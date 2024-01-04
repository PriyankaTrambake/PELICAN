create or replace PROCEDURE          transaction_queue_routing
(
p_institutionid      IN MSGDB.institutionid%TYPE,
p_msgdb_id       IN MSGDB.msgdb_id%TYPE,
p_user_action_flag   IN CHAR,
p_stachemmessageflag IN MSGDB.stachemmessageflag%TYPE,
p_userid             IN UUSER.userid%TYPE,
p_queueid            IN MSGDB.queueid%TYPE,
p_status             IN MSGDB.status%TYPE,
p_commit_flag        IN CHAR,
p_return_code        IN OUT NUMBER
)
AS

    m_messageno_btch                    msgdb.messageno%TYPE                    := NULL;

    m_status_available                  msgdb.status%tYPE                       := 69;

    m_institutionid                     msgdb.institutionid%TYPE                := NULL;

    m_td_value                          tabledetails.tdvalue%TYPE               := NULL;
    m_target_queueid_status             VARCHAR2(1000)                          := NULL;

    m_queueid                           msgdb.queueid%TYPE                      := NULL;

    g_queueid                           genaudit.queueID%TYPE                   := NULL;
    g_modulename                        genaudit.modulename%TYPE                := 'RECORD';
    g_application                       genaudit.modulename%TYPE                := 'PELICAN';
    g_action                            genaudit.action%TYPE                    := 'UPDATE';
    g_audittext                         genaudit.audittext%TYPE                 := NULL;
    g_messageno                         genaudit.messageno%TYPE                 := NULL;
    m_status                            VARCHAR2(100)                           := NULL;
    m_count                             NUMBER                                  := 0;
    m_tdvalue                           TABLEDETAILS.TDVALUE%TYPE               := NULL;
    m_target_queueid                    msgdb.queueid%TYPE                      := NULL;
    m_target_status                     msgdb.status%TYPE                       := NULL;
    m_action                            TABLEDETAILS.TDVALUE%TYPE               := NULL;
    m_messageclasstype                  MSGDB.messageclasstype% TYPE            := NULL;
    m_messagedirection                  MSGDB.messagedirection% TYPE            := NULL;
    m_transactiongroup                  MSGDB.transactiongroup% TYPE            := NULL;
    m_transactiontype                   MSGDB.transactiontype% TYPE             := NULL;
    m_msg_family                        MSGDB.transactiontype% TYPE             := NULL;
    m_pipe_count                        NUMBER                                  := 0;
    m_column_name                       TABLEDETAILS.TDVALUE%TYPE               := NULL;
    m_first_query_part                  VARCHAR2(32000)                         := NULL;
    m_middle_part                       VARCHAR2(32000)                         := NULL;
    m_where_part                        VARCHAR2(32000)                         := NULL;
    m_execute_statement                 VARCHAR2(32000)                         := NULL;
    m_insert                            VARCHAR2(32000)                         := NULL;
    m_priorityamountnum                 MSGDB.PRIORITYAMOUNTNUM%TYPE            := NULL;
    m_prioritydate                      msgdb.prioritydate%TYPE                 := NULL;
    m_account_number                    msgdb.ACCOUNT_NUMBER%TYPE               := NULL;
    m_entrydate                         account_balance.entry_date%TYPE         := NULL;
    m_messageno_trans                   msgdb.messageno%TYPE                    := NULL;
    m_src_status                        msgdb.status%TYPE                       := NULL;
    m_statement_closed_book_bal         NUMBER                                    := 0;
    m_messageno                         msgdb.messageno%type                    := NULL;
    m_user_action_flag                  VARCHAR2(1 CHAR)                        := NULL;
    m_sysdate                           account_balance.entry_date%TYPE         := NULL;
    m_msg_prioritydate                  account_balance.entry_date%TYPE         := NULL;
    m_prev_date                         account_balance.entry_date%TYPE         := NULL;
    m_bank_code                         account_balance.bank_code%TYPE          := NULL;
    m_datakeyid                         msgdb.datakeyid%TYPE                    := NULL;
    m_account_number_enc                msgdb.account_number_enc%TYPE           := NULL;
    m_tenant_list                       VARCHAR2(30)                            := NULL;
    m_tenant                            INSTITUTIONPARAMETERS.PARAMNAME%TYPE    := NULL;  
    m_tdkey                             TABLEDETAILS.TDKEY%TYPE                 := NULL;
    m_context_name                      VARCHAR2(32664)                         := NULL;
    TRAN_IN_INTERMEDIATE_STATUS         EXCEPTION;
    NO_CONFIGURATION_FOUND              EXCEPTION;
    TRAN_IN_INTERMEDIATE_QUEUE          EXCEPTION;

    m_entry_timestamp_beg               TIMESTAMP;
    m_entry_timestamp_end               TIMESTAMP;
    m_txn_count                         NUMBER;
    m_update                            VARCHAR2(200)                           := NULL;

    m_prev_timestamp_beg                TIMESTAMP;
    m_prev_timestamp_end                TIMESTAMP;

    m_balance_subscription              INSTITUTIONPARAMETERS.PARAMVALUE%TYPE   := NULL;
    NOT_SUBSCRIBED                      EXCEPTION;
    m_CUSTOMERACCNO                     MSGDB.CUSTOMERACCNO%TYPE                      :=NULL;
    m_CUSTOMERACCNO_enc                     MSGDB.CUSTOMERACCNO_ENC%TYPE                      :=NULL;
    m_columnconfig_tdvalue                           TABLEDETAILS.TDVALUE%TYPE               := NULL;
    m_tdkey_temp                          TABLEDETAILS.TDVALUE%TYPE                         := NULL;
    m_CUSTOMERACCNO_valid                      VARCHAR2 (50 Byte)                     :='YES';

BEGIN

    m_balance_subscription    := NVL(UPPER(Get_Institution_Param_Value(p_institutionid ,'BALANCE_MANAGEMENT','CALCULATE_BALANCE_FROM_STATEMENT')), 'NO');

    IF m_balance_subscription IN ('NO', 'N')
    THEN
        RAISE NOT_SUBSCRIBED;
    END IF;

    m_tenant     := get_institution_param_value(p_institutionid,'INSTITUTION_DETAILS','TENANT_NAME');--NVL(GET_TENANTNAME(p_institutionid),'X');
    m_columnconfig_tdvalue    := NVL(TD_GET_VALUE(m_tenant,'ACCOUNT_REF'),'XX');

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
    IF m_columnconfig_tdvalue = 'NOSTRO_ACCOUNT_NUMBER'
    THEN
       SELECT am.account_number,
               am.bank_code,
               priorityamountnum,
               messageno,
               institutionid,
               prioritydate,
               status,
               messageno,
               m.datakeyid,
               am.account_number_enc,
               UPPER(REPLACE(SUBSTR(m.messageclasstype,1,8),'.',''))||'|'||m.messagedirection||'|'||m_tenant||'|'||m.transactiongroup||'|'||m.transactiontype||'|'||m.msg_family   as tdkey
        INTO   m_account_number,
               m_bank_code,
               m_priorityamountnum,
               m_messageno_trans,
               m_institutionid,
               m_prioritydate,
               m_src_status,
               m_messageno,
               m_datakeyid,
               m_account_number_enc,
               m_tdkey
        FROM    msgdb m,
                account_master am
        WHERE (m.nostro_account_number = am.account_number_enc
       OR m.nostro_account_number = am.account_number
        OR m.nostro_account_number =am.account_iban_enc
        OR m.nostro_account_number =am.account_iban
       )
        AND am.institution_id =m.institutionid
        AND am.ACCOUNT_STATUS='VALIDATED'
        AND msgdb_id = p_msgdb_id
        FOR UPDATE NOWAIT;

    ELSE
        SELECT am.account_number,
               am.bank_code,
               priorityamountnum,
               messageno,
               institutionid,
               prioritydate,
               status,
               messageno,
               m.datakeyid,
               am.account_number_enc,
               UPPER(REPLACE(SUBSTR(m.messageclasstype,1,8),'.',''))||'|'||m.messagedirection||'|'||m_tenant||'|'||m.transactiongroup||'|'||m.transactiontype||'|'||m.msg_family   as tdkey
        INTO   m_account_number,
                m_bank_code,
               m_priorityamountnum,
               m_messageno_trans,
               m_institutionid,
               m_prioritydate,
               m_src_status,
               m_messageno,
               m_datakeyid,
               m_account_number_enc,
               m_tdkey
        FROM    msgdb m,
                account_master am
        WHERE (m.customeraccno_enc = am.account_number_enc
        OR m.customeraccno_enc =am.account_iban_enc
        OR m.customeraccno =am.account_number
        OR m.sender || m.customeraccno = am.account_number
        OR m.customeraccno =am.account_iban)
        AND am.institution_id =m.institutionid
        AND am.ACCOUNT_STATUS='VALIDATED'
        AND msgdb_id = p_msgdb_id
        FOR UPDATE NOWAIT;

    END IF;
    
    
    DBMS_OUTPUT.put_line('m_account_number : ' || m_account_number);
    DBMS_OUTPUT.put_line('m_account_number_enc : ' || m_account_number_enc);

    IF p_user_action_flag = 'M'
    THEN
        m_tdkey := m_tdkey||'|M';
    END IF;
    DBMS_OUTPUT.put_line('m_tdkey : '||m_tdkey);
    m_tdkey_temp    := TD_GET_VALUE(m_tenant,m_tdkey);
    select trim(p_user_action_flag) into m_user_action_flag from dual;

    DBMS_OUTPUT.put_line('m_tdvalue : '||m_tdvalue);
     BEGIN
            SELECT am.account_number,am.account_number_enc
            INTO m_CUSTOMERACCNO,m_CUSTOMERACCNO_enc
            FROM account_master am , msgdb m
            WHERE (m.CUSTOMERACCNO = am.account_number
            OR m.CUSTOMERACCNO =am.account_iban
            OR m.customeraccno_enc =am.account_number_enc
            OR m.customeraccno_enc =am.account_iban_enc)
            AND am.institution_id =m.institutionid
            AND am.ACCOUNT_STATUS='VALIDATED'
            AND m.MSGDB_ID = p_msgdb_id;

    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
         m_CUSTOMERACCNO_valid := 'NO';
         
    END;
    
    DBMS_OUTPUT.put_line('m_CUSTOMERACCNO : ' || m_CUSTOMERACCNO);
    DBMS_OUTPUT.put_line('m_CUSTOMERACCNO_enc : ' || m_CUSTOMERACCNO_enc);
    
    FOR K IN 1..2
    LOOP

            IF m_tdkey_temp IS NULL
    THEN
        m_target_queueid_status := td_get_value('QUEUEID_CONFIG', p_queueid||'-'||m_src_status||'-'||m_user_action_flag);

            ELSIF  p_user_action_flag != 'M'  AND m_tdkey_temp IS NOT NULL
            THEN
                m_target_queueid_status := td_get_value(m_tenant, p_queueid||'-'||m_src_status||'-'||m_user_action_flag||'|'||m_tdkey_temp);
    ELSE
        m_target_queueid_status := td_get_value(m_tenant,m_tdvalue);
    END IF;
        DBMS_OUTPUT.put_line('m_target_queueid_status : '||m_target_queueid_status);
        DBMS_OUTPUT.put_line('m_tdvalue1 : '||m_tdvalue);
    m_tdvalue               := GETSTRINGITEMWITHSEPFORMATCH(m_target_queueid_status,2,',');
    m_update                := getstringitemwithsep(m_target_queueid_status,1,',');
        DBMS_OUTPUT.put_line('m_tdvalue2 : '||m_tdvalue);
        DBMS_OUTPUT.put_line('m_update : '||m_update);


    IF m_update IS NOT NULL AND m_update != 'XX' and m_update <> m_target_queueid_status
    THEN
        m_target_queueid        := getstringitemwithsep(getstringitemwithsep(m_target_queueid_status,1,','), 1, '-');
        m_target_status         := getstringitemwithsep(getstringitemwithsep(m_target_queueid_status,1,','), 2, '-');
    END IF;

        DBMS_OUTPUT.put_line('p_queueid : ' || p_queueid);
            DBMS_OUTPUT.put_line('p_status : ' || p_status);
            DBMS_OUTPUT.put_line('m_target_queueid : ' || m_target_queueid);
        DBMS_OUTPUT.put_line('m_target_status : ' || m_target_status);

            IF K = 1 AND (m_target_queueid IS NOT NULL OR m_target_status IS NOT NULL)
            THEN
                UPDATE msgdb
                SET    queueid            = m_target_queueid,
                       processing_stage      = get_queue_stage(m_institutionid,m_target_queueid),
                       status             = m_target_status,
                       lockedby           = NULL,
                       repairedby         = NULL,
                       releasedby         = NULL,
                       authorizedby       = NULL,
                       forwardedby        = NULL,
                       operator           = NULL,
                       stachemmessageflag = p_stachemmessageflag ,
                       lockstatus          =    NULL,
                       prevqueueid        = p_queueid
                WHERE  msgdb_id           = p_msgdb_id;

        ----changing msgdb_output.MDBOUT_status to 'A' to support EOD reports

        IF m_target_queueid = 'PROCDQ' AND m_target_status = 79
        THEN
            UPDATE  msgdb_output
            SET     mdbout_status = 'A'
            WHERE   msgdb_id = p_msgdb_id
            AND     mdbout_mode IN (SELECT para_code FROM  TABLE (get_code_from_list(td_get_value('EODREP_CONF','EOD2'), '|') ));

        END IF;
    END IF;


    IF m_tdvalue IS NULL
    THEN
        RAISE NO_CONFIGURATION_FOUND;
    END IF;

    IF SUBSTR(m_tdvalue,1,1) != '|' --to add input parameter
    THEN
        SELECT LENGTH(m_tdvalue)-LENGTH(REPLACE(m_tdvalue,'|',''))
        INTO   m_pipe_count
        FROM   DUAL;
    END IF;

    m_pipe_count       := NVL(m_pipe_count, 0) + 1;
        DBMS_OUTPUT.put_line('m_pipe_count : ' || m_pipe_count);
        DBMS_OUTPUT.put_line('m_prioritydate : ' || m_prioritydate);
           DBMS_OUTPUT.put_line('m_priorityamountnum : ' || m_priorityamountnum);

    m_msg_prioritydate     := TO_TIMESTAMP(TO_CHAR(TO_DATE(m_prioritydate, 'YYYY-MM-DD'), 'YYYY-MM-DD') || ' 00:00:00.000', 'YYYY-MM-DD HH24:MI:SS.FF3');
        DBMS_OUTPUT.put_line('m_prioritydate : ' || m_msg_prioritydate);
    m_sysdate              := TO_TIMESTAMP( ( TO_CHAR(SYSDATE, 'YYYY-MM-DD') || ' 00:00:00.000' ) , 'YYYY-MM-DD HH24:MI:SS.FF3');
        DBMS_OUTPUT.put_line('m_sysdate : ' || m_sysdate);

        DBMS_OUTPUT.put_line('m_entrydate : ' || m_entrydate);

            IF K =1 OR m_CUSTOMERACCNO_valid = 'YES'
            THEN

                DBMS_OUTPUT.put_line('Value for K --' || K);
                DBMS_OUTPUT.put_line('Value for m_CUSTOMERACCNO_Invalid' || m_CUSTOMERACCNO_valid);
                FOR i IN 1..m_pipe_count
                LOOP
                    IF m_msg_prioritydate < m_sysdate AND p_user_action_flag <> 'R'
                    THEN
                        m_entrydate := m_sysdate;
                        m_prev_date := m_msg_prioritydate;

            --DBMS_OUTPUT.put_line('1 : ' || 1);
        ELSE
            m_entrydate := m_msg_prioritydate;
            m_prev_date := m_msg_prioritydate;
            --DBMS_OUTPUT.put_line('2 : ' || 2);
        END IF;
            --DBMS_OUTPUT.put_line('m_entrydate : ' || m_entrydate);

        m_entry_timestamp_beg    := TO_TIMESTAMP((TO_CHAR(m_entrydate, 'YYYY-MM-DD') || ' 00:00:00.000' ), 'YYYY-MM-DD HH24:MI:SS.FF3');
        m_entry_timestamp_end    := TO_TIMESTAMP((TO_CHAR(m_entrydate, 'YYYY-MM-DD') || ' 23:59:59.999' ), 'YYYY-MM-DD HH24:MI:SS.FF3');

        m_prev_timestamp_beg    := TO_TIMESTAMP((TO_CHAR(m_prev_date, 'YYYY-MM-DD') || ' 00:00:00.000' ), 'YYYY-MM-DD HH24:MI:SS.FF3');
        m_prev_timestamp_end    := TO_TIMESTAMP((TO_CHAR(m_prev_date, 'YYYY-MM-DD') || ' 23:59:59.999' ), 'YYYY-MM-DD HH24:MI:SS.FF3');


        SELECT COUNT(*)
        INTO m_txn_count
        FROM ACCOUNT_BALANCE
        WHERE (ACCOUNT_NUMBER = m_account_number
        OR ACCOUNT_NUMBER_ENC =  m_account_number_enc)
        AND INSTITUTION_ID = m_institutionid
        AND TRUNC(ENTRY_DATE) = TRUNC(m_entrydate);

        --DBMS_OUTPUT.put_line('m_txn_count : ' || m_txn_count);
        m_action        := getstringitemwithsepformatch(getstringitemwithsepformatch(m_tdvalue, i, '|'), 2, '-') ;

        IF i = 1
        THEN
            m_column_name   := getstringitemwithsepformatch(m_tdvalue, 1, '-');
        ELSE
            m_column_name   := getstringitemwithsepformatch(getstringitemwithsepformatch(m_tdvalue,i, '-'), 2, '|');
        END iF;

        --DBMS_OUTPUT.put_line('m_action : ' || m_action);
        --DBMS_OUTPUT.put_line('m_column_name : ' || m_column_name);

        IF m_txn_count <=0
        THEN
            m_insert := 'INSERT INTO account_balance ( ACCOUNT_NUMBER, ENTRY_DATE, INSTITUTION_ID, '||m_column_name||', LAST_ACNT_BALN_RECORD_FLAG,
            BANK_CODE, account_number_enc, datakeyid) VALUES (
                '''||m_account_number||''','''||m_entrydate||''','''||m_institutionid||''','''||m_priorityamountnum||''',''N'','''||m_bank_code||''','''||m_account_number_enc||''','''||m_datakeyid||''')';
             EXECUTE IMMEDIATE   m_insert;
              /* Formatted on 2021/10/08 12:58 (Formatter Plus v4.8.8) 
            INSERT INTO account_balance
            (account_number, entry_date, institution_id,
             sum_of_forecast_payments, last_acnt_baln_record_flag, bank_code,
             account_number_enc
            )
            VALUES (m_account_number, m_entrydate, m_institutionid,
             m_priorityamountnum, 'N', m_bank_code,
             m_account_number_enc
            );*/
              --COMMIT;
        ELSE

            --DBMS_OUTPUT.put_line('3 : ' || 3);

--        EXCEPTION
--        WHEN DUP_VAL_ON_INDEX
--        THEN


            IF m_action = 'R'
            THEN
                m_first_query_part  := 'UPDATE ACCOUNT_BALANCE SET ';
                m_middle_part       := m_column_name || ' = NVL(' || m_column_name || ',0) - NVL(' || m_priorityamountnum ||',0)';

                    --DBMS_OUTPUT.put_line('m_middle_part : ' || m_middle_part);
                    IF instr(m_tenant_list,m_tenant)>0
                    THEN
                    m_where_part        := ' WHERE account_number_enc = ''' || m_account_number_enc || ''' AND  institution_id = '''
                                            --|| m_institutionid || ''' AND TRUNC(ENTRY_DATE) = TRUNC(''' || m_prev_date||''')';
                                                || m_institutionid || ''' AND ENTRY_DATE BETWEEN ''' || m_prev_timestamp_beg || ''' AND ''' || m_prev_timestamp_end||'''';
                    ELSE
                    m_where_part        := ' WHERE account_number = ''' || m_account_number || ''' AND  institution_id = '''
                                            || m_institutionid || ''' AND ENTRY_DATE BETWEEN ''' || m_prev_timestamp_beg || ''' AND ''' || m_prev_timestamp_end||'''';
                    END IF;
                    m_execute_statement := m_first_query_part || m_middle_part || m_where_part;

                --DBMS_OUTPUT.put_line('m_execute_statement : ' || m_execute_statement);
                EXECUTE IMMEDIATE m_execute_statement;


            END IF;

            IF m_action = 'A'
            THEN
                m_first_query_part  := 'UPDATE ACCOUNT_BALANCE SET ';
                m_middle_part       := m_column_name || ' = NVL(' || m_column_name || ',0) + NVL(' || m_priorityamountnum ||',0)';

                    --DBMS_OUTPUT.put_line('m_middle_part : ' || m_middle_part);
                    IF instr(m_tenant_list,m_tenant)>0
                    THEN
                    m_where_part        := ' WHERE account_number_enc = ''' || m_account_number_enc || ''' AND  institution_id = '''
                                            --|| m_institutionid || ''' AND TRUNC(ENTRY_DATE) = TRUNC('''|| m_entrydate || ''')' ;
                                            || m_institutionid || ''' AND ENTRY_DATE BETWEEN '''|| m_entry_timestamp_beg || ''' AND ''' || m_entry_timestamp_end||'''';
                    ELSE
                    m_where_part        := ' WHERE account_number = ''' || m_account_number || ''' AND  institution_id = '''
                                            || m_institutionid || ''' AND ENTRY_DATE BETWEEN '''|| m_entry_timestamp_beg  || ''' AND ''' || m_entry_timestamp_end||'''';
                    END IF;

                m_execute_statement := m_first_query_part || m_middle_part || m_where_part;

                --DBMS_OUTPUT.put_line('m_execute_statement : ' || m_execute_statement);
                EXECUTE IMMEDIATE m_execute_statement;

            END IF;
        END IF;

                END LOOP;
            END IF;
            IF m_CUSTOMERACCNO_valid = 'YES'
            THEN
                              IF m_tdkey_temp = 'I'
                              THEN
                                    m_tdkey_temp := 'D';
                              ELSIF m_tdkey_temp = 'IO'
                              THEN
                                    m_tdkey_temp := 'DO';
                              ELSIF m_tdkey_temp = 'D'
                              THEN
                                    m_tdkey_temp := 'I';
                              ELSIF m_tdkey_temp ='DO'
                              THEN
                                    m_tdkey_temp := 'IO';
        END IF;
                        m_account_number  := m_CUSTOMERACCNO;
                        m_account_number_enc  := m_CUSTOMERACCNO_enc;
            ELSE
                DBMS_OUTPUT.put_line('m_CUSTOMERACCNO_valid : ' || m_CUSTOMERACCNO_valid);
               EXIT;
             END IF;

    END LOOP;

    --COMMIT;

    g_queueid   := m_target_queueid;
    g_messageno := m_messageno;

    IF p_user_action_flag = 'V' and p_userid IS NOT NULL
    THEN
        g_action    := 'VALIDATE';
        g_audittext := 'Validated transaction number <' || g_messageno || '> validated and moved to Queue ''' || g_queueid ||''' by User '|| p_userid;
    ELSIF p_user_action_flag = 'R'
    THEN
        g_action    := 'CANCEL';
        g_audittext := 'Canceled transaction number <' || g_messageno || '> and moved to Queue ''' || g_queueid||''' from Queue '''||p_queueid||'''';
        update_target_status(p_msgdb_id,p_user_action_flag);
    ELSIF p_user_action_flag = 'p'
    THEN
        g_action    := 'IGNORE';
        g_audittext := 'Ignored transaction number <' || g_messageno || '> validated and moved to Queue ''' || g_queueid ||''' by User '||p_userid;
    END IF;

    IF p_user_action_flag IN ('R','p') OR (p_user_action_flag = 'V' and p_userid IS NOT NULL)
    THEN
        genaudit_insert_enchash_wrap
        (
        p_messageno=>g_messageno,
        p_queueid=>g_queueid,
        p_username=>p_userid,
        p_application=>g_application,
        p_modulename=>g_modulename,
        p_action=>g_action,
        p_audittext=>g_audittext,
        p_institutionid=>m_institutionid,
        p_incr_count=>0
        );

    END IF;

    g_audittext :=  'Balance calculation is done for transaction number <' || g_messageno || '> and moved to Queue ''' || g_queueid || ''' from Queue ''' ||  p_queueid ||'''';

    genaudit_insert_enchash_wrap
    (
    p_messageno=>g_messageno,
    p_queueid=>g_queueid,
    p_username=>p_userid,
    p_application=>g_application,
    p_modulename=>g_modulename,
    p_action=>g_action,
    p_audittext=>g_audittext,
    p_institutionid=>m_institutionid,
    p_incr_count=>0
    );


EXCEPTION
WHEN NOT_SUBSCRIBED
THEN
    NULL;
    --DBMS_OUTPUT.put_line('NOT_SUBSCRIBED');
WHEN NO_CONFIGURATION_FOUND
THEN
    --DBMS_OUTPUT.put_line('NO_CONFIGURATION_FOUND');
    genaudit_insert_enchash_wrap
    (
    p_messageno=>m_messageno,
    p_queueid=>m_target_queueid,
    p_username=>p_userid,
    p_application=>g_application,
    p_modulename=>g_modulename,
    p_action=>g_action,
    p_audittext=>'Moved to Queue ' || m_target_queueid || ' from Queue ' ||p_queueid,
    p_institutionid=>p_institutionid,
    p_incr_count=>0
    );

--    WHEN TRAN_IN_INTERMEDIATE_STATUS
--    THEN
--        p_return_code := 1384; -- Transaction records in intermediate state.
--    WHEN TRAN_IN_INTERMEDIATE_QUEUE
--    THEN
--        p_return_code := 1384; -- Transaction records in intermediate state.
WHEN OTHERS
THEN
    --DBMS_OUTPUT.put_line(SQLCODE || SQLERRM || dbms_utility.format_error_backtrace);
    NULL;
END; 