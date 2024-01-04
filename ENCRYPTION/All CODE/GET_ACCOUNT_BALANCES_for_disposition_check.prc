create or replace FUNCTION GET_ACCOUNT_BALANCES_for_disposition_check
(
    p_start_date            IN      NUMBER,
    p_end_date              IN      NUMBER,
    p_account_number        IN      VARCHAR2 DEFAULT NULL,
    p_institution_id        IN      VARCHAR2,
    p_bal_type              IN      VARCHAR2,
    p_data_keyid_list       IN      VARCHAR2 DEFAULT NULL,
    p_data_key_list         IN      VARCHAR2 DEFAULT NULL
)
RETURN table_account_balances PIPELINED
AS
    out_rec            type_account_balances := type_account_balances(NULL,NULL,0,NULL);

    m_encrypt                           VARCHAR2(10)                                                    :='ENCRYPT';

    CURSOR c_accountbalance_recs
    (
        m_account_number ACCOUNT_MASTER.ACCOUNT_NUMBER%TYPE,
        m_Datakeyid      datakeystore.datakeyid%type
    )
    IS
    SELECT   ab.*
    FROM     ACCOUNT_BALANCE ab,
             ACCOUNT_MASTER am
    WHERE    (ab.account_number_enc = am.account_number_enc OR ab.account_number = am.account_number)
    AND      ab.INSTITUTION_ID = am.INSTITUTION_ID
    AND      (ab.ACCOUNT_NUMBER_ENC = encrypt_decrypt_basedon_session_cntx(m_encrypt,p_institution_id,m_account_number,m_datakeyid)
    OR        ab.ACCOUNT_NUMBER = m_account_number)
    AND      ab.INSTITUTION_ID  = p_institution_id
    AND      ENTRY_DATE BETWEEN TO_TIMESTAMP(TO_CHAR(to_DATE(p_start_date, 'YYYY-MM-DD'), 'YYYY-MM-DD') || ' 00:00:00.000', 'YYYY-MM-DD HH24:MI:SS.FF3') and TO_TIMESTAMP(TO_CHAR(to_DATE(p_end_date, 'YYYY-MM-DD'), 'YYYY-MM-DD') || ' 00:00:00.000', 'YYYY-MM-DD HH24:MI:SS.FF3')
    ORDER BY ab.ACCOUNT_NUMBER,ENTRY_DATE;

    TYPE t_account_balance IS TABLE OF ACCOUNT_BALANCE%ROWTYPE;
    a_account_records      t_account_balance   := t_account_balance();


    m_ctr_beg                           NUMBER                                                          := 0;
    m_ctr_end                           NUMBER                                                          := 0;
    m_ctr                               NUMBER                                                          := 0;
    m_sys_date                          DATE;
    m_start_date                        DATE;
    m_actual_start_date                 DATE;
    m_end_date                          DATE;
    m_after_sys_date                    DATE;
    m_unreconciled_start_date           DATE;
    m_provisional_balance               NUMBER                                                          := 0;
    m_loop_date                         TIMESTAMP                                                       :=NULL;
    m_sum_unreconciled_payments         NUMBER                                                          := 0;
    m_add_ctr_end                       NUMBER                                                          := 0;
    m_pipe_count                        NUMBER                                                          := 0;
    m_account_number                    ACCOUNT_MASTER.ACCOUNT_NUMBER%TYPE                              := NULL;
    m_account_iban                      ACCOUNT_MASTER.ACCOUNT_NUMBER%TYPE                              := NULL;
    m_accounts                          VARCHAR2(4000)                                                  := NULL;
    m_accounts_no                       VARCHAR2(4000)                                                  := NULL;
    m_sum_of_receivables                ACCOUNT_BALANCE.sum_of_receivables%TYPE                         := NULL;
    m_sum_of_unreconciled_payments      ACCOUNT_BALANCE.sum_of_unreconciled_payments%TYPE               := NULL;
    m_sum_unreconciled_receivables      ACCOUNT_BALANCE.sum_unreconciled_receivables%TYPE               := NULL;
    m_sum_of_payments                   ACCOUNT_BALANCE.sum_of_payments%TYPE                            := NULL;
    --m_sum_of_forecast_receivables       ACCOUNT_BALANCE.sum_of_forecast_receivables%TYPE                := NULL;
    --m_sum_of_forecast_payments          ACCOUNT_BALANCE.sum_of_forecast_payments%TYPE                   := NULL;
    --m_sum_forecast_payments             ACCOUNT_BALANCE.sum_of_forecast_payments%TYPE                   := NULL;
    m_stmt_closing_booked_balance       ACCOUNT_BALANCE.stmt_closing_booked_balance%TYPE                := NULL;
    m_count_days                        NUMBER                                                          := 0;
    m_closing_balance                   ACCOUNT_BALANCE.stmt_closing_booked_balance%TYPE                := NULL;
    m_count                             NUMBER                                                          :=0;
    m_loop_count                        NUMBER                                                          :=0;
    m_decrypt                           VARCHAR2(10)                                                    :='DECRYPT';
    m_context_name                      VARCHAR2(32664)                                                    :=NULL;
    m_tenant_list                       VARCHAR2(32664)                                                 := NULL;
    m_tenant                            VARCHAR2(32664)                                                 := NULL;
    m_datakeyid                         VARCHAR2(10)                                                    := NULL;
    --m_sum_forecast_receivables          ACCOUNT_BALANCE.sum_of_forecast_receivables%TYPE                := NULL;

    INVALID_DATES   EXCEPTION;
BEGIN

    plcn_security_pkg.fetch_data_key(p_data_keyid_list,p_data_key_list);

    DBMS_OUTPUT.PUT_LINE('IN BALANCE CHECK');
  --  DBMS_OUTPUT.PUT_LINE(m_tenant_list);

    BEGIN

        SELECT  NVL(paramvalue,'X')
        INTO    m_tenant
        FROM    institutionparameters
        WHERE   institutionid=p_institution_id
        AND     paramname='TENANT_NAME';

    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            m_tenant :='X';
    END;

              BEGIN

                  SELECT TDVALUE
                  INTO m_context_name
                  FROM TABLEDETAILS
                  WHERE TDIDCODE ='CONTEXT'
                  AND
                  TDKEY = m_tenant ;
                        DBMS_OUTPUT.put_line('m_context_name -->'||m_context_name);

              EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN

                       DBMS_OUTPUT.PUT_LINE ('No CONTEXT found ');
             END;


    m_tenant_list := sys_context(m_context_name,'ENCRYPTION_TENANT_LIST');
    m_datakeyid         := sys_context(m_context_name,'ACTIVE_DATAKEYID');

    m_accounts          := encrypt_decrypt_basedon_session_cntx(m_decrypt,p_institution_id,p_account_number,m_datakeyid);
   DBMS_OUTPUT.PUT_LINE( 'm_accounts' || m_accounts);

    m_sys_date          := TO_TIMESTAMP(TO_CHAR(sysdate ,'YYYY-MM-DD') || ' 00:00:00.000', 'YYYY-MM-DD HH24:MI:SS.FF3');
    m_start_date        := TO_TIMESTAMP(TO_CHAR(to_DATE(p_start_date, 'YYYY-MM-DD'), 'YYYY-MM-DD') || ' 00:00:00.000', 'YYYY-MM-DD HH24:MI:SS.FF3');
    m_end_date          := TO_TIMESTAMP(TO_CHAR(to_DATE(p_end_date, 'YYYY-MM-DD'), 'YYYY-MM-DD') || ' 00:00:00.000', 'YYYY-MM-DD HH24:MI:SS.FF3') ;
    m_tenant_list := sys_context(m_context_name,'ENCRYPTION_TENANT_LIST');
    --DBMS_OUTPUT.PUT_LINE('m_sys_date :='|| m_sys_date);
    --DBMS_OUTPUT.PUT_LINE('m_start_date :='|| m_start_date);
    --DBMS_OUTPUT.PUT_LINE('m_end_date :='|| m_end_date);

    IF m_start_date > m_end_date
    THEN
        --DBMS_OUTPUT.PUT_LINE('Please enter Valid DATES');
        RAISE INVALID_DATES;
         -- raise exception and return nothing
    END IF;

    SELECT DECODE(m_start_date, m_end_date, 0, (m_end_date - m_start_date))
    INTO m_count_days
    FROM DUAL;

    --DBMS_OUTPUT.PUT_LINE('m_count_days ; ' || m_count_days);

    IF m_accounts IS NULL
    THEN
        IF instr(m_tenant_list,m_tenant)>0
        THEN
            SELECT LISTAGG(encrypt_decrypt_basedon_session_cntx(m_decrypt,p_institution_id,ACCOUNT_NUMBER_ENC,m_datakeyid),',')
            WITHIN GROUP( ORDER BY ACCOUNT_NUMBER_ENC)
            INTO    m_accounts
            FROM    ACCOUNT_MASTER
            WHERE   institution_id = p_institution_id
            AND     account_status = 'VALIDATED';

            --DBMS_OUTPUT.PUT_LINE ('m_accounts_Enc ' || m_accounts);

        ELSE
            SELECT LISTAGG(ACCOUNT_NUMBER,',') WITHIN GROUP( ORDER BY ACCOUNT_NUMBER)
            INTO    m_accounts
            FROM    ACCOUNT_MASTER
            WHERE   institution_id = p_institution_id
            AND     account_status = 'VALIDATED';

        END IF;

        --DBMS_OUTPUT.PUT_LINE ('m_accounts_Enc 1 ' || m_accounts);

    END IF;

    IF SUBSTR(m_accounts,1,1) != ',' --to add input parameter
    THEN
        SELECT LENGTH(m_accounts)-LENGTH(REPLACE(m_accounts,',',''))
        INTO   m_pipe_count
        FROM   DUAL;
    END IF;

    m_pipe_count       := NVL(m_pipe_count, 0) + 1;
    --DBMS_OUTPUT.PUT_LINE('m_pipe_count : ' || m_pipe_count);

    FOR p IN 1..m_pipe_count
    LOOP
        m_start_date := TO_TIMESTAMP(TO_CHAR(to_DATE(p_start_date, 'YYYY-MM-DD'), 'YYYY-MM-DD') || ' 00:00:00.000', 'YYYY-MM-DD HH24:MI:SS.FF3');
        m_account_number := getstringitemwithsepformatch(m_accounts, p, ',');

        BEGIN
            SELECT  STMT_CLOSING_BOOKED_BALANCE
            INTO    m_provisional_balance
            FROM (
            SELECT  STMT_CLOSING_BOOKED_BALANCE
            FROM    ACCOUNT_BALANCE
            WHERE   (ACCOUNT_NUMBER_ENC = encrypt_decrypt_basedon_session_cntx(m_encrypt,p_institution_id,m_account_number,m_datakeyid)
            OR       ACCOUNT_NUMBER     = m_account_number
            )
            AND     INSTITUTION_ID  = p_institution_id

            ORDER BY ENTRY_DATE DESC)
            WHERE      ROWNUM <= 1;

        EXCEPTION
        WHEN NO_DATA_FOUND
        THEN

            FOR j IN 0..m_count_days
            LOOP

                --DBMS_OUTPUT.PUT_LINE('NO_DATA_FOUND');

                IF m_start_date < m_sys_date AND p_bal_type IN ('A', 'B')
                THEN
                    out_rec.account_number  := return_masked_info('PREFIX',p_institution_id,m_account_number);
                    out_rec.entry_date      := m_start_date;
                    out_rec.BALANCES        := 0;
                    out_rec.BALANCE_TYPE    := 'A';
                    PIPE ROW(out_rec);

                ELSIF m_start_date >= m_sys_date AND p_bal_type IN ('P', 'B')
                THEN
                    out_rec.account_number  := return_masked_info('PREFIX',p_institution_id,m_account_number);
                    out_rec.entry_date      := m_start_date;
                    out_rec.BALANCES        := 0;
                    out_rec.BALANCE_TYPE    := 'P';
                    PIPE ROW(out_rec);

                END IF;

                IF m_start_date = m_end_date
                THEN
                    EXIT;
                END IF;

                m_start_date := m_start_date +1;

            END LOOP;

            GOTO label2;

        END;

        --DBMS_OUTPUT.PUT_LINE('m_account_number : ' || m_account_number);

        OPEN c_accountbalance_recs(m_account_number,m_datakeyid);
        FETCH c_accountbalance_recs  BULK COLLECT INTO a_account_records;
        close c_accountbalance_recs;

        m_ctr_beg := NVL(a_account_records.FIRST,0);
        m_ctr_end := NVL(a_account_records.LAST,0);

        --DBMS_OUTPUT.PUT_LINE('m_ctr_end'|| m_ctr_end);


        IF m_start_date < m_sys_date
        THEN
            --DBMS_OUTPUT.PUT_LINE('Start date of past');

            IF m_end_date < m_sys_date AND p_bal_type IN ('A', 'B')
            THEN
                --DBMS_OUTPUT.PUT_LINE('Both past dates');
                --DBMS_OUTPUT.PUT_LINE('m_count_days : ' || m_count_days);

                FOR i IN 0..m_count_days
                LOOP

                    --DBMS_OUTPUT.PUT_LINE('m_start_date : ' || m_start_date);
                    --DBMS_OUTPUT.PUT_LINE('m_account_number : ' || m_account_number);
                    SELECT  count(*)
                    INTO    m_count
                    FROM    ACCOUNT_BALANCE
                    WHERE   (ACCOUNT_NUMBER_ENC = encrypt_decrypt_basedon_session_cntx(m_encrypt,p_institution_id,m_account_number,m_datakeyid)
                       OR ACCOUNT_NUMBER     = m_account_number
                            )
                    AND     INSTITUTION_ID  = p_institution_id
                    AND     trunc(ENTRY_DATE) = m_start_date;

                    --DBMS_OUTPUT.PUT_LINE('m_count : ' || m_count);

                    IF m_count = 0
                    THEN
                        --DBMS_OUTPUT.PUT_LINE('ZERO');
                        out_rec.account_number  := encrypt_decrypt_basedon_session_cntx(m_encrypt,p_institution_id,m_account_number,m_datakeyid);
                        out_rec.entry_date      := m_start_date;
                        out_rec.BALANCES        := 0;
                        out_rec.BALANCE_TYPE    := 'A';
                        PIPE ROW(out_rec);
                    ELSE
                        EXIT;
                    END IF;
                    m_start_date := m_start_date + 1;
                END LOOP;

                IF m_ctr_end > 0
                THEN
                    FOR m_ctr in m_ctr_beg..m_ctr_end
                    LOOP

                        out_rec.account_number := a_account_records(m_ctr).ACCOUNT_NUMBER;
                        out_rec.entry_date := a_account_records(m_ctr).ENTRY_DATE;
                        out_rec.BALANCES := NVL(a_account_records(m_ctr).stmt_closing_booked_balance, 0);
                        out_rec.BALANCE_TYPE := 'A';
                        PIPE ROW(out_rec);

                    END LOOP;
                END IF;
            ELSE
                --DBMS_OUTPUT.PUT_LINE('Start is past date and end is future date');

                FOR i IN 0..m_count_days
                LOOP
                    --DBMS_OUTPUT.PUT_LINE('i : ' || i);


                    SELECT  count(*)
                    INTO    m_count
                    FROM    ACCOUNT_BALANCE
                    WHERE   (ACCOUNT_NUMBER_ENC = encrypt_decrypt_basedon_session_cntx(m_encrypt,p_institution_id,m_account_number,m_datakeyid)
                       OR ACCOUNT_NUMBER     = m_account_number
                        )
                    AND     INSTITUTION_ID  = p_institution_id
                    AND     trunc(ENTRY_DATE) = m_start_date;

                    IF m_count = 0 AND m_start_date < m_sys_date
                    THEN
                        --DBMS_OUTPUT.PUT_LINE('ZERO');
                        out_rec.account_number  := return_masked_info('PREFIX',p_institution_id,m_account_number);
                        out_rec.entry_date      := m_start_date;
                        out_rec.BALANCES        := 0;
                        out_rec.BALANCE_TYPE    := 'A';
                        PIPE ROW(out_rec);
                        m_start_date := m_start_date + 1;
                    ELSE
                        m_loop_date := m_start_date;

                        IF m_start_date < m_sys_date
                        THEN
                            m_loop_date := m_loop_date -1;
                            FOR m_ctr in m_ctr_beg..m_ctr_end
                            LOOP
                                m_loop_date := m_loop_date + 1;

                               --DBMS_OUTPUT.PUT_LINE('LOOP m_loop_date :='|| m_loop_date);
                               --DBMS_OUTPUT.PUT_LINE('LOOP m_sys_date :='|| m_sys_date);
                               --DBMS_OUTPUT.PUT_LINE('m_ctr :='|| m_ctr);

                                IF m_loop_date < m_sys_date AND p_bal_type IN ('A', 'B')
                                THEN
                                    m_provisional_balance   := NVL(a_account_records(m_ctr).stmt_closing_booked_balance,0);

                                    --DBMS_OUTPUT.PUT_LINE('m_provisional_balance in if :='|| m_provisional_balance);

                                    out_rec.account_number := a_account_records(m_ctr).ACCOUNT_NUMBER;
                                    out_rec.entry_date      := a_account_records(m_ctr).ENTRY_DATE;
                                    out_rec.BALANCES        := NVL(a_account_records(m_ctr).stmt_closing_booked_balance, 0);
                                    out_rec.BALANCE_TYPE    := 'A';
                                    PIPE ROW(out_rec);


                                END IF;

                                IF m_loop_date =  m_sys_date-1
                                THEN

                                    --DBMS_OUTPUT.PUT_LINE('EXIT');
                                    m_start_date := m_loop_date+1;
                                    EXIT;

                                END IF;

                            END LOOP;

                            m_start_date := m_loop_date;

                        ELSE
                            --DBMS_OUTPUT.PUT_LINE('m_start_date : ' || m_start_date);
                            --DBMS_OUTPUT.PUT_LINE('m_sys_date : ' || m_sys_date);

                            IF m_start_date = m_sys_date
                            THEN

                                BEGIN
                                    SELECT STMT_CLOSING_BOOKED_BALANCE
                                    INTO m_provisional_balance
                                    FROM (
                                    SELECT  NVL(STMT_CLOSING_BOOKED_BALANCE, 0) STMT_CLOSING_BOOKED_BALANCE
                                    FROM    ACCOUNT_BALANCE
                                    WHERE   (ACCOUNT_NUMBER_ENC = encrypt_decrypt_basedon_session_cntx(m_encrypt,p_institution_id,m_account_number,m_datakeyid)
                                          OR ACCOUNT_NUMBER     = m_account_number)
                                    AND     INSTITUTION_ID  = p_institution_id
                                        AND     STMT_CLOSING_BOOKED_BALANCE IS NOT NULL
                                        AND TRUNC(ENTRY_DATE)  = m_sys_date
                                        ORDER BY ENTRY_DATE DESC)
                                    WHERE     ROWNUM <= 1
                                    ;
                                    --DBMS_OUTPUT.PUT_LINE ('m_provisional_balance--JJ '|| m_provisional_balance);
                                EXCEPTION
                                WHEN NO_DATA_FOUND
                                THEN
                                    m_provisional_balance := 0;
                                END;

                                BEGIN
                                    SELECT  SUM_OF_UNRECONCILED_PAYMENTS,
                                            --SUM_OF_FORECAST_PAYMENTS,
                                            --SUM_OF_FORECAST_RECEIVABLES,
                                            SUM_UNRECONCILED_RECEIVABLES
                                    INTO    m_sum_unreconciled_payments,
                                            --m_sum_of_forecast_payments,
                                            --m_sum_of_forecast_receivables,
                                            m_sum_unreconciled_receivables
                                    FROM    ACCOUNT_BALANCE
                                    WHERE   TRUNC(ACCOUNT_BALANCE.ENTRY_DATE) =  m_sys_date
                                    AND     (ACCOUNT_NUMBER_ENC = encrypt_decrypt_basedon_session_cntx(m_encrypt,p_institution_id,m_account_number,m_datakeyid)
                                    OR      ACCOUNT_NUMBER     = m_account_number

                                     )
                                    AND INSTITUTION_ID  = p_institution_id;
                                EXCEPTION
                                WHEN NO_DATA_FOUND
                                THEN
                                    m_sum_unreconciled_payments     := 0;
                                    --m_sum_of_forecast_payments      := 0;
                                    --m_sum_of_forecast_receivables   := 0;
                                    m_sum_unreconciled_receivables  := 0;
                                END;

                                --m_provisional_balance       := NVL(m_provisional_balance, 0) + NVL(m_sum_of_forecast_receivables, 0);
                                m_provisional_balance       := NVL(m_provisional_balance, 0) + NVL(m_sum_unreconciled_receivables, 0);
                                m_provisional_balance       := NVL(m_provisional_balance, 0) - NVL(m_sum_unreconciled_payments, 0);
                                --m_provisional_balance       := NVL(m_provisional_balance, 0) - NVL(m_sum_of_forecast_payments, 0);
                                m_unreconciled_start_date   := m_start_date-365;

                                BEGIN

                                    SELECT  SUM(SUM_OF_UNRECONCILED_PAYMENTS),
                                            --SUM(SUM_OF_FORECAST_PAYMENTS),
                                            --SUM(SUM_OF_FORECAST_RECEIVABLES),
                                            SUM(SUM_UNRECONCILED_RECEIVABLES)
                                    INTO    m_sum_unreconciled_payments,
                                            --m_sum_forecast_payments,
                                            --m_sum_forecast_receivables,
                                            m_sum_unreconciled_receivables
                                    FROM    ACCOUNT_BALANCE
                                    WHERE   ACCOUNT_BALANCE.ENTRY_DATE  between m_unreconciled_start_date and m_sys_date-1
                                    AND     ACCOUNT_NUMBER = m_account_number
                                    AND     INSTITUTION_ID  = p_institution_id;

                                    --DBMS_OUTPUT.PUT_LINE('begin m_sum_unreconciled_payments :='|| m_sum_unreconciled_payments);
                                    ----DBMS_OUTPUT.PUT_LINE('begin m_sum_forecast_payments :='|| m_sum_forecast_payments);
                                    ----DBMS_OUTPUT.PUT_LINE('begin m_sum_forecast_receivables :='|| m_sum_forecast_receivables);
                                    --DBMS_OUTPUT.PUT_LINE('begin m_sum_unreconciled_receivables :='|| m_sum_unreconciled_receivables);

                                EXCEPTION
                                    WHEN NO_DATA_FOUND
                                    THEN
                                        m_sum_unreconciled_payments     := 0;
                                        --m_sum_forecast_payments         := 0;
                                        m_sum_unreconciled_receivables  := 0;
                                        --m_sum_forecast_receivables      := 0;
                                END;

                                --m_provisional_balance :=    nvl(m_provisional_balance,0) +  NVL(m_sum_forecast_receivables, 0);
                                m_provisional_balance :=    nvl(m_provisional_balance,0) +  NVL(m_sum_unreconciled_receivables, 0);

                                m_provisional_balance :=    nvl(m_provisional_balance,0) -  NVL(m_sum_unreconciled_payments, 0);
                                --m_provisional_balance :=    nvl(m_provisional_balance,0) -  NVL(m_sum_forecast_payments, 0);

                                --DBMS_OUTPUT.PUT_LINE('m_sys_date m_provisional_balance : ' || m_provisional_balance);

                                IF instr(m_tenant_list,m_tenant)>0
                                THEN
                                    out_rec.account_number := return_masked_info('PREFIX',p_institution_id,m_account_number);
                                ELSE
                                    out_rec.account_number := m_account_number;
                                END IF;

                                out_rec.entry_date      := m_sys_date;
                                out_rec.BALANCES        := NVL(m_provisional_balance, 0);
                                out_rec.BALANCE_TYPE    := 'P';
                                PIPE ROW(out_rec);

                                GOTO label3;

                            END IF;


                            BEGIN
                                SELECT  SUM_OF_RECEIVABLES,
                                        SUM_OF_UNRECONCILED_PAYMENTS,
                                        SUM_UNRECONCILED_RECEIVABLES,
                                        SUM_OF_PAYMENTS
                                        --SUM_OF_FORECAST_RECEIVABLES,
                                        --SUM_OF_FORECAST_PAYMENTS
                                INTO    m_sum_of_receivables,
                                        m_sum_of_unreconciled_payments,
                                        m_sum_unreconciled_receivables,
                                        m_sum_of_payments
                                        --m_sum_of_forecast_receivables,
                                        --m_sum_of_forecast_payments
                                FROM ACCOUNT_BALANCE
                                WHERE (ACCOUNT_NUMBER_ENC = encrypt_decrypt_basedon_session_cntx(m_encrypt,p_institution_id,m_account_number,m_datakeyid)
                                     OR ACCOUNT_NUMBER     = m_account_number
                                     )
                                AND institution_id = p_institution_id
                                AND entry_date  = m_start_date;

                            EXCEPTION
                            WHEN NO_DATA_FOUND
                            THEN
                                m_sum_of_receivables := 0;
                                m_sum_of_unreconciled_payments := 0;
                                m_sum_unreconciled_receivables := 0;
                                m_sum_of_payments := 0;
                                --m_sum_of_forecast_receivables := 0;
                                --m_sum_of_forecast_payments := 0;
                            END;

                            ----DBMS_OUTPUT.PUT_LINE('SUM_OF_FORECAST_RECEIVABLES :='|| m_sum_of_forecast_receivables);

                            --m_provisional_balance := NVL(m_provisional_balance, 0) + NVL(m_sum_of_forecast_receivables, 0);
                            --m_provisional_balance := NVL(m_provisional_balance, 0) - NVL(m_sum_of_forecast_payments, 0);

                            m_unreconciled_start_date := m_start_date-365;

                            IF m_after_sys_date = m_sys_date+1
                            THEN
                                BEGIN
                                    SELECT  SUM(SUM_OF_UNRECONCILED_PAYMENTS),
                                            --SUM(SUM_OF_FORECAST_PAYMENTS),
                                            SUM(SUM_UNRECONCILED_RECEIVABLES)
                                            --SUM(SUM_OF_FORECAST_RECEIVABLES)
                                    INTO    m_sum_unreconciled_payments,
                                            --m_sum_forecast_payments,
                                            m_sum_unreconciled_receivables
                                            --m_sum_of_forecast_receivables
                                    FROM    ACCOUNT_BALANCE
                                    WHERE   ACCOUNT_BALANCE.ENTRY_DATE  between m_unreconciled_start_date and m_sys_date
                                    AND     (ACCOUNT_NUMBER_ENC = encrypt_decrypt_basedon_session_cntx(m_encrypt,p_institution_id,m_account_number,m_datakeyid)
                                            OR ACCOUNT_NUMBER     = m_account_number)
                                    AND     INSTITUTION_ID  = p_institution_id;

                                    --DBMS_OUTPUT.PUT_LINE('begin m_sum_unreconciled_payments:='|| m_sum_unreconciled_payments);
                                    m_after_sys_date:=m_after_sys_date+1;

                                EXCEPTION
                                    WHEN NO_DATA_FOUND
                                    THEN
                                        m_sum_unreconciled_payments     := 0;
                                        --m_sum_forecast_payments         := 0;
                                        m_sum_unreconciled_receivables  := 0;
                                        --m_sum_of_forecast_receivables   := 0;
                                END;

                                m_provisional_balance :=    nvl(m_provisional_balance,0) +  NVL(m_sum_unreconciled_receivables, 0);
                                --m_provisional_balance :=    nvl(m_provisional_balance,0) +  NVL(m_sum_of_forecast_receivables, 0);                                

                                m_provisional_balance :=    nvl(m_provisional_balance,0) -  NVL(m_sum_unreconciled_payments, 0);
                                --m_provisional_balance :=    nvl(m_provisional_balance,0) -  NVL(m_sum_forecast_payments, 0);

                            END IF;

                            m_provisional_balance   := NVL(m_provisional_balance, 0) - NVL(m_sum_unreconciled_receivables, 0);
                            m_provisional_balance   := NVL(m_provisional_balance, 0) - NVL(m_sum_of_unreconciled_payments, 0);


                            --DBMS_OUTPUT.PUT_LINE('m_provisional_balance :='|| m_provisional_balance);

                            IF instr(m_tenant_list,m_tenant)>0
                            THEN
                                out_rec.account_number := return_masked_info('PREFIX',p_institution_id,m_account_number);
                            ELSE
                                out_rec.account_number := m_account_number;
                            END IF;

                            SELECT  m_start_date
                            INTO    out_rec.entry_date
                            FROM    DUAL;

                            out_rec.BALANCES        := NVL(m_provisional_balance,0);
                            out_rec.BALANCE_TYPE    := 'P';
                            PIPE ROW(out_rec);

                        END IF;

                        <<label3>>
                        m_start_date := m_start_date + 1;

                    END IF;

                    IF m_start_date > m_end_date
                    THEN
                        EXIT;
                    END IF;

                END LOOP;

            END IF;
        ----------------------------------
        ELSIF m_start_date=m_end_date
        THEN
            BEGIN
                SELECT  STMT_CLOSING_BOOKED_BALANCE
                INTO    m_provisional_balance
                FROM    (
                            SELECT  NVL(STMT_CLOSING_BOOKED_BALANCE, 0) STMT_CLOSING_BOOKED_BALANCE
                            FROM    ACCOUNT_BALANCE
                            WHERE   (ACCOUNT_NUMBER_ENC = encrypt_decrypt_basedon_session_cntx(m_encrypt,p_institution_id,m_account_number,m_datakeyid)
                                     OR ACCOUNT_NUMBER     = m_account_number)
                            AND     INSTITUTION_ID  = p_institution_id
                            AND     STMT_CLOSING_BOOKED_BALANCE IS NOT NULL
                            ORDER BY ENTRY_DATE DESC
                        )
                WHERE   ROWNUM <= 1
                    ;
                --DBMS_OUTPUT.PUT_LINE ('m_provisional_balance  '|| m_provisional_balance);
            EXCEPTION
                WHEN NO_DATA_FOUND
                THEN
                    m_provisional_balance := 0;
            END;

            --DBMS_OUTPUT.PUT_LINE ('m_provisional_balance--BB '|| m_provisional_balance);
            m_loop_count := m_end_date - m_sys_date;
            m_start_date := m_sys_date;

            FOR m_ctr IN 0..m_loop_count
            LOOP

                BEGIN
                    SELECT  SUM_OF_RECEIVABLES,
                            SUM_OF_UNRECONCILED_PAYMENTS,
                            SUM_UNRECONCILED_RECEIVABLES,
                            SUM_OF_PAYMENTS
                            --SUM_OF_FORECAST_RECEIVABLES,
                            --SUM_OF_FORECAST_PAYMENTS
                    INTO    m_sum_of_receivables,
                            m_sum_of_unreconciled_payments,
                            m_sum_unreconciled_receivables,
                            m_sum_of_payments
                            --m_sum_of_forecast_receivables,
                            --m_sum_of_forecast_payments
                    FROM ACCOUNT_BALANCE
                    WHERE (ACCOUNT_NUMBER_ENC = encrypt_decrypt_basedon_session_cntx(m_encrypt,p_institution_id,m_account_number,m_datakeyid)
                        OR ACCOUNT_NUMBER     = m_account_number
                            )
                    AND institution_id = p_institution_id
                    AND TRUNC(ENTRY_DATE)  = DECODE(m_ctr, 0,m_start_date, m_start_date+m_ctr);

                EXCEPTION
                WHEN NO_DATA_FOUND
                THEN
                    m_sum_of_receivables            := 0;
                    m_sum_of_unreconciled_payments  := 0;
                    m_sum_unreconciled_receivables  := 0;
                    m_sum_of_payments               := 0;
                    --m_sum_of_forecast_receivables   := 0;
                    --m_sum_of_forecast_payments      := 0;
                END;

                ----DBMS_OUTPUT.PUT_LINE('SUM_OF_FORECAST_RECEIVABLES :='|| m_sum_of_forecast_receivables);
                ----DBMS_OUTPUT.PUT_LINE('m_sum_of_forecast_payments :='|| m_sum_of_forecast_payments);

                --m_provisional_balance := NVL(m_provisional_balance, 0) + NVL(m_sum_of_forecast_receivables, 0);
                m_provisional_balance := NVL(m_provisional_balance, 0) + NVL(m_sum_unreconciled_receivables, 0);
                --m_provisional_balance := NVL(m_provisional_balance, 0) - NVL(m_sum_of_forecast_payments, 0);
                m_provisional_balance := NVL(m_provisional_balance, 0) - NVL(m_sum_of_unreconciled_payments, 0);

                --DBMS_OUTPUT.PUT_LINE('m_provisional_balance :='|| m_provisional_balance);
                --DBMS_OUTPUT.PUT_LINE('m_end_date :='|| m_end_date);
                --DBMS_OUTPUT.PUT_LINE('m_start_date :='|| m_start_date);

                m_unreconciled_start_date := m_start_date-365;

                IF m_ctr = 0
                THEN
                    BEGIN
                        SELECT  SUM(SUM_OF_UNRECONCILED_PAYMENTS),
                                --SUM(SUM_OF_FORECAST_PAYMENTS),
                                --SUM(SUM_OF_FORECAST_RECEIVABLES),
                                SUM(SUM_UNRECONCILED_RECEIVABLES)
                        INTO    m_sum_unreconciled_payments,
                                --m_sum_forecast_payments,
                                --m_sum_of_forecast_receivables,
                                m_sum_unreconciled_receivables
                        FROM    ACCOUNT_BALANCE
                        WHERE   ACCOUNT_BALANCE.ENTRY_DATE  between m_unreconciled_start_date and m_sys_date-1
                        AND     ACCOUNT_NUMBER  = m_account_number
                        AND     INSTITUTION_ID  = p_institution_id;

                        --DBMS_OUTPUT.PUT_LINE('begin m_sum_unreconciled_payments:='|| m_sum_unreconciled_payments);
                        ----DBMS_OUTPUT.PUT_LINE('begin m_sum_forecast_payments:='|| m_sum_forecast_payments);
                        ----DBMS_OUTPUT.PUT_LINE('begin m_sum_of_forecast_receivables:='|| m_sum_of_forecast_receivables);
                        --DBMS_OUTPUT.PUT_LINE('begin m_sum_unreconciled_receivables:='|| m_sum_unreconciled_receivables);

                    EXCEPTION
                        WHEN NO_DATA_FOUND
                        THEN
                            m_sum_unreconciled_payments     := 0;
                            --m_sum_forecast_payments         := 0;
                            --m_sum_of_forecast_receivables   := 0;
                            m_sum_unreconciled_receivables  := 0;
                    END;

                    m_provisional_balance :=    nvl(m_provisional_balance,0) -  NVL(m_sum_unreconciled_payments, 0);
                    --m_provisional_balance :=    nvl(m_provisional_balance,0) -  NVL(m_sum_forecast_payments, 0);

                    --m_provisional_balance :=    nvl(m_provisional_balance,0) +  NVL(m_sum_of_forecast_receivables, 0);
                    m_provisional_balance :=    nvl(m_provisional_balance,0) +  NVL(m_sum_unreconciled_receivables, 0);

                END IF;

                IF m_ctr = m_loop_count
                THEN

                    IF instr(m_tenant_list,m_tenant)>0
                    THEN
                        out_rec.account_number := return_masked_info('PREFIX',p_institution_id,m_account_number);
                    ELSE
                        out_rec.account_number := m_account_number;
                    END IF;

                    out_rec.entry_date      := m_end_date;
                    out_rec.BALANCES        := NVL(m_provisional_balance,0);
                    out_rec.BALANCE_TYPE    := 'P';
                    PIPE ROW(out_rec);
                    EXIT;

                END IF;

            END LOOP;

        --------------------
        ELSE
            --DBMS_OUTPUT.PUT_LINE('m_start_date ekse : ' || m_start_date);

            IF m_start_date = m_sys_date
            THEN
                BEGIN

                    SELECT STMT_CLOSING_BOOKED_BALANCE
                    INTO m_provisional_balance
                    FROM (
                    SELECT  NVL(STMT_CLOSING_BOOKED_BALANCE, 0) STMT_CLOSING_BOOKED_BALANCE
                    FROM    ACCOUNT_BALANCE
                    WHERE   (ACCOUNT_NUMBER_ENC = encrypt_decrypt_basedon_session_cntx(m_encrypt,p_institution_id,m_account_number,m_datakeyid)
                    OR       ACCOUNT_NUMBER     = m_account_number
                    )
                    AND     INSTITUTION_ID  = p_institution_id
                    AND     STMT_CLOSING_BOOKED_BALANCE IS NOT NULL
                    ORDER BY ENTRY_DATE DESC)
                    WHERE     ROWNUM <= 1;

                EXCEPTION
                    WHEN NO_DATA_FOUND
                    THEN
                        m_provisional_balance := 0;
                END;

            ELSE

                BEGIN

                    SELECT STMT_CLOSING_BOOKED_BALANCE
                    INTO m_provisional_balance
                    FROM (
                    SELECT  NVL(STMT_CLOSING_BOOKED_BALANCE, 0) STMT_CLOSING_BOOKED_BALANCE
                    FROM    ACCOUNT_BALANCE
                    WHERE   (ACCOUNT_NUMBER_ENC = encrypt_decrypt_basedon_session_cntx(m_encrypt,p_institution_id,m_account_number,m_datakeyid)
                    OR       ACCOUNT_NUMBER     = m_account_number
                    )
                    AND     INSTITUTION_ID  = p_institution_id
                    ORDER BY ENTRY_DATE DESC)
                    WHERE     ROWNUM <= 1;

                    --DBMS_OUTPUT.PUT_LINE('m_provisional_balance ekse1 : ' || m_provisional_balance);

                EXCEPTION
                    WHEN NO_DATA_FOUND
                    THEN
                        m_provisional_balance := 0;
                END;

            END IF;

            m_after_sys_date := m_start_date;

            --DBMS_OUTPUT.PUT_LINE('m_provisional_balance : ' || m_provisional_balance);
            --DBMS_OUTPUT.PUT_LINE('Start and End date is future date');

            FOR m_ctr IN 0..m_count_days
            LOOP
                --DBMS_OUTPUT.PUT_LINE('m_ctr : ' || m_ctr);

                IF m_ctr > m_count_days
                THEN
                    --DBMS_OUTPUT.PUT_LINE('EXIT');
                    EXIT;
                END IF;

                --DBMS_OUTPUT.PUT_LINE('NO EXIT');

                BEGIN
                    SELECT  SUM_OF_RECEIVABLES,
                            SUM_OF_UNRECONCILED_PAYMENTS,
                            SUM_UNRECONCILED_RECEIVABLES,
                            SUM_OF_PAYMENTS
                            --SUM_OF_FORECAST_RECEIVABLES,
                            --SUM_OF_FORECAST_PAYMENTS
                    INTO    m_sum_of_receivables,
                            m_sum_of_unreconciled_payments,
                            m_sum_unreconciled_receivables,
                            m_sum_of_payments
                            --m_sum_of_forecast_receivables,
                            --m_sum_of_forecast_payments
                    FROM ACCOUNT_BALANCE
                    WHERE (ACCOUNT_NUMBER_ENC = encrypt_decrypt_basedon_session_cntx(m_encrypt,p_institution_id,m_account_number,m_datakeyid)
                    OR ACCOUNT_NUMBER     = m_account_number
                    )
                    AND institution_id = p_institution_id
                    AND TRUNC(ENTRY_DATE)  = DECODE(m_ctr, 0,m_start_date, m_start_date+m_ctr);

                EXCEPTION
                    WHEN NO_DATA_FOUND
                    THEN
                        m_sum_of_receivables := 0;
                        m_sum_of_unreconciled_payments := 0;
                        m_sum_unreconciled_receivables := 0;
                        m_sum_of_payments := 0;
                        --m_sum_of_forecast_receivables := 0;
                        --m_sum_of_forecast_payments := 0;
                END;

                ----DBMS_OUTPUT.PUT_LINE('SUM_OF_FORECAST_RECEIVABLES :='|| m_sum_of_forecast_receivables);

                m_provisional_balance   := NVL(m_provisional_balance, 0) + NVL(m_sum_unreconciled_receivables, 0);
                --m_provisional_balance   := NVL(m_provisional_balance, 0) + NVL(m_sum_of_forecast_receivables, 0);
                --m_provisional_balance   := NVL(m_provisional_balance, 0) - NVL(m_sum_of_forecast_payments, 0);
                m_provisional_balance   := NVL(m_provisional_balance, 0) - NVL(m_sum_of_unreconciled_payments, 0);

                m_unreconciled_start_date := m_start_date-365;

                IF m_ctr = 0
                THEN
                    BEGIN
                        SELECT  SUM(sum_of_unreconciled_payments),
                                --SUM(sum_of_forecast_payments),
                                SUM(sum_unreconciled_receivables)
                                --SUM(sum_of_forecast_receivables)
                        INTO    m_sum_unreconciled_payments,
                                --m_sum_forecast_payments,
                                m_sum_unreconciled_receivables
                                --m_sum_of_forecast_receivables
                        FROM    ACCOUNT_BALANCE
                        WHERE   ACCOUNT_BALANCE.ENTRY_DATE  between m_unreconciled_start_date and m_sys_date-1
                        AND     (ACCOUNT_NUMBER_ENC = encrypt_decrypt_basedon_session_cntx(m_encrypt,p_institution_id,m_account_number,m_datakeyid)
                        OR      ACCOUNT_NUMBER     = m_account_number)
                        AND     INSTITUTION_ID  = p_institution_id;

                        --DBMS_OUTPUT.PUT_LINE('begin m_sum_unreconciled_payments:='|| m_sum_unreconciled_payments);

                    EXCEPTION
                        WHEN NO_DATA_FOUND
                        THEN
                            m_sum_unreconciled_payments := 0;
                    END;

                    m_provisional_balance :=    nvl(m_provisional_balance,0) +  NVL(m_sum_unreconciled_receivables, 0);
                    --m_provisional_balance :=    nvl(m_provisional_balance,0) +  NVL(m_sum_of_forecast_receivables, 0);

                    m_provisional_balance :=    nvl(m_provisional_balance,0) -  NVL(m_sum_unreconciled_payments, 0);
                    --m_provisional_balance :=    nvl(m_provisional_balance,0) -  NVL(m_sum_forecast_payments, 0);

                END IF;

               --DBMS_OUTPUT.PUT_LINE('m_provisional_balance :='|| m_provisional_balance);

                IF instr(m_tenant_list,m_tenant)>0
                THEN
                    out_rec.account_number := return_masked_info('PREFIX',p_institution_id,m_account_number);
                ELSE
                    out_rec.account_number := m_account_number;
                END IF;

                SELECT DECODE(m_ctr, 0,m_start_date, m_start_date+m_ctr)
                INTO out_rec.entry_date
                FROM DUAL;

                out_rec.BALANCES        := NVL(m_provisional_balance,0);
                out_rec.BALANCE_TYPE    := 'P';
                PIPE ROW(out_rec);

                <<label1>>
                NULL;

            END LOOP;

        END IF;
              <<label2>>
              NULL;
    END LOOP;

EXCEPTION
WHEN INVALID_DATES
THEN
    NULL;
    --DBMS_OUTPUT.PUT_LINE('INVALID_DATES');
WHEN OTHERS
THEN
    --DBMS_OUTPUT.PUT_LINE('OTHERS : ' || SQLCODE || SQLERRM || dbms_utility.format_error_backtrace)    ;
    NULL;
END;