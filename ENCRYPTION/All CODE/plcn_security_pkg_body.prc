create or replace PACKAGE BODY plcn_security_pkg
AS
    PROCEDURE fetch_data_key
    (
    p_data_keyid_list    IN VARCHAR2,
    p_data_key_list      IN VARCHAR2
    )
    IS
        m_string_count              NUMBER                  := 0;
        n_string_count              NUMBER                  := 0;
        m_data_keyid_list           VARCHAR2(32664)           := NULL;
        m_data_key_list             VARCHAR2(32664)           := NULL;
        m_context_name                VARCHAR2(32664)            := NULL;
        m_active_datakeyid            DATAKEYSTORE.datakeyid%type    := NULL;
        m_encryption_tenant_list    VARCHAR2(32664)           := NULL;
        m_encryption_timestamp      TIMESTAMP                 := NULL;
        m_datakeyid_tenant          VARCHAR2(30)              := NULL;
        m_tenant_list                VARCHAR2(30)              := NULL;

    BEGIN
--        IF p_data_key_list IS NOT NULL
--        THEN
--			m_data_key_list := aes_decrypt_string(p_data_key_list);
--			dbms_output.put_line(m_data_key_list);
--        END IF;

        -- setting datakeyids and datakeys
        IF p_data_keyid_list IS NOT NULL AND p_data_key_list IS NOT NULL
        THEN
        
        dynamic_context();
       
        IF instr(p_data_keyid_list,'|') > 0 AND INSTR(p_data_key_list,'|') > 0
        THEN
            m_string_count := LENGTH(p_data_keyid_list)-LENGTH(REPLACE(p_data_keyid_list,'|',''))+1;

            -- DBMS_OUTPUT.put_line('m_string_count ==> ' || m_string_count);

            FOR i in 1..m_string_count
            LOOP
                DBMS_OUTPUT.put_line('i IN ==> ' || i);

                m_data_keyid_list := getstringitemwithsep(p_data_keyid_list,i,'|');
                m_data_key_list   := aes_decrypt_string(getstringitemwithsep(p_data_key_list,i,'|'));
                m_data_key_list   := UTL_ENCODE.BASE64_DECODE(utl_raw.cast_to_raw(m_data_key_list));

                BEGIN
                    SELECT tenant_name
                    INTO m_tenant_list
                    FROM datakeystore
                    WHERE datakeyid = m_data_keyid_list
                    AND STATUS='ACTIVE';
                   DBMS_OUTPUT.put_line('m_tenant_list ==> '||m_tenant_list);
                    m_context_name:= TD_GET_VALUE('CONTEXT',m_tenant_list);

                EXCEPTION
                WHEN NO_DATA_FOUND
                THEN
                    dbms_output.put_line('no context present');
                END;
               DBMS_OUTPUT.put_line('m_context_name ==> '||m_context_name);

                DBMS_SESSION.set_context(m_context_name,m_data_keyid_list,m_data_key_list);


            SELECT REPLACE(TDIDCODE,'_ENC_MASK')
            INTO    m_encryption_tenant_list
            FROM (SELECT  listagg(TDIDCODE,',') WITHIN GROUP (ORDER BY tdidcode) TDIDCODE
            FROM    tabledetails
            WHERE   tdidcode =  m_tenant_list ||'_ENC_MASK'
            AND     tdkey = 'ENCRYPTION_FLAG'
            AND     tdvalue = 'YES');

          DBMS_OUTPUT.put_line('m_encryption_tenant_list ==> '||m_encryption_tenant_list);

            DBMS_SESSION.set_context(m_context_name,'ENCRYPTION_TENANT_LIST',m_encryption_tenant_list);

--            n_string_count:= LENGTH(m_encryption_tenant_list)-LENGTH(REPLACE(m_encryption_tenant_list,',',''))+1;
--        DBMS_OUTPUT.PUT_LINE('n_string_count ' ||  n_string_count);
--        FOR i in 1..n_string_count
--        LOOP
            SELECT	datakeyid,tenant_name
            INTO    m_active_datakeyid,m_datakeyid_tenant
            FROM    DATAKEYSTORE
            WHERE   status = 'ACTIVE'
            AND     tenant_name = m_encryption_tenant_list;
            DBMS_OUTPUT.PUT_LINE('m_active_datakeyid ' ||  m_active_datakeyid);
            DBMS_OUTPUT.PUT_LINE('m_datakeyid_tenant ' ||  m_datakeyid_tenant);
            DBMS_SESSION.set_context(m_context_name,m_datakeyid_tenant,m_active_datakeyid);
            DBMS_SESSION.set_context(m_context_name,'ACTIVE_DATAKEYID',m_active_datakeyid);
            DBMS_OUTPUT.PUT_LINE('m_active_datakeyid after ' ||  m_active_datakeyid);



        SELECT  TO_TIMESTAMP(tdvalue,'YYYY-MM-DD HH24:MI:SS.FF3')
        INTO    m_encryption_timestamp
        FROM    tabledetails
        WHERE  TDIDCODE = m_datakeyid_tenant||'_ENC_MASK'
        AND     tdkey = 'ENCRYPTION_TIMESTAMP';

        DBMS_OUTPUT.PUT_LINE('m_encryption_timestamp ' ||  m_encryption_timestamp);
        DBMS_SESSION.set_context(m_context_name,'ENCRYPTION_TIMESTAMP',m_encryption_timestamp);
        END LOOP;

        ELSE
            m_data_key_list   := aes_decrypt_string(p_data_key_list);
            m_data_key_list   := UTL_ENCODE.BASE64_DECODE(utl_raw.cast_to_raw(m_data_key_list));
            SELECT tenant_name
            INTO m_tenant_list
            FROM datakeystore
            WHERE datakeyid = p_data_keyid_list
            AND STATUS='ACTIVE';
            DBMS_OUTPUT.put_line('m_tenant_list ==> '||m_tenant_list);
            m_context_name:= TD_GET_VALUE('CONTEXT',m_tenant_list);
            DBMS_OUTPUT.put_line('m_context_name ==> '||m_context_name);
            DBMS_SESSION.set_context(m_context_name,p_data_keyid_list,m_data_key_list);
            SELECT REPLACE(TDIDCODE,'_ENC_MASK')
            INTO    m_encryption_tenant_list
            FROM (SELECT  listagg(TDIDCODE,',') WITHIN GROUP (ORDER BY tdidcode) TDIDCODE
            FROM    tabledetails
            WHERE   tdidcode like m_tenant_list|| '_ENC_MASK'
            AND     tdkey = 'ENCRYPTION_FLAG'
            AND     tdvalue = 'YES');
            DBMS_OUTPUT.put_line('ELSE  IN 3==> ');
            DBMS_OUTPUT.put_line('m_encryption_tenant_list ==> '||m_encryption_tenant_list);

            DBMS_SESSION.set_context(m_context_name,'ENCRYPTION_TENANT_LIST',m_encryption_tenant_list);


            SELECT	datakeyid,tenant_name
            INTO    m_active_datakeyid,m_datakeyid_tenant
            FROM    DATAKEYSTORE
            WHERE   status = 'ACTIVE'
            AND     tenant_name = m_encryption_tenant_list;
            DBMS_OUTPUT.PUT_LINE('m_active_datakeyid ' ||  m_active_datakeyid);
            DBMS_OUTPUT.PUT_LINE('m_datakeyid_tenant ' ||  m_datakeyid_tenant);
            DBMS_SESSION.set_context(m_context_name,m_datakeyid_tenant,m_active_datakeyid);
            DBMS_SESSION.set_context(m_context_name,'ACTIVE_DATAKEYID',m_active_datakeyid);
            DBMS_OUTPUT.PUT_LINE('m_active_datakeyid after ' ||  m_active_datakeyid);



        SELECT  TO_TIMESTAMP(tdvalue,'YYYY-MM-DD HH24:MI:SS.FF3')
        INTO    m_encryption_timestamp
        FROM    tabledetails
        WHERE  TDIDCODE = m_datakeyid_tenant||'_ENC_MASK'
        AND     tdkey = 'ENCRYPTION_TIMESTAMP';

        DBMS_OUTPUT.PUT_LINE('m_encryption_timestamp ' ||  m_encryption_timestamp);
        DBMS_SESSION.set_context(m_context_name,'ENCRYPTION_TIMESTAMP',m_encryption_timestamp);
        DBMS_OUTPUT.PUT_LINE('m_encryption_timestamp ' ||  m_encryption_timestamp);
        END IF;

        -- setting active datakeyid
--        SELECT	datakeyid
--        INTO    m_active_datakeyid
--        FROM    DATAKEYSTORE
--        WHERE   status = 'ACTIVE';
--
--        DBMS_SESSION.set_context(m_context_name,'ACTIVE_DATAKEYID',m_active_datakeyid);

        -- setting tenant list
--        SELECT REPLACE(TDIDCODE,'_ENC_MASK')
--        INTO    m_encryption_tenant_list
--        FROM (SELECT  listagg(TDIDCODE,',') WITHIN GROUP (ORDER BY tdidcode) TDIDCODE
--        FROM    tabledetails
--        WHERE   tdidcode like '%ENC_MASK%'
--        AND     tdkey = 'ENCRYPTION_FLAG'
--        AND     tdvalue = 'YES');

        --m_encryption_tenant_list := getstringitemwithsep(m_encryption_tenant_list,1,'_');
        DBMS_OUTPUT.put_line('3 ==> ' || m_string_count);

        --DBMS_SESSION.set_context(m_context_name,'ENCRYPTION_TENANT_LIST',m_encryption_tenant_list);

        n_string_count:= LENGTH(m_encryption_tenant_list)-LENGTH(REPLACE(m_encryption_tenant_list,',',''))+1;
        --DBMS_OUTPUT.PUT_LINE('n_string_count ' ||  n_string_count);
        FOR i in 1..n_string_count
        LOOP
            SELECT	datakeyid,tenant_name
            INTO    m_active_datakeyid,m_datakeyid_tenant
            FROM    DATAKEYSTORE
            WHERE   status = 'ACTIVE'
            AND     tenant_name = getstringitemwithsep(m_encryption_tenant_list,i,',');
            DBMS_OUTPUT.PUT_LINE('m_active_datakeyid ' ||  m_active_datakeyid);
            DBMS_OUTPUT.PUT_LINE('m_datakeyid_tenant ' ||  m_datakeyid_tenant);
            DBMS_SESSION.set_context(m_context_name,m_datakeyid_tenant,m_active_datakeyid);
            DBMS_SESSION.set_context(m_context_name,'ACTIVE_DATAKEYID',m_active_datakeyid);
            DBMS_OUTPUT.PUT_LINE('m_active_datakeyid after ' ||  m_active_datakeyid);



        SELECT  TO_TIMESTAMP(tdvalue,'YYYY-MM-DD HH24:MI:SS.FF3')
        INTO    m_encryption_timestamp
        FROM    tabledetails
        WHERE  TDIDCODE = m_datakeyid_tenant||'_ENC_MASK'
        AND     tdkey = 'ENCRYPTION_TIMESTAMP';

        DBMS_SESSION.set_context(m_context_name,'ENCRYPTION_TIMESTAMP',m_encryption_timestamp);

    END LOOP;
  END IF;  
    EXCEPTION
        WHEN OTHERS
        THEN
			DBMS_OUTPUT.put_line('fetch_data_key'||SQLCODE||':'||SQLERRM|| DBMS_UTILITY.format_error_backtrace);
	END;
END;