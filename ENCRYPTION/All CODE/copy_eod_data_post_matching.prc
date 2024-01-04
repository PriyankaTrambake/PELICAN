create or replace PROCEDURE copy_eod_data_post_matching
(
    p_msgdb_id_src              IN MSGDB.msgdb_id%TYPE,
    p_msgdb_id_tgt              IN MSGDB.msgdb_id%TYPE
)
AS
    m_institutionid                        MSGDB.institutionid%TYPE            := NULL;

    CURSOR cursor_institution
    IS
    SELECT     institutionid
    FROM       institutionmaster
    WHERE STATUS = 'V';


    CURSOR c_msgblocks
    (
        c_tdidcode              IN      TABLEDETAILS.TDIDCODE%TYPE,
        c_tdkey                 IN      TABLEDETAILS.TDKEY%TYPE,
        c_msgdb_id              IN      msgdb.msgdb_id%TYPE
    )
    IS
    SELECT  mb.*
    FROM    msgblocks mb
    WHERE   mb.msgdb_id = c_msgdb_id
    AND     mb.msgblocktype IN  (SELECT para_code FROM TABLE(get_code_from_list (td_get_value(c_tdidcode,c_tdkey), ',')))--(SELECT para_code FROM TABLE(get_code_from_list (td_get_value(c_mode,'BLOB|' || c_aggregate_flag), ',')))
    AND     mb.message IS NOT NULL
    ORDER BY msgblocktype;

    CURSOR c_msgdb_output
    (
        c_msgdb_id              IN      msgdb.msgdb_id%TYPE,
        c_tdidcode              IN      VARCHAR2
    )
    IS
    SELECT  *
    FROM    msgdb_output mo
    WHERE   mo.msgdb_id = c_msgdb_id
    AND     MDBOUT_MODE IN ((SELECT para_code FROM TABLE(get_code_from_list (td_get_value(c_tdidcode,'EOD2'), '|'))));

    CURSOR c_msgdb_output_core
    (
        c_msgdb_id              IN      msgdb.msgdb_id%TYPE,
        c_tdidcode              IN      VARCHAR2

    )
    IS
    SELECT  *
    FROM    msgdb_output
    WHERE   msgdb_id = c_msgdb_id
    AND     MDBOUT_MODE IN ((SELECT para_code FROM TABLE(get_code_from_list (td_get_value(c_tdidcode,'EOD_CORE'), '|'))));

    CURSOR c_msgdb
    (
        c_msgdb_id              IN      msgdb.msgdb_id%TYPE
    )
    IS
    SELECT  MSGDB_ID,
            SAP_DR,
            SAP_CR,
            SUB_SAP_DR,
            SUB_SAP_CR,
            AGGREGATE_FLAG,
            GROUPINGINFO_EOD,
            COMPANY_CODE,
            CONTRACT_NUMBER
    FROM    msgdb
    WHERE   msgdb_id = c_msgdb_id;


    TYPE t_msgblocks IS TABLE OF c_msgblocks%ROWTYPE;
    a_msgblocks             t_msgblocks             := t_msgblocks();

    TYPE t_msgblocks_tgt IS TABLE OF c_msgblocks%ROWTYPE;
    a_msgblocks_tgt             t_msgblocks_tgt             := t_msgblocks_tgt();

    TYPE t_msgblocks_chg IS TABLE OF c_msgblocks%ROWTYPE;
    a_msgblocks_chg             t_msgblocks_chg             := t_msgblocks_chg();

    TYPE t_msgdb_output IS TABLE OF c_msgdb_output%ROWTYPE;
    a_msgdb_output          t_msgdb_output          := t_msgdb_output();

    TYPE t_msgdb_output_tgt IS TABLE OF c_msgdb_output%ROWTYPE;
    a_msgdb_output_tgt          t_msgdb_output_tgt          := t_msgdb_output_tgt();

    TYPE t_msgblocktype IS TABLE OF MSGBLOCKS.MSGBLOCKTYPE%TYPE;
    a_msgblocktype             t_msgblocktype             := t_msgblocktype();

    TYPE t_msgdb IS TABLE OF c_msgdb%ROWTYPE;
    a_msgdb             t_msgdb             := t_msgdb();

    TYPE t_msgdb_output_core IS TABLE OF c_msgdb_output_core%ROWTYPE;
    a_msgdb_output_core          t_msgdb_output_core          := t_msgdb_output_core();

    TYPE t_mdboutmode IS TABLE OF MSGDB_OUTPUT.MDBOUT_MODE%TYPE;
    a_mdboutmode             t_mdboutmode             := t_mdboutmode();

    --Parameters for GENAUDIT
    g_queueid                               GENAUDIT.queueid%TYPE                   := NULL;
    g_username                              GENAUDIT.username%TYPE                  := NULL;
    g_application                           GENAUDIT.application%TYPE               := 'PELICAN';
    g_modulename                            GENAUDIT.modulename%TYPE                := 'PAIN_MATCHING';
    g_action                                GENAUDIT.action%TYPE                    := 'MATCHING';
    g_audittext                             GENAUDIT.audittext%TYPE                 := NULL;
    g_messageno                             GENAUDIT.messageno%TYPE                 := NULL;
    g_institutionid                         GENAUDIT.institutionid%TYPE             := NULL;
    m_audittext                             GENAUDIT.audittext%TYPE                 := NULL;


    --eod related
    m_eod_conf                              TABLEDETAILS.TDVALUE%TYPE;
    m_tdidcode_eod                          TABLEDETAILS.TDIDCODE%TYPE              := 'EODREP_CONF';
    m_tdkey_eod                             TABLEDETAILS.TDKEY%TYPE                 := 'EOD';
    m_copy_clob                             CLOB;
    m_charge_clob_1                         CLOB;
    m_charge_clob_2                         CLOB;
    m_msgdblocks_beg                        NUMBER                                  :=  0;
    m_msgdblocks_end                        NUMBER                                  :=  0;
    m_msgdb_output_beg                      NUMBER                                  :=  0;
    m_msgdb_output_end                      NUMBER                                  :=  0;
    m_msgclstype_src                        MSGDB.MESSAGECLASSTYPE%TYPE            := NULL;
    m_msgblocktype_src                      MSGBLOCKS.MSGBLOCKTYPE%TYPE             :=0;
    m_msgblocktype_beg                      NUMBER                                  :=  0;
    m_msgblocktype_end                      NUMBER                                  :=  0;
    m_tdkey_blobs                           TABLEDETAILS.TDKEY%TYPE                 := 'BLOBS';
    m_tdkey_sap_blobs                       TABLEDETAILS.TDKEY%TYPE                 := 'BLOBS_SAP';
    m_tdkey_core_blobs                      TABLEDETAILS.TDKEY%TYPE                 := 'BLOBS_CORE';
    m_tdkey_sap_core_blobs                  TABLEDETAILS.TDKEY%TYPE                 := 'BLOBS_SAP_CORE';
    m_msgdb_beg                             NUMBER                                  :=  0;
    m_msgdb_end                             NUMBER                                  :=  0;
    m_mdboutmode_beg                        NUMBER                                  :=  0;
    m_mdboutmode_end                        NUMBER                                  :=  0;
    m_output_core_beg                       NUMBER                                  :=  0;
    m_output_core_end                       NUMBER                                  :=  0;
    --m_charges                               MSGDB_PAY.MDBPAY_CHARGE_1%TYPE          := 0;
    m_charges                               VARCHAR2(100)                                := NULL;
    m_msgblks_chg_beg                       NUMBER                                  :=  0;
    m_msgblks_chg_end                       NUMBER                                  :=  0;
    INVALID_MSGTYPE                             EXCEPTION;
    m_msgblocktype_decode                       NUMBER                              :=  0;
m_paramname                         INSTITUTIONPARAMETERS.PARAMNAME%TYPE    := 'TENANT_NAME';
    m_path                              INSTITUTIONPARAMETERS.PATH%TYPE         := 'INSTITUTION_DETAILS';
    m_tenant_list                       VARCHAR2(3000)                  := NULL;
    m_tenantname                        VARCHAR2(3000)                  := NULL;
    m_context_name                      VARCHAR2(3000)                  := NULL;



BEGIN

    SELECT  m.messageclasstype ,m.institutionid
    INTO  m_msgclstype_src , m_institutionid
    FROM  msgdb m
    WHERE  m.msgdb_id = p_msgdb_id_src;

                m_tenantname   := NVL(Get_Institution_Param_Value(m_institutionid,m_path,m_paramname),'XXX');
                --DBMS_OUTPUT.PUT_LINE('m_tenantname -->'||m_tenantname);

                  BEGIN

                       SELECT TDVALUE
                       INTO m_context_name
                       FROM TABLEDETAILS
                       WHERE TDIDCODE ='CONTEXT'
                       AND
                       TDKEY = m_tenantname ;
                        --DBMS_OUTPUT.PUT_LINE('m_context_name -->'||m_context_name);

                  EXCEPTION
                       WHEN NO_DATA_FOUND
                      THEN

                          DBMS_OUTPUT.PUT_LINE ('No CONTEXT found ');
                  END;
                --DBMS_OUTPUT.PUT_LINE('m_context_name '||m_context_name);

                m_tenant_list := sys_context(m_context_name,'ENCRYPTION_TENANT_LIST');
                --DBMS_OUTPUT.PUT_LINE('m_tenant_list : ' || m_tenant_list);

        IF m_msgclstype_src = 'NAK'
        THEN
            --DBMS_OUTPUT.PUT_LINE('SAP/SUBSAP BLOBS');
            OPEN c_msgblocks(m_tdidcode_eod,m_tdkey_sap_blobs,p_msgdb_id_tgt);   --cursor for only sap and subsap blobs
            FETCH c_msgblocks BULK COLLECT INTO a_msgblocks;
            CLOSE c_msgblocks;

        ELSIF m_msgclstype_src = 'pacs.002.001.03'
        THEN
            --DBMS_OUTPUT.PUT_LINE('ALL EOD BLOBS');                              -- cursor for all eod blobs
            OPEN c_msgblocks(m_tdidcode_eod,m_tdkey_blobs,p_msgdb_id_tgt);
            FETCH c_msgblocks BULK COLLECT INTO a_msgblocks;
            CLOSE c_msgblocks;

        ELSE

            RAISE INVALID_MSGTYPE;

        END IF;

        m_msgdblocks_beg := NVL(a_msgblocks.FIRST, 0);
        m_msgdblocks_end := NVL(a_msgblocks.LAST, 0);

        --DBMS_OUTPUT.PUT_LINE('m_msgdblocks_end  : ' || m_msgdblocks_end);

        IF m_msgdblocks_end > 0
        THEN
            --DBMS_OUTPUT.PUT_LINE('m_msgdblocks_end > 0');
            --DBMS_OUTPUT.PUT_LINE('p_msgdb_id_tgt  : ' || p_msgdb_id_tgt);
            --DBMS_OUTPUT.PUT_LINE('p_msgdb_id_src  : ' || p_msgdb_id_src);
            --DBMS_OUTPUT.PUT_LINE('m_msgclstype_src  : ' || m_msgclstype_src);
            --DBMS_OUTPUT.PUT_LINE('m_msgblocktype_src  : ' || m_msgblocktype_src);

            FOR rec IN m_msgdblocks_beg..m_msgdblocks_end
            LOOP
                BEGIN
                    --DBMS_OUTPUT.PUT_LINE('a_msgblocks(rec).MSGBLOCKTYPE  : ' || a_msgblocks(rec).MSGBLOCKTYPE);
                    --DBMS_OUTPUT.PUT_LINE('rec  : ' || rec);

                    IF instr(m_tenant_list,m_tenantname)>0
                    THEN
                        m_copy_clob :=encrypt_decrypt_basedon_session_cntx_clob('DECRYPT',m_institutionid, blob_to_clob(p_msgdb_id_tgt,a_msgblocks(rec).msgblocktype));
                       --DBMS_OUTPUT.PUT_LINE('m_copy_clob  : ' || m_copy_clob);
                    ELSE
                        m_copy_clob := blob_to_clob(p_msgdb_id_tgt,a_msgblocks(rec).msgblocktype);
                    END IF;

                    IF m_msgclstype_src = 'NAK'
                    THEN

                        --DBMS_OUTPUT.PUT_LINE('NAK');
                        IF  INSTR(m_copy_clob,'H',43) = 43
                        THEN
                            m_copy_clob := replace_with_pos_clob(m_copy_clob,'S',43);           --credit/debit reverse for NAK
                        ELSIF INSTR(m_copy_clob,'S',43) = 43
                        THEN
                            m_copy_clob := replace_with_pos_clob(m_copy_clob,'H',43);           --credit/debit reverse for NAK
                        END IF;

                    ELSIF m_msgclstype_src = 'pacs.002.001.03' AND a_msgblocks(rec).msgblocktype IN (164,167,169,170)
                    THEN
                        IF  INSTR(m_copy_clob,'DDT',1) = 1
                        THEN
                            m_copy_clob := replace_with_pos_clob(m_copy_clob,'RDD',1);          --DDT to RDD for pacs002 and core blobs only
                        END IF;

                        OPEN c_msgdb_output_core(p_msgdb_id_src, m_tdidcode_eod);
                        FETCH c_msgdb_output_core BULK COLLECT INTO a_msgdb_output_core;
                        CLOSE c_msgdb_output_core;

                        m_output_core_beg := nvl(a_msgdb_output_core.first, 0);
                        m_output_core_end := nvl(a_msgdb_output_core.last, 0);

                        IF m_output_core_end> 0
                        THEN
                            FOR k IN m_output_core_beg..m_output_core_end
                            LOOP
                                IF a_msgdb_output_core(k).mdbout_mode in ('F0031','F0032', 'F0071','F0072')
                                THEN
                                    IF INSTR(m_copy_clob,'C',46) = 46
                                    THEN
                                        m_copy_clob := replace_with_pos_clob(m_copy_clob,'D',46);           -- credit to debit for pacs002 and core blobs only
                                    END IF;
                                ELSE
                                    IF INSTR(m_copy_clob,'C',57) = 57
                                    THEN
                                        m_copy_clob := replace_with_pos_clob(m_copy_clob,'D',57);           -- credit to debit for pacs002 and core blobs only
                                    END IF;
                                END IF;
                            END LOOP;
                        END IF;
                    ELSIF m_msgclstype_src = 'pacs.002.001.03' AND a_msgblocks(rec).msgblocktype IN (162,163,165,166)
                    THEN

                        IF  INSTR(m_copy_clob,'H',43) = 43
                        THEN
                            m_copy_clob := replace_with_pos_clob(m_copy_clob,'S',43);           --credit/debit reverse for pacs002 and core blobs only
                        ELSIF INSTR(m_copy_clob,'S',43) = 43
                        THEN
                            m_copy_clob := replace_with_pos_clob(m_copy_clob,'H',43);           --credit/debit reverse for pacs002 and core blobs only
                        END IF;

                    END IF;

                    --DBMS_OUTPUT.PUT_LINE(' a_msgblocks(rec).msgblocktype : ' || a_msgblocks(rec).msgblocktype);
                    --DBMS_OUTPUT.PUT_LINE(' a_msgblocks(a_msgblocks.LAST).MSGFAMILY : ' ||a_msgblocks(a_msgblocks.LAST).MSGFAMILY);
                    --DBMS_OUTPUT.PUT_LINE(' p_msgdb_id_src : ' ||p_msgdb_id_src);

                    a_msgblocktype.EXTEND;

                    SELECT   mb.msgblocktype
                    BULK COLLECT INTO a_msgblocktype--collecting existing blocktypes with empty message
                    FROM msgblocks mb
                    WHERE mb.msgdb_id = p_msgdb_id_src
                    --AND mb.msgblocktype = a_msgblocks (rec).msgblocktype
                    AND mb.msgblocktype = DECODE (a_msgblocks (rec).msgblocktype,162,165,165,162,163,166,166,163,a_msgblocks (rec).msgblocktype)
                    AND mb.MESSAGE IS NULL
                    ORDER BY msgblocktype;

                    m_msgblocktype_beg := NVL(a_msgblocktype.FIRST, 0);
                    m_msgblocktype_end := NVL(a_msgblocktype.LAST, 0);

                    --DBMS_OUTPUT.PUT_LINE(' m_msgblocktype_beg: ' || m_msgblocktype_beg);
                    --DBMS_OUTPUT.PUT_LINE(' m_msgblocktype_end: ' || m_msgblocktype_end);

                    IF m_msgblocktype_end >0
                    THEN

                        FOR i in m_msgblocktype_beg..m_msgblocktype_end
                        LOOP

                            BEGIN

                                --DBMS_OUTPUT.PUT_LINE(' i : ' || i );

                                --DBMS_OUTPUT.PUT_LINE(' UPDATE ');           --if existing blob found then update




                                IF instr(m_tenant_list,m_tenantname)>0
                                THEN
                                    UPDATE MSGBLOCKS
                                    SET MESSAGE = clob_to_blob(encrypt_decrypt_basedon_session_cntx_clob('ENCRYPT',m_institutionid, m_copy_clob))
                                    WHERE MSGDB_ID = p_msgdb_id_src
                                    AND MSGBLOCKTYPE = a_msgblocktype(i);
                                ELSE
                                    UPDATE MSGBLOCKS
                                    SET MESSAGE = clob_to_blob(m_copy_clob)
                                    WHERE MSGDB_ID = p_msgdb_id_src
                                    AND MSGBLOCKTYPE = a_msgblocktype(i);
                                 END IF;


                            EXCEPTION
                            WHEN OTHERS
                            THEN
                                --DBMS_OUTPUT.PUT_LINE ('OTHERS...'||SQLCODE || SQLERRM || dbms_utility.format_error_backtrace);
                            ROLLBACK;

                            END;

                        END LOOP;

                    ELSE

                        --DBMS_OUTPUT.PUT_LINE(' INSERT ');
                        --m_insert_flag := TRUE;
                        a_msgblocks_tgt.EXTEND;                                                         -- if existing blob not found then insert
                        a_msgblocks_tgt(a_msgblocks_tgt.LAST)               :=      a_msgblocks(rec);
                        a_msgblocks_tgt(a_msgblocks_tgt.LAST).msgdb_id      :=      p_msgdb_id_src;
                        --a_msgblocks_tgt(a_msgblocks_tgt.LAST).message       :=      clob_to_blob(m_copy_clob);
                        --a_msgblocks_tgt(a_msgblocks_tgt.LAST).msgblocktype  :=      a_msgblocks(rec).msgblocktype;
                        IF instr(m_tenant_list,m_tenantname)>0
                        THEN
                            a_msgblocks_tgt(a_msgblocks_tgt.LAST).message       :=      clob_to_blob(encrypt_decrypt_basedon_session_cntx_clob('ENCRYPT',m_institutionid, m_copy_clob));
                        ELSE
                            a_msgblocks_tgt(a_msgblocks_tgt.LAST).message       :=      clob_to_blob(m_copy_clob);
                        END IF;
			IF m_msgclstype_src IN ('pacs.002.001.03','NAK') AND a_msgblocks(rec).msgblocktype IN (162,163,165,166)
                        THEN
                        --a_msgblocks_tgt(a_msgblocks_tgt.LAST).MSGBLOCKTYPE   :=
                            SELECT  DECODE (a_msgblocks(rec).msgblocktype,162,165,165,162,163,166,166,163,a_msgblocks(rec).msgblocktype)
                             INTO   m_msgblocktype_decode FROM DUAL;

                             a_msgblocks_tgt(a_msgblocks_tgt.LAST).MSGBLOCKTYPE := m_msgblocktype_decode;
                        END IF;

                    END IF;

                   -- a_msgblocktype  :=  t_msgblocktype();

                EXCEPTION
                WHEN DUP_VAL_ON_INDEX
                THEN
                    DBMS_OUTPUT.PUT_LINE('EXCEPTION: DUP_VALUE_ON_INDEX' || dbms_utility.format_error_backtrace);
                WHEN OTHERS
                THEN
                    --DBMS_OUTPUT.PUT_LINE ('OTHERS...'||SQLCODE || SQLERRM || dbms_utility.format_error_backtrace);
                    ROLLBACK;
                END;


            END LOOP;

            --DBMS_OUTPUT.PUT_LINE(' insert a_msgblocks_tgt.LAST: ' || a_msgblocks_tgt.LAST);

            IF a_msgblocks_tgt.LAST > 0
            THEN
                FORALL rec IN a_msgblocks_tgt.FIRST..a_msgblocks_tgt.LAST
                INSERT INTO MSGBLOCKS VALUES a_msgblocks_tgt(rec);
            END IF;

        END IF;

        OPEN c_msgdb_output(p_msgdb_id_tgt,m_tdidcode_eod);                     --cursor for msgdb_output entries
        FETCH c_msgdb_output BULK COLLECT INTO a_msgdb_output;
        CLOSE c_msgdb_output;

         m_msgdb_output_beg := NVL(a_msgdb_output.FIRST, 0);
         m_msgdb_output_end := NVL(a_msgdb_output.LAST, 0);

        --DBMS_OUTPUT.PUT_LINE('m_msgdb_output_end  : ' || m_msgdb_output_end);

         IF m_msgdb_output_end > 0
         THEN

            FOR rec1 IN m_msgdb_output_beg..m_msgdb_output_end
            LOOP
                BEGIN


                    a_mdboutmode.EXTEND;

                    SELECT MDBOUT_MODE BULK COLLECT INTO a_mdboutmode                   --collecting existing MDBOUT_MODE
                    FROM    msgdb_output
                    WHERE   msgdb_id = p_msgdb_id_src
                    AND     MDBOUT_MODE = a_msgdb_output(rec1).MDBOUT_MODE;

                    m_mdboutmode_beg := NVL(a_mdboutmode.FIRST, 0);
                    m_mdboutmode_end := NVL(a_mdboutmode.LAST, 0);

                    --DBMS_OUTPUT.PUT_LINE(' m_mdboutmode_beg: ' || m_mdboutmode_beg);
                    --DBMS_OUTPUT.PUT_LINE(' m_mdboutmode_end: ' || m_mdboutmode_end);

                    IF m_mdboutmode_end >0
                    THEN

                        FOR j in m_mdboutmode_beg..m_mdboutmode_end
                        LOOP

                            BEGIN

                                --DBMS_OUTPUT.PUT_LINE(' j : ' || j );

                                --DBMS_OUTPUT.PUT_LINE(' UPDATE ');               --if output_mode present then update status
                                UPDATE MSGDB_OUTPUT
                                SET MDBOUT_STATUS = 'A'
                                WHERE MSGDB_ID = p_msgdb_id_src
                                AND MDBOUT_MODE = a_mdboutmode(j);

                            EXCEPTION
                            WHEN OTHERS
                            THEN
                                --DBMS_OUTPUT.PUT_LINE ('OTHERS...'||SQLCODE || SQLERRM || dbms_utility.format_error_backtrace);
                            ROLLBACK;

                            END;

                        END LOOP;

                    ELSE

                        --DBMS_OUTPUT.PUT_LINE(' INSERT ');

                        a_msgdb_output_tgt.EXTEND;                                                              --if output_mode not present then insert
                        a_msgdb_output_tgt(a_msgdb_output_tgt.LAST)                     :=   a_msgdb_output(rec1);
                        a_msgdb_output_tgt(a_msgdb_output_tgt.LAST).msgdb_id            :=   p_msgdb_id_src;
                        a_msgdb_output_tgt(a_msgdb_output_tgt.LAST).MDBOUT_STATUS         :=   'A';
                        a_msgdb_output_tgt(a_msgdb_output_tgt.LAST).MDBOUT_DATE_TIME    :=   SYSTIMESTAMP;



                    END IF;


                EXCEPTION
                WHEN DUP_VAL_ON_INDEX
                THEN
                    --DBMS_OUTPUT.PUT_LINE('EXCEPTION: DUP_VALUE_ON_INDEX' || dbms_utility.format_error_backtrace);
                    CONTINUE;

                WHEN OTHERS
                THEN
                    --DBMS_OUTPUT.PUT_LINE ('OTHERS...'||SQLCODE || SQLERRM || dbms_utility.format_error_backtrace);
                    ROLLBACK;

                END;

            END LOOP;

                 --DBMS_OUTPUT.PUT_LINE(' insert m_msgdb_output_beg: ' || m_msgdb_output_beg);
                --DBMS_OUTPUT.PUT_LINE(' insert m_msgdb_output_end: ' || m_msgdb_output_end);

                IF a_msgdb_output_tgt.LAST > 0
                THEN
                    FORALL rec1 IN a_msgdb_output_tgt.FIRST..a_msgdb_output_tgt.LAST
                    INSERT INTO MSGDB_OUTPUT VALUES a_msgdb_output_tgt(rec1);
                END IF;

         END IF;

        OPEN c_msgdb(p_msgdb_id_tgt);                                       --cursor for eod columns in msgdb for pacs002 and NAK
        FETCH c_msgdb BULK COLLECT INTO a_msgdb;
        CLOSE c_msgdb;

        m_msgdb_beg := NVL(a_msgdb.FIRST, 0);
        m_msgdb_end := NVL(a_msgdb.LAST, 0);

        --DBMS_OUTPUT.PUT_LINE('m_msgdb_end  : ' || m_msgdb_end);

        IF m_msgdb_end > 0
        THEN

            FOR rec2 IN m_msgdb_beg..m_msgdb_end
            LOOP

               BEGIN

                        --DBMS_OUTPUT.PUT_LINE('c_msgdb INSERT ');

                UPDATE MSGDB                                                --updating eod columns
                SET     SAP_DR              = DECODE(m_msgclstype_src,'pacs.002.001.03',a_msgdb(rec2).SAP_CR,a_msgdb(rec2).SAP_DR),
                        SAP_CR              = DECODE(m_msgclstype_src,'pacs.002.001.03',a_msgdb(rec2).SAP_DR,a_msgdb(rec2).SAP_CR),
                        SUB_SAP_DR          = DECODE(m_msgclstype_src,'pacs.002.001.03',a_msgdb(rec2).SUB_SAP_CR,a_msgdb(rec2).SUB_SAP_DR),
                        SUB_SAP_CR          = DECODE(m_msgclstype_src,'pacs.002.001.03',a_msgdb(rec2).SUB_SAP_DR,a_msgdb(rec2).SUB_SAP_CR),
                        AGGREGATE_FLAG      = a_msgdb(rec2).AGGREGATE_FLAG,
                        GROUPINGINFO_EOD    = a_msgdb(rec2).GROUPINGINFO_EOD,
                        COMPANY_CODE        = a_msgdb(rec2).COMPANY_CODE,
                        CONTRACT_NUMBER     = a_msgdb(rec2).CONTRACT_NUMBER
                WHERE   MSGDB_ID            = p_msgdb_id_src;

               EXCEPTION
               WHEN DUP_VAL_ON_INDEX
               THEN
                    --DBMS_OUTPUT.PUT_LINE('EXCEPTION: DUP_VALUE_ON_INDEX' || dbms_utility.format_error_backtrace);
                    EXIT;

               WHEN OTHERS
               THEN
                    --DBMS_OUTPUT.PUT_LINE ('OTHERS...'||SQLCODE || SQLERRM || dbms_utility.format_error_backtrace);
                    ROLLBACK;

               END;

            END LOOP;

        END IF;

        IF m_msgclstype_src = 'pacs.002.001.03'
        THEN
            --DBMS_OUTPUT.PUT_LINE('SAP/SUBSAP/CORE BLOBS');
            OPEN c_msgblocks(m_tdidcode_eod,m_tdkey_sap_core_blobs,p_msgdb_id_tgt);   --cursor for only core blobs
            FETCH c_msgblocks BULK COLLECT INTO a_msgblocks_chg;
            CLOSE c_msgblocks;

            m_msgblks_chg_beg := NVL(a_msgblocks_chg.FIRST, 0);
            m_msgblks_chg_end := NVL(a_msgblocks_chg.LAST, 0);

            --DBMS_OUTPUT.PUT_LINE('m_msgblks_chg_end  : ' || m_msgblks_chg_end);

            IF m_msgblks_chg_end > 0
            THEN

                --DBMS_OUTPUT.PUT_LINE('m_msgblks_chg_end > 0');

                FOR rec3 IN m_msgblks_chg_beg..m_msgblks_chg_end
                LOOP

                    BEGIN

                        SELECT mdbpay_charge_1 INTO m_charges FROM msgdb_pay mp WHERE msgdb_id = p_msgdb_id_src AND mdbpay_charge_1 > 0;


                        IF m_charges > 0
                        THEN

                            --m_charges :=    LPAD(m_charges,16,'0');

                            m_charges :=TRIM(REPLACE(TO_CHAR(m_charges,'09999999999999.99'),'.',''));
                            --DBMS_OUTPUT.PUT_LINE('m_charges  : ' || m_charges);



                            IF instr(m_tenant_list,m_tenantname)>0
                            THEN
                                m_charge_clob_1 := encrypt_decrypt_basedon_session_cntx_clob('DECRYPT',m_institutionid, blob_to_clob(p_msgdb_id_tgt,a_msgblocks_chg(rec3).msgblocktype));
                                m_charge_clob_2 := encrypt_decrypt_basedon_session_cntx_clob('DECRYPT',m_institutionid, blob_to_clob(p_msgdb_id_tgt,a_msgblocks_chg(rec3).msgblocktype));

                            ELSE
                                m_charge_clob_1 := blob_to_clob(p_msgdb_id_tgt,a_msgblocks_chg(rec3).msgblocktype);
                                m_charge_clob_2 := blob_to_clob(p_msgdb_id_tgt,a_msgblocks_chg(rec3).msgblocktype);

                            END IF;


                            --DBMS_OUTPUT.PUT_LINE('m_charge_clob_1  : ' || m_charge_clob_1);
                            --DBMS_OUTPUT.PUT_LINE('m_charge_clob_2  : ' || m_charge_clob_2);

                            IF m_msgclstype_src = 'pacs.002.001.03' AND a_msgblocks(rec3).msgblocktype IN (162,163,165,166)     --sap/subsap blobs
                            THEN

                                m_charge_clob_1 := replace_with_pos_clob(m_charge_clob_1,m_charges,27);
                                m_charge_clob_1 := replace_with_pos_clob(m_charge_clob_1,m_charges,44);     --charges amount replace

                                IF a_msgblocks_chg(rec3).msgblocktype IN (162,163)
                                THEN

                                    --a_msgblocks_chg(rec3).msgblocktype  := 171;
                                    a_msgblocks_chg(rec3).msgblocktype  := 172;  --charges blocktype replace


                                ELSIF a_msgblocks_chg(rec3).msgblocktype IN (165,166)
                                THEN

                                    --a_msgblocks_chg(rec3).msgblocktype  :=  172;
                                    a_msgblocks_chg(rec3).msgblocktype  :=  171;   --charges blocktype replace

                                END IF;

                                IF  INSTR(m_charge_clob_1,'H',43) = 43
                                THEN
                                    m_charge_clob_1 := replace_with_pos_clob(m_charge_clob_1,'S',43);           --credit/debit reverse
                                ELSIF INSTR(m_charge_clob_1,'S',43) = 43
                                THEN
                                    m_charge_clob_1 := replace_with_pos_clob(m_charge_clob_1,'H',43);           --credit/debit reverse
                                END IF;

                            ELSIF m_msgclstype_src = 'pacs.002.001.03' AND a_msgblocks(rec3).msgblocktype IN (164,167,169,170)  --core blobs
                            THEN
                                OPEN c_msgdb_output_core(p_msgdb_id_src,m_tdidcode_eod );
                                FETCH c_msgdb_output_core BULK COLLECT INTO a_msgdb_output_core;
                                CLOSE c_msgdb_output_core;

                                m_output_core_beg := nvl(a_msgdb_output_core.first, 0);
                                m_output_core_end := nvl(a_msgdb_output_core.last, 0);

                                IF m_output_core_end> 0
                                THEN
                                    FOR k IN m_output_core_beg..m_output_core_end
                                    LOOP
                                        IF a_msgdb_output_core(k).mdbout_mode in ('F0031','F0032', 'F0071','F0072')
                                        THEN
                                            IF INSTR(m_charge_clob_1,'C',46) = 46
                                            THEN
                                                m_charge_clob_1 := replace_with_pos_clob(m_copy_clob,'D',46);     -- credit to debit reverse
                                            END IF;
                                        ELSE
                                            IF INSTR(m_charge_clob_1,'C',57) = 57
                                            THEN
                                                m_charge_clob_1 := replace_with_pos_clob(m_copy_clob,'D',57);           -- credit to debit for pacs002 and core blobs only
                                            END IF;
                                        END IF;
                                    END LOOP;
                                END IF;
                                m_charge_clob_2 := m_charge_clob_1;

                                IF  INSTR(m_copy_clob,'RDD',1) = 1
                                THEN
                                    m_charge_clob_2 := replace_with_pos_clob(m_charge_clob_2,'CHG',1);          --DDT to RDD for pacs002 and core blobs only
                                END IF;


                                OPEN c_msgdb_output_core(p_msgdb_id_src,m_tdidcode_eod );
                                FETCH c_msgdb_output_core BULK COLLECT INTO a_msgdb_output_core;
                                CLOSE c_msgdb_output_core;
                                m_output_core_beg := nvl(a_msgdb_output_core.first, 0);
                                m_output_core_end := nvl(a_msgdb_output_core.last, 0);

                                IF m_output_core_end> 0
                                THEN
                                    FOR k IN m_output_core_beg..m_output_core_end
                                    LOOP
                                        IF a_msgdb_output_core(k).mdbout_mode in ('F0031','F0032', 'F0071','F0072')
                                        THEN
                                            m_charge_clob_2 := replace_with_pos_clob(m_charge_clob_2,m_charges,14);
                                            m_charge_clob_2 := replace_with_pos_clob(m_charge_clob_2,m_charges,30);
                                        ELSE
                                            m_charge_clob_2 := replace_with_pos_clob(m_charge_clob_2,m_charges,41);
                                        END IF;
                                    END LOOP;
                                END IF;
                                DBMS_LOB.writeappend(m_charge_clob_1,2,CHR(13)||CHR(10));

                                DBMS_LOB.writeappend(m_charge_clob_1, LENGTH(m_charge_clob_2), m_charge_clob_2 );

                            END IF;


                        END IF;


                        --DBMS_OUTPUT.PUT_LINE('a_msgblocks_chg(rec3).msgblocktype: ' || a_msgblocks_chg(rec3).msgblocktype);


                            IF a_msgblocks_chg(rec3).msgblocktype IN (164,167,169,170)        --if existing blob found then update
                            THEN
                                --DBMS_OUTPUT.PUT_LINE(' UPDATE ');

                                IF instr(m_tenant_list,m_tenantname)>0
                                THEN

                                    UPDATE  MSGBLOCKS
                                    SET     MESSAGE         =   clob_to_blob(encrypt_decrypt_basedon_session_cntx_clob('ENCRYPT',m_institutionid,m_charge_clob_1 ))
                                    WHERE   MSGBLOCKTYPE    =   a_msgblocks_chg(rec3).msgblocktype
                                    AND     MSGDB_ID        =   p_msgdb_id_src;

                                ELSE
                                    UPDATE  MSGBLOCKS
                                    SET     MESSAGE         =   clob_to_blob(m_charge_clob_1)
                                    WHERE   MSGBLOCKTYPE    =   a_msgblocks_chg(rec3).msgblocktype
                                    AND     MSGDB_ID        =   p_msgdb_id_src;

                                END IF;
                            END IF;

                            --DBMS_OUTPUT.PUT_LINE('a_msgblocks_chg(rec3).msgblocktype charge: ' || a_msgblocks_chg(rec3).msgblocktype);

                            --DBMS_OUTPUT.PUT_LINE(' INSERT ');

                            a_msgblocks_chg(rec3).msgdb_id := p_msgdb_id_src;
                            IF instr(m_tenant_list,m_tenantname)>0
                            THEN
                                a_msgblocks_chg(rec3).message := clob_to_blob(encrypt_decrypt_basedon_session_cntx_clob('ENCRYPT',m_institutionid,m_charge_clob_1 ));
                            ELSE
                            a_msgblocks_chg(rec3).message := clob_to_blob(m_charge_clob_1);
                            END IF;


                            IF a_msgblocks_chg(rec3).msgblocktype IN (171,172)
                            THEN

                                INSERT INTO MSGBLOCKS VALUES a_msgblocks_chg(rec3);

                            END IF;

                    EXCEPTION
                    WHEN DUP_VAL_ON_INDEX
                    THEN
                        DBMS_OUTPUT.PUT_LINE('EXCEPTION: DUP_VALUE_ON_INDEX' || dbms_utility.format_error_backtrace);

                    WHEN OTHERS
                    THEN
                        DBMS_OUTPUT.PUT_LINE ('OTHERS...'||SQLCODE || SQLERRM || dbms_utility.format_error_backtrace);
                    END;


                END LOOP;

            END IF;

        END IF;

        COMMIT;

EXCEPTION
   WHEN INVALID_MSGTYPE
   THEN
         --DBMS_OUTPUT.PUT_LINE ('INVALID_MSGTYPE ');
         NULL;

   WHEN NO_DATA_FOUND
   THEN
       --DBMS_OUTPUT.PUT_LINE ('No Data FOUND.... or passed parameter containing NULL or improper record...'||SQLCODE || SQLERRM || dbms_utility.format_error_backtrace);
      ROLLBACK;
   WHEN OTHERS
   THEN
       --DBMS_OUTPUT.PUT_LINE ('OTHERS...'||SQLCODE || SQLERRM || dbms_utility.format_error_backtrace);
      ROLLBACK;
END;