create or replace FUNCTION msgblocks_tampered_check
(
p_msgdb_id     IN MSGBLOCKS.MSGDB_ID%TYPE,
p_msgblocktype IN MSGBLOCKS.MSGBLOCKTYPE%TYPE
)
RETURN VARCHAR2
IS
    m_internalkey               KEYPASSWORD.KEY%TYPE            := NULL;
    m_endtoendreq_tdidcode      TABLEDETAILS.tdidcode%TYPE      := 'ACE_SECURITY';
    m_endtoendreq_tdkey         TABLEDETAILS.tdkey%TYPE         := 'END2END_REQUIRED';
    m_endtoendreq               TABLEDETAILS.tdvalue%TYPE       := NULL;
    m_auth_code                 MSGBLOCKS.authcode%TYPE         := NULL;
    m_encryption_type           VARCHAR2(20)                    := NULL;
    m_isaudittampered           VARCHAR2(1)                     := NULL;
    m_msg_clob                  NCLOB                           := NULL;
    m_message                   msgblocks.message%TYPE          := NULL;
    m_msg_keyid                 MSGBLOCKS.key_id%TYPE           := NULL;
    m_msg_authcode              MSGBLOCKS.authcode%TYPE         := NULL;
    m_db_characterset           VARCHAR2(5000)                  := NULL;
    m_was_characterset          VARCHAR2(5000)                  := NULL;
    m_paramname                         INSTITUTIONPARAMETERS.PARAMNAME%TYPE    := 'TENANT_NAME';
    m_path                              INSTITUTIONPARAMETERS.PATH%TYPE         := 'INSTITUTION_DETAILS';
    m_tenant_list                       VARCHAR2(3000)                  := NULL;
    m_tenantname                        VARCHAR2(3000)                  := NULL;
    m_context_name                      VARCHAR2(3000)                  := NULL;
    m_institutionid                        MSGDB.institutionid%TYPE            := NULL;
    m_message_clob                              clob;

    
BEGIN
    m_endtoendreq         := UPPER(NVL(TD_GET_VALUE(m_endtoendreq_tdidcode, m_endtoendreq_tdkey),'NO'));
 
    SELECT  institutionid
    INTO    m_institutionid
    FROM  msgdb 
    WHERE  msgdb_id = p_msgdb_id;

    
      m_tenantname   := NVL(Get_Institution_Param_Value(m_institutionid,m_path,m_paramname),'XXX');

            BEGIN 

                  SELECT TDVALUE
                  INTO m_context_name
                  FROM TABLEDETAILS 
                  WHERE TDIDCODE ='CONTEXT' 
                  AND 
                  TDKEY = m_tenantname ;

              EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN

                       DBMS_OUTPUT.PUT_LINE ('No CONTEXT found ');
            END;

        m_tenant_list := sys_context(m_context_name,'ENCRYPTION_TENANT_LIST');

    
    IF         m_endtoendreq = 'NO'
    THEN
        m_isaudittampered     := 'N';
    ELSIF     m_endtoendreq = 'YES'
    THEN
   
                      
        IF INSTR(m_tenant_list,m_tenantname) > 0
        THEN

             SELECT encrypt_decrypt_basedon_session_cntx_clob('DECRYPT',m_institutionid,v_blobtoclob(message)),
                    key_id,
                    authcode
             INTO   m_message_clob,
                    m_msg_keyid,
                    m_msg_authcode
              FROM     msgblocks
              WHERE     msgdb_id = p_msgdb_id
              AND        msgblocktype = p_msgblocktype;
            
            m_message := CLOB_TO_BLOB(m_message_clob);
        
      ELSE

             SELECT  message,
                     key_id,
                     authcode
             INTO    m_message,
                     m_msg_keyid,
                     m_msg_authcode
             FROM     msgblocks
            WHERE     msgdb_id = p_msgdb_id
            AND        msgblocktype = p_msgblocktype;
       END IF;

        IF INSTR(m_tenant_list,m_tenantname) > 0
        THEN
                 m_msg_clob        := encrypt_decrypt_basedon_session_cntx_clob('DECRYPT',m_institutionid,Blob_To_nClob(p_msgdb_id, p_msgblocktype));
        ELSE 

                m_msg_clob        := Blob_To_nClob(p_msgdb_id, p_msgblocktype);
        END IF;
        m_encryption_type := TD_GET_VALUE('ACE_SECURITY', 'ENCRYPTION_TYPE');

        BEGIN
            IF m_encryption_type = 'AES'
            THEN
                SELECT aes_decrypt_string(key)
                INTO   m_internalkey
                FROM   keypassword
                WHERE  key_id = m_msg_keyid;
            ELSIF  m_encryption_type = 'ACE'
            THEN
                SELECT ace_decryption_string(key)
                INTO   m_internalkey
                FROM   keypassword
                WHERE  key_id = m_msg_keyid;
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                --DBMS_OUTPUT.PUT_LINE('Input Key is not valid or does not match' || dbms_utility.format_error_backtrace);
                m_isaudittampered     := 'X';
                RETURN m_isaudittampered;
        END;

        SELECT  property_value
        INTO    m_db_characterset
        FROM    database_properties
        WHERE   property_name in ('NLS_CHARACTERSET');

        m_was_characterset:= NVL(TD_GET_VALUE('GLOBVAR','WAS_CHARACTERSET'),m_db_characterset);
        
        IF m_db_characterset = m_was_characterset
        THEN
            NULL;
        ELSE
            m_msg_clob := Blob_To_uClob(m_message,m_was_characterset);
        END IF;

        m_auth_code := Generatehmacsha256data(m_msg_clob ,m_internalkey);

        DBMS_OUTPUT.PUT_LINE('Generated m_auth_code: ' || m_auth_code);
        --DBMS_OUTPUT.PUT_LINE('Pre-Calculated m_msg_authcode: ' || m_msg_authcode);

        IF m_auth_code = m_msg_authcode
        THEN
            m_isaudittampered     := 'N';
        ELSE
            m_isaudittampered     := 'Y';
        END IF;
    END IF;
    RETURN m_isaudittampered;
EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
        DBMS_OUTPUT.PUT_LINE('Invalid MSGDB_ID or MSGBLOCKTYPE' || dbms_utility.format_error_backtrace);
                m_isaudittampered     := 'X';
            RETURN m_isaudittampered;
    WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE(SQLCODE || ' - ' || SQLERRM || dbms_utility.format_error_backtrace);
                m_isaudittampered     := 'X';
            RETURN m_isaudittampered;
END;