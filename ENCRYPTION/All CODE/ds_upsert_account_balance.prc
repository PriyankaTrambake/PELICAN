create or replace PROCEDURE ds_upsert_account_balance
(
p_queue_id    IN   msgdb.queueid%TYPE,
p_processid   IN   msgdb.process_id%TYPE,
p_data_keyid_list           IN      VARCHAR2,
p_data_key_list             IN      VARCHAR2
)
IS
BEGIN
    plcn_security_pkg.fetch_data_key(p_data_keyid_list,p_data_key_list);
    upsert_account_balance (p_queue_id,p_processid);
END;