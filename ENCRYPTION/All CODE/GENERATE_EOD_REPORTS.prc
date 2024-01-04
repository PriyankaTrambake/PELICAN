create or replace PROCEDURE GENERATE_EOD_REPORTS
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

    CURSOR c_msgblocks 
    (
        c_msgdb_output_mode VARCHAR2
    )
    IS
    SELECT  mb.MSGDB_ID,
            mb.MSGBLOCKTYPE,
            m.PRIORITYAMOUNTNUM,
            m.CONTRACT_NUMBER,
            m.TRANSACTIONTYPE,
            m.INSTITUTIONID,
            m.msgsegr,
            m.messageclasstype ,
            mp.mdbpay_charge_1               
    FROM    msgblocks mb , 
            msgdb m ,
            msgdb_pay mp 
    WHERE   m.MSGDB_ID = mb.MSGDB_ID
    AND     mp.msgdb_id = mb.msgdb_id
    AND     mb.MSGDB_ID IN 
                        (
                            SELECT msgdb_id FROM MSGDB_OUTPUT
                            WHERE MDBOUT_MODE = c_msgdb_output_mode
                            AND MDBOUT_STATUS = 'A'
                        )
    AND mb.MSGBLOCKTYPE IN (SELECT PARA_CODE FROM TABLE(GET_CODE_FROM_LIST(NVL(td_get_value(c_msgdb_output_mode, 'BLOB'),0), ',')))
    AND mb.MESSAGE IS NOT NULL
    --AND company_code = p_company_code
    AND institutionid = p_institutionid;

    CURSOR c_msgblocks_parentinst 
     (
        c_msgdb_output_mode VARCHAR2
    )
    IS
    SELECT  mb.MSGDB_ID,
            mb.MSGBLOCKTYPE,
            m.PRIORITYAMOUNTNUM,
            m.CONTRACT_NUMBER,
            m.TRANSACTIONTYPE,
            m.INSTITUTIONID,
            m.msgsegr,
            m.messageclasstype,
            mp.mdbpay_charge_1 
    FROM    msgblocks mb , 
            msgdb m,
            msgdb_pay mp 
    WHERE   m.MSGDB_ID = mb.MSGDB_ID
    AND     mb.MSGDB_ID IN 
                        (
                            SELECT msgdb_id FROM MSGDB_OUTPUT
                            WHERE MDBOUT_MODE = c_msgdb_output_mode
                            AND MDBOUT_STATUS = 'A'
                        )
    AND mb.MSGBLOCKTYPE IN (SELECT PARA_CODE FROM TABLE(GET_CODE_FROM_LIST(NVL(td_get_value(c_msgdb_output_mode, 'BLOB'),0), ',')))
    AND mp.msgdb_id = mb.msgdb_id
    AND mb.MESSAGE IS NOT NULL
    --AND company_code = p_company_code
    AND institutionid  in 
                        ( 
                            SELECT institutionid
                            FROM institutionparameters
                            WHERE  UPPER(paramname)     = 'PARENT_ID'
                            AND paramvalue = p_institutionid
                            UNION SELECT p_institutionid FROM DUAL
                         );

    type t_msgblocks is table of c_msgblocks%rowtype;
    a_msgblocks                 t_msgblocks         := t_msgblocks();

    type t_tabledetails is table of tabledetails%rowtype;
    a_tabledetails              t_tabledetails      := t_tabledetails();
    
    
    m_total_priorityamtnum       NUMBER                             :=  0;
    m_total_contractnum          NUMBER                             :=  0;
    m_debit_txn_sum              NUMBER                             :=  0;
    m_credit_txn_sum             NUMBER                             :=  0;
    m_file_tran_count            NUMBER                             :=  0;
    m_msgdb_id_length            NUMBER                             :=  0;
    loop_ctr                     NUMBER                             :=  0;
    m_msgblocks_beg              NUMBER                             :=  0;
    m_msgblocks_end              NUMBER                             :=  0;
    m_org_message                CLOB;
    l_new_file                   CLOB;
    m_msgdbid_list               CLOB                               := NULL;
    m_value                      VARCHAR2(3000)                     := NULL;
    m_query                      VARCHAR2(3000)                     := NULL;
    m_msgdb_output_mode          VARCHAR2(3000)                     := NULL;
    m_msgdb_id_sub                  VARCHAR2(50)                    :=  0;
    m_total_charges              NUMBER                             :=  0;
    m_row_count                  NUMBER                             :=  0;
    m_contractvar                VARCHAR2(3000)                     := NULL;
    m_contractnum                NUMBER                             :=  0;
    m_time                          VARCHAR2(15);
    m_tenant_list                       VARCHAR2(3000)                     := NULL;
    m_tenantname                        VARCHAR2(3000)                     := NULL;
    m_context_name                      VARCHAR2(3000)                     := NULL;
    m_paramname                         INSTITUTIONPARAMETERS.PARAMNAME%TYPE    := 'TENANT_NAME';
    m_path                              INSTITUTIONPARAMETERS.PATH%TYPE         := 'INSTITUTION_DETAILS';
    m_output_report                     CLOB;
    m_total_amount_clob       NUMBER                             :=  0;
    m_amount_clob       NUMBER                             :=  0;

    m_amount_var            VARCHAR2(17)                    := NULL;
    
BEGIN

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
    SELECT * BULK COLLECT INTO a_tabledetails 
    FROM TABLEDETAILS 
    WHERE TDIDCODE = p_mode 
    AND TDKEY LIKE 'HDR%' ORDER BY TDKEY;

    DBMS_LOB.CREATETEMPORARY(l_new_file,TRUE);
    
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
        dBMS_LOB.writeappend(l_new_file,LENGTH(m_value),m_value);

        p_time := m_time;
    END LOOP;
    
    DBMS_LOB.CREATETEMPORARY(m_msgdbid_list,TRUE);
    
    FOR k IN 1..2
    LOOP
        
        m_msgdb_output_mode     := p_mode||k;
        --DBMS_OUTPUT.PUT_LINE('m_msgdb_output_mode  : '||m_msgdb_output_mode );
          
        IF NVL(p_inst_paramvalue,'N')='N'
        THEN
            OPEN c_msgblocks(m_msgdb_output_mode);
            FETCH c_msgblocks BULK COLLECT  INTO a_msgblocks LIMIT 10000;
        ELSIF NVL(p_inst_paramvalue,'N')='Y'
        THEN
            OPEN c_msgblocks_parentinst(m_msgdb_output_mode);
            FETCH c_msgblocks_parentinst BULK COLLECT  INTO a_msgblocks LIMIT 10000;
        END IF;
        
        
        
       
        LOOP
            m_msgblocks_beg := NVL(a_msgblocks.FIRST, 0);
            m_msgblocks_end := NVL(a_msgblocks.LAST, 0);
        
           
            IF m_msgblocks_end >0
            THEN
                
                FOR rec IN 1..a_msgblocks.count
                LOOP
                    BEGIN
                        IF rec = 1
                        THEN
                            p_return_msgsegr := a_msgblocks(rec).msgsegr;
                        END IF;
                    
                            IF instr(m_tenant_list,m_tenantname)>0
                            THEN
                                m_org_message := encrypt_decrypt_basedon_session_cntx_clob('DECRYPT',p_institutionid,blob_to_clob(a_msgblocks(rec).MSGDB_ID,a_msgblocks(rec).MSGBLOCKTYPE));
                            ELSE
                                m_org_message := blob_to_clob(a_msgblocks(rec).MSGDB_ID,a_msgblocks(rec).MSGBLOCKTYPE);         --picking up file from specific blocktype in msgblocks
                            END IF;
                   --DBMS_OUTPUT.PUT_LINE('m_org_message : '||m_org_message);
                           /*DBMS_LOB.writeappend(l_new_file, LENGTH(m_org_message), m_org_message );
                           DBMS_LOB.writeappend(l_new_file,2,CHR(13)||CHR(10));*/

                        SELECT LENGTH(m_org_message)-LENGTH(REPLACE(m_org_message,chr(10)))  INTO m_row_count FROM DUAL;
                        
                        IF p_mode in ('F003', 'F007')
                        THEN
                            select SUBSTR( m_org_message , 47 , 11 )  into m_contractvar from dual;
                        ELSE
                            select SUBSTR( m_org_message , 11 , 11 )  into m_contractvar from dual;
                        END IF;
                         m_contractnum:= TO_NUMBER(m_contractvar);
                        
                        
                        
                       --DBMS_OUTPUT.PUT_LINE('a_msgblocks(rec).MSGDB_ID : '||a_msgblocks(rec).MSGDB_ID);
                         m_msgdb_id_sub := dbms_lob.instr(m_msgdbid_list, a_msgblocks(rec).MSGDB_ID);
                        IF m_msgdb_id_sub = 0
                        THEN
                            dbms_lob.writeappend(m_msgdbid_list,LENGTH(a_msgblocks(rec).MSGDB_ID)+1,a_msgblocks(rec).MSGDB_ID||'|');
                        END IF;
                       

                   --DBMS_OUTPUT.PUT_LINE('m_msgdbid_list-- : '||m_msgdbid_list);
                   --DBMS_OUTPUT.PUT_LINE('p_file_tran_count : '||p_file_tran_count);
                        IF a_msgblocks(rec).messageclasstype = 'pacs.004.001.02'
                        THEN
                                a_msgblocks(rec).priorityamountnum := a_msgblocks(rec).priorityamountnum - NVL(a_msgblocks(rec).mdbpay_charge_1,0);
                        END IF;
                       
                        m_amount_var :=   TRIM(REPLACE(TO_CHAR(a_msgblocks(rec).priorityamountnum,'09999999999999.99'),'.',''));
                        IF p_mode in ('F003', 'F007')
                        THEN
                            DBMS_OUTPUT.PUT_LINE('inside pmode');
                            m_org_message := replace_with_pos_clob(m_org_message,m_amount_var,14);
                            m_org_message := replace_with_pos_clob(m_org_message,m_amount_var,30);
                            
                            m_total_amount_clob := m_total_amount_clob + NVL(TO_NUMBER(substr(m_org_message,14,16)),0);
                        ELSE
                            m_org_message := replace_with_pos_clob(m_org_message,m_amount_var,41);
                            
                            m_total_amount_clob := m_total_amount_clob + NVL(TO_NUMBER(substr(m_org_message,41,16)),0);
                        END IF;
                        DBMS_LOB.writeappend(l_new_file, LENGTH(m_org_message), m_org_message );
                        DBMS_LOB.writeappend(l_new_file,2,CHR(13)||CHR(10));
                    m_total_priorityamtnum   :=   m_total_priorityamtnum + NVL(a_msgblocks(rec).PRIORITYAMOUNTNUM,0);
                        m_total_contractnum      :=   m_total_contractnum + NVL(m_contractnum,0);
                        IF m_row_count > 0 AND (TRIM(a_msgblocks(rec).mdbpay_charge_1) IS NOT  NULL OR a_msgblocks(rec).mdbpay_charge_1 <> 0)
                        THEN
                        DBMS_OUTPUT.PUT_LINE('a_msgblocks(rec).mdbpay_charge_1 ----- : '||a_msgblocks(rec).mdbpay_charge_1);
                            m_total_charges   :=   m_total_charges + NVL(a_msgblocks(rec).mdbpay_charge_1,0);
                            m_total_charges := TRIM(REPLACE(TO_CHAR(m_total_charges,'09999999999999.99'),'.',''));

                            m_total_contractnum      :=   m_total_contractnum + NVL(m_contractnum,0);
                             
                        END IF;
                    EXCEPTION
                        WHEN OTHERS
                        THEN
                            genaudit_insert_enchash_wrap
                                (null,null,NULL,'EVNTSRVR','FILE','INSERT','GENERATE_EOD_REPORTS Procedure Error : OTHERS1...'||SQLCODE || SQLERRM || dbms_utility.format_error_backtrace
                                || SQLCODE
                                || ':'
                                || SQLERRM
                                || dbms_utility.format_error_backtrace,
                                p_institutionid,
                                0
                                );
                                COMMIT;
                    END;                                

                END LOOP;
            END IF;                
                
            --DBMS_OUTPUT.PUT_LINE('m_msgdbid_list : '||m_msgdbid_list);
            --DBMS_OUTPUT.PUT_LINE('k : '||k);
                
                
            IF NVL(p_inst_paramvalue,'N') ='N'
            THEN
                EXIT WHEN c_msgblocks%NOTFOUND;
                FETCH c_msgblocks BULK COLLECT  INTO a_msgblocks LIMIT 10000;
            ELSIF NVL(p_inst_paramvalue,'N')='Y'
            THEN
                EXIT WHEN c_msgblocks_parentinst%NOTFOUND;
                FETCH c_msgblocks_parentinst BULK COLLECT  INTO a_msgblocks LIMIT 10000;
            END IF;
                
        END LOOP; --END OF MSGDB AND MSGBLOCKS CURSOR
        
        
        IF c_msgblocks%ISOPEN
        THEN
            CLOSE c_msgblocks;
        ELSIF c_msgblocks_parentinst%ISOPEN
        THEN
            CLOSE c_msgblocks_parentinst;
        END IF;
    END LOOP;  --END OF CORE1 and 2      
    
        
    m_msgdb_id_length := NVL(dbms_lob.getlength(m_msgdbid_list), 0);
    
    --DBMS_OUTPUT.PUT_LINE('m_msgdb_id_length : '||m_msgdb_id_length);
                            
    IF  m_msgdb_id_length > 0
    THEN
        a_tabledetails := t_tabledetails();
        
        SELECT * BULK COLLECT INTO a_tabledetails 
        FROM TABLEDETAILS 
        WHERE TDIDCODE = p_mode 
        AND TDKEY LIKE 'TLR%' ORDER BY TDKEY;
        
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
        
        --DBMS_OUTPUT.PUT_LINE('m_file_tran_count : '||m_file_tran_count );
        
        l_new_file:= REPLACE(l_new_file,'NORECORDS',LPAD(m_file_tran_count-2,6,0));
        --l_new_file:= REPLACE(l_new_file,'PRIORITYAMOUNTSUM',TRIM(REPLACE(TO_CHAR(m_total_priorityamtnum+m_total_charges,'09999999999999.99'),'.','')));
        l_new_file:= REPLACE(l_new_file,'PRIORITYAMOUNTSUM',TRIM(REPLACE(TO_CHAR(m_total_amount_clob+m_total_charges,'0999999999999999'),'.','')));
        l_new_file:= REPLACE(l_new_file,'CONTRACTNOSUM',LPAD(m_total_contractnum,18,0));
                  IF instr(m_tenant_list,m_tenantname)>0
                  THEN
                     p_output_report := GET_ENCRYPT_DECRYPT_DATA('ENCRYPT',p_institutionid,converttoblob(l_new_file));
                  ELSE
                     p_output_report         := converttoblob(l_new_file);
    
                  END IF;
        p_msgdbid_list := m_msgdbid_list;

        
--        IF m_msgdbid_list IS NOT NULL
--        THEN
--            SELECT LISTAGG(DISTINCT para_code, '|') 
--            INTO  p_msgdbid_list
--            FROM TABLE (get_code_from_list_clob(m_msgdbid_list, '|')) 
--            WHERE para_code IS NOT NULL;
--        END IF;
        
        --DBMS_OUTPUT.PUT_LINE('p_msgdbid_list : '||p_msgdbid_list);
        
        p_total_amount          := m_total_priorityamtnum;
    
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
    --DBMS_OUTPUT.PUT_LINE('NO_DATA_FOUND');
WHEN OTHERS
THEN
    ROLLBACK;
    genaudit_insert_enchash_wrap
        (null,null,NULL,'EVNTSRVR','FILE','INSERT','GENERATE_EOD_REPORTS Procedure Error : OTHERS...'||SQLCODE || SQLERRM || dbms_utility.format_error_backtrace
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