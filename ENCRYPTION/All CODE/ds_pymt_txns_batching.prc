create or replace PROCEDURE ds_pymt_txns_batching
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
    p_bulking_filetype              IN msgdb.MSDA%type,
    p_data_keyid_list           IN      VARCHAR2,
    p_data_key_list             IN      VARCHAR2
)
IS
BEGIN


    plcn_security_pkg.fetch_data_key(p_data_keyid_list,p_data_key_list);
    pymt_txns_batching(p_instanceid,p_src_fq_qid,p_src_fq_status_old,p_src_fq_status_new,
    p_src_bq_qid,p_src_bq_status,p_trgt_bq_qid,p_trgt_bq_status,p_src_tq_qid,
    p_src_tq_messageclasstype,p_src_tq_status,p_trgt_tran_queueid,p_trgt_tran_status,
    p_messagedirection,p_institution_type,p_bulking_filetype);
END;