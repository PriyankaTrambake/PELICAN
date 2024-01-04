create or replace FUNCTION get_decrypted_data
(
p_data      IN VARCHAR2,
p_datakey   IN VARCHAR2
)
RETURN VARCHAR2 AS
    m_iv                RAW(2000)           := NULL;
    m_key               RAW(2000)           := NULL;
    m_data              VARCHAR2(32767)      := NULL;
    l_mod               PLS_INTEGER         := DBMS_CRYPTO.ENCRYPT_AES256 + DBMS_CRYPTO.CHAIN_CBC + DBMS_CRYPTO.PAD_PKCS5;
    v_decrypt           VARCHAR2(32767)       := NULL;
    v_varchar_final     VARCHAR2(32767)      := NULL;

BEGIN

    m_data := UTL_ENCODE.BASE64_DECODE(UTL_I18N.STRING_TO_RAW(p_data,'AL32UTF8'));
    DBMS_OUTPUT.put_line('m_data: ' || m_data);

    m_iv := UTL_RAW.SUBSTR(DBMS_CRYPTO.HASH(UTL_I18N.STRING_TO_RAW('ACE Software Sol','AL32UTF8' ) ,4/* DBMS_CRYPTO.HASH_SH256 */ ),1,16);
    DBMS_OUTPUT.put_line('m_iv: ' || m_iv);

    --m_key   := AES_DECRYPT_STRING(p_datakey,'Y');
    m_key   := p_datakey;
	DBMS_OUTPUT.put_line('m_key: ' || m_key);

	v_decrypt := DBMS_CRYPTO.DECRYPT
                  (
                     src => m_data,
                     typ => l_mod,
                     key => m_key,
                     iv  => m_iv
                  );

    v_varchar_final := UTL_I18N.RAW_TO_CHAR(v_decrypt, 'AL32UTF8');
    DBMS_OUTPUT.put_line('v_decrypt: ' || v_decrypt);

    RETURN  v_varchar_final;
EXCEPTION
WHEN OTHERS
THEN
    DBMS_OUTPUT.put_line('fetch_data_key'||SQLCODE||':'||SQLERRM);
END;