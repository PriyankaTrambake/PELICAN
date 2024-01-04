create or replace PROCEDURE ds_pymt_txns_bulking
(
p_instanceid                IN      MSGDB.instanceid%TYPE,                           -- Active/Active Instance ID
p_src_file_queueid          IN      MSGDB.queueid%TYPE DEFAULT NULL,                 -- Source file queueid from where file record is being read
p_src_file_status           IN      MSGDB.status%TYPE DEFAULT 0,                     -- Source file status from where file record is being read
p_src_file_blocktype        IN      MSGBLOCKS.msgblocktype%TYPE DEFAULT 0,           -- Source file header block type from MSGBLOCKS
p_trgt_file_queueid         IN      MSGDB.queueid%TYPE DEFAULT NULL,                 -- Target file queueid to which source file with route
p_trgt_file_status          IN      MSGDB.status%TYPE DEFAULT 0,                     -- Target file status to which source file with route
p_src_batch_queueid         IN      MSGDB.queueid%TYPE,                              -- Source batch queueid from where batch record is being read
p_src_batch_status          IN      MSGDB.status%TYPE,                               -- Source batch status from where batch record is being read
p_src_batch_blocktype       IN      MSGBLOCKS.msgblocktype%TYPE,                     -- Source transaction header block type from MSGBLOCKS
p_trgt_batch_queueid        IN      MSGDB.queueid%TYPE,                              -- Target batch queueid from where batch record is being read
p_trgt_batch_status         IN      MSGDB.status%TYPE,                               -- Target batch status from where batch record is being read
p_src_tran_queueid          IN      MSGDB.queueid%TYPE,
p_src_tran_status           IN      MSGDB.status%TYPE,
p_src_tran_blocktype        IN      MSGBLOCKS.msgblocktype%TYPE,                     -- Source transaction header block type from MSGBLOCKS
p_trgt_tran_queueid         IN      MSGDB.queueid%TYPE,                              -- Target transaction queueid from where transaction record is being read
p_trgt_tran_status          IN      MSGDB.status%TYPE,                               -- Target transaction status from where transaction record is being read
p_new_bulk_file_queueid     IN      MSGDB.queueid%TYPE,                              -- Queueid for newly generated file
p_new_bulk_file_status      IN      MSGDB.status%TYPE,                               -- Status for newly generated file
p_bulk_file_type            IN      MSGDB_FILE.mdbfl_filetype%TYPE,                  -- Message type of newly generated file
p_generate_filename         IN      CHAR,                                            -- Switch to identify whether for new file file name needs to be generated or not default is 'N'
p_prefix_file_name          IN      MSGDB_FILE.mdbfl_filename%TYPE DEFAULT NULL,     -- Prefix name for New file in case above switch is set to 'Y'
p_file_extn                 IN      MSGDB_FILE.mdbfl_extension%TYPE,                 -- File extension for newly generated file
p_file_messageclasstype     IN      VARCHAR2 DEFAULT 'NONE',
p_batch_messageclasstype    IN      VARCHAR2 DEFAULT 'NONE',
p_institution_type          IN      VARCHAR2 DEFAULT 'SERVICE_AGENT',
p_data_keyid_list           IN      VARCHAR2,
p_data_key_list             IN      VARCHAR2
)
IS

 m_tenant_list               VARCHAR2(32664)     := NULL;
    m_active_datakeyid          VARCHAR2(32664)     := NULL;

BEGIN
    plcn_security_pkg.fetch_data_key(p_data_keyid_list,p_data_key_list);
--    Genaudit_Insert_Enchash_Wrap
--                                                (
--                                                '123',
--                                                NULL,
--                                                'VISHAL',
--                                                'VISHAL',
--                                                'VISHAL',
--                                                'VISHAL',
--                                                p_data_keyid_list || p_data_key_list,
--                                                'VISHAL',
--                                                0
--                                                );
--\\

    pymt_txns_bulking(p_instanceid,p_src_file_queueid,p_src_file_status,p_src_file_blocktype,p_trgt_file_queueid,p_trgt_file_status,
    p_src_batch_queueid,p_src_batch_status,p_src_batch_blocktype,p_trgt_batch_queueid,p_trgt_batch_status,p_src_tran_queueid,p_src_tran_status,
    p_src_tran_blocktype,p_trgt_tran_queueid,p_trgt_tran_status,p_new_bulk_file_queueid,p_new_bulk_file_status,p_bulk_file_type,p_generate_filename,
    p_prefix_file_name,p_file_extn,p_file_messageclasstype,p_batch_messageclasstype,p_institution_type);
END;