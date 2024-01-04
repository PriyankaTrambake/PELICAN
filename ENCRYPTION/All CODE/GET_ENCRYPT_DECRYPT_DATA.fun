create or replace FUNCTION GET_ENCRYPT_DECRYPT_DATA
(
    p_encrypt_decrypt_value IN  VARCHAR2,
    p_institution_id        IN  VARCHAR2,
    p_ip_msg_blob           IN  BLOB
)
RETURN BLOB
IS
    m_enc_msg_blob          BLOB                := EMPTY_BLOB();
    m_dec_msg_blob          BLOB                := EMPTY_BLOB();
    m_op_msg_blob           BLOB                := EMPTY_BLOB();
    m_context_name          VARCHAR2(32664)     := NULL;
    m_active_datakeyid      VARCHAR2(32664)     := NULL;
    m_iv                    RAW(4000)           := NULL;
    m_key                   VARCHAR2(4000)      := NULL;
    m_institution_tenantname VARCHAR2(100)      := NULL;
    m_tenant_list            VARCHAR2(1000)     := NULL;
    l_mod                   PLS_INTEGER         := DBMS_CRYPTO.ENCRYPT_AES256 + DBMS_CRYPTO.CHAIN_CBC + DBMS_CRYPTO.PAD_PKCS5;

BEGIN


    --DBMS_OUTPUT.PUT_LINE(' Inside GET_ENCRYPT_DECRYPT_DATA ');
    --plcn_security_pkg.fetch_data_key('D001','id4CbF0ppzHXjhjxSYLjmCdiqox1ju2Gb/WzA3AApwd8XlM50CDk8q1pxb2KbpbJ');
    DBMS_LOB.CREATETEMPORARY (m_enc_msg_blob, TRUE, dbms_lob.SESSION);
    DBMS_LOB.CREATETEMPORARY (m_dec_msg_blob, TRUE, dbms_lob.SESSION);
    DBMS_LOB.CREATETEMPORARY (m_op_msg_blob, TRUE, dbms_lob.SESSION);

    IF m_institution_tenantname IS NULL
    THEN
    BEGIN
        SELECT paramvalue INTO m_institution_tenantname FROM INSTITUTIONPARAMETERS WHERE INSTITUTIONID = p_institution_id AND PARAMNAME = 'TENANT_NAME';
        EXCEPTION
        WHEN NO_dATA_fOUND
        THEN
            m_institution_tenantname := 'X';
    END;
    --DBMS_OUTPUT.PUT_LINE('m_institution_tenantname : ' || m_institution_tenantname);
    ELSE
    m_institution_tenantname := 'X';
    --DBMS_OUTPUT.PUT_LINE('***Else m_institution_tenantname : ' || m_institution_tenantname);
    END IF;

           BEGIN

                  SELECT TDVALUE
                  INTO m_context_name
                  FROM TABLEDETAILS
                  WHERE TDIDCODE ='CONTEXT'
                  AND TDKEY = m_institution_tenantname ;

               -- DBMS_OUTPUT.put_line('m_context_name -->'||m_context_name);

              EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN

                       DBMS_OUTPUT.PUT_LINE ('No CONTEXT found ');
             END;

             m_tenant_list:= sys_context(m_context_name,'ENCRYPTION_TENANT_LIST');
            -- DBMS_OUTPUT.PUT_LINE ('m_tenant_list ===>'||m_tenant_list);

    IF INSTR(m_institution_tenantname,m_tenant_list,1) > 0 AND p_ip_msg_blob IS NOT NULL
    THEN

    m_active_datakeyid  := sys_context(m_context_name,'ACTIVE_DATAKEYID');
    m_key               := sys_context(m_context_name,m_active_datakeyid);
    m_iv                := UTL_RAW.SUBSTR(DBMS_CRYPTO.HASH(UTL_I18N.STRING_TO_RAW('ACE Software Sol','AL32UTF8' ) ,4/* DBMS_CRYPTO.HASH_SH256 */ ),1,16);

    IF p_encrypt_decrypt_value = 'ENCRYPT'
    THEN
        --DBMS_OUTPUT.PUT_LINE('ENCRYPT');
        DBMS_CRYPTO.ENCRYPT ( dst => m_enc_msg_blob,
                                src => p_ip_msg_blob,
                                typ => l_mod,
                                key => m_key,
                                iv  => m_iv
                              );
        m_op_msg_blob := m_enc_msg_blob;
        --DBMS_OUTPUT.PUT_LINE('Length of p_ip_msg_blob: ' || DBMS_LOB.GETLENGTH(p_ip_msg_blob));
        --DBMS_OUTPUT.PUT_LINE('Length of m_enc_msg_blob: ' || DBMS_LOB.GETLENGTH(m_enc_msg_blob));
        --DBMS_OUTPUT.PUT_LINE('Length of m_op_msg_blob: ' || DBMS_LOB.GETLENGTH(m_op_msg_blob));

    ELSIF p_encrypt_decrypt_value = 'DECRYPT'
    THEN
        --DBMS_OUTPUT.PUT_LINE('DECRYPT');
        DBMS_CRYPTO.DECRYPT ( dst => m_dec_msg_blob,
                                src => p_ip_msg_blob,
                                typ => l_mod,
                                key => m_key,
                                iv  => m_iv
                              );
        m_op_msg_blob := m_dec_msg_blob;
        --DBMS_OUTPUT.PUT_LINE('Length of m_op_msg_blob: ' || DBMS_LOB.GETLENGTH(m_op_msg_blob));
        --DBMS_OUTPUT.PUT_LINE('Length of p_ip_msg_blob: ' || DBMS_LOB.GETLENGTH(p_ip_msg_blob));
        --DBMS_OUTPUT.PUT_LINE('Length of m_dec_msg_blob: ' || DBMS_LOB.GETLENGTH(m_dec_msg_blob));
    END IF;
    ELSE
    m_op_msg_blob:=p_ip_msg_blob;
    END IF;

RETURN m_op_msg_blob;
EXCEPTION
    WHEN OTHERS THEN
    NULL;
    --DBMS_OUTPUT.PUT_LINE('OTHERS GET_ENCRYPT_DECRYPT_DATA : ' || SQLCODE || ':' || SQLERRM || DBMS_UTILITY.format_error_backtrace);
END;