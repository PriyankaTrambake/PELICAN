create or replace FUNCTION            return_masked_info
(
p_prefix_suffix    IN VARCHAR2,
p_institutionid    IN VARCHAR2,
p_input_data    IN VARCHAR2
)
RETURN VARCHAR2 AS

    m_input_data                   VARCHAR2(32664)     := NULL;
    m_context_name              VARCHAR2(32664)     := NULL;
    m_tenant_list                VARCHAR2(32664)     := NULL;
    m_institution_tenantname    VARCHAR2(32664)     := NULL;

BEGIN

    --m_institution_tenantname := NVL(get_tenantname(p_institutionid),'X');
    --m_institution_tenantname := get_tenantname(p_institutionid);

    --DBMS_OUTPUT.put_line('m_institution_tenantname : ' || m_institution_tenantname);

    IF m_institution_tenantname IS NULL
    THEN

        SELECT paramvalue INTO m_institution_tenantname FROM INSTITUTIONPARAMETERS WHERE INSTITUTIONID = p_institutionid AND PARAMNAME = 'TENANT_NAME';
        --DBMS_OUTPUT.put_line('m_institution_tenantname : ' || m_institution_tenantname);

   ELSE
        m_institution_tenantname := 'X';
        --DBMS_OUTPUT.put_line('Else m_institution_tenantname : ' || m_institution_tenantname);
    END IF;

BEGIN

                  SELECT TDVALUE
                  INTO m_context_name
                  FROM TABLEDETAILS
                  WHERE TDIDCODE ='CONTEXT'
                  AND
                  TDKEY = m_institution_tenantname ;
                        --DBMS_OUTPUT.put_line('m_context_name -->'||m_context_name);

              EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN

                       DBMS_OUTPUT.PUT_LINE ('No CONTEXT found ');
             END;
    m_tenant_list := sys_context(m_context_name,'ENCRYPTION_TENANT_LIST');
    --DBMS_OUTPUT.put_line('m_tenant_list : ' || m_tenant_list);

    IF INSTR(m_tenant_list||',',m_institution_tenantname) > 0
    THEN
        IF p_prefix_suffix = 'PREFIX'
        THEN
            m_input_data := LPAD(SUBSTR(p_input_data,-4,4),length(p_input_data),'X');
            --DBMS_OUTPUT.put_line('m_input_data : ' || m_input_data);
        ELSIF p_prefix_suffix = 'SUFFIX'
        THEN
            m_input_data := RPAD(SUBSTR(p_input_data,1,4),length(p_input_data),'X');
            --DBMS_OUTPUT.put_line('else m_input_data : ' || m_input_data);
        END IF;
    ELSE
        m_input_data := p_input_data;
        --DBMS_OUTPUT.put_line('Else 1 m_input_data'|| m_input_data);
    END IF;

    RETURN  m_input_data;

EXCEPTION
WHEN NO_DATA_FOUND
THEN
    m_input_data := p_input_data;
    RETURN  m_input_data;
END;