create or replace PACKAGE plcn_security_pkg
AS
PROCEDURE fetch_data_key
(
p_data_keyid_list    IN VARCHAR2,
p_data_key_list      IN VARCHAR2
);
END;