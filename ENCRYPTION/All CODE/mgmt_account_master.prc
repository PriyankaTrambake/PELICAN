create or replace PROCEDURE mgmt_account_master
(
p_action                    VARCHAR2,
p_institution_id            ACCOUNT_MASTER.institution_id%TYPE,
p_customer_id               ACCOUNT_MASTER.customer_id%TYPE,
p_bank_code                 ACCOUNT_MASTER.bank_code%TYPE,
p_branch                    ACCOUNT_MASTER.branch%TYPE,
p_account_number            ACCOUNT_MASTER.account_number%TYPE,
p_account_iban              ACCOUNT_MASTER.account_iban%TYPE,
p_account_type              ACCOUNT_MASTER.account_type%TYPE,
p_account_curr              ACCOUNT_MASTER.account_curr%TYPE,
p_credit_limit              ACCOUNT_MASTER.credit_limit%TYPE,
p_account_desc              ACCOUNT_MASTER.account_desc%TYPE,
p_country_code              ACCOUNT_MASTER.country_code%TYPE,
p_account_status            ACCOUNT_MASTER.account_status%TYPE,
p_account_updatedby         ACCOUNT_MASTER.account_updatedby%TYPE,
p_account_validatedby       ACCOUNT_MASTER.account_validatedby%TYPE,
p_crscheme_id               ACCOUNT_MASTER.crscheme_id%TYPE,
p_account_addl_property     ACCOUNT_MASTER.account_addl_property%TYPE,
p_input_channel             ACCOUNT_MASTER.input_channel%TYPE,
p_account_title             ACCOUNT_MASTER.account_title%TYPE,
p_account_id                ACCOUNT_MASTER.account_id%TYPE,
p_bank_name                 ACCOUNT_MASTER.bank_name%TYPE,
p_image_url                 ACCOUNT_MASTER.image_url%TYPE,
p_account_mode              ACCOUNT_MASTER.account_mode%TYPE,
p_acc_customer_id           ACCOUNT_MASTER.customer_id%TYPE,
p_AccountSchemeId           ACCOUNT_MASTER.crscheme_id%TYPE,
p_defaultaccount_flag            account_master.DEFAULT_ACCOUNT_FLAG%type,
p_created_by                ACCOUNT_MASTER.userid%type
)
AS

    m_institution_id            ACCOUNT_MASTER.institution_id%TYPE          := NULL;
    m_customer_id               ACCOUNT_MASTER.customer_id%TYPE             := NULL;
    m_bank_code                 ACCOUNT_MASTER.bank_code%TYPE               := NULL;
    m_branch                    ACCOUNT_MASTER.branch%TYPE                  := NULL;
    m_account_number            ACCOUNT_MASTER.account_number%TYPE          := NULL;
    m_account_iban              ACCOUNT_MASTER.account_iban%TYPE            := NULL;
    m_account_type              ACCOUNT_MASTER.account_type%TYPE            := NULL;
    m_account_curr              ACCOUNT_MASTER.account_curr%TYPE            := NULL;
    m_credit_limit              ACCOUNT_MASTER.credit_limit%TYPE            := NULL;
    m_account_desc              ACCOUNT_MASTER.account_desc%TYPE            := NULL;
    m_country_code              ACCOUNT_MASTER.country_code%TYPE            := NULL;
    m_account_status            ACCOUNT_MASTER.account_status%TYPE          := NULL;
    m_account_updatedby         ACCOUNT_MASTER.account_updatedby%TYPE       := NULL;
    m_account_validatedby       ACCOUNT_MASTER.account_validatedby%TYPE     := NULL;
    m_crscheme_id               ACCOUNT_MASTER.crscheme_id%TYPE             := NULL;
    m_account_addl_property     ACCOUNT_MASTER.account_addl_property%TYPE   := NULL;
    m_input_channel             ACCOUNT_MASTER.input_channel%TYPE           := NULL;
m_action                  VARCHAR2(15)                                  := NULL;
    m_account_title             ACCOUNT_MASTER.account_title%TYPE           := NULL;
    m_account_id                ACCOUNT_MASTER.account_id%TYPE              := NULL;
    m_bank_name                 ACCOUNT_MASTER.bank_name%TYPE               := NULL;
    m_accountMode               ACCOUNT_MASTER.account_mode%TYPE            := NULL;
    m_accountSchemeId           ACCOUNT_MASTER.crscheme_id%TYPE             := NULL;
    m_accountCustomerId         ACCOUNT_MASTER.customer_id%TYPE             := NULL;
    m_defaultaccount_flag       ACCOUNT_MASTER.default_account_flag%TYPE    := NULL;
    m_created_by                ACCOUNT_MASTER.userid%type                    := NULL;
m_account_no_seq            NUMBER := 0;
m_count                   NUMBER                                     :=0;
    m_count1                    NUMBER                                      := 0;

    --m_action                    VARCHAR2(15)                                := NULL;
    m_encrypt                   VARCHAR2(10)                                := 'ENCRYPT';
    m_suffix                    VARCHAR2(10)                                := 'SUFFIX';
    m_prefix                    VARCHAR2(10)                                := 'PREFIX';
    m_context_name              VARCHAR2(32664)                             := NULL;
        m_tennant_name              VARCHAR2(255)                                  := NULL;

m_institution_tenantname    VARCHAR2(32664)     := NULL;
    m_active_datakeyid                  VARCHAR2(32664)                             := NULL;



BEGIN
    m_action                 := p_action;
    m_institution_id         := p_institution_id;
    m_customer_id            := p_customer_id;
    m_bank_code              := p_bank_code;
    m_branch                 := p_branch;
    m_account_number         := p_account_number;
    m_account_iban           := p_account_iban;
    m_account_type           := p_account_type;
    m_account_curr           := p_account_curr;
    m_credit_limit           := p_credit_limit;
    m_account_desc           := p_account_desc;
    m_country_code           := p_country_code;
    m_account_status         := p_account_status;
    m_account_updatedby      := p_account_updatedby;
    m_account_validatedby    := p_account_validatedby;
    m_crscheme_id            := p_crscheme_id;
    m_account_addl_property  := p_account_addl_property;
    m_input_channel          := p_input_channel;
    m_account_title          := p_account_title;
    m_account_id             := p_account_id;
    m_bank_name              := p_bank_name;
    m_accountMode            := p_account_mode;
    m_accountSchemeId        := p_AccountSchemeId;
    m_defaultaccount_flag    := p_defaultaccount_flag;
    m_created_by             := p_created_by;

    --DBMS_OUTPUT.PUT_LINE('Inside account_number' || p_account_number);
    --DBMS_OUTPUT.PUT_LINE('mgmt_account_master m_input_channel' || m_input_channel);
    --DBMS_OUTPUT.PUT_LINE('mgmt_account_master p_bank_code' || p_bank_code);
    --DBMS_OUTPUT.PUT_LINE('mgmt_account_master p_account_status' || p_account_status);
    --DBMS_OUTPUT.PUT_LINE('mgmt_account_master p_country_code' || p_country_code);
    --DBMS_OUTPUT.PUT_LINE('mgmt_account_master p_account_curr' || p_account_curr);
    --DBMS_OUTPUT.PUT_LINE('mgmt_account_master p_image_url' || p_image_url);
    --DBMS_OUTPUT.PUT_LINE('mgmt_account_master p_account_iban' || p_account_iban);
    --DBMS_OUTPUT.PUT_LINE('mgmt_account_master m_account_title' || p_defaultaccount_flag);

       BEGIN

                  SELECT TDVALUE
                  INTO m_context_name
                  FROM TABLEDETAILS
                  WHERE TDIDCODE ='CONTEXT'
                  AND
                  TDKEY = m_tennant_name ;
                        --DBMS_OUTPUT.PUT_LINE('m_context_name -->'||m_context_name);

              EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN

                       DBMS_OUTPUT.PUT_LINE ('No CONTEXT found ');
             END;

  m_active_datakeyid := sys_context(m_context_name,'ACTIVE_DATAKEYID');
    IF (m_action = 'INSERT' OR m_action = 'INSERT-UPDATE')
    THEN
        BEGIN

            SELECT  COUNT(*)
            INTO    m_count1
            FROM    ACCOUNT_MASTER
            WHERE   institution_id       = p_institution_id
            AND     (account_number_enc  = encrypt_decrypt_basedon_session_cntx(m_encrypt,p_institution_id,p_account_number,m_active_datakeyid)
            OR       account_number      = p_account_number)
            AND     bank_code            = 'NOT-PROVIDED'
            AND     branch               = 'NOT-PROVIDED'
            AND     (customer_id_enc     = encrypt_decrypt_basedon_session_cntx(m_encrypt,p_institution_id,p_customer_id,m_active_datakeyid)
            OR       customer_id         = p_customer_id);

            DBMS_OUTPUT.put_line('m_count1 : ' || m_count1 );

            IF p_account_number IS NOT NULL AND p_bank_code != 'NOT-PROVIDED'
            THEN
                DELETE
                FROM    account_master
                WHERE   institution_id       = p_institution_id
                AND     (account_number_enc  = encrypt_decrypt_basedon_session_cntx(m_encrypt,p_institution_id,p_account_number,m_active_datakeyid)
                OR       account_number      = p_account_number)
                AND     bank_code            = 'NOT-PROVIDED'
                AND     branch               = 'NOT-PROVIDED'
                AND     (customer_id_enc     = encrypt_decrypt_basedon_session_cntx(m_encrypt,p_institution_id,p_customer_id,m_active_datakeyid)
                OR       customer_id         = p_customer_id);
            --AND     default_account_flag = m_defaultaccount_flag;
                DBMS_OUTPUT.PUT_LINE('Deleted for p_bank_code for bankcode : ' || p_bank_code || ' countcode: ' ||  p_country_code);
            END IF;

--            IF p_account_number IS NOT NULL AND p_branch != 'NOT-PROVIDED'
--            THEN
--                DELETE FROM account_master
--                WHERE   institution_id = p_institution_id
--                AND     account_number = p_account_number
--                AND     bank_code      = p_bank_code
--                AND     branch = 'NOT-PROVIDED'
--                AND     customer_id = p_customer_id;
--                DBMS_OUTPUT.PUT_LINE('Deleted for p_branch');
--            END IF;
            BEGIN

                SELECT  COUNT(*)
                INTO    m_count
                FROM    ACCOUNT_MASTER
                WHERE   institution_id      = p_institution_id
                --AND     account_iban      = p_account_iban
                AND     (account_number_enc  = encrypt_decrypt_basedon_session_cntx(m_encrypt,p_institution_id,p_account_number,m_active_datakeyid)
                OR       account_number      = p_account_number)
                AND BANK_CODE = DECODE(p_bank_code,'NOT-PROVIDED', BANK_CODE, p_bank_code) ;

    --            AND branch = 'NOT-PROVIDED'
    --            AND bank_code != 'NOT-PROVIDED'
--                AND account_status = 'VALIDATED';

            EXCEPTION
                WHEN NO_DATA_FOUND
                THEN
                    m_count := 0;
                    DBMS_OUTPUT.PUT_LINE('NO_DATA_FOUND');
            END;

            DBMS_OUTPUT.PUT_LINE('m_count : ' || m_count);

            IF m_count <= 0 --OR p_country_code IS NULL
            THEN
                SELECT ACCOUNT_NO_SEQ.NEXTVAL
                INTO m_account_no_seq
                FROM DUAL;
           --     SELECT paramvalue INTO m_tennant_name FROM INSTITUTIONPARAMETERS WHERE INSTITUTIONID = m_institution_id AND PARAMNAME = 'TENANT_NAME';
                DBMS_OUTPUT.PUT_LINE('INSERTED FOR account_number' || p_account_number);
                DBMS_OUTPUT.PUT_LINE('m_account_curr: ' || m_account_curr);
                DBMS_OUTPUT.PUT_LINE('ACCOUNT_TITLE: ' || p_account_title);

                INSERT
                INTO account_master
                (
                institution_id,
                customer_id,
                customer_id_enc,
                bank_code,
                branch,
                account_number,
                account_number_enc,
                account_iban,
                account_iban_enc,
                account_type,
                account_curr,
                credit_limit,
                account_desc,
                country_code,
                account_status,
                account_updatedby,
                account_validatedby,
                crscheme_id,
                account_addl_property,
                input_channel,
                account_title,
                account_title_enc,
                account_id,
                account_id_enc,
                image_url,
                bank_name,
                ACCOUNT_MODE,
                default_account_flag,
                pelican_account_no,
				account_display_name,
                account_display_name_enc,
				datakeyid,
				 userid
                )
                VALUES
                (
                m_institution_id,
                return_masked_info(m_prefix,m_institution_id,m_customer_id),
                encrypt_decrypt_basedon_session_cntx(m_encrypt,m_institution_id,m_customer_id,m_active_datakeyid),
                m_bank_code,
                m_branch,
                return_masked_info(m_prefix,m_institution_id,m_account_number),
                encrypt_decrypt_basedon_session_cntx(m_encrypt,m_institution_id,m_account_number,m_active_datakeyid),
                return_masked_info(m_prefix,m_institution_id,upper(m_account_iban)),
                encrypt_decrypt_basedon_session_cntx(m_encrypt,m_institution_id,upper(m_account_iban),m_active_datakeyid),
                m_account_type,
                m_account_curr,
                m_credit_limit,
                m_account_desc,
                m_country_code,
                m_account_status,
                m_account_updatedby,
                m_account_validatedby,
                m_accountSchemeId,--m_crscheme_id,
                DECODE(p_account_addl_property,'X',NULL,p_account_addl_property),
                DECODE(p_input_channel,'X',NULL,p_input_channel),
                return_masked_info(m_suffix,m_institution_id,replace(regexp_replace(substr(m_account_title,1,4),'[^[:alnum:]'' '']'),' ','')|| substr(m_account_title,5)),
                encrypt_decrypt_basedon_session_cntx(m_encrypt,m_institution_id,m_account_title,m_active_datakeyid),
                return_masked_info(m_prefix,m_institution_id,m_account_id),
                encrypt_decrypt_basedon_session_cntx(m_encrypt,m_institution_id,m_account_id,m_active_datakeyid),
                p_image_url,
                m_bank_name,
                m_accountMode,
                m_defaultaccount_flag,
                'A0000000' || m_account_no_seq,
				return_masked_info(m_suffix,m_institution_id,replace(regexp_replace(substr(m_account_title,1,4),'[^[:alnum:]'' '']'),' ','')|| substr(m_account_title,5)),
                encrypt_decrypt_basedon_session_cntx(m_encrypt,m_institution_id,m_account_title,m_active_datakeyid),
				sys_context(m_context_name,'ACTIVE_DATAKEYID'),
		m_created_by
                );
            ELSE
                DBMS_OUTPUT.PUT_LINE('Updated FOR account_number :' || p_account_number);
                DBMS_OUTPUT.PUT_LINE('p_account_title :' || p_account_title);
                DBMS_OUTPUT.PUT_LINE('p_account_curr :' || p_account_curr);
                DBMS_OUTPUT.PUT_LINE('p_account_status :' || p_account_status);

                UPDATE  ACCOUNT_MASTER
                SET     account_status        = DECODE(account_status, 'DELETED', p_account_status, account_status), -- p_account_status,
                        account_iban_enc      = encrypt_decrypt_basedon_session_cntx(m_encrypt,p_institution_id,upper(p_account_iban),m_active_datakeyid),
                        account_iban          = return_masked_info(m_prefix,p_institution_id,upper(p_account_iban)),
                        customer_id_enc       = encrypt_decrypt_basedon_session_cntx(m_encrypt,p_institution_id,p_customer_id,m_active_datakeyid),
                        customer_id           = return_masked_info(m_prefix,p_institution_id,p_customer_id),
                        crscheme_id           = DECODE(p_accountSchemeId,NULL,crscheme_id,p_accountSchemeId),--DECODE(p_crscheme_id,NULL,crscheme_id,p_crscheme_id),
                        account_addl_property = DECODE(p_account_addl_property,'X',account_addl_property,p_account_addl_property),
                        bank_code             = DECODE(p_bank_code, 'NOT-PROVIDED', bank_code, p_bank_code),--m_bank_code,
                        input_channel         = DECODE(p_input_channel,'X',input_channel,p_input_channel),
                        account_title_enc     = (CASE
                                                WHEN account_title_enc IS NULL
                                                THEN
                                                    encrypt_decrypt_basedon_session_cntx(m_encrypt,p_institution_id,p_account_title,m_active_datakeyid)
                                                WHEN account_title_enc = encrypt_decrypt_basedon_session_cntx(m_encrypt,p_institution_id,'NOT-PROVIDED',m_active_datakeyid)
                                                THEN
                                                    encrypt_decrypt_basedon_session_cntx(m_encrypt,p_institution_id,p_account_title,m_active_datakeyid)
                                                WHEN p_account_title IS NULL
                                                THEN
                                                    account_title_enc
                                                WHEN encrypt_decrypt_basedon_session_cntx(m_encrypt,p_institution_id,p_account_title,m_active_datakeyid) <>  account_title_enc
                                                THEN
                                                    encrypt_decrypt_basedon_session_cntx(m_encrypt,p_institution_id,p_account_title,m_active_datakeyid)
                                                WHEN encrypt_decrypt_basedon_session_cntx(m_encrypt,p_institution_id,p_account_title,m_active_datakeyid)  =  account_title_enc
                                                THEN
                                                    account_title_enc
                                                ELSE
                                                    account_title_enc
                                                END
                                                ),
                        account_title         = (CASE
                                                WHEN account_title_enc IS NULL
                                                THEN
                                                    return_masked_info(m_suffix,m_institution_id,replace(regexp_replace(substr(m_account_title,1,4),'[^[:alnum:]'' '']'),' ','')|| substr(m_account_title,5))
                                                WHEN account_title_enc = encrypt_decrypt_basedon_session_cntx(m_encrypt,p_institution_id,'NOT-PROVIDED',m_active_datakeyid)
                                                THEN
                                                    return_masked_info(m_suffix,m_institution_id,replace(regexp_replace(substr(m_account_title,1,4),'[^[:alnum:]'' '']'),' ','')|| substr(m_account_title,5))
                                                WHEN p_account_title IS NULL
                                                THEN
                                                    account_title
                                                WHEN encrypt_decrypt_basedon_session_cntx(m_encrypt,p_institution_id,p_account_title,m_active_datakeyid) <>  account_title_enc
                                                THEN
                                                    return_masked_info(m_suffix,m_institution_id,replace(regexp_replace(substr(m_account_title,1,4),'[^[:alnum:]'' '']'),' ','')|| substr(m_account_title,5))
                                                WHEN encrypt_decrypt_basedon_session_cntx(m_encrypt,p_institution_id,p_account_title,m_active_datakeyid)  =  account_title_enc
                                                THEN
                                                    account_title
                                                ELSE
                                                    account_title
                                                END
                                                ),
                        account_display_name_enc         = (CASE
                                                    WHEN account_display_name_enc IS NULL
                                                    THEN encrypt_decrypt_basedon_session_cntx(m_encrypt,p_institution_id,p_account_title,m_active_datakeyid)
                                                    WHEN account_display_name_enc = encrypt_decrypt_basedon_session_cntx(m_encrypt,p_institution_id,'NOT-PROVIDED',m_active_datakeyid)
													THEN  encrypt_decrypt_basedon_session_cntx(m_encrypt,p_institution_id,p_account_title,m_active_datakeyid)
                                                    WHEN p_account_title IS NULL
													THEN account_display_name_enc
                                                    WHEN encrypt_decrypt_basedon_session_cntx(m_encrypt,p_institution_id,p_account_title,m_active_datakeyid)<>  account_display_name_enc
                                                    THEN encrypt_decrypt_basedon_session_cntx(m_encrypt,p_institution_id,p_account_title,m_active_datakeyid)
                                                    WHEN encrypt_decrypt_basedon_session_cntx(m_encrypt,p_institution_id,p_account_title,m_active_datakeyid)    =  account_display_name_enc THEN
													account_display_name_enc
                                                    ELSE account_display_name_enc
                                                    END
                                                   ),
                        account_display_name    = (CASE
                                                    WHEN account_display_name_enc IS NULL THEN return_masked_info(m_suffix,m_institution_id,replace(regexp_replace(substr(p_account_title,1,4),'[^[:alnum:]'' '']'),' ','')|| substr(p_account_title,5))
                                                    WHEN account_display_name_enc = 'NOT-PROVIDED' THEN  return_masked_info(m_suffix,m_institution_id,replace(regexp_replace(substr(p_account_title,1,4),'[^[:alnum:]'' '']'),' ','')|| substr(p_account_title,5))
                                                    WHEN p_account_title IS NULL THEN account_display_name
                                                    WHEN encrypt_decrypt_basedon_session_cntx(m_encrypt,p_institution_id,p_account_title,m_active_datakeyid) <>  account_display_name_enc THEN return_masked_info(m_suffix,m_institution_id,replace(regexp_replace(substr(p_account_title,1,4),'[^[:alnum:]'' '']'),' ','')|| substr(p_account_title,5))
                                                    WHEN encrypt_decrypt_basedon_session_cntx(m_encrypt,p_institution_id,p_account_title,m_active_datakeyid)  =  account_display_name_enc THEN account_display_name
                                                    ELSE account_display_name
                                                    END
                                                   ),
                        account_curr          = (CASE
                                                WHEN account_curr IS NULL
                                                THEN
                                                    p_account_curr
                                                WHEN account_curr = 'NOT-PROVIDED'
                                                THEN
                                                    p_account_curr
                                                WHEN p_account_curr IS NULL
                                                THEN
                                                    account_curr
                                                WHEN p_account_curr <>  account_curr
                                                THEN
                                                    p_account_curr
                                                WHEN p_account_curr  =  account_curr
                                                THEN
                                                    account_curr
                                                ELSE
                                                    account_curr
                                                END
                                                ),
                        --DECODE(NVL(account_curr,'XX'), 'XX', p_account_curr, 'NOT-PROVIDED', p_account_curr, account_curr),
                        country_code          = DECODE(NVL(country_code,'XX'), 'XX', p_country_code, 'NOT-PROVIDED', p_country_code, country_code),
			account_id_enc          = encrypt_decrypt_basedon_session_cntx(m_encrypt,m_institution_id,m_account_id,m_active_datakeyid),
                        account_id = (CASE
                                                    WHEN account_id IS NULL THEN return_masked_info(m_prefix,p_institution_id,p_account_id)
                                                    WHEN account_id = 'NOT-PROVIDED' THEN  return_masked_info(m_prefix,p_institution_id,p_account_id)
                                                    WHEN p_account_id IS NULL THEN return_masked_info(m_prefix,p_institution_id,account_id)
                                                    WHEN p_account_id <>  account_title THEN return_masked_info(m_prefix,p_institution_id,p_account_id)
                                                    WHEN p_account_id  =  account_title THEN return_masked_info(m_prefix,p_institution_id,account_id)
                                                    ELSE return_masked_info(m_prefix,p_institution_id,account_id)
                                                    END
                                                   ),
                        image_url = DECODE(NVL(p_image_url, 'XXX'), 'XXX', image_url, p_image_url),
                        bank_name = (CASE   WHEN bank_name IS NULL AND m_bank_name IS NOT NULL  THEN m_bank_name
                                            WHEN bank_name = m_bank_name THEN bank_name
                                            ELSE bank_name
                                            END),
                        ACCOUNT_MODE = (CASE
                                                    WHEN account_mode IS NULL THEN p_account_Mode
                                                    WHEN account_mode = 'NOT-PROVIDED' THEN  p_account_Mode
                                                    WHEN p_account_Mode IS NULL THEN account_mode
                                                    WHEN p_account_Mode <>  account_mode THEN p_account_Mode
                                                    WHEN p_account_Mode  =  account_mode THEN account_mode
                                                    ELSE account_mode
                                                    END
                                                   ),
                        default_account_flag = (CASE    WHEN default_account_flag IS NULL AND m_defaultaccount_flag IS NOT NULL THEN m_defaultaccount_flag
                                                        WHEN default_account_flag <> m_defaultaccount_flag THEN m_defaultaccount_flag
                                                        ELSE default_account_flag
                                                        END),
                        USERID  =  m_created_by
                                                        WHERE  institution_id           = p_institution_id
                AND     (customer_id_enc     = encrypt_decrypt_basedon_session_cntx(m_encrypt,p_institution_id,p_customer_id,m_active_datakeyid)
                OR       customer_id         = p_customer_id)
                AND    bank_code                = DECODE(p_bank_code, 'NOT-PROVIDED', bank_code, p_bank_code)
                AND    branch                   = DECODE(p_branch, 'NOT-PROVIDED', branch, p_branch)
                AND     (account_number_enc  = encrypt_decrypt_basedon_session_cntx(m_encrypt,p_institution_id,p_account_number,m_active_datakeyid)
                OR       account_number      = p_account_number);
                --AND    upper(account_iban)   = upper(p_account_iban);
                ------DBMS_OUTPUT.PUT_LINE('Updated m_defaultaccount_flag in account master : ' || m_defaultaccount_flag);
            END IF;

        EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
                DBMS_OUTPUT.PUT_LINE('DUP_RECORD_FOUND');
                m_action := 'UPDATE';
        END;
    END IF;

    IF m_count > 0 and m_defaultaccount_flag IS NOT NULL
    THEN

        UPDATE  ACCOUNT_MASTER
        SET     default_account_flag = m_defaultaccount_flag
        WHERE   institution_id       = p_institution_id
        AND     (customer_id_enc     = encrypt_decrypt_basedon_session_cntx(m_encrypt,p_institution_id,p_customer_id,m_active_datakeyid)
        OR       customer_id         = p_customer_id)
        AND     bank_code            = DECODE(p_bank_code, 'NOT-PROVIDED', bank_code, p_bank_code)
        AND     branch               = DECODE(p_branch, 'NOT-PROVIDED', branch, p_branch)
        AND     (account_number_enc  = encrypt_decrypt_basedon_session_cntx(m_encrypt,p_institution_id,p_account_number,m_active_datakeyid)
        OR       account_number      = p_account_number);

        DBMS_OUTPUT.put_line('Update default account flag.');

    END IF;

    IF (m_action = 'DELETE')
    THEN
        DELETE  ACCOUNT_MASTER
        WHERE   institution_id       = p_institution_id
        AND     (customer_id_enc     = encrypt_decrypt_basedon_session_cntx(m_encrypt,p_institution_id,p_customer_id,m_active_datakeyid)
        OR       customer_id         = p_customer_id)
        AND     bank_code            = p_bank_code
        AND     branch               = p_branch
        AND     (account_number_enc  = encrypt_decrypt_basedon_session_cntx(m_encrypt,p_institution_id,p_account_number,m_active_datakeyid)
        OR       account_number      = p_account_number)
        AND     account_type         = p_account_type
        AND     account_curr         = p_account_curr
        AND     default_account_flag =  m_defaultaccount_flag;
        DBMS_OUTPUT.PUT_LINE('m_action delete');
    END IF;

    IF (m_action = 'UPDATE')
    THEN
        DBMS_OUTPUT.PUT_LINE('p_input_channel: ' || p_input_channel);
        DBMS_OUTPUT.PUT_LINE('In Update p_account_status: ' || p_account_status);
        DBMS_OUTPUT.PUT_LINE('In Update p_account_iban: ' || p_account_iban);

        UPDATE account_master
        SET    account_status        = DECODE(account_status, 'DELETED', p_account_status, account_status),
               account_iban          = return_masked_info(m_prefix,p_institution_id,upper(p_account_iban)),
               account_iban_enc      = encrypt_decrypt_basedon_session_cntx(m_encrypt,p_institution_id,upper(p_account_iban),m_active_datakeyid),
               customer_id           = return_masked_info(m_prefix,p_institution_id,p_customer_id),
               customer_id_enc       = encrypt_decrypt_basedon_session_cntx(m_encrypt,p_institution_id,p_customer_id,m_active_datakeyid),
               crscheme_id           = DECODE(p_accountSchemeId,NULL,crscheme_id,p_accountSchemeId),--DECODE(p_crscheme_id,NULL,crscheme_id,p_crscheme_id),
               account_addl_property = DECODE(p_account_addl_property,'X',account_addl_property,p_account_addl_property),
               input_channel         = DECODE(p_input_channel,'X',input_channel,p_input_channel),
	           account_title_enc     = DECODE(account_title, NULL,encrypt_decrypt_basedon_session_cntx(m_encrypt,p_institution_id,p_account_title,m_active_datakeyid), 'NOT-PROVIDED', encrypt_decrypt_basedon_session_cntx(m_encrypt,p_institution_id,p_account_title,m_active_datakeyid),encrypt_decrypt_basedon_session_cntx(m_encrypt,p_institution_id,p_account_title,m_active_datakeyid)),
               account_title         = (CASE
                                                    WHEN account_title IS NULL THEN return_masked_info(m_suffix,m_institution_id,replace(regexp_replace(substr(p_account_title,1,4),'[^[:alnum:]'' '']'),' ','')|| substr(p_account_title,5))
                                                    WHEN account_title = 'NOT-PROVIDED' THEN  return_masked_info(m_suffix,m_institution_id,replace(regexp_replace(substr(p_account_title,1,4),'[^[:alnum:]'' '']'),' ','')|| substr(p_account_title,5))
                                                    WHEN p_account_title IS NULL THEN return_masked_info(m_suffix,m_institution_id,replace(regexp_replace(substr(account_title,1,4),'[^[:alnum:]'' '']'),' ','')|| substr(account_title,5))
                                                    WHEN p_account_title <>  account_title THEN return_masked_info(m_suffix,m_institution_id,replace(regexp_replace(substr(p_account_title,1,4),'[^[:alnum:]'' '']'),' ','')|| substr(p_account_title,5))
                                                    WHEN p_account_title  =  account_title THEN return_masked_info(m_suffix,m_institution_id,replace(regexp_replace(substr(account_title,1,4),'[^[:alnum:]'' '']'),' ','')|| substr(account_title,5))
                                                    ELSE return_masked_info(m_suffix,m_institution_id,replace(regexp_replace(substr(account_title,1,4),'[^[:alnum:]'' '']'),' ','')|| substr(account_title,5))
                                                    END
                                                   ),
               account_display_name_enc     = DECODE(account_display_name, NULL,encrypt_decrypt_basedon_session_cntx(m_encrypt,p_institution_id,p_account_title,m_active_datakeyid), 'NOT-PROVIDED', encrypt_decrypt_basedon_session_cntx(m_encrypt,p_institution_id,p_account_title,m_active_datakeyid),encrypt_decrypt_basedon_session_cntx(m_encrypt,p_institution_id,p_account_title,m_active_datakeyid)),
               account_display_name         = (CASE
                                                    WHEN account_display_name IS NULL THEN return_masked_info(m_suffix,m_institution_id,replace(regexp_replace(substr(p_account_title,1,4),'[^[:alnum:]'' '']'),' ','')|| substr(p_account_title,5))
                                                    WHEN account_display_name = 'NOT-PROVIDED' THEN  return_masked_info(m_suffix,m_institution_id,replace(regexp_replace(substr(p_account_title,1,4),'[^[:alnum:]'' '']'),' ','')|| substr(p_account_title,5))
                                                    WHEN p_account_title IS NULL THEN return_masked_info(m_suffix,m_institution_id,replace(regexp_replace(substr(account_display_name,1,4),'[^[:alnum:]'' '']'),' ','')|| substr(account_display_name,5))
                                                    WHEN p_account_title <>  account_display_name THEN return_masked_info(m_suffix,m_institution_id,replace(regexp_replace(substr(p_account_title,1,4),'[^[:alnum:]'' '']'),' ','')|| substr(p_account_title,5))
                                                    WHEN p_account_title  =  account_display_name THEN account_display_name
                                                    ELSE return_masked_info(m_suffix,m_institution_id,replace(regexp_replace(substr(account_display_name,1,4),'[^[:alnum:]'' '']'),' ','')|| substr(account_display_name,5))
                                                    END
                                                   ),
               --DECODE(account_title, NULL, p_account_title, 'NOT-PROVIDED', p_account_title, p_account_title),
               bank_code             = DECODE(p_bank_code, 'NOT-PROVIDED', bank_code, p_bank_code),--m_bank_code,
               account_curr          = (CASE
                                        WHEN account_curr IS NULL THEN p_account_curr
                                        WHEN account_curr = 'NOT-PROVIDED' THEN  p_account_curr
                                        WHEN p_account_curr IS NULL THEN account_curr
                                        WHEN p_account_curr <>  account_curr THEN p_account_curr
                                        WHEN p_account_curr  =  account_curr THEN account_curr
                                        ELSE account_curr
                                        END
                                       ) ,
               --DECODE(NVL(account_curr, 'XXX'), 'XXX', p_account_curr, 'NOT-PROVIDED', p_account_curr, p_account_curr),
               country_code          = DECODE(NVL(country_code, 'XX'),'XX', p_country_code, 'NOT-PROVIDED', p_country_code, country_code),
                account_id_enc = (CASE
                            WHEN account_id_enc IS NULL
                            THEN
                                encrypt_decrypt_basedon_session_cntx(m_encrypt,p_institution_id,p_account_id,m_active_datakeyid)
                            WHEN account_id_enc = encrypt_decrypt_basedon_session_cntx(m_encrypt,p_institution_id,'NOT-PROVIDED',m_active_datakeyid)
                            THEN
                                encrypt_decrypt_basedon_session_cntx(m_encrypt,p_institution_id,p_account_id,m_active_datakeyid)
                            WHEN p_account_id IS NULL
                            THEN
                                account_id_enc
                            WHEN encrypt_decrypt_basedon_session_cntx(m_encrypt,p_institution_id,p_account_id,m_active_datakeyid) <>  account_id_enc
                            THEN
                                encrypt_decrypt_basedon_session_cntx(m_encrypt,p_institution_id,p_account_id,m_active_datakeyid)
                            WHEN encrypt_decrypt_basedon_session_cntx(m_encrypt,p_institution_id,p_account_id,m_active_datakeyid)  =  account_id_enc
                            THEN
                                account_id_enc
                            ELSE account_id_enc
                            END
                           ),
                account_id = (CASE
                            WHEN account_id IS NULL
                            THEN
                                return_masked_info(m_prefix,p_institution_id,p_account_id)
                                --encrypt_decrypt_basedon_session_cntx(m_encrypt,p_institution_id,p_account_id)
                            WHEN account_id_enc = encrypt_decrypt_basedon_session_cntx(m_encrypt,p_institution_id,'NOT-PROVIDED',m_active_datakeyid)
                            THEN
                                return_masked_info(m_prefix,p_institution_id,p_account_id)
                                --encrypt_decrypt_basedon_session_cntx(m_encrypt,p_institution_id,p_account_id)
                            WHEN p_account_id IS NULL
                            THEN
                                account_id
                            WHEN encrypt_decrypt_basedon_session_cntx(m_encrypt,p_institution_id,p_account_id,m_active_datakeyid) <>  account_id_enc
                            THEN
                                return_masked_info(m_prefix,p_institution_id,p_account_id)
                            WHEN encrypt_decrypt_basedon_session_cntx(m_encrypt,p_institution_id,p_account_id,m_active_datakeyid)  =  account_id_enc
                            THEN
                                account_id
                            ELSE account_id
                            END
                           ),
                          image_url            = DECODE(NVL(p_image_url, 'XXX'), 'XXX', image_url, p_image_url),
               bank_name = (CASE   WHEN bank_name IS NULL AND m_bank_name IS NOT NULL THEN m_bank_name
                                            WHEN bank_name = m_bank_name THEN bank_name
                                            ELSE bank_name
                                            END),
               default_account_flag = (CASE    WHEN default_account_flag IS NULL AND m_defaultaccount_flag IS NOT NULL THEN m_defaultaccount_flag
                                                        WHEN default_account_flag <> m_defaultaccount_flag THEN m_defaultaccount_flag
                                                        ELSE default_account_flag
                                                        END),
                userid = m_created_by
        WHERE  institution_id        = p_institution_id
        AND    customer_id_enc       = encrypt_decrypt_basedon_session_cntx(m_encrypt,p_institution_id,p_customer_id,m_active_datakeyid)
        AND    bank_code             = DECODE(p_bank_code, 'NOT-PROVIDED', bank_code, p_bank_code)
        AND    branch                = DECODE(p_branch, 'NOT-PROVIDED', branch, p_branch)
        AND     (account_number_enc  = encrypt_decrypt_basedon_session_cntx(m_encrypt,p_institution_id,p_account_number,m_active_datakeyid)
        OR      account_number      = p_account_number)
        AND    (account_iban_enc     = encrypt_decrypt_basedon_session_cntx(m_encrypt,p_institution_id,p_account_iban,m_active_datakeyid)
        OR      NVL(upper(account_iban), 'XX')   = NVL(upper(p_account_iban), 'XX'));
        --AND    account_status        = 'VALIDATED';
        DBMS_OUTPUT.PUT_LINE('*** m_action update *** : ' || m_defaultaccount_flag);
    END IF;
END;