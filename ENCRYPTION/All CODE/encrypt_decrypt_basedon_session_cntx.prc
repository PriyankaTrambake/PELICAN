create or replace FUNCTION            encrypt_decrypt_basedon_session_cntx
(
p_encrypt_decrypt_value IN VARCHAR2,
p_institutionid         IN VARCHAR2,
p_data                  IN VARCHAR2,
p_src_datakeyid         IN VARCHAR2 DEFAULT NULL,
p_trgt_datakeyid        IN VARCHAR2 DEFAULT NULL
)
RETURN VARCHAR2 AS

    m_data                      VARCHAR2(32664)     := NULL;
    m_context_name              VARCHAR2(32664)     := NULL;
    m_institution_tenantname    VARCHAR2(32664)     := NULL;
    m_tenant_list               VARCHAR2(32664)     := NULL;
    m_active_datakeyid          VARCHAR2(32664)     := NULL;

BEGIN

        --m_institution_tenantname := get_tenantname(p_institutionid);
        --DBMS_OUTPUT.put_line('m_institution_tenantname : ' || m_institution_tenantname);

        --m_institution_tenantname := 'X';
        --DBMS_OUTPUT.put_line('Exception m_institution_tenantname : ' || m_institution_tenantname);

        IF m_institution_tenantname IS NULL
        THEN
                    DBMS_OUTPUT.put_line('p_institutionid : ' || p_institutionid);

            SELECT paramvalue INTO m_institution_tenantname FROM INSTITUTIONPARAMETERS WHERE INSTITUTIONID = p_institutionid AND PARAMNAME = 'TENANT_NAME';
            DBMS_OUTPUT.put_line('m_institution_tenantname : ' || m_institution_tenantname);
        ELSE
            m_institution_tenantname := 'XXXX';
            --DBMS_OUTPUT.put_line('***Else m_institution_tenantname : ' || m_institution_tenantname);
        END IF;



BEGIN
m_institution_tenantname:='PLNT01';
       DBMS_OUTPUT.PUT_LINE('p_Data '|| p_Data);
                  SELECT TDVALUE
                  INTO m_context_name
                  FROM TABLEDETAILS
                  WHERE TDIDCODE ='CONTEXT'
                  AND
                  TDKEY = m_institution_tenantname ;
                        DBMS_OUTPUT.put_line('m_context_name -->'||m_context_name);

              EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN

                       DBMS_OUTPUT.PUT_LINE ('No CONTEXT found ');
             END;
    m_tenant_list := sys_context(m_context_name,'ENCRYPTION_TENANT_LIST');
    DBMS_OUTPUT.put_line('m_tenant_list : ' || m_tenant_list);

    IF INSTR(m_institution_tenantname,m_tenant_list,1) > 0 AND p_data IS NOT NULL--INSTR(m_tenant_list,m_institution_tenantname||',') > 0
    THEN
        m_active_datakeyid := sys_context(m_context_name,'ACTIVE_DATAKEYID');
        DBMS_OUTPUT.put_line('m_active_datakeyid : ' || m_active_datakeyid);

        IF p_encrypt_decrypt_value = 'ENCRYPT'
        THEN
            IF p_src_datakeyid IS NOT NULL AND p_trgt_datakeyid IS NOT NULL AND p_src_datakeyid != p_trgt_datakeyid
            THEN
                m_data := get_decrypted_data(p_data,sys_context(m_context_name,p_trgt_datakeyid));
                m_data := get_encrypted_data(m_data,sys_context(m_context_name,p_src_datakeyid));
                DBMS_OUTPUT.put_line('Level 1');
            ELSIF p_src_datakeyid IS NOT NULL AND p_trgt_datakeyid IS NULL
            THEN
                m_data := get_encrypted_data(p_data,sys_context(m_context_name,p_src_datakeyid));
                DBMS_OUTPUT.put_line('Level 2');
            ELSIF p_src_datakeyid IS NULL AND p_trgt_datakeyid IS NULL
            THEN
                DBMS_OUTPUT.put_line('Level 3 : ' || p_data || ' m_context_name : ' || m_context_name || ' m_active_datakeyid : ' || m_active_datakeyid);
                m_data := get_encrypted_data(p_data,sys_context(m_context_name,m_active_datakeyid));
                DBMS_OUTPUT.put_line('Level 3');
            END IF;
        ELSIF p_encrypt_decrypt_value = 'DECRYPT'
        THEN
            IF p_src_datakeyid IS NOT NULL AND p_trgt_datakeyid IS NULL
            THEN
                m_data := get_decrypted_data(p_data,sys_context(m_context_name,p_src_datakeyid));
                DBMS_OUTPUT.put_line('Level 4');
            ELSIF p_src_datakeyid IS NULL AND p_trgt_datakeyid IS NULL
            THEN
                m_data := get_decrypted_data(p_data,sys_context(m_context_name,m_active_datakeyid));
                DBMS_OUTPUT.put_line('Level 5');
            END IF;
        END IF;
    ELSE
        m_data := p_data;
        --RAISE NO_DATA_FOUND;
        DBMS_OUTPUT.put_line('Level 6 : ' || m_data);
    END IF;

    RETURN  m_data;

EXCEPTION
WHEN NO_DATA_FOUND
THEN
    m_data := p_data;
    RETURN  m_data;
    DBMS_OUTPUT.put_line('No data found.');

END;