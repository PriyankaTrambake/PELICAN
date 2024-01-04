create or replace PROCEDURE          disposition_check
(
    p_queueid     IN       msgdb.queueid%TYPE, --DSPMSGQ1
    p_status      IN       msgdb.status%TYPE, --69
    p_data_keyid_list       IN      VARCHAR2 DEFAULT NULL,
    p_data_key_list         IN      VARCHAR2 DEFAULT NULL
   -- p_exception   IN OUT   msgdb.exceptiontype%TYPE
)
IS

    m_queueid                       MSGDB.queueid%TYPE                                  := NULL;
    m_status                        MSGDB.status%TYPE                                   := NULL;
    a_msgdb_record                  msgdb%ROWTYPE;
    m_ctr_beg                       NUMBER                                              := 0;
    m_ctr_end                       NUMBER                                              := 0;
    m_exception                     VARCHAR2 (100)                                      := NULL;
    m_remaining_booked_balance      account_balance.stmt_closing_booked_balance%TYPE    := 0;
    m_min_threshold_balance         NUMBER                                              := 0;
    m_tenantname                    INSTITUTIONPARAMETERS.PARAMVALUE%TYPE               := NULL;
    m_queueid_status                TABLEDETAILS.tdkey%TYPE                             := NULL;
    m_disposition_check             TABLEDETAILS.tdvalue%TYPE                           := NULL;
    m_td_key                        TABLEDETAILS.tdkey%TYPE                             := 'DISPOSITION_CHK';
    m_stmt_closing_booked_balance   account_balance.stmt_closing_booked_balance%TYPE    := NULL;
    m_curr_balance                  account_balance.stmt_closing_booked_balance%TYPE    := NULL;
    m_tdvalue                       TABLEDETAILS.tdvalue%TYPE                           := NULL;
    p_return_code                   NUMBER                                              := NULL;
    g_application                   genaudit.APPLICATION%type                           := 'PELICAN';
    g_modulename                    genaudit.MODULENAME%type                            := 'EVENTSRVR';
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
    m_keyid                         GENAUDIT.keyid%TYPE             := NULL;
    m_secretkey                     VARCHAR2(32767)                 := NULL;
    m_key                           VARCHAR2(100)                   := 'PELICAN_INTERNAL_KEY_ID';
    m_decrypt                       VARCHAR2(32664)                         := 'DECRYPT';
    m_encrypt                       VARCHAR2(32664)                         := 'ENCRYPT';
    m_tenant_list                   VARCHAR2(32664)     := NULL;
    m_context_name                  VARCHAR2(32664)                         := NULL;
    -----EXCEPTION DECLARATION
    insufficient_balance            EXCEPTION;
    m_CUSTOMERACCNO                     MSGDB.CUSTOMERACCNO%TYPE                     :=NULL;
    m_CUSTOMERACCNO_enc                     MSGDB.CUSTOMERACCNO_enc%TYPE                     :=NULL;
    m_CUSTOMERACCNO_valid                      VARCHAR2 (50 Byte)                     :='YES';

    CURSOR c_institutions IS
    SELECT DISTINCT institutionid FROM MSGDB
    WHERE queueid =   p_queueid
    AND   status  =   p_status;

    CURSOR cur_msgdb(c_institutionid IN MSGDB.institutionid%TYPE,c_tenant IN INSTITUTIONPARAMETERS.paramname%TYPE)
    IS
    SELECT m.queueid,
           m.msgdb_id,
           m.institutionid,
           m.status,
           m.priorityamountnum,
           UPPER(REPLACE(SUBSTR(m.messageclasstype,1,8),'.',''))||'|'||m.messagedirection||
           '|'||c_tenant||'|'||m.transactiongroup||'|'||m.transactiontype||'|'||m.msg_family   as tdkey,
           --m.customeraccno,
           m.prioritydate,
           am.account_number,
           am.account_number_enc,
           m.messageno
           --inputdate
    FROM msgdb m,account_master am
    WHERE m.queueid = p_queueid
    AND m.status = p_status
    AND (m.customeraccno = am.account_iban OR m.customeraccno_enc = am.account_iban_enc)
    AND am.account_status = 'VALIDATED'
    AND m.institutionid  = c_institutionid
    AND am.institution_id =m.institutionid;

    CURSOR cur_msgdb_nostro(c_institutionid IN MSGDB.institutionid%TYPE,c_tenant IN INSTITUTIONPARAMETERS.paramname%TYPE)
    IS
    SELECT m.queueid,
           m.msgdb_id,
           m.institutionid,
           m.status,
           m.priorityamountnum,
           --m.customeraccno,
           UPPER(REPLACE(SUBSTR(m.messageclasstype,1,8),'.',''))||'|'||m.messagedirection||'|'||c_tenant||
           '|'||m.transactiongroup||'|'||m.transactiontype||'|'||m.msg_family   as tdkey,
           m.prioritydate,
           am.account_number,
           am.account_number_enc,
           m.messageno
           --inputdate
    FROM msgdb m,account_master am
    WHERE m.queueid = p_queueid
    AND m.status = p_status
    AND (m.nostro_account_number = am.account_number_enc
    OR m.nostro_account_number = am.account_number)
    AND am.account_status = 'VALIDATED'
    AND m.institutionid  = c_institutionid
    AND am.institution_id =m.institutionid;

    TYPE t_institutions IS TABLE OF c_institutions%ROWTYPE;
    a_institutions t_institutions := t_institutions();

    TYPE a_msgdb IS TABLE OF cur_msgdb%ROWTYPE;
    n_msgdb_record      a_msgdb          := a_msgdb();

BEGIN
    
    plcn_security_pkg.fetch_data_key(p_data_keyid_list,p_data_key_list);
    Getkeyidandsecretkey (m_keyid,m_secretkey);

    OPEN c_institutions;
    FETCH c_institutions  BULK COLLECT INTO a_institutions;
    CLOSE c_institutions;
    FOR rec IN a_institutions.FIRST .. a_institutions.LAST
    LOOP

        -- FETCH  TENANT_NAME  FROM INSTITUTIONPARAMETER
        m_tenantname := get_institution_param_value(
                                                    a_institutions (rec).institutionid,
                                                    'INSTITUTION_DETAILS',
                                                    'TENANT_NAME'
                                                    );

        --m_disposition_check := td_get_value (m_tenantname, m_td_key);
            BEGIN 

                  SELECT TDVALUE
                  INTO m_context_name
                  FROM TABLEDETAILS 
                  WHERE TDIDCODE ='CONTEXT' 
                  AND 
                  TDKEY = m_tenantname ;
                        DBMS_OUTPUT.PUT_LINE('m_context_name -->'||m_context_name);

              EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN

                       DBMS_OUTPUT.PUT_LINE ('No CONTEXT found ');
            END;

        m_tenant_list := sys_context(m_context_name,'ENCRYPTION_TENANT_LIST');


        m_disposition_check :=  get_institution_param_value(
                                                    a_institutions (rec).institutionid,
                                                    'BALANCE_MANAGEMENT',
                                                    'DISPOSITION_CHECK'
                                                    );

        m_tdvalue    := NVL(TD_GET_VALUE(m_tenantname,'ACCOUNT_REF'),'XX');

        IF m_tdvalue = 'NOSTRO_ACCOUNT_NUMBER'
        THEN
            DBMS_OUTPUT.put_line ('in NOSTRO_ACCOUNT_NUMBER');
            OPEN cur_msgdb_nostro(a_institutions(rec).institutionid,m_tenantname);
            FETCH cur_msgdb_nostro BULK COLLECT INTO n_msgdb_record LIMIT 10000;
        ELSE
            OPEN cur_msgdb(a_institutions(rec).institutionid,m_tenantname);
            FETCH cur_msgdb BULK COLLECT INTO n_msgdb_record LIMIT 10000;
        END IF;

        IF m_disposition_check = 'YES'
        THEN


            LOOP
                BEGIN

                    m_ctr_beg := NVL(n_msgdb_record.FIRST,0);
                    m_ctr_end := NVL(n_msgdb_record.LAST,0);

                    DBMS_OUTPUT.put_line ('m_ctr_beg : ' || m_ctr_beg);
                    DBMS_OUTPUT.put_line ('m_ctr_end : ' || m_ctr_end);

                    FOR i IN m_ctr_beg..m_ctr_end

                    LOOP
                        BEGIN
                                 IF TD_GET_VALUE(m_tenantname,n_msgdb_record (i).tdkey)  IN( 'I', 'IO')
                                 THEN

                                    BEGIN
                                        SELECT am.account_number,am.account_number_enc
                                        INTO m_CUSTOMERACCNO,m_CUSTOMERACCNO_ENC
                                        FROM account_master am , msgdb m
                                        WHERE (m.CUSTOMERACCNO = am.account_number
                                        OR m.customeraccno_enc =am.account_number_enc
                                        OR m.CUSTOMERACCNO =am.account_iban
                                        OR m.customeraccno_enc =am.account_iban_enc)
                                        AND am.institution_id =m.institutionid
                                        AND am.ACCOUNT_STATUS='VALIDATED'
                                        AND m.MSGDB_ID = n_msgdb_record(i).msgdb_id;

                                        n_msgdb_record (i).account_number := m_CUSTOMERACCNO;
                                        n_msgdb_record (i).account_number_enc := m_CUSTOMERACCNO_ENC;

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
                            --DBMS_OUTPUT.PUT_LINE ('PRIORITYAMOUNTNUM '|| n_msgdb_record (i).priorityamountnum );
                            --DBMS_OUTPUT.PUT_LINE ('start date : ' || n_msgdb_record (i).prioritydate);
                            --DBMS_OUTPUT.PUT_LINE ('end date : ' || n_msgdb_record (i).prioritydate);



                            IF INSTR(m_tenant_list,m_tenantname) > 0
                            THEN
                                DBMS_OUTPUT.PUT_LINE ('IF ');
                                DBMS_OUTPUT.PUT_LINE ('n_msgdb_record (i).account_number_enc ' ||n_msgdb_record (i).account_number_enc);
                                SELECT balances
                                INTO m_curr_balance
                                FROM TABLE (GET_ACCOUNT_BALANCES_for_disposition_check (n_msgdb_record (i).prioritydate,
                                                                    n_msgdb_record (i).prioritydate,
                                                                    n_msgdb_record (i).account_number_enc,
                                                                    n_msgdb_record (i).institutionid,
                                                                    'B',
                                                                    p_data_keyid_list,
                                                                    p_data_key_list
                                                                   )
                                           );
                            ELSE
                                  DBMS_OUTPUT.PUT_LINE ('ELSE');
                                 SELECT balances
                                  INTO m_curr_balance
                                  FROM TABLE (GET_ACCOUNT_BALANCES_for_disposition_check
                                  (n_msgdb_record (i).prioritydate,
                                                                    n_msgdb_record (i).prioritydate,
                                                                    n_msgdb_record (i).account_number,
                                                                    n_msgdb_record (i).institutionid,
                                                                    'B'
                                                                   )
                                             );
                            END IF;
                            DBMS_OUTPUT.put_line (' m_curr_balance : ' || m_curr_balance );

                            IF m_curr_balance IS NULL
                            THEN
                              m_curr_balance := 0;
                            END IF;

                            DBMS_OUTPUT.put_line ('n_msgdb_record (i).priorityamountnum : ' || n_msgdb_record (i).priorityamountnum );

                            --m_remaining_booked_balance :=  m_curr_balance - n_msgdb_record (i).priorityamountnum;

                            --DBMS_OUTPUT.put_line  ('m_remaining_booked_balance : ' || m_remaining_booked_balance);

                            --DBMS_OUTPUT.put_line ( 'Threshold amount : ' || m_min_threshold_balance);

                            DBMS_OUTPUT.put_line ( 'm_disposition_check : ' || m_disposition_check);

                            --IF RTRIM (m_disposition_check) = 'YES'
                            --THEN
                                IF n_msgdb_record (i).priorityamountnum > m_curr_balance AND m_CUSTOMERACCNO_valid = 'YES'--AND TD_GET_VALUE(m_tenantname,n_msgdb_record (i).tdkey) NOT IN( 'I', 'IO')  -- checking threshold amount is greater than  remaing account balance .
                                --IF n_msgdb_record (i).priorityamountnum > m_curr_balance AND TD_GET_VALUE(m_tenantname,n_msgdb_record (i).tdkey) NOT IN( 'I', 'IO')  -- checking threshold amount is greater than  remaing account balance .
                                THEN
                                    m_queueid_status := NVL(td_get_value(m_tenantname, p_queueid||'-'||p_status||'-F'),m_queueid);
                                    m_queueid := getstringitemwithsep(m_queueid_status,1,'-');
                                    m_status  := getstringitemwithsep(m_queueid_status,2,'-');

                                    BEGIN
                                        SELECT m.msg_family,ms.message
                                        INTO m_msg_Family,m_message_blob
                                        FROM MSGBLOCKS ms, msgdb m
                                        WHERE ms.msgdb_id = m.msgdb_id
                                        AND ms.msgdb_id   = n_msgdb_record (i).msgdb_id
                                        AND msgblocktype = m_msgblocktype;

                                        m_message_clob:= convertTOclob(m_message_blob);
                                        m_block := 'Y';
                                        DBMS_OUTPUT.put_line('m_block '|| m_block);
                                        DBMS_OUTPUT.put_line('m_msg_Family '|| m_msg_Family);
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

                                    select NVL(comments,'')
                                    into m_Comments
                                    FROM MSGDB
                                    WHERE msgdb_id=n_msgdb_record (i).msgdb_id;

                                    DBMS_OUTPUT.put_line('m_Comments '|| m_Comments);
                                    DBMS_OUTPUT.put_line('m_xml '|| m_xml);
                                    DBMS_OUTPUT.put_line('m_msg_Family  '|| m_msg_Family);
                                    DBMS_OUTPUT.put_line('m_xml_field  '|| m_xml_field);
                                    DBMS_OUTPUT.put_line('m_swift_field  '|| m_swift_field);
                                    DBMS_OUTPUT.put_line('m_error_code  '|| m_error_code);

                                    UPDATE msgdb
                                    SET queueid = m_queueid,
                                        status = m_status,
                                        processing_stage = get_queue_stage(a_institutions(rec).institutionid,m_queueid),
                                        prevqueueid = p_queueid,
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
                                    WHERE msgdb_id = n_msgdb_record (i).msgdb_id;
                                    DBMS_OUTPUT.put_line ( 'count updated ' || SQL%ROWCOUNT);
                                    DBMS_OUTPUT.put_line ( 'INSIDE IF');
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
                                                           DBMS_OUTPUT.put_line ( 'APPENDED');
                                        m_message_blob:= clob_to_blob(m_message_clob);
                                        DBMS_OUTPUT.put_line ( 'CONVERTED');
                                        UPDATE MSGBLOCKS
                                        SET MESSAGE  =m_message_blob,
                                            AUTHCODE = Generatehmacsha256data(convertTOclob(m_message_blob),m_secretkey),
                                            KEY_ID    = m_key
                                        WHERE MSGDB_ID=n_msgdb_record (i).msgdb_id
                                        AND msgblocktype = m_msgblocktype;
                                        DBMS_OUTPUT.put_line ( 'UPDATED');
                                    END IF;




                                    RAISE insufficient_balance;
                                ELSE
                                    DBMS_OUTPUT.put_line ( 'INSIDE ELSE');
                                    transaction_queue_routing
                                                            (
                                                                n_msgdb_record (i).institutionid,
                                                                n_msgdb_record (i).msgdb_id,
                                                                'V',
                                                                NULL,
                                                                NULL,
                                                                p_queueid,
                                                                p_status,
                                                                NULL,
                                                                p_return_code
                                                            );
                                END IF;

                            --END IF;

                        EXCEPTION

                        WHEN insufficient_balance
                        THEN
                            DBMS_OUTPUT.put_line (' BALANCE IS NOT SUFFICIENT.');
                            g_audittext := 'Disposition check failed for transaction number <' || n_msgdb_record (i).messageno || '> and moved to Queue ''' || m_queueid||''' from Queue '''||p_queueid||'''';

                            genaudit_insert_enchash_wrap
                                (
                                p_messageno=>n_msgdb_record (i).messageno,
                                p_queueid=>p_queueid,
                                p_username=>'ADMIN',
                                p_application=>g_application,
                                p_modulename=>g_modulename,
                                p_action=>g_action,
                                p_audittext=>g_audittext,
                                p_institutionid=>a_institutions(rec).institutionid,
                                p_incr_count=>0
                                );
                        WHEN NO_DATA_FOUND
                        THEN
                            DBMS_OUTPUT.put_line ('No data found.');
                           NULL;
                        WHEN OTHERS
                        THEN
                            NULL;
                          DBMS_OUTPUT.put_line ('OTHERS...'|| SQLCODE|| SQLERRM|| DBMS_UTILITY.format_error_backtrace);
                        END;


                        m_CUSTOMERACCNO_valid := 'YES';

                    END LOOP;



                EXCEPTION
                 WHEN OTHERS
                 THEN
                    NULL;
                    DBMS_OUTPUT.put_line ('OTHERS...' || SQLCODE || SQLERRM || DBMS_UTILITY.format_error_backtrace );
                END;
                IF m_tdvalue = 'NOSTRO_ACCOUNT_NUMBER'
                THEN
                    EXIT WHEN cur_msgdb_nostro%NOTFOUND;

                    FETCH cur_msgdb_nostro
                    BULK COLLECT INTO n_msgdb_record LIMIT 10000;
                ELSE
                    EXIT WHEN cur_msgdb%NOTFOUND;

                    FETCH cur_msgdb
                    BULK COLLECT INTO n_msgdb_record LIMIT 10000;
                END IF;
            END LOOP;

            IF cur_msgdb%ISOPEN THEN
                CLOSE cur_msgdb;
            ELSIF cur_msgdb_nostro%ISOPEN THEN
                CLOSE cur_msgdb_nostro;
            END IF;

        ELSE

            LOOP
                BEGIN

                    m_ctr_beg := NVL(n_msgdb_record.FIRST,0);
                    m_ctr_end := NVL(n_msgdb_record.LAST,0);


                    FOR i IN m_ctr_beg..m_ctr_end
                    LOOP
                        BEGIN


                                    DBMS_OUTPUT.PUT_LINE ( 'Disposition check NO');
                                    transaction_queue_routing
                                                            (
                                                                n_msgdb_record (i).institutionid,
                                                                n_msgdb_record (i).msgdb_id,
                                                                'V',
                                                                NULL,
                                                                NULL,
                                                                p_queueid,
                                                                p_status,
                                                                NULL,
                                                                p_return_code
                                                            );


                        EXCEPTION

                        WHEN NO_DATA_FOUND
                        THEN
                            --DBMS_OUTPUT.PUT_LINE ('No data found.');
                           NULL;
                        WHEN OTHERS
                        THEN
                            NULL;
                          --DBMS_OUTPUT.PUT_LINE ('OTHERS...'|| SQLCODE|| SQLERRM|| DBMS_UTILITY.format_error_backtrace);
                        END;


                    END LOOP;



                EXCEPTION
                 WHEN OTHERS
                 THEN
                    NULL;
                    --DBMS_OUTPUT.PUT_LINE ('OTHERS...' || SQLCODE || SQLERRM || DBMS_UTILITY.format_error_backtrace );
                END;
                IF m_tdvalue = 'NOSTRO_ACCOUNT_NUMBER'
                THEN
                    EXIT WHEN cur_msgdb_nostro%NOTFOUND;

                    FETCH cur_msgdb_nostro
                    BULK COLLECT INTO n_msgdb_record LIMIT 10000;
                ELSE
                    EXIT WHEN cur_msgdb%NOTFOUND;

                    FETCH cur_msgdb
                    BULK COLLECT INTO n_msgdb_record LIMIT 10000;
                END IF;
            END LOOP;

            IF cur_msgdb%ISOPEN THEN
                CLOSE cur_msgdb;
            ELSIF cur_msgdb_nostro%ISOPEN THEN
                CLOSE cur_msgdb_nostro;
            END IF;

        END IF;

    END LOOP;


EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
        NULL;
      DBMS_OUTPUT.put_line ('No data found ');

    WHEN OTHERS
    THEN
        NULL;
      DBMS_OUTPUT.put_line ('OTHERS...'|| SQLCODE|| SQLERRM|| DBMS_UTILITY.format_error_backtrace);

END; 