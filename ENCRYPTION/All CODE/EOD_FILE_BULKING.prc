create or replace PROCEDURE          EOD_FILE_BULKING
(
    p_queueid     IN      msgdb.queueid%TYPE,                              -- Queueid for newly generated file
    p_status      IN      msgdb.status%TYPE,
    p_instanceid  IN      MSGDB.instanceid%TYPE
)
AS
    m_format                            VARCHAR2(100)                           := NULL;
    m_hiphen                            VARCHAR2(10)                            := NULL;
    m_companycodes                      VARCHAR2(100)                           := NULL;
    m_format_cc                         VARCHAR2(100)                           := NULL;
    m_files_config                      VARCHAR2(100)                           := NULL;
    m_number_files                      VARCHAR2(100)                           := NULL;
    m_trans_msgdbid_char                VARCHAR2(1000)                          := 0;
    m_msgdb_output_format               VARCHAR2(1000)                          := 0;
    m_companycode_loop_ctr              NUMBER                                  := 0;
    m_td_end                            NUMBER                                  := 0;
    m_msgdb_id_length                   NUMBER                                  := 0;
    m_output_report                     BLOB;
    m_msgdbid_list                      CLOB;
    m_eod_conf                          TABLEDETAILS.TDVALUE%TYPE;
    m_tdidcode                          TABLEDETAILS.TDIDCODE%TYPE              := 'EODREP_CONF';
    m_tdkey                             TABLEDETAILS.TDKEY%TYPE                 := 'EOD';
    m_trans_msgdbid                     MSGDB.msgdb_id%TYPE                     := 0;
    m_record_group_type                 MSGDB.RECORD_GROUP_TYPE%TYPE            := NULL;
    m_newfile_msgdb_id                  MSGDB.msgdb_id%TYPE                     := NULL;
    m_messageno                         MSGDB.messageno%TYPE                    := 0;
    m_total_amount                      MSGDB.PRIORITYAMOUNTNUM%TYPE            := 0;
    m_institutionid                     MSGDB.institutionid%type                := NULL;--INSTITUTION TO BE taken from BI
    m_filename                          MSGDB_FILE.MDBFL_FILENAME%TYPE          := NULL;
    m_file_tran_count                   MSGDB_FILE.mdbfl_num_of_msgs%TYPE       := 0;
    m_filesize                          MSGDB_FILE.mdbfl_filesize%TYPE          := NULL;
    m_tenantname                        INSTITUTIONPARAMETERS.PARAMVALUE%TYPE   := NULL;
    m_paramname                         INSTITUTIONPARAMETERS.PARAMNAME%TYPE    := 'TENANT_NAME';
    m_path                              INSTITUTIONPARAMETERS.PATH%TYPE         := 'INSTITUTION_DETAILS';
    m_inst_paramvalue                   INSTITUTIONPARAMETERS.PARAMVALUE%TYPE   := NULL;
    m_messageclasstype                  MSGDB.messageclasstype%TYPE             := 'UNKNOWN';
    m_return_msgsegr                    MSGDB.msgsegr%TYPE                      := NULL;
    m_transactiongroup                  MSGDB.transactiongroup%TYPE             := NULL;
    m_time                              VARCHAR2(15);
    m_msgid                             VARCHAR2(50)                                := NULL;
    
    TYPE a_msgdb_id        IS TABLE OF MSGDB.msgdb_id%TYPE;
    t_msgdb_id              a_msgdb_id          := a_msgdb_id();

    CURSOR cursor_institution
    IS
    SELECT      INSTITUTIONID
    FROM        institutionmaster
    WHERE institutionid IN (
                        SELECT institutionid 
                        FROM institutionparameters 
                        WHERE PARAMVALUE IN ('Y','N')
                        AND PATH         = 'MESSAGE_PROCESSING.FUNCTIONALITY.BULKING_CHECK.BASED_ON_PARENT_INSTITUTION'
                        AND PARAMNAME    = 'BULKING_CHECK');

BEGIN
    m_eod_conf  :=  td_get_value(m_tdidcode,m_tdkey);
    m_td_end  := length(m_eod_conf) - length(replace(m_eod_conf,'|',null))+1;
    
    FOR c IN 1..m_td_end
    LOOP
        BEGIN
            FOR rec IN cursor_institution
            LOOP
                
                    m_institutionid  := rec.institutionid;
                    
                    --F001|F0011-043,044|F003-043,044,001|F005-043,044,001|F007-043,044,001
                    
                    m_files_config :=  getstringitemwithsep(m_eod_conf,c,'|');
                    
                    --m_number_files := getstringitemwithsep(getstringitemwithsep(m_eod_conf,c,'|'), 2, '-');
                    
                    ----DBMS_OUTPUT.PUT_LINE ('m_format : ' || m_format);                    
                    m_hiphen := INSTR(m_files_config, '-');
                    
                    IF m_hiphen > 0
                    THEN  
                        m_format := getstringitemwithsep(m_files_config,1,'-'); 
                        m_companycodes := getstringitemwithsep(m_files_config,2,'-');
                    ELSE
                        m_format := m_files_config;
                        m_companycodes := '001';    
                        
                    END IF;
                    --DBMS_OUTPUT.PUT_LINE ('m_format : ' || m_format); 
                    --DBMS_OUTPUT.PUT_LINE ('m_companycodes : ' || m_companycodes);
                    
                    m_companycode_loop_ctr  := length(m_companycodes) - length(replace(m_companycodes,',',null))+1;
                    
                    --DBMS_OUTPUT.PUT_LINE ('m_companycode_loop_ctr : ' || m_companycode_loop_ctr);
                    FOR d IN 1..m_companycode_loop_ctr
                    LOOP
                        BEGIN 
                            SELECT DECODE(m_format, 'F0011', getstringitemwithsep(m_companycodes,d,','), '001')
                            INTO m_format_cc
                            FROM DUAL;
                      
                            --DBMS_OUTPUT.PUT_LINE ('m_institutionid : '||m_institutionid||' | '||m_format || '|' || m_format_cc || '|' || m_companycode_loop_ctr);

                            IF m_format IN ('F001')
                            THEN
                                --DBMS_OUTPUT.PUT_LINE ('generate_eod_sap_report : ');
                                generate_eod_sap_report
                                (
                                    p_mode              =>  m_format,
                                    p_output_report     =>  m_output_report,
                                    p_msgdbid_list      =>  m_msgdbid_list,
                                    p_total_amount      =>  m_total_amount,
                                    p_institutionid     =>  m_institutionid,
                                    p_inst_paramvalue   =>  m_inst_paramvalue,
                                    p_company_code      =>  m_format_cc,
                                    p_return_msgsegr    =>  m_return_msgsegr,
                                    p_time              =>  m_time

                                );
                            
                            ELSIF m_format IN ('F0011')
                            THEN
                            
                                generate_eod_sub_sap_report
                                (
                                    p_mode              =>  m_format,
                                    p_output_report     =>  m_output_report,
                                    p_msgdbid_list      =>  m_msgdbid_list,
                                    p_total_amount      =>  m_total_amount,
                                    p_institutionid     =>  m_institutionid,
                                    p_inst_paramvalue   =>  m_inst_paramvalue,
                                    p_company_code      =>  m_format_cc,
                                    p_return_msgsegr    =>  m_return_msgsegr,
                                    p_time              =>  m_time

                                );
                            ELSE
                                generate_eod_reports
                                (
                                    p_mode              =>  m_format,
                                    p_output_report     =>  m_output_report,
                                    p_msgdbid_list      =>  m_msgdbid_list,
                                    p_total_amount      =>  m_total_amount,
                                    p_institutionid     =>  m_institutionid,
                                    p_inst_paramvalue   =>  m_inst_paramvalue,
                                    p_company_code      =>  m_format_cc,
                                    p_return_msgsegr    =>  m_return_msgsegr,
                                    p_time              =>  m_time
                                );
                            END IF;                     
                            --DBMS_OUTPUT.PUT_LINE('OUTSIDE : ' || m_msgdbid_list);
                            --DBMS_OUTPUT.PUT_LINE('OUTSIDE : ' || dbms_lob.getlength(m_msgdbid_list));
                            m_msgdb_id_length := NVL(dbms_lob.getlength(m_msgdbid_list), 0);
                            
                            IF  m_msgdb_id_length > 0
                            THEN
                            
                                m_file_tran_count := length(m_msgdbid_list) - length(replace(m_msgdbid_list,'|',null))  ;--m_msgdbid_list
                                
                                --DBMS_OUTPUT.PUT_LINE('EOD FILE BULKING : OUT m_msgdbid_list : '||m_msgdbid_list);
                                --DBMS_OUTPUT.PUT_LINE('EOD FILE BULKING : OUT m_file_tran_count : '||m_file_tran_count);

                                IF NVL(m_file_tran_count,0) = 0
                                THEN
                                    RAISE NO_DATA_FOUND;
                                END IF;

                                m_newfile_msgdb_id  := msgdb_seq.NEXTVAL;
                                m_filesize      := DBMS_LOB.getlength(m_output_report);
                                m_messageno     := 'F' || LPAD(msgdb_messageno.NEXTVAL,11,'0');
                                m_transactiongroup := get_trnx_group (m_messageclasstype, 0);
                                --DBMS_OUTPUT.PUT_LINE('m_newfile_msgdb_id : '||m_newfile_msgdb_id);
                                --DBMS_OUTPUT.PUT_LINE('m_filesize : '||m_filesize);
                                --DBMS_OUTPUT.PUT_LINE('DETAILS : '||m_total_amount||'|'||m_file_tran_count||'|'||m_messageno);
                                --/*
                                --inserting into msgdb table
                                INSERT INTO msgdb
                                    (MSGDB_ID,QUEUEID,STATUS,MESSAGENO,
                                    INPUTTIME,INPUTDATE,CURRQUEUEINDATE,
                                    RECORD_GROUP_TYPE,DISPLAY_FLAG,PROCESSING_STAGE,INSTANCEID,COMPANY_CODE, 
                                    INPUTDATETIME,INSTITUTIONID,MESSAGECLASSTYPE,
                                    PRIORITYAMOUNTNUM,PRIORITYAMOUNT,PRIORITYDATE,
                                    NUMOFMESSAGES,CURRQUEUEINTIME,MESSAGEDIRECTION,CUSTOMERACCNO,MSG_FAMILY, TRANSACTIONGROUP, msgsegr,
                                    sender, receiver
                                    )
                                VALUES(m_newfile_msgdb_id,p_queueid,p_status,m_messageno,
                                    TO_CHAR(SYSDATE,'HHMISS'),TO_CHAR(SYSDATE,'YYYYMMDD'),TO_CHAR(SYSDATE,'YYYYMMDD'),
                                    'F','Y',NULL,p_instanceid,m_format_cc,
                                    SYSDATE,m_institutionid,m_messageclasstype,
                                    m_total_amount,to_char(m_total_amount),TO_CHAR(SYSDATE,'YYYYMMDD'),
                                    null,TO_CHAR(SYSDATE,'HHMISS'),'I',NULL,'RECORD', m_transactiongroup, m_return_msgsegr,
                                    m_institutionid, m_institutionid
                                    );
                               
                                m_tenantname   := NVL(Get_Institution_Param_Value(m_institutionid,m_path,m_paramname),'XXX');
                                m_msgId     := get_msgid(m_newfile_msgdb_id,m_tenantname,'SEPA_MSGID_'||m_messageclasstype||'_'||'I');
                                
                                UPDATE MSGDB SET TRANSREFNO = m_msgId
                                WHERE MSGDB_ID = m_newfile_msgdb_id;

                                FOR j IN 1..NVL(m_file_tran_count,0)
                                LOOP
                                    BEGIN
                                        IF m_file_tran_count = 0
                                        THEN
                                            EXIT;
                                        END IF;
                                        
                                        m_trans_msgdbid_char   :=     NVL(TRIM(getstringitemwithsepclob(m_msgdbid_list,j,'|')),m_msgdbid_list);
                                        
                                        m_trans_msgdbid         := to_number(m_trans_msgdbid_char);
                                        --DBMS_OUTPUT.PUT_LINE(' m_trans_msgdbid: '||m_trans_msgdbid);

                                        select NVL(RECORD_GROUP_TYPE,'M') into m_record_group_type from msgdb where msgdb_id = m_trans_msgdbid;
                                        --inserting into msgdb_links table
                                        INSERT INTO MSGDB_LINKS
                                           (MSGDB_ID, TYPE, PARENT_ID, PARENT_TYPE, ARCH_STATUS,
                                            ARCH_DATE)
                                        VALUES
                                           (m_trans_msgdbid, m_record_group_type , m_newfile_msgdb_id, 'F', NULL,
                                            NULL);
                                            
                                        --DBMS_OUTPUT.PUT_LINE(' m_trans_msgdbid: '||m_trans_msgdbid);
                                        --DBMS_OUTPUT.PUT_LINE(' m_record_group_type : '|| m_record_group_type );
                                        --DBMS_OUTPUT.PUT_LINE(' m_newfile_msgdb_id: '||m_newfile_msgdb_id);
                                        
                                        
                                        SELECT CASE m_format
                                                    WHEN  'F003'
                                                    THEN 'F0031,F0032'
                                                    WHEN  'F005'
                                                    THEN  'F0051,F0052'
                                                    WHEN  'F007'
                                                    THEN  'F0071,F0072'
                                               ELSE m_format
                                               END  
                                        INTO m_msgdb_output_format FROM DUAL ;
                                         
                                      
                                        --UPDATING  MDBOUT_STATUS TO Y
                                        UPDATE MSGDB_OUTPUT SET MDBOUT_STATUS ='Y'
                                        WHERE MSGDB_ID  =   m_trans_msgdbid
                                        AND MDBOUT_MODE IN (SELECT PARA_CODE FROM TABLE(get_code_from_list(m_msgdb_output_format, ',')));
                                        
                                                      
                                          
                                     

                                    EXCEPTION
                                    WHEN OTHERS
                                    THEN
                                        --DBMS_OUTPUT.PUT_LINE ('OTHERS1...'||SQLCODE || SQLERRM || dbms_utility.format_error_backtrace);
                                            genaudit_insert_enchash_wrap
                                            (m_messageno,p_queueid,NULL,'EVNTSRVR','FILE','INSERT','EOD_FILE_BULKING Procedure Error : '
                                            || SQLCODE
                                            || ':'
                                            || SQLERRM
                                            || dbms_utility.format_error_backtrace,
                                            m_institutionid,
                                            0
                                            );
                                            COMMIT;
                                    END;

                                END LOOP;

                                                    --inserting into msgdb_file table3
                                --m_tenantname   := NVL(Get_Institution_Param_Value(m_institutionid,m_path,m_paramname),'XXX');

                                /*
                                SELECT get_bulk_filename(
                                                            DECODE(m_format,'F0011', m_tenantname||'SP', 'F001', m_tenantname||'SP' , m_tenantname || 'CR'),
                                                            m_newfile_msgdb_id,
                                                            m_format_cc,
                                                            DECODE(m_format, 'F0011', 'F001',m_format ))
                                INTO m_filename
                                FROM DUAL;
                                */
                                SELECT get_tenantwise_filename_eod(
                                                                    NULL,
                                                                    m_newfile_msgdb_id,
                                                                    'EOD',
                                                                    DECODE(m_format, 'F0011', 'F001',m_format ),
                                                                    m_tenantname,
                                                                    0
                                                                   )
                                INTO m_filename
                                FROM DUAL;
                               IF m_format in ('F003','F005','F007')
                               THEN
                                    --DBMS_OUTPUT.PUT_LINE ('IF : ');

                                    --m_filename := REPLACE(m_filename , SUBSTR(m_filename, 6, 8), m_date);
                                    m_filename := REPLACE(m_filename , SUBSTR(m_filename, 15, 6), m_time);
                               ELSE
                                    m_filename := REPLACE(m_filename , SUBSTR(m_filename, 19, 6), m_time);

                               END IF; 
                                
                                --DBMS_OUTPUT.PUT_LINE ('m_newfile_msgdb_id : '||m_newfile_msgdb_id);
                                --DBMS_OUTPUT.PUT_LINE ('m_filename : '|| m_filename);
                                --DBMS_OUTPUT.PUT_LINE ('m_filesize : '|| m_filesize);
                                ----DBMS_OUTPUT.PUT_LINE ('m_output_report : ' || m_output_report);


                                INSERT INTO msgdb_file
                                      (msgdb_id, mdbfl_filename, mdbfl_extension,
                                       mdbfl_filetype, mdbfl_num_of_msgs,
                                       mdbfl_outputfilename, mdbfl_outputfileextension, mdbfl_filesize,
                                       mdbfl_bytestransffred,mdbfl_debulk_flag, mdbfl_set_id, mdbfl_zip_file_name,
                                       mdbfl_file_contents
                                      )
                                VALUES (m_newfile_msgdb_id, m_filename, 'TXT',
                                       'EOD', m_file_tran_count,
                                       m_filename,'TXT', m_filesize,
                                       0,'Y', 0, m_filename,
                                       m_output_report
                                      );

                                genaudit_insert_enchash_wrap
                                (
                                    p_messageno=>m_messageno,
                                    p_queueid=>p_queueid,
                                    p_username=>'EOD_ADMIN',
                                    p_application=>'EVNTSRVR',
                                    p_modulename=>'BULK',
                                    p_action=>'INSERT',
                                    p_audittext=>'EOD FILE bulked with <FILE Name: '''|| m_filename|| '''> and <FILE NUMBER: '''|| m_messageno|| '''> with Queue '''|| p_queueid|| '''',
                                    p_institutionid=>m_institutionid,
                                    p_incr_count=>0
                                );
                            END IF;
                                                        
                        EXCEPTION
                            WHEN NO_DATA_FOUND
                            THEN
                                NULL;
                                --DBMS_OUTPUT.PUT_LINE('INVALID INPUT 1');
                            WHEN OTHERS
                            THEN
                                --DBMS_OUTPUT.PUT_LINE ('OTHERS2...'||SQLCODE || SQLERRM || dbms_utility.format_error_backtrace);
                                    genaudit_insert_enchash_wrap
                                    (m_messageno,p_queueid,NULL,'EVNTSRVR','FILE','INSERT','EOD_FILE_BULKING Procedure Error : '
                                    || SQLCODE
                                    || ':'
                                    || SQLERRM
                                    || dbms_utility.format_error_backtrace,
                                    m_institutionid,
                                    0
                                    );
                                    COMMIT;
                                --DBMS_OUTPUT.PUT_LINE ('OTHERS...'||SQLCODE || SQLERRM || dbms_utility.format_error_backtrace);
                        END;
                        COMMIT;
                    END LOOP;                         
            END LOOP;
        END;
    END LOOP;

EXCEPTION
WHEN NO_DATA_FOUND
THEN
    NULL;
    --DBMS_OUTPUT.PUT_LINE('INVALID INPUT 2');

WHEN OTHERS
THEN
    ROLLBACK;
    --DBMS_OUTPUT.PUT_LINE ('OTHERS...'||SQLCODE || SQLERRM || dbms_utility.format_error_backtrace);
    genaudit_insert_enchash_wrap
    (m_messageno,p_queueid,NULL,'EVNTSRVR','FILE','INSERT','EOD_FILE_BULKING Procedure Error : '
    || SQLCODE
    || ':'
    || SQLERRM
    || dbms_utility.format_error_backtrace,
    m_institutionid,
    0
    );
    COMMIT;


END; 