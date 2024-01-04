create or replace PROCEDURE          pymt_txns_bulking
(
    p_instanceid                IN      msgdb.instanceid%TYPE,                           -- Active/Active Instance ID
    p_src_file_queueid          IN      msgdb.queueid%TYPE DEFAULT NULL,                 -- Source file queueid from where file record is being read
    p_src_file_status           IN      msgdb.status%TYPE DEFAULT 0,                     -- Source file status from where file record is being read
    p_src_file_blocktype        IN      msgblocks.msgblocktype%TYPE DEFAULT 0,           -- Source file header block type from MSGBLOCKS
    p_trgt_file_queueid         IN      msgdb.queueid%TYPE DEFAULT NULL,                 -- Target file queueid to which source file with route
    p_trgt_file_status          IN      msgdb.status%TYPE DEFAULT 0,                     -- Target file status to which source file with route
    p_src_batch_queueid         IN      msgdb.queueid%TYPE,                              -- Source batch queueid from where batch record is being read
    p_src_batch_status          IN      msgdb.status%TYPE,                               -- Source batch status from where batch record is being read
    p_src_batch_blocktype       IN      msgblocks.msgblocktype%TYPE,                     -- Source transaction header block type from MSGBLOCKS
    p_trgt_batch_queueid        IN      msgdb.queueid%TYPE,                              -- Target batch queueid from where batch record is being read
    p_trgt_batch_status         IN      msgdb.status%TYPE,                               -- Target batch status from where batch record is being read
    p_src_tran_queueid          IN      msgdb.queueid%TYPE,
    p_src_tran_status           IN      msgdb.status%TYPE,
    p_src_tran_blocktype        IN      msgblocks.msgblocktype%TYPE,                     -- Source transaction header block type from MSGBLOCKS
    p_trgt_tran_queueid         IN      msgdb.queueid%TYPE,                              -- Target transaction queueid from where transaction record is being read
    p_trgt_tran_status          IN      msgdb.status%TYPE,                               -- Target transaction status from where transaction record is being read
    p_new_bulk_file_queueid     IN      msgdb.queueid%TYPE,                              -- Queueid for newly generated file
    p_new_bulk_file_status      IN      msgdb.status%TYPE,                               -- Status for newly generated file
    p_bulk_file_type            IN      msgdb_file.mdbfl_filetype%TYPE,                  -- Message type of newly generated file
    p_generate_filename         IN      CHAR,                                            -- Switch to identify whether for new file file name needs to be generated or not default is 'N'
    p_prefix_file_name          IN      msgdb_file.mdbfl_filename%TYPE DEFAULT NULL,     -- Prefix name for New file in case above switch is set to 'Y'
    p_file_extn                 IN      msgdb_file.mdbfl_extension%TYPE,                 -- File extension for newly generated file
    p_file_messageclasstype     IN      VARCHAR2 DEFAULT 'NONE',
    p_institution_type          IN         VARCHAR2 DEFAULT 'SERVICE_AGENT',
    p_batch_messageclasstype    IN      VARCHAR2 DEFAULT 'NONE'

)
AS

    --exec pymt_txns_bulking(p_instanceid => 'PELICAN1',p_trgt_file_status => 79,p_src_batch_queueid => 'BTPROCDQ',p_src_batch_status => 69,p_src_batch_blocktype => 91,p_trgt_batch_queueid => 'BTPROCDQ',p_trgt_batch_status => 84,p_src_tran_queueid => 'SCTTXSBQ',p_src_tran_status => 69,p_src_tran_blocktype => 2,p_trgt_tran_queueid => 'PROCDQ',p_trgt_tran_status => 84,p_new_bulk_file_queueid => 'INPFILEQ',p_new_bulk_file_status => 224,p_bulk_file_type => 'SEPA-PAIN',p_generate_filename => 'Y',p_file_extn => 'XML',p_file_messageclasstype => 'pain.001.001.03',p_batch_messageclasstype => 'pain.001.001.03',p_institution_type => 'SERVICED_CORPORATE');

    resource_busy                   EXCEPTION;
    PRAGMA EXCEPTION_INIT (resource_busy, -54);

    INVALID_XML                     EXCEPTION;
    NO_BATCHES                      EXCEPTION;
    INVALID_CONFIGURATION           EXCEPTION;
    PAYMENT_ONBEHALF                EXCEPTION;
    NO_CONFIGURATION_FOUND          EXCEPTION;
    PROC_EXEC_WIP                   EXCEPTION;

    TYPE t_msgdb_file IS RECORD
    (
        msgdb_id                    msgdb.msgdb_id%TYPE,
        messagedirection            msgdb.messagedirection%TYPE,
        messageno                   msgdb.messageno%TYPE,
        messageclasstype            msgdb.messageclasstype%TYPE
    );

   TYPE t_msgdb_batch IS RECORD
    (
        msgdb_id                    msgdb.msgdb_id%TYPE,
        messageno                   msgdb.messageno%TYPE,
        institutionid               msgdb.institutionid%TYPE,
        sender                      msgdb.sender%TYPE,
        receiver                    msgdb.receiver%TYPE,
        account_number              msgdb.account_number%TYPE,
        sequence_type               msgdb.custom34%TYPE,
        local_instrument_code       msgdb.custom35%TYPE,
        banking_channel             msgdb.custom37%TYPE,
        deliver_output_to           msgdb.custom40%TYPE,
        transrefno                  msgdb.transrefno%TYPE,
        msgdb_id_org                msgdb.msgdb_id_org%TYPE,
        channel_id_source           msgdb.channel_id_source%TYPE,
        prioritydate                msgdb.prioritydate%TYPE,
        currency                    msgdb.currency%TYPE,
        messagedirection            msgdb.messagedirection%TYPE,
        msg_mode_in                 msgdb.msg_mode_in%TYPE,
        msgsegr                     msgdb.msgsegr%TYPE,
        customeraccno               msgdb.customeraccno%TYPE,
        customeraccno_enc           msgdb.customeraccno_enc%TYPE,
        instanceid                  msgdb.instanceid%TYPE,
        possible_duplicate          msgdb.possible_duplicate%TYPE,
        unload_attempt              msgdb.unload_attempt%TYPE,
        other_accno                 msgdb.other_accno%TYPE,
        other_accno_enc             msgdb.other_accno_enc%TYPE,
        derived_branch              msgdb.derived_branch%TYPE,
        derived_payment_system      msgdb.derived_payment_system%TYPE,
        derived_product             msgdb.derived_product%TYPE,
        derived_application         msgdb.derived_application%TYPE,
        priority                    msgdb.priority%TYPE,
        transactiontype             msgdb.transactiontype%TYPE,
        business_receipt_date       msgdb.business_receipt_date%TYPE,
        custom21                    msgdb.custom21%TYPE,
        other_party_details         msgdb.other_party_details%TYPE,
        other_party_details_enc     msgdb.other_party_details_enc%TYPE,
        messageno_source            msgdb.messageno_source%TYPE,
        messageclasstype            msgdb.messageclasstype%TYPE,
        msg_family                  msgdb.msg_family%TYPE,
        custom2                     msgdb.custom2%TYPE,
        custom43                    msgdb.custom43%TYPE,
        display_flag                msgdb.display_flag%TYPE,
        current_auth_level          msgdb.current_auth_level%TYPE,
        payment_duedate             msgdb.payment_duedate%TYPE,
        tenant_name                 msgdb.tenant_name%TYPE,
        groupinginfo_file           msgdb.groupinginfo_file%TYPE,
        groupinginfo_batch          msgdb.groupinginfo_batch%TYPE,
        origname                    msgdb.origname%TYPE,
        datakeyid                   msgdb.datakeyid%TYPE,
        request_type                msgdb.request_type%TYPE
    );

   TYPE t_msgdb_tran IS RECORD
    (
        msgdb_id                        MSGDB.msgdb_id%TYPE,
        messageno                       MSGDB.messageno%TYPE,
        queueid                         MSGDB.queueid%TYPE,
        priorityamount                  MSGDB.priorityamount%TYPE,
        priorityamountnum               MSGDB.priorityamountnum%TYPE,
        msgdb_id_output_batch           MSGDB.msgdb_id_output_batch%TYPE,
        message                         MSGBLOCKS.message%TYPE,
        msgsegr                         MSGDB.msgsegr%TYPE,
        receiver                        MSGDB.receiver%TYPE,
        banking_channel                 MSGDB.custom37%TYPE,
        account_number_enc              MSGDB.account_number_enc%TYPE,
        record_end_marker               MSGDB.record_end_marker%TYPE,
        deliver_output_to               MSGDB.custom40%TYPE,
        institutionid                   MSGDB.institutionid%TYPE,
        datakeyid                       MSGDB.datakeyid%TYPE
        --custom2                         MSGDB.custom2%TYPE,
        --transrefno                      MSGDB.transrefno%TYPE
    );

    TYPE a_msgdb_file                   IS TABLE OF                     t_msgdb_file;
    n_msgdb_file                        a_msgdb_file                    := a_msgdb_file();

    TYPE a_msgdb_batch                  IS TABLE OF                     t_msgdb_batch;
    n_msgdb_batch                       a_msgdb_batch                   := a_msgdb_batch();

    TYPE a_msgdb_tran                   IS TABLE OF                     t_msgdb_tran;
    n_msgdb_tran                        a_msgdb_tran                    := a_msgdb_tran();

    TYPE t_msgdb_links                   IS TABLE OF                     msgdb_links%ROWTYPE;
    msgdb_links_new                      t_msgdb_links                   := t_msgdb_links();

    TYPE a_msgdb                        IS TABLE OF                     msgdb%ROWTYPE;
    f_msgdb                             a_msgdb                         := a_msgdb();

    TYPE a_msgdb_id                     IS TABLE OF                     msgdb.msgdb_id%TYPE;
    batch_msgdb_id                      a_msgdb_id                      := a_msgdb_id();             --Batch collection variable for msgdb_id initialize
    t_msgdb_id                          a_msgdb_id                      := a_msgdb_id();            --Transaction collection variable for msgdb_id initialize
    tran_msgdb_id                       a_msgdb_id                      := a_msgdb_id();            --Transaction collection variable for msgdb_id initialize

    TYPE a_messageno                    IS TABLE OF                     msgdb.messageno%TYPE;
    b_messageno                         a_messageno                     := a_messageno();            --Batch collection variable for messageno initialize
    t_messageno                         a_messageno                     := a_messageno();           --Transaction collection variable for messageno initialize

    TYPE a_priorityamountnum            IS TABLE OF                     msgdb.priorityamountnum%TYPE;
    t_priorityamountnum                 a_priorityamountnum             := a_priorityamountnum();    --Transaction collection variable for amount initialize

    TYPE a_institutionid                IS TABLE OF                     msgdb.institutionid%TYPE;
    t_institutionid                     a_institutionid                 := a_institutionid();       --Transaction collection variable for institutionid initialize

    TYPE a_queueid                      IS TABLE OF                     msgdb.queueid%TYPE;
    b_queueid                           a_queueid                       := a_queueid();             --Batch collection variable for queueid initialize
    t_queueid                           a_queueid                       := a_queueid();                --Transaction collection variable for queueid initialize

    TYPE a_status                       IS TABLE OF                     msgdb.status%TYPE;
    b_status                            a_status                        := a_status();              --Batch collection variable for status initialize
    t_status                            a_status                        := a_status();              --Transaction collection variable for status initialize

    TYPE a_msgdb_id_batch               IS TABLE OF                     msgdb.msgdb_id_batch%TYPE;
    t_msgdb_id_batch                    a_msgdb_id_batch                := a_msgdb_id_batch();      --Transaction collection variable for batch id initialize

    TYPE a_audittext                    IS TABLE OF                     genaudit.audittext%TYPE;
    b_audittext                         a_audittext                     := a_audittext();           --Batch collection variable for audit text initialize
    t_audittext                         a_audittext                     := a_audittext();           --Transaction collection variable for audit text initialize

    TYPE a_end_hash_code                IS TABLE OF                     VARCHAR2 (4000);
    t_end_hash_code                     a_end_hash_code                 := a_end_hash_code();
    b_end_hash_code                     a_end_hash_code                 := a_end_hash_code();

    TYPE a_seq_no                       IS TABLE OF                     genaudit.sequenceno%TYPE;
    t_seq_no                            a_seq_no                        := a_seq_no();
    b_seq_no                            a_seq_no                        := a_seq_no();

    TYPE a_auditdatetime                IS TABLE OF                     genaudit.auditdatetime%TYPE;
    t_auditdatetime                     a_auditdatetime                 := a_auditdatetime();
    b_auditdatetime                     a_auditdatetime                 := a_auditdatetime();

    TYPE a_audittimestamp               IS TABLE OF                     genaudit.audittimestamp%TYPE;
    t_audittimestamp                    a_audittimestamp                := a_audittimestamp();
    b_audittimestamp                    a_audittimestamp                := a_audittimestamp();

    m_file_content                      BLOB;
    file_header                         BLOB;
    m_btl_file_content_blob             BLOB;

    m_btl_file_content                  CLOB;
    batch_content                       CLOB;                                                           --Formatted batch header
    transaction_content                 CLOB;                                                           --Formatted transaction header
    tlt_transaction_content             CLOB;                                                           --Formatted transaction header
    batch_transaction_content           CLOB;                                                           --Concatenated batch and transaction block
    file_content_to_append              CLOB;                                                           --Concatenated batch / transaction block
    m_curr_transaction                  CLOB;                                                          --Current transaction in clob
    f_message_clob                      CLOB;
    m_batch_endtag                      CLOB                                        := '</PmtInf>';
    total_transaction_content           CLOB                                        := NULL;
    l_file_header                       CLOB;
    l_file_trailer                      CLOB;

    m_btch_beg_ctr                      NUMBER                                      := 0;
    m_btch_end_ctr                      NUMBER                                      := 0;
    m_tran_beg_ctr                      NUMBER                                      := 0;
    m_tran_end_ctr                      NUMBER                                      := 0;
    m_cust_file_seq                     NUMBER                                      := 0;
    m_txn_count                         NUMBER                                      := 0;
    m_file_ctr_beg                      NUMBER                                      := 0;
    m_file_ctr_end                      NUMBER                                      := 0;
    m_total_batch_count                 NUMBER                                      := 0;                   --Count of batches in a file
    m_new_batch_count                   NUMBER                                      := 0;                   --Count of batches in a file after splitting
    m_batch_msgblocks_count             NUMBER                                      := 0;                   --Existence of batches in a msgblocks
    t_file_seqno                        NUMBER                                      := 0;
    m_file_seq                          NUMBER                                      := 0;
    m_tran_count                        NUMBER                                      := 0;
    m_total_amount                      NUMBER                                      := 0;
    m_hash                              NUMBER                                      := 0;
    m_line_cnt                          NUMBER                                      := 0;
    m_tran_file_cnt                     NUMBER                                      := 0;
    m_msgdb_id_first                    NUMBER                                      := 0;
    m_msgdb_id_last                     NUMBER                                      := 0;
    m_str_posn_tag_to_replace           NUMBER                                      := 0;
    m_msgdb_id_batch_first              NUMBER                                      := 0;
    m_msgdb_id_batch_last               NUMBER                                      := 0;
    m_file_type_cnt                     NUMBER                                      := 0;
    m_nodecount                         NUMBER                                      := 0;
    m_time_diff_in_ss                   NUMBER                                      := NULL;
    m_time_gap                          NUMBER                                      := 1;

    m_time_diff_in_hhmiss               VARCHAR2(150)                               := NULL;
    m_old_file_name_supp                VARCHAR(50)                                 := NULL;
    m_bogaddress                        VARCHAR(35);
    m_batch_amount                      VARCHAR2(100)                               := 0;                  --Total amount of all transaction
    m_counter                           VARCHAR2(100)                               := 0;
    m_old_batch_strcount                VARCHAR2(200)                               := NULL;
    m_old_batch_stramount               VARCHAR2(200)                               := NULL;
    m_new_batch_strcount                VARCHAR2(200)                               := NULL;
    m_new_batch_stramount               VARCHAR2(200)                               := NULL;
    m_next_file_gen                     VARCHAR2(2)                                 := 'Y';
    m_new_file_name                     VARCHAR2(50)                                := NULL;
    m_linking_code                      VARCHAR2(50)                                := NULL;
    m_xpath                             VARCHAR2(100)                               := NULL;
    m_xnode                             VARCHAR2(100)                               := 'PmtInf';
    m_xnode_new                         VARCHAR2(100)                               := NULL;
    m_msgid                             VARCHAR2(50)                                := NULL;
    m_received                          VARCHAR2(50)                                := NULL;
    m_secretkey                         VARCHAR2(32767)                             := NULL;
    m_cutoff_time_beg                   VARCHAR2(8)                                 := NULL;
    m_cutoff_time_end                   VARCHAR2(8)                                 := NULL;
    m_current_time                      VARCHAR2(8)                                 := NULL;
    m_extract                           VARCHAR2(100)                               := NULL;
    m_product_list                      VARCHAR2(5000)                              := NULL;
    m_currency                          VARCHAR2(10)                                := NULL;
    m_pre_currency                      VARCHAR2(10)                                := 'ZZZ';
    m_tran_amount                       VARCHAR2(100)                               := NULL;
    m_append_tran_count                 VARCHAR2(100)                               := NULL;
    m_append_amount                     VARCHAR2(100)                               := NULL;
    m_total_tran_amount                 VARCHAR2(100)                               := NULL;
    m_all_transction                    VARCHAR2(1000)                              := NULL;
    m_file_footer                       VARCHAR2(2000)                              := NULL;
    m_app_line_cnt                      VARCHAR2(100)                               := NULL;
    m_append_hash                       VARCHAR2(100)                               := NULL;
    m_append_header_flag                VARCHAR2(10)                                := 'Y';
    --m_reverse_questionmark              VARCHAR2(3)                                 := chr(191);
    m_param_to_replace                  VARCHAR2(255)                               := NULL;
    c_messageclasstype                  VARCHAR2(1000)                               := NULL;
    m_filename_from_ip                  VARCHAR2(100)                               := NULL;
    m_messageclasstype                  VARCHAR2(100)                               := NULL;
    m_escro_institution                 VARCHAR2(100)                               := NULL;
    m_col_to_replace                    VARCHAR2(255)                               := NULL;
    m_tag_to_replace                    VARCHAR2(255)                               := NULL;
    m_new_col_to_replace                VARCHAR2(255)                               := NULL;
    m_file_creation_date                VARCHAR2(20)                                := NULL;
    m_encrypt                           VARCHAR2(32664)                             := 'ENCRYPT';
    m_decrypt                           VARCHAR2(32664)                             := 'DECRYPT';
    m_context_name                      VARCHAR2(32664)                             := NULL;
    m_active_datakeyid                  VARCHAR2(32664)                             := NULL;
m_tenant_list                           VARCHAR2(32664)                             := NULL;
    m_systimestamp                      TIMESTAMP WITH TIME ZONE;                                           --Parameters for genaudit

    m_sysdate                           DATE;

    m_xtype                             XMLTYPE;
    m_bxtype                            XMLTYPE;

    m_btch_ctr                          msgdb_file.mdbfl_num_of_batches%TYPE        := 0;                   --Count of batches in a file
    m_filename                          msgdb_file.mdbfl_filename%TYPE              := NULL;
    m_filesize                          msgdb_file.mdbfl_filesize%TYPE              := NULL;
    m_cancelled_batch_count             msgdb_file.mdbfl_param1%TYPE                := NULL;               --Canceled batches
    m_processed_batch_count             msgdb_file.mdbfl_param2%TYPE                := NULL;               --Processed batches
    m_mdbfl_param4                      msgdb_file.mdbfl_param4%TYPE                := NULL;
    m_mdbfl_param5                      msgdb_file.mdbfl_param5%TYPE                := NULL;
    m_file_tran_count                   msgdb_file.mdbfl_num_of_msgs%TYPE           := 0;                   --Count of transaction in a file
    m_prefix_filename                   msgdb_file.mdbfl_filename%TYPE              := p_prefix_file_name;

    m_file_amount                       msgdb.priorityamountnum%TYPE                := 0;                  --Total amount of all transaction
    m_file_tran_amnt_old                msgdb.priorityamountnum%TYPE                := 0;                  --Total amount of all transaction
    m_batch_tran_count                  msgdb_file.mdbfl_num_of_msgs%TYPE           := 0;                  --Count of transaction in a batch
    m_org_file_id                       msgdb.msgdb_id%TYPE                         := NULL;               --Current file id
    m_curr_batch_id                     msgdb.msgdb_id%TYPE                         := NULL;               --Current batch id
    m_curr_tran_id                      msgdb.msgdb_id%TYPE                         := NULL;               --Current transaction id
    m_curr_file_msgno                   msgdb.messageno%TYPE                        := NULL;               --Current file message number
    m_curr_batch_msgno                  msgdb.messageno%TYPE                        := NULL;               --Current batch message number
    m_curr_tran_msgno                   msgdb.messageno%TYPE                        := NULL;               --Current transaction message number
    m_new_file_id                       msgdb.msgdb_id%TYPE                         := NULL;               --New file id
    m_new_file_msgno                    msgdb.messageno%TYPE                        := NULL;               --New file message number
    m_institutionid                     msgdb.institutionid%TYPE                    := NULL;
    m_institutionname                   institutionmaster.institutionname%TYPE      := NULL;                --New File institutionname for GrpHdr/InitgPty/Nm
    m_output_file_id                    msgdb.msgdb_id%TYPE                         := 0;
    m_msgdb_msgeno_file                 msgdb.messageno%TYPE                        := NULL;
    m_bulk_file_type                    msgdb_file.mdbfl_filetype%TYPE              := NULL;
    m_file_canc_queueid                 msgdb.queueid%TYPE                          := 'FLPROCDQ';
    m_canc_status                       msgdb.status%TYPE                           := 102;
    m_btch_canc_queueid                 msgdb.queueid%TYPE                          := 'BTPROCDQ';
    m_old_receiver                      msgdb.receiver%TYPE                         := 'NONE';
    m_banking_channel                   msgdb.custom37%TYPE                         := NULL;
    m_msg_family                        msgdb.msg_family%TYPE                       := NULL;
    m_record_end_marker                 msgdb.record_end_marker%TYPE                := NULL;
    m_receiver                          msgdb.receiver%TYPE                         := NULL;
    m_local_instrument_code             msgdb.custom35%TYPE                         := NULL;
    m_deliver_output_to                 msgdb.custom40%TYPE                         := NULL;
    m_file_status                       msgdb.status%TYPE                           := NULL;
    m_queueid                           msgdb.queueid%TYPE                          := NULL;
    m_date                              msgdb.inputdate%TYPE;
    m_systime                           msgdb.inputtime%TYPE;
    m_no_curr_assignd                   msgdb.currency%TYPE                         := 'XXX';
    m_file_refno                        msgdb.transrefno%TYPE                       := NULL;
    t_file_refno                        msgdb.transrefno%TYPE                       := NULL;
    m_new_file_trgt_queueid             msgdb.queueid%TYPE                          := NULL;
    m_new_file_trgt_status              msgdb.status%TYPE                           := NULL;
    m_derived_product                   msgdb.derived_product%TYPE                  := NULL;
    m_msgdb_id_batch                    msgdb.msgdb_id%TYPE                         := NULL;
    m_btch_transrefno                   msgdb.transrefno%TYPE                       := NULL;
    m_file_currency                     msgdb.currency%TYPE                         := NULL;
    m_curr_file_org_id                  msgdb.msgdb_id%TYPE                         := null;

    m_seq_tran_no                       genaudit.sequenceno%TYPE                    := NULL;
    t_audit_text                        genaudit.audittext%TYPE                     := NULL;
    m_seq_btch_no                       genaudit.sequenceno%TYPE                    := NULL;
    b_audit_text                        genaudit.audittext%TYPE                     := NULL;
    m_keyid                             genaudit.keyid%TYPE                         := NULL;
    g_queueid                           genaudit.queueid%TYPE                       := NULL;
    g_username                          genaudit.username%TYPE                      := 'ADMIN';
    g_application                       genaudit.application%TYPE                   := 'EVNTSRVR';
    g_modulename                        genaudit.modulename%TYPE                    := 'BULK';
    g_action                            genaudit.action%TYPE                        := 'MOVE';
    g_audittext                         genaudit.audittext%TYPE                     := NULL;
    g_messageno                         genaudit.messageno%TYPE                     := NULL;
    g_institutionid                     genaudit.institutionid%TYPE                 := NULL;

    m_tdidcode_msgclasstype             tabledetails.tdidcode%TYPE                  := NULL;
    m_tdidcode_fileclasstype            tabledetails.tdidcode%TYPE                  := NULL;
    m_batch_trailer                     tabledetails.tdvalue%TYPE                   := NULL;
    m_batch_trailer_tag                 tabledetails.tdvalue%TYPE                   := 'BT001';
    m_tag_trns_str                      tabledetails.tdvalue%TYPE                   := NULL;
    m_tag_trns_end                      tabledetails.tdvalue%TYPE                   := NULL;
    m_tag_amt_str                       tabledetails.tdvalue%TYPE                   := NULL;
    m_tag_amt_end                       tabledetails.tdvalue%TYPE                   := NULL;
    m_cutoff_time                       tabledetails.tdvalue%TYPE                   := NULL;
    m_route_bank                        tabledetails.tdvalue%TYPE                   := NULL;
    m_req_hold                          tabledetails.tdvalue%TYPE                   := NULL;
    m_file_msgid_path                   tabledetails.tdvalue%TYPE                   := NULL;
    m_file_ttl_txn                      tabledetails.tdvalue%TYPE                   := NULL;
    m_file_sttlmdate_path               tabledetails.tdvalue%TYPE                   := NULL;
    m_file_ttl_txn_cnt_path             tabledetails.tdvalue%TYPE                   := NULL;
    m_file_ttl_txn_amt                  tabledetails.tdvalue%TYPE                   := 'F_SUM_OF_AMT';
    m_file_type_string                  tabledetails.tdvalue%TYPE                   := NULL;
    m_current_string                    tabledetails.tdvalue%TYPE                   := NULL;
    m_current_msgclasstype              tabledetails.tdvalue%TYPE                   := NULL;
    m_current_filetype                  tabledetails.tdvalue%TYPE                   := NULL;
    m_set_bat_channel_as_null           tabledetails.tdvalue%TYPE                   := NULL;
    m_set_txn_channel_as_null           tabledetails.tdvalue%TYPE                   := NULL;
    m_no_batch_required                 tabledetails.tdvalue%TYPE                   := NULL;  --Check if batch creation is optional
    m_file_msg_id                       tabledetails.tdkey%TYPE                     := 'F_MSG_ID';
    m_file_ttl_txn_cnt                  tabledetails.tdkey%TYPE                     := 'F_NO_OF_TXN';
    m_file_sttlmdate                    tabledetails.tdkey%TYPE                     := 'F_STTLM_DATE';
    m_file_ttl_txn_amt_path             tabledetails.tdkey%TYPE                     := NULL;
    m_bic_code                            tabledetails.tdkey%TYPE                       := NULL;
    m_proc_exec_tdidcode                TABLEDETAILS.tdidcode%TYPE                  := 'TRACK_PROC_EXEC';
    m_proc_exec_tdkey                   TABLEDETAILS.tdkey%TYPE                     := '350';
    m_proc_exec_time                    TABLEDETAILS.tdvalue%TYPE                   := NULL;

    m_mdbfl_filetype                    msgdb_file.mdbfl_filetype%TYPE              := NULL;
    m_filetype                          msgdb_file.mdbfl_filetype%TYPE              := NULL;
    m_filetype_org                      msgdb_file.mdbfl_filetype%TYPE              := NULL;

    m_treasury_center                   institutionparameters.institutionid%TYPE    := NULL;
    m_payment_onbehalf                  institutionparameters.paramvalue%TYPE       := NULL;
    m_path                                institutionparameters.path%TYPE               := NULL;
    m_request_type                        institutionparameters.paramname%TYPE        := NULL;
    m_auth_user_dn                        institutionparameters.paramname%TYPE        := NULL;
    m_requestor_dn                        institutionparameters.paramname%TYPE        := NULL;
    m_responder_dn                        institutionparameters.paramname%TYPE        := NULL;
    m_service_name                        institutionparameters.paramname%TYPE        := NULL;
    m_file_mode                            institutionparameters.paramname%TYPE        := NULL;
    m_ack_responder_dn                    institutionparameters.paramname%TYPE        := NULL;
    m_delivery_notif_q                    institutionparameters.paramname%TYPE        := NULL;
    m_ack_request_type                    institutionparameters.paramname%TYPE        := NULL;
    m_nr_flag                            institutionparameters.paramname%TYPE        := NULL;
    m_positive_delivery_notification    institutionparameters.paramname%TYPE        := NULL;

    m_tran_group                        messagetype.transactiongroup%TYPE           := NULL;
    m_separator                         NUMBER                                  := 0;
    m_reverse_questionmark              VARCHAR2(30)                            := chr(49855);
    m_settlement_method                 VARCHAR2(100)                           := NULL;
    m_tenant_name                       VARCHAR2(100)                           := NULL;
    m_inst_paramvalue                       VARCHAR2(10)                           := NULL;
    m_tenantname                    INSTITUTIONPARAMETERS.PARAMVALUE%TYPE               := NULL;



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


--Cursor to fetch file records
    CURSOR cur_file_records
    (
    c_institutionid     IN msgdb.institutionid%TYPE,
    c_messageclasstype  IN msgdb.messageclasstype%TYPE
    )
    IS
    SELECT  msgdb_id,
            messagedirection,
            messageno,
            messageclasstype
    FROM    msgdb
    WHERE   --instanceid          = p_instanceid
       queueid             = p_src_file_queueid
    AND     status              = p_src_file_status
    AND     messageclasstype    IN (SELECT para_code messageclasstype FROM TABLE(get_code_from_list((c_messageclasstype),'|')))
    AND     institutionid       IN (SELECT institutionid from INSTITUTIONPARAMETERS where paramname = 'PARENT_ID' AND paramvalue = c_institutionid)
    ORDER
    BY         msgdb_id;

--Cursor to fetch records of batch
    CURSOR cur_batch_records1
    (
    c_institutionid         msgdb.institutionid%TYPE,
    c_msgdb_id_org          msgdb.msgdb_id_org%TYPE,
    cur_messageclasstype    msgdb.messageclasstype%TYPE,
    c_messagedirection      msgdb.messagedirection%TYPE
    )
    IS
    SELECT  msgdb_id, messageno, institutionid, sender, receiver,
            account_number,
            custom34 AS sequence_type,
            custom35 AS local_instrument_code,
            custom37 AS banking_channel, custom40 AS deliver_output_to, transrefno, msgdb_id_org, channel_id_source,
            prioritydate, currency, messagedirection, msg_mode_in, msgsegr,
            customeraccno,customeraccno_enc,
            instanceid,
            possible_duplicate,
            unload_attempt,
            other_accno,other_accno_enc,
            derived_branch,
            derived_payment_system,
            derived_product,
            derived_application,
            priority,
            transactiontype,
            business_receipt_date,
            custom21,
            other_party_details,other_party_details_enc,
            messageno_source,
            messageclasstype,
            msg_family,
            custom2,
            custom43, display_flag, current_auth_level, payment_duedate,
            tenant_name,
            groupinginfo_file,
            groupinginfo_batch,origname,datakeyid,
            request_type
    FROM    MSGDB
    WHERE   institutionid   = c_institutionid
    --AND     get_institution_param_value(c_institutionid,'INSTITUTION_DETAILS','CUSTOMER_TYPE') = 'SERVICE_AGENT'
    --AND     NVL(get_tenantname(c_institutionid),'X') = p_tenant_name
    AND     queueid             = p_src_batch_queueid
    AND     status              = p_src_batch_status
    AND     messageclasstype    IN (SELECT para_code messageclasstype FROM TABLE(get_code_from_list((cur_messageclasstype),'|')))

    ORDER
    BY      msgdb_id;

     CURSOR cur_batch_records2
    (
    c_institutionid         msgdb.institutionid%TYPE,
    c_msgdb_id_org          msgdb.msgdb_id_org%TYPE,
    cur_messageclasstype    msgdb.messageclasstype%TYPE,
    c_messagedirection      msgdb.messagedirection%TYPE
    )
    IS
    SELECT  msgdb_id, messageno, institutionid, sender, receiver,
            account_number,
            custom34 AS sequence_type,
            custom35 AS local_instrument_code,
            custom37 AS banking_channel, custom40 AS deliver_output_to, transrefno, msgdb_id_org, channel_id_source,
            prioritydate, currency, messagedirection, msg_mode_in, msgsegr,
            customeraccno,customeraccno_enc,
            instanceid,
            possible_duplicate,
            unload_attempt,
            other_accno,other_accno_enc,
            derived_branch,
            derived_payment_system,
            derived_product,
            derived_application,
            priority,
            transactiontype,
            business_receipt_date,
            custom21,
            other_party_details,other_party_details_enc,
            messageno_source,
            messageclasstype,
            msg_family,
            custom2,
            custom43, display_flag, current_auth_level, payment_duedate,
            tenant_name,
            groupinginfo_file,
            groupinginfo_batch,origname,datakeyid,
            request_type
    FROM    MSGDB
    WHERE   institutionid   IN
                            ( SELECT institutionid
                              FROM institutionparameters
                              WHERE  UPPER(paramname)     = 'PARENT_ID'
                              AND paramvalue = c_institutionid
                              UNION SELECT c_institutionid FROM DUAL)
    AND     get_institution_param_value(c_institutionid,'INSTITUTION_DETAILS','CUSTOMER_TYPE') = 'SERVICE_AGENT'
    --AND     NVL(get_tenantname(c_institutionid),'X') = p_tenant_name
    AND     queueid             = p_src_batch_queueid
    AND     status              = p_src_batch_status
    AND     messageclasstype    IN (SELECT para_code messageclasstype FROM TABLE(get_code_from_list((cur_messageclasstype),'|')))

    ORDER
    BY      msgdb_id;

--Cursor to fetch records of transactions
    CURSOR cur_transaction_records
    (
      c_msgdb_id_batch  msgdb.msgdb_id_batch%TYPE
    )
    IS
    SELECT  t.msgdb_id,
            t.messageno,
            t.queueid,
            t.priorityamount,
            t.priorityamountnum,
            t.msgdb_id_output_batch msgdb_id_batch,
            x.message,
            t.msgsegr,
            t.receiver,
            t.custom37 AS banking_channel,
            t.account_number_enc,
            t.record_end_marker,
            t.custom40 AS deliver_output_to,
            t.institutionid,
            t.datakeyid
    FROM    MSGDB t,
            MSGBLOCKS x
    WHERE   x.msgdb_id                  = t.msgdb_id
    AND     x.msgblocktype              = p_src_tran_blocktype
    AND     t.msgdb_id_output_batch     = c_msgdb_id_batch
    AND     t.queueid                   = p_src_tran_queueid
    AND     t.status                    = p_src_tran_status
    ORDER
    BY      groupinginfo_file,
            groupinginfo_batch,
            t.msgdb_id;

BEGIN -- First BEGIN block START
    --Active-active implementation
    /*BEGIN
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
*/
    BEGIN
        SELECT TO_NUMBER(LTRIM(RTRIM(tdvalue)))
        INTO m_separator
        FROM TABLEDETAILS
        WHERE tdidcode = 'GLOBVAR'
        AND tdkey    = 'TEXT_SEPARATOR';

        m_reverse_questionmark := CHR(m_separator);

    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN m_reverse_questionmark := CHR(191);
    END;

    getkeyidandsecretkey (m_keyid, m_secretkey);

    m_mdbfl_filetype     := p_bulk_file_type;

    m_tdidcode_msgclasstype :=  CASE WHEN UPPER (SUBSTR (p_batch_messageclasstype, 1, 8))   = 'PACS.001'
                                     THEN 'PACS001'
                                     WHEN UPPER (p_batch_messageclasstype)   = 'PACS.008.001.08'
                                     THEN 'PACS008N'
                                     WHEN UPPER (p_batch_messageclasstype)   = 'CAMT.029.001.09'
                                     THEN 'CAMT029N'
                                     WHEN UPPER (p_batch_messageclasstype)   = 'PACS.004.001.09'
                                     THEN 'PACS004N'
                                     WHEN UPPER (p_batch_messageclasstype)   = 'CAMT.056.001.08'
                                     THEN 'CAMT056N'
                                     WHEN UPPER (p_batch_messageclasstype)   = 'PACS.003.001.08'
                                     THEN 'PACS003N'
                                     WHEN UPPER (p_batch_messageclasstype)   = 'PACS.007.001.09'
                                     THEN 'PACS007N'
                                     WHEN UPPER (SUBSTR (p_batch_messageclasstype, 1, 8))   = 'PACS.003'
                                     THEN 'PACS003'
                                     WHEN UPPER (SUBSTR (p_batch_messageclasstype, 1, 8))   = 'PACS.004'
                                     THEN 'PACS004'
                                     WHEN UPPER (SUBSTR (p_batch_messageclasstype, 1, 8))   = 'PACS.007'
                                     THEN 'PACS007'
                                     WHEN UPPER (SUBSTR (p_batch_messageclasstype, 1, 8))   = 'CAMT.056'
                                     THEN 'CAMT056'
                                     WHEN UPPER (SUBSTR (p_batch_messageclasstype, 1, 8))   = 'CAMT.029'
                                     THEN 'CAMT029'
                                     ELSE UPPER (p_batch_messageclasstype)
                                     END;

    dbms_output.put_line('m_tdidcode_msgclasstype : '||m_tdidcode_msgclasstype);

    m_no_batch_required     := NVL(td_get_value(m_tdidcode_msgclasstype, 'F_BATCH_REQUIRED'),'N');
    m_active_datakeyid      := sys_context(m_context_name,'ACTIVE_DATAKEYID');

    dbms_output.put_line('m_no_batch_required: ' || m_no_batch_required);

    IF m_tdidcode_msgclasstype NOT IN ('PACS001','PACS008','PACS008N','PACS003','PACS004','PACS007','CAMT056','CAMT029','CAMT029N','CAMT056N','PACS004N','PACS003N','PACS007N')
    THEN
        BEGIN
            SELECT  REPLACE(tdkey,'EXTRACT','')
            INTO    m_tdidcode_msgclasstype
            FROM    tabledetails
            WHERE   tdidcode = 'PAYEXTRACT'
            AND     tdvalue     =  p_batch_messageclasstype;

            dbms_output.put_line('m_tdidcode_msgclasstype inside if: ' || m_tdidcode_msgclasstype);

            m_tag_trns_str          := td_get_value(m_tdidcode_msgclasstype, 'NO_OF_TRNX_STRT');
            m_tag_trns_end          := td_get_value(m_tdidcode_msgclasstype, 'NO_OF_TRNX_END');
            m_tag_amt_str           := td_get_value(m_tdidcode_msgclasstype, 'AMOUNT_STRT');
            m_tag_amt_end           := td_get_value(m_tdidcode_msgclasstype, 'AMOUNT_END');

            IF  m_tag_trns_str IS NULL OR
                m_tag_trns_end IS NULL OR
                m_tag_amt_str  IS NULL OR
                m_tag_amt_end  IS NULL
            THEN
                RAISE NO_CONFIGURATION_FOUND;
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                RAISE NO_CONFIGURATION_FOUND;
        END;
    END IF;

    m_linking_code :=   (CASE m_tdidcode_msgclasstype
                        WHEN 'PACS.001'    THEN 'CINF'
                        WHEN 'PACS.008'    THEN 'OFCF'
                        WHEN 'PACS.004'    THEN 'IPRF'
                        WHEN 'PACS.002'    THEN 'SPSF'
                        WHEN 'PACS.003'    THEN 'PEND'
                        WHEN 'PACS.007'    THEN '???'
                        ELSE 'CINF'
                        END);

    m_set_txn_channel_as_null   := NVL(td_get_value('FILE-BULK-PROC','SET-TXN-CHANNEL-AS-NULL'),'YES');
    m_set_bat_channel_as_null   := NVL(td_get_value('FILE-BULK-PROC','SET-BAT-CHANNEL-AS-NULL'),'YES');
    m_file_creation_date        := TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS');



         DBMS_OUTPUT.put_line('-----------------------------TENANT_NAME-----------------------------'||m_Tenant_name );

            FOR rec IN cursor_institution
            LOOP
                BEGIN
                     m_inst_paramvalue:= NVL(Get_Institution_Param_Value(rec.institutionid,'INSTITUTION_DETAILS','PARENT_BULKING'),'N');

                    m_institutionid := rec.institutionid;
                    --DBMS_OUTPUT.PUT_LINE('-----------------------------m_instituionid-----------------------------' || m_institutionid);

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
                        --DBMS_OUTPUT.PUT_LINE('m_context_name -->'||m_context_name);

              EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN

                       DBMS_OUTPUT.PUT_LINE ('No CONTEXT found ');
             END;

                 m_active_datakeyid      := sys_context(m_context_name,'ACTIVE_DATAKEYID');

            m_next_file_gen := 'Y';

            IF p_src_file_queueid IS NOT NULL
            THEN
                OPEN cur_file_records(m_institutionid, m_messageclasstype);
                FETCH cur_file_records BULK COLLECT INTO n_msgdb_file;

                m_file_ctr_beg := NVL(n_msgdb_file.FIRST,0);
                m_file_ctr_end := NVL(n_msgdb_file.LAST,0);
            ELSE
                m_file_ctr_beg := 1;
                m_file_ctr_end := 1;
            dbms_output.put_line(' m_file_ctr_end ' ||m_file_ctr_end);
            END IF;

            FOR m_file_ctr IN m_file_ctr_beg..m_file_ctr_end
            LOOP -- Loop for File records START
                tran_msgdb_id := a_msgdb_id();

                DBMS_LOB.createtemporary (batch_transaction_content, TRUE);
                DBMS_LOB.createtemporary (m_btl_file_content_blob, TRUE);
                DBMS_LOB.createtemporary (m_btl_file_content,TRUE);
                DBMS_LOB.createtemporary (file_header, TRUE);
                DBMS_LOB.createtemporary (m_file_content, TRUE);
                DBMS_LOB.createtemporary (total_transaction_content,TRUE);

                BEGIN -- Second File record BEGIN block START
                    IF  p_src_file_queueid IS NULL OR
                        UPPER(m_payment_onbehalf) = 'Y' OR
                        UPPER(m_payment_onbehalf) = 'YES' OR
                        n_msgdb_file(m_file_ctr).messagedirection = 'I'
                    THEN
                        DBMS_LOB.createtemporary (tlt_transaction_content, TRUE);
                    ELSE
                        g_messageno := n_msgdb_file(m_file_ctr).messageno;
                    END IF;

                    --Open cursor to fetch batch records
                    IF p_src_file_queueid IS NULL
                    THEN
                        dbms_output.put_line(' m_institutionid ' ||m_institutionid);
                        dbms_output.put_line(' p_batch_messageclasstype ' ||p_batch_messageclasstype);
                        dbms_output.put_line(' p_src_batch_queueid ' ||p_src_batch_queueid);
                        dbms_output.put_line(' p_src_batch_STATUS ' ||p_src_batch_STATUS);
                        --dbms_output.put_line(' p_tenant_name ' ||p_tenant_name);
                                    IF m_inst_paramvalue = 'N'
                                    THEN
                                        OPEN cur_batch_records1 (m_institutionid, 0,p_batch_messageclasstype,NULL);
                                        FETCH cur_batch_records1 BULK COLLECT INTO n_msgdb_batch;
                                    ELSIF m_inst_paramvalue = 'Y'
                                    THEN
                                        OPEN cur_batch_records2 (m_institutionid, 0,p_batch_messageclasstype,NULL);
                                        FETCH cur_batch_records2 BULK COLLECT INTO n_msgdb_batch;
                                    END IF;
                            ELSE
                                        IF m_inst_paramvalue = 'N'
                                        THEN
                                            OPEN cur_batch_records1 (m_institutionid, n_msgdb_file(m_file_ctr).msgdb_id,p_batch_messageclasstype,n_msgdb_file(m_file_ctr).messagedirection);
                                            FETCH cur_batch_records1 BULK COLLECT INTO n_msgdb_batch;

                                        ELSIF m_inst_paramvalue = 'Y'
                                        THEN
                                            OPEN cur_batch_records2 (m_institutionid, n_msgdb_file(m_file_ctr).msgdb_id,p_batch_messageclasstype,n_msgdb_file(m_file_ctr).messagedirection);
                                            FETCH cur_batch_records2 BULK COLLECT INTO n_msgdb_batch;

                                        END IF;
                            END IF;

                            --FETCH cur_batch_records BULK COLLECT INTO n_msgdb_batch;

                    m_btch_beg_ctr := NVL (n_msgdb_batch.FIRST, 0);            --Setting begin counter for transaction
                    m_btch_end_ctr := NVL (n_msgdb_batch.LAST, 0);                --Setting end counter for transaction

                    DBMS_LOB.createtemporary (batch_transaction_content, TRUE);
                    dbms_output.put_line ('m_btch_end_ctr  =>' || m_btch_end_ctr);

                            IF m_btch_end_ctr <= 0
                            THEN
                                IF cur_batch_records1%ISOPEN
                                THEN
                                     CLOSE cur_batch_records1;
                                     RAISE NO_BATCHES;
                                ELSIF cur_batch_records2%ISOPEN
                                THEN
                                   CLOSE cur_batch_records2;
                                   RAISE NO_BATCHES;
                                END IF;


                            END IF;

                    FOR i IN m_btch_beg_ctr..m_btch_end_ctr
                    LOOP -- Loop for batches START
                        BEGIN -- Third Batch records BEGIN block START

                            dbms_output.put_line ('--------------------m_institutionid--------------------' || m_institutionid);

                            m_treasury_center   := NVL(get_institution_param_value(p_institutionid => rec.institutionid,p_path => 'INSTITUTION_DETAILS',p_paramname => 'PARENT_ID'),'X');
                            m_escro_institution := NVL(get_institution_param_value(p_institutionid => m_institutionid,p_path => 'INSTITUTION_DETAILS',p_paramname => 'ESCROW_INSTITUTION'),m_treasury_center);
                            m_product_list      := get_institution_param_value(p_institutionid => m_treasury_center,p_path => 'PROCESSING_STAGES.CHECK_AND_RELEASE',p_paramname => 'PRODUCTS');
                            m_payment_onbehalf  := NVL(get_institution_param_value(p_institutionid => m_treasury_center,p_path => 'INSTITUTION_DETAILS.PAYMENTS_ON_BEHALF', p_paramname => 'TRANSACTION_BANKING'),'X');

                            dbms_output.put_line ('m_treasury_center ==>' || m_treasury_center);
                            dbms_output.put_line ('m_escro_institution ==>' || m_escro_institution);
                            dbms_output.put_line ('m_product_list ==>' || m_product_list);
                            dbms_output.put_line ('m_payment_onbehalf ==>' || m_payment_onbehalf);


                            m_batch_tran_count  := 0;
                            m_batch_amount      := 0;

                            m_org_file_id := NVL(n_msgdb_batch(i).msgdb_id_org,0);
                            dbms_output.put_line('m_org_file_id' || m_org_file_id);

                            IF m_org_file_id > 0 AND p_src_file_queueid IS NULL
                            THEN
                                dbms_output.put_line('m_org_file_id' || m_org_file_id);
                                dbms_output.put_line('p_src_batch_blocktype' || p_src_batch_blocktype);
                                f_message_clob  := encrypt_decrypt_basedon_session_cntx_clob(m_decrypt,n_msgdb_batch(i).institutionid,blob_to_clob(m_org_file_id, p_src_batch_blocktype));
                                file_header     := clob_to_blob(f_message_clob);

                                SELECT  derived_product,
                                        priorityamountnum,
                                        messageno,
                                        institutionid,
                                        msg_family,
                                        transrefno,
                                        custom45
                                INTO    m_derived_product,
                                        m_file_tran_amnt_old,
                                        m_curr_file_msgno,
                                        m_institutionid,
                                        m_msg_family,
                                        m_file_refno,
                                        m_cust_file_seq
                                FROM    msgdb
                                WHERE   msgdb_id = m_org_file_id;

                                SELECT  NVL (mdbfl_num_of_batches, 0),
                                        NVL (mdbfl_custnum1, 0),
                                        NVL (mdbfl_custnum2, 0),
                                        NVL (mdbfl_custnum3, 0),
                                        NVL (mdbfl_filetype, 0)
                                INTO    m_total_batch_count,
                                        m_cancelled_batch_count,
                                        m_processed_batch_count,
                                        m_new_batch_count,
                                        m_filetype_org
                                FROM    msgdb_file
                                WHERE   msgdb_id = m_org_file_id;

                                IF m_file_refno IS NULL
                                THEN
                                    SELECT  getstringitemwithsep (mdbfl_filename, 4, '.')
                                    INTO    m_file_refno
                                    FROM    msgdb_file
                                    WHERE   msgdb_id = m_org_file_id;

                                    dbms_output.put_line ('File RefNo IF NULL=>' || m_file_refno);
                                END IF;
                            END IF;

                            DBMS_LOB.createtemporary (m_btl_file_content,TRUE);

                            IF UPPER(m_payment_onbehalf) = 'N'
                            THEN
                                  m_batch_tran_count    := 0;
                                  DBMS_LOB.createtemporary (total_transaction_content,TRUE);
                            ELSE
                                  m_batch_amount         := 0;
                            END IF;

                            IF p_src_file_queueid IS NOT NULL AND m_append_header_flag = 'Y'
                            THEN
                                 f_message_clob         := encrypt_decrypt_basedon_session_cntx(m_encrypt,n_msgdb_batch(i).institutionid,blob_to_clob(m_org_file_id, p_src_file_blocktype));
                                 DBMS_LOB.append (m_btl_file_content, f_message_clob||CHR(13)||CHR(10));
                                 m_append_header_flag     := 'N';
                            END IF;

                            m_msgdb_id_batch        := n_msgdb_batch(i).msgdb_id;
                            m_receiver              := n_msgdb_batch(i).receiver;
                            m_banking_channel       := n_msgdb_batch(i).banking_channel;
                            m_deliver_output_to     := n_msgdb_batch(i).deliver_output_to;
                            m_local_instrument_code := n_msgdb_batch(i).local_instrument_code;
                            m_btch_transrefno       := n_msgdb_batch(i).transrefno;


                            dbms_output.put_line ('Batch ID: '|| n_msgdb_batch (i).msgdb_id);
                            dbms_output.put_line ('m_banking_channel : '|| m_banking_channel);

                            g_messageno         := n_msgdb_batch (i).messageno;
                            g_institutionid     := n_msgdb_batch (i).institutionid;

                            IF m_next_file_gen = 'Y'
                            THEN
                                DBMS_LOB.createtemporary (batch_transaction_content, TRUE);
                                DBMS_LOB.createtemporary (m_file_content, TRUE);
                                dbms_output.put_line('here');
                            END IF;

                            --Generating new file record in msgdb
                            IF m_next_file_gen = 'Y'
                            THEN
                                m_cutoff_time       := td_get_value ('EQUENS-CHNLTIME', m_banking_channel);
                                m_cutoff_time_beg   := getstringitemwithsep (m_cutoff_time, 1, '|');
                                m_cutoff_time_end   := getstringitemwithsep (m_cutoff_time, 2, '|');
                                m_current_time      := TO_CHAR (SYSDATE, 'HH24:MI:SS');
                                m_next_file_gen     := 'N';

                                 dbms_output.put_line ('m_current_time    : ' || m_current_time);
                                 dbms_output.put_line ('m_cutoff_time     : ' || m_cutoff_time);

                                BEGIN -- Fourth Batch records BEGIN block START
                                    m_cutoff_time_beg   := TO_CHAR (TO_DATE (m_cutoff_time_beg, 'HH24:MI:SS'),'HH24:MI:SS');
                                EXCEPTION
                                     WHEN OTHERS
                                     THEN
                                        m_cutoff_time_beg := '080000';
                                END;    -- Fourth Batch records BEGIN block END

                                -- dbms_output.put_line ('m_cutoff_time_beg : '|| m_cutoff_time_beg     );

                                BEGIN -- Fifth Batch records BEGIN block START
                                     m_cutoff_time_end := TO_CHAR (TO_DATE (m_cutoff_time_end, 'HH24:MI:SS'),'HH24:MI:SS' );
                                EXCEPTION
                                     WHEN OTHERS
                                     THEN
                                        m_cutoff_time_end := '235959';
                                END; -- Fifth Batch records BEGIN block END

                                -- dbms_output.put_line ('m_cutoff_time_end : '|| m_cutoff_time_end );

                                m_req_hold := td_get_value('HOLD_FUN', 'REQUIERED');

                                IF m_req_hold = 'YES'
                                THEN
                                    IF TO_CHAR (SYSDATE, 'YYYYMMDD') = TO_CHAR (get_next_business_date (SYSDATE, 'TARGET2'),'YYYYMMDD')
                                    THEN
                                        IF m_current_time >= m_cutoff_time_beg AND m_current_time <= m_cutoff_time_end
                                        THEN
                                            m_new_file_trgt_queueid := p_new_bulk_file_queueid;
                                            m_new_file_trgt_status     := p_new_bulk_file_status;
                                        ELSE
                                            dbms_output.put_line ('File is moved to HOLDFLQ Queue');
                                            m_new_file_trgt_queueid := 'HOLDFLQ';
                                            m_new_file_trgt_status     := 69;
                                        END IF;
                                    ELSE
                                        dbms_output.put_line ('File is moved to HOLDFLQ Queue');
                                        m_new_file_trgt_queueid := 'HOLDFLQ';
                                        m_new_file_trgt_status := 69;
                                    END IF;
                                ELSE
                                    m_new_file_trgt_queueid := p_new_bulk_file_queueid;
                                    m_new_file_trgt_status := p_new_bulk_file_status;
                                END IF;

                                --Generate file id MSGDB_ID
                                SELECT  msgdb_seq.NEXTVAL
                                INTO    m_output_file_id
                                FROM    DUAL;

                                --Generate file MessageNo.
                                SELECT  'F'|| LPAD(LTRIM (TO_CHAR (msgdb_messageno_fileq_seq.NEXTVAL)),11,'0')
                                INTO    m_msgdb_msgeno_file
                                FROM    DUAL;

                                dbms_output.put_line ('New file ID=>' || m_output_file_id);

                                m_systimestamp     := TO_TIMESTAMP (TO_CHAR (SYSDATE, 'YYYYMMDDHH24MISS'),'YYYYMMDDHH24MISS');
                                m_sysdate         := SYSDATE;

                                f_msgdb                                         := a_msgdb ();
                                f_msgdb.EXTEND;
                                f_msgdb(f_msgdb.LAST).msgdb_id                  := m_output_file_id;
                                f_msgdb(f_msgdb.LAST).queueid                   := m_new_file_trgt_queueid;
                                f_msgdb(f_msgdb.LAST).status                    := m_new_file_trgt_status;
                                f_msgdb(f_msgdb.LAST).processing_stage          := get_queue_stage (m_treasury_center, m_new_file_trgt_queueid);
                                f_msgdb(f_msgdb.LAST).transactiongroup          := get_trnx_group (p_batch_messageclasstype, 0);
                                f_msgdb(f_msgdb.LAST).inputdatetime             := m_systimestamp;
                                f_msgdb(f_msgdb.LAST).currqueueindatetime       := m_systimestamp;
                                f_msgdb(f_msgdb.LAST).usr_action_timestamp      := m_systimestamp;
                                f_msgdb(f_msgdb.LAST).messageno                 := m_msgdb_msgeno_file;
                                f_msgdb(f_msgdb.LAST).messageclasstype          := p_batch_messageclasstype;
                                f_msgdb(f_msgdb.LAST).inputdate                 := TO_CHAR (m_sysdate, 'YYYYMMDD');
                                f_msgdb(f_msgdb.LAST).inputtime                 := TO_CHAR (m_sysdate, 'HH24MISS');
                                f_msgdb(f_msgdb.LAST).currqueueindate           := TO_CHAR (m_sysdate, 'YYYYMMDD');
                                f_msgdb(f_msgdb.LAST).currqueueintime           := TO_CHAR (m_sysdate, 'HH24MISS');
                                f_msgdb(f_msgdb.LAST).prioritydate              := n_msgdb_batch(i).prioritydate;
                                f_msgdb(f_msgdb.LAST).currency                  := n_msgdb_batch(i).currency;
                                f_msgdb(f_msgdb.LAST).localcurrencyamountnum    := 0;
                                f_msgdb(f_msgdb.LAST).lockstatus                := 0;
                                f_msgdb(f_msgdb.LAST).printflag                 := 0;
                                f_msgdb(f_msgdb.LAST).msgattribute              := 0;

                                IF n_msgdb_batch (i).messagedirection = 'I' AND INSTR(n_msgdb_batch (i).messageclasstype,'pacs') > 0
                                THEN
                                    f_msgdb (f_msgdb.LAST).msg_mode_in          := 'FILE';
                                ELSE
                                    f_msgdb (f_msgdb.LAST).msg_mode_in          := n_msgdb_batch(i).msg_mode_in;
                                END IF;

                                f_msgdb(f_msgdb.LAST).institutionid             := m_institutionid;
                                f_msgdb(f_msgdb.LAST).messagedirection          := n_msgdb_batch(i).messagedirection;
                                f_msgdb(f_msgdb.LAST).CATEGORY                  := 0;
                                f_msgdb(f_msgdb.LAST).returncode                := -1;
                                f_msgdb(f_msgdb.LAST).batch                     := 0;
                                f_msgdb(f_msgdb.LAST).msgsegr                   := n_msgdb_batch(i).msgsegr;
                                f_msgdb(f_msgdb.LAST).custom20                  := 0;
                                f_msgdb(f_msgdb.LAST).custom22                  := 0;
                                f_msgdb(f_msgdb.LAST).custom45                  := 0;
                                f_msgdb(f_msgdb.LAST).custom46                  := 0;
                                f_msgdb(f_msgdb.LAST).custom47                  := 0;
                                f_msgdb(f_msgdb.LAST).taskid                    := 0;
                                f_msgdb(f_msgdb.LAST).max_attempts              := 0;
                                f_msgdb(f_msgdb.LAST).attempts_made             := 0;
                                f_msgdb(f_msgdb.LAST).record_type               := 0;
                                f_msgdb(f_msgdb.LAST).swiftnetattributes        := 0;
                                f_msgdb(f_msgdb.LAST).customeraccno             := n_msgdb_batch(i).customeraccno;
                                f_msgdb(f_msgdb.LAST).customeraccno_enc         := n_msgdb_batch(i).customeraccno_enc;
                                f_msgdb(f_msgdb.LAST).prevstatus                := 0;
                                f_msgdb(f_msgdb.LAST).msgdb_id_org              := n_msgdb_batch(i).msgdb_id_org;
                                f_msgdb(f_msgdb.LAST).output_count              := 1;
                                f_msgdb(f_msgdb.LAST).msgdb_id_source           := n_msgdb_batch(i).msgdb_id_org;
                                f_msgdb(f_msgdb.LAST).msgdb_id_target           := 0;
                                f_msgdb(f_msgdb.LAST).msgdb_id_batch            := 0;
                                f_msgdb(f_msgdb.LAST).record_group_type         := 'F';
                                f_msgdb(f_msgdb.LAST).controlflag               := 0;
                                f_msgdb(f_msgdb.LAST).instanceid                := p_instanceid;
                                f_msgdb(f_msgdb.LAST).possible_duplicate        := n_msgdb_batch(i).possible_duplicate;
                                f_msgdb(f_msgdb.LAST).ack_status                := 0;
                                f_msgdb(f_msgdb.LAST).resubmit_status           := 0;
                                f_msgdb(f_msgdb.LAST).resend_count              := 0;
                                f_msgdb(f_msgdb.LAST).unload_attempt            := n_msgdb_batch(i).unload_attempt;
                                f_msgdb(f_msgdb.LAST).other_accno               := n_msgdb_batch(i).other_accno;
                                f_msgdb(f_msgdb.LAST).other_accno_enc           := n_msgdb_batch(i).other_accno_enc;
                                f_msgdb(f_msgdb.LAST).derived_branch            := n_msgdb_batch(i).derived_branch;
                                f_msgdb(f_msgdb.LAST).derived_payment_system    := n_msgdb_batch(i).derived_payment_system;

                                IF n_msgdb_batch(i).messagedirection = 'I'
                                THEN
                                    f_msgdb (f_msgdb.LAST).derived_product      := 'NOTAPPLICABLE';
                                ELSIF INSTR (n_msgdb_batch(i).derived_product, 'BTL') = 0
                                THEN
                                    f_msgdb (f_msgdb.LAST).derived_product      := n_msgdb_batch(i).derived_product;
                                END IF;

                                f_msgdb(f_msgdb.LAST).derived_application       := n_msgdb_batch(i).derived_application;
                                f_msgdb(f_msgdb.LAST).priority                  := n_msgdb_batch(i).priority;
                                f_msgdb(f_msgdb.LAST).transactiontype           := n_msgdb_batch(i).transactiontype;
                                f_msgdb(f_msgdb.LAST).business_receipt_date     := n_msgdb_batch(i).business_receipt_date;
                                f_msgdb(f_msgdb.LAST).custom21                  := n_msgdb_batch(i).custom21;
                                f_msgdb(f_msgdb.LAST).other_party_details       := n_msgdb_batch(i).other_party_details;
                                f_msgdb(f_msgdb.LAST).other_party_details_enc   := n_msgdb_batch(i).other_party_details_enc;
                                f_msgdb(f_msgdb.LAST).channel_id_source         := n_msgdb_batch(i).channel_id_source;
                                SELECT DECODE(m_org_file_id,0,NULL,'PREV=' || m_org_file_id || '|' || 'ORFL' || CHR (191))
                                INTO f_msgdb(f_msgdb.LAST).custom5
                                FROM DUAL;
                                --f_msgdb(f_msgdb.LAST).custom5                   := 'PREV=' || m_org_file_id || '|' || 'ORFL' || CHR (191);
                                f_msgdb(f_msgdb.LAST).messageno_source          := n_msgdb_batch(i).messageno_source;
                                f_msgdb(f_msgdb.LAST).receiver                  := n_msgdb_batch(i).receiver;
                                f_msgdb(f_msgdb.LAST).sender                    := n_msgdb_batch(i).sender;
                                f_msgdb(f_msgdb.LAST).custom37                  := m_banking_channel;
                                f_msgdb(f_msgdb.LAST).msg_family                := n_msgdb_batch(i).msg_family;
                                f_msgdb(f_msgdb.LAST).display_flag              := 'Y';
                                f_msgdb(f_msgdb.LAST).current_auth_level        := n_msgdb_batch(i).current_auth_level;
                                f_msgdb(f_msgdb.LAST).payment_duedate           := n_msgdb_batch(i).payment_duedate;
                                f_msgdb(f_msgdb.LAST).datakeyid                 := n_msgdb_batch(i).datakeyid;
                                f_msgdb (f_msgdb.LAST).ISOUTPUT                 := 'Y';
                                f_msgdb (f_msgdb.LAST).ISINPUT                  := 'N';
--                                f_msgdb (f_msgdb.LAST).custom24                 := m_releasedate;

                                IF n_msgdb_batch(i).request_type = 'INV'
                                THEN
                                    f_msgdb(f_msgdb.LAST).request_type                 := n_msgdb_batch(i).request_type;
                                    dbms_output.put_line('Request type : ' || f_msgdb(f_msgdb.LAST).request_type);
                                END IF;
                                dbms_output.put_line(' f_msgdb(f_msgdb.LAST).channel_id_source : ' || f_msgdb(f_msgdb.LAST).channel_id_source );
                                INSERT INTO msgdb VALUES f_msgdb (1);

                                dbms_output.put_line ('New file record insert in msgdb=>'|| m_output_file_id);

                                --Added to support New File institutionname for GrpHdr/InitgPty/Nm

                                SELECT NVL(institutionname, 'NOTPROVIDED')
                                INTO   m_institutionname
                                FROM institutionmaster
                                WHERE institutionid = m_institutionid;
                            END IF;

                            --To support Generic XML bulking when batch creation required
                            IF m_no_batch_required = 'Y'
                            THEN
                                DBMS_LOB.createtemporary (batch_content, TRUE);
                                batch_content := NVL(encrypt_decrypt_basedon_session_cntx_clob(m_decrypt,n_msgdb_batch(i).institutionid,blob_to_clob(n_msgdb_batch(i).msgdb_id,p_src_batch_blocktype)),'X');
                                dbms_output.put_line('batch_content length of : '||n_msgdb_batch(i).msgdb_id || ' is  : ' || batch_content);
                                DBMS_LOB.append (batch_transaction_content, batch_content);
                            END IF;

                            m_seq_btch_no        := TO_NUMBER (TO_CHAR (SYSTIMESTAMP, 'FF3'));
                            b_audit_text         := 'Batch number <'|| n_msgdb_batch (i).messageno|| '> moved to ' || NVL(td_get_value('MESSAGESTATUS2',p_trgt_batch_status),'Final') || ' status';
                            m_curr_batch_msgno   := n_msgdb_batch (i).messageno;

                            SELECT  COUNT (*)
                            INTO    m_batch_msgblocks_count
                            FROM    msgblocks
                            WHERE   msgdb_id = n_msgdb_batch (i).msgdb_id;

                            dbms_output.put_line('m_batch_msgblocks_count: ' || m_batch_msgblocks_count);

                            IF m_batch_msgblocks_count != 0
                            THEN
                                --To support Generic XML bulking Get batch header and convert it into CLOB
                                IF m_no_batch_required = 'N'
                                THEN
                                    batch_content := encrypt_decrypt_basedon_session_cntx_clob(m_decrypt,n_msgdb_batch(i).institutionid,blob_to_clob(n_msgdb_batch (i).msgdb_id,p_src_batch_blocktype));
                                    dbms_output.put_line ('batch_content : '|| batch_content  );
                                END IF;
                                dbms_output.put_line ('m_tdidcode_msgclasstype : '|| m_tdidcode_msgclasstype  );
                                dbms_output.put_line ('m_batch_trailer_tag : '|| m_batch_trailer_tag );
                            END IF;

                            --To support Generic XML bulking Get batch trailer
                            IF m_no_batch_required = 'Y'
                            THEN
                               m_batch_trailer := td_get_value(m_tdidcode_msgclasstype, m_batch_trailer_tag);
                            END IF;

                            dbms_output.put_line ('m_batch_trailer : ' || m_batch_trailer);
                            dbms_output.put_line ('n_msgdb_batch (i).msgdb_id : ' || n_msgdb_batch (i).msgdb_id);

                            --Open cursor for Transactions
                            OPEN cur_transaction_records (n_msgdb_batch (i).msgdb_id);
                            FETCH cur_transaction_records BULK COLLECT INTO n_msgdb_tran LIMIT 10000;

                            LOOP --Loop for Transactions START
                                m_tran_beg_ctr := NVL (n_msgdb_tran.FIRST, 0);  --Setting begin counter for transaction
                                        m_tran_end_ctr := NVL (n_msgdb_tran.LAST, 0);      --Setting end counter for transaction
                                        DBMS_OUTPUT.put_line ('Transaction COUNT : '|| m_tran_end_ctr  );

                                DBMS_LOB.createtemporary (transaction_content, TRUE);

                                IF m_tran_end_ctr <= 0
                                THEN
                                    EXIT;
                                END IF;

                                -- Initializing collection variable for batch records
                                t_msgdb_id          := a_msgdb_id ();
                                t_messageno         := a_messageno ();
                                t_institutionid     := a_institutionid ();
                                t_audittext         := a_audittext ();
                                t_seq_no            := a_seq_no ();
                                t_end_hash_code     := a_end_hash_code ();
                                t_auditdatetime     := a_auditdatetime ();
                                t_audittimestamp    := a_audittimestamp ();
                               --Creating temporary space for transactions of a batch

                                FOR j IN m_tran_beg_ctr..m_tran_end_ctr
                                LOOP -- Internal Loop for transaction START
                                    tran_msgdb_id.EXTEND;
                                    t_msgdb_id.EXTEND;
                                    t_messageno.EXTEND;
                                    t_institutionid.EXTEND;
                                    t_audittext.EXTEND;
                                    t_seq_no.EXTEND;
                                    t_end_hash_code.EXTEND;
                                    t_auditdatetime.EXTEND;
                                    t_audittimestamp.EXTEND;

                                    m_seq_tran_no := TO_NUMBER (TO_CHAR (SYSTIMESTAMP, 'FF3'));

                                    t_audit_text    := 'Message number <'|| n_msgdb_tran (j).messageno|| '> moved to '|| NVL(td_get_value('MESSAGESTATUS2',p_trgt_tran_status),'Final') || ' Status';
                                    m_sysdate       := SYSDATE;

                                    t_msgdb_id(t_msgdb_id.LAST)             := n_msgdb_tran (j).msgdb_id;
                                    tran_msgdb_id(tran_msgdb_id.LAST)       := n_msgdb_tran (j).msgdb_id;
                                    t_messageno(t_messageno.LAST)           := n_msgdb_tran (j).messageno;
                                    t_institutionid(t_msgdb_id.LAST)        := n_msgdb_tran (j).institutionid;
                                    t_audittext(t_audittext.LAST)           := t_audit_text;
                                    t_auditdatetime(t_auditdatetime.LAST)   := m_sysdate;
                                    t_audittimestamp(t_audittimestamp.LAST) := m_systimestamp;
                                    t_seq_no(t_seq_no.LAST)                 := m_seq_tran_no;
                                    t_end_hash_code(t_end_hash_code.LAST)   := getencodehashvalue
                                                                              (   n_msgdb_tran (j).messageno
                                                                               || TO_CHAR (m_sysdate,'yyyy-mm-dd HH24:MI:SS')
                                                                               || m_seq_tran_no
                                                                               || p_trgt_tran_queueid
                                                                               || g_username
                                                                               || g_application
                                                                               || g_modulename
                                                                               || g_action
                                                                               || t_audit_text
                                                                               || n_msgdb_tran (j).institutionid
                                                                               || m_keyid,
                                                                               m_secretkey
                                                                              );
                                    m_record_end_marker := n_msgdb_tran (j).record_end_marker;

                                    dbms_output.put_line ('tran_msgdb_id(tran_msgdb_id.LAST): '|| tran_msgdb_id(tran_msgdb_id.LAST));

                                    dbms_output.put_line ('Transaction ID : '|| n_msgdb_tran (j).msgdb_id|| ' : '|| m_record_end_marker);

                                    --Creating temporary space for a transaction
                                    DBMS_LOB.createtemporary (m_curr_transaction, TRUE);
                                    --Convert Transaction in CLOB

                                    m_curr_transaction := encrypt_decrypt_basedon_session_cntx_clob(m_decrypt,n_msgdb_tran(j).institutionid,v_blobtoclob(n_msgdb_tran(j).message));
                                    dbms_output.put_line('m_curr_transaction : '||m_curr_transaction);
                                    dbms_output.put_line('m_batch_trailer : '||m_batch_trailer);
                                    dbms_output.put_line('m_tdidcode_msgclasstype : '||m_tdidcode_msgclasstype);
                                    dbms_output.put_line('DBMS_LOB.getlength (file_header) : '||DBMS_LOB.getlength (file_header));
                                    dbms_output.put_line('DBMS_LOB.getlength (batch_content) = 0 : '||DBMS_LOB.getlength (batch_content));

                                     --Generic XML
--                                    IF INSTR (m_curr_transaction, m_batch_trailer) > 0 AND m_tdidcode_msgclasstype IN ('PAIN001','PAIN008')

                                    IF m_tdidcode_msgclasstype IN ('PACS001','PACS003','PACS008','PACS008N','PACS004','PACS007','CAMT056','CAMT029','CAMT029N','CAMT056N','PACS004N','PACS003N','PACS007N')
                                    THEN
                                        -- If no file header is present
                                        IF    DBMS_LOB.getlength (file_header) = 0 AND   i = 1 OR (i > 1 AND m_next_file_gen = 'Y')
                                        THEN
                                            -- Extract file header
                                            dbms_output.put_line('Calling file_header');
                                            file_header := clob_to_blob(get_sepa_tran (m_curr_transaction, m_tdidcode_msgclasstype));
                                            dbms_output.put_line('2 file_header LENGTH : '|| DBMS_LOB.getlength(file_header));
                                        END IF;

                                        IF DBMS_LOB.getlength (batch_content) = 0 OR (i >= 1 AND j <= 1)
                                        THEN
                                            --Get BATCH HEADER / TRAILER tag from tabledetails
                                            dbms_output.put_line('Calling batch_content assigning from get_sepa_tran ');
                                            batch_content := get_sepa_tran (m_curr_transaction, m_tdidcode_msgclasstype);
                                        END IF;

                                        --Extract transaction if stored along with File and Batch tags
                                        dbms_output.put_line('Calling m_curr_transaction assigning from get_sepa_tran ');
                                        m_curr_transaction := get_sepa_tran (m_curr_transaction,m_tdidcode_msgclasstype);
                                    END IF;
                                    dbms_output.put_line('m_curr_transaction 001' || m_curr_transaction);
                                    dbms_output.put_line('LENGTH : ' || LENGTH (m_curr_transaction));
                                    dbms_output.put_line('m_no_batch_required : ' || m_no_batch_required);
                                    dbms_output.put_line('m_payment_onbehalf : ' || m_payment_onbehalf);
                                    --Appending transaction with another transaction of a batch
                                    --DBMS_LOB.createtemporary (transaction_content, TRUE);
                                    DBMS_LOB.writeappend (transaction_content,LENGTH (m_curr_transaction), m_curr_transaction);
                                    dbms_output.put_line('transaction_content : ' || transaction_content);

                                    IF m_no_batch_required = 'N'
                                    THEN
                                        IF n_msgdb_batch(i).messagedirection = 'I'
                                        THEN
                                            dbms_output.put_line('P2');
                                            DBMS_LOB.append (batch_transaction_content, m_curr_transaction);
                                            --DBMS_LOB.freetemporary (transaction_content);

                                        ELSIF (UPPER(m_payment_onbehalf) = 'N' OR UPPER(m_payment_onbehalf) = 'NO') OR n_msgdb_batch(i).messagedirection = 'O'
                                        THEN
                                            batch_transaction_content :=  transaction_content;
                                            --DBMS_LOB.freetemporary (transaction_content);
                                            dbms_output.put_line('P1');

                                        END IF;

                                    ELSE
--                                        dbms_output.put_line('batch_transaction_content: ' || batch_transaction_content);
--                                        dbms_output.put_line('m_curr_transaction: ' || m_curr_transaction);

                                        DBMS_LOB.append (batch_transaction_content, m_curr_transaction);
                                    END IF;

                                    IF (UPPER(m_payment_onbehalf) = 'Y' OR UPPER(m_payment_onbehalf) = 'YES') AND n_msgdb_batch(i).messagedirection = 'I'
                                    THEN
                                        DBMS_LOB.writeappend (tlt_transaction_content,LENGTH (m_curr_transaction), m_curr_transaction);
                                    END IF;
                                    dbms_output.put_line('m_payment_onbehalf'||m_payment_onbehalf);

                                    --Generic XML
                                    IF m_no_batch_required = 'Y'
                                    THEN
                                        m_batch_tran_count  := m_batch_tran_count + 1;
                                        m_batch_amount      := m_batch_amount + n_msgdb_tran(j).priorityamountnum;
                                    END IF;

                                    m_file_tran_count   := m_file_tran_count + 1;
                                    dbms_output.put_line ('m_file_tran_count_1: '|| m_file_tran_count);

                                    m_file_amount       := m_file_amount + n_msgdb_tran(j).priorityamountnum;
                                    dbms_output.put_line ('m_file_amount_1: '|| m_file_amount);

                                    dbms_output.put_line ('Transaction processed for =>'|| t_msgdb_id (j));

                                    DBMS_LOB.freetemporary (m_curr_transaction);

                                    --dbms_output.put_line('n_msgdb_tran.custom2 : '|| n_msgdb_tran (j).custom2);
                                    --dbms_output.put_line('n_msgdb_tran.transrefno : '|| n_msgdb_tran (j).transrefno);
                                END LOOP; -- Internal Loop for transaction END

                                IF UPPER(m_payment_onbehalf) = 'N' OR UPPER(m_payment_onbehalf) = 'NO'
                                THEN
                                    IF DBMS_LOB.getlength(total_transaction_content) > 0
                                    THEN
                                        DBMS_LOB.freetemporary (total_transaction_content);
                                    END IF;
                                END IF;

                                dbms_output.put_line ('m_record_end_marker : '|| m_record_end_marker);
                                dbms_output.put_line ('m_batch_tran_count  : '|| m_batch_tran_count);
                                dbms_output.put_line ('m_batch_amount   : '|| m_batch_amount);

                                IF INSTR (m_batch_amount, '.') > 0
                                THEN
                                    m_batch_amount := TO_CHAR (m_batch_amount);

                                    IF INSTR (m_batch_amount, '.') = 1
                                    THEN
                                        m_batch_amount := '0.'|| RPAD (getstringitemwithsep (m_batch_amount,2,'.'),2,'0');
                                    ELSE
                                        m_batch_amount := getstringitemwithsep (m_batch_amount, 1,'.')|| '.' || RPAD (getstringitemwithsep (m_batch_amount,2,'.' ), 2, '0');
                                    END IF;
                                ELSE
                                    m_batch_amount := m_batch_amount || '.00';
                                END IF;

                                dbms_output.put_line('batch_content : '||DBMS_LOB.GETLENGTH(batch_content));
/*
                                IF DBMS_LOB.INSTR (batch_content, m_tag_trns_str, 1, 1) > 0
                                THEN
                                    m_old_batch_strcount := SUBSTR (batch_content,
                                                            INSTR (batch_content, m_tag_trns_str, 1, 1),
                                                            INSTR (batch_content, m_tag_trns_end, 1, 1) -
                                                            INSTR (batch_content, m_tag_trns_str, 1, 1) +
                                                            LENGTH (m_tag_trns_end));

                                    dbms_output.put_line ('m_old_batch_strcount  : ' || m_old_batch_strcount);
                                    m_new_batch_strcount := m_tag_trns_str || m_batch_tran_count || m_tag_trns_end;
                                    dbms_output.put_line ('m_new_batch_strcount  : '|| m_new_batch_strcount);

                                    batch_content := REPLACE (batch_content, m_old_batch_strcount, m_new_batch_strcount);
                                ELSIF m_no_batch_required = 'Y'
                                THEN
                                    m_new_batch_strcount  := m_tag_trns_str || m_batch_tran_count || m_tag_trns_end;
                                    m_xnode_new           := m_tag_trns_str;
                                    m_xnode_new           := REPLACE (m_xnode_new, '<', NULL);
                                    m_xnode_new           := REPLACE (m_xnode_new, '>', NULL);
                                    DBMS_LOB.append (batch_content, m_batch_endtag);

                                    dbms_output.put_line('batch_content: ' || batch_content);

                                    BEGIN  -- Sixth Transaction records BEGIN block START
                                        m_xtype := XMLTYPE (xmldata => batch_content);
                                        m_xpath := 'PmtInf/BtchBookg';

                                        SELECT     EXISTSNODE (m_xtype, m_xpath)
                                        INTO     m_nodecount
                                        FROM     DUAL;
                                        dbms_output.put_line (m_xpath);

                                        IF m_nodecount <= 0
                                        THEN
                                            m_xpath := 'PmtInf/PmtMtd';

                                            SELECT     EXISTSNODE (m_xtype, m_xpath)
                                            INTO     m_nodecount
                                            FROM     DUAL;
                                            dbms_output.put_line (m_xpath);

                                            IF m_nodecount = 1
                                            THEN
                                                SELECT     insertxmlafter(m_xtype,m_xpath,XMLTYPE (m_new_batch_strcount))
                                                INTO     m_xtype
                                                FROM     DUAL;
                                            END IF;
                                        ELSE
                                           SELECT     insertxmlafter(m_xtype,m_xpath,XMLTYPE (m_new_batch_strcount))
                                           INTO     m_xtype
                                           FROM     DUAL;
                                        END IF;
                                        batch_content := m_xtype.getclobval;
                                    END; -- Sixth Transaction records BEGIN block END

                                    batch_content         := REPLACE (batch_content, m_batch_endtag, '');
                                END IF;

                                IF DBMS_LOB.INSTR (batch_content, m_tag_amt_str, 1, 1) > 0
                                THEN
                                    dbms_output.put_line ('AT 2');
                                    m_old_batch_stramount := SUBSTR (batch_content,INSTR (batch_content, m_tag_amt_str, 1, 1),
                                                             INSTR     (batch_content, m_tag_amt_end, 1, 1) - INSTR (batch_content, m_tag_amt_str, 1, 1) +
                                                             LENGTH (m_tag_amt_end));

                                    dbms_output.put_line ('m_old_batch_stramount : ' || m_old_batch_stramount);
                                    m_new_batch_stramount := m_tag_amt_str || m_batch_amount || m_tag_amt_end;

                                    dbms_output.put_line ('m_new_batch_stramount : '|| m_new_batch_stramount);
                                    batch_content := REPLACE (batch_content,m_old_batch_stramount,m_new_batch_stramount);
                                    DBMS_LOB.append (batch_content, transaction_content);
                                ELSIF m_no_batch_required = 'Y'
                                THEN
                                    m_new_batch_stramount     := m_tag_amt_str || m_batch_amount || m_tag_amt_end;
                                    m_xnode_new                := m_tag_amt_str;
                                    m_xnode_new                   := REPLACE (m_xnode_new, '<', NULL);
                                    m_xnode_new                := REPLACE (m_xnode_new, '>', NULL);
                                    DBMS_LOB.append (batch_content, m_batch_endtag);

                                    BEGIN -- Seventh Transaction records BEGIN block START
                                        m_xtype := XMLTYPE (xmldata => batch_content);
                                        m_xpath := 'PmtInf/NbOfTxs';

                                        SELECT     EXISTSNODE (m_xtype, m_xpath)
                                        INTO     m_nodecount
                                        FROM     DUAL;
                                        dbms_output.put_line (m_xpath);

                                        IF m_nodecount <= 0
                                        THEN
                                            m_xpath := 'PmtInf/BtchBookg';

                                            SELECT     EXISTSNODE (m_xtype, m_xpath)
                                            INTO     m_nodecount
                                            FROM     DUAL;
                                            dbms_output.put_line (m_xpath);

                                            IF m_nodecount <= 0
                                            THEN
                                                m_xpath := 'PmtInf/PmtMtd';

                                                SELECT     EXISTSNODE (m_xtype, m_xpath)
                                                INTO     m_nodecount
                                                FROM     DUAL;

                                                dbms_output.put_line (m_xpath);

                                                IF m_nodecount = 1
                                                THEN
                                                    SELECT     insertxmlafter(m_xtype,m_xpath,XMLTYPE (m_new_batch_stramount))
                                                    INTO     m_xtype
                                                    FROM     DUAL;
                                                END IF;
                                            ELSE
                                                SELECT     insertxmlafter(m_xtype, m_xpath, XMLTYPE (m_new_batch_stramount))
                                                INTO     m_xtype
                                                FROM     DUAL;
                                            END IF;
                                        ELSE
                                            SELECT     insertxmlafter(m_xtype, m_xpath, XMLTYPE (m_new_batch_stramount))
                                            INTO     m_xtype
                                            FROM     DUAL;
                                        END IF;
                                        batch_content     := m_xtype.getclobval;
                                    END; -- Seventh Transaction records BEGIN block END
                                    batch_content := REPLACE (batch_content, m_batch_endtag, '');

                                    DBMS_LOB.append (batch_content, transaction_content);

                                END IF;
*/
                                --Changes made by Vilas M-- for handling processing of huge files(3.5L)
                                --Updating transactions queueid and status from source to target


                                FORALL i IN m_tran_beg_ctr .. m_tran_end_ctr
                                UPDATE  msgdb
                                SET     queueid              = p_trgt_tran_queueid,
                                        processing_stage     = get_queue_stage (m_institutionid,p_trgt_tran_queueid),       -- included new column
                                        status                = p_trgt_tran_status,
                                        isoutput             =  'N',
                                        display_flag        = 'N',
                                        msgdb_id_target     = m_output_file_id,
                                        channel_id_source     = DECODE(m_set_txn_channel_as_null,'YES',NULL,channel_id_source),
                                        channel_id_target     = DECODE(m_set_txn_channel_as_null,'YES',NULL,channel_id_target),
                                        --custom2             = DECODE(messageclasstype,'pacs.008.001.02',transrefno,'pacs.003.001.02',transrefno,'pacs.004.001.02',transrefno,m_btch_transrefno ||m_reverse_questionmark||transrefno),--changes made by cyril for pacs003 custom2
                                        custom2             = DECODE(m_tdidcode_msgclasstype,'PACS008',transrefno,'PACS008N',transrefno,'PACS003',transrefno,'PACS003N',transrefno,'PACS004',transrefno,m_btch_transrefno ||m_reverse_questionmark||transrefno),--changes made by cyril for pacs003 custom2
                                        --reason_code         = DECODE(messageclasstype,'pacs.008.001.02','OLA02','pacs.003.001.02','OLA04'),
                                        reason_code         = DECODE(m_tdidcode_msgclasstype,'PACS008','OLA02','PACS003','OLA04'),
                                        messageno_target    = m_msgdb_msgeno_file --,
                                        --display_flag        = 'N'
                                WHERE   msgdb_id             = t_msgdb_id (i);

                                msgdb_links_new := t_msgdb_links();

                                FOR i IN m_tran_beg_ctr .. m_tran_end_ctr
                                LOOP
                                    dbms_output.put_line('transaction_msgdb : '|| t_msgdb_id(i));
                                    msgdb_links_new.EXTEND;
                                    msgdb_links_new(i).msgdb_id     := t_msgdb_id(i);
                                    msgdb_links_new(i).type         := 'M';
                                    msgdb_links_new(i).parent_id    := m_output_file_id;
                                    msgdb_links_new(i).parent_type  := 'F';

                                    INSERT INTO MSGDB_LINKS VALUES msgdb_links_new(i);

                                END LOOP;

                                --Inserting audit for transactions
                                /*FORALL j IN m_tran_beg_ctr .. m_tran_end_ctr

                                INSERT
                                INTO genaudit
                                     (messageno, auditdatetime,
                                      audittimestamp, sequenceno,
                                      queueid, username,
                                      application, modulename, action,
                                      audittext, institutionid,
                                      keyid, enc_hash_code, datakeyid
                                     )
                                VALUES (t_messageno (j), t_auditdatetime (j),
                                      t_audittimestamp (j), t_seq_no (j),
                                      p_trgt_tran_queueid, 'ADMIN',
                                      g_application, g_modulename, g_action,
                                      t_audittext(j),t_institutionid (j),
                                      m_keyid, t_end_hash_code (j),m_active_datakeyid
                                     );*/
                                FOR j IN m_tran_beg_ctr .. m_tran_end_ctr
                                LOOP
                                    genaudit_insert_enchash_wrap
                                    (
                                        p_messageno=>t_messageno (j),
                                        p_queueid=>p_trgt_tran_queueid,
                                        p_username=>'ADMIN',
                                        p_application=>g_application,
                                        p_modulename=>g_modulename,
                                        p_action=>g_action,
                                        p_audittext=>t_audittext(j),
                                        p_institutionid=>t_institutionid (j),
                                        p_incr_count=>0
                                    );


                                END LOOP;

                                ----changing msgdb_output.MDBOUT_status to 'A' to support EOD reports
                                dbms_output.put_line('test1');
                                FORALL l IN m_tran_beg_ctr .. m_tran_end_ctr
                                UPDATE  msgdb_output
                                SET     mdbout_status = 'A'
                                WHERE   msgdb_id = t_msgdb_id (l)
                                AND     mdbout_mode IN (SELECT para_code FROM  TABLE (get_code_from_list(td_get_value('EODREP_CONF','EOD2'), '|') ))
                                AND     mdbout_status <> 'N'; --SNTD ignore mdbout_status <> N indication EOD is not applicable 
                                
                                EXIT WHEN cur_transaction_records%NOTFOUND;

                                FETCH cur_transaction_records
                                BULK COLLECT INTO n_msgdb_tran LIMIT 10000;
                                -- END IF;

                                IF m_no_batch_required = 'Y'
                                THEN
                                    DBMS_LOB.freetemporary (transaction_content);
                                END IF;
                            END LOOP; --Loop for Transactions END

                            CLOSE cur_transaction_records;

                            m_btch_ctr                 := m_btch_ctr + 1;
                            m_processed_batch_count := m_processed_batch_count + 1;
                            
                            dbms_output.put_line('test2');

                            UPDATE  msgdb
                            SET     queueid             = p_trgt_batch_queueid,
                                    processing_stage    = get_queue_stage (n_msgdb_batch (i).institutionid,p_trgt_tran_queueid),             -- included new column
                                    status              = p_trgt_batch_status,
                                    msgdb_id_target     = m_output_file_id,
                                    channel_id_source   = DECODE(m_set_bat_channel_as_null,'YES',NULL,channel_id_source),
                                    channel_id_target   = DECODE(m_set_bat_channel_as_null,'YES',NULL,channel_id_target),
                                    custom2             = m_btch_transrefno,
                                    messageno_target    = m_msgdb_msgeno_file
                                    --priorityamountnum   = m_batch_amount
                            WHERE   msgdb_id            = n_msgdb_batch(i).msgdb_id;

                            /*INSERT
                            INTO genaudit
                                       (messageno, auditdatetime,
                                        audittimestamp, sequenceno,
                                        queueid, username, application,
                                        modulename, action, audittext,
                                        institutionid, keyid,
                                        enc_hash_code, datakeyid
                                       )
                                VALUES (n_msgdb_batch (i).messageno, m_sysdate,
                                        m_systimestamp, m_seq_btch_no,
                                        p_trgt_batch_queueid, 'ADMIN', g_application,
                                        g_modulename, g_action, b_audit_text,
                                        n_msgdb_batch (i).institutionid, m_keyid,
                                        getencodehashvalue
                                                      (   n_msgdb_batch (i).messageno
                                                       || TO_CHAR (m_sysdate,'yyyy-mm-dd HH24:MI:SS')
                                                       || m_seq_btch_no
                                                       || p_trgt_batch_queueid
                                                       || 'ADMIN'
                                                       || g_application
                                                       || g_modulename
                                                       || g_action
                                                       || b_audit_text
                                                       || n_msgdb_batch (i).institutionid
                                                       || m_keyid,
                                                       m_secretkey
                                                      ),m_active_datakeyid
                                       );*/

                            genaudit_insert_enchash_wrap
                                    (
                                        p_messageno=>n_msgdb_batch (i).messageno,
                                        p_queueid=>p_trgt_batch_queueid,
                                        p_username=>'ADMIN',
                                        p_application=>g_application,
                                        p_modulename=>g_modulename,
                                        p_action=>g_action,
                                        p_audittext=>b_audit_text,
                                        p_institutionid=>n_msgdb_batch (i).institutionid,
                                        p_incr_count=>0
                                    );
                            dbms_output.put_line('test3');
                            IF m_filetype_org = 'SEPA-PAIN' OR n_msgdb_batch(i).custom43 = 'TRX_DELIVERY' OR m_filetype_org = 'SEPA-PACS'
                            THEN
                                dbms_output.put_line(   'm_new_batch_count = m_cancelled_batch_count + m_processed_batch_count ==>');
                                 --|| m_new_batch_count || ' = ' || m_cancelled_batch_count || '+' || m_processed_batch_count||' total batch:'||m_total_batch_count);

                                IF m_total_batch_count =    (m_cancelled_batch_count + m_processed_batch_count)
                                THEN
                                    dbms_output.put_line ('target:'||m_cancelled_batch_count || '<==>' || m_processed_batch_count);
                                    m_file_status     := p_trgt_file_status;
                                    m_queueid         := p_trgt_file_queueid;
                                ELSE
                                    dbms_output.put_line ('source:'||m_cancelled_batch_count || '<==>' || m_processed_batch_count);
                                    m_file_status     := p_src_file_status;
                                    m_queueid         := p_src_file_queueid;
                                END IF;
                            ELSE
                                dbms_output.put_line ('else:'||m_filetype_org||m_cancelled_batch_count || '<==>' || m_processed_batch_count);
                                m_file_status     := p_trgt_file_status;
                                m_queueid         := p_trgt_file_queueid;
                            END IF;

                            UPDATE  msgdb
                            SET     queueid             = m_queueid,
                                    processing_stage    = get_queue_stage (m_institutionid, m_queueid),-- included new column
                                    status              = m_file_status,
                                    lock_child_records  = 'N',
                                    custom45            = t_file_seqno,
                                    custom5             = (CASE WHEN LENGTH(custom5) + LENGTH('NEXT='|| m_output_file_id|| '|'|| m_linking_code || CHR (191)) <= 250
                                                            THEN custom5 || 'NEXT=' || m_output_file_id || '|' || m_linking_code || CHR (191)
                                                            ELSE custom5 END)
                            WHERE   msgdb_id            = m_org_file_id;

                            UPDATE  msgdb_file
                            SET     mdbfl_outputfilename     = m_filename
                            WHERE   msgdb_id                 = m_org_file_id;
                            
                            dbms_output.put_line('test4');

                             IF m_no_batch_required = 'Y' and length(m_batch_trailer) > 0
                            THEN
                                DBMS_LOB.writeappend (batch_transaction_content,LENGTH (m_batch_trailer),m_batch_trailer);
                            END IF;
                            m_date         := TO_CHAR (SYSDATE, 'YYYYMMDD');
                            m_systime      := TO_CHAR (SYSDATE, 'HH24MISS');
                            dbms_output.put_line('test5');

                            IF m_record_end_marker = 3
                            THEN
                                 m_msgId     := get_msgid(m_output_file_id,n_msgdb_batch(i).tenant_name,'SEPA_MSGID_'||m_tdidcode_msgclasstype||'_'||n_msgdb_batch(i).messagedirection);
                                dbms_output.PUT_LINE('m_msgId '|| m_msgId);
                                
                                dbms_output.PUT_LINE('f_message_clob '|| f_message_clob);
                                f_message_clob  := get_tag_value(m_tdidcode_msgclasstype,'FH',m_banking_channel);
                                dbms_output.PUT_LINE('f_message_clob '|| f_message_clob);
                                dbms_output.PUT_LINE('2nd  ');
                                IF m_tdidcode_msgclasstype        IN ('PACS003','PACS003N')
                                THEN
                                    m_settlement_method := NVL(get_institution_param_value(p_institutionid => m_institutionid, p_path =>'FILE_PROCESSING.GEN_PARAMS.PACS003_GRPHDR_VALUES.SETTLEMENT_METHOD', p_paramname => 'METHOD_USED'),'PACS3');
                                    dbms_output.put_line('m_settlement_method pacs 3 '|| m_settlement_method);
                                ELSIF m_tdidcode_msgclasstype        IN ('PACS008','PACS008N')
                                THEN
                                    m_settlement_method := NVL(get_institution_param_value(p_institutionid => m_institutionid, p_path =>'FILE_PROCESSING.GEN_PARAMS.PACS008_GRPHDR_VALUES.SETTLEMENT_METHOD', p_paramname => 'METHOD_USED'),'PACS8');
                                    dbms_output.put_line('m_settlement_method pacs 8 '|| m_settlement_method);
                                ELSIF m_tdidcode_msgclasstype        IN ('PACS007','PACS007N')
                                THEN
                                    m_settlement_method := NVL(get_institution_param_value(p_institutionid => m_institutionid, p_path =>'FILE_PROCESSING.GEN_PARAMS.PACS007_GRPHDR_VALUES.SETTLEMENT_METHOD', p_paramname => 'METHOD_USED'),'PACS7');
                                    dbms_output.put_line('m_settlement_method pacs 7 '|| m_settlement_method);
                                ELSIF m_tdidcode_msgclasstype        IN ( 'PACS004','PACS004N')
                                THEN
                                    m_settlement_method := NVL(get_institution_param_value(p_institutionid => m_institutionid, p_path =>'FILE_PROCESSING.GEN_PARAMS.PACS004_GRPHDR_VALUES.SETTLEMENT_METHOD', p_paramname => 'METHOD_USED'),'PACS4');
                                    dbms_output.put_line('m_settlement_method pacs 4 '|| m_settlement_method);
                                ELSIF m_tdidcode_msgclasstype        IN ( 'CAMT056','CAMT056N')
                                THEN
                                    m_settlement_method := NVL(get_institution_param_value(p_institutionid => m_institutionid, p_path =>'FILE_PROCESSING.GEN_PARAMS.CAMT056_GRPHDR_VALUES.SETTLEMENT_METHOD', p_paramname => 'METHOD_USED'),'CAMT56');
                                    dbms_output.put_line('m_settlement_method camt 56 '|| m_settlement_method);
                                ELSIF m_tdidcode_msgclasstype        IN ( 'CAMT029','CAMT029N')
                                THEN
                                    m_settlement_method := NVL(get_institution_param_value(p_institutionid => m_institutionid, p_path =>'FILE_PROCESSING.GEN_PARAMS.CAMT029_GRPHDR_VALUES.SETTLEMENT_METHOD', p_paramname => 'METHOD_USED'),'CAMT29');
                                    dbms_output.put_line('m_settlement_method camt 29 '|| m_settlement_method);
                                END IF;

                                dbms_output.put_line('generate_xml CALLING');
                                dbms_output.put_line('m_banking_channel :' || m_banking_channel);
                                dbms_output.put_line('m_msgdb_msgeno_file : ' || m_msgdb_msgeno_file);
                                dbms_output.put_line('m_file_amount : ' || m_file_amount);
                                dbms_output.put_line('m_file_tran_count : ' || m_file_tran_count);
                                dbms_output.put_line('m_institutionname : ' || m_institutionname);
                                dbms_output.put_line('m_tdidcode_msgclasstype : ' || m_tdidcode_msgclasstype);
                                dbms_output.put_line('n_msgdb_batch(i).msgdb_id : ' || n_msgdb_batch(i).msgdb_id);
                                dbms_output.put_line('m_msgid : ' || m_msgid);
                                dbms_output.put_line('f_message_clob : ' || f_message_clob);
                                ----------------------------------------------------------------------------changes made by cyril on 28 apr 2022------------------------------------------------
                                --L_FILE_HEADER   := GENERATE_XML('F_MESSAGENO='||M_MSGDB_MSGENO_FILE||'|'||'F_AMOUNT='||M_FILE_AMOUNT||'|'||'F_T_COUNT='||M_FILE_TRAN_COUNT||'|'||'F_INITPRTYNM='||M_INSTITUTIONNAME||'|'||'F_STLM_MTD='||M_SETTLEMENT_METHOD||'|',M_TDIDCODE_MSGCLASSTYPE,N_MSGDB_BATCH(I).MSGDB_ID,'F');
                                L_FILE_HEADER   := GENERATE_XML('F_MESSAGENO='||m_msgid||'|'||'F_AMOUNT='||M_FILE_AMOUNT||'|'||'F_T_COUNT='||M_FILE_TRAN_COUNT||'|'||'F_INITPRTYNM='||M_INSTITUTIONNAME||'|'||'F_STLM_MTD='||M_SETTLEMENT_METHOD||'|',M_TDIDCODE_MSGCLASSTYPE,N_MSGDB_BATCH(I).MSGDB_ID,'F');
                                ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                                dbms_output.put_line('l_file_header : ' || l_file_header);

                                DBMS_LOB.append (f_message_clob, l_file_header);

                                    IF m_tdidcode_msgclasstype IN ('CAMT029','CAMT029N')
                                    THEN
                                            batch_transaction_content:= TD_GET_VALUE(m_tdidcode_msgclasstype, 'NODE_BATCHHEAD_TAG') || batch_transaction_content || TD_GET_VALUE(m_tdidcode_msgclasstype, 'NODE_BATCHFOOTER_TAG');

                                    END IF;

                                DBMS_LOB.append (f_message_clob, batch_transaction_content);
                                dbms_output.put_line('batch_transaction_content : ' || batch_transaction_content);

                                l_file_trailer   :=    get_tag_value(m_tdidcode_msgclasstype,'FT',m_banking_channel);
                                dbms_output.put_line('l_file_trailer : ' || l_file_trailer);

                                DBMS_LOB.append (f_message_clob, l_file_trailer);

                                m_filesize := DBMS_LOB.getlength(f_message_clob);
                                --Encrypting payments--
                                 m_file_content := GET_ENCRYPT_DECRYPT_DATA('ENCRYPT',n_msgdb_batch (i).institutionid,CLOB_TO_BLOB(f_message_clob));

                                dbms_output.put_line('m_filesize length : ' || m_filesize);
                                --dbms_output.put_line('batch_transaction_content : ' || batch_transaction_content);
                                --dbms_output.put_line('f_message_clob : '||f_message_clob);
                                dbms_output.put_line('m_file_tran_count : '||m_file_tran_count);
                                dbms_output.put_line('m_file_tran_amnt_old : '||m_file_tran_amnt_old);
--                              dbms_output.put_line('m_file_tran_amnt : '||m_file_tran_amnt);
                                dbms_output.put_line('m_mdbfl_filetype : '||m_mdbfl_filetype);
                                dbms_output.put_line('file_header : '||length(file_header));

                                IF m_no_batch_required = 'Y'
                                THEN
                                    DBMS_LOB.freetemporary (transaction_content);
                                END IF;

                                IF m_tdidcode_msgclasstype = 'PACS001'
                                THEN
                                    m_mdbfl_filetype := td_get_value ('EQUENS','SCT' || '-' || m_deliver_output_to);
                                ELSIF m_tdidcode_msgclasstype        IN  ('PACS008','PACS008N')
                                THEN
                                    m_mdbfl_filetype := td_get_value ('EQUENS',m_local_instrument_code|| '-' || m_deliver_output_to);
                                ELSE
                                    SELECT  transactiongroup
                                    INTO    m_tran_group
                                    FROM    messagetype
                                    WHERE   type = p_batch_messageclasstype;

                                    IF m_tran_group = 'CT'
                                    THEN
                                        m_mdbfl_filetype := td_get_value ('EQUENS','SCT' || '-' || m_deliver_output_to);
                                    ELSE
                                        m_mdbfl_filetype := td_get_value ('EQUENS',m_local_instrument_code|| '-' || m_deliver_output_to);
                                    END IF;

                                END IF;

                                IF m_mdbfl_filetype IS NULL
                                THEN
                                    m_mdbfl_filetype := p_bulk_file_type;
                                END IF;

                                IF m_no_batch_required = 'Y' AND p_src_file_queueid IS NOT NULL
                                THEN
                                    file_content_to_append :=  batch_transaction_content;
                                ELSE
                                --If batch XML section not required

                                    IF p_src_file_queueid IS NOT NULL
                                    THEN
                                        file_header := clob_to_blob (f_message_clob);
                                        dbms_output.put_line('m_org_file_id : '||m_org_file_id);
                                        dbms_output.put_line('m_file_tran_count : '||m_file_tran_count);
                                        dbms_output.put_line('m_file_tran_amnt_old : '||m_file_tran_amnt_old);
                                        dbms_output.put_line('m_file_amount : '||m_file_amount);
--                                      dbms_output.put_line('file_content_to_append : '||file_content_to_append);
                                        dbms_output.put_line('m_mdbfl_filetype : '||m_mdbfl_filetype);
                                        dbms_output.put_line('file_header : '||length(file_header));

                                        ace_generate_file (m_org_file_id,
                                                     m_file_tran_count,
                                                     m_file_tran_amnt_old,
                                                     m_file_amount,
                                                     --batch_transaction_content,
                                                     file_content_to_append,
                                                     m_mdbfl_filetype,
                                                     file_header,
                                                     m_file_content,
                                                     m_mdbfl_filetype,
                                                     m_filesize,
                                                     m_mdbfl_param4,
                                                     m_mdbfl_param5,
                                                     m_filename,
                                                     m_tdidcode_msgclasstype,
                                                     m_banking_channel
                                                    );
                                        dbms_output.put_line('m_file_amount_2: '||m_file_amount);
                                        dbms_output.put_line('m_file_tran_count_2 : '||m_file_tran_count);
                                    END IF;

                                    IF p_generate_filename != 'N'
                                    THEN
                                        m_counter       := m_counter + 1;
--                                        m_bogaddress := get_institution_param_value (m_treasury_center,'INSTITUTION_DETAILS','EQUENS_ID');

--                                        IF m_bogaddress IS NULL
--                                        THEN
--                                            m_bogaddress := 'CHECKCONF';
--                                        END IF;

--                                        m_file_refno := NVL (m_file_refno, 'NOREF-');

--                                        dbms_output.put_line ('referenceno 1st : '|| m_file_refno);

--                                        IF LENGTH (m_file_refno) >= 6
--                                        THEN
--                                            m_file_refno := SUBSTR (m_file_refno, -6);
--                                        ELSE
--                                            m_file_refno := LPAD (m_file_refno, 6, '0');
--                                        END IF;

--                                        dbms_output.put_line ('referenceno 2nd : '|| m_file_refno);
--                                        dbms_output.put_line ('t_file_seqno before increament : ' || t_file_seqno);

--                                        IF m_cust_file_seq > 0
--                                        THEN
--                                            m_cust_file_seq := m_cust_file_seq + 1;
--                                            t_file_seqno     := m_cust_file_seq;
--                                        ELSE
--                                            t_file_seqno     := t_file_seqno + 1;
--                                        END IF;

--                                        IF n_msgdb_batch (i).deliver_output_to = 'BANK'
--                                        THEN
--                                            m_route_bank    := td_get_value ('EQUENS-DVOUTPUT', n_msgdb_batch (i).banking_channel);
--                                            m_received         := td_get_value ('EQNS_BANK_ROUTE', m_route_bank);

--                                            IF m_received IS NULL
--                                            THEN
--                                               m_received := 'RNVB';
--                                            END IF;
--                                        ELSIF n_msgdb_batch (i).deliver_output_to = 'CPS'
--                                        THEN
--                                            m_received := 'CPS';
--                                        ELSE
--                                            m_received := m_bogaddress;
--                                        END IF;

--                                        t_file_refno    := m_file_refno || LPAD(t_file_seqno,GREATEST(LENGTH(TO_CHAR(t_file_seqno)),2),'0');

--                                        IF LENGTH (t_file_refno) > 8
--                                        THEN
--                                            t_file_refno := SUBSTR (t_file_refno, -8);
--                                        END IF;

--                                        dbms_output.put_line('t_file_seqno after increament : ' || t_file_seqno);
--                                        dbms_output.put_line('t_file_seqno after appending  : ' || t_file_refno);

--                                        m_new_file_name    :=    td_get_value('PGGM_FILE_NAME','CREATE_FILE_NAME');--To handle for file name (i.e existing in PGGM)
--                                        dbms_output.put_line('New file name flag: ' || m_new_file_name);

--                                        m_old_file_name_supp    :=    td_get_value('FILE_NAME','OLD_FILE_NAME_SUPP');
--
--                                        dbms_output.put_line('m_old_file_name_supp ' || m_old_file_name_supp);
--
--                                        IF m_new_file_name = 'Y'
--                                        THEN
--                                            m_filename    :=    n_msgdb_batch(i).banking_channel || '.' || m_filename || '-' || t_file_refno || '-' || LPAD (t_file_seqno, 2, '0');
--                                            dbms_output.put_line('m_filename pggm : ' || m_filename);
--                                        ELSIF m_old_file_name_supp = 'Y'
--                                        THEN
--                                            IF n_msgdb_batch(i).tenant_name = 'VISTRA'
--                                            THEN

                                                dbms_output.put_line('------------get_filename-------------');
                                                dbms_output.put_line('n_msgdb_batch(i).banking_channel : ' || n_msgdb_batch(i).banking_channel);
                                                dbms_output.put_line('n_msgdb_batch(i).msgdb_id : ' || n_msgdb_batch(i).msgdb_id);
                                                dbms_output.put_line('m_mdbfl_filetype : ' || m_mdbfl_filetype);
                                                dbms_output.put_line('m_institutionid : ' || m_institutionid);
                                                dbms_output.put_line('n_msgdb_batch(i).tenant_name : ' || n_msgdb_batch(i).tenant_name);
                                                dbms_output.put_line('m_output_file_id : ' || m_output_file_id);

                                                m_filename    := get_tenantwise_filename(n_msgdb_batch(i).banking_channel,n_msgdb_batch(i).msgdb_id, m_mdbfl_filetype, m_institutionid,n_msgdb_batch(i).tenant_name,m_counter);
                                                dbms_output.put_line('m_filename : ' || m_filename);
--                                            ELSE
--                                                m_filename    := p_prefix_file_name || '.' || m_received || '.' || m_mdbfl_filetype || '.' || t_file_refno;
--                                            END IF;
--                                        ELSE
--                                            m_file_type_string := NVL(td_get_value('FILE_NAME','FILE_TYPE'),'N');

--                                            IF  getstringitemwithsep (m_file_type_string,1,'|') = 'Y'
--                                            THEN
--                                                m_file_type_cnt := LENGTH(m_file_type_string)-LENGTH(REPLACE(m_file_type_string,'|',''));

--                                                FOR i IN 2..m_file_type_cnt
--                                                LOOP
--                                                    m_current_string        := getstringitemwithsep (m_file_type_string,i,'|');
--                                                    m_current_msgclasstype  := getstringitemwithsep (m_current_string,1,'-');
--                                                    m_current_filetype      := getstringitemwithsep (m_current_string,2,'-');

--                                                    IF UPPER (SUBSTR (p_batch_messageclasstype, 1, 8)) = m_current_msgclasstype
--                                                    THEN
--                                                        m_mdbfl_filetype := m_current_filetype;
--                                                        EXIT;
--                                                    END IF;
--                                                END LOOP;
--                                            END IF;

--                                            dbms_output.put_line('n_msgdb_batch(i).banking_channel: ' || n_msgdb_batch(i).banking_channel);
--                                            dbms_output.put_line('n_msgdb_batch(i).msgdb_id: ' || n_msgdb_batch(i).msgdb_id);
--                                            dbms_output.put_line('m_mdbfl_filetype: ' || m_mdbfl_filetype);
--                                            dbms_output.put_line('m_institutionid_2: ' || m_institutionid);
--                                            dbms_output.put_line('n_msgdb_batch(i).tenant_name: ' || n_msgdb_batch(i).tenant_name);

--                                            m_filename_from_ip :=  td_get_value('FILENMFMTCONFIG',n_msgdb_batch(i).institutionid);

--                                            IF m_filename_from_ip = 'institutionparameters'
--                                            THEN
--                                                dbms_output.put_line('Calling institutionparameters..');
--                                                m_messageclasstype  := getstringitemwithsep(p_file_messageclasstype,1,'|'); -- for supporting pain to pacs conversion
--                                                m_filename          := generate_output_filename(m_messageclasstype||'-'||n_msgdb_batch(i).messagedirection,n_msgdb_batch(i).institutionid);
--                                                m_mdbfl_filetype    := p_bulk_file_type;
--                                            ELSE
--                                                dbms_output.put_line('Calling get_filename...');
--                                                m_filename    :=    get_filename(n_msgdb_batch(i).banking_channel,n_msgdb_batch(i).msgdb_id,m_mdbfl_filetype,m_institutionid,n_msgdb_batch(i).tenant_name,m_counter);
--                                                IF m_filename IS NULL
--                                                THEN
--                                                    m_filename  := m_prefix_filename || '.' || m_received || '.' || m_mdbfl_filetype || '.' || t_file_refno;
--                                                END IF;
--                                            END IF;

--                                            dbms_output.put_line('m_filename: ' || m_filename);
--                                        END IF;
                                    END IF;

                                    --removing special characters from filename START
                                    m_filename := REPLACE(m_filename,'/','');
                                    m_filename := REPLACE(m_filename,'\','');
                                    m_filename := REPLACE(m_filename,'*','');
                                    m_filename := REPLACE(m_filename,':','');
                                    m_filename := REPLACE(m_filename,'"','');
                                    m_filename := REPLACE(m_filename,'?','');
                                    m_filename := REPLACE(m_filename,'|','');
                                    m_filename := REPLACE(m_filename,'<','');
                                    m_filename := REPLACE(m_filename,'>','');
                                    --removing special characters from filename END

                                    dbms_output.put_line ('m_filename : ' || m_filename);
                                    dbms_output.put_line ('m_product_list  => ' || m_product_list);

                                    IF INSTR (m_product_list, m_derived_product) > 0
                                    THEN
                                        m_mdbfl_param5 := '03CHCKRS|04END';
                                    ELSE
                                        m_mdbfl_param5 := '04END';
                                    END IF;

                                    dbms_output.put_line ('m_banking_channel : ' || m_banking_channel);

--                                    SELECT    NVL(tdkey,'X')
--                                    INTO    m_bic_code
--                                    FROM    tabledetails
--                                    WHERE    tdidcode = 'BANKCHNL_TO_BIC'
--                                    AND        tdvalue = m_banking_channel;

                                    m_bic_code:= NVL(td_get_value('BIC_TO_SWIFTNET',m_banking_channel),'DEFAULT');

                                    dbms_output.put_line ('m_bic_code : ' || m_bic_code);
                                    dbms_output.put_line ('m_institutionid : ' || m_institutionid);

                                    BEGIN
                                        SELECT     path
                                        INTO    m_path
                                        FROM    institutionparameters
                                        WHERE    institutionid = m_institutionid
                                        AND        paramname       = 'SWIFT_FileAct_PROFILE_NAME'
                                        AND        paramvalue    = m_bic_code;
                                    EXCEPTION
                                        WHEN OTHERS
                                        THEN
                                            m_path := NULL;
                                    END;

                                    IF m_path IS NOT NULL
                                    THEN

                                        m_request_type     := get_institution_param_value(m_institutionid,m_path || '.ADVANCE_FILE_ACT.SEPACT','REQUEST_TYPE');
                                        m_auth_user_dn     := get_institution_param_value(m_institutionid,m_path || '.ADVANCE_FILE_ACT.GENERAL','AUTH_USER_DN');
                                        m_requestor_dn     := get_institution_param_value(m_institutionid,m_path || '.ADVANCE_FILE_ACT.GENERAL','REQUESTOR_DN');
                                        m_responder_dn     := get_institution_param_value(m_institutionid,m_path || '.ADVANCE_FILE_ACT.GENERAL','RESPONDER_DN');
                                        m_service_name     := get_institution_param_value(m_institutionid,m_path || '.ADVANCE_FILE_ACT.GENERAL','SERVICE_NAME');
                                        m_file_mode     := get_institution_param_value(m_institutionid,m_path || '.ADVANCE_FILE_ACT.GENERAL','FILE_MODE');
                                        m_nr_flag         := get_institution_param_value(m_institutionid,m_path || '.ADVANCE_FILE_ACT.GENERAL','NR_FLAG');
                                        m_delivery_notif_q := get_institution_param_value(m_institutionid,m_path || '.ADVANCE_FILE_ACT.GENERAL','DELIVERY_NOTIF_Q');
                                        m_ack_request_type := get_institution_param_value(m_institutionid,m_path || '.ADVANCE_FILE_ACT.GENERAL','ACK_REQUEST_TYPE');
                                        m_ack_responder_dn := get_institution_param_value(m_institutionid,m_path || '.ADVANCE_FILE_ACT.GENERAL','ACK_RESPONDER_DN');
                                        m_positive_delivery_notification := get_institution_param_value(m_institutionid,m_path || '.ADVANCE_FILE_ACT.GENERAL','POSITIVE_DELIVERY_NOTIFICATION');

                                        INSERT INTO msgdb_swiftnet
                                        (
                                        msgdb_id,
                                        mdbsn_request_type,
                                        mdbsn_user_dn,
                                        mdbsn_requester_dn,
                                        mdbsn_responder_dn,
                                        mdbsn_service_name,
                                        mdbsn_filemode,
                                        mdbsn_ack_reqd,
                                        mdbsn_ack_responder_dn,
                                        mdbsn_nr_flag,
                                        mdbsn_del_notfq,
                                        mdbsn_ack_reqtype
                                        )
                                        VALUES
                                        (
                                        m_output_file_id,
                                        m_request_type,
                                        m_auth_user_dn,
                                        m_requestor_dn,
                                        m_responder_dn,
                                        m_service_name,
                                        m_file_mode,
                                        m_positive_delivery_notification,
                                        m_ack_responder_dn,
                                        m_nr_flag,
                                        m_delivery_notif_q,
                                        m_ack_request_type
                                        );
                                    END IF;

                                    dbms_output.put_line ('m_mdbfl_param5  => ' || m_mdbfl_param5);
                                    --Generating new file record in MSGDB_FILES table
                                    IF m_mdbfl_param5 is null
                                    THEN
                                            null;
                                        dbms_output.put_line('m_mdbfl_param5 is null');
                                    END IF;
                                    
                                    INSERT INTO msgdb_file
                                          (msgdb_id, mdbfl_filename, mdbfl_extension,
                                           mdbfl_filetype, mdbfl_num_of_msgs,
                                           mdbfl_outputfilename,
                                           mdbfl_outputfileextension, mdbfl_filesize,
                                           mdbfl_bytestransffred, mdbfl_num_of_batches,
                                           mdbfl_debulk_flag, mdbfl_set_id, mdbfl_param4,
                                           mdbfl_param5, mdbfl_zip_file_name,
                                           mdbfl_file_contents
                                          )
                                   VALUES (m_output_file_id, m_filename, p_file_extn,
                                           m_mdbfl_filetype, m_file_tran_count,
                                           NULL,p_file_extn, m_filesize,0,m_btch_ctr,
                                           'Y', 0, m_mdbfl_param4,m_mdbfl_param5, m_filename,
                                           m_file_content
                                          );

                                    m_btch_ctr  := 0;
                                    m_sysdate   := SYSDATE;
                                    g_action    := 'BULKING';
                                    g_audittext := 'FILE bulked with <FILE Name: '''|| m_filename|| '''> and <FILE NUMBER: '''|| m_msgdb_msgeno_file|| '''> with Queue '''|| m_new_file_trgt_queueid|| '''';

                                    --Inserting audit for new file
                                    /*INSERT INTO genaudit
                                              (messageno, auditdatetime,
                                               audittimestamp, sequenceno,
                                               queueid, username,
                                               application, modulename, action,
                                               audittext, institutionid, keyid,
                                           enc_hash_code, datakeyid
                                              )
                                    VALUES (m_msgdb_msgeno_file, m_sysdate,
                                            m_systimestamp, TO_NUMBER(TO_CHAR (SYSTIMESTAMP, 'FF3')),
                                            m_new_file_trgt_queueid, g_username,
                                            g_application, g_modulename, g_action,
                                            g_audittext, m_institutionid, m_keyid,
                                            getencodehashvalue
                                            (   m_msgdb_msgeno_file
                                            || TO_CHAR (m_sysdate,'yyyy-mm-dd HH24:MI:SS')
                                            || TO_NUMBER(TO_CHAR (SYSTIMESTAMP, 'FF3'))
                                            || m_new_file_trgt_queueid
                                            || g_username
                                            || g_application
                                            || g_modulename
                                            || g_action
                                            || g_audittext
                                            || m_treasury_center
                                            || m_keyid,
                                            m_secretkey
                                                      ), m_active_datakeyid
                                           );*/
                                           genaudit_insert_enchash_wrap
                                            (
                                                p_messageno=>m_msgdb_msgeno_file,
                                                p_queueid=>m_new_file_trgt_queueid,
                                                p_username=>g_username,
                                                p_application=>g_application,
                                                p_modulename=>g_modulename,
                                                p_action=>g_action,
                                                p_audittext=>g_audittext,
                                                p_institutionid=>m_institutionid,
                                                p_incr_count=>0
                                            );

                                    dbms_output.put_line('UPDATE FILE STATUS');

                                    UPDATE  msgdb
                                    SET     priorityamount      = TO_CHAR (m_file_amount),
                                            priorityamountnum   = TO_NUMBER (m_file_amount),
                                            custom5             = DECODE(m_org_file_id,0,NULL,'PREV='|| m_org_file_id || '|'|| 'ORFL'|| CHR (191)),
                                            transrefno          = m_msgid,
                                            custom2             = m_msgid
                                    WHERE   msgdb_id            = m_output_file_id;

                                    m_msgdb_id_first    :=  NVL(tran_msgdb_id.FIRST,0);
                                    m_msgdb_id_last     :=  NVL(tran_msgdb_id.LAST,0);
                                    dbms_output.put_line('m_msgdb_id_first '|| m_msgdb_id_first);
                                    dbms_output.put_line('m_msgdb_id_last '|| m_msgdb_id_last);

                                    FORALL i IN m_msgdb_id_first..m_msgdb_id_last
                                    UPDATE  msgdb
                                    SET     custom2     = m_msgid || m_reverse_questionmark || custom2,
                                            groupinginfo_eod = groupinginfo_eod || m_msgid --added msgid to grouping criteria for EOD
                                    WHERE   msgdb_id    = tran_msgdb_id(i);

                                    m_msgdb_id_batch_first  :=  NVL(n_msgdb_batch.first,0);
                                    m_msgdb_id_batch_last   :=  NVL(n_msgdb_batch.last,0);

                                    FORALL i IN m_msgdb_id_batch_first..m_msgdb_id_batch_last
                                    UPDATE  msgdb
                                    SET     custom2     = m_msgid || m_reverse_questionmark|| custom2
                                    WHERE   msgdb_id    = n_msgdb_batch(i).msgdb_id;

                                    INSERT INTO msgdb_links (msgdb_id, TYPE, parent_id, parent_type) VALUES (m_output_file_id, 'F', m_org_file_id, 'F');

                                    update_target_status(tran_msgdb_id(i));

                                    IF m_no_batch_required = 'Y'
                                    THEN
                                        DBMS_LOB.freetemporary (batch_content);
                                        DBMS_LOB.freetemporary (batch_transaction_content);
                                    END IF;

--                                    dbms_output.put_line('m_btl_file_content : '|| UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(m_btl_file_content,4000,1)));
--                                    dbms_output.put_line('m_file_content : '|| utl_raw.cast_to_varchar2(m_file_content));

                                    DBMS_LOB.freetemporary (m_btl_file_content);
                                    DBMS_LOB.freetemporary (m_file_content);
                                    dbms_output.put_line     ('m_file_tran_count_3: '|| m_file_tran_count);

                                    m_file_tran_count   := 0;
                                    m_file_amount       := 0;
                                    m_next_file_gen     := 'Y';
                                    tran_msgdb_id       := a_msgdb_id();
                                    batch_msgdb_id      := a_msgdb_id();
                                END IF;
                            END IF;
                            COMMIT;
                        EXCEPTION
                            WHEN INVALID_CONFIGURATION
                            THEN

                              dbms_output.put_line ('invalid_configuration'|| dbms_utility.format_error_backtrace);
                              ROLLBACK;
                              g_institutionid := m_institutionid;
                              UPDATE msgdb
                              SET status = 204
                              WHERE msgdb_id = m_msgdb_id_batch;

                              genaudit_insert_enchash_wrap
                                 (g_messageno,g_queueid,NULL,'EVNTSRVR','BATCH','MOVE','PROCEDURE: Transaction_Bulking Error Invalid cutoff time configuration '
                                  || m_cutoff_time
                                  || ' Error Code:'
                                  || SQLCODE
                                  || ':'
                                  || SQLERRM,
                                  g_institutionid,
                                  0
                                 );
                            COMMIT;
                        END; -- Third Batch records BEGIN block END
                    END LOOP; -- Loop for batches END

                           COMMIT;
                                IF cur_batch_records1%ISOPEN
                                THEN
                                     CLOSE cur_batch_records1;
                                ELSIF cur_batch_records2%ISOPEN
                                THEN
                                    CLOSE cur_batch_records2;
                                END IF;

                EXCEPTION
                    WHEN NO_BATCHES
                    THEN
                        NULL;
                        dbms_output.put_line ('level7');
                        dbms_output.put_line (SQLERRM);
                        dbms_output.put_line ('No batches found in file number ' || m_org_file_id);

                    WHEN PAYMENT_ONBEHALF
                    THEN
                        NULL;

                    WHEN NO_DATA_FOUND
                    THEN
                        NULL;
                        dbms_output.put_line ('No Data FOUND...');
                        dbms_output.put_line (SQLCODE || SQLERRM || dbms_utility.format_error_backtrace);

                    WHEN INVALID_XML
                    THEN
                        dbms_output.put_line ('invalid_xml'|| dbms_utility.format_error_backtrace);
                        ROLLBACK;
                        IF cur_transaction_records%ISOPEN
                        THEN
                           CLOSE cur_transaction_records;
                        END IF;

                            IF cur_batch_records1%ISOPEN
                                THEN
                                     CLOSE cur_batch_records1;
                                ELSIF cur_batch_records2%ISOPEN
                                THEN
                                    CLOSE cur_batch_records2;
                                END IF;

                        dbms_output.put_line('INVALID_XML'||SQLCODE || SQLERRM || dbms_utility.format_error_backtrace);
                        genaudit_insert_enchash_wrap
                                             (g_messageno,g_queueid,NULL,'EVNTSRVR','FILE','MOVE','Transaction_Bulking Procedure Error : '
                                              || SQLCODE
                                              || ':'
                                              || SQLERRM
                                              || ' File number <'
                                              || g_messageno
                                              || '> read from '
                                              || p_src_file_queueid
                                              || ' Queue and written into '
                                              || g_queueid
                                              || ' Queue',
                                              m_treasury_center,
                                              0
                                             );
                        COMMIT;

                    WHEN OTHERS
                    THEN
                        ROLLBACK;

                        dbms_output.put_line('Others issue: line 1823');
                        dbms_output.put_line(SQLCODE || SQLERRM || dbms_utility.format_error_backtrace);

                        IF cur_transaction_records%ISOPEN
                        THEN
                           CLOSE cur_transaction_records;
                        END IF;

                             IF cur_batch_records1%ISOPEN
                                THEN
                                     CLOSE cur_batch_records1;
                                ELSIF cur_batch_records2%ISOPEN
                                THEN
                                    CLOSE cur_batch_records2;
                                END IF;

                        ROLLBACK;
                        genaudit_insert_enchash_wrap
                        (
                        g_messageno,
                        g_queueid,
                        NULL,
                        g_application,
                        g_modulename,
                        g_action,
                        'transaction_bulking_sepa OTHERS: ' || SQLCODE || SQLERRM || dbms_utility.format_error_backtrace,
                        g_institutionid,
                        0
                        );
                       COMMIT;
                END; -- SECOND File record BEGIN block END

                DBMS_LOB.createtemporary (file_header, TRUE);
                DBMS_LOB.createtemporary (m_btl_file_content_blob, TRUE);
            END LOOP; -- Loop for File records END
        EXCEPTION
            WHEN OTHERS
            THEN
                dbms_output.put_line('Others issue: line 1952');
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
                'transaction_bulking_sepa OTHERS: ' || SQLCODE || SQLERRM || dbms_utility.format_error_backtrace,
                m_institutionid,
                0
                );
               COMMIT;
        END;
    END LOOP; -- closing of cursor institution loop
    DELETE FROM tabledetails WHERE tdidcode = m_proc_exec_tdidcode and tdkey = m_proc_exec_tdkey;
    COMMIT;
EXCEPTION
    WHEN PROC_EXEC_WIP
    THEN
        DELETE FROM tabledetails WHERE tdidcode = m_proc_exec_tdidcode and tdkey = m_proc_exec_tdkey;
        COMMIT;
    WHEN NO_CONFIGURATION_FOUND
    THEN
        dbms_output.put_line('No TableMain entry found for messageclasstype '||p_batch_messageclasstype);
        -- Can we use table name in audit
        genaudit_insert_enchash_wrap
        (
            g_messageno,
            g_queueid,
            NULL,
            'EVNTSRVR',
            'CONFIG',
            'BULKING',
            'PROCEDURE: Transaction_Bulking No TableMain entry found for messageclasstype '||p_batch_messageclasstype,
            g_institutionid,
            0
        );
        DELETE FROM tabledetails WHERE tdidcode = m_proc_exec_tdidcode and tdkey = m_proc_exec_tdkey;
        COMMIT;

    WHEN NO_DATA_FOUND
    THEN
        dbms_output.put_line ('No Data Found.... or passed parameter containing NULL or improper record...');
        ROLLBACK;

        DELETE FROM tabledetails WHERE tdidcode = m_proc_exec_tdidcode and tdkey = m_proc_exec_tdkey;
        COMMIT;
    WHEN DUP_VAL_ON_INDEX
    THEN
        dbms_output.put_line ('DUP_VAL_ON_INDEX');
        dbms_output.put_line (SQLERRM);
    ROLLBACK;

        DELETE FROM tabledetails WHERE tdidcode = m_proc_exec_tdidcode and tdkey = m_proc_exec_tdkey;
        COMMIT;
    WHEN resource_busy
    THEN
        dbms_output.put_line ('level6');
        dbms_output.put_line (SQLERRM);
        ROLLBACK;
        DELETE FROM tabledetails WHERE tdidcode = m_proc_exec_tdidcode and tdkey = m_proc_exec_tdkey;
        COMMIT;
END; -- First BEGIN block END