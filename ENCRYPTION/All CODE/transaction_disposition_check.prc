create or replace PROCEDURE          transaction_disposition_check
(
    p_institutionid       IN        MSGDB.institutionid%TYPE,       --Institution Id of Record
    p_trn_msgdb_id        IN        MSGDB.msgdb_id%TYPE,            --MSGDBId of Record
    p_user_action_flag    IN        CHAR,
    p_stachemmessageflag  IN        MSGDB.stachemmessageflag%TYPE,
    p_userid              IN        UUSER.userid%TYPE,              --Logged In User ID
    p_queueid             IN        MSGDB.queueid%TYPE,             --QueueID of Record
    p_status              IN        MSGDB.status%TYPE,              --Status of Record
    p_commit_flag         IN        CHAR,
    p_custom              IN        MSGDB.custom5%TYPE              DEFAULT NULL,
    p_return_code         IN OUT NUMBER
)

IS

    m_queueid                       MSGDB.queueid%TYPE                                  := NULL;
    m_status                        MSGDB.status%TYPE                                   := NULL;
    m_queueid_status                TABLEDETAILS.tdkey%TYPE                             := NULL;
    m_remaining_booked_balance      account_balance.stmt_closing_booked_balance%TYPE    := 0;
    m_min_threshold_balance         NUMBER                                              := 0;
    m_tenantname                    INSTITUTIONPARAMETERS.PARAMVALUE%TYPE               := NULL;
    m_disposition_check             TABLEDETAILS.tdvalue%TYPE                           := NULL;
    m_td_key                        TABLEDETAILS.tdkey%TYPE                             := 'DISPOSITION_CHK';
    m_stmt_closing_booked_balance   account_balance.stmt_closing_booked_balance%TYPE    := NULL;
    m_curr_balance                  account_balance.stmt_closing_booked_balance%TYPE    := NULL;
    m_tdvalue                       TABLEDETAILS.TDVALUE%TYPE                           := NULL;
    m_priorityamountnum             MSGDB.priorityamountnum%TYPE                        := 0;
    m_prioritydate                  MSGDB.prioritydate%TYPE;
    m_account_number                ACCOUNT_MASTER.account_number%TYPE;
    m_account_number_enc            ACCOUNT_MASTER.account_number_ENC%TYPE;
    g_application                   genaudit.APPLICATION%type                           := 'PELICAN';
    g_modulename                    genaudit.MODULENAME%type                            := 'RECORD';
    g_action                        GENAUDIT.ACTION%TYPE                                := 'UPDATE';
    g_messageno                     GENAUDIT.MESSAGENO%TYPE                             := NULL;
    g_audittext                     GENAUDIT.AUDITTEXT%TYPE                             := NULL;


    m_msgblocktype                  MSGBLOCKS.MSGBLOCKTYPE%TYPE                         := '6';
    m_message_Clob                  CLOB                                                := EMPTY_CLOB();
    m_message_blob                  MSGBLOCKS.MESSAGE%TYPE;
    m_xtype                         XMLTYPE;
    m_xml                           VARCHAR2(1)                                         := 'Y';
    m_xml_field                     VARCHAR2(30)                                        := ':A00:00';
    m_swift_field                   VARCHAR2(30)                                        := ':A00:20';
    m_error_Code                    VARCHAR2(30)                                        := '3123';
    m_msg_Family                    VARCHAR2(30)                                        := NULL;
    m_block                         VARCHAR2(30)                                        := NULL;
    m_comments                      MSGDB.COMMENTS%TYPE                                 := NULL;
    m_key                           VARCHAR2(100)                   := 'PELICAN_INTERNAL_KEY_ID';
    m_keyid                         GENAUDIT.keyid%TYPE             := NULL;
    m_secretkey                     VARCHAR2(32767)                 := NULL;
    m_CUSTOMERACCNO                     MSGDB.CUSTOMERACCNO%TYPE                    :=NULL;
    m_CUSTOMERACCNO_valid          VARCHAR2(10)                    :='YES';
    m_tdkey                       TABLEDETAILS.TDkey%TYPE                           := NULL;
    m_decrypt                       VARCHAR2(32664)                         := 'DECRYPT';
    m_encrypt                       VARCHAR2(32664)                         := 'ENCRYPT';
    m_tenant_list                   VARCHAR2(32664)     := NULL;
    m_context_name                  VARCHAR2(32664)                         := NULL;


    -----EXCEPTION DECLARATION
    insufficient_balance            EXCEPTION;
    TXN_REJECT             EXCEPTION;
BEGIN
    Getkeyidandsecretkey (m_keyid,m_secretkey);


    IF p_user_action_flag = 'R'
    THEN
        transaction_queue_routing
                                    (
                                        p_institutionid,
                                        p_trn_msgdb_id,
                                        p_user_action_flag,
                                        NULL,
                                        NULL,
                                        p_queueid,
                                        p_status,
                                        NULL,
                                        p_return_code
                                    );
       RAISE TXN_REJECT;
    END IF;
    m_tenantname := get_institution_param_value(p_institutionid,'INSTITUTION_DETAILS','TENANT_NAME');
    m_tdvalue    := NVL(TD_GET_VALUE(m_tenantname,'ACCOUNT_REF'),'XX');

       BEGIN

                  SELECT TDVALUE
                  INTO m_context_name
                  FROM TABLEDETAILS
                  WHERE TDIDCODE ='CONTEXT'
                  AND
                  TDKEY = m_tenantname ;
                        --DBMS_OUTPUT.put_line('m_context_name -->'||m_context_name);

              EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN

                       DBMS_OUTPUT.PUT_LINE ('No CONTEXT found ');
             END;

    m_tenant_list := sys_context(m_context_name,'ENCRYPTION_TENANT_LIST');


    IF m_tdvalue = 'NOSTRO_ACCOUNT_NUMBER'
    THEN
        SELECT m.priorityamountnum,m.prioritydate,am.account_number,m.messageno,m.account_number_Enc,
                UPPER(REPLACE(SUBSTR(m.messageclasstype,1,8),'.',''))||'|'||m.messagedirection||
                 '|'||m_tenantname||'|'||m.transactiongroup||'|'||m.transactiontype||'|'||m.msg_family
        INTO   m_priorityamountnum,m_prioritydate,m_account_number,g_messageno,m_account_number_enc,m_tdkey
        FROM   MSGDB m, ACCOUNT_MASTER am
        WHERE  m.msgdb_id = p_trn_msgdb_id
        AND (m.nostro_account_number = am.account_number
        OR m.nostro_account_number = am.account_number_enc
        OR m.nostro_account_number = am.account_iban
        OR m.nostro_account_number = am.account_iban_enc
        )
        AND m.institutionid = am.institution_id
        AND am.account_status='VALIDATED'; --OR m.customeraccno_enc = am.account_iban_enc);
    ELSE
        SELECT m.priorityamountnum,m.prioritydate,am.account_number,m.messageno,
                UPPER(REPLACE(SUBSTR(m.messageclasstype,1,8),'.',''))||'|'||m.messagedirection||
                 '|'||m_tenantname||'|'||m.transactiongroup||'|'||m.transactiontype||'|'||m.msg_family
        INTO   m_priorityamountnum,m_prioritydate,m_account_number,g_messageno,m_tdkey
        FROM   MSGDB m, ACCOUNT_MASTER am
        WHERE  m.msgdb_id = p_trn_msgdb_id
        AND (m.customeraccno = am.account_number OR m.customeraccno_enc = am.account_number_enc)
        AND am.account_status='VALIDATED';
    END IF;
    -- fetch minimum  balance (threshold balance ) from  institutionparameters
    --m_min_threshold_balance := --get_institution_param_value
                                 --(n_msgdb_record (i).institutionid,
                                 -- 'INSTITUTION_DETAILS',
                                 -- 'MINIMUM_FLAG'
                               --  );

    -- checking flag  is YES
    m_disposition_check :=  get_institution_param_value(
                                                    p_institutionid,
                                                    'BALANCE_MANAGEMENT',
                                                    'DISPOSITION_CHECK'
                                                    );
    IF RTRIM (m_disposition_check) = 'YES'
    THEN

                IF TD_GET_VALUE(m_tenantname,m_tdkey)  IN( 'I', 'IO')
                THEN
                     BEGIN
                        
                        SELECT am.account_number,am.account_number_enc
                        INTO m_account_number,m_account_number_enc
                        FROM account_master am , msgdb m
                        WHERE (m.CUSTOMERACCNO = am.account_number
                        OR m.customeraccno_enc =am.account_number_enc
                        OR m.CUSTOMERACCNO =am.account_iban
                        OR m.customeraccno_enc =am.account_iban_enc)
                        AND am.institution_id =m.institutionid
                        AND am.ACCOUNT_STATUS='VALIDATED'
                        AND m.MSGDB_ID = p_trn_msgdb_id;

                    EXCEPTION
                    WHEN NO_DATA_FOUND
                    THEN
                      m_CUSTOMERACCNO_valid := 'NO';
                      NULL;
                    WHEN OTHERS
                    THEN
                      m_CUSTOMERACCNO_valid := 'NO';
                      NULL;
                    END;

                END IF;




    --DBMS_OUTPUT.put_line ('PRIORITYAMOUNTNUM '|| m_priorityamountnum );
    --DBMS_OUTPUT.put_line ('start date : ' || m_prioritydate);
    --DBMS_OUTPUT.put_line ('end date : ' || m_prioritydate);



     IF INSTR(m_tenant_list,m_tenantname) > 0
    THEN
        SELECT balances
        INTO m_curr_balance
        FROM TABLE (GET_ACCOUNT_BALANCES_for_disposition_check (m_prioritydate,
                                        m_prioritydate,
                                        m_account_number_enc,
                                        p_institutionid,
                                        'B'
                                       )
                         );
    ELSE
        SELECT balances
        INTO m_curr_balance
        FROM TABLE (GET_ACCOUNT_BALANCES_for_disposition_check (m_prioritydate,
                                        m_prioritydate,
                                        m_account_number,
                                        p_institutionid,
                                        'B'
                                       )
                         );
    END IF;

    --DBMS_OUTPUT.put_line (' m_curr_balance : ' || m_curr_balance );

    IF m_curr_balance IS NULL
    THEN
      m_curr_balance := 0;
    END IF;

    --DBMS_OUTPUT.put_line ('m_priorityamountnum : ' || m_priorityamountnum );

    --m_remaining_booked_balance :=  m_curr_balance - n_msgdb_record (i).priorityamountnum;

    ----DBMS_OUTPUT.put_line  ('m_remaining_booked_balance : ' || m_remaining_booked_balance);

    ----DBMS_OUTPUT.put_line ( 'Threshold amount : ' || m_min_threshold_balance);

    --DBMS_OUTPUT.put_line ( 'm_disposition_check : ' || m_disposition_check);


        IF m_priorityamountnum > m_curr_balance   AND m_CUSTOMERACCNO_valid = 'YES'-- checking threshold amount is greater than  remaing account balance .
        THEN
            --DBMS_OUTPUT.put_line ( 'm_tenantname : '||m_tenantname);
            m_queueid_status := getstringitemwithsep(td_get_value(m_tenantname, p_queueid||'-'||p_status||'-F'),1,',');
            --DBMS_OUTPUT.put_line ( 'm_queueid_status : '||m_queueid_status);
            m_queueid := getstringitemwithsep(m_queueid_status,1,'-');
            --DBMS_OUTPUT.put_line ( 'm_queueid : '||m_queueid);
            m_status  := getstringitemwithsep(m_queueid_status,2,'-');
            --DBMS_OUTPUT.put_line ( 'm_status : '||m_status);


            BEGIN
                SELECT m.msg_family,ms.message
                INTO m_msg_Family,m_message_blob
                FROM MSGBLOCKS ms, msgdb m
                WHERE ms.msgdb_id = m.msgdb_id
                AND ms.msgdb_id   = p_trn_msgdb_id
                AND ms.msgblocktype = m_msgblocktype;

                m_message_clob:= convertTOclob(m_message_blob);
                m_block := 'Y';
                --DBMS_OUTPUT.put_line('m_block '|| m_block);
                --DBMS_OUTPUT.put_line('m_msg_Family '|| m_msg_Family);
            EXCEPTION
            WHEN OTHERS
            THEN
                ----DBMS_OUTPUT.put_line('Not an XML');
                --DBMS_OUTPUT.put_line ('OTHERS...'|| SQLCODE|| SQLERRM|| DBMS_UTILITY.format_error_backtrace);
                m_block:= NULL;
                m_xml := 'N';
            END;

            IF m_block = 'Y'
            THEN
                BEGIN
                    m_xtype := XMLTYPE(xmlData=>m_message_clob);
                    --DBMS_OUTPUT.put_line('XML present '|| m_block);
                EXCEPTION
                WHEN OTHERS
                THEN
                    m_xml := 'N';
                    ----DBMS_OUTPUT.put_line('Not an XML : ' || m_xml);
                    --DBMS_OUTPUT.put_line ('OTHERS...'|| SQLCODE|| SQLERRM|| DBMS_UTILITY.format_error_backtrace);

                END;
            END IF;

            --DBMS_OUTPUT.put_line('m_xml : ' || m_xml);


            select NVL(comments,'')
            into m_Comments
            FROM MSGDB
            WHERE msgdb_id=p_trn_msgdb_id;

            --DBMS_OUTPUT.put_line('m_Comments '|| m_Comments);
            --DBMS_OUTPUT.put_line('m_xml ------------------'|| m_xml);
            --DBMS_OUTPUT.put_line('m_msg_Family  '|| m_msg_Family);
            --DBMS_OUTPUT.put_line('m_xml_field  '|| m_xml_field);
            --DBMS_OUTPUT.put_line('m_swift_field  '|| m_swift_field);
            --DBMS_OUTPUT.put_line('m_error_code  '|| m_error_code);

            UPDATE msgdb
            SET     queueid = m_queueid,
                    processing_stage = get_queue_stage(p_institutionid,m_queueid),
                    status = m_status,
                    prevqueueid = queueid,
                    lockedby               = NULL,
                    repairedby             = NULL,
                    releasedby             = NULL,
                    authorizedby           = NULL,
                    forwardedby            = NULL,
                    operator               = NULL,
                    stachemmessageflag     = NULL,
                    lockstatus              = NULL,
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
            WHERE   msgdb_id = p_trn_msgdb_id;

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

                --DBMS_OUTPUT.put_line ( 'APPENDED');

                m_message_blob:= clob_to_blob(m_message_clob);

                --DBMS_OUTPUT.put_line ( 'CONVERTED');
                UPDATE MSGBLOCKS
                                    SET MESSAGE   = m_message_blob,
                                        AUTHCODE  = Generatehmacsha256data(convertTOclob(m_message_blob),m_secretkey),
                                        KEY_ID    = m_key
                WHERE MSGDB_ID=p_trn_msgdb_id
                AND msgblocktype = m_msgblocktype;

                --DBMS_OUTPUT.put_line ( 'UPDATED');
            END IF;

            --DBMS_OUTPUT.put_line ( 'INSIDE IF');

            RAISE insufficient_balance;
        ELSE
            --DBMS_OUTPUT.put_line ( 'INSIDE ELSE');
            transaction_queue_routing
                                    (
                                        p_institutionid,
                                        p_trn_msgdb_id,
                                        p_user_action_flag,
                                        NULL,
                                        --NULL,
                                        p_userid,
                                        p_queueid,
                                        p_status,
                                        NULL,
                                        p_return_code
                                    );
        END IF;

    ELSE
        DBMS_OUTPUT.put_line ( 'INSIDE ELSE Disposition check no');
        transaction_queue_routing
                                    (
                                        p_institutionid,
                                        p_trn_msgdb_id,
                                        p_user_action_flag,
                                        NULL,
                                        --NULL,
                                        p_userid,
                                        p_queueid,
                                        p_status,
                                        NULL,
                                        p_return_code
                                    );
    END IF;

EXCEPTION
    WHEN TXN_REJECT
    THEN
         --DBMS_OUTPUT.put_line (' PAYMENT IS REJECTED.');
         NULL;
    WHEN insufficient_balance
    THEN
        --DBMS_OUTPUT.put_line (' BALANCE IS NOT SUFFICIENT.');
        g_audittext := 'Disposition check failed for transaction number <' || g_messageno || '> and moved to Queue ''' || m_queueid||''' from Queue '''||p_queueid||'''';

        genaudit_insert_enchash_wrap
            (
            p_messageno=>g_messageno,
            p_queueid=>m_queueid,
            p_username=>'ADMIN',
            p_application=>g_application,
            p_modulename=>g_modulename,
            p_action=>g_action,
            p_audittext=>g_audittext,
            p_institutionid=>p_institutionid,
            p_incr_count=>0
            );
    /*WHEN NO_DATA_FOUND
    THEN
        --DBMS_OUTPUT.put_line ('No data found.');*/

    WHEN OTHERS
    THEN
      --DBMS_OUTPUT.put_line ('OTHERS...'|| SQLCODE|| SQLERRM|| DBMS_UTILITY.format_error_backtrace);
    NULL;
END; 