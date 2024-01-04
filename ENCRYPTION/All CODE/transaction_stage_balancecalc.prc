create or replace PROCEDURE          transaction_stage_balancecalc
(
p_src_queueid           IN MSGDB.queueid%TYPE,
p_src_status            IN MSGDB.status%TYPE,
calling_parameter        IN VARCHAR2
)
AS

--call transaction_stage_balancecalc('TMPBALQ1', 69, 'FIRST);
--call transaction_stage_balancecalc('TMPBALQ5', 69, 'FIRST');

    CURSOR c_institutions
    IS
    SELECT DISTINCT institutionid FROM MSGDB
    WHERE queueid =   p_src_queueid
    AND   status  =   p_src_status;

    CURSOR  c_transaction_records (c_institutionid IN MSGDB.institutionid%TYPE,c_tenant IN INSTITUTIONPARAMETERS.paramname%TYPE)
    IS
    SELECT am.account_number,
           am.account_number_enc,
           am.bank_code,
           m.CUSTOMERACCNO,
           m.priorityamountnum,
           m.messageno,
           m.institutionid,
           m.prioritydate,
           m.status,
           m.msgdb_id,
           m.prev_msgdate,
           m.datakeyid,
           UPPER(REPLACE(SUBSTR(m.messageclasstype,1,8),'.',''))||'|'||m.messagedirection||'|'||c_tenant||'|'||m.transactiongroup||'|'||m.transactiontype||'|'||m.msg_family   as tdkey
    FROM    msgdb m,
            account_master am
    WHERE (m.customeraccno = am.account_number
    OR m.sender || m.customeraccno = am.account_number
    OR m.customeraccno =am.account_iban
    OR m.customeraccno_enc =am.account_number_enc
    OR m.customeraccno_enc =am.account_iban_enc)
    AND am.institution_id =m.institutionid
    AND m.institutionid = c_institutionid
    AND am.ACCOUNT_STATUS='VALIDATED'
    AND m.queueid =   p_src_queueid
    AND m.status  =   p_src_status;

    CURSOR  c_transaction_records_nostro(c_institutionid IN MSGDB.institutionid%TYPE,c_tenant IN INSTITUTIONPARAMETERS.paramname%TYPE)
    IS
    SELECT am.account_number,
           am.account_number_enc,
           am.bank_code,
           m.CUSTOMERACCNO,
           m.priorityamountnum,
           m.messageno,
           m.institutionid,
           m.prioritydate,
           m.status,
           m.msgdb_id,
           m.prev_msgdate,
           m.datakeyid,
           UPPER(REPLACE(SUBSTR(m.messageclasstype,1,8),'.',''))||'|'||m.messagedirection||'|'||c_tenant||'|'||m.transactiongroup||'|'||m.transactiontype||'|'||m.msg_family   as tdkey
    FROM    msgdb m,
            account_master am
    WHERE (m.nostro_account_number = am.account_number_enc
        OR m.nostro_account_number = am.account_number
        OR m.nostro_account_number =am.account_iban_enc
        OR m.nostro_account_number =am.account_iban)
    AND am.institution_id =m.institutionid
    AND m.institutionid =c_institutionid
    AND am.ACCOUNT_STATUS='VALIDATED'
    AND m.queueid =   p_src_queueid
    AND m.status  =   p_src_status;

    TYPE t_institutions IS TABLE OF c_institutions%ROWTYPE;
    a_institutions                                t_institutions                                   := t_institutions();

    TYPE t_msgdb IS TABLE OF c_transaction_records_nostro%ROWTYPE;
    a_source_records                    t_msgdb                                 := t_msgdb();

    m_institutionid                     msgdb.institutionid%TYPE                := NULL;
    m_target_queueid_status             VARCHAR2(1000)                          := NULL;
    m_tdvalue                           TABLEDETAILS.TDVALUE%TYPE               := NULL;
    m_columnconfig_tdvalue                           TABLEDETAILS.TDVALUE%TYPE               := NULL;
    m_target_queueid                    msgdb.queueid%TYPE                      := NULL;
    m_target_status                     msgdb.status%TYPE                       := NULL;
    m_action                            TABLEDETAILS.TDVALUE%TYPE               := NULL;
    m_pipe_count                        NUMBER                                  := 0;
    m_column_name                       TABLEDETAILS.TDVALUE%TYPE               := NULL;
    m_first_query_part                  VARCHAR2(32000)                         := NULL;
    m_middle_part                       VARCHAR2(32000)                         := NULL;
    m_where_part                        VARCHAR2(32000)                         := NULL;
    m_execute_statement                 VARCHAR2(32000)                         := NULL;
    m_priorityamountnum                 msgdb.PRIORITYAMOUNTNUM%TYPE            := NULL;
    m_prioritydate                      msgdb.prioritydate%TYPE                 := NULL;
    m_account_number                    msgdb.ACCOUNT_NUMBER%TYPE               := NULL;
    m_account_enc                       msgdb.account_number_enc%TYPE           := NULL;
    m_prev_msgdate                      msgdb.prev_msgdate%TYPE                 := NULL;
    m_entrydate                         account_balance.entry_date%TYPE         := NULL;
    m_prev_msgdate_time                 account_balance.entry_date%TYPE         := NULL;
    m_encrypt                           VARCHAR2(10)                            := 'ENCRYPT';
    m_ctr_beg                           NUMBER                                  := 0;
    m_ctr_end                           NUMBER                                  := 0;
    m_ctr                               NUMBER                                  := 0;
    m_insert                            VARCHAR2(3800)                          := NULL;
    g_username                          genaudit.username%TYPE                  := 'ADMIN';
    g_queueid                           genaudit.queueID%TYPE                   := NULL;
    g_modulename                        genaudit.modulename%TYPE                := 'RECORD';
    g_application                       genaudit.modulename%TYPE                := 'PELICAN';
    g_action                            genaudit.action%TYPE                    := 'MOVE';
    g_audittext                         genaudit.audittext%TYPE                 := NULL;
    g_messageno                         genaudit.messageno%TYPE                 := NULL;
    m_tenant_list                       VARCHAR2(32664)                         := NULL;
    m_tenant                            VARCHAR2(32664)                         := NULL;
    m_context_name                      VARCHAR2(32664)                         := 'PLCN_CNTX';

    NO_CONFIGURATION_FOUND              EXCEPTION;
    NO_RECORDS_FOUND                    EXCEPTION;

    m_entry_timestamp_beg               TIMESTAMP;
    m_entry_timestamp_end               TIMESTAMP;
    m_txn_count                         NUMBER;

    m_balance_subscription              INSTITUTIONPARAMETERS.PARAMVALUE%TYPE   := NULL;
    NOT_SUBSCRIBED                      EXCEPTION;

    m_tdkey_temp                      TABLEDETAILS.TDKEY%TYPE                         := NULL;
    m_CUSTOMERACCNO                    MSGDB.CUSTOMERACCNO%TYPE                      :=NULL;
    m_message_Clob                  CLOB                                                := EMPTY_CLOB();
    m_message_blob                  MSGBLOCKS.MESSAGE%TYPE;
    m_msgblocktype                  MSGBLOCKS.MSGBLOCKTYPE%TYPE                         := '6';
    m_xtype                         XMLTYPE;
    m_xml                           VARCHAR2(1)                                         := 'Y';
    m_xml_field                     VARCHAR2(30)                                        := ':A00:00';
    m_swift_field                   VARCHAR2(30)                                        := ':A00:20';
    m_error_Code                    VARCHAR2(30)                                        := '6856';
    m_msg_Family                    VARCHAR2(30)                                        := NULL;
    m_block                         VARCHAR2(30)                                        := NULL;
    m_comments                      MSGDB.COMMENTS%TYPE                                 := NULL;
    m_keyid                         GENAUDIT.keyid%TYPE             := NULL;
    m_secretkey                     VARCHAR2(32767)                 := NULL;
    m_key                           VARCHAR2(100)                   := 'PELICAN_INTERNAL_KEY_ID';
    m_CUSTOMERACCNO_valid                      VARCHAR2 (50 Byte)                     :='YES';

BEGIN

    DBMS_OUTPUT.put_line('p_queueid : ' || p_src_queueid);
    DBMS_OUTPUT.put_line('p_src_status : ' || p_src_status);

    OPEN c_institutions;
    FETCH c_institutions  BULK COLLECT INTO a_institutions;
    CLOSE c_institutions;
    DBMS_OUTPUT.put_line('a_institutions.FIRST: '||NVL(a_institutions.FIRST,0));
    DBMS_OUTPUT.put_line('a_institutions.LAST: '||NVL(a_institutions.LAST,0));
    FOR rec IN a_institutions.FIRST.. a_institutions.LAST
    LOOP
        BEGIN
            DBMS_OUTPUT.put_line('a_institutions(rec).institutionid : '||a_institutions(rec).institutionid );

            m_tenant     := get_institution_param_value(a_institutions(rec).institutionid,'INSTITUTION_DETAILS','TENANT_NAME');--NVL(GET_TENANTNAME(a_institutions(rec).institutionid),'X');
            m_columnconfig_tdvalue    := NVL(TD_GET_VALUE(m_tenant,'ACCOUNT_REF'),'XX');

            DBMS_OUTPUT.put_line('m_tenant : ' || m_tenant);
            DBMS_OUTPUT.put_line('m_columnconfig_tdvalue : ' || m_columnconfig_tdvalue);
            IF m_columnconfig_tdvalue = 'NOSTRO_ACCOUNT_NUMBER'
            THEN
                OPEN c_transaction_records_nostro(a_institutions(rec).institutionid, m_tenant);
                FETCH c_transaction_records_nostro  BULK COLLECT INTO a_source_records LIMIT 10000;
            ELSE
                OPEN c_transaction_records(a_institutions(rec).institutionid, m_tenant);
                FETCH c_transaction_records  BULK COLLECT INTO a_source_records LIMIT 10000;
            END IF;

            LOOP


                m_ctr_beg := NVL(a_source_records.FIRST,0);
                m_ctr_end := NVL(a_source_records.LAST,0);

                DBMS_OUTPUT.put_line('m_ctr_beg=>' || m_ctr_beg);
                DBMS_OUTPUT.put_line('m_ctr_end=>' || m_ctr_end);

                IF m_ctr_end = 0
                THEN
                    DBMS_OUTPUT.put_line ('m_ctr_end is              =>' || m_ctr_end);
                    RAISE NO_RECORDS_FOUND;
                    EXIT;
                END IF;

                FOR m_ctr IN m_ctr_beg..m_ctr_end
                LOOP
                    BEGIN
                         m_tdkey_temp  := TD_GET_VALUE(m_tenant,a_source_records(m_ctr).tdkey);

                               
                            m_account_number    :=  a_source_records(m_ctr).account_number;
                            m_account_enc    := a_source_records(m_ctr).account_number_enc;        

                        FOR K IN 1..2
                        LOOP
                          BEGIN
                        DBMS_OUTPUT.put_line('TD_GET_VALUE(m_tenant,a_source_records(m_ctr).tdkey) : ' || TD_GET_VALUE(m_tenant,a_source_records(m_ctr).tdkey));
                        --DBMS_OUTPUT.put_line('m_target_queueid_status : ' || m_target_queueid_status);
                        IF m_columnconfig_tdvalue = 'NOSTRO_ACCOUNT_NUMBER'
                        THEN
                            m_target_queueid_status := td_get_value(m_tenant, p_src_queueid||'-'||p_src_status||'|'||m_tdkey_temp);
                        ELSE
                            m_target_queueid_status := td_get_value('QUEUEID_CONFIG', p_src_queueid||'-'||p_src_status);
                        END IF;

                        DBMS_OUTPUT.put_line('a_source_records(m_ctr).tdkey : ' || a_source_records(m_ctr).tdkey);
                        DBMS_OUTPUT.put_line('m_target_queueid_status : ' || m_target_queueid_status);

                        m_tdvalue               := getstringitemwithsep(m_target_queueid_status,2,',');

                        DBMS_OUTPUT.put_line('m_tdvalue 1: ' || m_tdvalue);

                        IF m_tdvalue IS NULL
                        THEN
                            RAISE NO_CONFIGURATION_FOUND;
                        END IF;

                        m_target_queueid        := getstringitemwithsep(getstringitemwithsep(m_target_queueid_status,1,','), 1, '-');
                        m_target_status         := getstringitemwithsep(getstringitemwithsep(m_target_queueid_status,1,','), 2, '-');


                        DBMS_OUTPUT.put_line('m_tdvalue 2 : ' || m_tdvalue);

                        DBMS_OUTPUT.put_line('m_target_queueid : ' || m_target_queueid);
                        DBMS_OUTPUT.put_line('m_target_status : ' || m_target_status);
                        DBMS_OUTPUT.put_line('a_source_records(m_ctr).institutionid : ' || a_source_records(m_ctr).institutionid);
                        DBMS_OUTPUT.put_line('a_source_records(m_ctr).msgdb_id : ' || a_source_records(m_ctr).msgdb_id);
                                 IF NVL(TRIM(a_source_records(m_ctr).CUSTOMERACCNO),'XX') = 'XX' AND K = 2
                                 THEN

                                    BEGIN
                                        SELECT m.msg_family,ms.message,NVL(m.comments,'')
                                        INTO m_msg_Family,m_message_blob,m_Comments
                                        FROM  MSGBLOCKS ms, msgdb m
                                        WHERE ms.msgdb_id = m.msgdb_id
                                        AND ms.msgdb_id   = a_source_records(m_ctr).msgdb_id
                                        AND msgblocktype = m_msgblocktype;

                                        m_message_clob:= convertTOclob(m_message_blob);
                                        m_block := 'Y';
                                    EXCEPTION
                                    WHEN OTHERS
                                    THEN
                                        DBMS_OUTPUT.put_line('Not an XML');
                                        m_block:= NULL;
                                        m_xml:='N';
                                    END;

                                    IF m_block = 'Y'
                                    THEN
                                        BEGIN
                                        m_xtype := XMLTYPE(xmlData=>m_message_clob);
                                        DBMS_OUTPUT.put_line('XML present '|| m_block);
                                        EXCEPTION
                                        WHEN OTHERS
                                        THEN
                                            DBMS_OUTPUT.put_line('Not an XML');
                                            m_xml:='N';
                                        END;
                                    END IF;
                        UPDATE  msgdb
                                    SET
                                        comments = CASE
                                                   WHEN m_xml='N' AND trim(m_msg_Family) = 'SEPA'
                                                   THEN
                                                       m_Comments || m_xml_field ||'-'||m_error_code
                                                   WHEN m_xml='N' AND trim(m_msg_Family) = 'SWIFT'
                                                   THEN
                                                       m_Comments || m_swift_field ||'-'||m_error_code
                                                   ELSE
                                                       m_Comments
                                                   END

                                    WHERE msgdb_id = a_source_records(m_ctr).msgdb_id;

                                    IF m_xml='N'
                                    THEN
                                        m_message_clob:=   CASE
                                                           WHEN trim(m_msg_Family) = 'SEPA'
                                                           THEN
                                                               m_message_clob || m_xml_field ||'-'||m_error_code
                                                           WHEN m_xml='N' AND trim(m_msg_Family) = 'SWIFT'
                                                           THEN
                                                               m_message_clob || m_swift_field ||'-'||m_error_code
                                                           ELSE
                                                               m_message_clob
                                                           END;
                                        m_message_blob:= clob_to_blob(m_message_clob);
                                        UPDATE MSGBLOCKS
                                        SET MESSAGE  =m_message_blob
                                        WHERE MSGDB_ID=a_source_records(m_ctr).msgdb_id
                                        AND msgblocktype = m_msgblocktype;
                                        DBMS_OUTPUT.put_line ( 'UPDATED');
                                    END IF;
                                   COMMIT;
                                   EXIT;
                                ELSIF K =2
                                THEN

                                   BEGIN
                                        SELECT am.account_number,am.account_number_enc
                                        INTO m_account_number,m_account_enc
                                        FROM account_master am , msgdb m
                                        WHERE (m.CUSTOMERACCNO = am.account_number
                                        OR m.CUSTOMERACCNO =am.account_iban
                                        OR m.customeraccno_enc =am.account_number_enc
                                        OR m.customeraccno_enc =am.account_iban_enc)
                                        AND am.institution_id =m.institutionid
                                        AND am.ACCOUNT_STATUS='VALIDATED'
                                        AND m.MSGDB_ID = a_source_records(m_ctr).msgdb_id;
                                        
                                  
                                       -- m_account_number  := m_CUSTOMERACCNO;
                                   EXCEPTION
                                    WHEN NO_DATA_FOUND
                                    THEN
                                                 m_CUSTOMERACCNO_valid := 'NO';
                                                 NULL;
                                                 EXIT;

                                    WHEN OTHERS
                                    THEN
                                                m_CUSTOMERACCNO_valid := 'NO';
                                                NULL;
                                                EXIT;
                                   END;

                                END IF;
                                IF K =1
                                THEN

                                    UPDATE  msgdb
                        SET     queueid             =   m_target_queueid,
                                status              =   m_target_status,
                                processing_stage    =   get_queue_stage(a_source_records(m_ctr).institutionid,m_target_queueid),
                                prevqueueid         =   p_src_queueid
                        WHERE   msgdb_id    = a_source_records(m_ctr).msgdb_id;
                                 END IF;
                        m_balance_subscription    := NVL(UPPER(Get_Institution_Param_Value(a_source_records(m_ctr).institutionid ,'BALANCE_MANAGEMENT','CALCULATE_BALANCE_FROM_STATEMENT')), 'NO');

                        IF m_balance_subscription IN ('NO', 'N')
                        THEN
                            RAISE NOT_SUBSCRIBED;
                        END IF;

                        IF SUBSTR(m_tdvalue,1,1) != '|' --to add input parameter
                        THEN
                            SELECT LENGTH(m_tdvalue)-LENGTH(REPLACE(m_tdvalue,'|',''))
                            INTO   m_pipe_count
                            FROM   DUAL;
                        END IF;

                        m_pipe_count        :=  NVL(m_pipe_count, 0) + 1;
                        m_prioritydate      :=  a_source_records(m_ctr).prioritydate;



                        m_priorityamountnum :=  a_source_records(m_ctr).priorityamountnum;

                        m_institutionid     :=  a_source_records(m_ctr).institutionid;
                        m_prev_msgdate      :=  a_source_records(m_ctr).prev_msgdate;

                        DBMS_OUTPUT.put_line('m_pipe_count : ' || m_pipe_count);
                        DBMS_OUTPUT.put_line('m_prioritydate : ' || m_prioritydate);
                        DBMS_OUTPUT.put_line('m_priorityamountnum : ' || m_priorityamountnum);

                        m_entrydate         := TO_TIMESTAMP(TO_CHAR(TO_DATE(m_prioritydate, 'YYYY-MM-DD'), 'YYYY-MM-DD') || ' 00:00:00.000', 'YYYY-MM-DD HH24:MI:SS.FF3');
                        DBMS_OUTPUT.put_line('m_entrydate : ' || m_entrydate);

                        IF m_prev_msgdate IS NOT NULL
                        THEN
                            m_prev_msgdate_time := TO_TIMESTAMP(TO_CHAR(TO_DATE(m_prev_msgdate, 'YYYY-MM-DD'), 'YYYY-MM-DD') || ' 00:00:00.000', 'YYYY-MM-DD HH24:MI:SS.FF3');
                            DBMS_OUTPUT.put_line('m_prev_msgdate_time : ' || m_prev_msgdate_time);

                        END IF;

--                        m_account_enc := encrypt_decrypt_basedon_session_cntx(m_encrypt,m_institutionid ,m_account_number);
--                        m_account_number := return_masked_info('PREFIX',m_institutionid ,m_account_number);

                        m_entry_timestamp_beg    := TO_TIMESTAMP((TO_CHAR(m_entrydate, 'YYYY-MM-DD') || ' 00:00:00.000' ), 'YYYY-MM-DD HH24:MI:SS.FF3');
                        m_entry_timestamp_end    := TO_TIMESTAMP((TO_CHAR(m_entrydate, 'YYYY-MM-DD') || ' 23:59:59.999' ), 'YYYY-MM-DD HH24:MI:SS.FF3');


                        SELECT COUNT(*)
                        INTO m_txn_count
                        FROM ACCOUNT_BALANCE
                        WHERE ACCOUNT_NUMBER = m_account_number
                        AND INSTITUTION_ID = m_institutionid
                        AND TRUNC(ENTRY_DATE) = TRUNC(m_entrydate);

                        DBMS_OUTPUT.put_line('m_txn_count : ' || m_txn_count);

                        FOR i IN 1..m_pipe_count
                        LOOP
                            IF i = 1
                            THEN
                                m_column_name   := getstringitemwithsepformatch(m_tdvalue, 1, '-');
                            ELSE
                                m_column_name   := getstringitemwithsepformatch(getstringitemwithsepformatch(m_tdvalue,i, '-'), 2, '|');
                            END iF;

                            --BEGIN
                            IF m_txn_count <=0
                            THEN
                                DBMS_OUTPUT.put_line('INSERT');
                                m_insert := 'INSERT INTO account_balance ( ACCOUNT_NUMBER, ENTRY_DATE, INSTITUTION_ID, '||m_column_name||', LAST_ACNT_BALN_RECORD_FLAG,
                                BANK_CODE, account_number_enc) VALUES (
                                '''||m_account_number||''','''||m_entrydate||''','''||m_institutionid||''','''||m_priorityamountnum||''',''N'','''||a_source_records(m_ctr).bank_code||''','''||m_account_enc||''')';

                                EXECUTE IMMEDIATE m_insert;
                                COMMIT;

                            ELSE
                                DBMS_OUTPUT.put_line('ELSE');
                                m_action        := getstringitemwithsepformatch(getstringitemwithsepformatch(m_tdvalue, i, '|'), 2, '-') ;

                                DBMS_OUTPUT.put_line('m_action : ' || m_action);
                                DBMS_OUTPUT.put_line('m_column_name : ' || m_column_name);
                                IF m_action = 'R'
                                THEN
                                    m_first_query_part  := 'UPDATE ACCOUNT_BALANCE SET ';
                                    m_middle_part       := m_column_name || ' = NVL(' || m_column_name || ',0) - NVL(' || m_priorityamountnum||',0)';

                                    DBMS_OUTPUT.put_line('m_middle_part : ' || m_middle_part);

                                    IF m_prev_msgdate IS NOT NULL AND  m_prev_msgdate <> m_prioritydate
                                    THEN
                                        IF instr(m_tenant_list,m_tenant)>0
                                        THEN
                                        m_where_part        := ' WHERE account_number_enc = ''' || m_account_enc || ''' AND  institution_id = '''
                                                            || m_institutionid || ''' AND ENTRY_DATE = ''' || m_prev_msgdate_time||'''';
                                        ELSE
                                        m_where_part        := ' WHERE account_number = ''' || m_account_number || ''' AND  institution_id = '''
                                                            || m_institutionid || ''' AND ENTRY_DATE =''' || m_prev_msgdate_time||'''';
                                        END IF;
                                    ELSE
                                        IF instr(m_tenant_list,m_tenant)>0
                                        THEN
                                        m_where_part        := ' WHERE account_number_enc = ''' || m_account_enc || ''' AND  institution_id = '''
                                                            || m_institutionid || ''' AND ENTRY_DATE BETWEEN '''|| m_entry_timestamp_beg || ''' AND ''' || m_entry_timestamp_end||'''';
                                        ELSE
                                        m_where_part        := ' WHERE account_number = ''' || m_account_number || ''' AND  institution_id = '''
                                                            || m_institutionid || ''' AND ENTRY_DATE BETWEEN '''|| m_entry_timestamp_beg || ''' AND ''' || m_entry_timestamp_end||'''';
                                        END IF;
                                    END IF;
                                    m_execute_statement := m_first_query_part || m_middle_part || m_where_part;

                                    DBMS_OUTPUT.put_line('m_execute_statement : ' || m_execute_statement);
                                    EXECUTE IMMEDIATE m_execute_statement;


                                END IF;

                                IF m_action = 'A'
                                THEN
                                    m_first_query_part  := 'UPDATE ACCOUNT_BALANCE SET ';
                                    m_middle_part       := m_column_name || ' = NVL(' || m_column_name || ', 0) + NVL(' || m_priorityamountnum||',0)';

                                    DBMS_OUTPUT.put_line('m_middle_part : ' || m_middle_part);
                                    IF instr(m_tenant_list,m_tenant)>0
                                    THEN
                                    m_where_part        := ' WHERE account_number_enc = ''' || m_account_enc || ''' AND  institution_id = '''
                                                            || m_institutionid || ''' AND ENTRY_DATE BETWEEN '''|| m_entry_timestamp_beg || ''' AND ''' || m_entry_timestamp_end||'''';
                                    ELSE
                                    m_where_part        := ' WHERE account_number = ''' || m_account_number || ''' AND  institution_id = '''
                                                            || m_institutionid || ''' AND ENTRY_DATE BETWEEN '''|| m_entry_timestamp_beg || ''' AND ''' || m_entry_timestamp_end||'''';
                                    END IF;
                                    m_execute_statement := m_first_query_part || m_middle_part || m_where_part;

                                    DBMS_OUTPUT.put_line('m_execute_statement : ' || m_execute_statement);
                                    EXECUTE IMMEDIATE m_execute_statement;

                                END IF;
                            --END;
                            END IF;
                        END LOOP;

                        g_messageno := a_source_records(m_ctr).messageno;
                        g_queueid   := m_target_queueid;
                        g_audittext := 'Transaction number <' || g_messageno || '> moved to Queue ''' || m_target_queueid||''' from Queue '''||p_src_queueid||'''';

                        genaudit_insert_enchash_wrap
                        (
                        p_messageno=>g_messageno,
                        p_queueid=>g_queueid,
                        p_username=>g_username,
                        p_application=>g_application,
                        p_modulename=>g_modulename,
                        p_action=>g_action,
                        p_audittext=>g_audittext,
                        p_institutionid=>m_institutionid,
                        p_incr_count=>0
                        );
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

                          ELSE
                               EXIT;
                          END IF;
                        EXCEPTION
                            WHEN NO_RECORDS_FOUND
                            THEN
                                NULL;
                            WHEN NOT_SUBSCRIBED
                            THEN
                                NULL;
                                DBMS_OUTPUT.put_line('NOT_SUBSCRIBED');
                            WHEN NO_CONFIGURATION_FOUND
                            THEN
                                NULL;
                                DBMS_OUTPUT.put_line('NO_CONFIGURATION_FOUND');
                        END;


                      END LOOP;
                    EXCEPTION
                            WHEN NO_RECORDS_FOUND
                            THEN
                                --DBMS_OUTPUT.put_line('--NO_RECORDS_FOUND--');
                                NULL;
                            WHEN NOT_SUBSCRIBED
                            THEN
                                NULL;
                                DBMS_OUTPUT.put_line('NOT_SUBSCRIBED');
                            WHEN NO_CONFIGURATION_FOUND
                            THEN
                                NULL;
                                DBMS_OUTPUT.put_line('NO_CONFIGURATION_FOUND');
                            END;


                      m_CUSTOMERACCNO_valid := 'YES';
                END LOOP;

                IF m_columnconfig_tdvalue = 'NOSTRO_ACCOUNT_NUMBER'
                THEN
                    --OPEN c_transaction_records_nostro(a_institutions(rec).institutionid, m_tenant);

                    EXIT WHEN c_transaction_records_nostro%NOTFOUND;
                    FETCH c_transaction_records_nostro  BULK COLLECT INTO a_source_records LIMIT 10000;

                ELSE
                    --OPEN c_transaction_records(a_institutions(rec).institutionid, m_tenant);

                    EXIT WHEN c_transaction_records%NOTFOUND;
                    FETCH c_transaction_records  BULK COLLECT INTO a_source_records LIMIT 10000;

                END IF;

            END LOOP;
            IF m_columnconfig_tdvalue = 'NOSTRO_ACCOUNT_NUMBER'
            THEN
                CLOSE c_transaction_records_nostro;

            ELSE
                CLOSE c_transaction_records;
            END IF;
        EXCEPTION
            WHEN NO_RECORDS_FOUND
            THEN
                DBMS_OUTPUT.put_line('NO_RECORDS_FOUND');
                IF c_transaction_records_nostro%ISOPEN
                THEN
                    CLOSE c_transaction_records_nostro;
                ELSIF c_transaction_records%ISOPEN
                THEN
                    CLOSE c_transaction_records;
                END IF;
            WHEN OTHERS
            THEN
                DBMS_OUTPUT.put_line(SQLCODE || SQLERRM || dbms_utility.format_error_backtrace);
                IF c_transaction_records_nostro%ISOPEN
                THEN
                    CLOSE c_transaction_records_nostro;
                ELSIF c_transaction_records%ISOPEN
                THEN
                    CLOSE c_transaction_records;
                END IF;
        END;

    END LOOP;

EXCEPTION
WHEN OTHERS
THEN
    DBMS_OUTPUT.put_line(SQLCODE || SQLERRM || dbms_utility.format_error_backtrace);
    NULL;
END; 