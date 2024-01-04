create or replace PROCEDURE pymt_txns_batching
(
    p_instanceid                    IN msgdb.instanceid%TYPE,
    p_src_fq_qid                    IN msgdb.queueid%TYPE DEFAULT NULL,
    p_src_fq_status_old             IN msgdb.status%TYPE DEFAULT 0,
    p_src_fq_status_new             IN msgdb.status%TYPE DEFAULT 0,
    p_src_bq_qid                    IN msgdb.queueid%TYPE DEFAULT NULL,
    p_src_bq_status                 IN msgdb.status%TYPE DEFAULT 0,
    p_trgt_bq_qid                   IN msgdb.queueid%TYPE DEFAULT NULL,
    p_trgt_bq_status                IN msgdb.status%TYPE DEFAULT NULL,
    p_src_tq_qid                    IN msgdb.queueid%TYPE,
    p_src_tq_messageclasstype       IN msgdb.messageclasstype%TYPE,
    p_src_tq_status                 IN msgdb.status%TYPE,
    p_trgt_tran_queueid             IN msgdb.queueid%TYPE DEFAULT NULL,
    p_trgt_tran_status              IN msgdb.status%TYPE DEFAULT 0,
    p_messagedirection              IN msgdb.messagedirection%TYPE DEFAULT NULL,
    p_institution_type              IN VARCHAR2 DEFAULT 'SERVICE_AGENT',
    p_bulking_filetype              IN msgdb.MSDA%type

)
AS
    --EXEC pymt_txns_batching(p_instanceid => 'PELICAN1', p_src_tq_qid=>'SPVNLBLQ', p_src_tq_messageclasstype=> 'pain.001.001.03', p_src_tq_status=>69, p_trgt_bq_status=>84, p_trgt_bq_qid=>'BTPROCDQ', p_trgt_tran_queueid => 'PROCDQ', p_trgt_tran_status => 69, p_institution_type => 'SERVICED_CORPORATE');

    TYPE s_msgdb_file
    IS RECORD
    (
    msgdb_id                  msgdb.msgdb_id%TYPE,
    messageno                 msgdb.messageno%TYPE,
    queueid                   msgdb.targetchannelid%TYPE,
    institutionid             msgdb.institutionid%TYPE
    );

    TYPE s_msgdb_batch
    IS RECORD
    (
    msgdb_id                msgdb.msgdb_id%TYPE,
    messageno               msgdb.messageno%TYPE,
    queueid                 msgdb.targetchannelid%TYPE,
    institutionid           msgdb.institutionid%TYPE,
    priorityamountnum       msgdb.priorityamountnum%TYPE,
    transrefno              msgdb.transrefno%TYPE,
    status                  msgdb.status%TYPE,
    record_group_type       msgdb.record_group_type%TYPE,
    instanceid              msgdb.instanceid%TYPE,
    record_end_marker       msgdb.record_end_marker%TYPE,
    msgsegr                 msgdb.msgsegr%TYPE,
    messagedirection        msgdb.messagedirection%TYPE,
    messageclasstype        msgdb.messageclasstype%TYPE,
    channel_id_source       msgdb.channel_id_source%TYPE,
    receiver                msgdb.receiver%TYPE,
    msgdb_id_org            msgdb.msgdb_id_org%TYPE,
    msgdb_id_source         msgdb.msgdb_id_source%TYPE,
    msg_family              msgdb.msg_family%TYPE,
    custom13                msgdb.custom13%TYPE,
    custom24                msgdb.custom24%TYPE,
    custom35                msgdb.custom35%TYPE,
    custom37                msgdb.custom37%TYPE,
    custom39                msgdb.custom39%TYPE,
    custom40                msgdb.custom40%TYPE,
    prioritydate            msgdb.prioritydate%TYPE,
    comments                msgdb.comments%TYPE,
    currency                msgdb.currency%TYPE,
    groupinginfo_batch      msgdb.groupinginfo_batch%TYPE,
    groupinginfo_file       msgdb.groupinginfo_file%TYPE
    );

    TYPE s_msgdb_tran
    IS RECORD
    (
    msgdb_id                msgdb.msgdb_id%TYPE,
    messageno               msgdb.messageno%TYPE,
    queueid                 msgdb.targetchannelid%TYPE,
    institutionid           msgdb.institutionid%TYPE,
    priorityamountnum       msgdb.priorityamountnum%TYPE,
    account_dr              msgdb.account_dr%TYPE,
    account_dr_enc          MSGDB.account_dr_enc%TYPE,
    custom37                msgdb.custom37%TYPE,
    prioritydate            msgdb.prioritydate%TYPE,
    msgdb_id_batch          msgdb.msgdb_id_batch%TYPE,
    transrefno              msgdb.transrefno%TYPE,
    record_end_marker       msgdb.record_end_marker%TYPE,
    messageclasstype        msgdb.messageclasstype%TYPE,
    msgdb_id_org            msgdb.msgdb_id_org%TYPE,
    groupinginfo_batch      msgdb.groupinginfo_batch%TYPE,
    groupinginfo_file       msgdb.groupinginfo_file%TYPE,
    tenant_name             msgdb.tenant_name%TYPE,
    currency                msgdb.currency%TYPE,
    messagedirection        msgdb.messagedirection%TYPE,
    msg_family              msgdb.msg_family%TYPE,
    msg_mode_in             msgdb.msg_mode_in%TYPE,
    msgsegr                 msgdb.msgsegr%TYPE,
    customeraccno           msgdb.customeraccno%TYPE,
    customeraccno_enc       MSGDB.customeraccno_enc%TYPE,
    transactiontype         MSGDB.transactiontype%TYPE,
    payment_duedate         MSGDB.payment_duedate%TYPE,
    display_flag            MSGDB.display_flag%TYPE,
    current_auth_level      MSGDB.current_auth_level%TYPE,
    origname                MSGDB.origname%TYPE,
    origname_enc            MSGDB.origname_enc%TYPE,
    currqueueindatetime     MSGDB.currqueueindatetime%TYPE,
    custom40                MSGDB.custom40%TYPE,
    sender                  MSGDB.sender%TYPE,
    channel_id_source       MSGDB.channel_id_source%TYPE,
    receiver                MSGDB.receiver%TYPE,
    account_cr              MSGDB.account_cr%TYPE,
    account_cr_enc          MSGDB.account_cr_enc%TYPE,
    countrycode             MSGDB.countrycode%TYPE,
    transactiongroup        msgdb.transactiongroup%TYPE,
    datakeyid               MSGDB.datakeyid%TYPE,
    request_type            MSGDB.request_type%TYPE,
    settlementmethod        MSGDB.settlementmethod%TYPE,
    tampered                VARCHAR2(1)
    );

    TYPE type_max_amount_in_one_file        IS TABLE OF NUMBER INDEX BY             VARCHAR2(255); -- associative array
    t_max_amount_in_one_file                type_max_amount_in_one_file;

    TYPE type_max_batches_in_one_file       IS TABLE OF NUMBER INDEX BY             VARCHAR2(255); -- associative array
    t_max_batches_in_one_file               type_max_batches_in_one_file;

    TYPE type_max_transactions_in_one_batch IS TABLE OF NUMBER INDEX BY             VARCHAR2(255); -- associative array
    t_max_transactions_in_one_batch             type_max_transactions_in_one_batch;

    TYPE type_max_transactions_in_one_file  IS TABLE OF NUMBER INDEX BY             VARCHAR2(255); -- associative array
    t_max_transactions_in_one_file          type_max_transactions_in_one_file;

    TYPE t_msgdb_batch                      IS TABLE OF                             s_msgdb_batch;
    a_msgdb_batch                           t_msgdb_batch                           := t_msgdb_batch();

    TYPE t_msgdb_tran                       IS TABLE OF                             s_msgdb_tran;
    a_msgdb_tran                            t_msgdb_tran                            := t_msgdb_tran();
    a_msgdb_tran_tampered                   t_msgdb_tran                            := t_msgdb_tran();

    TYPE t_msgdb_links                      IS TABLE OF                             msgdb_links%ROWTYPE;
    msgdb_links_new                          t_msgdb_links                           := t_msgdb_links();

    TYPE t_msgdb_batch_new                  IS TABLE OF                             msgdb%ROWTYPE;
    a_msgdb_batch_new                       t_msgdb_batch_new                       := t_msgdb_batch_new();

    TYPE t_msgdb_id                         IS TABLE OF msgdb.msgdb_id%TYPE;
    a_msgdb_id                              t_msgdb_id                              := t_msgdb_id();

    TYPE t_record_end_marker                IS TABLE OF                             msgdb.record_end_marker%TYPE;
    a_record_end_marker                     t_record_end_marker                     := t_record_end_marker();

    TYPE t_msgdb_id_output_batch            IS TABLE OF                             msgdb.msgdb_id_output_batch%TYPE;
    a_msgdb_id_output_batch                 t_msgdb_id_output_batch                 := t_msgdb_id_output_batch();

    TYPE t_msgdb_file                       IS TABLE OF                             s_msgdb_file;
    a_msgdb_file                            t_msgdb_file                            := t_msgdb_file();

    f_ctr_beg                               NUMBER                                  := 0;
    f_ctr_end                               NUMBER                                  := 0;
    b_ctr_beg                               NUMBER                                  := 0;
    b_ctr_end                               NUMBER                                  := 0;
    t_ctr_beg                               NUMBER                                  := 0;
    t_ctr_end                               NUMBER                                  := 0;
    t_ctr_beg_tamp                          NUMBER                                  := 0;
    t_ctr_end_tamp                          NUMBER                                  := 0;
    tran_ctr                                NUMBER                                  := 0;
    m_new_batch_count                       NUMBER                                  := 0;
    m_max_trans_per_batch                   NUMBER                                  := 0;
    m_max_batches_per_file                  NUMBER                                  := 0;
    m_max_trans_per_file                    NUMBER                                  := 0;
    m_max_amnt_per_file                     NUMBER                                  := 0;
    p_return_code                           NUMBER                                  := 0;
    m_transrefno_seq                        NUMBER                                  := 0;
    m_batches_processed                     NUMBER                                  := 0;
    msgblocks_beg                           NUMBER                                  := 0;
    msgblocks_end                           NUMBER                                  := 0;
    m_tran_processing_limit                 NUMBER                                  := 10000;

    m_error_description                     VARCHAR2(255)                           := NULL;
    m_today                                 VARCHAR2(8)                             := NULL;
    m_executiondate                         VARCHAR2(10)                            := NULL;
    m_institution_type                      VARCHAR2(15)                            := NULL;
    g_ora_exception                         VARCHAR2(32764)                         := NULL;
    m_concentrator                          VARCHAR2(10)                            := NULL;
    m_current_time                          VARCHAR2(8)                             := NULL;
    m_path_inst                             VARCHAR2(500)                           := NULL;
    m_paramname                             VARCHAR2(500)                           := NULL;
    m_tag_value                             VARCHAR2(500)                           := NULL;
    m_decrypt                               VARCHAR2(32664)                         := 'DECRYPT';
    m_encrypt                               VARCHAR2(32664)                         := 'ENCRYPT';
    m_tenant_list                   VARCHAR2(32664)     := NULL;
    m_tenantname                    INSTITUTIONPARAMETERS.PARAMVALUE%TYPE               := NULL;

    m_tenant                        VARCHAR2(32664)     := NULL;
    m_context_name                  VARCHAR2(32664)                         := NULL;

    b_message_clob                          CLOB                                    := EMPTY_CLOB();
    m_batch_endtag                          CLOB                                    := '</PmtInf>';

    m_current_date                          DATE                                    := NULL;
    m_date                                  DATE                                    := SYSDATE;

    m_systimestamp                          TIMESTAMP WITH TIME ZONE;

    m_xtype                                 XMLTYPE;

    new_batch                               BOOLEAN                                 := TRUE;
    m_file_create                           BOOLEAN                                 := FALSE;

    b_priorityamountnum                     msgdb.priorityamountnum%TYPE            := 0;
    f_priorityamountnum                     msgdb.priorityamountnum%TYPE            := 0;
    m_src_bq_qid                            msgdb.queueid%TYPE                      := NULL;
    m_src_tq_qid                            msgdb.queueid%TYPE                      := NULL;
    m_src_fq_status                         msgdb.status%TYPE                       := NULL;
    m_last_transaction_id                   msgdb.msgdb_id%TYPE                     := NULL;
    g_status                                msgdb.status%TYPE                       := NULL;
    m_last_transaction                      msgdb.msgdb_id%TYPE := NULL;
    m_record_end_marker_batch               msgdb.record_end_marker%TYPE            := 2;
    m_record_end_marker_file                msgdb.record_end_marker%TYPE            := 3;
    m_msgdb_id_new_batch                    msgdb.msgdb_id%TYPE                     := NULL;
    m_messageno_new_batch                   msgdb.messageno%TYPE                    := NULL;
    m_next_msgdb_id_batch                   msgdb.msgdb_id_batch%TYPE               := NULL;
    m_institutionid                         msgdb.institutionid%TYPE                := NULL;
    m_parent_inst                           msgdb.institutionid%TYPE                := NULL;
    m_banking_channel                       msgdb.custom37%TYPE                     := NULL;
    m_transrefno                            msgdb.transrefno%TYPE                   := NULL;
    m_transrefno_new                        msgdb.transrefno%TYPE                   := NULL;
    m_next_groupinginfo_batch               msgdb.groupinginfo_batch%TYPE           := NULL;
    m_next_groupinginfo_file                msgdb.groupinginfo_file%TYPE            := NULL;
    m_origname                              MSGDB.origname_enc%TYPE                 := NULL;
    m_account_cr                            MSGDB.account_cr_enc%TYPE               := NULL;
    m_bic                                   MSGDB.sender%TYPE                       := NULL;
    m_localinstrumentcode                   MSGDB.custom35%TYPE                     := NULL;

    b_tran_count                            MSGDB_BATCH.mdbbt_num_of_msgs%TYPE      := NULL;
    f_tran_count                            MSGDB_BATCH.mdbbt_num_of_msgs%TYPE      := NULL;
    f_btch_count                            MSGDB_BATCH.mdbbt_num_of_msgs%TYPE      := NULL;
    t_account_dr                            MSGDB_BATCH.mdbbt_custnum1%TYPE         := 0;

    m_filetype                              msgdb_file.mdbfl_filetype%TYPE          := NULL;
    m_processed_batch_count                 msgdb_file.mdbfl_custnum2%TYPE          := 0;

    m_msgfamily                             msgblocks.msgfamily%TYPE                := NULL;
    b_message_blob                          msgblocks.message%TYPE                  := NULL;

    m_paramvalue                            institutionparameters.paramvalue%TYPE   := NULL;
    m_payment_onbehalf                      institutionparameters.paramvalue%TYPE   := NULL;
    m_treasury_center                       institutionparameters.paramvalue%TYPE   := NULL;
    m_path                                  institutionparameters.path%TYPE         := NULL;
    m_pggm_path                             institutionparameters.path%TYPE         := NULL;
    m_inst_autogeneration                   institutionparameters.paramvalue%TYPE   := NULL;
    m_cutoff_time                           institutionparameters.paramvalue%TYPE   := NULL;
    m_btchbookg                             institutionparameters.paramvalue%TYPE   := NULL;

    m_batch_flag                            tabledetails.tdvalue%TYPE               := NULL;
    m_concentrator_req                      tabledetails.tdvalue%TYPE               := NULL;
    m_tdidcode_msgclasstype                 tabledetails.tdidcode%TYPE              := NULL;

    m_ctrycode                              account_master.country_code%TYPE         := NULL;

    g_queueid                               genaudit.queueid%TYPE                   := NULL;
    g_username                              genaudit.username%TYPE                  := NULL;
    g_application                           genaudit.application%TYPE               := 'EVNTSRVR';
    g_modulename                            genaudit.modulename%TYPE                := 'FILE';
    g_action                                genaudit.action%TYPE                    := 'SPLITTING';
    g_audittext                             genaudit.audittext%TYPE                 := NULL;
    g_messageno                             genaudit.messageno%TYPE                 := NULL;
    g_institutionid                         genaudit.institutionid%TYPE             := NULL;

    INVALID_XML                             EXCEPTION;
    RELEASE_LATER                           EXCEPTION;
    NO_FILES_FOUND                          EXCEPTION;
    NO_BATCHES_FOUND                        EXCEPTION;
    NO_TRANSACTION_FOUND                    EXCEPTION;
    PAYMENT_ONBEHALF                        EXCEPTION;
    NOT_BUSINESS_DAY                        EXCEPTION;
    INVALID_CUTOFF                          EXCEPTION;
    CUTOFF_NOT_REACHED                      EXCEPTION;
    FUTURE_DATE_BATCH                       EXCEPTION;
    m_proc_exec_tdidcode TABLEDETAILS.tdidcode%TYPE := 'TRACK_PROC_EXEC';
    m_proc_exec_tdkey      TABLEDETAILS.tdkey%TYPE := '349';
    m_proc_exec_time      TABLEDETAILS.tdvalue%TYPE := NULL;
    PROC_EXEC_WIP EXCEPTION;
    m_time_diff_in_ss        NUMBER        := NULL;
    m_time_diff_in_hhmiss    VARCHAR2(150) := NULL;
    m_time_gap                 NUMBER           := 1;
    m_btchservicelevel          VARCHAR2(1000)  := NULL;
    m_btchservicelevel_value    VARCHAR2(1000)  := NULL;
    m_service_tdvalue           VARCHAR2(1000)  := NULL;
    m_prefix                    VARCHAR2(30)    := NULL;
    m_currency                  VARCHAR2(30)    := NULL;
    m_cnt                       NUMBER          := 0;
    m_inst_paramvalue                       VARCHAR2(10)                           := NULL;
    m_value                                 VARCHAR2(10)                           := 'N';
    m_blob6                     clob := EMPTY_CLOB();
    t_ctr_beg_1    NUMBER := 0;
    t_ctr_end_1    NUMBER := 0;
    m_settlement_method                 VARCHAR2(100)                           := NULL;
    


    CURSOR cursor_institution
    IS
    SELECT      INSTITUTIONID
    FROM        institutionmaster
    where institutionid in (
                        select institutionid
                        from institutionparameters
                        where paramvalue in ('Y','N')
                        AND UPPER(path)          = 'MESSAGE_PROCESSING.FUNCTIONALITY.BULKING_CHECK.BASED_ON_PARENT_INSTITUTION'
                        AND UPPER(paramname)     = 'BULKING_CHECK');

    CURSOR cursor_file
    (
    c_institutionid IN msgdb.institutionid%TYPE,
    c_messagedirection VARCHAR2
    )
    IS
    SELECT msgdb_id,
           messageno,
           queueid,
           institutionid
    FROM   msgdb
    WHERE  queueid              = p_src_fq_qid
    AND    status               = p_src_fq_status_old
    --AND    instanceid           = p_instanceid
    AND    messagedirection     = c_messagedirection
    AND    messageclasstype     IN (SELECT para_code messagedirection FROM TABLE(Get_Code_From_List((p_src_tq_messageclasstype),'|')))
    AND    process_id           = 'NONE'
    AND    institutionid       IN (SELECT institutionid from institutionparameters where paramname = 'PARENT_ID' AND paramvalue = c_institutionid)
    AND    transactiontype      = 'D'
    UNION
    SELECT msgdb_id,
           messageno,
           queueid,
           institutionid
    FROM   msgdb
    WHERE  queueid             = p_src_fq_qid
    AND    status              = p_src_fq_status_old
   -- AND    instanceid          = p_instanceid
    AND    messagedirection    = c_messagedirection
    AND    process_id          = 'TO-MATCH'
    AND    institutionid       IN (SELECT institutionid from institutionparameters where paramname = 'PARENT_ID' AND paramvalue = c_institutionid)
    AND    messageclasstype    = p_src_tq_messageclasstype
    ORDER
    BY     msgdb_id;

    CURSOR cursor_batch
    (
    c_msgdb_id_org IN msgdb.msgdb_id_org%TYPE,
    c_src_bq_qid IN msgdb.queueid%TYPE
    )
    IS
    SELECT msgdb_id,
           messageno,
           queueid,
           institutionid,
           priorityamountnum,
           transrefno,
           status,
           record_group_type,
           instanceid,
           record_end_marker,
           msgsegr,
           messagedirection,
           messageclasstype,
           channel_id_source,
           receiver,
           msgdb_id_org,
           msgdb_id_source,
           msg_family,
           custom13,
           custom24,
           custom35,
           custom37,
           custom39,
           custom40,
           prioritydate,
           comments,
           currency,
           groupinginfo_batch,
           groupinginfo_file
    FROM   msgdb
    WHERE  msgdb_id_org         = DECODE(c_msgdb_id_org,0,msgdb_id_org,c_msgdb_id_org)
    AND    queueid              = c_src_bq_qid
    AND    messageclasstype     IN (SELECT para_code messagedirection FROM TABLE(Get_Code_From_List((p_src_tq_messageclasstype),'|')))
    AND    record_group_type    = 'B'
    AND    status               = p_src_bq_status
    AND    process_id           = 'NONE'
    UNION
    SELECT msgdb_id,
           messageno,
           queueid,
           institutionid,
           priorityamountnum,
           transrefno,
           status,
           record_group_type,
           instanceid,
           record_end_marker,
           msgsegr,
           messagedirection,
           messageclasstype,
           channel_id_source,
           receiver,
           msgdb_id_org,
           msgdb_id_source,
           msg_family,
           custom13,
           custom24,
           custom35,
           custom37,
           custom39,
           custom40,
           prioritydate,
           comments,
           currency,
           groupinginfo_batch,
           groupinginfo_file
    FROM   msgdb
    WHERE  msgdb_id_org         = DECODE(c_msgdb_id_org,0,msgdb_id_org,c_msgdb_id_org)
    AND    queueid              = 'ELRLBTQ1'
    AND    messageclasstype     IN (SELECT para_code messagedirection FROM TABLE(Get_Code_From_List((p_src_tq_messageclasstype),'|')))
    AND    record_group_type    = 'B'
    AND    status               = p_src_bq_status
    AND    process_id           = 'NONE'
    AND    custom24                <= m_date
    ORDER
    BY     institutionid,
           custom37,
           prioritydate,
           msgdb_id;

    CURSOR cursor_trans1
    (
    c_institutionid     IN msgdb.institutionid%TYPE,
    c_msgdb_id_batch    IN msgdb.msgdb_id_batch%TYPE,
    c_src_tq_qid        IN msgdb.queueid%TYPE
    )
    IS
    SELECT      msgdb_id,
                messageno,
                queueid,
                institutionid,
                priorityamountnum,
                account_dr,
                account_dr_enc,
                custom37,
                prioritydate,
                msgdb_id_batch,
                transrefno,
                record_end_marker,
                messageclasstype,
                msgdb_id_org,
                groupinginfo_batch,
                groupinginfo_file,
                tenant_name,
                currency,
                messagedirection,
                msg_family,
                msg_mode_in,
                msgsegr,
                customeraccno,
                customeraccno_enc,
                transactiontype,
                payment_duedate,
                display_flag,
                current_auth_level,
                origname,
                origname_enc,
                currqueueindatetime,
                custom40,
                sender,
                channel_id_source,
                receiver,
                account_cr,
                account_cr_enc,
                countrycode,
                transactiongroup,
                datakeyid,
                request_type,
                settlementmethod,
                NVL(msgblocks_tampered_check(MSGDB_ID,2),'N') tampered
    FROM        MSGDB
    WHERE       queueid                          = p_src_tq_qid
    AND         status                           = p_src_tq_status
--    AND         ((NVL(msgdb_id_batch,0)         = DECODE(c_msgdb_id_batch, 0, msgdb_id_batch, c_msgdb_id_batch) AND msgdb_id_output_batch IS NULL)
--               OR NVL(msgdb_id_output_batch,0) = c_msgdb_id_batch)
    AND         TO_CHAR(NVL(custom24,SYSTIMESTAMP),'YYYYMMDDHH24MISS') <= TO_CHAR(SYSTIMESTAMP,'YYYYMMDDHH24MISS')
    --AND         MSDA = p_bulking_filetype
    -- AND           tenant_name = p_tenant_name
    AND         messageclasstype = p_src_tq_messageclasstype
    AND         RECORD_GROUP_TYPE = 'M'
    and         institutionid = c_institutionid
    ORDER
    BY          groupinginfo_file,
                groupinginfo_batch,
                msgdb_id;

    CURSOR cursor_trans2
    (
    c_institutionid     IN msgdb.institutionid%TYPE,
    c_msgdb_id_batch    IN msgdb.msgdb_id_batch%TYPE,
    c_src_tq_qid        IN msgdb.queueid%TYPE
    )
    IS
    SELECT      msgdb_id,
                messageno,
                queueid,
                institutionid,
                priorityamountnum,
                account_dr,
                account_dr_enc,
                custom37,
                prioritydate,
                msgdb_id_batch,
                transrefno,
                record_end_marker,
                messageclasstype,
                msgdb_id_org,
                groupinginfo_batch,
                groupinginfo_file,
                tenant_name,
                currency,
                messagedirection,
                msg_family,
                msg_mode_in,
                msgsegr,
                customeraccno,
                customeraccno_enc,
                transactiontype,
                payment_duedate,
                display_flag,
                current_auth_level,
                origname,
                origname_enc,
                currqueueindatetime,
                custom40,
                sender,
                channel_id_source,
                receiver,
                account_cr,
                account_cr_enc,
                countrycode,
                transactiongroup,
                datakeyid,
                request_type,
                settlementmethod,
                NVL(msgblocks_tampered_check(MSGDB_ID,2),'N') tampered
    FROM        MSGDB
    WHERE       queueid                          = p_src_tq_qid
    AND         status                           = p_src_tq_status
--    AND         ((NVL(msgdb_id_batch,0)         = DECODE(c_msgdb_id_batch, 0, msgdb_id_batch, c_msgdb_id_batch) AND msgdb_id_output_batch IS NULL)
--               OR NVL(msgdb_id_output_batch,0) = c_msgdb_id_batch)
    AND         TO_CHAR(NVL(custom24,SYSTIMESTAMP),'YYYYMMDDHH24MISS') <= TO_CHAR(SYSTIMESTAMP,'YYYYMMDDHH24MISS')
    --AND         MSDA = p_bulking_filetype
    -- AND           tenant_name = p_tenant_name
    AND         messageclasstype = p_src_tq_messageclasstype
    AND         RECORD_GROUP_TYPE = 'M'
    and         institutionid   IN
                            ( SELECT institutionid
                              FROM institutionparameters
                              WHERE  UPPER(paramname)     = 'PARENT_ID'
                              AND paramvalue = c_institutionid
                              UNION SELECT c_institutionid FROM DUAL)
    ORDER
    BY          groupinginfo_file,
                groupinginfo_batch,
                msgdb_id;

    FUNCTION account_number_summation
    (
    p_account_dr    IN MSGDB.account_dr_enc%TYPE
    )
    RETURN NUMBER
    AS
    m_account_num_length    NUMBER      := 0;
    m_iban_ctrycode         VARCHAR2(2) := NULL;
    BEGIN
        IF TRIM(TRANSLATE(p_account_dr,'0123456789',' ')) IS NULL
        THEN
            RETURN NVL(p_account_dr,0);
        ELSE
            m_iban_ctrycode                := SUBSTR(p_account_dr,1,2);
            m_account_num_length        := NVL(TD_GET_VALUE('IBAN_ACNT_LEN',m_iban_ctrycode),0);
            IF m_account_num_length  <= 0
            THEN
                RETURN 0;
                -- summation of account number is ignored since configuration not found
            ELSE
                m_account_num_length        := -1 * m_account_num_length;
                RETURN NVL(SUBSTR(p_account_dr,m_account_num_length),0);
            END IF;
        END IF;
    END;
BEGIN
    --Active-active implementation
   /* BEGIN
        INSERT
        INTO     tabledetails
        VALUE     (
                tdidcode,
                tdkey,
                tdvalue,
                status,
                userid
                )
        VALUES     (
                m_proc_exec_tdidcode,
                m_proc_exec_tdkey,
                TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS'),
                'V',
                'ADMIN1'
                );
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX
        THEN
            SELECT     tdvalue
            INTO    m_proc_exec_time
            FROM    tabledetails
            WHERE   tdidcode = m_proc_exec_tdidcode
            AND        tdkey     = m_proc_exec_tdkey;
            m_time_diff_in_hhmiss := Diff_Bw_Datetime(TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS'), m_proc_exec_time);
            m_time_diff_in_ss     := ( TO_NUMBER( Getstringitemwithsep(m_time_diff_in_hhmiss, 1,':') ) * 3600 ) + ( TO_NUMBER( Getstringitemwithsep(m_time_diff_in_hhmiss,2,':') ) * 60 ) + ( TO_NUMBER( Getstringitemwithsep(m_time_diff_in_hhmiss, 3,':') ) );
            IF  m_time_diff_in_ss > m_time_gap
            THEN
                UPDATE TABLEDETAILS
                   SET tdvalue = TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS')
                 WHERE tdidcode = m_proc_exec_tdidcode
                   AND tdkey    = m_proc_exec_tdkey;
            ELSE
                RAISE PROC_EXEC_WIP;
            END IF;
    END;
    m_current_date  := SYSDATE;
    m_current_time    := TO_CHAR(SYSDATE,'HH24:MI:SS');
    m_today            := TO_CHAR(SYSDATE,'YYYYMMDD');
    m_tenant_list := sys_context(m_context_name,'ENCRYPTION_TENANT_LIST');*/

/*  IF NVL(td_get_value('CUSTOM-CONFG','BUSINESS_DAY_CHECK'),'N') = 'Y' AND m_today != TO_CHAR(get_next_business_date(SYSDATE,'TARGET2'),'YYYYMMDD')
    THEN
        RAISE NOT_BUSINESS_DAY;
    END IF; */

    BEGIN
        SELECT  REPLACE(tdkey,'EXTRACT','')
        INTO    m_tdidcode_msgclasstype
        FROM    tabledetails
        WHERE   tdvalue =  p_src_tq_messageclasstype
        AND     tdidcode = 'PAYEXTRACT'  ;
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            m_tdidcode_msgclasstype := NULL;
    END;

   dbms_output.put_line('p_institution_type: ' || p_institution_type);

        FOR rec1 IN cursor_institution
            LOOP
            BEGIN
                    m_inst_paramvalue:= NVL(Get_Institution_Param_Value(rec1.institutionid,'INSTITUTION_DETAILS','PARENT_BULKING'),'N');
                    m_institutionid := rec1.institutionid;
                dbms_output.put_line('m_institutionid: ' || m_institutionid);

          m_tenantname := get_institution_param_value(
                                                     m_institutionid,
                                                    'INSTITUTION_DETAILS',
                                                    'TENANT_NAME'
                                                    );
                            
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
            m_treasury_center := NVL(get_institution_param_value
                                (
                                p_institutionid=>m_institutionid,
                                p_path=>'INSTITUTION_DETAILS',
                                p_paramname=>'PARENT_ID'
                                ),'X');

            m_payment_onbehalf := NVL(get_institution_param_value
                                (
                                p_institutionid=>m_treasury_center,
                                p_path=>'INSTITUTION_DETAILS.PAYMENTS_ON_BEHALF',
                                p_paramname=>'TRANSACTION_BANKING'
                                ),'X');

           dbms_output.put_line('m_payment_onbehalf ==>'|| m_payment_onbehalf);

            IF UPPER(m_payment_onbehalf) = 'Y' OR UPPER(m_payment_onbehalf) = 'YES'
            OR p_src_fq_qid IS NULL -- when rebatching is required only based on transaction without input file
            THEN
               dbms_output.put_line('m_cutoff_time ==> '|| m_cutoff_time);
                f_ctr_beg := 1;
                f_ctr_end := 1;
            ELSE
                OPEN cursor_file(m_institutionid,p_messagedirection);
                FETCH cursor_file BULK COLLECT INTO a_msgdb_file;

                f_ctr_beg := NVL(a_msgdb_file.FIRST,0);  -- Set the start counter of the RECORD Table
                f_ctr_end := NVL(a_msgdb_file.LAST ,0);  -- Set the end   counter of the RECORD Table
            END IF;

            BEGIN
                SELECT  path
                INTO    m_path
                FROM    institutionparameters
                WHERE   paramname         = 'PROFILE_NAME'
                AND     paramvalue         = m_banking_channel
                AND     institutionid     = m_institutionid;
            EXCEPTION
                WHEN NO_DATA_FOUND
                THEN
                    m_path := NULL;
            END;

            --End of spliting configuration

           dbms_output.put_line('f_ctr_end: ' || f_ctr_end);

            IF f_ctr_end <= 0
            THEN
               dbms_output.put_line('here');
                g_messageno     := NULL;
                g_queueid       := NULL;
                g_institutionid := mi_get_concentratorid;
                g_audittext     := 'Files not found for splitting';
                CLOSE cursor_file;
                RAISE NO_FILES_FOUND;
            END IF;

            f_btch_count        := 0;
            f_tran_count        := 0;
            f_priorityamountnum := 0;

            FOR f_ctr IN f_ctr_beg..f_ctr_end
            LOOP
                BEGIN
                   dbms_output.put_line('Institutionid ID => ' || m_institutionid);
                    IF p_src_fq_qid IS NOT NULL
                    THEN
                       dbms_output.put_line('File ID=>' || a_msgdb_file(f_ctr).msgdb_id);

                        SELECT  mdbfl_filetype
                        INTO    m_filetype
                        FROM    msgdb_file
                        WHERE   msgdb_id = a_msgdb_file(f_ctr).msgdb_id;

                        IF m_filetype = 'SEPA-PAIN'
                        THEN
                            m_src_bq_qid := td_get_value ('EQUENS-TA-CONF', 'BATCH-QUEUE');
                            m_src_bq_qid := NVL(m_src_bq_qid,p_src_bq_qid);

                            m_src_tq_qid := td_get_value ('EQUENS-TA-CONF', 'TRANS-QUEUE');
                            m_src_tq_qid := NVL(m_src_tq_qid,p_src_tq_qid);
                        END IF;
                    ELSE
                        m_src_tq_qid := p_src_tq_qid;
                    END IF;

                    IF p_src_bq_qid IS NOT NULL
                    THEN
                        OPEN cursor_batch(a_msgdb_file(f_ctr).msgdb_id,m_src_bq_qid);
                        FETCH cursor_batch BULK COLLECT INTO a_msgdb_batch;

                        b_ctr_beg         := NVL(a_msgdb_batch.FIRST,0);  -- Set the start counter of the RECORD Table
                        b_ctr_end         := NVL(a_msgdb_batch.LAST ,0);  -- Set the end   counter of the RECORD Table
                    ELSE
                        b_ctr_beg := 1;
                        b_ctr_end := 1;
                    END IF;

                   dbms_output.put_line ('batch count : '|| b_ctr_end);
                    g_audittext     := NULL;

                    IF b_ctr_beg <= 0
                    THEN
                        g_messageno            := NULL;
                        g_queueid           := a_msgdb_file(f_ctr).queueid;
                        g_institutionid     := a_msgdb_file(f_ctr).institutionid;
                        g_audittext         := 'Batches not found for file : ' || a_msgdb_file(f_ctr).messageno || '. Batches of this file would probably be in manual verification queue. When these batches are processed from manual verification queue the file would be processed further.';
                        CLOSE cursor_batch;
                        RAISE NO_BATCHES_FOUND;
                    END IF;

                    b_tran_count        := 0;
                    m_transrefno_seq    := 1;

                    FOR b_ctr IN b_ctr_beg..b_ctr_end
                    LOOP
                       dbms_output.put_line ('m_institutionid : '|| m_institutionid);

                        g_audittext     := NULL;
--                       dbms_output.put_line('Batch ID=>' || a_msgdb_batch(b_ctr).msgdb_id);
                        BEGIN
--                         dbms_output.put_line('Batch priority date =>' || a_msgdb_batch(b_ctr).prioritydate);

                            IF p_src_bq_qid IS NOT NULL
                            THEN
                                m_processed_batch_count := m_processed_batch_count + 1;
                                IF (UPPER(a_msgdb_batch(b_ctr).messageclasstype) = 'PACS.008.001.02' AND a_msgdb_batch(b_ctr).messagedirection = 'I')
                                OR (UPPER(a_msgdb_batch(b_ctr).messageclasstype) = 'PACS.008.001.08' AND a_msgdb_batch(b_ctr).messagedirection = 'I')
                                THEN
                                    IF a_msgdb_batch(b_ctr).prioritydate > TO_CHAR(SYSDATE,'YYYYMMDD')
                                    THEN
                                        RAISE FUTURE_DATE_BATCH;
                                    END IF;
                                END IF;

                                IF a_msgdb_batch(b_ctr).queueid = 'ELRLBTQ1'
                                THEN
                                    IF TO_CHAR(a_msgdb_batch(b_ctr).custom24,'YYYYMMDD') > m_today
                                    THEN
                                        g_messageno         := a_msgdb_batch(b_ctr).messageno;
                                        g_queueid           := a_msgdb_batch(b_ctr).queueid;
                                        g_institutionid     := a_msgdb_batch(b_ctr).institutionid;
                                        g_audittext         := 'Batch will be released on ' || To_CHAR(a_msgdb_batch(b_ctr).custom24,'YYYY/MM/DD');
                                        RAISE RELEASE_LATER;
                                    END IF;
                                END IF;

                                m_institutionid         := a_msgdb_batch(b_ctr).institutionid;
                                m_banking_channel       := a_msgdb_batch(b_ctr).custom37;
                                m_transrefno            := a_msgdb_batch(b_ctr).transrefno;
                                m_transrefno_new        := m_transrefno;
                                g_queueid               := a_msgdb_batch(b_ctr).queueid;
                                g_institutionid         := a_msgdb_batch(b_ctr).institutionid;

                                BEGIN
                                    SELECT  msgfamily
                                    INTO    m_msgfamily
                                    FROM    msgblocks
                                    WHERE   msgdb_id = a_msgdb_batch(b_ctr).msgdb_id
                                    AND     msgblocktype = 91;
                                EXCEPTION
                                    WHEN    OTHERS
                                    THEN
                                       null;
                                       dbms_output.put_line('No data found');
                                END;

                                select message
                                INTO    b_message_blob
                                FROM    msgblocks
                                WHERE   msgdb_id = a_msgdb_batch(b_ctr).msgdb_id;

                                a_msgdb_batch(b_ctr).queueid := 'BTPROCDQ';
                                a_msgdb_batch(b_ctr).status     := 290;
                            END IF;

                            f_btch_count            := 0;
                            b_tran_count            := 0;
                            new_batch               := TRUE;

                            m_executiondate         := NULL;

                            ----     dbms_output.put_line('a_msgdb_batch(b_ctr).msgdb_id: ' || a_msgdb_batch(b_ctr).msgdb_id);

                            IF  p_src_bq_qid IS NOT NULL
                            THEN
                                    IF m_inst_paramvalue = 'N'
                                    THEN
                                        OPEN cursor_trans1(m_institutionid,a_msgdb_batch(b_ctr).msgdb_id,m_src_tq_qid);
                                        FETCH cursor_trans1 BULK COLLECT INTO a_msgdb_tran_tampered LIMIT m_tran_processing_limit;
                                    ELSIF m_inst_paramvalue = 'Y'
                                        THEN
                                        OPEN cursor_trans2(m_institutionid,a_msgdb_batch(b_ctr).msgdb_id,m_src_tq_qid);
                                        FETCH cursor_trans2 BULK COLLECT INTO a_msgdb_tran_tampered LIMIT m_tran_processing_limit;
                                    END IF;
                            ELSE
                                    IF m_inst_paramvalue = 'N'
                                    THEN
                                         OPEN cursor_trans1(m_institutionid,0, m_src_tq_qid);
                                         FETCH cursor_trans1 BULK COLLECT INTO a_msgdb_tran_tampered LIMIT m_tran_processing_limit;
                                    ELSIF m_inst_paramvalue = 'Y'
                                        THEN
                                         OPEN cursor_trans2(m_institutionid,0, m_src_tq_qid);
                                         FETCH cursor_trans2 BULK COLLECT INTO a_msgdb_tran_tampered LIMIT m_tran_processing_limit;
                                    END IF;
                                    dbms_output.put_line('Transaction queueid: ' || m_src_tq_qid);
                                    dbms_output.put_line('Transaction m_institutionid: ' || m_institutionid);
                                    dbms_output.put_line('Transaction p_src_tq_messageclasstype: ' || p_src_tq_messageclasstype);
                                    dbms_output.put_line('Transaction p_src_tq_status: ' || p_src_tq_status);
                                   -- dbms_output.put_line('Transaction p_tenant_name : ' || p_tenant_name);


                            END IF;



                            t_ctr_beg_tamp := NVL(a_msgdb_tran_tampered.FIRST,0);
                            t_ctr_end_tamp := NVL(a_msgdb_tran_tampered.LAST ,0);
                            dbms_output.put_line('Transactions begin: ' || t_ctr_beg_tamp);
                                 dbms_output.put_line('Transactions end: ' || t_ctr_end_tamp);


                            IF t_ctr_end_tamp > 0
                            THEN
                                FOR i in t_ctr_beg_tamp..t_ctr_end_tamp
                                LOOP
                                    dbms_output.put_line('i' ||i);
                                    dbms_output.put_line('a_msgdb_tran_tampered(i).msgdb_id ' || a_msgdb_tran_tampered(i).msgdb_id);
                                    IF a_msgdb_tran_tampered(i).tampered='Y'
                                    THEN
                                        DBMS_LOB.createtemporary(m_blob6, TRUE);
                                        dbms_output.put_line('a_msgdb_tran_tampered(i).tampered ' || a_msgdb_tran_tampered(i).tampered);

                                        UPDATE MSGDB
                                        SET QUEUEID='INERRMSG',
                                            STATUS=69,
                                            processing_stage=get_queue_stage(a_msgdb_tran_tampered(i).institutionid,'INERRMSG'),
                                            comments = comments || ':A00:00-8905'
                                        WHERE msgdb_id=  a_msgdb_tran_tampered(i).msgdb_id;
                                        
                                        m_blob6 := blob_to_clob(a_msgdb_tran_tampered(i).msgdb_id, 6);
                                        
                                        DBMS_LOB.append (m_blob6, ':A00:00-8905');
                                        
                                        UPDATE MSGBLOCKS
                                        SET MESSAGE = CLOB_TO_BLOB(m_blob6)
                                        WHERE msgdb_id=  a_msgdb_tran_tampered(i).msgdb_id
                                        AND   MSGBLOCKTYPE = 6;
                                        
                                        
                                        dbms_output.put_line('updated');

                                        genaudit_insert_enchash_wrap
                                        (
                                        a_msgdb_tran_tampered(i).messageno,
                                        'INERRMSG',
                                        'ADMIN',
                                        'PELICAN',
                                        'BATCH',
                                        'MOVE',
                                        'Transaction number <'||a_msgdb_tran_tampered(i).messageno ||'> moved to INERRMSG due to Authentication Failure',
                                        a_msgdb_tran_tampered(i).institutionid,
                                        0
                                        );
                                        dbms_lob.freetemporary(m_blob6);
                                    ELSE
                                        dbms_output.put_line('a_msgdb_tran_tampered(i).tampered ' || a_msgdb_tran_tampered(i).tampered);
                                        a_msgdb_tran.extend();
                                        a_msgdb_tran(a_msgdb_tran.LAST)               :=      a_msgdb_tran_tampered(i);
                                        dbms_output.put_line('extended');
                                    END IF;
                                END LOOP;
                            END IF;



                            t_ctr_beg := NVL(a_msgdb_tran.FIRST,0);
                            t_ctr_end := NVL(a_msgdb_tran.LAST ,0);

                           dbms_output.put_line('Transactions begin: ' || t_ctr_beg);
                           dbms_output.put_line('Transactions end: ' || t_ctr_end);

                            g_audittext     := NULL;

                            IF t_ctr_end <= 0 -- Transactions records found
                            THEN
                                g_messageno     := NULL;
                                g_audittext     := 'Transactions not found.';
                                RAISE NO_TRANSACTION_FOUND;
                            END IF;

                            a_msgdb_id_output_batch    := t_msgdb_id_output_batch();
                            a_record_end_marker        := t_record_end_marker();

                            tran_ctr := 1;
                            LOOP
                                IF tran_ctr > t_ctr_end
                                THEN
                                    EXIT;
                                END IF;

                               dbms_output.put_line('Msgdb_id => ' || a_msgdb_tran(tran_ctr).msgdb_id);

                                IF a_msgdb_tran(tran_ctr).tenant_name IS NOT NULL AND tran_ctr = 1
                                THEN
                                    m_parent_inst := (CASE WHEN get_institution_param_value(m_institutionid,'INSTITUTION_DETAILS','CUSTOMER_TYPE') = 'SERVICE_AGENT' THEN m_institutionid ELSE get_institution_param_value(m_institutionid,'INSTITUTION_DETAILS','PARENT_ID') END);
                                END IF;

                               dbms_output.put_line('m_institutionid =>' || m_institutionid);


                                t_max_amount_in_one_file.DELETE;
                                t_max_batches_in_one_file.DELETE;
                                t_max_transactions_in_one_batch.DELETE;
                                t_max_transactions_in_one_file.DELETE;
                                BEGIN
                                    IF tran_ctr = 1
                                    THEN
                                        FOR rec2 IN (SELECT  paramname, paramvalue, path FROM institutionparameters WHERE institutionid = m_institutionid and path LIKE '%.OUTPUT_BANKING_CHANNEL_CONF.%' ORDER BY paramname)
                                        LOOP
                                            m_paramvalue   := REPLACE(rec2.paramvalue,',','');
                                            m_paramvalue   := REPLACE(rec2.paramvalue,'.','');
                                            m_paramvalue   := REPLACE(rec2.paramvalue,' ','');

                                            IF m_paramvalue IS NULL OR m_paramvalue = 'NO_LIMIT'
                                            THEN
                                                m_paramvalue := 0;
                                            ELSE
                                               dbms_output.put_line ('m_paramvalue : ' || m_paramvalue);
                                                m_paramvalue := m_paramvalue;
                                            END IF;

                                            m_path_inst :=  rec2.path;
                                            m_paramname := rec2.paramname;

                                            IF m_paramname = 'MAX_TRANSACTIONS_IN_ONE_FILE'
                                            THEN
                                                t_max_transactions_in_one_file(m_path_inst) := m_paramvalue;
                                            ELSE
                                                t_max_transactions_in_one_file(m_path_inst) := 0;
                                            END IF;

                                            IF m_paramname = 'MAX_BATCHES_IN_ONE_FILE'
                                            THEN
                                                t_max_batches_in_one_file(m_path_inst) := m_paramvalue;
                                            ELSE
                                                t_max_batches_in_one_file(m_path_inst) := 0;
                                            END IF;

                                            IF m_paramname = 'MAX_TRANSACTIONS_IN_ONE_BATCH'
                                            THEN
                                                t_max_transactions_in_one_batch(m_path_inst) := m_paramvalue;
                                            ELSE
                                                t_max_transactions_in_one_batch(m_path_inst) := 0;
                                            END IF;

                                            IF m_paramname = 'MAX_AMOUNT_IN_ONE_FILE'
                                            THEN
                                                t_max_amount_in_one_file(m_path_inst) := m_paramvalue;
                                            ELSE
                                                t_max_amount_in_one_file(m_path_inst) := 0;
                                            END IF;
                                        END LOOP;

                                        FOR rec3 IN (SELECT institutionid, paramname, paramvalue, path FROM institutionparameters WHERE institutionid = m_institutionid and path LIKE '%.OUTPUT_BANKING_CHANNEL_CONF.%' AND paramname IN ('MAX_TRANSACTIONS_IN_ONE_BATCH','MAX_TRANSACTIONS_IN_ONE_FILE') ORDER BY paramname)
                                        LOOP
                                            m_path_inst :=  rec3.path;
                                            IF t_max_transactions_in_one_file(m_path_inst) < t_max_transactions_in_one_batch(m_path_inst)
                                            THEN
                                                t_max_transactions_in_one_batch (m_path_inst) := t_max_transactions_in_one_file(m_path_inst);
                                            END IF;
                                        END LOOP;
                                    END IF;
                                END;

                                a_msgdb_id_output_batch.EXTEND;
                                a_record_end_marker.EXTEND;

                                IF new_batch
                                THEN
                                    m_executiondate := TO_CHAR(TO_DATE(a_msgdb_tran(tran_ctr).prioritydate,'YYYYMMDD'),'YYYY-MM-DD');
                                    --Generate Batch ID MSGDB_ID
                                    SELECT  msgdb_seq.NEXTVAL
                                    INTO    m_msgdb_id_new_batch
                                    FROM    dual;

                                    --Generate Batch MessageNo.
                                    SELECT  'B' || LPAD(LTRIM(TO_CHAR(msgdb_messageno.NEXTVAL)),11, '0')
                                    INTO    m_messageno_new_batch
                                    FROM    DUAL;

                                    new_batch            := FALSE;
                                   dbms_output.put_line('new_batch set to false 744');
                                    b_tran_count         := 0;

                                    IF p_src_bq_qid IS NOT NULL
                                    THEN
                                        SELECT  *
                                        BULK     COLLECT
                                        INTO    a_msgdb_batch_new
                                        FROM    msgdb
                                        WHERE   msgdb_id = a_msgdb_batch(b_ctr).msgdb_id;
                                    ELSE
                                        a_msgdb_batch_new.EXTEND();
                                    END IF;
                                    
                                IF m_tdidcode_msgclasstype        IN ('PACS003','PACS003N')
                                THEN
                                    m_settlement_method := NVL(get_institution_param_value(p_institutionid => m_institutionid, p_path =>'FILE_PROCESSING.GEN_PARAMS.PACS003_GRPHDR_VALUES.SETTLEMENT_METHOD', p_paramname => 'METHOD_USED'),'PACS3');
                                         dbms_output.PUT_LINE('m_settlement_method pacs 3 '|| m_settlement_method);
                                ELSIF m_tdidcode_msgclasstype        IN ('PACS008','PACS008N')
                                THEN
                                    m_settlement_method := NVL(get_institution_param_value(p_institutionid => m_institutionid, p_path =>'FILE_PROCESSING.GEN_PARAMS.PACS008_GRPHDR_VALUES.SETTLEMENT_METHOD', p_paramname => 'METHOD_USED'),'PACS8');
                                         dbms_output.PUT_LINE('m_settlement_method pacs 8 '|| m_settlement_method);
                                ELSIF m_tdidcode_msgclasstype        IN ('PACS007','PACS007N')
                                THEN
                                    m_settlement_method := NVL(get_institution_param_value(p_institutionid => m_institutionid, p_path =>'FILE_PROCESSING.GEN_PARAMS.PACS007_GRPHDR_VALUES.SETTLEMENT_METHOD', p_paramname => 'METHOD_USED'),'PACS7');
                                         dbms_output.PUT_LINE('m_settlement_method pacs 7 '|| m_settlement_method);
                                ELSIF m_tdidcode_msgclasstype        IN ('PACS004','PACS004N')
                                THEN
                                    m_settlement_method := NVL(get_institution_param_value(p_institutionid => m_institutionid, p_path =>'FILE_PROCESSING.GEN_PARAMS.PACS004_GRPHDR_VALUES.SETTLEMENT_METHOD', p_paramname => 'METHOD_USED'),'PACS4');
                                         dbms_output.PUT_LINE('m_settlement_method pacs 4 '|| m_settlement_method);
                                ELSIF m_tdidcode_msgclasstype        IN ('CAMT056','CAMT056N')
                                THEN
                                    m_settlement_method := NVL(get_institution_param_value(p_institutionid => m_institutionid, p_path =>'FILE_PROCESSING.GEN_PARAMS.CAMT056_GRPHDR_VALUES.SETTLEMENT_METHOD', p_paramname => 'METHOD_USED'),'CAM56');
                                         dbms_output.PUT_LINE('m_settlement_method camt 56 '|| m_settlement_method);
                                ELSIF m_tdidcode_msgclasstype        IN ('CAMT029','CAMT029N')
                                THEN
                                    m_settlement_method := NVL(get_institution_param_value(p_institutionid => m_institutionid, p_path =>'FILE_PROCESSING.GEN_PARAMS.CAMT029_GRPHDR_VALUES.SETTLEMENT_METHOD', p_paramname => 'METHOD_USED'),'CAM29');
                                         dbms_output.PUT_LINE('m_settlement_method camt 29 '|| m_settlement_method);
                                END IF;

                                   dbms_output.put_line('Inserting new Batch Record => ' || m_msgdb_id_new_batch);

                                    a_msgdb_batch_new(1).msgdb_id                   := m_msgdb_id_new_batch;
                                    a_msgdb_batch_new(1).messageno                  := m_messageno_new_batch;
                                    a_msgdb_batch_new(1).isoutput                   := 'N';
                                    a_msgdb_batch_new(1).isinput                    := 'N';
                                    a_msgdb_batch_new(1).inputdate                  := TO_CHAR(m_date,'YYYYMMDD');
                                    a_msgdb_batch_new(1).inputtime                  := TO_CHAR(m_date,'HH24MISS');
                                    a_msgdb_batch_new(1).currqueueindate            := TO_CHAR(m_date,'YYYYMMDD');
                                    a_msgdb_batch_new(1).currqueueintime            := TO_CHAR(m_date,'HH24MISS');
                                    a_msgdb_batch_new(1).lockedby                   := NULL;
                                    a_msgdb_batch_new(1).repairedby                 := NULL;
                                    a_msgdb_batch_new(1).releasedby                 := NULL;
                                    a_msgdb_batch_new(1).authorizedby               := NULL;
                                    a_msgdb_batch_new(1).forwardedby                := NULL;
                                    a_msgdb_batch_new(1).operator                   := NULL;
                                    a_msgdb_batch_new(1).stachemmessageflag         := NULL;
--                                    a_msgdb_batch_new(1).custom5                    := (CASE WHEN p_src_bq_qid IS NULL THEN NULL ELSE 'NEXT = '||a_msgdb_batch(b_ctr).msgdb_id||'|'||'ORBT'||CHR(191) END);
                                    a_msgdb_batch_new(1).processing_stage           := (CASE WHEN p_src_bq_qid IS NULL THEN NULL ELSE get_queue_stage(a_msgdb_batch(b_ctr).institutionid,a_msgdb_batch(b_ctr).queueid) END);
                                    --a_msgdb_batch_new(1).transactiongroup           := (CASE WHEN p_src_bq_qid IS NULL THEN NULL ELSE get_trnx_group(a_msgdb_batch(b_ctr).messageclasstype,a_msgdb_batch(b_ctr).msgdb_id_org) END);
                                    a_msgdb_batch_new(1).transactiongroup           := a_msgdb_tran(tran_ctr).transactiongroup;
                                    a_msgdb_batch_new(1).inputdatetime              := TO_TIMESTAMP(TO_CHAR(m_date , 'YYYYMMDDHH24MISS'), 'YYYYMMDDHH24MISS');
                                    a_msgdb_batch_new(1).queueid                    := p_trgt_bq_qid;
                                    a_msgdb_batch_new(1).currency                   := a_msgdb_tran(tran_ctr).currency;
                                    a_msgdb_batch_new(1).tenant_name                := a_msgdb_tran(tran_ctr).tenant_name;
                                    a_msgdb_batch_new(1).custom37                   := a_msgdb_tran(tran_ctr).custom37;
                                    a_msgdb_batch_new(1).transrefno                 := m_messageno_new_batch;
                                    a_msgdb_batch_new(1).institutionid              := a_msgdb_tran(tran_ctr).institutionid;
                                    a_msgdb_batch_new(1).record_group_type          := 'B';
                                    a_msgdb_batch_new(1).messageclasstype           := p_src_tq_messageclasstype;
                                    a_msgdb_batch_new(1).status                     := p_trgt_bq_status;
                                    a_msgdb_batch_new(1).messagedirection           := a_msgdb_tran(tran_ctr).messagedirection;
                                    a_msgdb_batch_new(1).msg_family                 := a_msgdb_tran(tran_ctr).msg_family;
                                    a_msgdb_batch_new(1).msg_mode_in                := a_msgdb_tran(tran_ctr).msg_mode_in;
                                    a_msgdb_batch_new(1).msgsegr                    := a_msgdb_tran(tran_ctr).msgsegr;
                                    a_msgdb_batch_new(1).customeraccno              := a_msgdb_tran(tran_ctr).customeraccno;
                                    a_msgdb_batch_new(1).customeraccno_enc          := a_msgdb_tran(tran_ctr).customeraccno_enc;
                                    a_msgdb_batch_new(1).transactiontype            := a_msgdb_tran(tran_ctr).transactiontype;
                                    a_msgdb_batch_new(1).payment_duedate            := a_msgdb_tran(tran_ctr).payment_duedate;
                                    a_msgdb_batch_new(1).display_flag               := 'N';
                                    a_msgdb_batch_new(1).current_auth_level         := a_msgdb_tran(tran_ctr).current_auth_level;
                                    a_msgdb_batch_new(1).origname                   := a_msgdb_tran(tran_ctr).origname;
                                    a_msgdb_batch_new(1).origname_enc               := a_msgdb_tran(tran_ctr).origname_enc;
                                    a_msgdb_batch_new(1).currqueueindatetime        := a_msgdb_tran(tran_ctr).currqueueindatetime;
                                    a_msgdb_batch_new(1).custom40                   := a_msgdb_tran(tran_ctr).custom40;
                                    a_msgdb_batch_new(1).sender                     := a_msgdb_tran(tran_ctr).sender;
                                    a_msgdb_batch_new(1).channel_id_source          := a_msgdb_tran(tran_ctr).channel_id_source;
                                    a_msgdb_batch_new(1).priorityamountnum          := b_priorityamountnum;
                                    a_msgdb_batch_new(1).priorityamount             := TO_CHAR(b_priorityamountnum);
                                    a_msgdb_batch_new(1).receiver                   := a_msgdb_tran(tran_ctr).receiver;
                                    a_msgdb_batch_new(1).prioritydate               := a_msgdb_tran(tran_ctr).prioritydate;
                                    a_msgdb_batch_new(1).account_cr                 := a_msgdb_tran(tran_ctr).account_cr;
                                    a_msgdb_batch_new(1).account_cr_enc             := a_msgdb_tran(tran_ctr).account_cr_enc;
                                    a_msgdb_batch_new(1).account_dr                 := a_msgdb_tran(tran_ctr).account_dr;
                                    a_msgdb_batch_new(1).account_dr_enc             := a_msgdb_tran(tran_ctr).account_dr_enc;
                                    a_msgdb_batch_new(1).instanceid                 := p_instanceid;
                                    a_msgdb_batch_new(1).datakeyid                  := a_msgdb_tran(tran_ctr).datakeyid;
                                    a_msgdb_batch_new(1).settlementmethod           := m_settlement_method;

                                    IF a_msgdb_tran(tran_ctr).request_type = 'INV'
                                    THEN
                                        a_msgdb_batch_new(1).request_type               := a_msgdb_tran(tran_ctr).request_type;
                                       dbms_output.put_line('Request_type : ' || a_msgdb_tran(tran_ctr).request_type);
                                    END IF;

                                    INSERT INTO msgdb VALUES a_msgdb_batch_new(1);

                                    FOR i in t_ctr_beg..t_ctr_end
                                    LOOP
                                        --dbms_output.put_line('transaction_msgdb : '||a_msgdb_tran(i).msgdb_id);
                                        msgdb_links_new.EXTEND;
                                        msgdb_links_new(i).msgdb_id             := a_msgdb_tran(i).msgdb_id;
                                        msgdb_links_new(i).type                 := 'M';
                                        msgdb_links_new(i).parent_id            := m_msgdb_id_new_batch;
                                        msgdb_links_new(i).parent_type          := 'B';

                                        INSERT INTO msgdb_links VALUES msgdb_links_new(i);

                                    END LOOP;

                                    --dbms_output.put_line('Insert into msgdb_links completed');
                                    --dbms_output.put_line('Insert successful in msgdb for new Batch Record =>: ' || m_msgdb_id_new_batch);

                                    INSERT
                                    INTO msgdb_batch
                                    (
                                    msgdb_id,
                                    mdbbt_type,
                                    mdbbt_custnum1,
                                    mdbbt_custnum2,
                                    mdbbt_custnum3,
                                    mdbbt_custnum4,
                                    mdbbt_custnum5,
                                    mdbbt_custnum6,
                                    mdbbt_custchr1,
                                    mdbbt_custchr2,
                                    mdbbt_num_of_msgs
                                    )
                                    VALUES
                                    (
                                    m_msgdb_id_new_batch,
                                    NULL,
                                    TO_NUMBER(t_account_dr),
                                    0,
                                    NULL,
                                    NULL,
                                    NULL,
                                    NULL,
                                    NULL,
                                    NULL,
                                    b_tran_count
                                    );

                                    m_file_create    := TRUE;

                                    --dbms_output.put_line('Insert successful in msgdb_batch for new Batch Record =>: ' || m_msgdb_id_new_batch);

                                    m_batch_flag            := NVL(td_get_value (m_tdidcode_msgclasstype, 'F_BATCH_REQUIRED'),'N');

                                   dbms_output.put_line('m_batch_flag :'||m_batch_flag);

                                    Genaudit_Insert_Enchash_Wrap
                                                            (m_messageno_new_batch,
                                                            a_msgdb_batch_new(1).queueid,
                                                            'ADMIN1',
                                                            'EVNTSRVR',
                                                            'MESSAGE',
                                                            'NEW BATCH ENTRY',
                                                            'New Batch inserted with Batch Number <'||m_messageno_new_batch||'> and wrote to Queue '''||a_msgdb_batch_new(1).queueid||'''',
                                                            a_msgdb_tran(1).institutionid,
                                                            0
                                                            );
                                    b_tran_count                := 0;
                                END IF;

                                IF tran_ctr < t_ctr_end
                                THEN
                                   dbms_output.put_line('tran_ctr < t_ctr_end');

                                    m_next_groupinginfo_batch   := NVL(a_msgdb_tran(tran_ctr+1).groupinginfo_batch,'X');
                                    m_next_groupinginfo_file    := NVL(a_msgdb_tran(tran_ctr+1).groupinginfo_file,'X');

                                   dbms_output.put_line('m_next_groupinginfo_batch: ' || m_next_groupinginfo_batch);
                                   dbms_output.put_line('m_next_groupinginfo_file: ' || m_next_groupinginfo_file);
                                ELSE
                                        dbms_output.put_line('tran_ctr > t_ctr_end');
                                    IF m_inst_paramvalue = 'Y'
                                    THEN
                                        IF NOT cursor_trans2%NOTFOUND
                                        THEN
                                            dbms_output.put_line('NOT cursor_trans2%NOTFOUND');
                                            FETCH cursor_trans2 BULK COLLECT INTO a_msgdb_tran_tampered LIMIT m_tran_processing_limit;
                                            m_value:= 'Y';
                                        END IF;
                                    ELSIF  m_inst_paramvalue = 'N'
                                    THEN
                                        IF NOT cursor_trans1%NOTFOUND
                                        THEN
                                            dbms_output.put_line('NOT cursor_trans1%NOTFOUND');
                                            FETCH cursor_trans1 BULK COLLECT INTO a_msgdb_tran_tampered LIMIT m_tran_processing_limit;
                                            m_value:= 'Y';
                                        END IF;
                                    END IF;

                                    t_ctr_beg_tamp := NVL(a_msgdb_tran_tampered.FIRST,0);
                                    t_ctr_end_tamp := NVL(a_msgdb_tran_tampered.LAST ,0);
                                    dbms_output.put_line('Transactions begin: ' || t_ctr_beg_tamp);
                                    dbms_output.put_line('Transactions end: ' || t_ctr_end_tamp);


                                    IF t_ctr_end_tamp > 0
                                    THEN
                                        FOR i in t_ctr_beg_tamp..t_ctr_end_tamp
                                        LOOP
                                            dbms_output.put_line('i' ||i);
                                            dbms_output.put_line('a_msgdb_tran_tampered(i).msgdb_id ' || a_msgdb_tran_tampered(i).msgdb_id);
                                            IF a_msgdb_tran_tampered(i).tampered='Y'
                                            THEN
                                                dbms_output.put_line('a_msgdb_tran_tampered(i).tampered ' || a_msgdb_tran_tampered(i).tampered);

                                                UPDATE MSGDB
                                                SET QUEUEID='INERRMSG',
                                                    STATUS=69,
                                                    processing_stage=get_queue_stage(a_msgdb_tran_tampered(i).institutionid,'INERRMSG')
                                                WHERE msgdb_id=  a_msgdb_tran_tampered(i).msgdb_id;
                                                dbms_output.put_line('updated');
                                            ELSE
                                                dbms_output.put_line('a_msgdb_tran_tampered(i).tampered ' || a_msgdb_tran_tampered(i).tampered);
                                                a_msgdb_tran.extend();
                                                a_msgdb_tran(a_msgdb_tran.LAST)               :=      a_msgdb_tran_tampered(i);
                                                dbms_output.put_line('extended');
                                            END IF;
                                        END LOOP;
                                    END IF;




                                    IF m_value='Y'
                                    THEN
                                        --tran_ctr  := 0;
                                        t_ctr_beg_1 := NVL (a_msgdb_tran.FIRST, 0); -- Set the start counter for MT940P transactions
                                        t_ctr_end_1 := NVL (a_msgdb_tran.LAST, 0);  -- Set the end   counter for MT940P transactions

                                       dbms_output.put_line('t_ctr_beg: ' || t_ctr_beg);
                                       dbms_output.put_line('t_ctr_end: ' || t_ctr_end);

                                        IF t_ctr_end_1 > 0
                                        THEN
                                           dbms_output.put_line('t_ctr_end > 0');
                                            m_next_groupinginfo_batch         := a_msgdb_tran(t_ctr_beg).groupinginfo_batch;
                                        ELSE
                                           dbms_output.put_line('t_ctr_end = 0');

                                            IF b_ctr+1 > b_ctr_end
                                            THEN
                                                m_next_groupinginfo_batch         := 'LASTRECORD';
                                            ELSE
                                                m_next_groupinginfo_batch         := NVL(a_msgdb_batch(b_ctr+1).groupinginfo_batch,'X');
                                                m_next_msgdb_id_batch       := NVL(a_msgdb_batch(b_ctr+1).msgdb_id,0);

                                                IF cursor_trans1%ISOPEN
                                                THEN
                                                    CLOSE cursor_trans1;
                                                ELSIF cursor_trans2%ISOPEN
                                                THEN
                                                    CLOSE cursor_trans2;
                                                END IF;

                                                IF  p_src_bq_qid IS NOT NULL
                                                THEN
                                                    IF m_inst_paramvalue = 'N'
                                                    THEN
                                                        OPEN cursor_trans1(m_institutionid,m_next_msgdb_id_batch,m_src_tq_qid);
                                                        FETCH cursor_trans1 BULK COLLECT INTO a_msgdb_tran LIMIT m_tran_processing_limit;
                                                    ELSIF m_inst_paramvalue = 'Y'
                                                        THEN
                                                        OPEN cursor_trans2(m_institutionid,m_next_msgdb_id_batch,m_src_tq_qid);
                                                        FETCH cursor_trans2 BULK COLLECT INTO a_msgdb_tran LIMIT m_tran_processing_limit;
                                                    END IF;
                                                ELSE
                                                    IF m_inst_paramvalue = 'N'
                                                    THEN
                                                        OPEN cursor_trans1(m_institutionid,0,m_src_tq_qid);
                                                        FETCH cursor_trans1 BULK COLLECT INTO a_msgdb_tran_tampered LIMIT m_tran_processing_limit;
                                                    ELSIF m_inst_paramvalue = 'Y'
                                                        THEN
                                                        OPEN cursor_trans2(m_institutionid,0,m_src_tq_qid);
                                                        FETCH cursor_trans2 BULK COLLECT INTO a_msgdb_tran_tampered LIMIT m_tran_processing_limit;
                                                    END IF;
                                                END IF;

                                                t_ctr_beg_tamp := NVL(a_msgdb_tran_tampered.FIRST,0);
                                                t_ctr_end_tamp := NVL(a_msgdb_tran_tampered.LAST ,0);
                                                dbms_output.put_line('Transactions begin: ' || t_ctr_beg_tamp);
                                                dbms_output.put_line('Transactions end: ' || t_ctr_end_tamp);


                                                IF t_ctr_end_tamp > 0
                                                THEN
                                                    FOR i in t_ctr_beg_tamp..t_ctr_end_tamp
                                                    LOOP
                                                        dbms_output.put_line('i' ||i);
                                                        dbms_output.put_line('a_msgdb_tran_tampered(i).msgdb_id ' || a_msgdb_tran_tampered(i).msgdb_id);
                                                        IF a_msgdb_tran_tampered(i).tampered='Y'
                                                        THEN
                                                            dbms_output.put_line('a_msgdb_tran_tampered(i).tampered ' || a_msgdb_tran_tampered(i).tampered);

                                                            UPDATE MSGDB
                                                            SET QUEUEID='INERRMSG',
                                                                STATUS=69,
                                                                processing_stage=get_queue_stage(a_msgdb_tran_tampered(i).institutionid,'INERRMSG')
                                                            WHERE msgdb_id=  a_msgdb_tran_tampered(i).msgdb_id;
                                                            dbms_output.put_line('updated');
                                                            genaudit_insert_enchash_wrap
                                                            (
                                                            a_msgdb_tran_tampered(i).messageno,
                                                            'INERRMSG',
                                                            'ADMIN',
                                                            'PELICAN',
                                                            'BATCH',
                                                            'MOVE',
                                                            'Transaction number <'||a_msgdb_tran_tampered(i).messageno ||'> moved to INERRMSG due to Authentication Failure',
                                                            a_msgdb_tran_tampered(i).institutionid,
                                                            0
                                                            );
                                                        ELSE
                                                            dbms_output.put_line('a_msgdb_tran_tampered(i).tampered ' || a_msgdb_tran_tampered(i).tampered);
                                                            a_msgdb_tran.extend();
                                                            a_msgdb_tran(a_msgdb_tran.LAST)               :=      a_msgdb_tran_tampered(i);
                                                            dbms_output.put_line('extended');
                                                        END IF;
                                                    END LOOP;
                                                END IF;



                                                IF NVL(a_msgdb_tran.FIRST,0) > 0
                                                THEN
                                                    m_next_groupinginfo_batch := a_msgdb_tran(a_msgdb_tran.FIRST).groupinginfo_batch;
                                                ELSE
                                                    m_next_groupinginfo_batch := 'LASTRECORD';
                                                END IF;
                                                IF cursor_trans1%ISOPEN
                                                THEN
                                                    CLOSE cursor_trans1;
                                                ELSIF cursor_trans2%ISOPEN
                                                THEN
                                                    CLOSE cursor_trans2;
                                                END IF;

                                               dbms_output.put_line('m_next_groupinginfo_batch : ' || m_next_groupinginfo_batch);

                                            END IF;
                                            m_next_groupinginfo_batch   := 'LASTRECORD';
                                        END IF;
                                    ELSE
                                       dbms_output.put_line('cursor_trans%NOTFOUND');

                                        IF b_ctr+1 > b_ctr_end
                                        THEN
                                            m_next_groupinginfo_batch   := 'LASTRECORD';
                                        ELSE
                                            m_next_groupinginfo_batch   := NVL(a_msgdb_batch(b_ctr+1).groupinginfo_batch,'X');
                                            m_next_msgdb_id_batch       := NVL(a_msgdb_batch(b_ctr+1).msgdb_id,0);

                                            IF cursor_trans1%ISOPEN
                                                THEN
                                                    CLOSE cursor_trans1;
                                                ELSIF cursor_trans2%ISOPEN
                                                THEN
                                                    CLOSE cursor_trans2;
                                            END IF;

                                            IF  p_src_bq_qid IS NOT NULL
                                                THEN
                                                    IF m_inst_paramvalue = 'N'
                                                    THEN
                                                        OPEN cursor_trans1(m_institutionid,m_next_msgdb_id_batch,m_src_tq_qid);
                                                        FETCH cursor_trans1 BULK COLLECT INTO a_msgdb_tran LIMIT m_tran_processing_limit;
                                                    ELSIF m_inst_paramvalue = 'Y'
                                                        THEN
                                                        OPEN cursor_trans2(m_institutionid,m_next_msgdb_id_batch,m_src_tq_qid);
                                                        FETCH cursor_trans2 BULK COLLECT INTO a_msgdb_tran LIMIT m_tran_processing_limit;
                                                    END IF;
                                                ELSE
                                                    IF m_inst_paramvalue = 'N'
                                                    THEN
                                                        OPEN cursor_trans1(m_institutionid,0,m_src_tq_qid);
                                                        FETCH cursor_trans1 BULK COLLECT INTO a_msgdb_tran LIMIT m_tran_processing_limit;
                                                    ELSIF m_inst_paramvalue = 'Y'
                                                        THEN
                                                        OPEN cursor_trans2(m_institutionid,0,m_src_tq_qid);
                                                        FETCH cursor_trans2 BULK COLLECT INTO a_msgdb_tran LIMIT m_tran_processing_limit;
                                                    END IF;
                                             END IF;

                                           dbms_output.put_line('(a_msgdb_tran.FIRST : ' || (a_msgdb_tran.FIRST));

                                            t_ctr_beg_tamp := NVL(a_msgdb_tran_tampered.FIRST,0);
                                                t_ctr_end_tamp := NVL(a_msgdb_tran_tampered.LAST ,0);
                                                dbms_output.put_line('Transactions begin: ' || t_ctr_beg_tamp);
                                                dbms_output.put_line('Transactions end: ' || t_ctr_end_tamp);


                                                IF t_ctr_end_tamp > 0
                                                THEN
                                                    FOR i in t_ctr_beg_tamp..t_ctr_end_tamp
                                                    LOOP
                                                        dbms_output.put_line('i' ||i);
                                                        dbms_output.put_line('a_msgdb_tran_tampered(i).msgdb_id ' || a_msgdb_tran_tampered(i).msgdb_id);
                                                        IF a_msgdb_tran_tampered(i).tampered='Y'
                                                        THEN
                                                            dbms_output.put_line('a_msgdb_tran_tampered(i).tampered ' || a_msgdb_tran_tampered(i).tampered);

                                                            UPDATE MSGDB
                                                            SET QUEUEID='INERRMSG',
                                                                STATUS=69,
                                                                processing_stage=get_queue_stage(a_msgdb_tran_tampered(i).institutionid,'INERRMSG')
                                                            WHERE msgdb_id=  a_msgdb_tran_tampered(i).msgdb_id;
                                                            dbms_output.put_line('updated');

                                                            genaudit_insert_enchash_wrap
                                                            (
                                                            a_msgdb_tran_tampered(i).messageno,
                                                            'INERRMSG',
                                                            'ADMIN',
                                                            'PELICAN',
                                                            'BATCH',
                                                            'MOVE',
                                                            'Transaction number <'||a_msgdb_tran_tampered(i).messageno ||'> moved to INERRMSG due to Authentication Failure',
                                                            a_msgdb_tran_tampered(i).institutionid,
                                                            0
                                                            );
                                                        ELSE
                                                            dbms_output.put_line('a_msgdb_tran_tampered(i).tampered ' || a_msgdb_tran_tampered(i).tampered);
                                                            a_msgdb_tran.extend();
                                                            a_msgdb_tran(a_msgdb_tran.LAST)               :=      a_msgdb_tran_tampered(i);
                                                            dbms_output.put_line('extended');
                                                        END IF;
                                                    END LOOP;
                                                END IF;

                                            IF NVL(a_msgdb_tran.FIRST,0) > 0
                                            THEN
                                                m_next_groupinginfo_batch := a_msgdb_tran(a_msgdb_tran.FIRST).groupinginfo_batch;
                                            ELSE
                                                m_next_groupinginfo_batch := 'LASTRECORD';
                                            END IF;
                                            IF cursor_trans1%ISOPEN
                                            THEN
                                                CLOSE cursor_trans1;
                                            ELSIF cursor_trans2%ISOPEN
                                            THEN
                                                CLOSE cursor_trans2;
                                            END IF;
                                                dbms_output.put_line('m_next_groupinginfo_batch : ' || m_next_groupinginfo_batch);

                                        END IF;
                                        m_next_groupinginfo_batch   := 'LASTRECORD';
                                    END IF;
                                END IF;

                                f_tran_count            := f_tran_count + 1;
                                f_priorityamountnum     := f_priorityamountnum + a_msgdb_tran(tran_ctr).priorityamountnum;

                                b_tran_count            := b_tran_count + 1;
                                b_priorityamountnum     := b_priorityamountnum + a_msgdb_tran(tran_ctr).priorityamountnum;

                               dbms_output.put_line('f_priorityamountnum: ' || f_priorityamountnum);
                               dbms_output.put_line('b_tran_count: ' || b_tran_count);
                               dbms_output.put_line('b_priorityamountnum: ' || b_priorityamountnum);
                                BEGIN
                                SELECT NVL(paramvalue,'X')
                                INTO m_tenant
                                FROM institutionparameters
                                WHERE institutionid=a_msgdb_tran (tran_ctr).institutionid
                                AND paramname='TENANT_NAME';
                                EXCEPTION
                WHEN NO_DATA_FOUND
                THEN m_tenant := 'X';
                END;

                                IF m_tenant =  m_tenant_list
                                THEN
                                t_account_dr            := t_account_dr + account_number_summation(encrypt_decrypt_basedon_session_cntx(m_decrypt,a_msgdb_tran(tran_ctr).institutionid,TRIM(a_msgdb_tran(tran_ctr).account_dr_enc)));
                                ELSE
                                t_account_dr            := t_account_dr + account_number_summation(TRIM(a_msgdb_tran(tran_ctr).account_dr));
                                END IF;

                                a_msgdb_id_output_batch(tran_ctr)     := m_msgdb_id_new_batch;
                                a_record_end_marker(tran_ctr)         := NULL;

                               dbms_output.put_line('m_next_groupinginfo_batch = ' || m_next_groupinginfo_batch || ' |current groupinginfo = ' || a_msgdb_tran(tran_ctr).groupinginfo_batch);
                               dbms_output.put_line('-----------------------------------------------------------------------------------');

                                BEGIN
                                    m_max_trans_per_batch := t_max_transactions_in_one_batch(a_msgdb_tran(tran_ctr).institutionid || '.GEN_PARAMS.OUTPUT_BANKING_CHANNEL_CONF.' ||a_msgdb_tran(tran_ctr).custom37);
                                EXCEPTION
                                    WHEN NO_DATA_FOUND
                                    THEN
                                        m_max_trans_per_batch := 0;
                                END;

                                BEGIN
                                    m_max_trans_per_batch := t_max_transactions_in_one_batch(a_msgdb_tran(tran_ctr).institutionid || '.GEN_PARAMS.OUTPUT_BANKING_CHANNEL_CONF.' ||a_msgdb_tran(tran_ctr).custom37);
                                EXCEPTION
                                    WHEN NO_DATA_FOUND
                                    THEN
                                        m_max_trans_per_batch := 0;

                                END;

                                BEGIN
                                    m_max_trans_per_file := t_max_transactions_in_one_file(a_msgdb_tran(tran_ctr).institutionid || '.GEN_PARAMS.OUTPUT_BANKING_CHANNEL_CONF.' ||a_msgdb_tran(tran_ctr).custom37);
                                EXCEPTION
                                    WHEN NO_DATA_FOUND
                                    THEN
                                        m_max_trans_per_file := 0;
                                END;

                                BEGIN
                                    m_max_amnt_per_file := t_max_amount_in_one_file(a_msgdb_tran(tran_ctr).institutionid || '.GEN_PARAMS.OUTPUT_BANKING_CHANNEL_CONF.' ||a_msgdb_tran(tran_ctr).custom37);
                                EXCEPTION
                                    WHEN NO_DATA_FOUND
                                    THEN
                                        m_max_amnt_per_file := 0;
                                END;

                              dbms_output.put_line('m_max_trans_per_batch : ' || m_max_trans_per_batch);
                              dbms_output.put_line('b_tran_count : ' || b_tran_count);
--                               dbms_output.put_line('MAX_BATCHES_IN_ONE_FILE       : ' || m_max_batches_per_file);
--                               dbms_output.put_line('MAX_TRANSACTIONS_IN_ONE_FILE  : ' || m_max_trans_per_file);
--                               dbms_output.put_line('MAX_AMOUNT_IN_ONE_FILE        : ' || m_max_amnt_per_file);

                                IF  (m_next_groupinginfo_batch = 'LASTRECORD')                --     Last transactions records of the batch
                                    OR (a_msgdb_tran(tran_ctr).groupinginfo_batch != m_next_groupinginfo_batch)
                                    OR (m_max_trans_per_batch > 0 AND b_tran_count = m_max_trans_per_batch)    --    if the current transaction count is greater than the max transactions allowed per batch
                                THEN
                                    a_record_end_marker(tran_ctr)    := m_record_end_marker_batch;
                                   dbms_output.put_line('record_end_marker_batch: ' || m_record_end_marker_batch);

                                    m_last_transaction := a_msgdb_tran(tran_ctr).msgdb_id;
                                    new_batch        := TRUE;

                                   dbms_output.put_line('new_batch set to true 1021');

                                    f_btch_count    := f_btch_count + 1;

                                   dbms_output.put_line('m_banking_channel : ' || m_banking_channel);

                                    IF m_banking_channel = 'DEUT_CHNL'
                                    THEN
                                        m_transrefno := m_transrefno || '-' || LTRIM(RTRIM(TO_CHAR(m_transrefno_seq)));
                                        IF LENGTH(m_transrefno) > 20
                                        THEN
                                            m_transrefno := SUBSTR(m_transrefno,-20);
                                        END IF;
                                        m_transrefno_new  :=  m_transrefno;
                                    ELSE
                                        IF     LENGTH(m_transrefno) + LENGTH(m_messageno_new_batch) > 34
                                        THEN
                                                m_transrefno := SUBSTR(m_transrefno,1,( LENGTH(m_transrefno) - (LENGTH(m_transrefno) + LENGTH(m_messageno_new_batch) -34) ) );
                                        END IF;
                                        m_transrefno_new     :=  m_transrefno || '-' || m_messageno_new_batch;
                                    END IF;

                                    m_transrefno_seq := m_transrefno_seq + 1;

                                    IF m_transrefno_seq > 99
                                    THEN
                                        m_transrefno_seq := 1;
                                    END IF;

                                    IF p_src_bq_qid IS NULL
                                    THEN

                                        IF  p_src_tq_messageclasstype = 'pain.008.001.02'
                                        THEN
                                            b_message_clob := generate_batch_header_pain008(m_messageno_new_batch, b_priorityamountnum, b_tran_count, m_institutionid, NULL, m_executiondate, m_origname, m_account_cr, m_bic, NULL, m_localinstrumentcode);
                                        ELSIF p_src_tq_messageclasstype = 'pain.001.001.03'
                                        THEN
                                            --b_message_clob := generate_batch_header_pain001(m_messageno_new_batch, b_priorityamountnum, b_tran_count, m_institutionid, m_executiondate, m_origname, t_account_dr, m_bic);
                                            m_btchbookg := LOWER(NVL(td_get_value(a_msgdb_tran(tran_ctr).custom37,'BATCH_BOOKING'),get_institution_param_value(p_institutionid => a_msgdb_tran(tran_ctr).institutionid, p_path => 'FILE_PROCESSING.GEN_PARAMS.PAIN001_BATCH_VALUES', p_paramname => 'BATCH_BOOKING')));

                                            m_service_tdvalue := NVL(td_get_value(a_msgdb_tran(tran_ctr).custom37,'BATCH_SERVICELEVEL'), 'SEPA');

                                            IF instr(m_service_tdvalue,'.') > 1
                                            THEN
                                            m_btchservicelevel := 'SELECT ' || m_service_tdvalue || ' FROM MSGDB
                                            WHERE MSGDB_ID = ' || a_msgdb_tran(tran_ctr).MSGDB_ID;
                                            ELSE
                                            m_btchservicelevel := 'SELECT ' || '''' || m_service_tdvalue ||'''' || ' FROM MSGDB
                                            WHERE MSGDB_ID = ' || a_msgdb_tran(tran_ctr).MSGDB_ID;
                                            END IF;
                                           dbms_output.put_line ('m_btchservicelevel : ' || m_btchservicelevel)  ;

                                            EXECUTE IMMEDIATE  m_btchservicelevel INTO m_btchservicelevel_value;

                                            BEGIN
                                                SELECT  country_code
                                                INTO    m_ctrycode
                                                FROM    account_master
                                                WHERE   (account_iban   = a_msgdb_tran(tran_ctr).customeraccno
                                                OR      account_iban_enc = a_msgdb_tran(tran_ctr).customeraccno_enc
                                                OR      account_number  = a_msgdb_tran(tran_ctr).customeraccno
                                                OR      account_number_enc  = a_msgdb_tran(tran_ctr).customeraccno_enc)
                                                AND     country_code    IS NOT NULL
                                                AND     rownum = 1;
                                            EXCEPTION
                                                WHEN OTHERS
                                                THEN
                                                    m_ctrycode := NULL;
                                            END;

                                            b_message_clob := generate_xml('B_MESSAGENO=' || m_messageno_new_batch || '|B_BTCHBOOKG=' || m_btchbookg || '|B_T_COUNT=' ||b_tran_count || '|B_PSTLADR_CTRY=' || m_ctrycode || '|B_AMOUNT='||b_priorityamountnum|| '|B_SERVICELEVEL=' || m_btchservicelevel_value ||'|',m_tdidcode_msgclasstype, m_msgdb_id_new_batch,'B');   ----This is generic function which would return batch blob with updated values

                                            IF a_msgdb_tran(tran_ctr).tenant_name = 'VISTRA'
                                            THEN
                                                m_xtype    := XMLTYPE(xmlData => b_message_clob);

                                                SELECT COUNT(*)
                                                INTO m_cnt
                                                FROM TABLEDETAILS
                                                WHERE TDKEY  = 'BATCH_CURRENCY'
                                                AND TDIDCODE = a_msgdb_tran(tran_ctr).custom37;
                                               dbms_output.put_line ('m_cnt : ' || m_cnt)  ;

                                                IF m_cnt > 0
                                                THEN
                                                    SELECT  EXTRACTVALUE(m_xtype,'PmtInf/DbtrAcct/Id/IBAN/text()')
                                                    INTO    m_tag_value
                                                    FROM    DUAL;
                                                   dbms_output.put_line ('m_cnt : ' || m_cnt)  ;

                                                    SELECT account_curr
                                                    INTO   m_currency
                                                    FROM   ACCOUNT_MASTER
                                                    WHERE  (ACCOUNT_IBAN_ENC = encrypt_decrypt_basedon_session_cntx(m_encrypt,a_msgdb_tran(tran_ctr).institutionid,m_tag_value)
                                                       OR   ACCOUNT_IBAN     = return_masked_info(m_prefix,a_msgdb_tran(tran_ctr).institutionid,m_tag_value)
                               OR   ACCOUNT_NUMBER_ENC = encrypt_decrypt_basedon_session_cntx(m_encrypt,a_msgdb_tran(tran_ctr).institutionid,m_tag_value)
                               OR   ACCOUNT_NUMBER     = return_masked_info(m_prefix,a_msgdb_tran(tran_ctr).institutionid,m_tag_value))
                                                      AND  ACCOUNT_STATUS    = 'VALIDATED'
                                                      AND  institution_id= a_msgdb_tran(tran_ctr).institutionid;
                                                     dbms_output.put_line ('a_msgdb_tran(tran_ctr).institutionid : ' || a_msgdb_tran(tran_ctr).institutionid)  ;
                                                     dbms_output.put_line ('m_currency : ' || m_currency)  ;

                                                    SELECT  INSERTCHILDXML(m_xtype,'PmtInf/DbtrAcct', 'Ccy', XMLTYPE('<Ccy>'||m_currency||'</Ccy>'))
                                                    INTO    m_xtype
                                                    FROM    DUAL;

                                                END IF;


                                                SELECT  EXTRACTVALUE(m_xtype,'PmtInf/DbtrAgt/FinInstnId/BIC/text()')
                                                INTO    m_tag_value
                                                FROM    DUAL;

                                               dbms_output.put_line('m_tag_value: ' || m_tag_value);
                                                IF m_tag_value IS NULL
                                                THEN

                                                    SELECT  DELETEXML(m_xtype,'PmtInf/DbtrAgt/FinInstnId/BIC',NULL)
                                                    INTO    m_xtype
                                                    FROM    DUAL;

                                                    SELECT  INSERTCHILDXML(m_xtype,'PmtInf/DbtrAgt/FinInstnId', 'Othr', XMLTYPE('<Othr><Id>NOTPROVIDED</Id></Othr>'))
                                                    INTO    m_xtype
                                                    FROM    DUAL;

                                                   dbms_output.put_line('m_xtype: ' || m_xtype.getclobval());
                                                END IF;

                                                SELECT  EXTRACTVALUE(m_xtype,'/PmtInf/Dbtr/PstlAdr/Ctry/text()')
                                                INTO    m_tag_value
                                                FROM    DUAL;

                                                IF m_tag_value IS NULL
                                                THEN

                                                    SELECT  DELETEXML(m_xtype,'PmtInf/Dbtr/PstlAdr/Ctry',NULL)
                                                    INTO    m_xtype
                                                    FROM    DUAL;

                                                   dbms_output.put_line('m_xtype: ' || m_xtype.getclobval());
                                                END IF;

                                                b_message_clob := m_xtype.getclobval();
                                            END IF;
                                        END IF;

                                        IF p_src_tq_messageclasstype  IN  ('pain.008.001.02', 'pain.001.001.03') ----We Cannot add batch end tag becasue this should be added after last transaction insertion
                                        THEN
                                            b_message_clob := REPLACE(b_message_clob,m_batch_endtag,'');
                                        ELSE
                                            b_message_clob := REPLACE(b_message_clob,td_get_value(m_tdidcode_msgclasstype,'BATCH_FOOTER'),'');
                                        END IF;

                                        IF  LENGTH(b_message_clob) > 0
                                        THEN
                                            b_message_blob := clob_to_blob(encrypt_decrypt_basedon_session_cntx_clob(m_encrypt,a_msgdb_tran(tran_ctr).institutionid,b_message_clob));
                                        END IF;
                                    END IF;

                                    INSERT
                                    INTO    msgblocks
                                    (
                                    msgdb_id,
                                    msgblocktype,
                                    msgfamily,
                                    message)
                                    VALUES
                                    (
                                    m_msgdb_id_new_batch,
                                    91,
                                    m_msgfamily,
                                    b_message_blob
                                    );

                                    UPDATE  msgdb
                                    SET     priorityamountnum   = b_priorityamountnum,
                                            priorityamount      = TO_CHAR(b_priorityamountnum)
--                                            display_flag        = 'N'
                                    WHERE   msgdb_id            = m_msgdb_id_new_batch;


                                    UPDATE  msgdb_batch
                                    SET     mdbbt_num_of_msgs   = b_tran_count
                                    WHERE   msgdb_id            = m_msgdb_id_new_batch;

                                    b_tran_count        := 0;
                                    b_priorityamountnum := 0;
                                END IF;

                               dbms_output.put_line ('tran_ctr: ' || tran_ctr);
                               dbms_output.put_line ('t_ctr_end: ' || t_ctr_end);
                               dbms_output.put_line ('a_msgdb_tran(tran_ctr).groupinginfo_file: ' || a_msgdb_tran(tran_ctr).groupinginfo_file);
                               dbms_output.put_line ('m_next_groupinginfo_file: ' || m_next_groupinginfo_file);
                               dbms_output.put_line ('m_max_trans_per_file: ' || m_max_trans_per_file);
                               dbms_output.put_line ('f_tran_count: ' || f_tran_count);
                               dbms_output.put_line ('f_btch_count: ' || f_btch_count);
                               dbms_output.put_line ('m_max_batches_per_file: ' || m_max_batches_per_file);
                               dbms_output.put_line ('m_max_amnt_per_file: ' || m_max_amnt_per_file);
                               dbms_output.put_line ('f_priorityamountnum: ' || f_priorityamountnum);

                                IF  (tran_ctr = t_ctr_end OR a_msgdb_tran(tran_ctr).groupinginfo_file != m_next_groupinginfo_file) OR
                                    (m_max_trans_per_file   > 0 AND f_tran_count = m_max_trans_per_file) OR     -- IF the current transaction count is EQUAL TO max transactions allowed per file
                                    (m_max_batches_per_file > 0 AND f_btch_count = m_max_batches_per_file) OR
                                    (m_max_amnt_per_file > 0 AND f_priorityamountnum > m_max_amnt_per_file)
                                THEN
                                    a_record_end_marker(tran_ctr)  := m_record_end_marker_file;
                                    new_batch                   := TRUE;
                                   dbms_output.put_line('new_batch set to true 1113');
                                    f_btch_count                := 0;
                                    f_tran_count                := 0;
                                    f_priorityamountnum         := 0;
                                END IF;

                                m_date                  := SYSDATE;
                                m_last_transaction_id   := a_msgdb_tran(tran_ctr).msgdb_id;

                                IF a_msgdb_tran(tran_ctr).groupinginfo_file != m_next_groupinginfo_file
                                THEN
                                   dbms_output.put_line('a_record_end_marker(a_record_end_marker.LAST): ' || a_record_end_marker(a_record_end_marker.LAST));
                                   dbms_output.put_line('m_record_end_marker_file: ' || m_record_end_marker_file);
                                    a_record_end_marker(a_record_end_marker.LAST)    := m_record_end_marker_file;

                                    IF b_ctr < b_ctr_end                                        -- If next batch record exist
                                    THEN
                                        m_institutionid     := a_msgdb_batch(b_ctr+1).institutionid;
                                        m_banking_channel   := RPAD(a_msgdb_batch(b_ctr+1).custom37,255,'X');
                                    END IF;

                                    b_tran_count            := 0;
                                    f_btch_count            := 0;
                                    f_tran_count            := 0;
                                    f_priorityamountnum     := 0;
                                END IF;

                                IF tran_ctr = 0
                                THEN
                                    tran_ctr     := 1;
                                ELSE
                                    tran_ctr     := tran_ctr     + 1;
                                END IF;
                            END LOOP;

                            b_tran_count            := 0; -- new batch transaction count

                           dbms_output.put_line('Updating transactions record with New batch ID=>' || m_msgdb_id_new_batch);

                            --FORALL  t_ctr IN t_ctr_beg..t_ctr_end
                            FOR t_ctr IN t_ctr_beg..t_ctr_end
                            LOOP

                                UPDATE  msgdb
                                SET     queueid                 = p_trgt_tran_queueid,
                                        status                  = p_trgt_tran_status,
                                        record_end_marker       = a_record_end_marker(t_ctr),
                                        msgdb_id_output_batch   = a_msgdb_id_output_batch(t_ctr)
                                WHERE   msgdb_id                = a_msgdb_tran(t_ctr).msgdb_id;

                               dbms_output.put_line('a_record_end_marker(t_ctr): ' || a_record_end_marker(t_ctr));
                               dbms_output.put_line('a_msgdb_id_output_batch(t_ctr): ' || a_msgdb_id_output_batch(t_ctr));
                               dbms_output.put_line('a_msgdb_tran(t_ctr).msgdb_id: ' || a_msgdb_tran(t_ctr).msgdb_id);

                                genaudit_insert_enchash_wrap
                                (
                                a_msgdb_tran(t_ctr).messageno,
                                p_trgt_tran_queueid,
                                'ADMIN',
                                'PELICAN',
                                'BATCH',
                                'MOVE',
                                'Transaction number <'||a_msgdb_tran(t_ctr).messageno ||'> and moved to '''||p_trgt_tran_queueid||''' from Queue '''||p_src_tq_qid||'''',
                                a_msgdb_tran(t_ctr).institutionid,
                                0
                                );
                               dbms_output.put_line('Successfully updated transactions record with New batch ID=>' || m_msgdb_id_new_batch);
                            END LOOP;
                            COMMIT;

                        EXCEPTION
                            WHEN FUTURE_DATE_BATCH
                            THEN
                               dbms_output.put_line('Exception=>batch is of future date');
                                null;

                            WHEN RELEASE_LATER
                            THEN
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
                            WHEN NO_TRANSACTION_FOUND
                            THEN
                               dbms_output.put_line('Exception=>No transaction found');
                                null;

                            WHEN INVALID_XML
                            THEN
                                ROLLBACK;
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
                               dbms_output.put_line('Exception=>Invalid XML');
                               COMMIT;
                            WHEN OTHERS
                            THEN
                                g_ora_exception := 'pymt_txns_batching OTHERS:' || DBMS_UTILITY.format_error_backtrace;
                                g_audittext        := SUBSTR(g_ora_exception,1,750);

                               dbms_output.put_line(SQLCODE || SQLERRM || dbms_utility.format_error_backtrace);

                                ROLLBACK;
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
                               COMMIT;
                        END;

                        IF cursor_trans1%ISOPEN
                        THEN
                            CLOSE cursor_trans1;
                        END IF;
                        IF cursor_trans2%ISOPEN
                        THEN
                            CLOSE cursor_trans2;
                        END IF;
                    END LOOP;

                    IF m_last_transaction > 0 AND p_messagedirection = 'I' AND  UPPER(p_src_tq_messageclasstype) like 'PACS.008%'
                    THEN
                        UPDATE  msgdb
                        SET     record_end_marker = m_record_end_marker_file
                        WHERE   msgdb_id = m_last_transaction;
                       dbms_output.put_line('m_last_transaction : '|| m_last_transaction);
                    END IF;

                    IF m_file_create
                    THEN
                        IF p_src_bq_qid IS NOT NULL
                        THEN
                            FORALL b_ctr IN b_ctr_beg..b_ctr_end
                            UPDATE  msgdb
                            SET     status              = a_msgdb_batch(b_ctr).status,
                                    queueid             = a_msgdb_batch(b_ctr).queueid,
                                    processing_stage    = get_queue_stage(a_msgdb_batch(b_ctr).institutionid,a_msgdb_batch(b_ctr).queueid)
                            WHERE   msgdb_id            = a_msgdb_batch(b_ctr).msgdb_id;
                        END IF;
                    END IF;

                    IF b_ctr_end > 0 AND p_src_bq_qid IS NOT NULL
                    THEN
                        UPDATE  msgdb_file
                        SET     mdbfl_custnum2  = mdbfl_custnum2 + m_processed_batch_count,
                                mdbfl_custnum3  = mdbfl_custnum3 + m_new_batch_count
                        WHERE   msgdb_id        = a_msgdb_file(f_ctr).msgdb_id;

                       dbms_output.put_line('m_src_fq_status : '|| m_src_fq_status);

                        UPDATE      msgdb
                        SET         status       = p_src_fq_status_new
                        WHERE       msgdb_id     = a_msgdb_file(f_ctr).msgdb_id
                        RETURNING   institutionid, messageno, queueid, status INTO g_institutionid, g_messageno, g_queueid, g_status;

                        g_audittext        := 'File status set as ' ||  td_get_value('MESSAGESTATUS2',p_src_fq_status_new);

                        Genaudit_Insert_Enchash_Wrap(g_messageno,
                                                     g_queueid,
                                                     NULL,
                                                     'EVNTSRVR',
                                                     'FILE',
                                                     'MOVE',
                                                     g_audittext,
                                                     g_institutionid,
                                                     0
                                                     );
                    END IF;
                    IF cursor_batch%ISOPEN
                    THEN
                        CLOSE cursor_batch;
                    END IF;
                EXCEPTION
                    WHEN NO_DATA_FOUND
                    THEN
                        IF cursor_batch%ISOPEN
                        THEN
                            CLOSE cursor_batch;
                        END IF;

                    WHEN NO_BATCHES_FOUND
                    THEN
                       dbms_output.put_line('No batches found');
                        null;

                    WHEN PAYMENT_ONBEHALF
                    THEN
                    null;
                         --  dbms_output.put_line(m_institutionid || ' Payment on Behalf flag is : Y');
                END;
--                COMMIT;
            END LOOP;
            IF cursor_file%ISOPEN
            THEN
                CLOSE cursor_file;
            END IF;
        EXCEPTION
            WHEN INVALID_CUTOFF
            THEN
               dbms_output.put_line('invalid cutoff time');
                    null;
            WHEN CUTOFF_NOT_REACHED
            THEN
                    null;
               dbms_output.put_line('cut off time not reached');

            WHEN OTHERS
            THEN
               dbms_output.put_line('Others issue');
               dbms_output.put_line(SQLCODE || SQLERRM || dbms_utility.format_error_backtrace);

                ROLLBACK;
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
               COMMIT;
        END;
        COMMIT;
    END LOOP; -- closing of cursor institution loop
    DELETE FROM tabledetails WHERE tdidcode = m_proc_exec_tdidcode and tdkey = m_proc_exec_tdkey;
    COMMIT;
EXCEPTION
    WHEN PROC_EXEC_WIP
    THEN
        DELETE FROM tabledetails WHERE tdidcode = m_proc_exec_tdidcode and tdkey = m_proc_exec_tdkey;
        COMMIT;
    WHEN NOT_BUSINESS_DAY
    THEN
       dbms_output.put_line(' Today is NOT BUSINESS DAY');
        DELETE FROM tabledetails WHERE tdidcode = m_proc_exec_tdidcode and tdkey = m_proc_exec_tdkey;
        COMMIT;

    WHEN NO_FILES_FOUND
    THEN
       dbms_output.put_line('No files found');
        DELETE FROM tabledetails WHERE tdidcode = m_proc_exec_tdidcode and tdkey = m_proc_exec_tdkey;
        COMMIT;
END;