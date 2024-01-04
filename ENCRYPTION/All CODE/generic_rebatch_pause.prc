create or replace PROCEDURE generic_rebatch_pause
(
    p_batch_msgdbid_src     IN MSGDB.msgdb_id%TYPE, -- 123
    p_batch_qid_src         IN OUT MSGDB.queueid%TYPE,  -- REBTCHQ
    p_batch_cust13_src         IN MSGDB.custom13%TYPE, -- SERVICES
    p_batch_status            IN OUT MSGDB.status%TYPE, -- 304
    p_batch_all_txn_cnt     IN NUMBER, -- TOTAL BATCH TRANSACTION COUNT
    p_batch_del_txn_cnt     IN NUMBER, -- TOTAL CANCEL TRANSACTION
    p_batch_int_txn_cnt     IN NUMBER, -- TOTAL PAUSE TRANSACTION
    p_institutionid            IN MSGDB.institutionid%TYPE
)
AS
    TYPE t_msgdb        IS TABLE OF MSGDB%ROWTYPE;
    TYPE t_msgdb_batch  IS TABLE OF MSGDB_BATCH%ROWTYPE;
    TYPE t_msgblocks    IS TABLE OF MSGBLOCKS%ROWTYPE;
    TYPE t_msgdb_links  IS TABLE OF MSGDB_LINKS%ROWTYPE;
    TYPE t_msgdb_id     IS TABLE OF MSGDB.msgdb_id%TYPE;


    NO_TRANSACTIONS_FOUND    EXCEPTION;
    NO_BATCHES_FOUND         EXCEPTION;

    btch_msgdb               t_msgdb                     := t_msgdb();
    btch_msgblocks           t_msgblocks                 := t_msgblocks();

    tran_msgdb               t_msgdb                     := t_msgdb();
    btch_msgdb_new           t_msgdb                     := t_msgdb();
    msgdb_batch_new          t_msgdb_batch               := t_msgdb_batch();
    msgdb_links_new          t_msgdb_links               := t_msgdb_links();

    n_msgdb_id               t_msgdb_id                  := t_msgdb_id();


    m_msgdb_id_last_txn      MSGDB.msgdb_id%TYPE         := 0;
    m_option_list            MSGDB.custom13%TYPE         := NULL;

    m_msgdb_id_batch_new     MSGDB.msgdb_id%TYPE                 := 0;
    m_messageno_batch_new    MSGDB.messageno%TYPE                := 0;
    tran_ctr_beg             NUMBER                             := 0;
    tran_ctr_end             NUMBER                             := 0;
    next_btch_qid            TABLEDETAILS.tdvalue%TYPE          :=  NULL;--'PAUSBTHQ';
    next_tran_qid            TABLEDETAILS.tdvalue%TYPE          := NULL; --NULL;'PAUSTXNQ'
    old_btch_qid             TABLEDETAILS.tdvalue%TYPE          := NULL;
    old_tran_btch_qid        TABLEDETAILS.tdvalue%TYPE          := NULL;
    old_custom13             TABLEDETAILS.tdvalue%TYPE          := NULL;
    m_btch_qid_cancel        MSGDB.queueid%TYPE                 := 'BTPROCDQ';
    m_status_cancel          MSGDB.status%TYPE                  := 102;
    m_status_available       MSGDB.status%TYPE                  := 69;
    m_status_final           MSGDB.status%TYPE                  := 79;
    m_status_retired         MSGDB.status%TYPE                  := 290;
    m_sysdate                DATE;
    m_systimestamp           TIMESTAMP WITH TIME ZONE;
    m_systime                MSGDB.inputtime%TYPE;
    m_mdbbt_num_of_msgs      MSGDB_BATCH.mdbbt_num_of_msgs%TYPE := 0;
    m_priorityamountnum      MSGDB.priorityamountnum%TYPE       := 0;
    m_td_msg_status             TABLEDETAILS.tdvalue%TYPE            := '69|296|304';
    m_tenant_list                   VARCHAR2(32664)     := NULL;
    m_tenant                        VARCHAR2(32664)     := NULL;
    m_decrypt                               VARCHAR2(32664)                         := 'DECRYPT';
    m_encrypt                               VARCHAR2(32664)                         := 'ENCRYPT';

    t_account_dr             msgdb_batch.mdbbt_custnum1%TYPE    := 0;
    g_action                 GENAUDIT.action%TYPE               := 'MOVE';
    g_audittext              GENAUDIT.audittext%TYPE            := NULL;
    g_messageno              GENAUDIT.messageno%TYPE            := NULL;
    g_institutionid          GENAUDIT.institutionid%TYPE        := NULL;
    g_queueid                GENAUDIT.queueid%TYPE              := NULL;
    g_username               GENAUDIT.username%TYPE             := 'ADMIN';
    g_application            GENAUDIT.application%TYPE          := 'EVNTSRVR';
    g_modulename             GENAUDIT.modulename%TYPE           := NULL;
    m_tdidcode               TABLEDETAILS.TDIDCODE%TYPE          := 'PLCN-SRVS';
    m_context_name                      VARCHAR2(100)                                                    :=NULL;


    b_del_msg_count         NUMBER;
    b_all_msgs_count        NUMBER;
    msgblocks_beg            NUMBER;
    msgblocks_end            NUMBER;
    btch_ctr_beg            NUMBER := 0;
    btch_ctr_end            NUMBER := 0;
    ctr                     NUMBER := 0;
    m_curr_batch_status        MSGDB.status%TYPE    := 304; --304;

    m_nxt_batch_status        MSGDB.status%TYPE    := 304; --304;
    m_nxt_tran_status        MSGDB.status%TYPE    := 304; --304;
    BATCH_CANCEL    EXCEPTION;
    m_datetime                TIMESTAMP;

    CURSOR cursor_tran
    (
    c_msgdb_id_batch     IN     MSGDB.msgdb_id_batch%TYPE,
    c_msg_status        IN    TABLEDETAILS.tdvalue%TYPE
    )
    IS
    SELECT *
    FROM
    (
     SELECT  *
     FROM    MSGDB
     WHERE   msgdb_id_batch = c_msgdb_id_batch
     AND     msgdb_id_output_batch       IS NULL
     AND     status IN (SELECT * FROM TABLE (get_code_from_list (c_msg_status,'|')))
     UNION
     SELECT  *
     FROM    MSGDB
     WHERE   msgdb_id_output_batch = c_msgdb_id_batch
     AND     status IN (SELECT * FROM TABLE (get_code_from_list (c_msg_status,'|')))
     )
    ORDER BY msgdb_id;

--
   CURSOR cursor_blocks
   (
   c_msgdb_id_batch IN MSGDB.msgdb_id_batch%TYPE
   )
   IS
   SELECT *
   FROM MSGBLOCKS
   WHERE msgdb_ID = c_msgdb_id_batch;
--
BEGIN
     BEGIN

           SELECT  NVL(paramvalue,'X')
           INTO    m_tenant
           FROM    institutionparameters
           WHERE   institutionid=p_institutionid
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
    DBMS_OUTPUT.put_line('PAUSE...........');
    IF p_batch_all_txn_cnt = p_batch_del_txn_cnt
    THEN
        RAISE BATCH_CANCEL;
    END IF;

    IF p_batch_status = m_curr_batch_status
    THEN
        -- Fetch all the transactions except cancel
        OPEN cursor_tran(p_batch_msgdbid_src,m_td_msg_status);
    ELSE
        -- Fetch only pause transactions
        OPEN cursor_tran(p_batch_msgdbid_src,TO_CHAR(m_curr_batch_status));
    END IF;

    next_btch_qid     := td_get_value(m_tdidcode, 'BQID-PAUS');
    next_tran_qid    := td_get_value(m_tdidcode, 'TQID-PAUS');

    --m_curr_batch_status    := td_get_value('PLCN-SRVS', 'BSTS-PAUSE');
    --m_curr_tran_status    := td_get_value('PLCN-SRVS', 'TSTS-PAUSE');

    IF (p_batch_del_txn_cnt > 0 OR (p_batch_int_txn_cnt > 0 AND p_batch_status != m_curr_batch_status))
    THEN
        old_tran_btch_qid := p_batch_qid_src;

        --Generating new batch id and messageno in case of new batch creation
        SELECT MSGDB_SEQ.NEXTVAL
        INTO   m_msgdb_id_batch_new
        FROM   dual;

        SELECT 'B'||LPAD(MSGDB_MESSAGENO.NEXTVAL,11,'0')
        INTO   m_messageno_batch_new
        FROM   dual;
    ELSE
        old_tran_btch_qid := m_btch_qid_cancel;
    END IF;

    LOOP
        EXIT WHEN cursor_tran%NOTFOUND;
        FETCH cursor_tran BULK COLLECT INTO tran_msgdb LIMIT 10000;

        tran_ctr_beg := NVL(tran_msgdb.FIRST,0);  -- Set the start counter of the RECORD Table
        tran_ctr_end := NVL(tran_msgdb.LAST ,0);  -- Set the end   counter of the RECORD Table

        DBMS_OUTPUT.put_line('tran_ctr_end : '||tran_ctr_end);

        BEGIN
            m_mdbbt_num_of_msgs := 0;

            IF tran_ctr_end <= 0
            THEN
                EXIT;
            END IF;

            m_msgdb_id_last_txn := 0;

            n_msgdb_id    := t_msgdb_id();

            FOR t_ctr IN tran_ctr_beg..tran_ctr_end       --Transaction loop start
            LOOP
                n_msgdb_id.EXTEND;
                m_msgdb_id_last_txn := tran_msgdb(t_ctr).msgdb_id;

                --Counting transactions
                m_mdbbt_num_of_msgs := m_mdbbt_num_of_msgs + 1;
                m_priorityamountnum := m_priorityamountnum + tran_msgdb(t_ctr).priorityamountnum;
                       


                IF instr(m_tenant_list,m_tenant)>0
                THEN
                t_account_dr        := t_account_dr + NVL(To_NUMBER(tran_msgdb(t_ctr).account_dr_enc),0);
                ELSE
                t_account_dr        := t_account_dr + NVL(To_NUMBER(tran_msgdb(t_ctr).account_dr),0);
                END IF;

                n_msgdb_id    (n_msgdb_id.LAST)    :=     tran_msgdb(t_ctr).msgdb_id;

                DBMS_OUTPUT.put_line('MSGDB_ID : '||tran_msgdb(t_ctr).msgdb_id);

                g_audittext      := 'Message number <' || tran_msgdb(t_ctr).messageno || '> moved to Queue '''||next_tran_qid||''' from Queue '''||tran_msgdb(t_ctr).queueid||'''';
                g_modulename     := 'MESSAGE';
                g_messageno      := tran_msgdb(t_ctr).messageno;
                g_queueid        := tran_msgdb(t_ctr).queueid;
                g_institutionid  := tran_msgdb(t_ctr).institutionid;

                genaudit_insert_enchash_wrap
                (
                g_messageno,
                g_queueid,
                NULL,
                g_application,
                g_modulename,
                g_action,
                g_audittext,
                g_institutionid,
                0
                );
            END LOOP;
            -- added Devendra
                IF p_batch_del_txn_cnt = 0 AND p_batch_status = m_curr_batch_status
                THEN
                    FORALL  t_ctr IN tran_ctr_beg..tran_ctr_end
                    UPDATE  msgdb
                    SET     queueid                 = next_tran_qid,
                            prevqueueid                  = tran_msgdb(t_ctr).queueid,
                            status                    = m_status_available,
                            processing_stage          = get_queue_stage(p_institutionid,next_tran_qid)
                    WHERE      msgdb_id                  = n_msgdb_id(t_ctr);
                    DBMS_OUTPUT.put_line('304 batch updated');

                    m_datetime := systimestamp;

                    FOR t_ctr IN tran_ctr_beg..tran_ctr_end
                    LOOP
                        upsert_msgdb_stats
                        (
                            n_msgdb_id(t_ctr),
                            next_tran_qid,
                            m_datetime,
                            'N'
                        );
                    END LOOP;
                ELSE
                    FORALL t_ctr IN tran_ctr_beg..tran_ctr_end
                    UPDATE msgdb
                    SET    msgdb_id_output_batch     = m_msgdb_id_batch_new,
                           record_end_marker         = NULL,
                           queueid                   = next_tran_qid,
                           prevqueueid                 = tran_msgdb(t_ctr).queueid,
                           status                    = m_status_available,
                           processing_stage          = get_queue_stage(p_institutionid,next_tran_qid)
                    WHERE  msgdb_id                  = n_msgdb_id(t_ctr);
                    DBMS_OUTPUT.put_line('new batch with pause transaction');

                    m_datetime := systimestamp;

                    FOR t_ctr IN tran_ctr_beg..tran_ctr_end
                    LOOP
                        upsert_msgdb_stats
                        (
                            n_msgdb_id(t_ctr),
                            next_tran_qid,
                            m_datetime,
                            'N'
                        );
                    END LOOP;
                END IF;
            -- added Devendra
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                CLOSE cursor_tran;
        END;

    END LOOP;

    UPDATE MSGDB
    SET    record_end_marker = '2'
    WHERE  msgdb_id          = m_msgdb_id_last_txn;

    DBMS_OUTPUT.put_line('Rows updates: '||SQL%ROWCOUNT);

    CLOSE cursor_tran;

    IF (p_batch_del_txn_cnt > 0 OR (p_batch_int_txn_cnt > 0 AND p_batch_status != m_curr_batch_status)) AND p_batch_all_txn_cnt != p_batch_int_txn_cnt
    THEN
        m_systimestamp     := TO_TIMESTAMP(TO_CHAR(SYSDATE , 'YYYYMMDDHH24MISS'), 'YYYYMMDDHH24MISS');
        m_sysdate        :=    SYSDATE;

        DBMS_OUTPUT.put_line('Inserting new Batch Record : ' || m_msgdb_id_batch_new);
        btch_msgdb_new                        := t_msgdb();
        btch_msgdb_new.EXTEND;

        SELECT  *
        INTO    btch_msgdb_new(1)
        FROM    MSGDB
        WHERE   msgdb_id    =   p_batch_msgdbid_src;

        --btch_msgdb_new(1)                     := p_batch_msgdbid_src;
        btch_msgdb_new(1).msgdb_id            := m_msgdb_id_batch_new;
        btch_msgdb_new(1).messageno           := m_messageno_batch_new;
        btch_msgdb_new(1).queueid               := next_btch_qid;
        btch_msgdb_new(1).status              := m_status_available;
        btch_msgdb_new(1).inputdate           := TO_CHAR(m_sysdate,'YYYYMMDD');
        btch_msgdb_new(1).inputtime           := TO_CHAR(m_sysdate,'HH24MISS');
        btch_msgdb_new(1).currqueueindate     := TO_CHAR(m_sysdate,'YYYYMMDD');
        btch_msgdb_new(1).currqueueintime     := TO_CHAR(m_sysdate,'HH24MISS');
        btch_msgdb_new(1).inputdatetime       := m_systimestamp;
        btch_msgdb_new(1).currqueueindatetime := m_systimestamp;
        btch_msgdb_new(1).usr_action_timestamp:= m_systimestamp;
        btch_msgdb_new(1).processing_stage    := get_queue_stage(p_institutionid,next_btch_qid);
        btch_msgdb_new(1).lockedby            := NULL;
        btch_msgdb_new(1).repairedby          := NULL;
        btch_msgdb_new(1).releasedby          := NULL;
        btch_msgdb_new(1).authorizedby        := NULL;
        btch_msgdb_new(1).forwardedby         := NULL;
        btch_msgdb_new(1).operator            := NULL;
        btch_msgdb_new(1).stachemmessageflag  := NULL;
        btch_msgdb_new(1).priorityamountnum   := m_priorityamountnum;
        btch_msgdb_new(1).priorityamount      := TO_CHAR(m_priorityamountnum);
        btch_msgdb_new(1).custom13            := p_batch_cust13_src;
        btch_msgdb_new(1).custom5             := 'NEXT = '||p_batch_msgdbid_src||'|'||'ORBT'||CHR(191);
        btch_msgdb_new(1).ADDITIONAL_INFO     := NULL;

        INSERT INTO MSGDB VALUES btch_msgdb_new(1);

        msgdb_batch_new                       := t_msgdb_batch();
        msgdb_batch_new.EXTEND;
        msgdb_batch_new(1).msgdb_id           := m_msgdb_id_batch_new;
        msgdb_batch_new(1).mdbbt_num_of_msgs  := m_mdbbt_num_of_msgs;
        msgdb_batch_new(1).mdbbt_custnum1     := t_account_dr;
        msgdb_batch_new(1).mdbbt_custnum2     := m_priorityamountnum;

        INSERT INTO MSGDB_BATCH VALUES msgdb_batch_new(1);

        UPDATE  msgdb_batch
        SET     mdbbt_num_of_msgs     = (mdbbt_num_of_msgs-m_mdbbt_num_of_msgs),
                mdbbt_custnum2        = (mdbbt_custnum2-m_priorityamountnum)
        WHERE   msgdb_id = p_batch_msgdbid_src;

        UPDATE  msgdb
        SET     priorityamountnum    = (priorityamountnum-m_priorityamountnum),
                priorityamount        = TO_CHAR(priorityamountnum-m_priorityamountnum)
        WHERE   msgdb_id             = p_batch_msgdbid_src;

        IF p_batch_status = m_curr_batch_status
        THEN
            -- Fetch all the transactions except cancel
            OPEN cursor_tran(p_batch_msgdbid_src,m_td_msg_status);
        ELSE
            -- Fetch only pause transactions
            OPEN cursor_tran(p_batch_msgdbid_src,TO_CHAR(m_curr_batch_status));
        END IF;

        FETCH cursor_tran BULK COLLECT INTO tran_msgdb;

        tran_ctr_beg := NVL(tran_msgdb.FIRST,0);  -- Set the start counter of the RECORD Table
        tran_ctr_end := NVL(tran_msgdb.LAST ,0);  -- Set the end   counter of the RECORD Table

        FOR i in tran_ctr_beg..tran_ctr_end
        LOOP
            IF  tran_ctr_end <= 0
            THEN
                EXIT;
            END IF;

            msgdb_links_new.EXTEND;
            msgdb_links_new(i).msgdb_id             := tran_msgdb(i).msgdb_id;
            msgdb_links_new(i).type                 := 'M';
            msgdb_links_new(i).parent_id            := m_msgdb_id_batch_new;
            msgdb_links_new(i).parent_type          := 'B';

            INSERT INTO MSGDB_LINKS VALUES msgdb_links_new(i);
        END LOOP;

        g_audittext        := 'New Batch inserted with Batch Number <'||btch_msgdb_new(1).messageno||'> and wrote to Queue '''||btch_msgdb_new(1).queueid||'''';
        g_modulename       := 'BATCH';
        g_messageno        := btch_msgdb_new(1).messageno;
        g_queueid          := btch_msgdb_new(1).queueid;
        g_institutionid    := p_institutionid;

        genaudit_insert_enchash_wrap
        (
        g_messageno,
        g_queueid,
        NULL,
        g_application,
        g_modulename,
        g_action,
        g_audittext,
        g_institutionid,
        0
        );

        CLOSE cursor_tran;

        OPEN cursor_blocks(p_batch_msgdbid_src);
        FETCH cursor_blocks BULK COLLECT INTO btch_msgblocks;

        msgblocks_beg :=    NVL(btch_msgblocks.FIRST,0);
        msgblocks_end :=    NVL(btch_msgblocks.LAST,0);

        IF msgblocks_end > 0
        THEN
            FOR blk_ctr IN msgblocks_beg..msgblocks_end
            LOOP
                btch_msgblocks(blk_ctr).msgdb_id := m_msgdb_id_batch_new;
                INSERT INTO MSGBLOCKS VALUES btch_msgblocks(blk_ctr);
            END LOOP;
        END IF;
        CLOSE cursor_blocks;

--        IF p_batch_status = m_curr_batch_status
--        THEN
--            UPDATE  MSGDB
--            SET     STATUS                     = m_status_cancel,
--                      msgdb_id_output_batch   = m_msgdb_id_batch_new,
--                       queueid                 = m_btch_qid_cancel,
--                    prevqueueid                = p_batch_qid_src
--            WHERE   msgdb_id                  = p_batch_msgdbid_src;
--        END IF;

    ELSE

        UPDATE  MSGDB
        SET     queueid             = next_btch_qid,
                status              = m_status_available,
                priorityamountnum   = m_priorityamountnum,
                priorityamount      = TO_CHAR(m_priorityamountnum),
                processing_stage    = get_queue_stage(p_institutionid,next_btch_qid)
        WHERE   msgdb_id               = p_batch_msgdbid_src;
        DBMS_OUTPUT.put_line('Updating current batch');

        upsert_msgdb_stats
        (
            p_batch_msgdbid_src,
            next_btch_qid,
            systimestamp,
            'N'
        );

        p_batch_qid_src :=  next_btch_qid;
        p_batch_status  :=  m_status_available;
    END IF;
EXCEPTION
    WHEN BATCH_CANCEL
    THEN
        UPDATE  MSGDB
        SET     STATUS          = m_status_cancel,
        queueid                 = m_btch_qid_cancel,
        processing_stage    = get_queue_stage(p_institutionid,next_btch_qid),
        prevqueueid             = p_batch_qid_src
        WHERE   msgdb_id        = p_batch_msgdbid_src;

        upsert_msgdb_stats
        (
            p_batch_msgdbid_src,
            m_btch_qid_cancel,
            systimestamp,
            'N'
        );

    WHEN OTHERS
    THEN
        DBMS_OUTPUT.put_line(SQLCODE || SQLERRM || dbms_utility.format_error_backtrace);
END;