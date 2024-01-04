create or replace FUNCTION encrypt_decrypt_basedon_session_cntx_clob
(
p_encrypt_decrypt_value IN VARCHAR2,
p_institutionid         IN VARCHAR2,
p_data                  IN CLOB,
p_src_datakeyid         IN VARCHAR2 DEFAULT NULL,
p_trgt_datakeyid        IN VARCHAR2 DEFAULT NULL
)
RETURN CLOB AS

    m_data                      CLOB                := NULL;
    m_context_name              VARCHAR2(32664)     := NULL;
    m_institution_tenantname    VARCHAR2(32664)     := NULL;
    m_tenant_list               VARCHAR2(32664)     := NULL;
    m_active_datakeyid          VARCHAR2(32664)     := NULL;

BEGIN

    BEGIN
        m_institution_tenantname := get_tenantname(p_institutionid);
    EXCEPTION
        WHEN OTHERS
        THEN
            m_institution_tenantname := 'X';
    END;


BEGIN

                  SELECT TDVALUE
                  INTO m_context_name
                  FROM TABLEDETAILS
                  WHERE TDIDCODE ='CONTEXT'
                  AND
                  TDKEY = m_institution_tenantname ;
                        ---DBMS_OUTPUT.put_line('m_context_name -->'||m_context_name);

              EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN

                       DBMS_OUTPUT.PUT_LINE ('No CONTEXT found ');
             END;


    m_tenant_list := sys_context(m_context_name,'ENCRYPTION_TENANT_LIST');

    --IF INSTR(m_tenant_list,m_institution_tenantname||',') > 0
     IF INSTR(m_institution_tenantname,m_tenant_list,1) > 0
     THEN
        m_active_datakeyid := sys_context(m_context_name,'ACTIVE_DATAKEYID');
        IF p_encrypt_decrypt_value = 'ENCRYPT'
        THEN
            IF p_src_datakeyid IS NOT NULL AND p_trgt_datakeyid IS NOT NULL AND p_src_datakeyid != p_trgt_datakeyid
            THEN
                m_data := get_decrypted_data(p_data,sys_context(m_context_name,p_trgt_datakeyid));
                m_data := get_encrypted_data(m_data,sys_context(m_context_name,p_src_datakeyid));
            ELSIF p_src_datakeyid IS NOT NULL AND p_trgt_datakeyid IS NULL
            THEN
                m_data := get_encrypted_data(p_data,sys_context(m_context_name,p_src_datakeyid));
            ELSIF p_src_datakeyid IS NULL AND p_trgt_datakeyid IS NULL
            THEN
                m_data := get_encrypted_data(p_data,sys_context(m_context_name,m_active_datakeyid));
            END IF;
        ELSIF p_encrypt_decrypt_value = 'DECRYPT'
        THEN
            IF p_src_datakeyid IS NOT NULL AND p_trgt_datakeyid IS NULL
            THEN
                m_data := get_decrypted_data(p_data,sys_context(m_context_name,p_src_datakeyid));
            ELSIF p_src_datakeyid IS NULL AND p_trgt_datakeyid IS NULL
            THEN
                m_data := get_decrypted_data(p_data,sys_context(m_context_name,m_active_datakeyid));
            END IF;
        END IF;
    ELSE
        m_data := p_data;
    END IF;

    RETURN  m_data;

EXCEPTION
WHEN OTHERS
THEN
    DBMS_OUTPUT.put_line('Level 8');
    RETURN p_data;
END;