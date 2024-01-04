create or replace PROCEDURE ds_EOD_FILE_BULKING
(
    p_queueid     IN      msgdb.queueid%TYPE,                              -- Queueid for newly generated file
    p_status      IN      msgdb.status%TYPE,
    p_instanceid  IN      MSGDB.instanceid%TYPE,
    p_data_keyid_list           IN      VARCHAR2,
    p_data_key_list             IN      VARCHAR2
)
IS
BEGIN
    plcn_security_pkg.fetch_data_key(p_data_keyid_list,p_data_key_list);
    EOD_FILE_BULKING(p_queueid,p_status,p_instanceid);
END;