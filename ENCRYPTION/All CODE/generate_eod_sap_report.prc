create or replace PROCEDURE generate_eod_sap_report
(
    p_mode              IN      MSGDB_OUTPUT.mdbout_mode%TYPE,
    p_output_report     OUT     BLOB,
    p_msgdbid_list      OUT     CLOB,
    p_total_amount      OUT     MSGDB.PRIORITYAMOUNTNUM%TYPE,
    p_institutionid     IN      MSGDB.institutionid%TYPE,
    p_inst_paramvalue   IN      INSTITUTIONPARAMETERS.PARAMVALUE%TYPE DEFAULT 'N',
    p_company_code      IN      MSGDB.company_code%TYPE,
    p_return_msgsegr    OUT     MSGDB.msgsegr%TYPE,
    p_time              OUT     VARCHAR2

)
AS
    CURSOR c_groupinginfo_eod
    IS
    SELECT DISTINCT groupinginfo_eod
    FROM msgdb
    WHERE   groupinginfo_eod IS NOT NULL
    AND     msgdb_id IN 
                    (
                        SELECT msgdb_id FROM msgdb_output
                        WHERE mdbout_mode = p_mode
                        AND mdbout_status = 'A'
                    )
    --AND groupinginfo_eod is not null
    AND institutionid = p_institutionid
    ORDER BY    groupinginfo_eod;                    
    
    CURSOR c_distinct_accounts
    (
        c_groupinginfo_eod IN msgdb.groupinginfo_eod%TYPE,
        c_aggregate_flag IN msgdb.aggregate_flag%TYPE
    )
    
    IS
    SELECT DISTINCT DECODE(c_aggregate_flag, 'CR-AGG', SAP_CR,'BOTH-AGG',SAP_CR, SAP_DR) ACCOUNTS
    FROM msgdb
    where msgdb_id IN 
                    (
                        SELECT msgdb_id FROM msgdb_output
                        WHERE mdbout_mode = p_mode
                        AND mdbout_status = 'A'
                    )
    AND groupinginfo_eod is not null
    AND groupinginfo_eod = c_groupinginfo_eod
    AND SAP_CR IS NOT NULL
    AND SAP_DR IS NOT NULL
    AND aggregate_flag IN (SELECT para_code FROM TABLE(get_code_from_list (c_aggregate_flag||','||'BOTH-AGG,IND', ',')))
    ORDER BY     groupinginfo_eod;


    CURSOR c_distinct_accounts_enc
    (
        c_groupinginfo_eod IN msgdb.groupinginfo_eod%TYPE,
        c_aggregate_flag IN msgdb.aggregate_flag%TYPE
    )

    IS
    SELECT DISTINCT DECODE(c_aggregate_flag, 'CR-AGG', encrypt_decrypt_basedon_session_cntx('DECRYPT',p_institutionid,SAP_CR),'BOTH-AGG',encrypt_decrypt_basedon_session_cntx('DECRYPT',p_institutionid,SAP_CR), encrypt_decrypt_basedon_session_cntx('DECRYPT',p_institutionid,SAP_DR)) ACCOUNTS
    FROM msgdb
    where msgdb_id IN
                    (
                        SELECT msgdb_id FROM msgdb_output
                        WHERE mdbout_mode = p_mode
                        AND mdbout_status = 'A'
                    )
    AND groupinginfo_eod is not null
    AND groupinginfo_eod = c_groupinginfo_eod
    AND SAP_CR IS NOT NULL
    AND SAP_DR IS NOT NULL
    AND aggregate_flag IN (SELECT para_code FROM TABLE(get_code_from_list (c_aggregate_flag||','||'BOTH-AGG,IND', ',')))
    ORDER BY     groupinginfo_eod;


    CURSOR c_msgblocks
    (
        c_groupinginfo_eod IN msgdb.groupinginfo_eod%TYPE,
        c_aggregate_flag IN msgdb.aggregate_flag%TYPE,
        c_distinct_accounts IN msgdb.sap_cr%type

    )
    IS
    SELECT  mb.msgdb_id,
            mb.msgblocktype,
            m.priorityamountnum,
            m.transactiontype,
            m.institutionid,
            m.sap_dr,
            m.sap_cr,
            m.aggregate_flag,
            m.groupinginfo_eod,
            m.msgsegr,
            mp.mdbpay_charge_1,
            m.messageclasstype
    FROM    msgblocks mb, 
            msgdb m,
            msgdb_output mo,
            msgdb_pay mp
    WHERE   mb.msgblocktype IN  ((SELECT para_code FROM TABLE(get_code_from_list (td_get_value(p_mode,'BLOB|' || c_aggregate_flag), ','))),
                                 (SELECT para_code FROM TABLE(get_code_from_list (td_get_value(p_mode,'BLOB|' || c_aggregate_flag || '|CHARGES'), ',')))) 
    AND m.msgdb_id = mb.MSGDB_ID
    AND mo.MDBOUT_STATUS = 'A'
    AND mo.msgdb_id = mb.msgdb_id
    AND mp.msgdb_id = mb.msgdb_id
    AND institutionid = p_institutionid
    AND mo.mdbout_mode = p_mode
    AND mb.message IS NOT NULL
    AND groupinginfo_eod = c_groupinginfo_eod
    AND aggregate_flag IN (SELECT para_code FROM TABLE(get_code_from_list (c_aggregate_flag||','||'BOTH-AGG,IND', ',')))
    AND groupinginfo_eod is not null
    AND NVL(SAP_CR, 'XXXX') = DECODE(c_aggregate_flag, 'CR-AGG',c_distinct_accounts, NVL(SAP_CR, 'XXXX'))
    AND NVL(SAP_DR, 'XXXX') = DECODE(c_aggregate_flag, 'DR-AGG',c_distinct_accounts, NVL(SAP_DR, 'XXXX'))
    ORDER BY DECODE(c_aggregate_flag, 'CR-AGG',sap_cr,sap_dr) DESC;

    CURSOR c_msgblocks_enc
    (
        c_groupinginfo_eod IN msgdb.groupinginfo_eod%TYPE,
        c_aggregate_flag IN msgdb.aggregate_flag%TYPE,
        c_distinct_accounts_enc IN msgdb.sap_cr%type

    )
    IS
    SELECT  mb.msgdb_id,
            mb.msgblocktype,
            m.priorityamountnum,
            m.transactiontype,
            m.institutionid,
            m.sap_dr,
            m.sap_cr,
            m.aggregate_flag,
            m.groupinginfo_eod,
            m.msgsegr,
            mp.mdbpay_charge_1,
            m.messageclasstype
    FROM    msgblocks mb,
            msgdb m,
            msgdb_output mo,
            msgdb_pay mp
    WHERE   mb.msgblocktype IN  ((SELECT para_code FROM TABLE(get_code_from_list (td_get_value(p_mode,'BLOB|' || c_aggregate_flag), ','))),
                                 (SELECT para_code FROM TABLE(get_code_from_list (td_get_value(p_mode,'BLOB|' || c_aggregate_flag || '|CHARGES'), ','))))
    AND m.msgdb_id = mb.MSGDB_ID
    AND mo.MDBOUT_STATUS = 'A'
    AND mo.msgdb_id = mb.msgdb_id
    AND mp.msgdb_id = mb.msgdb_id
    AND institutionid = p_institutionid
    AND mo.mdbout_mode = p_mode
    AND mb.message IS NOT NULL
    AND groupinginfo_eod = c_groupinginfo_eod
    AND aggregate_flag IN (SELECT para_code FROM TABLE(get_code_from_list (c_aggregate_flag||','||'BOTH-AGG,IND', ',')))
    AND groupinginfo_eod is not null
    AND NVL(encrypt_decrypt_basedon_session_cntx('DECRYPT',p_institutionid,SAP_CR), 'XXXX') = DECODE(c_aggregate_flag, 'CR-AGG',c_distinct_accounts_enc, NVL(encrypt_decrypt_basedon_session_cntx('DECRYPT',p_institutionid,SAP_CR), 'XXXX'))
    AND NVL(encrypt_decrypt_basedon_session_cntx('DECRYPT',p_institutionid,SAP_DR), 'XXXX') = DECODE(c_aggregate_flag, 'DR-AGG',c_distinct_accounts_enc, NVL(encrypt_decrypt_basedon_session_cntx('DECRYPT',p_institutionid,SAP_DR), 'XXXX'))
    ORDER BY DECODE(c_aggregate_flag, 'CR-AGG',sap_cr,sap_dr) DESC;

    CURSOR c_msgblocks_parentinst
    (
        c_groupinginfo_eod IN msgdb.groupinginfo_eod%TYPE,
        c_aggregate_flag IN msgdb.aggregate_flag%TYPE,
        c_distinct_accounts IN msgdb.sap_cr%type
    )
    IS
    SELECT  mb.msgdb_id,
            mb.msgblocktype,
            m.priorityamountnum,
            m.transactiontype,
            m.institutionid,
            m.sap_dr,
            m.sap_cr,
            m.aggregate_flag,
            m.groupinginfo_eod,
            m.msgsegr,
            mp.mdbpay_charge_1,
            m.messageclasstype
    FROM    msgblocks mb, 
            msgdb m,
            msgdb_output mo,
            msgdb_pay mp 
    WHERE   mb.msgblocktype IN  ((SELECT para_code FROM TABLE(get_code_from_list (NVL(td_get_value(p_mode,'BLOB|' || c_aggregate_flag), 0), ','))),
                                (SELECT para_code FROM TABLE(get_code_from_list (NVL(td_get_value(p_mode,'BLOB|' || c_aggregate_flag || '|CHARGES'), 0), ','))))
    AND m.msgdb_id = mb.msgdb_id
    AND mo.MDBOUT_STATUS = 'A'
    AND mo.msgdb_id = mb.msgdb_id
    AND mo.mdbout_mode = p_mode
    AND mb.message IS NOT NULL
    AND groupinginfo_eod = c_groupinginfo_eod
    AND aggregate_flag IN (SELECT para_code FROM TABLE(get_code_from_list (c_aggregate_flag||','||'BOTH-AGG,IND', ',')))
    AND institutionid  IN
                        ( 
                            SELECT  institutionid
                            FROM    institutionparameters
                            WHERE      UPPER(paramname)    = 'PARENT_ID'
                            AND     paramvalue          = p_institutionid
                            UNION 
                            SELECT  p_institutionid 
                            FROM    DUAL
                         )
    AND groupinginfo_eod is not null
    AND NVL(sap_cr, 'XXXX') = DECODE(c_aggregate_flag, 'CR-AGG',c_distinct_accounts, NVL(sap_cr, 'XXXX'))
    AND NVL(sap_dr, 'XXXX') = DECODE(c_aggregate_flag, 'DR-AGG',c_distinct_accounts, NVL(sap_dr, 'XXXX'))
    ORDER BY DECODE(c_aggregate_flag, 'CR-AGG',sap_cr,sap_dr) DESC;                         

    CURSOR c_msgblocks_parentinst_enc
    (
        c_groupinginfo_eod IN msgdb.groupinginfo_eod%TYPE,
        c_aggregate_flag IN msgdb.aggregate_flag%TYPE,
        c_distinct_accounts_enc IN msgdb.sap_cr%type
    )
    IS
    SELECT  mb.msgdb_id,
            mb.msgblocktype,
            m.priorityamountnum,
            m.transactiontype,
            m.institutionid,
            m.sap_dr,
            m.sap_cr,
            m.aggregate_flag,
            m.groupinginfo_eod,
            m.msgsegr,
            mp.mdbpay_charge_1,
            m.messageclasstype
    FROM    msgblocks mb,
            msgdb m,
            msgdb_output mo,
            msgdb_pay mp
    WHERE   mb.msgblocktype IN  ((SELECT para_code FROM TABLE(get_code_from_list (NVL(td_get_value(p_mode,'BLOB|' || c_aggregate_flag), 0), ','))),
                                (SELECT para_code FROM TABLE(get_code_from_list (NVL(td_get_value(p_mode,'BLOB|' || c_aggregate_flag || '|CHARGES'), 0), ','))))
    AND m.msgdb_id = mb.msgdb_id
    AND mo.MDBOUT_STATUS = 'A'
    AND mo.msgdb_id = mb.msgdb_id
    AND mo.mdbout_mode = p_mode
    AND mb.message IS NOT NULL
    AND groupinginfo_eod = c_groupinginfo_eod
    AND aggregate_flag IN (SELECT para_code FROM TABLE(get_code_from_list (c_aggregate_flag||','||'BOTH-AGG,IND', ',')))
    AND institutionid  IN
                        (
                            SELECT  institutionid
                            FROM    institutionparameters
                            WHERE      UPPER(paramname)    = 'PARENT_ID'
                            AND     paramvalue          = p_institutionid
                            UNION
                            SELECT  p_institutionid
                            FROM    DUAL
                         )
    AND groupinginfo_eod is not null
    AND NVL(encrypt_decrypt_basedon_session_cntx('DECRYPT',p_institutionid,SAP_CR), 'XXXX') = DECODE(c_aggregate_flag, 'CR-AGG',c_distinct_accounts_enc, NVL( encrypt_decrypt_basedon_session_cntx('DECRYPT',p_institutionid,SAP_CR), 'XXXX'))
    AND NVL(encrypt_decrypt_basedon_session_cntx('DECRYPT',p_institutionid,SAP_DR), 'XXXX') = DECODE(c_aggregate_flag, 'DR-AGG',c_distinct_accounts_enc, NVL(encrypt_decrypt_basedon_session_cntx('DECRYPT',p_institutionid,SAP_DR), 'XXXX'))
    ORDER BY DECODE(c_aggregate_flag, 'CR-AGG',sap_cr,sap_dr) DESC;



    TYPE t_msgblocks IS TABLE OF c_msgblocks%ROWTYPE;
    a_msgblocks             t_msgblocks             := t_msgblocks();

    TYPE t_tabledetails IS TABLE OF tabledetails%ROWTYPE;
    a_tabledetails          t_tabledetails          := t_tabledetails();
    
    TYPE t_groupinginfo_eod IS TABLE OF c_groupinginfo_eod%ROWTYPE;
    a_groupinginfo_eod      t_groupinginfo_eod      := t_groupinginfo_eod();
    
    TYPE t_distinct_accounts IS TABLE OF c_distinct_accounts%ROWTYPE;
    a_distinct_accounts     t_distinct_accounts     := t_distinct_accounts();
    
    
    m_total_priorityamtnum      NUMBER                          :=  0;
    --m_total_contractnum         NUMBER                          :=  0;
    m_debit_txn_sum             NUMBER                          :=  0;
    m_txn_sum                   NUMBER                          :=  0;
    m_file_tran_count           NUMBER                          :=  0;
    m_groupinfo_beg             NUMBER                          :=  0;
    m_groupinfo_end             NUMBER                          :=  0;
    m_msgdblocks_beg            NUMBER                          :=  0;
    m_msgdblocks_end            NUMBER                          :=  0;  
    m_acc_ctr_beg               NUMBER                          :=  0;  
    m_acc_ctr_end               NUMBER                          :=  0;
    m_doc_ctr                   NUMBER                          :=  0;  
    m_msgdb_id_length           NUMBER                          :=  0;
    m_total_txn_charges_sum             NUMBER                          :=  0; 
    m_txn_charges_sum                   NUMBER                          :=  0;
    m_debit_charges_sum                 NUMBER                          :=  0;
    m_credit_charges_sum                NUMBER                          :=  0; 
    m_total_debit_charges_sum           NUMBER                          :=  0;
    m_org_message               CLOB;
    m_append_message            CLOB;
    m_append_message_charges            CLOB;
    l_new_file                  CLOB;
    m_document_header                   CLOB;
    m_msgdbid_list              CLOB;
    m_aggreagted_clob           CLOB;
    m_charges_aggregate_clob            CLOB; 
    m_value                     VARCHAR2(3000)                  := NULL;
    m_query                     VARCHAR2(3000)                  := NULL;
    m_aggregation_types         VARCHAR2(100)                   := 'DR-AGG,CR-AGG';
    m_aggregation_type          VARCHAR2(100)                   := NULL;
    m_header_no                 VARCHAR2(50)                    :=  NULL;
    m_total_debit_sum           VARCHAR2(3000)                  := '0';
    m_total_credit_sum          VARCHAR2(3000)                  := '0';
    m_aggregation_amount_var            VARCHAR2(17)                    := NULL;
    m_aggregation_charges_amount_var    VARCHAR2(17)                    := NULL;
    m_flag                              VARCHAR2(160)                   := 'DOCHEADER';
    m_documentheader_count              VARCHAR2(50)                    :=  0;
    m_aggregation_account               msgdb.sap_cr%type               := 'XXXXXXX';    
    m_aggregation_amount                msgdb.priorityamountnum%type    := 0;
    m_compare_account                   msgdb.sap_cr%type               := NULL;
    m_aggregation_charges_amount        msgdb.priorityamountnum%type    := 0;
    m_msgdb_id_sub                      VARCHAR2(50)                    :=  0;
    m_time                              VARCHAR2(15);
    m_tenant_list                       VARCHAR2(3000)                  := NULL;
    m_tenantname                        VARCHAR2(3000)                  := NULL;
    m_context_name                      VARCHAR2(3000)                  := NULL;
    m_paramname                         INSTITUTIONPARAMETERS.PARAMNAME%TYPE    := 'TENANT_NAME';
    m_path                              INSTITUTIONPARAMETERS.PATH%TYPE         := 'INSTITUTION_DETAILS';
    m_output_report                     clob           ;
    m_doc_ctr_aggregation_cr            msgdb.priorityamountnum%type    := 0;
    m_doc_ctr_aggregation_dr            msgdb.priorityamountnum%type    := 0;
    m_amount_MDBPAY_CHARGE_CR            msgdb_pay.mdbpay_charge_1%type    := 0;
    m_amount_MDBPAY_CHARGE_DR            msgdb_pay.mdbpay_charge_1%type    := 0;
    m_amount_debit_charges_sum            msgdb_pay.mdbpay_charge_1%type    := 0;
    m_amount_credit_charges_sum            msgdb_pay.mdbpay_charge_1%type    := 0;
    
BEGIN

    SELECT * 
    BULK COLLECT 
    INTO a_tabledetails 
    FROM tabledetails 
    WHERE   TDIDCODE = p_mode 
    AND     TDKEY LIKE 'HDR%' 
    ORDER BY TDKEY;

             m_tenantname   := NVL(Get_Institution_Param_Value(p_institutionid,m_path,m_paramname),'XXX');
            DBMS_OUTPUT.PUT_LINE('m_tenantname -->'||m_tenantname);

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
                DBMS_OUTPUT.PUT_LINE('m_context_name '||m_context_name);

              m_tenant_list := sys_context(m_context_name,'ENCRYPTION_TENANT_LIST');
                DBMS_OUTPUT.PUT_LINE('m_tenant_list : ' || m_tenant_list);


    dbms_lob.createtemporary(l_new_file,TRUE);
    dbms_lob.createtemporary(m_document_header,TRUE);
    dbms_lob.createtemporary(m_msgdbid_list,TRUE);
    
    FOR i IN 1..a_tabledetails.COUNT
    LOOP
    
        IF a_tabledetails.LAST <=0
        THEN
            EXIT;
        END IF;

        m_query := 'SELECT '||a_tabledetails(i).TDVALUE||' FROM DUAL ';
        
        EXECUTE IMMEDIATE m_query INTO m_value;
        
        SELECT TO_CHAR(SYSDATE,'HH24MISS') INTO m_time FROM  dual;
        m_value := REPLACE(m_value ,'SYSTIME',m_time);
        dbms_lob.writeappend(l_new_file,LENGTH(m_value),m_value);
        p_time := m_time;

    END LOOP;
    
    OPEN c_groupinginfo_eod;
    FETCH c_groupinginfo_eod BULK COLLECT  INTO a_groupinginfo_eod;
    CLOSE c_groupinginfo_eod;
    
    
    
    m_groupinfo_beg := NVL(a_groupinginfo_eod.FIRST, 0);
    m_groupinfo_end := NVL(a_groupinginfo_eod.LAST, 0);
    
    --DBMS_OUTPUT.PUT_LINE('m_groupinfo_end : '||m_groupinfo_end);
    
    IF m_groupinfo_end > 0
    THEN
        
        FOR i IN m_groupinfo_beg..m_groupinfo_end
        LOOP
            --DBMS_OUTPUT.PUT_LINE('---------------m_groupinfo_end : '||a_groupinginfo_eod(i).groupinginfo_eod);
            m_document_header := EMPTY_CLOB();
            dbms_lob.createtemporary(m_document_header,TRUE);
            a_tabledetails := t_tabledetails(); 
            --m_header_no    :=  LPAD(i,6,'0');   
            m_doc_ctr      := 0;
            m_flag := 'DOCHEADER';
            SELECT * BULK COLLECT INTO a_tabledetails FROM TABLEDETAILS WHERE TDIDCODE = p_mode AND TDKEY LIKE 'DHDR%' ORDER BY TDKEY;
                                
            FOR j IN 1.. a_tabledetails.COUNT
            LOOP
                IF a_tabledetails.LAST <=0
                THEN
                    EXIT;
                END IF;

                m_query := 'SELECT '||a_tabledetails(j).TDVALUE||' FROM DUAL ';
                                    
                EXECUTE IMMEDIATE m_query INTO m_value;
                                    
                DBMS_LOB.writeappend(m_document_header,LENGTH(m_value),m_value);
                --m_document_header  := REPLACE(m_document_header,'DOCHDRNO',m_header_no);   
                m_document_header  := REPLACE(m_document_header,'DOCHDOCUMENT',getstringitemwithsep(a_groupinginfo_eod(i).groupinginfo_eod, 1, '|'));                    
                                 
            END LOOP;  
            --m_flag := 'NO RECORDS FOUND';
            FOR k IN 1..2
            LOOP
                m_aggregation_type := getstringitemwithsep(m_aggregation_types, k, ',');
              IF INSTR(m_tenant_list,m_tenantname) > 0
              THEN
                
                OPEN c_distinct_accounts_enc (a_groupinginfo_eod(i).groupinginfo_eod, m_aggregation_type);
                FETCH c_distinct_accounts_enc BULK COLLECT INTO a_distinct_accounts;
                CLOSE c_distinct_accounts_enc;
              ELSE
                OPEN c_distinct_accounts (a_groupinginfo_eod(i).groupinginfo_eod, m_aggregation_type);
                FETCH c_distinct_accounts BULK COLLECT INTO a_distinct_accounts;
                CLOSE c_distinct_accounts;               
                
            END IF;
                m_acc_ctr_beg := NVL(a_distinct_accounts.FIRST(), 0);
                m_acc_ctr_end := NVL(a_distinct_accounts.LAST(), 0);
                ----DBMS_OUTPUT.PUT_LINE('m_aggregation_type : ' ||m_aggregation_type);
                --DBMS_OUTPUT.PUT_LINE('m_acc_ctr_end : ' ||m_acc_ctr_end);
                --DBMS_OUTPUT.PUT_LINE('**********************In aggregation loop');
--                IF m_flag = 'NO RECORDS FOUND' AND m_acc_ctr_end> 0
--                THEN
--                    m_documentheader_count := m_documentheader_count + 1;
--                    m_header_no    :=  LPAD(m_documentheader_count,6,'0');
--                    DBMS_OUTPUT.PUT_LINE('B4 doc header : ' || m_document_header );

--                    m_document_header  := REPLACE(m_document_header,'DOCHDRNO',m_header_no);
--                    DBMS_OUTPUT.PUT_LINE('m_header_no : '||m_header_no);

--                    DBMS_LOB.writeappend(l_new_file,LENGTH(m_document_header),m_document_header);
--                    DBMS_OUTPUT.PUT_LINE('doc header : ' || m_document_header );
--                END IF;
                IF m_acc_ctr_end > 0 
                THEN
                    --m_flag := 'RECORDS FOUND';
                    FOR m IN m_acc_ctr_beg..m_acc_ctr_end
                    LOOP
                        BEGIN
                            --DBMS_OUTPUT.PUT_LINE('INSIDE : ' ||m);
                                       
                            IF NVL(p_inst_paramvalue,'N')='N'
                            THEN
                            
                                IF c_msgblocks%ISOPEN
                                THEN
                                    CLOSE c_msgblocks;
                                ELSIF c_msgblocks_parentinst%ISOPEN
                                THEN
                                    CLOSE c_msgblocks_parentinst;
                                ELSIF c_msgblocks_enc%ISOPEN
                                THEN
                                    CLOSE c_msgblocks_enc;
                                    ELSIF c_msgblocks_parentinst_enc%ISOPEN
                                THEN
                                    CLOSE c_msgblocks_parentinst_enc;
                                END IF;
                                --DBMS_OUTPUT.PUT_LINE(' a_groupinginfo_eod(i).groupinginfo_eod : ' || a_groupinginfo_eod(i).groupinginfo_eod);
                                --DBMS_OUTPUT.PUT_LINE(' a_distinct_accounts(m).accounts : ' || a_distinct_accounts(m).accounts);
                                --DBMS_OUTPUT.PUT_LINE(' m_aggregation_type : ' || m_aggregation_type);
                               IF INSTR(m_tenant_list,m_tenantname) > 0
                               THEN

                                   OPEN c_msgblocks_enc(a_groupinginfo_eod(i).groupinginfo_eod, m_aggregation_type, a_distinct_accounts(m).accounts);
                               ELSE
                                OPEN c_msgblocks(a_groupinginfo_eod(i).groupinginfo_eod, m_aggregation_type, a_distinct_accounts(m).accounts);
                               END IF;
                            ELSIF NVL(p_inst_paramvalue,'N')='Y'
                            THEN
                               IF INSTR(m_tenant_list,m_tenantname) > 0
                               THEN
                                   OPEN c_msgblocks_parentinst_enc(a_groupinginfo_eod(i).groupinginfo_eod, m_aggregation_type, a_distinct_accounts(m).accounts);
                               ELSE
                                OPEN c_msgblocks_parentinst(a_groupinginfo_eod(i).groupinginfo_eod, m_aggregation_type, a_distinct_accounts(m).accounts);
                            END IF;
                        
                            END IF;
                             
                            
                            IF NVL(p_inst_paramvalue,'N') ='N'
                            THEN
                                  IF INSTR(m_tenant_list,m_tenantname) > 0
                                  THEN
                                     FETCH c_msgblocks_enc BULK COLLECT  INTO a_msgblocks LIMIT 10000;
                                  ELSE
                                     FETCH c_msgblocks BULK COLLECT  INTO a_msgblocks LIMIT 10000;
                                  END IF;
                                ELSIF NVL(p_inst_paramvalue,'N') ='Y'
                                THEN
                                  IF INSTR(m_tenant_list,m_tenantname) > 0
                                  THEN
                                     FETCH c_msgblocks_parentinst_enc BULK COLLECT  INTO a_msgblocks LIMIT 10000;
                                  ELSE
                                    FETCH c_msgblocks_parentinst BULK COLLECT  INTO a_msgblocks LIMIT 10000;
                                  END IF;
                            END IF;
                                
                               
                            m_msgdblocks_beg := NVL(a_msgblocks.FIRST, 0);
                            m_msgdblocks_end := NVL(a_msgblocks.LAST, 0);
                            --DBMS_OUTPUT.PUT_LINE('m_msgdblocks_end  : ' || m_msgdblocks_end);
                                        
                            IF m_msgdblocks_end > 0
                            THEN
                                    ----DBMS_OUTPUT.PUT_LINE('m_msgdblocks_end > 0');
                                IF m_flag = 'DOCHEADER'
                                THEN
                                    m_flag := 'DOCHEADERATTACED';
                                    
                                    m_documentheader_count := m_documentheader_count + 1;
                                    m_header_no    :=  LPAD(m_documentheader_count,6,'0');
                                    m_document_header  := REPLACE(m_document_header,'DOCHDRNO',m_header_no);
                                    DBMS_LOB.writeappend(l_new_file,LENGTH(m_document_header),m_document_header);
                                END IF;
                                
                                    ----DBMS_OUTPUT.PUT_LINE('BEFORE FOR');
                                    
                                FOR rec IN m_msgdblocks_beg..m_msgdblocks_end
                                LOOP
                                
                                    IF rec = 1 and a_msgblocks(rec).aggregate_flag <> 'IND'
                                    THEN
                                        IF INSTR(m_tenant_list,m_tenantname) > 0
                                        THEN
                                            m_aggreagted_clob := encrypt_decrypt_basedon_session_cntx_clob('DECRYPT',p_institutionid,blob_to_clob(a_msgblocks(rec).msgdb_id, td_get_value(p_mode,'BLOB|' ||m_aggregation_type)));
                                        ELSE
                                        m_aggreagted_clob := blob_to_clob(a_msgblocks(rec).msgdb_id, td_get_value(p_mode,'BLOB|' ||m_aggregation_type));
                                        
                                        END IF;
                                       -- DBMS_OUTPUT.PUT_LINE('a_msgblocks(rec).msgblocktype : ' || a_msgblocks(rec).msgblocktype);
                                        p_return_msgsegr := a_msgblocks(rec).msgsegr;

                                    END IF;
                                    
                                   -- DBMS_OUTPUT.PUT_LINE('m_aggreagted_clob  : ' || m_aggreagted_clob);
                                    --DBMS_OUTPUT.PUT_LINE('msgblocktype1 : ' || td_get_value(p_mode,'BLOB|' ||m_aggregation_type || '|CHARGES'));
                                    
                                    IF a_msgblocks(rec).msgblocktype =  td_get_value(p_mode,'BLOB|' ||m_aggregation_type || '|CHARGES')
                                    THEN 
   
                                        IF INSTR(m_tenant_list,m_tenantname) > 0
                                        THEN
                                             m_charges_aggregate_clob :=   encrypt_decrypt_basedon_session_cntx_clob('DECRYPT',p_institutionid,blob_to_clob(a_msgblocks(rec).msgdb_id, td_get_value(p_mode,'BLOB|' ||m_aggregation_type || '|CHARGES')));
                                        ELSE
                                        m_charges_aggregate_clob := blob_to_clob(a_msgblocks(rec).msgdb_id, td_get_value(p_mode,'BLOB|' ||m_aggregation_type || '|CHARGES'));
                                        END IF;
                                       -- DBMS_OUTPUT.PUT_LINE('m_charges_aggregate_clob  : ' || m_charges_aggregate_clob);

                                    END IF;
                                       
                                    --DBMS_OUTPUT.PUT_LINE('m_msgdblocks_end : ' || m_msgdblocks_end);
                                    ----DBMS_OUTPUT.PUT_LINE('m_aggregation_type : ' || m_aggregation_type);
                                        
                                    IF m_aggregation_type = 'CR-AGG'
                                    THEN
                                        IF INSTR(m_tenant_list,m_tenantname) > 0
                                        THEN
                                             m_compare_account :=  encrypt_decrypt_basedon_session_cntx('DECRYPT',p_institutionid,a_msgblocks(rec).sap_cr);
                                        ELSE
                                        m_compare_account := a_msgblocks(rec).sap_cr;
                                        END IF;
                                    ELSE
                                      IF INSTR(m_tenant_list,m_tenantname) > 0
                                      THEN
                                        m_compare_account := encrypt_decrypt_basedon_session_cntx('DECRYPT',p_institutionid,a_msgblocks(rec).sap_dr);
                                      ELSE
                                        m_compare_account := a_msgblocks(rec).sap_dr;
                                    END IF;
                                        
                                    END IF;
                                    IF m_aggregation_account != NVL(m_compare_account, 'XXXXXXX')
                                    THEN
                                            
                                        IF  m_aggregation_type = 'CR-AGG'
                                        THEN
                                           IF INSTR(m_tenant_list,m_tenantname) > 0
                                           THEN
                                                m_aggregation_account := encrypt_decrypt_basedon_session_cntx('DECRYPT',p_institutionid,a_msgblocks(rec).sap_cr);
                                           ELSE     
                                            m_aggregation_account := a_msgblocks(rec).sap_cr;
                                            
                                           END IF;
                                        ELSE
                                           IF INSTR(m_tenant_list,m_tenantname) > 0
                                           THEN
                                                m_aggregation_account := encrypt_decrypt_basedon_session_cntx('DECRYPT',p_institutionid,a_msgblocks(rec).sap_dr);
                                           ELSE
                                            m_aggregation_account := a_msgblocks(rec).sap_dr;
                                            
                                           END IF;

                                        END IF;
                                                                                                        
                                    END IF;
                                    IF a_msgblocks(rec).messageclasstype = 'pacs.004.001.02' and a_msgblocks(rec).mdbpay_charge_1 > 0
                                    THEN 
                                        DBMS_OUTPUT.PUT_LINE('a_msgblocks(rec).priorityamountnum: '||a_msgblocks(rec).priorityamountnum);

                                        a_msgblocks(rec).priorityamountnum := a_msgblocks(rec).priorityamountnum - a_msgblocks(rec).mdbpay_charge_1;
                                        
                                        DBMS_OUTPUT.PUT_LINE('a_msgblocks(rec).priorityamountnum: '||a_msgblocks(rec).priorityamountnum);
                                   
                                    END IF;
                                    
                                    IF  m_aggregation_type = 'CR-AGG' and (m_aggregation_account =  encrypt_decrypt_basedon_session_cntx('DECRYPT',p_institutionid,a_msgblocks(rec).sap_cr) OR m_aggregation_account =a_msgblocks(rec).sap_cr)  and a_msgblocks(rec).msgblocktype = td_get_value(p_mode,'BLOB|CR-AGG')
                                    THEN
                                        m_txn_sum           := m_txn_sum        + NVL(a_msgblocks(rec).priorityamountnum,0);

                                    ELSIF m_aggregation_type = 'DR-AGG' and (m_aggregation_account =  encrypt_decrypt_basedon_session_cntx('DECRYPT',p_institutionid,a_msgblocks(rec).sap_dr) OR m_aggregation_account =a_msgblocks(rec).sap_dr) and a_msgblocks(rec).msgblocktype = td_get_value(p_mode,'BLOB|DR-AGG')
                                    THEN
                                        m_debit_txn_sum     := m_debit_txn_sum  + NVL(a_msgblocks(rec).priorityamountnum,0); 
END IF;
                                    IF m_aggregation_type = 'CR-AGG' and (m_aggregation_account =  encrypt_decrypt_basedon_session_cntx('DECRYPT',p_institutionid,a_msgblocks(rec).sap_cr) OR m_aggregation_account = a_msgblocks(rec).sap_cr) and a_msgblocks(rec).msgblocktype = td_get_value(p_mode,'BLOB|CR-AGG|CHARGES')
                                    THEN
                                        DBMS_OUTPUT.PUT_LINE('check1 : ');
                                        m_credit_charges_sum       := m_credit_charges_sum    + NVL(a_msgblocks(rec).MDBPAY_CHARGE_1,0);
                                    ELSIF m_aggregation_type = 'DR-AGG' and (m_aggregation_account =  encrypt_decrypt_basedon_session_cntx('DECRYPT',p_institutionid,a_msgblocks(rec).sap_dr)OR m_aggregation_account =a_msgblocks(rec).sap_dr) and a_msgblocks(rec).msgblocktype = td_get_value(p_mode,'BLOB|DR-AGG|CHARGES')
                                    THEN
                                        m_debit_charges_sum       := m_debit_charges_sum    + NVL(a_msgblocks(rec).MDBPAY_CHARGE_1,0);

                                    END IF; 

                                    
                                    
                                    IF a_msgblocks(rec).aggregate_flag IN ('CR-AGG') and a_msgblocks(rec).msgblocktype = td_get_value(p_mode,'BLOB|CR-AGG')  
                                    THEN
                                        --Different BLOB APPEND FOR  SAP_DR
                                        m_debit_txn_sum             := m_debit_txn_sum  + NVL(a_msgblocks(rec).priorityamountnum,0);
                                          IF INSTR(m_tenant_list,m_tenantname) > 0
                                          THEN
                                               m_append_message := encrypt_decrypt_basedon_session_cntx_clob('DECRYPT',p_institutionid,blob_to_clob(a_msgblocks(rec).MSGDB_ID,td_get_value(p_mode,'BLOB|DR-AGG')));
                                          ELSE
                                               m_append_message := blob_to_clob(a_msgblocks(rec).MSGDB_ID,td_get_value(p_mode,'BLOB|DR-AGG'));
                                          END IF;
                                        DBMS_LOB.writeappend(l_new_file, LENGTH(m_append_message), m_append_message );
                                        DBMS_LOB.writeappend(l_new_file,2,CHR(13)||CHR(10));
                                           
                                        IF SUBSTR(m_append_message,43,1) ='H'
                                        THEN
                                        
                                            m_doc_ctr_aggregation_cr := m_doc_ctr_aggregation_cr + NVL(TO_NUMBER(substr(m_append_message,27,16)),0);
                                        
                                        ELSE
                                        
                                            m_doc_ctr_aggregation_dr  := m_doc_ctr_aggregation_dr + NVL(TO_NUMBER(substr(m_append_message,27,16)),0);
                                        
                                        END IF;
                                        m_doc_ctr   := m_doc_ctr    + 1;
                                        l_new_file  := REPLACE(l_new_file,'123456876453',m_header_no||LPAD(m_doc_ctr,6,0));
                                           
                                    ELSIF a_msgblocks(rec).aggregate_flag IN ('DR-AGG') and a_msgblocks(rec).msgblocktype = td_get_value(p_mode,'BLOB|DR-AGG') 
                                    THEN
                                        --different BLOB APPEND FOR  SAP_CR
                                        m_txn_sum           := m_txn_sum        + NVL(a_msgblocks(rec).priorityamountnum,0);

                                          IF INSTR(m_tenant_list,m_tenantname) > 0
                                          THEN
                                               m_append_message := encrypt_decrypt_basedon_session_cntx_clob('DECRYPT',p_institutionid,blob_to_clob(a_msgblocks(rec).MSGDB_ID,td_get_value(p_mode,'BLOB|CR-AGG')));
                                          ELSE
                                               m_append_message := blob_to_clob(a_msgblocks(rec).MSGDB_ID,td_get_value(p_mode,'BLOB|CR-AGG'));
                                          END IF;
                                        DBMS_LOB.writeappend(l_new_file, LENGTH(m_append_message), m_append_message );
                                        DBMS_LOB.writeappend(l_new_file,2,CHR(13)||CHR(10));
                                        IF SUBSTR(m_append_message,43,1) ='H'
                                        THEN
                                            m_doc_ctr_aggregation_cr := m_doc_ctr_aggregation_cr + NVL(TO_NUMBER(substr(m_append_message,27,16)),0);
                                        ELSE
                                            m_doc_ctr_aggregation_dr  := m_doc_ctr_aggregation_dr + NVL(TO_NUMBER(substr(m_append_message,27,16)),0);
                                        END IF;
                                        m_doc_ctr   := m_doc_ctr    + 1;
                                        l_new_file  := REPLACE(l_new_file,'123456876453',m_header_no||LPAD(m_doc_ctr,6,0));
                                    ELSIF a_msgblocks(rec).aggregate_flag = 'IND' 
                                    THEN

                                        --add both blob for IND
                                          IF INSTR(m_tenant_list,m_tenantname) > 0
                                          THEN
                                              m_append_message := encrypt_decrypt_basedon_session_cntx_clob('DECRYPT',p_institutionid,blob_to_clob(a_msgblocks(rec).MSGDB_ID,td_get_value(p_mode,'BLOB|'||m_aggregation_type)));         --picking up file from specific blocktype in msgblocks
                                        DBMS_OUTPUT.PUT_LINE('m_append_message3:' ||m_append_message ); 
                                          ELSE
                                              m_append_message := blob_to_clob(a_msgblocks(rec).MSGDB_ID,td_get_value(p_mode,'BLOB|'||m_aggregation_type));
                                          END IF;
                                        DBMS_LOB.writeappend(l_new_file, LENGTH(m_append_message), m_append_message );
                                        DBMS_LOB.writeappend(l_new_file,2,CHR(13)||CHR(10));
                                         
                                        DBMS_OUTPUT.PUT_LINE('entry1: '); 
                                        IF SUBSTR(m_append_message,43,1) ='H'
                                        THEN
                                            m_doc_ctr_aggregation_cr := m_doc_ctr_aggregation_cr + NVL(TO_NUMBER(substr(m_append_message,27,16)),0);
                                        ELSE
                                            m_doc_ctr_aggregation_dr  := m_doc_ctr_aggregation_dr + NVL(TO_NUMBER(substr(m_append_message,27,16)),0);
                                        END IF;

                                        m_doc_ctr   := m_doc_ctr    + 1;
                                        l_new_file  := REPLACE(l_new_file,'123456876453',m_header_no||LPAD(m_doc_ctr,6,0));
                                       
END IF;
                                    IF  a_msgblocks(rec).aggregate_flag = 'CR-AGG'  AND a_msgblocks(rec).msgblocktype = td_get_value(p_mode,'BLOB|CR-AGG|CHARGES') 
                                    THEN
                                        DBMS_OUTPUT.PUT_LINE('CR CHARGE BLOB LOOP: '); 
                                        m_debit_charges_sum       := m_debit_charges_sum    + NVL(a_msgblocks(rec).MDBPAY_CHARGE_1,0);
                                       
                                         IF INSTR(m_tenant_list,m_tenantname) > 0
                                         THEN
                                              m_append_message_charges := encrypt_decrypt_basedon_session_cntx_clob('DECRYPT',p_institutionid,blob_to_clob(a_msgblocks(rec).MSGDB_ID,td_get_value(p_mode,'BLOB|DR-AGG|CHARGES')));
                                         ELSE
                                        m_append_message_charges    := blob_to_clob(a_msgblocks(rec).MSGDB_ID,td_get_value(p_mode,'BLOB|DR-AGG|CHARGES'));
                                         END IF;
                                        DBMS_OUTPUT.PUT_LINE('m_append_message_charges1:' ||m_append_message_charges ); 

                                        DBMS_LOB.writeappend(l_new_file, LENGTH(m_append_message_charges), m_append_message_charges );

                                        DBMS_LOB.writeappend(l_new_file,2,CHR(13)||CHR(10));
                                           
                                        IF SUBSTR(m_append_message_charges,43,1) ='H'
                                        THEN
                                            m_amount_credit_charges_sum := m_amount_credit_charges_sum + NVL(TO_NUMBER(substr(m_append_message_charges,27,16)),0);
                                        ELSE
                                            m_amount_debit_charges_sum  := m_amount_debit_charges_sum + NVL(TO_NUMBER(substr(m_append_message_charges,27,16)),0);
                                        END IF;
                                        m_doc_ctr   := m_doc_ctr    + 1;
                                        l_new_file  := REPLACE(l_new_file,'123456876453',m_header_no||LPAD(m_doc_ctr,6,0));
                                        
                                    ELSIF a_msgblocks(rec).aggregate_flag = 'DR-AGG' and a_msgblocks(rec).msgblocktype = td_get_value(p_mode,'BLOB|DR-AGG|CHARGES')
                                    THEN 
                                        DBMS_OUTPUT.PUT_LINE('DR CHARGE BLOB LOOP: '); 
                                        m_credit_charges_sum       := m_credit_charges_sum    + NVL(a_msgblocks(rec).MDBPAY_CHARGE_1,0);

                                         IF INSTR(m_tenant_list,m_tenantname) > 0
                                         THEN
                                              m_append_message_charges := encrypt_decrypt_basedon_session_cntx_clob('DECRYPT',p_institutionid,blob_to_clob(a_msgblocks(rec).MSGDB_ID,td_get_value(p_mode,'BLOB|CR-AGG|CHARGES')));
                                         ELSE
                                        m_append_message_charges    := blob_to_clob(a_msgblocks(rec).MSGDB_ID,td_get_value(p_mode,'BLOB|CR-AGG|CHARGES'));
                                         END IF;
                                        DBMS_OUTPUT.PUT_LINE('m_append_message_charges: '||m_append_message_charges); 

                                        DBMS_LOB.writeappend(l_new_file, LENGTH(m_append_message_charges), m_append_message_charges );

                                        DBMS_LOB.writeappend(l_new_file,2,CHR(13)||CHR(10));
                                           
                                        IF SUBSTR(m_append_message_charges,43,1) ='H'
                                        THEN
                                            m_amount_credit_charges_sum := m_amount_credit_charges_sum + NVL(TO_NUMBER(substr(m_append_message_charges,27,16)),0);
                                        ELSE
                                            m_amount_debit_charges_sum  := m_amount_debit_charges_sum + NVL(TO_NUMBER(substr(m_append_message_charges,27,16)),0);
                                        END IF;
                                        m_doc_ctr   := m_doc_ctr    + 1;
                                        l_new_file  := REPLACE(l_new_file,'123456876453',m_header_no||LPAD(m_doc_ctr,6,0));
                                    
                                    END IF;
                                       
                                       
                                    SELECT DECODE(m_aggregation_type,'CR-AGG',nvl(m_txn_sum,0),nvl(m_debit_txn_sum,0)) INTO m_aggregation_amount  FROM DUAL;
                                    SELECT DECODE(m_aggregation_type,'CR-AGG',nvl(m_credit_charges_sum,0),nvl(m_debit_charges_sum,0)) INTO m_aggregation_charges_amount  FROM DUAL; 
                                    m_msgdb_id_sub := dbms_lob.instr(m_msgdbid_list, a_msgblocks(rec).MSGDB_ID);
                                    IF m_msgdb_id_sub = 0
                                    THEN
                                        dbms_lob.writeappend(m_msgdbid_list,LENGTH(a_msgblocks(rec).MSGDB_ID)+1,a_msgblocks(rec).MSGDB_ID||'|');
                                    END IF;
                                       ----DBMS_OUTPUT.PUT_LINE('p_file_tran_count : '||p_file_tran_count);

                                      
                                       
                                END LOOP;
                                
                                IF m_aggreagted_clob is not null
                                THEN
                                m_aggregation_amount_var :=   TRIM(REPLACE(TO_CHAR(m_aggregation_amount,'09999999999999.99'),'.',''));
                                                                                
                                m_aggreagted_clob := replace_with_pos_clob(m_aggreagted_clob, m_aggregation_amount_var, 27);
                                m_aggreagted_clob := replace_with_pos_clob(m_aggreagted_clob, m_aggregation_amount_var, 44);
                                        IF SUBSTR(m_aggreagted_clob,43,1) ='H'
                                        THEN
                                            m_doc_ctr_aggregation_cr := m_doc_ctr_aggregation_cr + NVL(TO_NUMBER(substr(m_aggreagted_clob,27,16)),0);
                                        ELSE
                                            m_doc_ctr_aggregation_dr  := m_doc_ctr_aggregation_dr + NVL(TO_NUMBER(substr(m_aggreagted_clob,27,16)),0);
                                        END IF;
                                                                                
                                m_doc_ctr   := m_doc_ctr    + 1; 
                                m_aggreagted_clob := replace_with_pos_clob(m_aggreagted_clob, m_header_no, 1);
                                m_aggreagted_clob := replace_with_pos_clob(m_aggreagted_clob, LPAD(m_doc_ctr,6,0), 7);
                                    DBMS_LOB.writeappend(l_new_file,LENGTH(m_aggreagted_clob),m_aggreagted_clob);
                                END IF;
                                
                                IF  m_aggregation_charges_amount > 0 
                                THEN
                                    DBMS_LOB.writeappend(l_new_file,2,CHR(13)||CHR(10));

                                    m_aggregation_charges_amount_var := TRIM(REPLACE(TO_CHAR(m_aggregation_charges_amount,'09999999999999.99'),'.',''));
                                    DBMS_OUTPUT.PUT_LINE ('m_aggregation_charges_amount_var :'||m_aggregation_charges_amount_var);

                                    m_charges_aggregate_clob := replace_with_pos_clob(m_charges_aggregate_clob, m_aggregation_charges_amount_var, 27);
                                    m_charges_aggregate_clob := replace_with_pos_clob(m_charges_aggregate_clob, m_aggregation_charges_amount_var, 44);
                                   IF SUBSTR(m_charges_aggregate_clob,43,1) ='H'
                                    THEN
                                        m_amount_credit_charges_sum := m_amount_credit_charges_sum + NVL(TO_NUMBER(substr(m_charges_aggregate_clob,27,16)),0);
                                            
                                    ELSE
                                        m_amount_debit_charges_sum  := m_amount_debit_charges_sum + NVL(TO_NUMBER(substr(m_charges_aggregate_clob,27,16)),0);
                                                    
                                    END IF;

                                    m_doc_ctr   := m_doc_ctr    + 1; 
                                    DBMS_OUTPUT.PUT_LINE('DOCUMENT HEADER COUNT: '||m_doc_ctr); 

                                    m_charges_aggregate_clob := replace_with_pos_clob(m_charges_aggregate_clob, m_header_no, 1);
                                    m_charges_aggregate_clob := replace_with_pos_clob(m_charges_aggregate_clob, LPAD(m_doc_ctr,6,0), 7);                                                
                                --inserting aggregated record in file conent
                                    DBMS_LOB.writeappend(l_new_file,LENGTH(m_charges_aggregate_clob),m_charges_aggregate_clob);
                                    /*m_total_txn_charges_sum := m_total_txn_charges_sum + m_credit_charges_sum;
                                    m_total_debit_charges_sum := m_total_debit_charges_sum + m_debit_charges_sum;*/
                                    
                                    m_total_txn_charges_sum := m_total_txn_charges_sum + m_amount_credit_charges_sum;
                                    m_total_debit_charges_sum := m_total_debit_charges_sum + m_amount_debit_charges_sum;
                                END IF;
                                IF m_aggreagted_clob is not null
                                THEN
                                    DBMS_LOB.writeappend(l_new_file,2,CHR(13)||CHR(10));
                                END IF;
                                           
                                m_total_debit_sum :=m_total_debit_sum +  m_doc_ctr_aggregation_dr;
                                m_total_credit_sum:=m_total_credit_sum + m_doc_ctr_aggregation_cr;
                                
                                m_doc_ctr_aggregation_cr:= 0;
                                m_doc_ctr_aggregation_dr := 0;
                                m_aggregation_amount :=  0;
                                /* m_total_debit_sum := m_total_debit_sum + m_debit_txn_sum;
                                m_total_credit_sum := m_total_credit_sum + m_txn_sum;*/
                                m_debit_txn_sum := 0;
                                m_credit_charges_sum := 0;
                                m_debit_charges_sum :=0;
                                m_txn_sum   := 0;
                                m_amount_credit_charges_sum:= 0;
                                m_amount_debit_charges_sum :=0;
                                
                            END IF;
                        
                        EXCEPTION
                        WHEN OTHERS
                        THEN
                            genaudit_insert_enchash_wrap
                                    (null,null,NULL,'EVNTSRVR','FILE','INSERT','generate_eod_sap_report Procedure Error : OTHERS 1...'||SQLCODE || SQLERRM || dbms_utility.format_error_backtrace
                                    || SQLCODE
                                    || ':'
                                    || SQLERRM
                                    || dbms_utility.format_error_backtrace,
                                    p_institutionid,
                                    0
                                    );
                                    COMMIT;
                                
                                    --DBMS_OUTPUT.PUT_LINE ('OTHERS...'||SQLCODE || SQLERRM || dbms_utility.format_error_backtrace);
                        END;    
                        
                    END LOOP;
                ELSE
                    NULL;
                    DBMS_OUTPUT.PUT_LINE ('doc header null');

                END IF;
                
            END LOOP; 
            --txn 
            m_aggreagted_clob := null;
                   
        END LOOP; 
    END IF;               

    IF c_msgblocks%ISOPEN
    THEN
        CLOSE c_msgblocks;
    ELSIF c_msgblocks_parentinst%ISOPEN
    THEN
        CLOSE c_msgblocks_parentinst;
    ELSIF c_msgblocks_enc%ISOPEN
    THEN
        CLOSE c_msgblocks_enc;
        ELSIF c_msgblocks_parentinst_enc%ISOPEN
    THEN
        CLOSE c_msgblocks_parentinst_enc;
    END IF;
    
    m_msgdb_id_length := NVL(dbms_lob.getlength(m_msgdbid_list), 0);
                            
    IF  m_msgdb_id_length > 0
    THEN
        a_tabledetails := t_tabledetails();
        SELECT * BULK COLLECT INTO a_tabledetails FROM TABLEDETAILS WHERE TDIDCODE = p_mode AND TDKEY LIKE 'TLR%' ORDER BY TDKEY;
        FOR j IN 1.. a_tabledetails.COUNT
        LOOP
            IF a_tabledetails.LAST <=0
            THEN
                EXIT;
            END IF;


            m_query := 'SELECT '||a_tabledetails(j).TDVALUE||' FROM DUAL ';
            EXECUTE IMMEDIATE m_query INTO m_value;
            DBMS_LOB.writeappend(l_new_file,LENGTH(m_value),m_value);

        END LOOP;
        
        
        SELECT LENGTH(l_new_file)-LENGTH(REPLACE(l_new_file,CHR(10))) + 1
        INTO m_file_tran_count
        FROM DUAL; 
        l_new_file:= REPLACE(l_new_file,'NORECORDS',LPAD(m_file_tran_count,14,0));

        l_new_file:= REPLACE(l_new_file,'DEBITTXNSUM',TRIM(REPLACE(TO_CHAR(m_total_debit_sum+m_total_debit_charges_sum,'0999999999999999'),'.','')));
        l_new_file:= REPLACE(l_new_file,'CREDITTXNSUM',TRIM(REPLACE(TO_CHAR(m_total_credit_sum+m_total_txn_charges_sum,'0999999999999999'),'.','')));
        DBMS_LOB.writeappend(l_new_file,2,CHR(13)||CHR(10));

        m_total_priorityamtnum   := m_total_credit_sum + m_total_debit_sum;
       
            IF instr(m_tenant_list,m_tenantname)>0
            THEN
                 p_output_report := GET_ENCRYPT_DECRYPT_DATA('ENCRYPT',p_institutionid,converttoblob(l_new_file));
            ELSE
        p_output_report         := converttoblob(l_new_file);
            END IF;
        p_msgdbid_list := m_msgdbid_list;
        /*IF m_msgdbid_list IS NOT NULL
        THEN
            SELECT LISTAGG(DISTINCT para_code, '|') 
            INTO  p_msgdbid_list
            FROM TABLE (get_code_from_list_clob(m_msgdbid_list, '|')) 
            WHERE para_code IS NOT NULL;
        END IF;*/
        
        p_total_amount          := m_total_priorityamtnum;
        
        --DBMS_OUTPUT.PUT_LINE('m_msgdbid_list : '||m_msgdbid_list);
        
        ----DBMS_OUTPUT.PUT_LINE('p_file_tran_count : '||p_file_tran_count);
    END IF;  
          
    IF dbms_lob.getlength(m_msgdbid_list) > 0
    THEN
        dbms_lob.freetemporary (m_msgdbid_list);
    END IF;
    
     IF dbms_lob.getlength(l_new_file) > 0
    THEN
        dbms_lob.freetemporary (l_new_file);
    END IF;
    
EXCEPTION
WHEN NO_DATA_FOUND
THEN
    NULL;
    --DBMS_OUTPUT.PUT_LINE('NO_DATA_FOUND' || dbms_utility.format_error_backtrace);
WHEN OTHERS
THEN
    ROLLBACK;
    genaudit_insert_enchash_wrap
        (null,null,NULL,'EVNTSRVR','FILE','INSERT','generate_eod_sap_report Procedure Error : OTHERS2...'||SQLCODE || SQLERRM || dbms_utility.format_error_backtrace
        || SQLCODE
        || ':'
        || SQLERRM
        || dbms_utility.format_error_backtrace,
        p_institutionid,
        0
        );
        COMMIT;
    --DBMS_OUTPUT.PUT_LINE ('OTHERS...'||SQLCODE || SQLERRM || dbms_utility.format_error_backtrace);

END;