-- [8.1.90.7] [20221109] [PTRAMBAKE] [START]
create or replace FUNCTION ob_income_expense_analysis_sevice
(
    p_onboard_info          IN CLOB,
    p_institutionid         IN INSTITUTIONMASTER.institutionid%TYPE

)RETURN NUMBER
AS

    m_onboard_xtype                 XMLTYPE;
    m_institutionid                 MSGDB.institutionid%TYPE                    :=NULL;
    SERVICE_NOT_SUBSCRIBED          EXCEPTION;
    ONBOARDING_EXCEPTION            EXCEPTION;
    OB_AUDIT_LOG                    EXCEPTION;
    m_xpath                         OB_XPATH_INSTPARMPATH_MAP.xpath_node%TYPE   := NULL;
    m_xpath_node                    OB_XPATH_INSTPARMPATH_MAP.xpath_node%TYPE   := 'Customer/IncomeExpenseAnalysisService/';
    m_paramvalue                    INSTITUTIONPARAMETERS.paramvalue%TYPE       := NULL;
    m_return_code                   NUMBER                                      := 0;
    m_xpath_root                    OB_XPATH_INSTPARMPATH_MAP.xpath_root%TYPE   := 'ProductConfiguration';
    m_audittext                     GENAUDIT.audittext%TYPE                     := NULL;
    g_messageno                     GENAUDIT.messageno%TYPE                     := NULL;
    g_queueid                       GENAUDIT.queueid%TYPE                       := NULL;
    m_return_number                 NUMBER                                      := 0;
    m_exception_desc                VARCHAR2(4000)                              := NULL;
    m_replacetagvalue_list          VARCHAR2(4000)                              := NULL;
    m_replacetagvalue_main          VARCHAR2(4000)                              := NULL;
    m_ServiceSubscription           VARCHAR2(255)                               := NULL;
    m_VerificationRail              VARCHAR2(500)                               := NULL;
    m_LogoURL                       VARCHAR2(500)                               := NULL;
    m_FlowType                      VARCHAR2(500)                               := NULL;
    m_IsEmail                       VARCHAR2(500)                               := NULL;
    m_IsSms                         VARCHAR2(500)                               := NULL;
    m_domain                        XMLTYPE;
    m_Primary                       VARCHAR2(255)                               := NULL;
    m_Secondary                     VARCHAR2(255)                               := NULL;
    m_Tertiary                      VARCHAR2(255)                               := NULL;
    m_support_email                 VARCHAR2(255)                               := NULL;
    m_support_mob_no                VARCHAR2(255)                               := NULL;

    m_running_number                   NUMBER                                      := 0;
    m_running_number_ctr            VARCHAR2(4000)                              := NULL;
    x_currency_code                 XMLTYPE                                     := NULL;
    m_country_code                  VARCHAR2(255)                               := NULL;
    m_currency_code                 VARCHAR2(255)                               := NULL;
    --m_countries                     VARCHAR2(255)                               := NULL;
    --p_path                          VARCHAR2(4000)                              := 'AFFORDABILITY_VERIFICATION_SERVICE.ACCOUNT.CURRENCY';
    m_path                          VARCHAR2(4000)                              := NULL;



    cursor c1(c_RedirectionDomains IN XMLTYPE)
    IS
    SELECT     *
    FROM     XMLTable('*' PASSING c_RedirectionDomains
                        COLUMNS domain                VARCHAR2 (255)  PATH '.');                 


BEGIN
    BEGIN
        m_onboard_xtype := XMLTYPE(p_onboard_info);
        m_institutionid := p_institutionid;

        DBMS_OUTPUT.PUT_LINE ('m_institutionid: ' || m_institutionid);

        BEGIN
            SELECT  x.Subscription,
                    x.VerificationRail,
                    x.LogoURL,
                    x.FlowType,
                    x.IsEmail,
                    x.IsSms,
                    x.domain
            INTO    m_ServiceSubscription,
                    m_VerificationRail,
                    m_LogoURL,
                    m_FlowType,
                    m_IsEmail,
                    m_IsSms,
                    m_domain
            FROM    XMLTable('/ProductConfiguration/Customer/IncomeExpenseAnalysisService' PASSING m_onboard_xtype
            COLUMNS Subscription        VARCHAR2(15)  PATH 'Subscription',
                    VerificationRail    VARCHAR2(15)  PATH 'VerificationRail',
                    LogoURL                VARCHAR2(500)  PATH 'LogoURL',
                    FlowType                VARCHAR2(500)  PATH 'FlowType',
                    IsEmail                VARCHAR2(500)  PATH 'RequestMethodS/ISEmail',
                    IsSms                VARCHAR2(500)  PATH 'RequestMethodS/ISSMS',
                    domain                XMLTYPE PATH 'Redirectiondomains/domain')x;
--                    Primary                VARCHAR2(255)  PATH 'ThemeColors/Primary',
--                    Secondary            VARCHAR2(255)  PATH 'ThemeColors/Secondary',
--                    Tertiary            VARCHAR2(255)  PATH 'ThemeColors/Tertiary',
--                    SupportEmailId                          VARCHAR2(255)  PATH 'SupportEmailId',
--                    SupportMobileNo         VARCHAR2(255)  PATH 'SupportMobileNo'

        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                m_ServiceSubscription := 'NO';
        END;
        DBMS_OUTPUT.PUT_LINE ('m_ServiceSubscription: ' || m_ServiceSubscription);

        IF    UPPER(m_ServiceSubscription)    =    'NO' OR UPPER(m_ServiceSubscription)    =    'N'
        THEN
            DBMS_OUTPUT.put_line('IncomeExpenseAnalysisService not subscribed !');

            RAISE SERVICE_NOT_SUBSCRIBED;
        END IF;


        m_xpath    := m_xpath_node || 'Subscription';
        IF m_ServiceSubscription IS NULL
        THEN
            m_return_number        := 6;
            m_exception_desc    := 'Mandatory component => ' || m_xpath || ' ' || ' not found';
            RAISE ONBOARDING_EXCEPTION;
        END IF;

		DBMS_OUTPUT.put_line('-----------------------IncomeExpenseAnalysisService---------------------------');

        m_xpath             := m_xpath_node || 'Subscription';
        m_paramvalue        := m_ServiceSubscription;
        m_return_code       := mgmt_institutionparam_usexpath(p_action_passed=>'INSERT-UPDATE',p_institutionid_passed=>m_institutionid, p_xpath_root=>m_xpath_root, p_xpath_child=>m_xpath, p_paramvalue=>m_paramvalue);
        DBMS_OUTPUT.put_line(RPAD('Subscription:',35,' ')|| m_paramvalue);

        m_xpath    := m_xpath_node || 'VerificationRail';
        m_paramvalue    := m_VerificationRail;
        DBMS_OUTPUT.put_line('VerificationRail m_xpath : ' || m_xpath);
        m_return_code    := mgmt_institutionparam_usexpath(p_action_passed=>'INSERT-UPDATE',p_institutionid_passed=>m_institutionid, p_xpath_root=>m_xpath_root, p_xpath_child=>m_xpath,p_replacetagvalue_list=>m_replacetagvalue_list,p_paramvalue=>m_paramvalue);
        DBMS_OUTPUT.put_line(RPAD('VerificationRail:',35,' ')|| m_paramvalue);

        m_xpath    := m_xpath_node || 'LogoURL';
        m_paramvalue    := m_LogoURL;
        DBMS_OUTPUT.put_line('LogoURL m_xpath : ' || m_xpath);
        m_return_code    := mgmt_institutionparam_usexpath(p_action_passed=>'INSERT-UPDATE',p_institutionid_passed=>m_institutionid, p_xpath_root=>m_xpath_root, p_xpath_child=>m_xpath,p_replacetagvalue_list=>m_replacetagvalue_list,p_paramvalue=>m_paramvalue);
        DBMS_OUTPUT.put_line(RPAD('LogoURL:',35,' ')|| m_paramvalue);

        m_xpath    := m_xpath_node || 'FlowType';
        m_paramvalue    := m_FlowType;
        DBMS_OUTPUT.put_line('FlowType m_xpath : ' || m_xpath);
        m_return_code    := mgmt_institutionparam_usexpath(p_action_passed=>'INSERT-UPDATE',p_institutionid_passed=>m_institutionid, p_xpath_root=>m_xpath_root, p_xpath_child=>m_xpath,p_replacetagvalue_list=>m_replacetagvalue_list,p_paramvalue=>m_paramvalue);
        DBMS_OUTPUT.put_line(RPAD('FlowType:',35,' ')|| m_paramvalue);

        m_xpath    := m_xpath_node || 'RequestMethodS/ISEmail';
        m_paramvalue    := m_IsEmail;
        DBMS_OUTPUT.put_line('IsEmail m_xpath : ' || m_xpath);
        DBMS_OUTPUT.put_line('IsEmail m_paramvalue : ' || m_paramvalue);
        m_return_code    := mgmt_institutionparam_usexpath(p_action_passed=>'INSERT-UPDATE',p_institutionid_passed=>m_institutionid, p_xpath_root=>m_xpath_root, p_xpath_child=>m_xpath,p_replacetagvalue_list=>m_replacetagvalue_list,p_paramvalue=>m_paramvalue);
        DBMS_OUTPUT.put_line(RPAD('IsEmail:',35,' ')|| m_paramvalue);

        m_xpath    := m_xpath_node || 'RequestMethodS/ISSMS';
        m_paramvalue    := m_IsSms;
        DBMS_OUTPUT.put_line('IsSms m_xpath : ' || m_xpath);
        DBMS_OUTPUT.put_line('IsSms m_paramvalue : ' || m_paramvalue);
        m_return_code    := mgmt_institutionparam_usexpath(p_action_passed=>'INSERT-UPDATE',p_institutionid_passed=>m_institutionid, p_xpath_root=>m_xpath_root, p_xpath_child=>m_xpath,p_replacetagvalue_list=>m_replacetagvalue_list,p_paramvalue=>m_paramvalue);
        DBMS_OUTPUT.put_line(RPAD('IsSms:',35,' ')|| m_paramvalue);

            DBMS_OUTPUT.put_line('---------------------------Redirectiondomains---------------------------');

            FOR j IN c1(m_domain)
            LOOP
                m_running_number            := m_running_number + 1 ;
                m_running_number_ctr        := LPAD(m_running_number, 2, '0');
                m_xpath                         := m_xpath_node || 'Redirectiondomains/domain';

                DBMS_OUTPUT.put_line('****Domain : ' || j.domain);

                m_paramvalue                    := j.domain;
                m_replacetagvalue_main        := '[nn]' || ':' || m_running_number_ctr; --|| '|';
                m_replacetagvalue_list          := m_replacetagvalue_main;
                DBMS_OUTPUT.put_line('m_replacetagvalue_list : ' || m_replacetagvalue_list);
               m_return_code                   := mgmt_institutionparam_usexpath(p_action_passed=>'INSERT-UPDATE',p_institutionid_passed=>m_institutionid, p_xpath_root=>m_xpath_root, p_xpath_child=>m_xpath, p_replacetagvalue_list=>m_replacetagvalue_list, p_paramvalue=>m_paramvalue);
            END LOOP;

            DBMS_OUTPUT.put_line('-----------------------End of IncomeExpenseAnalysisService---------------------');



    EXCEPTION
        WHEN ONBOARDING_EXCEPTION
        THEN
            m_audittext := 'Invalid xml path: ' || m_exception_desc;
            DBMS_OUTPUT.put_line('m_exception_desc : ' || m_exception_desc);
            --ROLLBACK;
            RAISE OB_AUDIT_LOG;

        WHEN NO_DATA_FOUND
        THEN
            DBMS_OUTPUT.put_line(SQLERRM);
            m_audittext := 'Invalid XML Format';
            --ROLLBACK;
            RAISE OB_AUDIT_LOG;

        WHEN SERVICE_NOT_SUBSCRIBED
        THEN


            DELETE FROM institutionparameters
            WHERE INSTITUTIONID = m_institutionid
            AND PATH LIKE 'INCOME_EXPENSE_ANALYSIS_SERVICE%';
            COMMIT;

            DBMS_OUTPUT.PUT_LINE('Rows deleted : '||SQL%ROWCOUNT);

            m_return_code := mgmt_institutionparameter(p_action=>'INSERT-UPDATE',p_institutionid=>m_institutionid, p_path_old=>'INCOME_EXPENSE_ANALYSIS_SERVICE.ACCOUNT.SUBSCRIPTION', p_paramname=>'SUBSCRIPTION', p_paramvalue=>'NO');

            m_audittext := 'IncomeExpenseAnalysisService not subscribed.';
            RAISE OB_AUDIT_LOG;
            RETURN 0;

            RAISE OB_AUDIT_LOG;
        WHEN OTHERS
        THEN

            DBMS_OUTPUT.put_line ('OTHERS...'||SQLCODE || SQLERRM || dbms_utility.format_error_backtrace);
    END;
    RETURN 0;

EXCEPTION
    WHEN OB_AUDIT_LOG
    THEN
        genaudit_insert_enchash_wrap
        (
        p_messageno=>g_messageno,
        p_queueid=>g_queueid,
        p_username=>NULL,
        p_application=>'PELICAN',
        p_modulename=>'ONBOARDING',
        p_action=>'IMPORT',
        --p_audittext=>'Customer ==> '|| m_institutionid || ' issues encountered while onboarding. Onboarding Failed',
        p_audittext=>m_audittext,
        p_institutionid=>m_institutionid,
        p_incr_count=>0
        );
        RETURN 1;
END;
/
-- [8.1.90.7] [20221109] [PTRAMBAKE] [END]
EXIT;