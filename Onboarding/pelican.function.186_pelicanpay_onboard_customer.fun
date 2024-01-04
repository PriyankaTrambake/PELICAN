-- [8.1.90.7] [20221109] [PTRAMBAKE] [START]
create or replace FUNCTION          pelicanpay_onboard_customer(p_onboard_info IN CLOB,
                                                                  p_data_keyid_list       IN VARCHAR2 DEFAULT NULL)
                                                                  RETURN NUMBER
    AS
        m_onboard_clob              CLOB            := EMPTY_CLOB();
        m_onboard_xtype             XMLTYPE;
        m_id                        VARCHAR2(12)    := NULL;
        m_CustomerType              VARCHAR2(255)   := NULL;
        m_CustomerSubType           VARCHAR2(255)   := NULL;
        m_CustomerName              VARCHAR2(255)   := NULL;
        m_StatusCustomer            VARCHAR2(255)   := NULL;
        m_StatusConfig              VARCHAR2(255)   := NULL;
        m_channel_id                VARCHAR2(25)    := NULL;
        m_CreditorSchemeId          VARCHAR2(255)   := NULL;
        m_channel_name              VARCHAR2(255)   := NULL;
        p_cinstitutionid            VARCHAR2(12)    := NULL;
        m_outputdeliverytype        VARCHAR2(35)    := NULL;
        m_parent_id                 VARCHAR2(12)    := NULL;
        m_ParentCoCNumber           INSTITUTION_ORGANIZATION_INFO.EST_CHAMBER_OF_COMMERCE_ID%TYPE   := NULL;

        m_Stage                     XMLTYPE;
        m_Account                   XMLTYPE;

        m_nooftokens                VARCHAR2(35)    := NULL;
        m_ServiceProvider           VARCHAR2(500)    := NULL;
        m_brandname                 VARCHAR2(500)    := NULL;
        m_TenantName                VARCHAR2(500)    := NULL;
        m_name                      VARCHAR2(35)    := NULL;
        m_address_line1             VARCHAR2(70)    := NULL;
        m_address_line2             VARCHAR2(70)    := NULL;
        m_address_line3             VARCHAR2(70)    := NULL;
        m_address_line4             VARCHAR2(70)    := NULL;
        m_address_line5             VARCHAR2(70)    := NULL;
        m_address_line6             VARCHAR2(70)    := NULL;
        m_bog_routeeradres          VARCHAR2(35)    := NULL;
        m_SupportEmailId            VARCHAR2(255)    := NULL;
        m_SupportMobileNo           VARCHAR2(30)    := NULL;
        m_bog_relationnumber        VARCHAR2(35)    := NULL;
        m_emailaddress              VARCHAR2(255)   := NULL;
        m_apikey                      VARCHAR2(255)   := NULL;
        m_Auth2Level                 VARCHAR2(255)   := NULL;
        m_iban                      VARCHAR2(35)    := NULL;
        n_iban                      VARCHAR2(35)    := NULL;
        m_mode                      VARCHAR2(30)    := NULL;
        n_name                      VARCHAR2(35)    := NULL;
        m_sepascheme                VARCHAR2(35)    := NULL;
        n_code                      NUMBER(3)       := NULL;
        m_code                      NUMBER(3)       := NULL;
        m_error_code                VARCHAR2(255)   := NULL;
        m_output_channel            VARCHAR2(255)   := NULL;
        m_input_channel             VARCHAR2(255)   := NULL;
        m_erroratlevel              VARCHAR2(255)   := NULL;
        m_result                    VARCHAR2(32767) := NULL;
        m_return_value              NUMBER(10)      := NULL;
        m_temp                      VARCHAR2(32767) := NULL;
        ctr                         VARCHAR(5)      := '0';
        m_val                       CHAR(1)         := '0';
        m_val1                      VARCHAR(5)      := '0';
        m_xpath                     VARCHAR2(4000)  := NULL;
        m_xpath1                    VARCHAR2(4000)  := NULL;
        m_xpath2                    VARCHAR2(4000)  := NULL;
        m_label_file_type           VARCHAR2(4000)  := NULL;
        m_path                      VARCHAR2(4000)  := NULL;
        m_exception_desc            GENAUDIT.audittext%TYPE  := NULL;
        m_ultimatetime              DATE;
        m_scanningrequired          VARCHAR2(10)    := NULL;
        m_monitoringrequired        VARCHAR2(10)    := NULL;
        m_path1                     VARCHAR2(4000)  := NULL;
        m_count                     NUMBER          := 0;
        m_return_code               NUMBER          := 0;
        m_return_number             NUMBER          := 0;
        m_count_verwinfoa           NUMBER          := 0;
        m_count_verwinfob           NUMBER          := 0;
        m_count_verwinfoc           NUMBER          := 0;
        m_count_verwinfoc1          NUMBER          := 0;
        m_count_verwinfoc2          NUMBER          := 0;
        m_count_synonym             NUMBER          := 0;
        m_seqno                     VARCHAR(04)     := NULL;
        m_ctr                       VARCHAR(04)     := NULL;
        g_messageno                 GENAUDIT.messageno%TYPE    := NULL;
        g_queueid                   GENAUDIT.queueid%TYPE    := NULL;
        m_institutionid             INSTITUTIONMASTER.institutionid%TYPE     := NULL;
--        m_countrycode                VARCHAR2(25)                            := NULL;
--        m_cocnumber                    VARCHAR2(25)                            := NULL;
        m_institution               EXCEPTION;
        m_invalidxml                EXCEPTION;
        m_exp_ultimatetime          EXCEPTION;
        invalid_data                EXCEPTION;
        customer_inactive_status    EXCEPTION;
        customer_does_not_exist     EXCEPTION;
        onboarding_exception        EXCEPTION;
        customer_already_onboarded  EXCEPTION;
        mandatory_field_not_found   EXCEPTION;
        INVALID_ACCESS_CONTROL      EXCEPTION;
        m_date                      VARCHAR2(15)    := NULL;
        m_verwinfoa                 BOOLEAN         := FALSE;
        m_verwinfob                 BOOLEAN         := FALSE;
        m_verwinfoc                 BOOLEAN         := FALSE;
        m_function                  NUMBER          := 0;

        m_account_number            ACCOUNT_MASTER.account_number%TYPE    := NULL;
        m_account_customer_id       ACCOUNT_MASTER.customer_id%TYPE      := NULL;
        m_bank_code                 ACCOUNT_MASTER.bank_code%TYPE       := NULL;
        m_tdvalue                   TABLEDETAILS.tdvalue%TYPE           := NULL;

        m_replacetagvalue_main      VARCHAR2(4000)                      := NULL;
        m_replacetagvalue_list      VARCHAR2(4000)                      := NULL;
        m_comp_prev_name            VARCHAR2(50)                        := NULL;
        m_business_nature           VARCHAR2(500)                       := NULL;
        m_pep                       VARCHAR2(3)                         := NULL;
        m_buss_other_ctry           VARCHAR2(3)                         := NULL;
        m_exp_annual_vol            VARCHAR2(250)                       := NULL;
        m_company_type              VARCHAR2(50)                        := NULL;
        m_company_status            VARCHAR2(50)                        := NULL;


        m_StreetName                INSTITUTION_ORGANIZATION_INFO.EST_HQ_STREET_NAME%TYPE     := NULL;
        m_HouseNo                   INSTITUTION_ORGANIZATION_INFO.EST_HQ_HOUSE_NO_1%TYPE      := NULL;
        m_PostalCode                INSTITUTION_ORGANIZATION_INFO.EST_HQ_POSTAL_CODE%TYPE     := NULL;
        m_node_present              NUMBER                                                      := 0;
        m_acc_node_present          NUMBER                                                      := 0;
        m_node_present1             NUMBER                                                      := 0;
        m_node_present2             NUMBER                                                      := 0;
        m_xtype                     XMLTYPE;
        m_parent_tag_path           VARCHAR2(255)                                := NULL;
        m_paymenttimestamp          VARCHAR2(255)                                := NULL;
        m_uuser_auth_count          NUMBER                                       := 0;
        m_defaultaccount_flag       ACCOUNT_MASTER.DEFAULT_ACCOUNT_FLAG%TYPE      := 'NO';
        m_default_acc_no            ACCOUNT_MASTER.PELICAN_ACCOUNT_NO%TYPE      := 0;
        m_bic                       ACCOUNT_MASTER.BANK_CODE%TYPE      := NULL;
        m_BankWiSeConnection        XMLTYPE;
        m_running_number            NUMBER                                      := 0;
        m_running_number_ctr        VARCHAR2(4000)                              := NULL;
        m_createtimestamp           TIMESTAMP(6)                                := NULL;
        m_updatetimestamp           TIMESTAMP(6)                                := NULL;

    m_beg_ctr                   NUMBER;
        m_end_ctr                   NUMBER;

        CURSOR
        c1
        IS
        SELECT     *
        FROM     XMLTable('/ProductConfiguration/Customer/PostalAddress/AddressLine' PASSING m_onboard_xtype
                        COLUMNS AddressLine                       VARCHAR2(255)   PATH '.');

        CURSOR
        c2 (c_path VARCHAR2)
        IS
        SELECT     *
        FROM     XMLTable('/ProductConfiguration/Customer/Reporting' PASSING m_onboard_xtype
                        COLUMNS ServiceSubscription              VARCHAR2(3)    PATH 'ServiceSubscription',
                                ScanningAndTransactionMonitoringServiceSubscription VARCHAR(3) PATH 'ScanningAndTransactionMonitoringServiceSubscription',
                                UltimateTime                     VARCHAR2(255)  PATH 'UltimateTime',
                                MatchStatements                  VARCHAR2(255)  PATH  'MatchStatements',
                                ScanningRequired                 VARCHAR2(255)  PATH  'ScanningRequired',
                                MonitoringRequired               VARCHAR2(255)  PATH  'MonitoringRequired') Reporting;

        CURSOR
        c3 (c_path VARCHAR2)
        IS
        SELECT     *
        FROM     XMLTable('/ProductConfiguration/Customer/Conversion' PASSING m_onboard_xtype
                        COLUMNS ServiceSubscription                    VARCHAR2(3)    PATH 'ServiceSubscription') Conversion;

        CURSOR
        c4 (c_path VARCHAR2)
        IS
        SELECT     *
        FROM     XMLTable('/ProductConfiguration/Customer/Conversion/OrderingAgreement' PASSING m_onboard_xtype
                        COLUMNS SEPAScheme                      VARCHAR2(255)  PATH 'SEPAScheme',
                                SDDTransactionType              VARCHAR2(255)  PATH 'SDDTransactionType',
                                CreditorSchemeId                VARCHAR2(255)  PATH 'CreditorSchemeId',
                                MandateDeliveryType             VARCHAR2(255)  PATH 'MandateDeliveryType',
                                OutputDestination               VARCHAR2(255)  PATH 'OutputDestination',
                                OnboardingAllServiced           VARCHAR2(255)  PATH 'OnboardingAllServicedCorporates',
                                IBANXML                            XMLTYPE           PATH 'OrderingAccounts/IBAN')  Conversion;

        CURSOR
        c5 (c_path VARCHAR2)
        IS
        SELECT     *
        FROM     XMLTable(c_path PASSING m_onboard_xtype  COLUMNS iban  VARCHAR2(35)  PATH '.');

        CURSOR
        c6 (c_path VARCHAR2)
        IS
        SELECT     *
        FROM     XMLTable('/ProductConfiguration/Customer/Conversion/AccountInformation/AccountsPerChannel' PASSING m_onboard_xtype
                        COLUMNS OutputChannel                VARCHAR2(255)  PATH 'OutputChannel',
                                AccountNumber                VARCHAR2(255)  PATH 'AccountNumber',
                                IBAN                         VARCHAR2(255)  PATH 'IBAN',
                                AgentBIC                     VARCHAR2(255)  PATH 'AgentBIC',
                                CorporateName                VARCHAR2(255)  PATH 'CorporateName');

        CURSOR
        c7 (c_path VARCHAR2)
        IS
        SELECT     *
        FROM     XMLTable('/ProductConfiguration/Customer/Reporting/OutputSettings' PASSING m_onboard_xtype
                        COLUMNS FileType                         VARCHAR2(255)  PATH 'FileType',
                                VERWINFOCFileTypeSpecial         VARCHAR2(255)  PATH 'VERWINFOCFileTypeSpecial',
                                Structure                        VARCHAR2(255)  PATH 'Structure',
                                Aggregation                      VARCHAR2(255)  PATH 'Aggregation',
                                --InputChannel                     VARCHAR2(255)  PATH 'InputChannel',
                                OutputChannel                    VARCHAR2(255)  PATH 'OutputChannel',
                                Accounts                         XMLTYPE        PATH 'Account') Reporting;


        CURSOR
        c8 (c_institutionid institutionparameters.institutionid%TYPE)
        IS
        SELECT *
        FROM  institutionparameters
        WHERE PATH LIKE 'REPORTING.OUTPUT_SETTINGS-%'
        AND   institutionid = c_institutionid;

        CURSOR
        c19 (c_institutionid institutionparameters.institutionid%TYPE)
        IS
        SELECT *
        FROM  institutionparameters
        WHERE PATH LIKE 'REPORTING.VERWINFO%'
        AND   institutionid = c_institutionid;

        CURSOR
        c9 (c_institutionid institutionparameters.institutionid%TYPE)
        IS
        SELECT *
        FROM  institutionparameters
        WHERE PATH LIKE 'CONVERSION.ORDERING_AGREEMENT-%'
        AND   PATH NOT LIKE 'CONVERSION.ORDERING_AGREEMENT-%.ORDERING_ACCOUNTS%'
        AND   institutionid = c_institutionid;

        CURSOR
        c10 (c_institutionid institutionparameters.institutionid%TYPE)
        IS
        SELECT *
        FROM  institutionparameters
        WHERE PATH LIKE 'CONVERSION.ACCOUNT_INFORMATION.ACCOUNTS_PER_CHANNEL-%'
        --AND   PATH NOT LIKE 'CONVERSION.ORDERING_AGREEMENT-%.ACCOUNT_INFORMATION'
        AND   institutionid = c_institutionid;

        CURSOR
        c11 (c_path VARCHAR2)
        IS
        SELECT     *
        FROM     XMLTable('/ProductConfiguration/Customer/Conversion/AccountInformation/OutputChannel_SA' PASSING m_onboard_xtype
                        COLUMNS OutputChannel_SA                VARCHAR2(255)  PATH '.');


        CURSOR
        c13 (c_institutionid CREDITORSCHEMEID.institution_id%TYPE)
        IS
        SELECT     *
        FROM     creditorschemeid
        WHERE    institution_id = c_institutionid;

        CURSOR
        c14 (c_institutionid ACCOUNT_MASTER.institution_id%TYPE)
        IS
        SELECT     *
        FROM     account_master
        WHERE    institution_id = c_institutionid;

        CURSOR
        c15 (c_path VARCHAR2)
        IS
        SELECT     *
        FROM     XMLTable('/ProductConfiguration/Customer/GUI-Licenses/License' PASSING m_onboard_xtype
                            COLUMNS application                       VARCHAR2(25)   PATH 'Application',
                                numoflicenses                   VARCHAR2(255)  PATH 'NumOfLicenses');

        CURSOR
        c16 (c_institutionid institutionparameters.institutionid%TYPE)
        IS
        SELECT *
        FROM  institutionparameters
        WHERE PATH LIKE 'CONVERSION.ORDERING_AGREEMENT-%.ORDERING_ACCOUNTS'
        AND   institutionid = c_institutionid;

        CURSOR
        c17 (c_path VARCHAR2)
        IS
        SELECT     *
        FROM     XMLTable(c_path PASSING m_onboard_xtype
                        COLUMNS iban            VARCHAR2(35)  PATH '.');
        CURSOR
        c18(c_iban IN XMLTYPE)
        IS
        SELECT   *
        FROM     XMLTable
                ('*' PASSING c_iban
                  COLUMNS IBAN            VARCHAR2(255)  PATH 'IBAN',
                            AccountNo       VARCHAR2(255)  PATH 'AccountNo',
                          InputChannel VARCHAR2(255)  PATH 'InputChannel',
                            INGMigration VARCHAR2(255)  PATH 'INGMigration') data;

        CURSOR
        c20(c_iban IN XMLTYPE)
        IS
        SELECT   *
        FROM     XMLTable
                ('*' PASSING c_iban
                  COLUMNS IBAN            VARCHAR2(255)  PATH '.') data;

        CURSOR c21(c_Stage IN XMLTYPE)
        IS
        SELECT     *
        FROM     XMLTable('*'   PASSING c_Stage
                                COLUMNS StageName    VARCHAR2(255)   PATH 'StageName',
                                        StageAccessControl           VARCHAR2(255)   PATH 'StageAccessControl',
                                        Product          XMLTYPE            PATH 'Thresholds/Products');

        CURSOR c22(c_Products IN XMLTYPE)
        IS
        SELECT     *
        FROM     XMLTable('*'   PASSING c_Products
                                COLUMNS ProductId       VARCHAR2(255)    PATH 'ProductId',
                                        ThresholdAmountPerCurrency XMLTYPE PATH 'ThresholdAmountPerCurrency');

        CURSOR c22a(c_Threshold IN XMLTYPE)
        IS 
        SELECT * 
        FROM XMLTable('*'  PASSING c_Threshold
                           COLUMNS Currency        VARCHAR2(10)     PATH 'Currency',
                                   ThresholdSecondSignature VARCHAR2(255)  PATH    'ThresholdSecondSignature',
                                   ThresholdThirdSignature  VARCHAR2(255)  PATH    'ThresholdThirdSignature');
                                   
        CURSOR c23(c_Account IN XMLTYPE)
        IS
        SELECT     *
        FROM     XMLTable('*'   PASSING c_Account
                                COLUMNS AccountCurrency       VARCHAR2(255)    PATH 'AccountCurrency',
                                        country_code     VARCHAR2(255)  PATH    'CountryCode',
                                        AcountNumber    VARCHAR2(255)  PATH    'AcountNumber',
                                        IBAN        VARCHAR2(255)   PATH 'IBAN',
                                        account_title    VARCHAR2(255)   PATH 'Name',
                                        BIC VARCHAR2(255)   PATH 'BIC',
                                        status  VARCHAR2(255) PATH 'status',
                                        AccountId VARCHAR2(255) PATH 'AccountId',
                                        BankName            VARCHAR2(1000) PATH 'BankName',
                                        BankImageURL            VARCHAR2(1000) PATH 'ImageURL',
                                        AccountMode         VARCHAR2(1000) PATH 'AccountMode',
                                        AccountcustomerId   VARCHAR2(1000) PATH 'AccountCustomerId',
                                        AccountSchemeId     VARCHAR2(1000) PATH 'AccountSchemeId',
                                        DefaultAccount      VARCHAR2(1000) PATH 'DefaultAccount',
                                        CreatedBy            VARCHAR2(255)  PATH 'CreatedBy');

        CURSOR
        c25 (c_ubo IN XMLTYPE)
        IS
        SELECT     *
        FROM     XMLTable('*' PASSING c_ubo
                        COLUMNS UBOID                    VARCHAR2 (250)  PATH 'UBOID',
                                Title                   VARCHAR2 (250)  PATH 'Title',
                                Role                    VARCHAR2 (4000) PATH 'Role',
                                LastName                VARCHAR2 (500) PATH 'LastName',
                                FirstName               VARCHAR2 (500) PATH 'FirstName',
                                DateOfBirth             VARCHAR2 (500) PATH 'DateOfBirth',
                                PlaceOfBirth            VARCHAR2 (100) PATH 'PlaceOfBirth',
                                CountryOfBirth          VARCHAR2 (3) PATH 'CountryOfBirth',
                                InsertFlag              VARCHAR2 (500) PATH 'InsertFlag',
                                Nationality                VARCHAR2 (500) PATH 'Nationality',
                                CountryOfResidence        VARCHAR2 (500) PATH 'CountryOfResidence',
                                Appointedon                VARCHAR2 (500) PATH 'Appointedon',
                                Shares                  VARCHAR2 (250) PATH 'Shares',
                                Address                   VARCHAR2 (500) PATH 'Address',
                                Status                    VARCHAR2 (500) PATH 'Status');
        CURSOR
        c26 (c_AccountingPackage IN XMLTYPE)
        IS
        SELECT     *
        FROM     XMLTable('*' PASSING c_AccountingPackage
                        COLUMNS AccPacTp                VARCHAR2 (250)  PATH 'AccPacTp',
                                customerId              VARCHAR2 (4000) PATH 'customerId',
                                Shortcode               VARCHAR2 (500)  PATH 'ShortCode',
                                Services                        XMLTYPE PATH 'Services/Service',
                                --PaymentMethods                XMLTYPE PATH 'PaymentMethods',
                                WebUser                         VARCHAR2(120) PATH 'Loket/WebUser',
                                WebPass                 VARCHAR2 (120) PATH 'Loket/WebPass',
                                WebEnv                  VARCHAR2(120)  PATH 'Loket/WebEnv',
                                UserName                VARCHAR2(120)  PATH 'Nmbrs/UserName',
                                token                   VARCHAR2(120)  PATH 'Nmbrs/token',
                                tokenInstitutionId      VARCHAR2(120)  PATH 'Nmbrs/tokenInstitutionId',
                                AccountOfficeRef                VARCHAR2(120)  PATH 'Xero/Tax/AccountOfficeRef',
                                Tax_PayableDateforeveryMonth        VARCHAR2(120)  PATH 'Xero/Tax/PayableDateforeveryMonth',
                                PensionProivderName             VARCHAR2(120)  PATH 'Xero/Pension/PensionProivderName',
                                PensionProivderID               VARCHAR2(120)  PATH 'Xero/Pension/PensionProivderID',
                                PesionProivderAccountName       VARCHAR2(120)  PATH 'Xero/Pension/PesionProivderAccountName',
                                PesionProivderAccountSortCode   VARCHAR2(120)  PATH 'Xero/Pension/PesionProivderAccountSortCode',
                                PesionProivderAccountNumber     VARCHAR2(120)  PATH 'Xero/Pension/PesionProivderAccountNumber',
                                PayableDateforeveryMonth        VARCHAR2(120)  PATH 'Xero/Pension/PayableDateforeveryMonth',
                                AccessToken             VARCHAR2(120)  PATH 'Oauth/AccessToken',
                                AccessTokenExpiryDate   VARCHAR2(120)  PATH 'Oauth/AccessTokenExpiryDate',
                                RefreshToken            VARCHAR2(120)  PATH 'Oauth/RefreshToken',
                                RefreshTokenExpiryDate  VARCHAR2(120)  PATH 'Oauth/RefreshTokenExpiryDate',
                                PaymentMode                VARCHAR2(120)  PATH 'PaymentOption/PaymentMode',
                                PaymentRunDateType        VARCHAR2(120)  PATH 'PaymentOption/PaymentRunDateType',
                                PaymentNValue            VARCHAR2(120)  PATH 'PaymentOption/PaymentNValue',
                                PaymentDayOfWeek        VARCHAR2(120)  PATH 'PaymentOption/PaymentDayOfWeek',
				PaymentServiceId        VARCHAR2(500)  PATH 'Xero/PaymentRequest/PaymentServiceId',
                                PaymentRequestThemeId   VARCHAR2(500)  PATH 'Xero/PaymentRequest/PaymentRequestThemeId',
                                FinancialYearEndDay     VARCHAR2(120)  PATH 'Xero/FHC/FinancialPeriod/FinancialYearEndDay',
                                FinancialYearEndMonth   VARCHAR2(120)  PATH 'Xero/FHC/FinancialPeriod/FinancialYearEndMonth'
                                );

        --c27 (c_PaymentMethods IN XMLTYPE)
       /* c27(c_Service IN XMLTYPE)
        IS
        SELECT     *
        FROM     XMLTable('*' PASSING c_Service
                              COLUMNS PaymentMethod                   VARCHAR2 (250)  PATH 'PaymentMethod',
                                        PaymentOutPutMode               VARCHAR2 (250)  PATH 'PaymentOutPutMode');*/
        CURSOR
    c30(c_Service IN XMLTYPE)
        IS
        SELECT     *
    FROM     XMLTable('*' PASSING c_Service
                          COLUMNS ProductId                   VARCHAR2 (250)  PATH 'ProductId',
                                    ServiceId               VARCHAR2 (250)  PATH 'ServiceId',
                                    PaymentMethod           VARCHAR2 (250)  PATH 'PaymentMethods/PaymentMethod',
                                    PaymentOutPutMode               VARCHAR2 (250)  PATH 'PaymentMethods/PaymentOutPutMode',
                                    DefaultAccountNo           VARCHAR2 (250)  PATH 'DefaultAccountNo',
                                     EscrowInstitutionId        VARCHAR2 (250)  PATH 'EscrowInstitutionId',
                                     createtimestamp            VARCHAR2 (250)  PATH 'createTimestamp',
                                     updatetimestamp            VARCHAR2 (250)  PATH 'updateTimestamp');

    --procedure will look up to institutionparameters  scripts at concentrator institution for RECORD_TYPE as 'C'.
    CURSOR c28 (c_institutionid institutionparameters.institutionid%TYPE)
    IS
    SELECT     *
    FROM    institutionparameters
    WHERE    record_type = 'C'
    AND        institutionid = c_institutionid;

    CURSOR c29 (c_path institutionparameters.path%TYPE,c_institutionid institutionparameters.institutionid%TYPE)
    IS
    SELECT     *
    FROM    institutionparameters
    WHERE   path = c_path
    AND institutionid = c_institutionid;     --Parent Institution

    CURSOR
    c31 (c_BankWiSeConnection IN XMLTYPE)
    IS
    SELECT     *
    FROM     XMLTable('*' PASSING c_BankWiSeConnection
                        COLUMNS BankBIC                VARCHAR2 (250)  PATH 'BankBIC',
                                FileType              VARCHAR2 (250) PATH 'ConnectivityConfiguration/FileType',
                                MessageIdentifier        VARCHAR2(250)  PATH 'ConnectivityConfiguration/MessageIdentifier',
                                Auth_DN                      VARCHAR2(250)  PATH 'ConnectivityConfiguration/AuthUser/DN',
                                Auth_FullName                      VARCHAR2(250)  PATH 'ConnectivityConfiguration/AuthUser/FullName',
                                Sender_DN                      VARCHAR2(250)  PATH 'ConnectivityConfiguration/Sender/DN',
                                Sender_FullName                      VARCHAR2(250)  PATH 'ConnectivityConfiguration/Sender/FullName',
                                Receiver_DN                      VARCHAR2(250)  PATH 'ConnectivityConfiguration/Receiver/DN',
                                Receiver_FullName                      VARCHAR2(250)  PATH 'ConnectivityConfiguration/Receiver/FullName',
                                Service                      VARCHAR2(250)  PATH 'ConnectivityConfiguration/NetworkInfo/Service',
                                Network                      VARCHAR2(250)  PATH 'ConnectivityConfiguration/NetworkInfo/Network',
                                SwCompression                      VARCHAR2(250)  PATH 'ConnectivityConfiguration/FileInfo/SwCompression',
                                FileMode                      VARCHAR2(250)  PATH 'ConnectivityConfiguration/OtherParameters/FileMode',
                                PositiveDeliveryNotification  VARCHAR2(250)  PATH 'ConnectivityConfiguration/OtherParameters/PositiveDeliveryNotification',
                                ACKReceiverDN                      VARCHAR2(250)  PATH 'ConnectivityConfiguration/OtherParameters/ACKReceiverDN',
                                NRFlag                      VARCHAR2(250)  PATH 'ConnectivityConfiguration/OtherParameters/NRFlag',
                                DeliveryNotificationQ                      VARCHAR2(250)  PATH 'ConnectivityConfiguration/OtherParameters/DeliveryNotificationQ',
                                ACKRequestType                      VARCHAR2(250)  PATH 'ConnectivityConfiguration/OtherParameters/ACKRequestType'
                                );
 --TYPE a_conc_institutionid            IS TABLE OF institutionparameters.institutionid%TYPE;
    TYPE a_conc_institutionid            IS TABLE OF institutionparameters%ROWTYPE;
    t_conc_institutionid                 a_conc_institutionid             := a_conc_institutionid();

 TYPE a_conc_path            IS TABLE OF institutionparameters%ROWTYPE;
    t_conc_path                 a_conc_path             := a_conc_path();

        TYPE a_institutionid            IS TABLE OF institutionparameters.institutionid%TYPE;
        TYPE a_sequenceno               IS TABLE OF institutionparameters.sequenceno%TYPE;
        TYPE a_paramname                IS TABLE OF institutionparameters.paramname%TYPE;
        TYPE a_path                     IS TABLE OF institutionparameters.path%TYPE;
        TYPE a_institutionparameters    IS TABLE OF institutionparameters%ROWTYPE;

        TYPE b_institution_id           IS TABLE OF CREDITORSCHEMEID.institution_id%TYPE;
        TYPE a_crscheme_id              IS TABLE OF CREDITORSCHEMEID.crscheme_id%TYPE;
        TYPE a_creditorschemeid         IS TABLE OF CREDITORSCHEMEID%ROWTYPE;

        TYPE a_customer_id              IS TABLE OF ACCOUNT_MASTER.customer_id%TYPE;
        TYPE a_account_number           IS TABLE OF ACCOUNT_MASTER.account_number%TYPE;
        TYPE a_bank_code                IS TABLE OF ACCOUNT_MASTER.bank_code%TYPE;
        TYPE a_branch_code              IS TABLE OF ACCOUNT_MASTER.branch%TYPE;
        TYPE g_institutionid            IS TABLE OF ACCOUNT_MASTER.institution_id%TYPE;
        TYPE a_account_master           IS TABLE OF ACCOUNT_MASTER%ROWTYPE;

        t_crscheme_id                   a_crscheme_id               := a_crscheme_id();
        t_creditorschemeid              a_creditorschemeid          := a_creditorschemeid();

        t_customer_id                   a_customer_id               := a_customer_id();
        t_account_number                a_account_number            := a_account_number();
        t_bank_code                     a_bank_code                 := a_bank_code();
        t_branch_code                   a_branch_code               := a_branch_code();
        t_institutionid                 a_institutionid             := a_institutionid();
        t_account_master                a_account_master            := a_account_master();

        t_institutionid                 a_institutionid             := a_institutionid();
        t_paramname                     a_paramname                 := a_paramname();
        t_path                          a_path                      := a_path();
        t_sequenceno                    a_sequenceno                := a_sequenceno();
        t_institutionparameters         a_institutionparameters     := a_institutionparameters();

        t_order_agg                     a_institutionparameters     := a_institutionparameters();
        t_accperchan                    a_institutionparameters     := a_institutionparameters();
        t_accinfo                       a_institutionparameters     := a_institutionparameters();
        t_order_acc                     a_institutionparameters     := a_institutionparameters();

        --Added to support deletion of user related details in case of Invoice 21-03-2017
        m_ta_subscription                VARCHAR2(10)                := NULL;
        m_cnvrsn_subscription           VARCHAR2(10)                := NULL;
        m_rpt_subscription              VARCHAR2(10)                := NULL;
        m_mndt_subscription             VARCHAR2(10)                := NULL;
        m_invpay_subscription           VARCHAR2(10)                := NULL;
        m_del_updt_usr_det              NUMBER                      := 0;
        --Added to support deletion of user related details in case of Invoice 21-03-2017
        m_LocalCurrencyCode                VARCHAR2(255)   := NULL;
        m_StatusUpdateNotificationInterval VARCHAR2(255)   := NULL;
        m_DueDatePeriodCriteria         VARCHAR2(255)   := NULL;
        m_DueDateBufferDays             VARCHAR2(255)   := NULL;
        m_InstitutionAccessControl      VARCHAR2(255)   := NULL;

        m_xpath_node                    OB_XPATH_INSTPARMPATH_MAP.xpath_node%TYPE   := 'Customer';
        m_xpath_root                    OB_XPATH_INSTPARMPATH_MAP.xpath_root%TYPE   := 'ProductConfiguration';
        m_paramvalue                    VARCHAR2(255)   :=NULL;
        m_ubo                           XMLTYPE;
        m_AccountingPackage             XMLTYPE;
        m_CoCNumber                     INSTITUTION_ORGANIZATION_INFO.EST_CHAMBER_OF_COMMERCE_ID%TYPE   := NULL;
        m_CountryCode                   INSTITUTION_ORGANIZATION_INFO.EST_HQ_ISO_CTRYCODE%TYPE          := NULL;
        m_City                          INSTITUTION_ORGANIZATION_INFO.EST_POSTAL_ADDR_CITY%TYPE         := NULL;
        m_LegalEntity                   INSTITUTION_ORGANIZATION_INFO.EST_LEGAL_ENTITIY_STATUS%TYPE     := NULL;
        INVALID_PRODUCTID               EXCEPTION;
        INVALID_INST_ACCESS_CTRL          EXCEPTION;
        INVALID_STAGENAME               EXCEPTION;

        p_account_string                 VARCHAR2(32767) := NULL;
        m_dob                               UBO.DATE_OF_BIRTH%TYPE := NULL;
        m_companyname                   INSTITUTION_ORGANIZATION_INFO.EST_STATUTORY_NAME%TYPE     := NULL;
        m_OriginatingSystem                   INSTITUTION_ORGANIZATION_INFO.ORIGINATING_SYSTEM%TYPE     := NULL;
        m_PaymentMethod                   INSTITUTION_ORGANIZATION_INFO.SERVICE_SUBSCRIBED%TYPE     := NULL;
        --Newly added tag for company

        m_config_flag                   NUMBER;
        m_accoutingpackagename              INSTITUTION_ORGANIZATION_INFO.ORIGINATING_SYSTEM%TYPE     := NULL;
        m_accpkg_tdvalue                TABLEDETAILS.TDVALUE%TYPE       := NULL;
        m_coc_tdvalue                TABLEDETAILS.TDVALUE%TYPE       := NULL;
    m_ctr_beg           NUMBER := 0;
    m_ctr_end  NUMBER := 0;
            m_comp_desc                VARCHAR2(4000) := NULL;
        m_partner_subscription VARCHAR2(25) := NULL;
        m_partner_client_id VARCHAR2(255) := NULL;
        m_partner_client_secret VARCHAR2(255) := NULL;
        m_partner_customer_type VARCHAR2(255) := NULL;
        m_partner_data_mode VARCHAR2(255) := NULL;
        m_partner_web_url VARCHAR2(255) := NULL;
        m_partner_web_key VARCHAR2(255) := NULL;
        m_partner_logo_url VARCHAR2(255) := NULL;
        m_partner_pro_serv_id_seq NUMBER              := 0;
        m_partner_pro_serv_id NUMBER              := 0;
        m_payment_selection VARCHAR2(255) := NULL;
        m_Categorisation_subscription VARCHAR2(25) := NULL;
        SERVICE_NOT_SUBSCRIBED            EXCEPTION;

    m_count_tenant_roles NUMBER := 0;
    m_SenderBIC                    VARCHAR2(100)        := NULL;
    m_SWIFTBICLTAddress                VARCHAR2(10)                := NULL;
    m_merchant_service                VARCHAR2(3)            :=        NULL;
    m_DynamicTheme_service            VARCHAR2(3)            :=        NULL;
    m_partnerid                       VARCHAR2(30)           :=        NULL;
    m_tppid                           VARCHAR2(30)           :=        NULL;
    m_service_ctr                       number                      := 0;
    m_account_ctr                       number                      := 0;
    m_product_flavor            TABLEDETAILS.TDVALUE%TYPE       := NULL;

BEGIN
    m_onboard_xtype := XMLTYPE(xmlData=>p_onboard_info);

    SELECT  x.CustomerType,
            x.CustomerSubType,
            x.CustomerName,
            x.StatusCustomer,
            x.StatusConfig,
            x.LocalCurrencyCode,
            x.StatusUpdateNotificationInterval,
            x.DueDatePeriodCriteria,
            x.DueDateBufferDays,
            x.id,
        x.SenderBIC,
        x.SWIFTBICLTAddress,
                x.parent_id,
                x.ParentCoCNumber,
                x.InstitutionAccessControl,
                x.Stage,
                x.Account,
                x.OriginatingSystem,
                x.PaymentMethod,
                x.CompanyName,
            x.CompanyDescription,
                x.CompanyPreviousName,
                x.CompanyBusinessNature,
                x.CompanyType,
                x.CompanyStatus,
                x.CoCNumber,
                x.CountryCode,
                x.City,
                x.LegalEntity,
                x.StreetName,
                x.HouseNo,
                x.PostalCode,
                x.PEP,
                x.BusinessOtherCountry,
                x.ExpectedAnnualVolume,
                x.UBO,
            x.Subscription,
            x.ClientID,
            x.ClientSecret,
            x.Partner_CustomerType,
            x.DataMode,
            x.WebhookCustomerURL,
            x.WebhookSecurityKey,
            x.CustomerLogoUrl,
                x.OutputDeliveryType,
                x.NoOfTokens,
                x.PartnerId,
                x.TppId,
                x.BrandName,
                x.TenantName,
                x.name,
                x.emailaddress,
                x.APIKey,
                x.Auth2Level,
                x.BankWiSeConnection,
                x.AccountingPackage,
--                x.cocnumber,
--                x.countrycode,
            x.bog_routeeradres,
            x.bog_relationnumber,
            x.SupportEmailId,
            x.SupportMobileNo,
            x.Subscription_cs
    INTO    m_CustomerType,
            m_CustomerSubType,
            m_CustomerName,
            m_StatusCustomer,
            m_StatusConfig,
            m_LocalCurrencyCode,
            m_StatusUpdateNotificationInterval,
            m_DueDatePeriodCriteria,
            m_DueDateBufferDays,
            m_id,
        m_SenderBIC,
        m_SWIFTBICLTAddress,
                m_parent_id,
                m_ParentCoCNumber,
                m_InstitutionAccessControl,
                m_Stage,
                m_Account,
                m_OriginatingSystem,
                m_PaymentMethod,
                m_CompanyName,
            m_comp_desc,
                m_comp_prev_name,
                m_business_nature,
                m_company_type,
                m_company_status,
                m_CoCNumber,
                m_CountryCode,
                m_City,
                m_LegalEntity,
                m_StreetName,
                m_HouseNo,
                m_PostalCode,
                m_pep,
                m_buss_other_ctry,
                m_exp_annual_vol,
                m_ubo,
            m_partner_subscription,
            m_partner_client_id,
            m_partner_client_secret,
            m_partner_customer_type,
            m_partner_data_mode,
            m_partner_web_url,
            m_partner_web_key,
            m_partner_logo_url,
                m_outputdeliverytype,
                m_nooftokens,
                m_partnerid,
                m_tppid,
                m_BrandName,
                m_TenantName,
                m_name,
                m_emailaddress,
                m_apikey,
                m_Auth2Level,
                m_BankWiSeConnection,
                m_AccountingPackage,
--                m_cocnumber,
--                m_countrycode,
            m_bog_routeeradres,
            m_bog_relationnumber,
            m_SupportEmailId,
            m_SupportMobileNo,
            m_Categorisation_subscription
        
      FROM XMLTable('/ProductConfiguration/Customer' PASSING m_onboard_xtype
                    COLUMNS CustomerType            VARCHAR2(255) PATH 'CustomerType',
                            CustomersubType         VARCHAR2(255) PATH 'CustomerSubType',
                            CustomerName            VARCHAR2(255) PATH 'CustomerName',
                            StatusCustomer          VARCHAR2(30)  PATH 'StatusCustomer',
                            StatusConfig            VARCHAR2(30)  PATH 'StatusConfiguration',
                            LocalCurrencyCode       VARCHAR2(255) PATH  'LocalCurrencyCode',
                            StatusUpdateNotificationInterval       VARCHAR2(255) PATH  'StatusUpdateNotificationInterval',
                            DueDatePeriodCriteria   VARCHAR2(255) PATH  'DueDatePeriodCriteria',
                            DueDateBufferDays       VARCHAR2(255) PATH  'DueDateBufferDays',
                            id                      VARCHAR2(15)  PATH 'RelationID',
                SenderBIC                VARCHAR2(100)  PATH    'SenderBIC',
                SWIFTBICLTAddress        VARCHAR2(10)       PATH  'SWIFTBICLTAddress',
                                parent_id               VARCHAR2(15)  PATH 'ParentID',
                                ParentCoCNumber          VARCHAR2 (50)       PATH    'ParentCoCNumber',
                                InstitutionAccessControl    VARCHAR2(255)   PATH    'AuthenticationLevel/InstitutionAccessControl',
                                Stage                       XMLTYPE            PATH 'AuthenticationLevel/Stages/Stage',
                                Account                     XMLTYPE         PATH    'AccountDetails/Account',
                                OriginatingSystem             VARCHAR2 (250)      PATH    'Company/OriginatingSystem',
                                PaymentMethod             VARCHAR2 (250)      PATH    'Company/PaymentMethod',
                                CompanyName             VARCHAR2 (250)      PATH    'Company/CompanyName',
                            CompanyDescription         VARCHAR2 (250)      PATH    'Company/CompanyDescription',
                                CompanyPreviousName        VARCHAR2 (250)      PATH    'Company/CompanyPreviousName',
                                CompanyBusinessNature     VARCHAR2 (250)      PATH    'Company/CompanyBusinessNature',
                                CompanyType                 VARCHAR2 (250)      PATH    'Company/CompanyType',
                                CompanyStatus             VARCHAR2 (250)      PATH    'Company/CompanyStatus',
                                CoCNumber               VARCHAR2 (50)       PATH    'Company/CoCNumber',
                                CountryCode             VARCHAR2 (250)      PATH    'Company/CountryCode',
                                City                    VARCHAR2 (100)      PATH    'Company/City',
                                LegalEntity             VARCHAR2 (500)      PATH    'Company/LegalEntity',
                                StreetName              VARCHAR2 (500)      PATH    'Company/StreetName',
                                HouseNo                 VARCHAR2 (500)      PATH    'Company/HouseNo',
                                PostalCode              VARCHAR2 (500)      PATH    'Company/PostalCode',
                                PEP                        VARCHAR2 (500)      PATH    'Company/PEP',
                                BusinessOtherCountry    VARCHAR2 (500)      PATH    'Company/BusinessOtherCountry',
                                ExpectedAnnualVolume    VARCHAR2 (500)      PATH    'Company/ExpectedAnnualVolume',
                                UBO                      XMLTYPE       PATH 'Company/UBOS/UBO',
                            Subscription            VARCHAR2(15)  PATH 'Company/PartnerService/Subscription',
                            ClientID                VARCHAR2(255)  PATH 'Company/PartnerService/ClientID',
                            ClientSecret VARCHAR2(255) PATH 'Company/PartnerService/ClientSecret',
                            Partner_CustomerType            VARCHAR2(255)  PATH 'Company/PartnerService/CustomerType',
                            DataMode                VARCHAR2(255)  PATH 'Company/PartnerService/DataMode',
                            WebhookCustomerURL      VARCHAR2(255)  PATH 'Company/PartnerService/WebhookCustomerURL',
                            WebhookSecurityKey      VARCHAR2(255)  PATH 'Company/PartnerService/WebhookSecurityKey',
                            CustomerLogoUrl         VARCHAR2(255)  PATH 'Company/PartnerService/CustomerLogoUrl',
                                OutputDeliveryType      VARCHAR2(15)  PATH 'OutputDeliveryType',
                                NoOfTokens              VARCHAR2(15)  PATH 'NoOfTokens',
                                PartnerId               VARCHAR2(30)  PATH 'PartnerId',
                                TPPId                   VARCHAR2(30)  PATH 'TPPId',
                                BrandName               VARCHAR2(500)  PATH 'BrandName',
                                TenantName              VARCHAR2(500)  PATH 'TenantName',
                                name                    VARCHAR2(35)  PATH 'RelationID',
                                emailaddress            VARCHAR2(255) PATH 'NotificationEmailAddress',
                                APIKey                  VARCHAR2(255) PATH 'APIKey',
                                Auth2Level               VARCHAR2(255) PATH 'Auth2Level',
                                BankWiSeConnection       XMLTYPE PATH 'SwiftFileAct/BankWiSeConnection',
                                AccountingPackage       XMLTYPE PATH 'AccountingPackages/AccountingPackage',
--                                cocnumber               VARCHAR2(255) PATH 'CoCNumber',
--                                countrycode             VARCHAR2(255) PATH 'CountryCode',
                            bog_routeeradres        VARCHAR2(35)  PATH 'Routingaddress',
                            bog_relationnumber      VARCHAR2(35)  PATH 'RelationNumberBOG',
                            SupportEmailId          VARCHAR2(255) PATH 'SupportDetails/SupportEmailId',
                            SupportMobileNo         VARCHAR2(30) PATH 'SupportDetails/SupportMobileNo',
                            Subscription_cs            VARCHAR2(15)  PATH 'CategorisationService/Subscription') x;

        DBMS_OUTPUT.put_line('Customer Information');
        DBMS_OUTPUT.put_line('--------------------');
        DBMS_OUTPUT.put_line('RelationID     : ' || m_id);
        DBMS_OUTPUT.put_line('SenderBIC     : ' || m_SenderBIC);
        DBMS_OUTPUT.put_line('SWIFTBICLTAddress       : ' || m_SWIFTBICLTAddress );
        DBMS_OUTPUT.put_line('ParentID       : ' || m_parent_id);
        DBMS_OUTPUT.put_line('ParentCoCNumber       : ' || m_ParentCoCNumber);
        DBMS_OUTPUT.put_line('InstitutionAccessControl       : ' || m_InstitutionAccessControl);
        DBMS_OUTPUT.put_line('OutputDeliveryType       : ' || m_outputdeliverytype);
        DBMS_OUTPUT.put_line('NoOfTokens       : ' || m_nooftokens);
        DBMS_OUTPUT.put_line('Partnerid       : ' || m_partnerid);
        DBMS_OUTPUT.put_line('TppId       : ' || m_tppid);
        DBMS_OUTPUT.put_line('Name           : ' || m_name);
        DBMS_OUTPUT.put_line('CustomerType   : ' || m_CustomerType);
        DBMS_OUTPUT.put_line('CustomerSubType   : ' || m_CustomerSubType);
        DBMS_OUTPUT.put_line('CustomerName   : ' || m_CustomerName);
        DBMS_OUTPUT.put_line('StatusCustomer : ' || m_StatusCustomer);
        DBMS_OUTPUT.put_line('StatusConfig   : ' || m_StatusConfig);
        DBMS_OUTPUT.put_line('LocalCurrencyCode   : ' || m_LocalCurrencyCode);
        DBMS_OUTPUT.put_line('StatusUpdateNotificationInterval   : ' || m_StatusUpdateNotificationInterval);
        DBMS_OUTPUT.put_line('DueDatePeriodCriteria   : ' || m_DueDatePeriodCriteria);
        DBMS_OUTPUT.put_line('DueDateBufferDays   : ' || m_DueDateBufferDays);
        DBMS_OUTPUT.put_line('emailaddress   : ' || m_emailaddress);
        DBMS_OUTPUT.put_line('APIKey   : ' || m_apikey);
        DBMS_OUTPUT.put_line('Auth2Level   : ' || m_Auth2Level);
        DBMS_OUTPUT.put_line('COC number     : ' || m_cocnumber);
        DBMS_OUTPUT.put_line('Country code   : ' || m_countrycode);
        DBMS_OUTPUT.put_line('BIGRA          : ' || m_bog_routeeradres);
        DBMS_OUTPUT.put_line('RelNumBOG      : ' || m_bog_relationnumber);
        DBMS_OUTPUT.put_line('m_OriginatingSystem      : ' || m_OriginatingSystem);
        DBMS_OUTPUT.put_line('m_PaymentMethod      : ' || m_PaymentMethod);
        DBMS_OUTPUT.put_line('m_comp_desc : ' || m_comp_desc);
        DBMS_OUTPUT.put_line('m_partner_subscription : ' || m_partner_subscription);
        DBMS_OUTPUT.put_line('m_partner_client_id : ' || m_partner_client_id);
        DBMS_OUTPUT.put_line('m_partner_client_secret: ' || m_partner_client_secret);
        DBMS_OUTPUT.put_line('m_partner_customer_type : ' || m_partner_customer_type);
        DBMS_OUTPUT.put_line('m_partner_web_url : ' || m_partner_web_url);
        DBMS_OUTPUT.put_line('m_partner_web_key : ' || m_partner_web_key);
        DBMS_OUTPUT.put_line('m_partner_logo_url : ' || m_partner_logo_url);


        DBMS_OUTPUT.put_line('m_bog_routeeradres      : ' || m_bog_routeeradres);
        DBMS_OUTPUT.put_line('m_bog_relationnumber      : ' || m_bog_relationnumber);
        DBMS_OUTPUT.put_line('supportemailid      : ' || m_supportemailid);
        DBMS_OUTPUT.put_line('supportmobileno      : ' || m_supportmobileno);
        DBMS_OUTPUT.put_line('m_Categorisation_subscription      : ' || m_Categorisation_subscription);
        -- Start - MJ: Getting subscription of all services if available 21-03-2017
        BEGIN
            SELECT  x.subscription
            INTO    m_ta_subscription
            FROM    XMLTable('/ProductConfiguration/Customer/TransactionDelivery'     PASSING         m_onboard_xtype
                                    COLUMNS     subscription    VARCHAR2(255)    PATH 'Subscription') x;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                m_ta_subscription := NVL(m_ta_subscription,'NO');
        END;

        BEGIN
            SELECT  x.subscription
            INTO    m_cnvrsn_subscription
            FROM    XMLTable('/ProductConfiguration/Customer/Conversion'     PASSING         m_onboard_xtype
                                    COLUMNS     subscription    VARCHAR2(255)    PATH 'Subscription') x;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                m_cnvrsn_subscription := NVL(m_cnvrsn_subscription,'NO');
        END;

        BEGIN
            SELECT  x.subscription
            INTO    m_rpt_subscription
            FROM     XMLTable('/ProductConfiguration/Customer/Reporting'     PASSING         m_onboard_xtype
                                    COLUMNS     subscription    VARCHAR2(255)    PATH 'Subscription') x;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                m_rpt_subscription := NVL(m_rpt_subscription,'NO');
        END;

        BEGIN
            SELECT  x.subscription
            INTO    m_mndt_subscription
            FROM    XMLTable('/ProductConfiguration/Customer/MandateService'     PASSING         m_onboard_xtype
                                    COLUMNS     subscription    VARCHAR2(255)    PATH 'Subscription') x;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                m_mndt_subscription := NVL(m_mndt_subscription,'NO');
        END;

        BEGIN
            SELECT    x.subscription
            INTO    m_merchant_service
            FROM    XMLTable('/ProductConfiguration/Customer/MerchantService' PASSING        m_onboard_xtype
                COLUMNS     Subscription    VARCHAR2(3)    PATH 'Subscription') x;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                m_merchant_service := NVL(m_merchant_service,'NO');
        END;


        BEGIN
            SELECT    x.subscription
            INTO    m_DynamicTheme_service
            FROM    XMLTable('/ProductConfiguration/Customer/DynamicThemeService' PASSING        m_onboard_xtype
                COLUMNS     Subscription    VARCHAR2(3)    PATH 'Subscription') x;
        EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                m_DynamicTheme_service := NVL(m_DynamicTheme_service,'NO');
        END;
        --SELECT  NVL(x.subscription,'NO')
        --INTO    m_invpay_subscription
        --FROM    XMLTable('/ProductConfiguration/Customer/InvoicePay'     PASSING         m_onboard_xtype
        --                        COLUMNS     subscription    VARCHAR2(255)    PATH 'Subscription') x;

        -- End - MJ: Getting subscription of all services if available 21-03-2017


        --Start - MJ: Check if any of the service (other than InvoicePay) is not subscribed then set flag as 1 else 0 21-03-2017

        SELECT  count(*)
        INTO    m_count_synonym
        FROM    table(GET_CODE_FROM_LIST(NVL(TD_GET_VALUE('ONBOARD_CONFIG','SYN_REQUIRED'),'X'),','))
        WHERE   para_code = m_tenantname;

        IF (m_ta_subscription = 'YES' OR m_cnvrsn_subscription = 'YES' OR m_rpt_subscription = 'YES' OR m_mndt_subscription = 'YES' OR m_merchant_service = 'YES' OR m_DynamicTheme_service = 'YES')
        THEN
            m_del_updt_usr_det := 1;
        ELSE
            m_del_updt_usr_det := 0;
        END IF;
        --End - MJ: Check if any of the service (other than InvoicePay) is not subscribed then set flag as 1 else 0 21-03-2017
        m_id := get_institutionid(m_id,m_CoCNumber,m_return_number);
        DBMS_OUTPUT.put_line('m_id : ' || m_id);
        IF m_return_number = 8.1
        THEN
            m_exception_desc := 'Multitple Institutions found against CoC number => ' || m_CoCNumber;
            DBMS_OUTPUT.put_line('Exception    :    ' || m_exception_desc);
            RAISE ONBOARDING_EXCEPTION;
        END IF;

        IF m_id IS NULL
        THEN
            m_return_number  := 6.11;
            m_exception_desc := 'Mandatory component =>' || m_xpath || '/' || 'RelationID' || ' not found';
            DBMS_OUTPUT.put_line('Exception    :    ' || m_exception_desc);
            RAISE ONBOARDING_EXCEPTION;
        END IF;

        DBMS_OUTPUT.put_line('Level 1');

        IF m_parent_id IS NULL
        THEN
            m_return_number  := 6.10;
            m_exception_desc := 'Mandatory component =>' || m_xpath || '/' || 'ParentID' || ' not found while onboarding Customer ID => ' || m_id ;
            DBMS_OUTPUT.put_line('Exception    :    ' || m_exception_desc);
            RAISE ONBOARDING_EXCEPTION;
        END IF;

        DBMS_OUTPUT.put_line('Level 2');

        IF m_nooftokens IS NULL
        THEN
            m_return_number  := 6.9;
            m_exception_desc := 'Mandatory component =>' || m_xpath || '/' || 'NoOfTokens' || ' not found while onboarding Customer ID => ' || m_id ;
            DBMS_OUTPUT.put_line('Exception    :    ' || m_exception_desc);
            RAISE ONBOARDING_EXCEPTION;
        END IF;

        DBMS_OUTPUT.put_line('Level 3');

        IF m_customertype IS NULL
        THEN
            m_return_number  := 6.8;
            m_exception_desc := 'Mandatory component =>' || m_xpath || '/' || 'CustomerType' || ' not found while onboarding Customer ID => ' || m_id ;
            DBMS_OUTPUT.put_line('Exception    :    ' || m_exception_desc);
            RAISE ONBOARDING_EXCEPTION;
        END IF;

        DBMS_OUTPUT.put_line('Level 4');

        IF m_CustomerSubtype IS NULL
        THEN
            IF INSTR(TD_GET_VALUE('SUBTYPE_CONFIG','BRAND_NAME'),upper(m_BrandName)) > 0
            THEN
                m_return_number  := 6.8;
                m_exception_desc := 'Mandatory component =>' || m_xpath || '/' || 'CustomerSubType' || ' not found while onboarding Customer ID => ' || m_id ;
                DBMS_OUTPUT.put_line('Exception    :    ' || m_exception_desc);
                RAISE ONBOARDING_EXCEPTION;
            ELSE
                m_CustomerSubtype:= 'Business';
            END IF;
        END IF;


        IF m_statuscustomer IS NULL
        THEN
            m_return_number  := 6.7;
            m_exception_desc := 'Mandatory component =>' || m_xpath || '/' || 'StatusCustomer' || ' not found while onboarding Customer ID => ' || m_id ;
            DBMS_OUTPUT.put_line('Exception    :    ' || m_exception_desc);
            RAISE ONBOARDING_EXCEPTION;
        END IF;

        DBMS_OUTPUT.put_line('Level 5');


        IF m_statusconfig IS NULL
        THEN
            m_return_number  := 6.6;
            m_exception_desc := 'Mandatory component =>' || m_xpath || '/' || 'StatusConfiguration' || ' not found while onboarding Customer ID => ' || m_id ;
            DBMS_OUTPUT.put_line('Exception    :    ' || m_exception_desc);
            RAISE ONBOARDING_EXCEPTION;
        END IF;

        DBMS_OUTPUT.put_line('Level 6');


        IF m_CustomerType != 'SERVICED_CORPORATE' AND m_bog_routeeradres IS NULL
        THEN
            m_return_number  := 6.5;
            m_exception_desc := 'Mandatory component =>' || m_xpath || '/' || 'Routingaddress' || ' not found while onboarding Customer ID => ' || m_id ;
            DBMS_OUTPUT.put_line('Exception    :    ' || m_exception_desc);
            RAISE ONBOARDING_EXCEPTION;
        END IF;

        DBMS_OUTPUT.put_line('Level 7');

        IF UPPER(m_statuscustomer) NOT IN('ACTIVE','INACTIVE')
        THEN
            m_return_number  := 4;
            m_exception_desc := 'Invalid Data =>' || m_xpath || '/' || 'StatusCustomer';
            DBMS_OUTPUT.put_line('Exception    :    ' || m_exception_desc);
            RAISE ONBOARDING_EXCEPTION;
        END IF;

        DBMS_OUTPUT.put_line('Level 8');

        IF UPPER(m_statuscustomer) = 'INACTIVE'
        THEN
            m_return_number  := 6.0;
            m_exception_desc := 'Status for Customer id => ' || m_id || ' is Inactive';
            DBMS_OUTPUT.put_line('Exception    :    ' || m_exception_desc);
            RAISE CUSTOMER_INACTIVE_STATUS;
        END IF;

        DBMS_OUTPUT.put_line('Level 9');

        IF UPPER(m_statusconfig) NOT IN('NEW','MODIFIED')
        THEN
            m_return_number  := 4;
            m_exception_desc    := 'Invalid Data =>' || m_xpath || '/' || 'StatusConfiguration';
            DBMS_OUTPUT.put_line('Exception    :    ' || m_exception_desc);
            RAISE ONBOARDING_EXCEPTION;
        END IF;

       DBMS_OUTPUT.put_line('Level 10');
       DBMS_OUTPUT.put_line('m_ParentCoCNumber : ' || m_ParentCoCNumber);
       DBMS_OUTPUT.put_line('m_CoCNumber : ' || m_CoCNumber);

        IF INSTR(m_parent_id, CHR(64)) > 0 AND m_ParentCoCNumber IS NOT NULL
        THEN
            IF m_ParentCoCNumber = m_CoCNumber
            THEN
                m_parent_id := m_id;
            ELSE
                BEGIN
                    SELECT institution_id
                    INTO m_parent_id
                    FROM INSTITUTION_ORGANIZATION_INFO
                    WHERE ORGANIZATION_ID = m_ParentCoCNumber;
                EXCEPTION
                WHEN NO_DATA_FOUND
                THEN
                    RAISE ONBOARDING_EXCEPTION;
                END;
            END IF;
        END IF;


        SELECT    count(*)
        INTO    m_count
        FROM    institutionmaster
        WHERE    institutionid = m_id;

        DBMS_OUTPUT.put_line('m_id : '||m_id);
        DBMS_OUTPUT.put_line('m_count : '||m_count);


        IF UPPER(m_statusconfig) = 'NEW' AND m_count > 0
        THEN
            m_return_number  := 2;
            m_exception_desc    := 'Customer ==> '|| m_id || ' already onboarded.';
            DBMS_OUTPUT.put_line('Exception    :    ' || m_exception_desc);
            RAISE ONBOARDING_EXCEPTION;
        END IF;

        IF UPPER(m_statusconfig) = 'MODIFIED' AND m_count = 0
        THEN
            m_return_number  := 3;
            m_exception_desc    := 'Customer ==> '|| m_id || ' does not exist.';
            DBMS_OUTPUT.put_line('Exception    :    ' || m_exception_desc);
            RAISE ONBOARDING_EXCEPTION;
        END IF;

        IF m_parent_id IS NOT NULL AND m_parent_id <> m_id
        THEN
            SELECT    count(*)
            INTO    m_count
            FROM    institutionmaster
            WHERE    institutionid = m_parent_id;

            IF m_count = 0
            THEN
                m_return_number      := 4;
                m_exception_desc    := 'Invalid Data =>' || m_xpath || '/' || 'ParentID';
                DBMS_OUTPUT.put_line('Exception    :    ' || m_exception_desc);
                RAISE ONBOARDING_EXCEPTION;
            END IF;
        END IF;


        IF UPPER(m_statusconfig) = 'MODIFIED'
        THEN
            DELETE FROM institutionparameters
            WHERE  paramname        = 'ALLOWED_FILE_TYPE'
            AND    path                = 'CONVERSION'
            AND    institutionid      = m_id;

            DELETE FROM institutionparameters
            WHERE  paramname        = 'OUTPUT_CORPORATE_CHANNEL'
            AND    path                = 'CONVERSION'
            AND    institutionid      = m_id;

            DELETE
            FROM  institutionparameters
            WHERE institutionid = m_id
            AND   PATH like '%INSTITUTION_DETAILS.AUTHENTICATION_LEVEL%';
        END IF;

        -- if status is changed from INACTIVE to ACTIVE
        IF UPPER(m_statusconfig) = 'MODIFIED' AND UPPER(m_statuscustomer) = 'ACTIVE'
        THEN
            UPDATE uuser
            SET    status            = 'E'
            WHERE  userid            IN ('ADMIN1','ADMIN2')
            AND    institutionid     = m_id;

        END IF;

    --Set polling required flag YES using concentrator script.
        DELETE
        FROM  institutionparameters
        WHERE institutionid = m_id
        AND   PATH = 'INVOICEPAY'
        AND   PARAMNAME = 'POLLING_REQUIRED';

        DBMS_OUTPUT.PUT_LINE('Rows deleted test: '||SQL%ROWCOUNT);

        DBMS_OUTPUT.put_line('Inside MI Tool');
        m_product_flavor := td_get_value('MI_TOOL', 'PRODUCT_FLAVOR');
        DBMS_OUTPUT.put_line('m_product_flavor List : ' || m_product_flavor);
        mi_tool(m_id,m_id,m_product_flavor, m_CustomerSubType);
        -- mi_tool(m_id,m_id,'CORP|PCOR|OFAC|CORE',m_CustomerSubType);
        DBMS_OUTPUT.put_line('Out OF MI Tool');

        UPDATE  institutionparameters
        SET     record_type       = NULL
        WHERE   record_type       = 'T'
        AND     institutionid     = m_id;

        m_institutionid := mi_get_concentratorid();
        p_cinstitutionid := mi_get_concentratorid();
        DBMS_OUTPUT.put_line('Conc Institutionid      : ' || p_cinstitutionid);
    --Institution parameters to be taken from immediate parent.
    OPEN c28(p_cinstitutionid); --m_institutionid concenteator
    FETCH c28 BULK COLLECT INTO t_conc_institutionid;
    CLOSE c28;
    m_ctr_beg := NVL(t_conc_institutionid.FIRST,0);  -- Set the start counter of the RECORD Table
    m_ctr_end := NVL(t_conc_institutionid.LAST ,0);  -- Set the end   counter of the RECORD Table
    DBMS_OUTPUT.put_line('m_ctr_beg : ' || m_ctr_beg);
    DBMS_OUTPUT.put_line('m_ctr_end : ' || m_ctr_end);
    IF m_ctr_end <= 0
    THEN
        DBMS_OUTPUT.put_line('No data found.');
    END IF;
    IF m_ctr_beg > 0
    THEN
        FOR i IN m_ctr_beg..m_ctr_end
        LOOP
            m_path := t_conc_institutionid(i).path;
            DBMS_OUTPUT.put_line('m_path : ' || m_path);
            DBMS_OUTPUT.put_line('m_parent_id : ' || m_parent_id);
            OPEN c29(m_path,m_parent_id);
            FETCH c29 BULK COLLECT INTO t_conc_path;
            CLOSE c29;
            m_beg_ctr := NVL(t_conc_path.FIRST,0);  -- Set the start counter of the RECORD Table
            m_end_ctr := NVL(t_conc_path.LAST ,0);  -- Set the end   counter of the RECORD Table
            DBMS_OUTPUT.put_line('m_beg_ctr : ' || m_beg_ctr);
            DBMS_OUTPUT.put_line('m_end_ctr : ' || m_end_ctr);
            IF m_end_ctr > 0
            THEN
            FOR j IN m_beg_ctr..m_end_ctr
            LOOP
                --If found procedure will copy paramvalues from parent institutions to the onboarding institution
                DBMS_OUTPUT.put_line('t_conc_path(j).paramvalue : ' || t_conc_path(j).paramvalue);
                DBMS_OUTPUT.put_line('m_id c29 : ' || m_id);
                m_return_code := mgmt_institutionparameter(p_action=>'INSERT-UPDATE',p_institutionid=>m_id, p_path_old=>t_conc_path(j).path, p_paramname=>t_conc_path(j).paramname, p_paramvalue=>t_conc_path(j).paramvalue);
                DBMS_OUTPUT.put_line('Record inserted in institutionparameter table.');
            END LOOP;
            END IF;
        END LOOP;
    END IF;

        IF m_outputdeliverytype !='FTP'
        THEN
            m_outputdeliverytype :=NULL;
        END IF;

        SELECT count(para_code)
        INTO m_config_flag
        FROM TABLE (GET_CODE_FROM_LIST(TD_GET_VALUE('PRODUCT-CONFG', 'PRODUCT'), ',')) WHERE PARA_CODE = m_tenantname;

        IF m_config_flag > 0
        THEN
            DELETE FROM AML_CUST_INFO
            WHERE ACI_CUST_TYPE ='AO'
            AND     ACI_CUST_CODE = 'ACEOFACCUSTOMER'
            AND     ACI_INSTITUTIONID = m_id;
        END IF;

        m_return_code := mgmt_institutionparameter(p_action=>'UPDATE',p_institutionid=>m_id, p_path_old=>'INSTITUTION_DETAILS', p_paramname=>'EQUENS_ID', p_paramvalue=>m_bog_routeeradres);
        m_return_code := mgmt_institutionparameter(p_action=>'UPDATE',p_institutionid=>m_id, p_path_old=>'INSTITUTION_DETAILS', p_paramname=>'RELATIONNUMBERBOG', p_paramvalue=>m_bog_relationnumber);
        m_return_code := mgmt_institutionparameter(p_action=>'INSERT-UPDATE',p_institutionid=>m_id, p_path_old=>'SUPPORT_DETAILS.SUPPORT_EMAILID', p_paramname=>'SUPPORT_EMAILID', p_paramvalue=>m_supportemailid);
        m_return_code := mgmt_institutionparameter(p_action=>'INSERT-UPDATE',p_institutionid=>m_id, p_path_old=>'SUPPORT_DETAILS.SUPPORT_MOBILE_NO', p_paramname=>'SUPPORT_MOBILENO', p_paramvalue=>m_supportmobileno);
        m_return_code := mgmt_institutionparameter(p_action=>'INSERT-UPDATE',p_institutionid=>m_id, p_path_old=>'INSTITUTION_DETAILS', p_paramname=>'STATUS_UPDATE_NOTIFICATION_INTERVAL', p_paramvalue=>m_StatusUpdateNotificationInterval);

        DBMS_OUTPUT.put_line('Customer type update      : ' || m_StatusCustomer);

        m_return_code := mgmt_institutionparameter(p_action=>'UPDATE',p_institutionid=>m_id, p_path_old=>'INSTITUTION_DETAILS', p_paramname=>'CUSTOMER_TYPE', p_paramvalue=>m_CustomerType);
        m_return_code := mgmt_institutionparameter(p_action=>'INSERT-UPDATE',p_institutionid=>m_id, p_path_old=>'INSTITUTION_DETAILS', p_paramname=>'CUSTOMER_SUBTYPE', p_paramvalue=>m_CustomerSubtype);
        m_return_code := mgmt_institutionparameter(p_action=>'UPDATE',p_institutionid=>m_id, p_path_old=>'INSTITUTION_DETAILS', p_paramname=>'STATUS_CONFIGURATION', p_paramvalue=>m_StatusConfig);

        m_xpath      := m_xpath_node || '/LocalCurrencyCode';

        IF m_LocalCurrencyCode IS NULL
        THEN
            m_return_number  := 6.6;
            m_exception_desc := 'Mandatory component =>' || m_xpath || '/' || 'LocalCurrencyCode' || ' not found while onboarding Customer ID => ' || m_id ;
            DBMS_OUTPUT.put_line('Exception    :    ' || m_exception_desc);
            RAISE ONBOARDING_EXCEPTION;
        END IF;

        m_paramvalue         := m_LocalCurrencyCode;
        m_return_code        := mgmt_institutionparam_usexpath(p_action_passed=>'INSERT-UPDATE',p_institutionid_passed=>m_id, p_xpath_root=>m_xpath_root, p_xpath_child=>m_xpath, p_paramvalue=>m_paramvalue);

        m_xpath      := m_xpath_node || '/DueDatePeriodCriteria';
        m_paramvalue         := m_DueDatePeriodCriteria;
        m_return_code        := mgmt_institutionparam_usexpath(p_action_passed=>'INSERT-UPDATE',p_institutionid_passed=>m_id, p_xpath_root=>m_xpath_root, p_xpath_child=>m_xpath, p_paramvalue=>m_paramvalue);

        m_xpath      := m_xpath_node || '/DueDateBufferDays';

        IF m_DueDateBufferDays IS NULL
        THEN
            m_paramvalue := 3;
        ELSE
            m_paramvalue         := m_DueDateBufferDays;
        END IF;

        m_BrandName   := NVL(m_BrandName, 'OneLinQ');

        DBMS_OUTPUT.PUT_LINE('m_BrandName : ' ||m_BrandName);
        DBMS_OUTPUT.PUT_LINE('m_TenantName : ' ||m_TenantName);

        m_return_code        := mgmt_institutionparam_usexpath(p_action_passed=>'INSERT-UPDATE',p_institutionid_passed=>m_id, p_xpath_root=>m_xpath_root, p_xpath_child=>m_xpath, p_paramvalue=>m_paramvalue);

        m_xpath      := m_xpath_node || '/SenderBIC';
        m_paramvalue        := m_SenderBIC;
        IF m_paramvalue IS NOT NULL
        THEN
            m_return_code        := mgmt_institutionparam_usexpath(p_action_passed=>'INSERT-UPDATE',p_institutionid_passed=>m_id, p_xpath_root=>m_xpath_root, p_xpath_child=>m_xpath, p_paramvalue=>m_paramvalue);
        END IF;
        m_xpath      := m_xpath_node || '/SWIFTBICLTAddress';
        m_paramvalue        := m_SWIFTBICLTAddress;
        IF m_paramvalue IS NOT NULL
        THEN
            m_return_code        := mgmt_institutionparam_usexpath(p_action_passed=>'INSERT-UPDATE',p_institutionid_passed=>m_id, p_xpath_root=>m_xpath_root, p_xpath_child=>m_xpath, p_paramvalue=>m_paramvalue);
        END IF;
        m_return_code := mgmt_institutionparameter(p_action=>'UPDATE',p_institutionid=>m_id, p_path_old=>'INSTITUTION_DETAILS', p_paramname=>'STATUS_CUSTOMER', p_paramvalue=>m_StatusCustomer);
        m_return_code := mgmt_institutionparameter(p_action=>'UPDATE',p_institutionid=>m_id, p_path_old=>'INSTITUTION_DETAILS', p_paramname=>'CUSTOMER_NAME', p_paramvalue=>m_CustomerName);
        m_return_code := mgmt_institutionparameter(p_action=>'UPDATE',p_institutionid=>m_id, p_path_old=>'INSTITUTION_DETAILS', p_paramname=>'PARENT_ID', p_paramvalue=>m_parent_id);
        m_return_code := mgmt_institutionparameter(p_action=>'UPDATE',p_institutionid=>m_id, p_path_old=>'INSTITUTION_DETAILS', p_paramname=>'NO_OF_TOKENS', p_paramvalue=>m_nooftokens);
        m_return_code := mgmt_institutionparameter(p_action=>'INSERT-UPDATE',p_institutionid=>m_id, p_path_old=>'INSTITUTION_DETAILS', p_paramname=>'PARTNERID', p_paramvalue=>m_partnerid);
        m_return_code := mgmt_institutionparameter(p_action=>'INSERT-UPDATE',p_institutionid=>m_id, p_path_old=>'INSTITUTION_DETAILS', p_paramname=>'TPPID', p_paramvalue=>m_tppid);
        m_return_code := mgmt_institutionparameter(p_action=>'UPDATE',p_institutionid=>m_id, p_path_old=>'INSTITUTION_DETAILS', p_paramname=>'OUTPUT_DELIVERY_TYPE', p_paramvalue=>m_outputdeliverytype);
        m_return_code := mgmt_institutionparameter(p_action=>'UPDATE',p_institutionid=>m_id, p_path_old=>'INSTITUTION_DETAILS', p_paramname=>'RELATION_ID', p_paramvalue=>m_id);
        m_return_code := mgmt_institutionparameter(p_action=>'UPDATE',p_institutionid=>m_id, p_path_old=>'INSTITUTION_DETAILS', p_paramname=>'NOTIFICATION_EMAIL_ID', p_paramvalue=>m_emailaddress);
        m_return_code := mgmt_institutionparameter(p_action=>'INSERT-UPDATE',p_institutionid=>m_id, p_path_old=>'INSTITUTION_DETAILS', p_paramname=>'API_KEY', p_paramvalue=>m_apikey);
        m_return_code := mgmt_institutionparameter(p_action=>'INSERT-UPDATE',p_institutionid=>m_id, p_path_old=>'INSTITUTION_DETAILS', p_paramname=>'2STEPAUTH', p_paramvalue=>m_Auth2Level);
--        m_return_code := mgmt_institutionparameter(p_action=>'UPDATE',p_institutionid=>m_id, p_path_old=>'INSTITUTION_DETAILS', p_paramname=>'COUNTRY_CODE', p_paramvalue=>m_countrycode);
--        m_return_code := mgmt_institutionparameter(p_action=>'UPDATE',p_institutionid=>m_id, p_path_old=>'INSTITUTION_DETAILS', p_paramname=>'COC_NUMBER', p_paramvalue=>m_cocnumber);
        m_return_code := mgmt_institutionparameter(p_action=>'INSERT-UPDATE',p_institutionid=>m_id, p_path_old=>'INSTITUTION_DETAILS', p_paramname=>'BRAND_NAME', p_paramvalue=>m_BrandName);
        m_return_code := mgmt_institutionparameter(p_action=>'INSERT-UPDATE',p_institutionid=>m_id, p_path_old=>'INSTITUTION_DETAILS', p_paramname=>'TENANT_NAME', p_paramvalue=>m_TenantName);

        UPDATE  institutionmaster
        SET     allocated_tokens  = m_nooftokens
        WHERE   institutionid     = m_id;

        DELETE FROM institutionhierarchy
        WHERE childinstitution = m_id;

          BEGIN
          INSERT INTO institutionhierarchy
                                         (
                                          parentinstitution,
                                          childinstitution
                                         )
                                  VALUES (
                                         p_cinstitutionid,
                                         m_id
                                         );
            EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
            NULL;
          END;

          IF m_parent_id IS NOT NULL AND m_parent_id != m_id
          THEN
          BEGIN
          INSERT INTO institutionhierarchy
                                         (
                                          parentinstitution,
                                          childinstitution
                                         )
                                  VALUES (
                                         m_parent_id,
                                         m_id
                                         );
            EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
            NULL;
          END;
          END IF;

        DBMS_OUTPUT.put_line('Address Details');
        DBMS_OUTPUT.put_line('-----------------------');
        ctr := 1;
        m_result := NULL;
        FOR rec1 IN c1
        LOOP
            IF ctr = 1
            THEN
                m_address_line1 :=    rec1.AddressLine;
                DBMS_OUTPUT.put_line('AddressLine  : ' || rec1.AddressLine || '-' || m_address_line1);
            ELSIF ctr = 2
            THEN
                m_address_line2 :=    rec1.AddressLine;
                DBMS_OUTPUT.put_line('AddressLine  : ' || rec1.AddressLine || '-' || m_address_line2);
            ELSIF ctr = 3
            THEN
                m_address_line3 :=    rec1.AddressLine;
                DBMS_OUTPUT.put_line('AddressLine  : ' || rec1.AddressLine || '-' || m_address_line3);
            ELSIF ctr = 4
            THEN
                m_address_line4 :=    rec1.AddressLine;
                DBMS_OUTPUT.put_line('AddressLine  : ' || rec1.AddressLine || '-' || m_address_line4);
ELSIF ctr = 5
THEN
m_address_line5 :=    rec1.AddressLine;
DBMS_OUTPUT.put_line('AddressLine  : ' || rec1.AddressLine || '-' || m_address_line5);
ELSIF ctr = 6
THEN
m_address_line6 :=    rec1.AddressLine;
                DBMS_OUTPUT.put_line('AddressLine  : ' || rec1.AddressLine || '-' || m_address_line6);
            END IF;
            ctr := ctr + 1;
             DBMS_OUTPUT.put_line('AddressLine  : ' || rec1.AddressLine);
        END LOOP;
        DBMS_OUTPUT.put_line('mgmt_client_details: START');
        mgmt_client_details
        (
        p_first_name                 => NULL,
        p_last_name                  => NULL,
        p_middle_name                => NULL,
        p_phone_number               => NULL,
        p_title                      => NULL,
        p_client_name                => m_id,
        p_client_address1            => m_address_line1,
        p_client_address2            => m_address_line2,
        p_client_city                => m_address_line3,
        p_client_postcode_loc        => m_address_line4,
p_client_state      => m_address_line5,
p_client_country      => m_address_line6,
        p_client_bic                 => m_id,
        p_state                      => NULL,
        p_zip_code                   => NULL,
        p_zip_plus_4_code            => NULL,
        p_primary_federal_regulator  => NULL,
        p_ein                        => NULL
        );
        DBMS_OUTPUT.put_line('mgmt_client_details: END');

    --AuthenticationLevel Start
        --m_replace_label_tag        :=    '[@INSTITUTIONID]' || ':' || m_id || '|';

        IF m_InstitutionAccessControl IS NULL
        THEN
            m_return_number  := 5;
            m_exception_desc := 'Mandatory component =>' || m_xpath || '/' || 'InstitutionAccessControl' || ' not found while onboarding Customer ID => ' || m_id ;
            DBMS_OUTPUT.put_line('Exception    :    ' || m_exception_desc);
            RAISE ONBOARDING_EXCEPTION;
        END IF;


        IF m_InstitutionAccessControl IN ('TWO','FOUR','SIX')
        THEN
            m_xpath      := m_xpath_node || '/AuthenticationLevel/InstitutionAccessControl';
            m_paramvalue         := m_InstitutionAccessControl;
            m_replacetagvalue_main          := '[@INSTITUTIONID]' || ':' || m_id || '|';
            m_replacetagvalue_list          := m_replacetagvalue_main;
            m_return_code                   := mgmt_institutionparam_usexpath(p_action_passed=>'INSERT-UPDATE',p_institutionid_passed=>m_id, p_xpath_root=>m_xpath_root, p_xpath_child=>m_xpath, p_replacetagvalue_list=>m_replacetagvalue_list, p_paramvalue=>m_paramvalue);
        ELSE
            RAISE INVALID_INST_ACCESS_CTRL;
        END IF;

    --    m_return_code := mgmt_institutionparameter(p_action=>'INSERT-UPDATE',p_institutionid=>m_id, p_path_old=>'INSTITUTION_DETAILS', p_paramname=>'INSTITUTION_ACCESS_CONTROL', p_paramvalue=>m_InstitutionAccessControl);
        DBMS_OUTPUT.PUT_LINE('InstitutionAccessControl: ' || m_InstitutionAccessControl);

        DELETE FROM INSTITUTIONPARAMETERS
        WHERE INSTITUTIONID = m_id
        AND PATH LIKE 'INSTITUTION_DETAILS.AUTHENTICATION_LEVEL.STAGES.%'
        AND PARAMNAME = 'STAGE_ACCESS_CONTROL';
        FOR rec21 IN c21(m_Stage)
        LOOP

            m_xpath    := m_xpath_node || '/AuthenticationLevel/Stages/Stage/StageName';
            DBMS_OUTPUT.PUT_LINE('rec21.StageName: ' || rec21.StageName);
            --DBMS_OUTPUT.PUT_LINE('rec21: ' || rec21);

            IF rec21.StageName IN ('WITHDRAWAL','ACCEPT','AUTHORIZATION','REPAIR','WAREHOUSE','DUPLICATE','ERROR','FINAL','CREATE','PENDING', 'REVIEW', 'ESCLATE',
                                    'INVESTIGATION', 'EXCEPTIONS','REVW','ESCL','INV','EXCP', 'APPROVE')
            THEN


                IF rec21.StageAccessControl IN ('TWO','FOUR','SIX')
                THEN
                    m_xpath    := m_xpath_node || '/AuthenticationLevel/Stages/Stage/StageAccessControl';
                    m_paramvalue         := rec21.StageAccessControl;
                    m_replacetagvalue_main        := '[@INSTITUTIONID]' || ':' || m_id || '|' || '[@StageName]' || ':' || rec21.StageName || '|';
                    m_replacetagvalue_list        := m_replacetagvalue_main;
                    DBMS_OUTPUT.put_line('m_replacetagvalue_list : '|| m_replacetagvalue_list);
                    m_return_code               := mgmt_institutionparam_usexpath(p_action_passed=>'INSERT-UPDATE',p_institutionid_passed=>m_id, p_xpath_root=>m_xpath_root, p_xpath_child=>m_xpath, p_replacetagvalue_list=>m_replacetagvalue_list, p_paramvalue=>m_paramvalue);
                    DBMS_OUTPUT.put_line(RPAD('StageAccessControl:',45,' ')|| rec21.StageAccessControl);
                    DBMS_OUTPUT.put_line(RPAD('m_paramvalue:',45,' ')|| m_paramvalue);
                    DBMS_OUTPUT.put_line(RPAD('StageName:',45,' ')|| rec21.StageName);
                ELSE
                    RAISE INVALID_ACCESS_CONTROL;
                END IF;
            ELSE
                RAISE INVALID_STAGENAME;
            END IF;

            FOR rec22 IN c22(rec21.Product)
            LOOP
                m_xpath    := m_xpath_node || '/AuthenticationLevel/Stages/Stage/Thresholds/Products/ProductId';
--                IF rec22.ProductId IS NULL
--                THEN
--                    m_return_number        := 6;
--                    m_exception_desc    := 'Mandatory component => ' || m_xpath || ' ' || ' not found';
--                    RAISE ONBOARDING_EXCEPTION;
--                END IF;


                IF rec22.ProductId NOT IN ('SCT','SDD')
                THEN
                    RAISE INVALID_PRODUCTID;
                END IF;

                DBMS_OUTPUT.put_line(RPAD('ProductId:',45,' ')|| rec22.ProductId);
                
                FOR i in C22a(rec22.ThresholdAmountPerCurrency)
                LOOP
                   


                m_xpath    := m_xpath_node || '/AuthenticationLevel/Stages/Stage/Thresholds/Products/ThresholdAmountPerCurrency/ThresholdSecondSignature';
--                IF rec22.ThresholdSecondSignature IS NULL
--                THEN
--                    m_return_number        := 6;
--                    m_exception_desc    := 'Mandatory component => ' || m_xpath || ' ' || ' not found';
--                    RAISE ONBOARDING_EXCEPTION;
--                END IF;

                IF i.ThresholdSecondSignature IS NOT NULL
                THEN
                    m_xpath    := m_xpath_node || '/AuthenticationLevel/Stages/Stage/Thresholds/Products/ThresholdAmountPerCurrency/ThresholdSecondSignature';
                    m_paramvalue         := i.ThresholdSecondSignature;
                    m_replacetagvalue_main        := '[@INSTITUTIONID]' || ':' || m_id || '|' || '[@StageName]' || ':' || rec21.StageName || '|'|| '[@PRODUCT_ID]' || ':' || rec22.ProductId || '|'|| '[@CURRENCY]' || ':' || i.Currency || '|';
                    m_replacetagvalue_list        := m_replacetagvalue_main;
                    m_return_code               := mgmt_institutionparam_usexpath(p_action_passed=>'INSERT-UPDATE',p_institutionid_passed=>m_id, p_xpath_root=>m_xpath_root, p_xpath_child=>m_xpath, p_replacetagvalue_list=>m_replacetagvalue_list, p_paramvalue=>m_paramvalue);
                    DBMS_OUTPUT.put_line(RPAD('ThresholdSecondSignature:',45,' ')|| i.ThresholdSecondSignature);
                END IF;

                m_xpath    := m_xpath_node || '/AuthenticationLevel/Stages/Stage/Thresholds/Products/ThresholdAmountPerCurrency/ThresholdThirdSignature';
--                IF rec22.ThresholdThirdSignature IS NULL
--                THEN
--                    m_return_number        := 6;
--                    m_exception_desc    := 'Mandatory component => ' || m_xpath || ' ' || ' not found';
--                    RAISE ONBOARDING_EXCEPTION;
--                END IF;


                IF i.ThresholdThirdSignature IS NOT NULL
                THEN
                    m_xpath    := m_xpath_node || '/AuthenticationLevel/Stages/Stage/Thresholds/Products/ThresholdAmountPerCurrency/ThresholdThirdSignature';
                    m_paramvalue         := i.ThresholdThirdSignature;
                    m_replacetagvalue_main        := '[@INSTITUTIONID]' || ':' || m_id || '|' || '[@StageName]' || ':' || rec21.StageName || '|'|| '[@PRODUCT_ID]' || ':' || rec22.ProductId || '|' || '[@CURRENCY]' || ':' || i.CURRENCY || '|';
                    m_replacetagvalue_list        := m_replacetagvalue_main;
                    m_return_code               := mgmt_institutionparam_usexpath(p_action_passed=>'INSERT-UPDATE',p_institutionid_passed=>m_id, p_xpath_root=>m_xpath_root, p_xpath_child=>m_xpath, p_replacetagvalue_list=>m_replacetagvalue_list, p_paramvalue=>m_paramvalue);
                    DBMS_OUTPUT.put_line(RPAD('ThresholdThirdSignature:',45,' ')|| i.ThresholdThirdSignature);
                END IF;
            END LOOP;
            END LOOP;
            DBMS_OUTPUT.put_line('--------------------------------------------');
        END LOOP;

    --AuthenticationLevel END


        DBMS_OUTPUT.put_line('Licenses Distribution');
        DBMS_OUTPUT.put_line('-------------------------------------------');
        FOR rec15 IN c15(m_xpath)
        LOOP
            p_cinstitutionid := mi_get_concentratorid();
            DBMS_OUTPUT.put_line('Conc Institutionid      : ' || p_cinstitutionid);

            DBMS_OUTPUT.put_line('APPLICATION    : ' || rec15.application);
            DBMS_OUTPUT.put_line('NUMOFLICENSES  : ' || rec15.numoflicenses);

          IF rec15.numoflicenses IS NOT NULL
          THEN
             gui_licenses_distribution(p_cinstitutionid,m_id,rec15.application,rec15.numoflicenses);
             DBMS_OUTPUT.put_line('NUMOFLICENSES  : ' || rec15.numoflicenses);

          ELSIF rec15.numoflicenses IS NULL THEN

             m_tdvalue := Td_Get_Value('EQUENS','LICENSES-'||rec15.application);

             gui_licenses_distribution(p_cinstitutionid,m_id,rec15.application,m_tdvalue);

             DBMS_OUTPUT.put_line('TDVALUE    : ' || m_tdvalue);
             DBMS_OUTPUT.put_line('APPLICATION    : ' || rec15.application);
             DBMS_OUTPUT.put_line('NUMOFLICENSES  : ' || rec15.numoflicenses);
          END IF;
        END LOOP;

        SELECT count (*)
        INTO   m_count
        FROM   institutionproductlicense
        WHERE  institutionid = m_id
        AND    productid = 'ADMIN';

        IF m_count <=0
        THEN
            m_tdvalue := Td_Get_Value('EQUENS','LICENSES-ADMIN');
            gui_licenses_distribution(p_cinstitutionid,m_id,'ADMIN',m_tdvalue);
            DBMS_OUTPUT.put_line('TDVALUE    : ' || m_tdvalue);
        END IF;

        SELECT count (*)
        INTO   m_count
        FROM   institutionproductlicense
        WHERE  institutionid = m_id
        AND    productid = 'MONITOR';

        IF m_count <=0
        THEN
            m_tdvalue := Td_Get_Value('EQUENS','LICENSES-MONITOR');
            gui_licenses_distribution(p_cinstitutionid,m_id,'MONITOR',m_tdvalue);
            DBMS_OUTPUT.put_line('TDVALUE    : ' || m_tdvalue);
        END IF;

        SELECT count (*)
        INTO   m_count
        FROM   institutionproductlicense
        WHERE  institutionid = m_id
        AND    productid = 'PELICAN';

        IF m_count <=0
        THEN
            m_tdvalue := Td_Get_Value('EQUENS','LICENSES-PELICAN');
                IF m_tdvalue IS NOT NULL
                THEN
                    gui_licenses_distribution(p_cinstitutionid,m_id,'PELICAN',m_tdvalue);
                    DBMS_OUTPUT.put_line('TDVALUE    : ' || m_tdvalue);
                END IF;
            END IF;


        SELECT count (*)
        INTO   m_count
        FROM   institutionproductlicense
        WHERE  institutionid = m_id
        AND    productid = 'OFACWI';

        IF m_count <=0
        THEN
            m_tdvalue := Td_Get_Value('EQUENS','LICENSES-OFACWI');
            DBMS_OUTPUT.put_line('m_tdvalue    : ' || m_tdvalue);

            IF m_tdvalue IS NOT NULL
            THEN
                DBMS_OUTPUT.put_line('m_tdvalue IS NOT NULL');
                gui_licenses_distribution(p_cinstitutionid,m_id,'OFACWI',m_tdvalue);
                DBMS_OUTPUT.put_line('TDVALUE    : ' || m_tdvalue);
            END IF;
        END IF;

        --Added for HOME application
        SELECT count (*)
        INTO   m_count
        FROM   institutionproductlicense
        WHERE  institutionid = m_id
        AND    productid = 'HOME';

        IF m_count <=0
        THEN
            m_tdvalue := Td_Get_Value('EQUENS','LICENSES-HOME');
            gui_licenses_distribution(p_cinstitutionid,m_id,'HOME',m_tdvalue);
            DBMS_OUTPUT.put_line('TDVALUE    : ' || m_tdvalue);
        END IF;

        OPEN c14(m_id);
        FETCH c14 BULK COLLECT INTO t_account_master;
        IF t_account_master.FIRST > 0
        THEN
            FORALL  acc_ctr IN t_account_master.FIRST..t_account_master.LAST
            UPDATE  account_master
            SET     account_status = 'DELETED'
            WHERE   institution_id = t_account_master(acc_ctr).institution_id
            AND     customer_id    = t_account_master(acc_ctr).customer_id
            AND     account_number = t_account_master(acc_ctr).account_number
            AND     bank_code      = t_account_master(acc_ctr).bank_code
            AND     branch         = t_account_master(acc_ctr).branch;
        END IF;
        CLOSE c14;

    --AccountDetails START

         FOR rec23 IN c23(m_Account)
         LOOP
            m_xpath    := m_xpath_node || '/AccountDetails/Account/IBAN'    ;
            --m_xpath    := m_xpath_node || '/AccountDetails/Account'    ;
            m_paramvalue    := rec23.IBAN;

        --    m_bic := rec23.BIC;
         --   m_account_number := rec23.AcountNumber;
            DBMS_OUTPUT.put_line(RPAD('IBAN:',45,' ')|| rec23.IBAN);

            IF SUBSTR(rec23.IBAN, 1,2) = 'NL'
            THEN
                IF LENGTH (m_paramvalue) > 10
                THEN
                    m_account_number    :=    SUBSTR(m_paramvalue, -10, 10);
                    m_iban                :=    rec23.IBAN;
                ELSE
                    m_account_number    :=    LPAD(LTRIM(TO_CHAR(m_paramvalue)),10,'0');
                    m_iban                :=    m_account_number;
                END IF;
            ELSE
                m_account_number :=    rec23.AcountNumber;
                m_iban              := rec23.IBAN;
            END IF;
--            m_xpath    := m_xpath_node || '/AccountDetails/Account/Currency';

----            IF rec23.Currency IS NULL
----            THEN
----                m_return_number        := 6;
----                m_exception_desc    := 'Mandatory component => ' || m_xpath || ' ' || ' not found';
----                RAISE ONBOARDING_EXCEPTION;
----            END IF;

--            m_xpath    := m_xpath_node || '/AccountDetails/Account/AcountNumber';
--            IF rec23.AcountNumber IS NULL
--            THEN
--                m_return_number        := 6;
--                m_exception_desc    := 'Mandatory component => ' || m_xpath || ' ' || ' not found';
--                RAISE ONBOARDING_EXCEPTION;
--            END IF;

--            m_xpath    := m_xpath_node || '/AccountDetails/Account/IBAN';
--            IF rec23.IBAN IS NULL
--            THEN
--                m_return_number        := 6;
--                m_exception_desc    := 'Mandatory component => ' || m_xpath || ' ' || ' not found';
--                RAISE ONBOARDING_EXCEPTION;
--            END IF;

--            m_xpath    := m_xpath_node || '/AccountDetails/Account/Name';
--            IF rec23.account_title IS NULL
--            THEN
--                m_return_number        := 6;
--                m_exception_desc    := 'Mandatory component => ' || m_xpath || ' ' || ' not found';
--                RAISE ONBOARDING_EXCEPTION;
--            END IF;

--            m_xpath    := m_xpath_node || '/AccountDetails/Account/BIC';
--            IF rec23.BIC IS NULL
--            THEN
--                m_return_number        := 6;
--                m_exception_desc    := 'Mandatory component => ' || m_xpath || ' ' || ' not found';
--                RAISE ONBOARDING_EXCEPTION;
--            END IF;

            DBMS_OUTPUT.put_line('AccountCurrency : ' || rec23.AccountCurrency);
            DBMS_OUTPUT.put_line('CountryCode : ' || rec23.country_code);
            DBMS_OUTPUT.put_line('AcountNumber : ' || rec23.AcountNumber);
            DBMS_OUTPUT.put_line('IBAN : ' || rec23.IBAN);
            DBMS_OUTPUT.put_line('Name : ' || rec23.account_title);
            DBMS_OUTPUT.put_line('BIC : ' || rec23.BIC);
            DBMS_OUTPUT.put_line('BankName :' || rec23.BankName);
            DBMS_OUTPUT.put_line('ImageURL : ' || rec23.BankImageURL);
            DBMS_OUTPUT.put_line('AccountMode : ' || rec23.AccountMode);
            DBMS_OUTPUT.put_line('AccountcustomerId : ' || rec23.AccountcustomerId);
            DBMS_OUTPUT.put_line('AccountSchemeId : ' || rec23.AccountSchemeId);
            DBMS_OUTPUT.put_line('DefaultAccount : ' || rec23.DefaultAccount);

            --Added by PG
--            IF  m_account_number IS NULL--rec23.AcountNumber IS NULL
--            THEN
--                m_account_customer_id := rec23.AccountcustomerId;
--            ELSE
--                m_account_customer_id := m_account_number;--rec23.AcountNumber;
--            END IF;

            m_account_customer_id := NVL(rec23.AccountcustomerId,m_account_number);

            --If this tag is not present then default value should be "NO"
            IF rec23.DefaultAccount IS NOT NULL
            THEN
               m_defaultaccount_flag := rec23.DefaultAccount;
               DBMS_OUTPUT.put_line('If loop m_defaultaccount_flag : ' || m_defaultaccount_flag);
            ELSE
                m_defaultaccount_flag := 'NO';
            END IF;

            DBMS_OUTPUT.put_line('Default m_defaultaccount_flag : ' || m_defaultaccount_flag);
            --m_defaultaccount_flag := 'NO';

            mgmt_account_master
            (
            p_action                  => 'INSERT-UPDATE',
            p_institution_id          => m_id,
            --p_customer_id             => rec23.AcountNumber,
            p_customer_id              => m_account_customer_id,
            p_bank_code               => rec23.BIC,
            p_branch                  => 'NOT-PROVIDED',
            p_account_number          => m_account_number,--rec23.AcountNumber,
            p_account_iban            => rec23.IBAN,
            p_account_type            => NULL,
            p_account_curr            => rec23.AccountCurrency,
            p_credit_limit            => NULL,
            p_account_desc            => NULL,
            p_country_code            => rec23.country_code,
            p_account_status          => NVL(rec23.status, 'VALIDATED'),
            p_account_updatedby       => 'ADMIN1',
            p_account_validatedby     => 'ADMIN2',
            p_crscheme_id             => NULL,
            p_account_addl_property => 'X',
            p_input_channel            => 'X',
            p_account_title         => rec23.account_title,
            p_account_id            => rec23.AccountId,
            p_bank_name             => rec23.BankName,
            p_image_url             => rec23.BankImageURL,
            p_account_mode          => rec23.AccountMode,
            p_acc_customer_id       => rec23.AccountcustomerId,
            p_AccountSchemeId       => rec23.AccountSchemeId,
            p_defaultaccount_flag   => m_defaultaccount_flag,
            p_created_by            => rec23.CreatedBy
            );

            IF rec23.AcountNumber IS NOT NULL
            THEN
                p_account_string := p_account_string ||  rec23.AcountNumber || ',';
            END IF;

         END LOOP;

--         m_append_string := CASE TRIM(m_append_string)
--                            WHEN ','
--                            THEN NULL
--                            END;

         DBMS_OUTPUT.PUT_LINE('p_account_string : ' || p_account_string);


    --AccountDetails END

    ---SwiftFileAct start
    FOR rec31 IN c31(m_BankWiSeConnection)
    LOOP
        m_running_number            := m_running_number + 1 ;
        m_running_number_ctr        := LPAD(m_running_number, 2, '0');
        m_xpath                         := m_xpath_node || '/SwiftFileAct/BankWiSeConnection/BankBIC';
        m_paramvalue                    := rec31.BankBIC;
        m_replacetagvalue_main        := '[@RUNNING-NUMBER]' || ':' || m_running_number_ctr; --|| '|';
        m_replacetagvalue_list          := m_replacetagvalue_main;
        DBMS_OUTPUT.put_line('m_replacetagvalue_list : ' || m_replacetagvalue_list);
       m_return_code                   := mgmt_institutionparam_usexpath(p_action_passed=>'INSERT-UPDATE',p_institutionid_passed=>m_id, p_xpath_root=>m_xpath_root, p_xpath_child=>m_xpath, p_replacetagvalue_list=>m_replacetagvalue_list, p_paramvalue=>m_paramvalue);
        m_xpath                         := m_xpath_node || '/SwiftFileAct/BankWiSeConnection/ConnectivityConfiguration/FileType';
        m_paramvalue                    := rec31.FileType;
        m_replacetagvalue_main        := '[@RUNNING-NUMBER]' || ':' || m_running_number_ctr; --|| '|';
        m_replacetagvalue_list          := m_replacetagvalue_main;
        m_return_code                   := mgmt_institutionparam_usexpath(p_action_passed=>'INSERT-UPDATE',p_institutionid_passed=>m_id, p_xpath_root=>m_xpath_root, p_xpath_child=>m_xpath, p_replacetagvalue_list=>m_replacetagvalue_list, p_paramvalue=>m_paramvalue);
        m_xpath                         := m_xpath_node || '/SwiftFileAct/BankWiSeConnection/ConnectivityConfiguration/MessageIdentifier';
        m_paramvalue                    := rec31.MessageIdentifier;
        m_replacetagvalue_main        := '[@RUNNING-NUMBER]' || ':' || m_running_number_ctr; --|| '|';
        m_replacetagvalue_list          := m_replacetagvalue_main;
        m_return_code                   := mgmt_institutionparam_usexpath(p_action_passed=>'INSERT-UPDATE',p_institutionid_passed=>m_id, p_xpath_root=>m_xpath_root, p_xpath_child=>m_xpath, p_replacetagvalue_list=>m_replacetagvalue_list, p_paramvalue=>m_paramvalue);
        m_xpath                         := m_xpath_node || '/SwiftFileAct/BankWiSeConnection/ConnectivityConfiguration/AuthUser/DN';
        m_paramvalue                    := rec31.Auth_DN;
        m_replacetagvalue_main        := '[@RUNNING-NUMBER]' || ':' || m_running_number_ctr; --|| '|';
        m_replacetagvalue_list          := m_replacetagvalue_main;
        m_return_code                   := mgmt_institutionparam_usexpath(p_action_passed=>'INSERT-UPDATE',p_institutionid_passed=>m_id, p_xpath_root=>m_xpath_root, p_xpath_child=>m_xpath, p_replacetagvalue_list=>m_replacetagvalue_list, p_paramvalue=>m_paramvalue);
        m_xpath                         := m_xpath_node || '/SwiftFileAct/BankWiSeConnection/ConnectivityConfiguration/AuthUser/FullName';
        m_paramvalue                    := rec31.Auth_FullName;
        m_replacetagvalue_main        := '[@RUNNING-NUMBER]' || ':' || m_running_number_ctr; --|| '|';
        m_replacetagvalue_list          := m_replacetagvalue_main;
        m_return_code                   := mgmt_institutionparam_usexpath(p_action_passed=>'INSERT-UPDATE',p_institutionid_passed=>m_id, p_xpath_root=>m_xpath_root, p_xpath_child=>m_xpath, p_replacetagvalue_list=>m_replacetagvalue_list, p_paramvalue=>m_paramvalue);
        m_xpath                         := m_xpath_node || '/SwiftFileAct/BankWiSeConnection/ConnectivityConfiguration/Sender/DN';
        m_paramvalue                    := rec31.Sender_DN;
        m_replacetagvalue_main        := '[@RUNNING-NUMBER]' || ':' || m_running_number_ctr; --|| '|';
        m_replacetagvalue_list          := m_replacetagvalue_main;
        m_return_code                   := mgmt_institutionparam_usexpath(p_action_passed=>'INSERT-UPDATE',p_institutionid_passed=>m_id, p_xpath_root=>m_xpath_root, p_xpath_child=>m_xpath, p_replacetagvalue_list=>m_replacetagvalue_list, p_paramvalue=>m_paramvalue);
        m_xpath                         := m_xpath_node || '/SwiftFileAct/BankWiSeConnection/ConnectivityConfiguration/Sender/FullName';
        m_paramvalue                    := rec31.Sender_FullName;
        m_replacetagvalue_main        := '[@RUNNING-NUMBER]' || ':' || m_running_number_ctr; --|| '|';
        m_replacetagvalue_list          := m_replacetagvalue_main;
        m_return_code                   := mgmt_institutionparam_usexpath(p_action_passed=>'INSERT-UPDATE',p_institutionid_passed=>m_id, p_xpath_root=>m_xpath_root, p_xpath_child=>m_xpath, p_replacetagvalue_list=>m_replacetagvalue_list, p_paramvalue=>m_paramvalue);
        m_xpath                         := m_xpath_node || '/SwiftFileAct/BankWiSeConnection/ConnectivityConfiguration/Receiver/DN';
        m_paramvalue                    := rec31.Receiver_DN;
        m_replacetagvalue_main        := '[@RUNNING-NUMBER]' || ':' || m_running_number_ctr; --|| '|';
        m_replacetagvalue_list          := m_replacetagvalue_main;
        m_return_code                   := mgmt_institutionparam_usexpath(p_action_passed=>'INSERT-UPDATE',p_institutionid_passed=>m_id, p_xpath_root=>m_xpath_root, p_xpath_child=>m_xpath, p_replacetagvalue_list=>m_replacetagvalue_list, p_paramvalue=>m_paramvalue);
        m_xpath                         := m_xpath_node || '/SwiftFileAct/BankWiSeConnection/ConnectivityConfiguration/Receiver/FullName';
        m_paramvalue                    := rec31.Receiver_FullName;
        m_replacetagvalue_main        := '[@RUNNING-NUMBER]' || ':' || m_running_number_ctr; --|| '|';
        m_replacetagvalue_list          := m_replacetagvalue_main;
        m_return_code                   := mgmt_institutionparam_usexpath(p_action_passed=>'INSERT-UPDATE',p_institutionid_passed=>m_id, p_xpath_root=>m_xpath_root, p_xpath_child=>m_xpath, p_replacetagvalue_list=>m_replacetagvalue_list, p_paramvalue=>m_paramvalue);
        m_xpath                         := m_xpath_node || '/SwiftFileAct/BankWiSeConnection/ConnectivityConfiguration/NetworkInfo/Service';
        m_paramvalue                    := rec31.Service;
        m_replacetagvalue_main        := '[@RUNNING-NUMBER]' || ':' || m_running_number_ctr; --|| '|';
        m_replacetagvalue_list          := m_replacetagvalue_main;
        m_return_code                   := mgmt_institutionparam_usexpath(p_action_passed=>'INSERT-UPDATE',p_institutionid_passed=>m_id, p_xpath_root=>m_xpath_root, p_xpath_child=>m_xpath, p_replacetagvalue_list=>m_replacetagvalue_list, p_paramvalue=>m_paramvalue);
        m_xpath                         := m_xpath_node || '/SwiftFileAct/BankWiSeConnection/ConnectivityConfiguration/NetworkInfo/Network';
        m_paramvalue                    := rec31.Network;
        m_replacetagvalue_main        := '[@RUNNING-NUMBER]' || ':' || m_running_number_ctr; --|| '|';
        m_replacetagvalue_list          := m_replacetagvalue_main;
        m_return_code                   := mgmt_institutionparam_usexpath(p_action_passed=>'INSERT-UPDATE',p_institutionid_passed=>m_id, p_xpath_root=>m_xpath_root, p_xpath_child=>m_xpath, p_replacetagvalue_list=>m_replacetagvalue_list, p_paramvalue=>m_paramvalue);
        m_xpath                         := m_xpath_node || '/SwiftFileAct/BankWiSeConnection/ConnectivityConfiguration/FileInfo/SwCompression';
        m_paramvalue                    := rec31.SwCompression;
        m_replacetagvalue_main        := '[@RUNNING-NUMBER]' || ':' || m_running_number_ctr; --|| '|';
        m_replacetagvalue_list          := m_replacetagvalue_main;
        m_return_code                   := mgmt_institutionparam_usexpath(p_action_passed=>'INSERT-UPDATE',p_institutionid_passed=>m_id, p_xpath_root=>m_xpath_root, p_xpath_child=>m_xpath, p_replacetagvalue_list=>m_replacetagvalue_list, p_paramvalue=>m_paramvalue);
        m_xpath                         := m_xpath_node || '/SwiftFileAct/BankWiSeConnection/ConnectivityConfiguration/OtherParameters/FileMode';
        m_paramvalue                    := rec31.FileMode;
        m_replacetagvalue_main        := '[@RUNNING-NUMBER]' || ':' || m_running_number_ctr; --|| '|';
        m_replacetagvalue_list          := m_replacetagvalue_main;
        m_return_code                   := mgmt_institutionparam_usexpath(p_action_passed=>'INSERT-UPDATE',p_institutionid_passed=>m_id, p_xpath_root=>m_xpath_root, p_xpath_child=>m_xpath, p_replacetagvalue_list=>m_replacetagvalue_list, p_paramvalue=>m_paramvalue);
        m_xpath                         := m_xpath_node || '/SwiftFileAct/BankWiSeConnection/ConnectivityConfiguration/OtherParameters/PositiveDeliveryNotification';
        m_paramvalue                    := rec31.PositiveDeliveryNotification;
        m_replacetagvalue_main        := '[@RUNNING-NUMBER]' || ':' || m_running_number_ctr; --|| '|';
        m_replacetagvalue_list          := m_replacetagvalue_main;
        m_return_code                   := mgmt_institutionparam_usexpath(p_action_passed=>'INSERT-UPDATE',p_institutionid_passed=>m_id, p_xpath_root=>m_xpath_root, p_xpath_child=>m_xpath, p_replacetagvalue_list=>m_replacetagvalue_list, p_paramvalue=>m_paramvalue);
        m_xpath                         := m_xpath_node || '/SwiftFileAct/BankWiSeConnection/ConnectivityConfiguration/OtherParameters/ACKReceiverDN';
        m_paramvalue                    := rec31.ACKReceiverDN;
        m_replacetagvalue_main        := '[@RUNNING-NUMBER]' || ':' || m_running_number_ctr; --|| '|';
        m_replacetagvalue_list          := m_replacetagvalue_main;
        m_return_code                   := mgmt_institutionparam_usexpath(p_action_passed=>'INSERT-UPDATE',p_institutionid_passed=>m_id, p_xpath_root=>m_xpath_root, p_xpath_child=>m_xpath, p_replacetagvalue_list=>m_replacetagvalue_list, p_paramvalue=>m_paramvalue);
        m_xpath                         := m_xpath_node || '/SwiftFileAct/BankWiSeConnection/ConnectivityConfiguration/OtherParameters/NRFlag';
        m_paramvalue                    := rec31.NRFlag;
        m_replacetagvalue_main        := '[@RUNNING-NUMBER]' || ':' || m_running_number_ctr; --|| '|';
        m_replacetagvalue_list          := m_replacetagvalue_main;
        m_return_code                   := mgmt_institutionparam_usexpath(p_action_passed=>'INSERT-UPDATE',p_institutionid_passed=>m_id, p_xpath_root=>m_xpath_root, p_xpath_child=>m_xpath, p_replacetagvalue_list=>m_replacetagvalue_list, p_paramvalue=>m_paramvalue);
        m_xpath                         := m_xpath_node || '/SwiftFileAct/BankWiSeConnection/ConnectivityConfiguration/OtherParameters/DeliveryNotificationQ';
        m_paramvalue                    := rec31.DeliveryNotificationQ;
        m_replacetagvalue_main        := '[@RUNNING-NUMBER]' || ':' || m_running_number_ctr; --|| '|';
        m_replacetagvalue_list          := m_replacetagvalue_main;
        m_return_code                   := mgmt_institutionparam_usexpath(p_action_passed=>'INSERT-UPDATE',p_institutionid_passed=>m_id, p_xpath_root=>m_xpath_root, p_xpath_child=>m_xpath, p_replacetagvalue_list=>m_replacetagvalue_list, p_paramvalue=>m_paramvalue);
        m_xpath                         := m_xpath_node || '/SwiftFileAct/BankWiSeConnection/ConnectivityConfiguration/OtherParameters/ACKRequestType';
        m_paramvalue                    := rec31.ACKRequestType;
        m_replacetagvalue_main        := '[@RUNNING-NUMBER]' || ':' || m_running_number_ctr; --|| '|';
        m_replacetagvalue_list          := m_replacetagvalue_main;
        m_return_code                   := mgmt_institutionparam_usexpath(p_action_passed=>'INSERT-UPDATE',p_institutionid_passed=>m_id, p_xpath_root=>m_xpath_root, p_xpath_child=>m_xpath, p_replacetagvalue_list=>m_replacetagvalue_list, p_paramvalue=>m_paramvalue);
        DBMS_OUTPUT.put_line(RPAD('BankBIC :',35,' ')|| m_paramvalue);
        DBMS_OUTPUT.put_line(RPAD('FileType :',35,' ')|| rec31.FileType);
        DBMS_OUTPUT.put_line(RPAD('MessageIdentifier :',35,' ')|| rec31.MessageIdentifier);
        DBMS_OUTPUT.put_line(RPAD('Auth_DN :',35,' ')|| rec31.Auth_DN);
        DBMS_OUTPUT.put_line(RPAD('Auth_FullName :',35,' ')|| rec31.Auth_FullName);
        DBMS_OUTPUT.put_line(RPAD('Sender_DN :',35,' ')|| rec31.Sender_DN);
        DBMS_OUTPUT.put_line(RPAD('Sender_FullName :',35,' ')|| rec31.Sender_FullName);
        DBMS_OUTPUT.put_line(RPAD('Receiver_DN :',35,' ')|| rec31.Receiver_DN);
        DBMS_OUTPUT.put_line(RPAD('Receiver FullName :',35,' ')|| rec31.Receiver_FullName);
        DBMS_OUTPUT.put_line(RPAD('Service :',35,' ')|| rec31.Service);
        DBMS_OUTPUT.put_line(RPAD('Network :',35,' ')|| rec31.Network);
        DBMS_OUTPUT.put_line(RPAD('SwCompression :',35,' ')|| rec31.SwCompression);
        DBMS_OUTPUT.put_line(RPAD('FileMode :',35,' ')|| rec31.FileMode);
        DBMS_OUTPUT.put_line(RPAD('PositiveDeliveryNotification :',35,' ')|| rec31.PositiveDeliveryNotification);
        DBMS_OUTPUT.put_line(RPAD('ACKReceiverDN :',35,' ')|| rec31.ACKReceiverDN);
        DBMS_OUTPUT.put_line(RPAD('NRFlag :',35,' ')|| rec31.NRFlag);
        DBMS_OUTPUT.put_line(RPAD('DeliveryNotificationQ :',35,' ')|| rec31.DeliveryNotificationQ);
        DBMS_OUTPUT.put_line(RPAD('ACKRequestType :',35,' ')|| rec31.ACKRequestType);
    END LOOP;
    ---SwiftFileAct end
    --AccountingPackages START

    DBMS_OUTPUT.PUT_LINE('--------------------AccountingPackages START----------------------');

    DELETE FROM INSTITUTION_ORGANIZATION_INFO
    WHERE   INSTITUTION_ID = m_id;
    --AND     INSTITUTION_TYPE = m_CustomerType;

        m_parent_tag_path := 'ProductConfiguration/Customer';
        m_xpath := m_parent_tag_path || '/AccountingPackages/AccountingPackage';
        m_xtype     := XMLTYPE(xmlData => p_onboard_info);

        --DBMS_OUTPUT.PUT_LINE('m_xtype : ' || m_xtype);
        DBMS_OUTPUT.PUT_LINE('m_xpath : ' || m_xpath);

        SELECT EXISTSNODE(m_xtype, m_xpath)
        INTO m_acc_node_present
        FROM DUAL;

        DBMS_OUTPUT.PUT_LINE('m_acc_node_present : ' || m_acc_node_present);

        m_parent_tag_path := 'ProductConfiguration/Customer';
        m_xpath1 := m_parent_tag_path || '/Company/OriginatingSystem';
        m_xpath2 := m_parent_tag_path || '/Company/PaymentMethod';
        m_xtype     := XMLTYPE(xmlData => p_onboard_info);

        --DBMS_OUTPUT.PUT_LINE('m_xtype : ' || m_xtype);
        DBMS_OUTPUT.PUT_LINE('m_xpath : ' || m_xpath);

        SELECT EXISTSNODE(m_xtype, m_xpath1)
        INTO m_node_present1
        FROM DUAL;

SELECT EXISTSNODE(m_xtype, m_xpath2)
        INTO m_node_present2
        FROM DUAL;


IF  m_acc_node_present > 0
THEN
    FOR rec26 IN c26(m_AccountingPackage)
    LOOP
        m_xpath := 'Customer/AccountingPackages/AccountingPackage';
                IF NVL(rec26.AccPacTp, m_OriginatingSystem) IS NULL
        THEN
            m_return_number  := 7.1;
            m_exception_desc := 'Mandatory component =>' || m_xpath || '/' || 'AccPacTp' || ' not found while onboarding Customer ID => ' || m_id ;
            DBMS_OUTPUT.put_line('Exception    :    ' || m_exception_desc);
            RAISE ONBOARDING_EXCEPTION;
        END IF;
        m_xpath := 'Customer/AccountingPackages/AccountingPackage';
        IF rec26.customerId IS NULL
        THEN
            m_return_number  := 7.2;
            m_exception_desc := 'Mandatory component =>' || m_xpath || '/' || 'customerId' || ' not found while onboarding Customer ID => ' || m_id ;
            DBMS_OUTPUT.put_line('Exception    :    ' || m_exception_desc);
            RAISE ONBOARDING_EXCEPTION;
        END IF;
                DBMS_OUTPUT.put_line('AccountOfficeRef : ' || rec26.AccountOfficeRef);
                DBMS_OUTPUT.put_line('Tax PayableDateforeveryMonth : ' || rec26.Tax_PayableDateforeveryMonth);
                DBMS_OUTPUT.put_line('PensionProivderName : ' || rec26.PensionProivderName);
                DBMS_OUTPUT.put_line('PensionProivderID : ' || rec26.PensionProivderID);
                DBMS_OUTPUT.put_line('PesionProivderAccountName : ' || rec26.PesionProivderAccountName);
                DBMS_OUTPUT.put_line('PesionProivderAccountSortCode : ' || rec26.PesionProivderAccountSortCode);
                DBMS_OUTPUT.put_line('PesionProivderAccountNumber : ' || rec26.PesionProivderAccountNumber);
                DBMS_OUTPUT.put_line('PayableDateforeveryMonth : ' || rec26.PayableDateforeveryMonth);
                DBMS_OUTPUT.put_line('FinancialYearEndDay : ' || rec26.FinancialYearEndDay);
                DBMS_OUTPUT.put_line('FinancialYearEndMonth : ' || rec26.FinancialYearEndMonth);
		DBMS_OUTPUT.put_line('SHORTCODE : ' || rec26.ShortCode);
                DBMS_OUTPUT.put_line('PaymentServiceId : ' || rec26.PaymentServiceId);
                DBMS_OUTPUT.put_line('PAYMENTREQUEST : ' || rec26.PaymentRequestThemeId);

                m_return_code := mgmt_institutionparameter(p_action=>'INSERT-UPDATE',p_institutionid=>m_id, p_path_old=>'INSTITUTION_DETAILS.TAX', p_paramname=>'ACCOUNTOFFICEREF', p_paramvalue=>rec26.AccountOfficeRef);
                m_return_code := mgmt_institutionparameter(p_action=>'INSERT-UPDATE',p_institutionid=>m_id, p_path_old=>'INSTITUTION_DETAILS.TAX', p_paramname=>'PAYABLEDTFOREVERYMONTH', p_paramvalue=>rec26.Tax_PayableDateforeveryMonth);
                m_return_code := mgmt_institutionparameter(p_action=>'INSERT-UPDATE',p_institutionid=>m_id, p_path_old=>'INSTITUTION_DETAILS.PENSION', p_paramname=>'NAME', p_paramvalue=>rec26.PensionProivderName);
                m_return_code := mgmt_institutionparameter(p_action=>'INSERT-UPDATE',p_institutionid=>m_id, p_path_old=>'INSTITUTION_DETAILS.PENSION', p_paramname=>'ID', p_paramvalue=>rec26.PensionProivderID);
                m_return_code := mgmt_institutionparameter(p_action=>'INSERT-UPDATE',p_institutionid=>m_id, p_path_old=>'INSTITUTION_DETAILS.PENSION', p_paramname=>'ACCOUNTNAME', p_paramvalue=>rec26.PesionProivderAccountName);
                m_return_code := mgmt_institutionparameter(p_action=>'INSERT-UPDATE',p_institutionid=>m_id, p_path_old=>'INSTITUTION_DETAILS.PENSION', p_paramname=>'ACCOUNTSORTCODE', p_paramvalue=>rec26.PesionProivderAccountSortCode);
                m_return_code := mgmt_institutionparameter(p_action=>'INSERT-UPDATE',p_institutionid=>m_id, p_path_old=>'INSTITUTION_DETAILS.PENSION', p_paramname=>'ACCOUNTNO', p_paramvalue=>rec26.PesionProivderAccountNumber);
                m_return_code := mgmt_institutionparameter(p_action=>'INSERT-UPDATE',p_institutionid=>m_id, p_path_old=>'INSTITUTION_DETAILS.PENSION', p_paramname=>'PAYABLEDTFOREVERYMONTH', p_paramvalue=>rec26.PayableDateforeveryMonth);
                m_return_code := mgmt_institutionparameter(p_action=>'INSERT-UPDATE',p_institutionid=>m_id, p_path_old=>'ACCOUNTING_PACKAGE.'||rec26.AccPacTp , p_paramname=>'SHORTCODE', p_paramvalue=>rec26.Shortcode);
                m_return_code := mgmt_institutionparameter(p_action=>'INSERT-UPDATE',p_institutionid=>m_id, p_path_old=>'INSTITUTION_DETAILS.PAYMENT_REQUEST', p_paramname=>'PAYMENTSERVICEID', p_paramvalue=>rec26.paymentserviceid);
                m_return_code := mgmt_institutionparameter(p_action=>'INSERT-UPDATE',p_institutionid=>m_id, p_path_old=>'INSTITUTION_DETAILS.PAYMENT_REQUEST', p_paramname=>'PAYMENTREQUESTTHEMEID', p_paramvalue=>rec26.paymentrequestthemeid);
		
		
                m_return_code := mgmt_institutionparameter(p_action=>'INSERT-UPDATE',p_institutionid=>m_id, p_path_old=>'INSTITUTION_DETAILS.FHC.FINANCIALPERIOD', p_paramname=>'FINANCIALYEARENDDAY', p_paramvalue=>rec26.FinancialYearEndDay);
                m_return_code := mgmt_institutionparameter(p_action=>'INSERT-UPDATE',p_institutionid=>m_id, p_path_old=>'INSTITUTION_DETAILS.FHC.FINANCIALPERIOD', p_paramname=>'FINANCIALYEARENDMONTH', p_paramvalue=>rec26.FinancialYearEndMonth);
        /*m_xpath := 'Customer/AccountingPackages/AccountingPackage/PaymentMethods';
        IF rec26.PaymentMethods IS NULL
        THEN
            m_return_number  := 7.3;
            m_exception_desc := 'Mandatory component =>' || m_xpath || '/' || 'PaymentMethod' || ' not found while onboarding Customer ID => ' || m_id ;
            DBMS_OUTPUT.put_line('Exception    :    ' || m_exception_desc);
            RAISE ONBOARDING_EXCEPTION;
        END IF;*/
                m_accoutingpackagename := rec26.AccPacTp;

        m_service_ctr := 0;
        FOR rec30 IN c30 (rec26.Services)
        LOOP
            m_service_ctr   := m_service_ctr +1;
            m_payment_selection := NVL(td_get_value('XERO_REC_SELECTION','BILL_PAYMENT'),'X');
            m_updatetimestamp := NULL;
            m_createtimestamp := NULL;
            IF m_service_ctr = 1
            THEN
                UPDATE INSTITUTION_SERVICES
                SET STATUS = 'DELETED'
                WHERE INSTITUTION_ID = m_id;
                 --DBMS_OUTPUT.put_line('VISHAL DELETED : ');
            END IF;
            
            BEGIN
                select PARTNER_PROD_SERVICE_ID
                INTO m_partner_pro_serv_id
                from PARTNER_PRODUCTS_SERVICES
                where PARTNER_ID = m_accoutingpackagename
                AND PRODUCT_ID = rec30.ProductId
                AND SERVICE_ID = rec30.ServiceId;
                DBMS_OUTPUT.put_line('m_partner_pro_serv_id : ' || m_partner_pro_serv_id);
            EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
                DBMS_OUTPUT.put_line('No data found');
            END;
            ---DBMS_OUTPUT.put_line('VISHAL ' || rec30.createtimestamp);
            IF rec30.createtimestamp = 'YES' 
            THEN
                m_createtimestamp := SYSTIMESTAMP;
                DBMS_OUTPUT.put_line('1');
                IF rec30.updatetimestamp = 'YES'
                THEN
                    m_updatetimestamp := SYSTIMESTAMP;
                END IF;
                BEGIN
                INSERT INTO INSTITUTION_SERVICES (INSTITUTION_ID,PARTNER_PROD_SERVICE_ID,ORGANIZATION_ID,PAYMENT_OUTPUT_MODE,PAYMENT_SELECTION,PAYMENT_DEFAULT_ACCOUNT_NO,ESCROW_INSTITUTION_ID,CREATE_TIMESTAMP,UPDATE_TIMESTAMP,STATUS)
                VALUES(m_id,m_partner_pro_serv_id,rec26.customerId,rec30.PaymentOutPutMode,m_payment_selection,m_default_acc_no,rec30.EscrowInstitutionId,m_createtimestamp,m_updatetimestamp,'ENABLE');
                EXCEPTION
                WHEN DUP_VAL_ON_INDEX
                THEN
                UPDATE INSTITUTION_SERVICES
                   SET PARTNER_PROD_SERVICE_ID = m_partner_pro_serv_id,
                   ORGANIZATION_ID = rec26.customerId,
                   PAYMENT_OUTPUT_MODE = rec30.PaymentOutPutMode,
                   PAYMENT_SELECTION = m_payment_selection,
                   PAYMENT_DEFAULT_ACCOUNT_NO = m_default_acc_no, --rec30.DefaultAccountNo,
                   ESCROW_INSTITUTION_ID = rec30.EscrowInstitutionId,
                   CREATE_TIMESTAMP       = m_createtimestamp,
                   UPDATE_TIMESTAMP       = m_updatetimestamp,
                   STATUS                 = 'ENABLE'
                   WHERE INSTITUTION_ID = m_id
                   AND PARTNER_PROD_SERVICE_ID = m_partner_pro_serv_id
                   AND ORGANIZATION_ID = rec26.customerId
                   AND PAYMENT_OUTPUT_MODE = rec30.PaymentOutPutMode;
                END;
            ELSIF rec30.updatetimestamp = 'YES'
            THEN 
                m_updatetimestamp := SYSTIMESTAMP;
                BEGIN
                INSERT INTO INSTITUTION_SERVICES (INSTITUTION_ID,PARTNER_PROD_SERVICE_ID,ORGANIZATION_ID,PAYMENT_OUTPUT_MODE,PAYMENT_SELECTION,PAYMENT_DEFAULT_ACCOUNT_NO,ESCROW_INSTITUTION_ID,CREATE_TIMESTAMP,UPDATE_TIMESTAMP,STATUS)
                VALUES(m_id,m_partner_pro_serv_id,rec26.customerId,rec30.PaymentOutPutMode,m_payment_selection,m_default_acc_no,rec30.EscrowInstitutionId,m_createtimestamp,m_updatetimestamp,'ENABLE');
                EXCEPTION
                WHEN DUP_VAL_ON_INDEX
                THEN
                UPDATE INSTITUTION_SERVICES
                   SET PARTNER_PROD_SERVICE_ID = m_partner_pro_serv_id,
                   ORGANIZATION_ID = rec26.customerId,
                   PAYMENT_OUTPUT_MODE = rec30.PaymentOutPutMode,
                   PAYMENT_SELECTION = m_payment_selection,
                   PAYMENT_DEFAULT_ACCOUNT_NO = m_default_acc_no, --rec30.DefaultAccountNo,
                   ESCROW_INSTITUTION_ID = rec30.EscrowInstitutionId,
                   --CREATE_TIMESTAMP       = m_createtimestamp,
                   UPDATE_TIMESTAMP       = m_updatetimestamp,
                   STATUS                 = 'ENABLE'
                   WHERE INSTITUTION_ID = m_id
                   AND PARTNER_PROD_SERVICE_ID = m_partner_pro_serv_id
                   AND ORGANIZATION_ID = rec26.customerId
                   AND PAYMENT_OUTPUT_MODE = rec30.PaymentOutPutMode;
                END;
            END IF;
            BEGIN
                SELECT   PARTPROD_SER_ID.NEXTVAL
                INTO     m_partner_pro_serv_id_seq
                FROM     DUAL;
                           FOR rec23 IN c23(m_Account)
                           LOOP
                                m_account_ctr := m_account_ctr + 1;
                                m_account_number := rec23.AcountNumber;
                                m_bic := rec23.BIC;
                                IF rec23.AcountNumber IS NULL
                                THEN
                                    m_account_customer_id := rec23.AccountcustomerId;
                                ELSE
                                    m_account_customer_id := rec23.AcountNumber;
                                END IF;
                               DBMS_OUTPUT.put_line('************ m_account_number : ' || rec23.AcountNumber);
                                DBMS_OUTPUT.put_line('*** m_default_acc_no : ' || m_default_acc_no);
                                DBMS_OUTPUT.put_line('*** m_id : ' || m_id);
                                DBMS_OUTPUT.put_line('*** m_account_customer_id : ' || m_account_customer_id);
                                DBMS_OUTPUT.put_line('*** m_bic : ' || m_bic);
                                DBMS_OUTPUT.put_line('*** m_account_number : ' || m_account_number);
                                BEGIN
                                    SELECT PELICAN_ACCOUNT_NO
                                    INTO m_default_acc_no
                                    FROM ACCOUNT_MASTER
                                    WHERE INSTITUTION_ID = m_id
                                    AND CUSTOMER_ID = NVL(rec23.AccountcustomerId,m_account_number)
                                    AND BANK_CODE = m_bic
                                    AND ACCOUNT_NUMBER = rec30.DefaultAccountNo;--m_account_number;
                                EXCEPTION
                                WHEN NO_DATA_FOUND
                                THEN
                                    DBMS_OUTPUT.put_line('No data found.');
                                END;
                                DBMS_OUTPUT.put_line('default m_default_acc_no : ' || m_default_acc_no);
                                DBMS_OUTPUT.put_line('default m_id : ' || m_id);
                                DBMS_OUTPUT.put_line('default m_account_customer_id : ' || m_account_customer_id);
                                DBMS_OUTPUT.put_line('default m_bic : ' || m_bic);
                                DBMS_OUTPUT.put_line('default m_account_number : ' || m_account_number);
                            DBMS_OUTPUT.put_line('ProductId : ' || rec30.ProductId);
                            DBMS_OUTPUT.put_line('ServiceId : ' || rec30.ServiceId);
                            -- we need to configure the output mode for each partner, service and payment mode combination (WA team will provide tabledetails script as per design doc)
                            
                            DBMS_OUTPUT.put_line('m_payment_selection : ' || m_payment_selection);
                            --As per requirement fecthing pelican_acc_no from account_master and insert into PAYMENT_DEFAULT_ACCOUNT_NO column of INSTITUTION_SERVICES table
                                IF UPPER(m_statusconfig) = 'MODIFIED'
                                THEN
                                    UPDATE INSTITUTION_SERVICES
                                    SET PARTNER_PROD_SERVICE_ID = m_partner_pro_serv_id,
                                        ORGANIZATION_ID = rec26.customerId,
                                        PAYMENT_OUTPUT_MODE = rec30.PaymentOutPutMode,
                                        PAYMENT_SELECTION = m_payment_selection,
                                        PAYMENT_DEFAULT_ACCOUNT_NO = m_default_acc_no, --rec30.DefaultAccountNo,
                                        ESCROW_INSTITUTION_ID = rec30.EscrowInstitutionId,
                                        --CREATE_TIMESTAMP = m_createtimestamp,
                                        UPDATE_TIMESTAMP = m_updatetimestamp,
                                        STATUS           = 'ENABLE'
                                    WHERE INSTITUTION_ID = m_id
                                    AND PARTNER_PROD_SERVICE_ID = m_partner_pro_serv_id
                                    AND ORGANIZATION_ID = rec26.customerId
                                    AND PAYMENT_OUTPUT_MODE = rec30.PaymentOutPutMode;
                                END IF;

--                                BEGIN
--                                    select PARTNER_PROD_SERVICE_ID
--                                    INTO m_partner_pro_serv_id
--                                    from PARTNER_PRODUCTS_SERVICES
--                                    where PARTNER_ID = m_accoutingpackagename
--                                    AND PRODUCT_ID = rec30.ProductId
--                                    AND SERVICE_ID = rec30.ServiceId;
--                                    DBMS_OUTPUT.put_line('m_partner_pro_serv_id : ' || m_partner_pro_serv_id);
--                                EXCEPTION
--                                WHEN NO_DATA_FOUND
--                                THEN
--                                    DBMS_OUTPUT.put_line('No data found');
--                                END;
                                --IF UPPER(m_statusconfig) = 'NEW'
                               -- THEN
                                    BEGIN
                                        IF m_account_ctr = 1
                                        THEN
                                            UPDATE INSTITUTION_SERVICES
                                            SET STATUS = 'DELETED'
                                            WHERE INSTITUTION_ID = m_id;
                                        END IF;
                                        
                                        BEGIN
                                        SELECT CREATE_TIMESTAMP
                                        INTO m_createtimestamp
                                        FROM INSTITUTION_SERVICES
                                        WHERE INSTITUTION_ID = m_id
                                        AND PARTNER_PROD_SERVICE_ID = m_partner_pro_serv_id
                                        AND ORGANIZATION_ID = rec26.customerId
                                        AND PAYMENT_OUTPUT_MODE = rec30.PaymentOutPutMode;
                                        EXCEPTION
                                        WHEN NO_DATA_FOUND
                                        THEN
                                            m_createtimestamp := NULL;
                                        END;
                                        --AND PARTNER_PROD_SERVICE_ID = m_partner_pro_serv_id
                                        --AND ORGANIZATION_ID = rec26.customerId
                                        --AND PAYMENT_OUTPUT_MODE = rec30.PaymentOutPutMode;
                                        DBMS_OUTPUT.put_line('rec30.DefaultAccountNo : ' || rec30.DefaultAccountNo);
                                        DBMS_OUTPUT.put_line('m_account_number : ' || m_account_number);
                                        --IF rec30.DefaultAccountNo =  m_account_number
                                        --THEN
                                            INSERT INTO INSTITUTION_SERVICES (INSTITUTION_ID,PARTNER_PROD_SERVICE_ID,ORGANIZATION_ID,PAYMENT_OUTPUT_MODE,PAYMENT_SELECTION,PAYMENT_DEFAULT_ACCOUNT_NO,ESCROW_INSTITUTION_ID,CREATE_TIMESTAMP,UPDATE_TIMESTAMP,STATUS)
                                            VALUES(m_id,m_partner_pro_serv_id,rec26.customerId,rec30.PaymentOutPutMode,m_payment_selection,m_default_acc_no,rec30.EscrowInstitutionId,m_createtimestamp,m_updatetimestamp,'ENABLE');
                                            DBMS_OUTPUT.put_line('Reocrds inserted into INSTITUTION_SERVICES table : ' || m_default_acc_no);
                                            DBMS_OUTPUT.put_line('m_partner_pro_serv_id : ' || m_partner_pro_serv_id);
                                            DBMS_OUTPUT.put_line('rec26.customerId : ' || rec26.customerId);
                                            DBMS_OUTPUT.put_line('rec30.PaymentOutPutMode : ' || rec30.PaymentOutPutMode);
                                            DBMS_OUTPUT.put_line('rec30.EscrowInstitutionId : ' || rec30.EscrowInstitutionId);
                                        --END IF;
                                    EXCEPTION
                                    WHEN DUP_VAL_ON_INDEX
                                    THEN
                                        DBMS_OUTPUT.put_line('DUP_VAL_ON_INDEX m_partner_pro_serv_id : ' || m_partner_pro_serv_id);
                                        DBMS_OUTPUT.put_line('DUP_VAL_ON_INDEX rec26.customerId : ' || rec26.customerId);
                                        DBMS_OUTPUT.put_line('DUP_VAL_ON_INDEX rec30.PaymentOutPutMode : ' || rec30.PaymentOutPutMode);
                                        DBMS_OUTPUT.put_line('DUP_VAL_ON_INDEX rec30.EscrowInstitutionId : ' || rec30.EscrowInstitutionId);
                                        UPDATE INSTITUTION_SERVICES
                                        SET PARTNER_PROD_SERVICE_ID = m_partner_pro_serv_id,
                                            ORGANIZATION_ID = rec26.customerId,
                                            PAYMENT_OUTPUT_MODE = rec30.PaymentOutPutMode,
                                            PAYMENT_SELECTION = m_payment_selection,
                                            PAYMENT_DEFAULT_ACCOUNT_NO = m_default_acc_no, --rec30.DefaultAccountNo,
                                            ESCROW_INSTITUTION_ID = rec30.EscrowInstitutionId,
                                            CREATE_TIMESTAMP       = m_createtimestamp,
                                            UPDATE_TIMESTAMP       = m_updatetimestamp,
                                            STATUS                 = 'ENABLE'
                                        WHERE INSTITUTION_ID = m_id
                                        AND PARTNER_PROD_SERVICE_ID = m_partner_pro_serv_id
                                        AND ORGANIZATION_ID = rec26.customerId
                                        AND PAYMENT_OUTPUT_MODE = rec30.PaymentOutPutMode;
                                        DBMS_OUTPUT.put_line('Duplicate value in INSTITUTION_SERVICES table : ' || m_default_acc_no);
                                    END;
                                --END IF;
                            END LOOP;    --end of account loop psssssssss
                        --FOR rec27 IN c27(rec26.PaymentMethods)
                        --LOOP
                           IF UPPER(m_partner_subscription) IN ('Y','YES')
                           THEN
                                IF UPPER(m_statusconfig) = 'MODIFIED'
                                THEN
                                    /*DELETE FROM PARTNERS
                                    WHERE PARTNER_ID = m_accoutingpackagename
                                    AND PARTNER_INSTITUTIONID = m_id
                                    AND PARTNER_NAME = m_CompanyName;
                                    DELETE FROM PARTNER_PRODUCTS_SERVICES
                                    WHERE  PARTNER_ID = m_accoutingpackagename
                                    AND PARTNER_PROD_SERVICE_ID = m_partner_pro_serv_id_seq
                                    AND PRODUCT_ID = rec30.ProductId
                                    AND SERVICE_ID = rec30.ServiceId;*/
                                    UPDATE PARTNERS
                                    SET PARTNER_DESCRIPTION = m_comp_desc,
                                         PARTNER_ISO_COUNTRYCODE = m_CountryCode,
                                        PARTNER_LOGO_URL = m_partner_logo_url,
                                        BRAND_NAME = m_BrandName
                                    WHERE PARTNER_ID = m_accoutingpackagename
                                    AND PARTNER_INSTITUTIONID = m_id
                                    AND PARTNER_NAME = m_CompanyName;

                                    DBMS_OUTPUT.put_line('Update PRODUCT_ID : ' || rec30.ProductId || ' m_accoutingpackagename : ' || m_accoutingpackagename);
                                    DBMS_OUTPUT.put_line('Update rec30.ServiceId : ' || rec30.ServiceId);

                                    /*DELETE FROM PARTNER_PRODUCTS_SERVICES
                                    WHERE PARTNER_ID = m_accoutingpackagename
                                    AND PRODUCT_ID = rec30.ProductId
                                    AND SERVICE_ID = rec30.ServiceId;*/
                                    DBMS_OUTPUT.put_line('DELETED '|| SQL%ROWCOUNT);
                                    IF m_service_ctr = 1
                                    THEN
                                        DELETE FROM PARTNER_PRODUCTS_SERVICES
                                        WHERE PARTNER_ID = m_accoutingpackagename
                                        AND PRODUCT_ID = rec30.ProductId;
                                    END IF;

                                    INSERT INTO PARTNER_PRODUCTS_SERVICES(PARTNER_PROD_SERVICE_ID,PARTNER_ID,PRODUCT_ID,SERVICE_ID,STATUS,USERID,UPDATE_TIMESTAMP)
                                    VALUES(m_partner_pro_serv_id_seq,m_accoutingpackagename,rec30.ProductId,rec30.ServiceId,'E','ADMIN1',SYSTIMESTAMP);
                                    DBMS_OUTPUT.put_line('IN MODIFIED Record inserted into PARTNER_PRODUCTS_SERVICES table.' || m_partner_pro_serv_id_seq);

                                    /*UPDATE PARTNER_PRODUCTS_SERVICES
                                    SET PARTNER_ID = m_accoutingpackagename,
                                        PRODUCT_ID = rec30.ProductId,
                                        SERVICE_ID = rec30.ServiceId
                                    WHERE  PARTNER_ID = m_accoutingpackagename
                                    --AND PARTNER_PROD_SERVICE_ID = m_partner_pro_serv_id_seq
                                    --AND PRODUCT_ID = rec30.ProductId
                                    AND SERVICE_ID = rec30.ServiceId;*/
                                END IF;
                                IF UPPER(m_statusconfig) = 'NEW'
                                THEN
                                        DBMS_OUTPUT.put_line('m_partner_pro_serv_id_seq : ' || m_partner_pro_serv_id_seq);
                                        DBMS_OUTPUT.put_line('m_accoutingpackagename : ' || m_accoutingpackagename);
                                        DBMS_OUTPUT.put_line('rec30.ProductId : ' || rec30.ProductId);
                                        DBMS_OUTPUT.put_line('rec30.ServiceId : ' || rec30.ServiceId);
                                BEGIN
                                    INSERT INTO PARTNERS (PARTNER_ID,PARTNER_NAME,PARTNER_DESCRIPTION,PARTNER_INSTITUTIONID,PARTNER_ISO_COUNTRYCODE,PARTNER_LOGO_URL,BRAND_NAME,STATUS,USERID,UPDATE_TIMESTAMP)
                                    VALUES (m_accoutingpackagename,m_CompanyName,m_comp_desc,m_id,m_CountryCode,m_partner_logo_url,m_BrandName,'ENABLED','ADMIN1',SYSTIMESTAMP);

                                    DBMS_OUTPUT.put_line('Data inserted into PARTNERS table.');
                                EXCEPTION
                                    WHEN OTHERS
                                    THEN
                                        DBMS_OUTPUT.PUT_LINE('OTHERS : ' || SQLERRM || SQLCODE);
                                END;
                                    INSERT INTO PARTNER_PRODUCTS_SERVICES(PARTNER_PROD_SERVICE_ID,PARTNER_ID,PRODUCT_ID,SERVICE_ID,STATUS,USERID,UPDATE_TIMESTAMP)
                                    VALUES(m_partner_pro_serv_id_seq,m_accoutingpackagename,rec30.ProductId,rec30.ServiceId,'E','ADMIN1',SYSTIMESTAMP);
                                    DBMS_OUTPUT.put_line('Record inserted into PARTNER_PRODUCTS_SERVICES table.' || m_partner_pro_serv_id_seq);
                                END IF;
                           END IF;
                DBMS_OUTPUT.PUT_LINE('CALLING upsert_institution_org_info');
                upsert_institution_org_info
                (
                p_action                =>  'INSERT-UPDATE',
                p_institution_id        =>  m_id,
                p_service_subscribed    =>  NVL(rec30.PaymentMethod, m_PaymentMethod),--NVL(rec27.PaymentMethod, m_PaymentMethod),
                p_originating_system    =>  NVL(rec26.AccPacTp, m_OriginatingSystem),
                p_customerId            =>  rec26.customerId,
                p_institution_type      =>  m_CustomerType,
                p_institution_subtype   =>  m_CustomerSubType,
                p_cocnumber             =>  m_CoCNumber,
                p_CountryCode           =>  m_CountryCode,
                p_City                  =>  m_City,
                p_LegalEntity           =>  m_LegalEntity,
                p_CompanyName           =>  m_CompanyName,
                p_comp_prev_name        =>    m_comp_prev_name,    ---Newly added company tags
                p_comp_business_nature  =>  m_business_nature,
                p_company_type          =>    m_company_type,
                p_company_status        =>    m_company_status,
                p_pep                   =>    m_pep,
                p_business_other_ctry   =>    m_buss_other_ctry,
                p_expected_annual_volume    =>     m_exp_annual_vol,
                p_StreetName            =>  m_StreetName,
                p_HouseNo               =>  m_HouseNo,
                p_PostalCode            =>  m_PostalCode,
                p_tenant                => m_TenantName
                );
               IF m_count_synonym > 0
               THEN
                DBMS_OUTPUT.PUT_LINE('CALLING upsert_institution_org_info_syn');
                upsert_institution_org_info_syn
                (
                p_action                =>  'INSERT-UPDATE',
                p_institution_id        =>  m_id,
                            p_service_subscribed    =>  NVL(rec30.PaymentMethod, m_PaymentMethod), --NVL(rec27.PaymentMethod, m_PaymentMethod),
                p_originating_system    =>  NVL(rec26.AccPacTp, m_OriginatingSystem),
                p_customerId            =>  rec26.customerId,
                p_institution_type      =>  m_CustomerType,
                p_cocnumber             =>  m_CoCNumber,
                p_CountryCode           =>  m_CountryCode,
                p_City                  =>  m_City,
                p_LegalEntity           =>  m_LegalEntity,
                p_CompanyName           =>  m_CompanyName,
                p_comp_prev_name        =>    m_comp_prev_name,    ---Newly added company tags
                p_comp_business_nature  =>  m_business_nature,
                p_company_type          =>    m_company_type,
                p_company_status        =>    m_company_status,
                p_pep                   =>    m_pep,
                p_business_other_ctry   =>    m_buss_other_ctry,
                p_expected_annual_volume    =>     m_exp_annual_vol,
                p_StreetName            =>  m_StreetName,
                p_HouseNo               =>  m_HouseNo,
                p_PostalCode            =>  m_PostalCode,
                p_tenant                => m_TenantName
                );
               END IF;

            EXCEPTION
                WHEN OTHERS
                THEN
                    DBMS_OUTPUT.PUT_LINE('OTHERS : ' || SQLERRM || SQLCODE);
            END;
        END LOOP;

        m_parent_tag_path := 'ProductConfiguration/Customer';

        m_xpath := m_parent_tag_path || '/AccountingPackages/AccountingPackage/Loket';

        m_xtype     := XMLTYPE(xmlData => p_onboard_info);

        --DBMS_OUTPUT.PUT_LINE('m_xtype : ' || m_xtype);
        DBMS_OUTPUT.PUT_LINE('m_xpath : ' || m_xpath);

        /*SELECT EXISTSNODE(m_xtype, m_xpath)
        INTO m_node_present
        FROM DUAL;*/

        DBMS_OUTPUT.PUT_LINE('m_node_present : ' || m_node_present);

        IF  m_node_present > 0 AND rec26.WebUser IS NULL
        THEN
            m_return_number  := 7.4;
            m_exception_desc := 'Mandatory component =>' || m_xpath || '/' || 'WebUser' || ' not found while onboarding Customer ID => ' || m_id ;
            DBMS_OUTPUT.put_line('Exception    :    ' || m_exception_desc);
            RAISE ONBOARDING_EXCEPTION;
        END IF;

        IF  m_node_present > 0 AND rec26.WebPass IS NULL
        THEN
            m_return_number  := 7.4;
            m_exception_desc := 'Mandatory component =>' || m_xpath || '/' || 'WebPass' || ' not found while onboarding Customer ID => ' || m_id ;
            DBMS_OUTPUT.put_line('Exception    :    ' || m_exception_desc);
            RAISE ONBOARDING_EXCEPTION;
        END IF;

        IF  m_node_present > 0 AND rec26.WebEnv IS NULL
        THEN
            m_return_number  := 7.4;
            m_exception_desc := 'Mandatory component =>' || m_xpath || '/' || 'WebEnv' || ' not found while onboarding Customer ID => ' || m_id ;
            DBMS_OUTPUT.put_line('Exception    :    ' || m_exception_desc);
            RAISE ONBOARDING_EXCEPTION;
        END IF;

        SELECT  COUNT(*)
        INTO    m_uuser_auth_count
        FROM    uuser_auth
        WHERE   userid = 'ADMIN1'
        AND     institutionid = m_id
        AND     identity_provider IN ('SAGE','LOKET')
        --OR identity_provider = 'XERO'
        AND     scope = 'ALL'
        AND     type = 'OAuth';

        IF  UPPER(rec26.AccPacTp) = 'LOKET' AND m_uuser_auth_count = 0
        THEN
        upsert_uuser_auth
        (
            p_action                    =>  'INSERT-UPDATE',
            p_userid                    =>    'ADMIN1',
            p_institutionid             =>    m_id,
            p_identity_provider         =>  rec26.AccPacTp,
            p_webservice_username       =>  rec26.WebUser,
            p_webservice_password       =>  rec26.WebPass,
            p_webservice_environment    =>  rec26.WebEnv,
            p_token                     =>  rec26.AccessToken,
            p_access_token_exp_date     => rec26.AccessTokenExpiryDate,
            p_refresh_token             => rec26.RefreshToken,
            p_refresh_token_exp_date    => rec26.RefreshTokenExpiryDate
        );
            DBMS_OUTPUT.put_line('WebUser IF : ' || rec26.WebUser);
        ELSIF UPPER(rec26.AccPacTp) = 'NMBRS'
        THEN
            dbms_output.put_line('WebUser : ' || rec26.WebUser);
             upsert_uuser_auth
            (
                p_action                    =>  'INSERT-UPDATE',
                p_userid                    =>    'ADMIN1',
                p_institutionid             =>    m_id,
                p_identity_provider         =>  rec26.AccPacTp,
                p_webservice_username       =>  rec26.UserName,
                p_token                     =>  rec26.token,
                p_access_token_exp_date     => rec26.AccessTokenExpiryDate,
                p_refresh_token             => rec26.RefreshToken,
                p_refresh_token_exp_date    => rec26.RefreshTokenExpiryDate
            );
m_return_code := mgmt_institutionparameter(p_action=>'INSERT-UPDATE',p_institutionid=>m_id, p_path_old=>'INSTITUTION_DETAILS.TOKEN', p_paramname=>'TOKENINSTITUTIONID', p_paramvalue=>rec26.tokenInstitutionId);

                DBMS_OUTPUT.put_line('WebUser IF : ' || rec26.WebUser);
                DBMS_OUTPUT.put_line('Token IF : ' || rec26.token);

        ELSIF UPPER(rec26.AccPacTp) = 'SAGE' AND m_uuser_auth_count = 0
        THEN
            upsert_uuser_auth
            (
                p_action                    =>  'INSERT-UPDATE',
                p_userid                    =>    'ADMIN1',
                p_institutionid             =>    m_id,
                p_identity_provider         =>  rec26.AccPacTp,
                p_token                     =>  rec26.AccessToken,
                p_access_token_exp_date     => rec26.AccessTokenExpiryDate,
                p_refresh_token             => rec26.RefreshToken,
                p_refresh_token_exp_date    => rec26.RefreshTokenExpiryDate
            );
        ELSIF UPPER(rec26.AccPacTp) = 'XERO' --AND m_uuser_auth_count = 0
        THEN
            dbms_output.put_line('WebUser : ' || rec26.WebUser);
             upsert_uuser_auth
            (
                p_action                    =>  'INSERT-UPDATE',
                p_userid                    =>    'ADMIN1',
                p_institutionid             =>    m_id,
                p_identity_provider         =>  rec26.AccPacTp,
                p_token                     =>  rec26.AccessToken,
                p_access_token_exp_date     => rec26.AccessTokenExpiryDate,
                p_refresh_token             => rec26.RefreshToken,
                p_refresh_token_exp_date    => rec26.RefreshTokenExpiryDate
            );

                DBMS_OUTPUT.put_line('WebUser IF : ' || rec26.WebUser);
                DBMS_OUTPUT.put_line('Token IF : ' || rec26.token);


        END IF;
            --dbms_output.put_line('PaymentOption : ' || rec26.PaymentOption);  --Inserted into INSTITUTIONPARAMETERS table

            m_return_code := mgmt_institutionparameter(p_action=>'INSERT-UPDATE',p_institutionid=>m_id, p_path_old=>'INSTITUTION_DETAILS.PAYMENT_OPTION', p_paramname=>'PAYMENT_MODE', p_paramvalue=>rec26.PaymentMode);
            m_return_code := mgmt_institutionparameter(p_action=>'INSERT-UPDATE',p_institutionid=>m_id, p_path_old=>'INSTITUTION_DETAILS.PAYMENT_OPTION', p_paramname=>'PAYMENT_RUN_DATE_TYPE', p_paramvalue=>rec26.PaymentRunDateType);
            m_return_code := mgmt_institutionparameter(p_action=>'INSERT-UPDATE',p_institutionid=>m_id, p_path_old=>'INSTITUTION_DETAILS.PAYMENT_OPTION', p_paramname=>'PAYMENT_N_VALUE', p_paramvalue=>rec26.PaymentNValue);
            m_return_code := mgmt_institutionparameter(p_action=>'INSERT-UPDATE',p_institutionid=>m_id, p_path_old=>'INSTITUTION_DETAILS.PAYMENT_OPTION', p_paramname=>'PAYMENT_DAY_OF_WEEK', p_paramvalue=>rec26.PaymentDayOfWeek);

            SELECT to_char(systimestamp, 'yyyy-mm-dd') || 'T00:00:00'
            INTO m_paymenttimestamp
            FROM DUAL;

            m_return_code := mgmt_institutionparameter(p_action=>'INSERT-UPDATE',p_institutionid=>m_id, p_path_old=>'INSTITUTION_DETAILS.PAYMENT_OPTION', p_paramname=>'PAYMENT_RUN_TYPE_UPDATE_DATE', p_paramvalue=>m_paymenttimestamp);

    END LOOP;

        ELSIF m_node_present1 > 0 AND m_node_present2 > 0
THEN
            DBMS_OUTPUT.PUT_LINE('CALLING upsert_institution_org_info');

            upsert_institution_org_info
            (
            p_action                =>  'INSERT-UPDATE',
            p_institution_id        =>  m_id,
            p_service_subscribed    =>  m_PaymentMethod,
            p_originating_system    =>  m_OriginatingSystem,
            p_customerId            =>  m_CoCNumber,
            p_institution_type      =>  m_CustomerType,
            p_institution_subtype   =>  m_CustomerSubType,
            p_cocnumber             =>  m_CoCNumber,
            p_CountryCode           =>  m_CountryCode,
            p_City                  =>  m_City,
            p_LegalEntity           =>  m_LegalEntity,
            p_CompanyName           =>  m_CompanyName,
            p_comp_prev_name        =>    m_comp_prev_name,    ---Newly added company tags
            p_comp_business_nature  =>  m_business_nature,
            p_company_type          =>    m_company_type,
            p_company_status        =>    m_company_status,
            p_pep                   =>    m_pep,
            p_business_other_ctry   =>    m_buss_other_ctry,
            p_expected_annual_volume    =>     m_exp_annual_vol,
            p_StreetName            =>  m_StreetName,
            p_HouseNo               =>  m_HouseNo,
            p_PostalCode            =>  m_PostalCode,
            p_tenant                => m_TenantName
            );

            IF m_count_synonym > 0
            THEN
    DBMS_OUTPUT.PUT_LINE('CALLING upsert_institution_org_info_syn');
            upsert_institution_org_info_syn
            (
            p_action                =>  'INSERT-UPDATE',
            p_institution_id        =>  m_id,
            p_service_subscribed    =>  m_PaymentMethod,
            p_originating_system    =>  m_OriginatingSystem,
            p_customerId            =>  m_CoCNumber,
            p_institution_type      =>  m_CustomerType,
            p_cocnumber             =>  m_CoCNumber,
            p_CountryCode           =>  m_CountryCode,
            p_City                  =>  m_City,
            p_LegalEntity           =>  m_LegalEntity,
            p_CompanyName           =>  m_CompanyName,
            p_comp_prev_name        =>    m_comp_prev_name,    ---Newly added company tags
            p_comp_business_nature  =>  m_business_nature,
            p_company_type          =>    m_company_type,
            p_company_status        =>    m_company_status,
            p_pep                   =>    m_pep,
            p_business_other_ctry   =>    m_buss_other_ctry,
            p_expected_annual_volume    =>     m_exp_annual_vol,
            p_StreetName            =>  m_StreetName,
            p_HouseNo               =>  m_HouseNo,
            p_PostalCode            =>  m_PostalCode,
            p_tenant                => m_TenantName
            );
            END IF;
        END IF;
    DBMS_OUTPUT.PUT_LINE('--------------------AccountingPackages END----------------------');
    --AccountingPackages END


    --Company START


        ctr := 1;
        DBMS_OUTPUT.PUT_LINE('ctr : ' || ctr);
        DELETE FROM UBO
        WHERE INSTITUTIONID = m_id;
        FOR rec25 IN c25(m_ubo)
        LOOP
            DBMS_OUTPUT.PUT_LINE('rec25.Title : ' || rec25.Title);
            DBMS_OUTPUT.PUT_LINE('rec25.Role : ' || rec25.Role);
            DBMS_OUTPUT.PUT_LINE('rec25.FirstName : ' || rec25.FirstName);
            DBMS_OUTPUT.PUT_LINE('rec25.LastName : ' || rec25.LastName);
            DBMS_OUTPUT.PUT_LINE('rec25.DateOfBirth : ' || rec25.DateOfBirth);
            DBMS_OUTPUT.PUT_LINE('rec25.PlaceOfBirth : ' || rec25.PlaceOfBirth);
            DBMS_OUTPUT.PUT_LINE('rec25.CountryOfBirth : ' || rec25.CountryOfBirth);
            DBMS_OUTPUT.PUT_LINE('rec25.InsertFlag : ' || rec25.InsertFlag);

            --m_dob := TO_DATE(rec25.DateOfBirth, 'YYYY/MM/DD');msgdb
            --DBMS_OUTPUT.PUT_LINE('m_dob : ' || m_dob);

            m_xpath    := m_xpath_node || '/Company/UBOS/UBO';
            SELECT LENGTH (TO_CHAR(ctr)) INTO m_ctr from dual;

            IF m_ctr <= 1
            THEN
            m_seqno := LPAD(LTRIM(TO_CHAR(ctr)),2,'0');
            ELSE
            m_seqno := TO_NUMBER(LPAD(LTRIM(TO_CHAR(ctr)),4,'0'));
            END IF;
            DBMS_OUTPUT.PUT_LINE('m_seqno : ' || m_seqno);
            mgmt_ubo
            (
            p_action                    => 'INSERT-UPDATE',
            p_institutionid            => m_id,
            --p_uboid                     =>  m_seqno,
            p_uboid                        => rec25.UBOID,
            p_Title                     =>rec25.Title,
            p_Role                      =>rec25.Role,
            p_Name                      =>rec25.FirstName || ' ' || rec25.LastName,
            p_DateOfBirth               =>TO_DATE(rec25.DateOfBirth, 'YYYYMMDD'),
            p_PlaceOfBirth              =>rec25.PlaceOfBirth,
            p_CountryOfBirth            =>rec25.CountryOfBirth,
            p_InsertFlag                =>rec25.InsertFlag,
            p_Nationality               => rec25.Nationality,
            p_ctry_residence            =>  rec25.CountryOfResidence,
            p_appointedon               =>  TO_DATE(rec25.Appointedon, 'YYYYMMDD'),
            p_shares                    =>rec25.Shares,
            p_status                    => rec25.Status,
            p_address                    =>rec25.address
            );
            ctr := ctr+1;
        END LOOP;

        --Added for PartnerService --If service subscription Yes then add below tags else raise exception
        IF UPPER(m_partner_subscription) IN ('Y','YES')
        THEN
            --If PartnerService subscription is yes then insert m_comp_desc in PARTNER_DESCRIPTION column of PARTNERS table.
            --insert in institutionparameters
            DBMS_OUTPUT.put_line('Partner service started !');
            m_return_code := mgmt_institutionparameter(p_action=>'INSERT-UPDATE',p_institutionid=>m_id, p_path_old=>'PARTNERSERVICE', p_paramname=>'SERVICE_SUBSCRIBED', p_paramvalue=>m_partner_subscription);
            m_return_code := mgmt_institutionparameter(p_action=>'INSERT-UPDATE',p_institutionid=>m_id, p_path_old=>'PARTNERSERVICE', p_paramname=>'CLIENTID', p_paramvalue=>m_partner_client_id);
    m_return_code := mgmt_institutionparameter(p_action=>'INSERT-UPDATE',p_institutionid=>m_id, p_path_old=>'PARTNERSERVICE', p_paramname=>'CLIENT_SECRET', p_paramvalue=>m_partner_client_secret);
            m_return_code := mgmt_institutionparameter(p_action=>'INSERT-UPDATE',p_institutionid=>m_id, p_path_old=>'PARTNERSERVICE', p_paramname=>'CUSTOMER_TYPE', p_paramvalue=>m_partner_customer_type);
            m_return_code := mgmt_institutionparameter(p_action=>'INSERT-UPDATE',p_institutionid=>m_id, p_path_old=>'PARTNERSERVICE', p_paramname=>'DATAMODE', p_paramvalue=>m_partner_data_mode);
            m_return_code := mgmt_institutionparameter(p_action=>'INSERT-UPDATE',p_institutionid=>m_id, p_path_old=>'PARTNERSERVICE', p_paramname=>'WEBHOOK_CUSTOMERURL', p_paramvalue=>m_partner_web_url);
            m_return_code := mgmt_institutionparameter(p_action=>'INSERT-UPDATE',p_institutionid=>m_id, p_path_old=>'PARTNERSERVICE', p_paramname=>'WEBHOOK_SECURITYKEY', p_paramvalue=>m_partner_web_key);
            m_return_code := mgmt_institutionparameter(p_action=>'INSERT-UPDATE',p_institutionid=>m_id, p_path_old=>'PARTNERSERVICE', p_paramname=>'CUSTOMERLOGOURL', p_paramvalue=>m_partner_logo_url);
        END IF;
        IF UPPER(m_partner_subscription) = 'NO' OR UPPER(m_partner_subscription) ='N'
        THEN
            DBMS_OUTPUT.put_line('Partner service not subscribed!');
            RAISE SERVICE_NOT_SUBSCRIBED;
        END IF;
        
        IF UPPER(m_Categorisation_subscription) IN ('Y','YES')
        THEN
            DBMS_OUTPUT.put_line('Categorisation service started !');
            m_return_code := mgmt_institutionparameter(p_action=>'INSERT-UPDATE',p_institutionid=>m_id, p_path_old=>'CATEGORISATION_SERVICE.ACCOUNT.SUBSCRIPTION', p_paramname=>'SUBSCRIPTION', p_paramvalue=>m_Categorisation_subscription);
        ELSE
            m_return_code := mgmt_institutionparameter(p_action=>'INSERT-UPDATE',p_institutionid=>m_id, p_path_old=>'CATEGORISATION_SERVICE.ACCOUNT.SUBSCRIPTION', p_paramname=>'SUBSCRIPTION', p_paramvalue=>'NO');
        DBMS_OUTPUT.put_line('Categorisation service not subscribed!');
        END IF;
    --Company END

        --m_tdvalue := td_get_value('INST_NM_ACC_PKG','BRAND_NAME_LIST1');

        --select UPPER(PARA_CODE) FROM TABLE(get_code_from_list((TD_GET_VALUE('INST_NM_ACC_PKG', 'BRAND_NAME_LIST'), ',')) into m_tdvalue from dual;

        DBMS_OUTPUT.put_line('m_tdvalue ********** : ' || m_tdvalue);

        IF m_brandname IS NOT NULL
        THEN
            SELECT  LISTAGG(tdvalue, ',') WITHIN GROUP (ORDER BY tdvalue)
            INTO m_accpkg_tdvalue
            FROM TABLEDETAILS
            WHERE TDIDCODE = 'INST_NM_ACC_PKG' AND TDKEY LIKE 'BRAND_NAME_LIST%'
            OR TDVALUE IN (SELECT PARA_CODE FROM table(GET_CODE_FROM_LIST(NVL(TD_GET_VALUE('INST_NM_ACC_PKG','BRAND_NAME_LIST1'),'X'),',')) WHERE PARA_CODE = m_BRANDNAME);
           --AND tdvalue = UPPER(m_BRANDNAME);
           DBMS_OUTPUT.put_line('m_accpkg_tdvalue ****** : ' || m_accpkg_tdvalue);

        END IF;


         IF m_TenantName IS NOT NULL
            THEN
                SELECT  LISTAGG(tdvalue, ',') WITHIN GROUP (ORDER BY tdvalue)
                INTO m_coc_tdvalue
                FROM TABLEDETAILS
                WHERE TDIDCODE = 'INST_NM_COC' AND TDKEY LIKE 'TENANT_NAME_LIST%'
                AND tdvalue = UPPER(m_TenantName);
         END IF;
        dbms_output.put_line('B4 m_cocnumber : ' || m_cocnumber);
        dbms_output.put_line('B4 m_coc_tdvalue : ' || m_coc_tdvalue);
        IF m_companyname IS NOT NULL
        THEN
            UPDATE INSTITUTIONMASTER
            SET INSTITUTIONNAME =   CASE
                                    WHEN m_coc_tdvalue IS NOT NULL AND m_cocnumber IS NOT NULL
                                    THEN
                                        m_companyname || ' (' ||m_cocnumber || ')'

--                                    WHEN m_accpkg_tdvalue IS NOT NULL AND m_accoutingpackagename IS NOT NULL
--                                    THEN
--                                        m_companyname || ' (' ||m_accoutingpackagename || ')'
                                    WHEN m_cocnumber IS NOT NULL
                                    THEN
                                        m_companyname || ' (' ||m_cocnumber || ')'
                                    ELSE
                                       m_companyname
                                        --m_id
                                    END,
                institution_subtype = m_CustomerSubType 
            WHERE institutionid = m_id;
        ELSE
            UPDATE INSTITUTIONMASTER
            SET institution_subtype = m_CustomerSubType,
                INSTITUTIONNAME =  m_id
            WHERE institutionid = m_id;
        END IF;
        DBMS_OUTPUT.put_line('Reporting START');
        DBMS_OUTPUT.put_line('-----------------------------------------------');
        ctr := 1;
        DBMS_OUTPUT.put_line('Count : ' || ctr);
        ctr := ctr + 1;
        m_xpath := '/ProductConfiguration/Customer/Reporting';
        FOR rec2 IN c2(m_xpath)
        LOOP
            DBMS_OUTPUT.put_line('Count : ' || ctr);
            DBMS_OUTPUT.put_line('ServiceSubscription : ' || rec2.ServiceSubscription);
            DBMS_OUTPUT.put_line('ScanningAndTransactionMonitoringServiceSubscription : ' || rec2.ScanningAndTransactionMonitoringServiceSubscription);
            DBMS_OUTPUT.put_line('UltimateTime        : ' || rec2.UltimateTime);
            DBMS_OUTPUT.put_line('MatchStatements        : ' || rec2.MatchStatements);
            DBMS_OUTPUT.put_line('ScanningRequired        : ' || rec2.ScanningRequired);
            DBMS_OUTPUT.put_line('MonitoringRequired        : ' || rec2.MonitoringRequired);

            BEGIN
                SELECT    to_char(to_date(rec2.UltimateTime,'HH24:MI:SS'),'HH24:MI:SS')
                INTO    m_date
                FROM    dual;
                DBMS_OUTPUT.put_line('Exception UltimateTime        : ' || m_date);
            EXCEPTION
                WHEN OTHERS
                THEN
                    ROLLBACK;
                    m_return_number        := 4;
                    m_exception_desc    := 'Invalid Data =>' || m_xpath || '/' || 'UltimateTime';
                    RAISE ONBOARDING_EXCEPTION;
            END;

            m_return_code := mgmt_institutionparameter(p_action=>'UPDATE',p_institutionid=>m_id, p_path_old=>'REPORTING', p_paramname=>'SERVICE_SUBSCRIBED', p_paramvalue=>rec2.ServiceSubscription);
            m_return_code := mgmt_institutionparameter(p_action=>'INSERT-UPDATE',p_institutionid=>m_id, p_path_old=>'REPORTING', p_paramname=>'SCANNING_TRANSACTION_MONITORING', p_paramvalue=>NVL(rec2.ScanningAndTransactionMonitoringServiceSubscription, 'NO'));
            m_return_code := mgmt_institutionparameter(p_action=>'UPDATE',p_institutionid=>m_id, p_path_old=>'REPORTING', p_paramname=>'ULTIMATE_TIME', p_paramvalue=>rec2.UltimateTime);
            m_return_code := mgmt_institutionparameter(p_action=>'INSERT-UPDATE',p_institutionid=>m_id, p_path_old=>'REPORTING', p_paramname=>'SCANNING_REQUIRED', p_paramvalue=>rec2.ScanningRequired);
            m_return_code := mgmt_institutionparameter(p_action=>'INSERT-UPDATE',p_institutionid=>m_id, p_path_old=>'REPORTING', p_paramname=>'MONITORING_REQUIRED', p_paramvalue=>rec2.MonitoringRequired);
            m_xpath      := m_xpath_node || '/Reporting/MatchStatements';

--            IF rec2.MatchStatements IS NULL
--            THEN
--                m_return_number        := 6;
--                m_exception_desc    := 'Mandatory component => ' || m_xpath || ' ' || ' not found';
--                RAISE ONBOARDING_EXCEPTION;
--            END IF;
            m_paramvalue         := rec2.MatchStatements;
            m_return_code        := mgmt_institutionparam_usexpath(p_action_passed=>'INSERT-UPDATE',p_institutionid_passed=>m_id, p_xpath_root=>m_xpath_root, p_xpath_child=>m_xpath, p_paramvalue=>m_paramvalue);
        ctr := ctr + 1;
        END LOOP;

        IF ctr = 2
        THEN
            m_return_code := mgmt_institutionparameter(p_action=>'UPDATE',p_institutionid=>m_id, p_path_old=>'REPORTING', p_paramname=>'SERVICE_SUBSCRIBED', p_paramvalue=>'NO');
        END IF;

        m_verwinfoa := TRUE;
        m_verwinfob := TRUE;
        m_verwinfoc := TRUE;
        ctr := 1;
        m_xpath := '/ProductConfiguration/Customer/Reporting/OutputSettings';
        FOR rec7 IN c7(m_xpath)
        LOOP
            IF ctr = 1
            THEN
                OPEN c8(m_id);
                FETCH c8 BULK COLLECT INTO t_institutionparameters;
                IF t_institutionparameters.FIRST > 0
                THEN
                    FORALL    acc_institution IN t_institutionparameters.FIRST..t_institutionparameters.LAST
                    DELETE    FROM    institutionparameters
                    WHERE   institutionid    = t_institutionparameters(acc_institution).institutionid
                    AND     paramname        = t_institutionparameters(acc_institution).paramname
                    AND     path             = t_institutionparameters(acc_institution).path;
                END IF;
                CLOSE c8;

                OPEN c19(m_id);
                FETCH c19 BULK COLLECT INTO t_institutionparameters;
                IF t_institutionparameters.FIRST > 0
                THEN
                    FORALL acc_institution IN t_institutionparameters.FIRST..t_institutionparameters.LAST
                    DELETE FROM    institutionparameters
                    WHERE  institutionid    = t_institutionparameters(acc_institution).institutionid
                    AND    paramname        = t_institutionparameters(acc_institution).paramname
                    AND    path             = t_institutionparameters(acc_institution).path;
                END IF;
                CLOSE c19;

                /*OPEN c14(m_id);
                FETCH c14 BULK COLLECT INTO t_account_master;
                IF t_account_master.FIRST > 0
                THEN
                    FORALL acc_ctr IN t_account_master.FIRST..t_account_master.LAST
                    UPDATE    account_master
                    SET        account_status = 'DELETED'
                    WHERE   institution_id = t_account_master(acc_ctr).institution_id
                    AND     customer_id    = t_account_master(acc_ctr).customer_id
                    AND     account_number = t_account_master(acc_ctr).account_number
                    AND     bank_code      = t_account_master(acc_ctr).bank_code
                    AND     branch         = t_account_master(acc_ctr).branch;
                END IF;
                CLOSE c14; */

                   DELETE FROM institutionparameters_map
                WHERE institutionid =  m_id
                AND label LIKE '@OUTPUT_SETTINGS-%';

                   DELETE FROM institutionparameters_map
                WHERE institutionid =  m_id
                AND label LIKE '%-REPORTING';

                   DELETE FROM institutionparameters
                WHERE institutionid =  m_id
                AND PATH = 'REPORTING.OUTPUT_SETTINGS-[nn]';

                OPEN c19(p_cinstitutionid);
                FETCH c19 BULK COLLECT INTO t_institutionparameters;
                IF t_institutionparameters.FIRST > 0
                THEN
                    FOR i IN t_institutionparameters.FIRST..t_institutionparameters.LAST
                    LOOP
                        t_institutionparameters(i).institutionid := m_id;
                        t_institutionparameters(i).sequenceno    := t_institutionparameters(i).sequenceno||'.'||m_seqno;
                    END LOOP;
                    FORALL i IN t_institutionparameters.FIRST..t_institutionparameters.LAST
                    INSERT INTO institutionparameters VALUES t_institutionparameters(i);
                END IF;
                CLOSE c19;

            END IF;

            IF       rec7.FileType = 'VERWINFA'
            THEN
                m_count_verwinfoa := m_count_verwinfoa + 1;
            ELSIF rec7.FileType = 'VERWINFB' THEN
                m_count_verwinfob := m_count_verwinfob + 1;
            ELSIF rec7.FileType = 'VERWINFC' THEN
                m_count_verwinfoc := m_count_verwinfoc + 1;
            END IF;

            --m_seqno := TO_NUMBER(LPAD(LTRIM(TO_CHAR(ctr)),4,'0'));

              SELECT LENGTH (TO_CHAR(ctr)) INTO m_ctr from dual;
              IF m_ctr <= 1
              THEN
                 m_seqno := LPAD(LTRIM(TO_CHAR(ctr)),2,'0');
              ELSE
                m_seqno := TO_NUMBER(LPAD(LTRIM(TO_CHAR(ctr)),4,'0'));
              END IF;

            DBMS_OUTPUT.put_line('Sequence            : ' || m_seqno);
            m_path  := 'REPORTING.OUTPUT_SETTINGS-' || m_seqno;

            OPEN c8(p_cinstitutionid);
            FETCH c8 BULK COLLECT INTO t_institutionparameters;
            IF t_institutionparameters.FIRST > 0
            THEN
                FOR i IN t_institutionparameters.FIRST..t_institutionparameters.LAST
                LOOP
                    t_institutionparameters(i).institutionid := m_id;
                    t_institutionparameters(i).path          := 'REPORTING.OUTPUT_SETTINGS-'||m_seqno;
                    t_institutionparameters(i).sequenceno    := t_institutionparameters(i).sequenceno||'.'||m_seqno;
                END LOOP;
                FORALL i IN t_institutionparameters.FIRST..t_institutionparameters.LAST
                INSERT INTO institutionparameters VALUES t_institutionparameters(i);
            END IF;
            CLOSE c8;

            DBMS_OUTPUT.put_line('Count : ' || ctr);
            DBMS_OUTPUT.put_line('FileType                  : ' || rec7.FileType);
            DBMS_OUTPUT.put_line('VERWINFOCFileTypeSpecial  : ' || rec7.VERWINFOCFileTypeSpecial);
            DBMS_OUTPUT.put_line('Structure                 : ' || rec7.Structure);
            DBMS_OUTPUT.put_line('Aggregation               : ' || rec7.Aggregation);
            DBMS_OUTPUT.put_line('OutputChannel             : ' || rec7.OutputChannel);
            --DBMS_OUTPUT.put_line('InputChannel              : ' || rec7.InputChannel);
            --DBMS_OUTPUT.put_line('INGMigration              : ' || rec7.INGMigration);


          /*    IF rec7.OutputChannel = 'AAB_DA'
            THEN
                m_output_channel := 'ABNAMRO';
            ELSIF rec7.OutputChannel = 'AAB_DO' THEN
                m_output_channel := 'ABNAMRO';
            ELSIF rec7.OutputChannel = 'RABO_RIBPRO' THEN
                m_output_channel := 'RABO_RIBPRO';
            ELSIF rec7.OutputChannel = 'RABO_RDC' THEN
                m_output_channel := 'RABO_RDC';
            ELSIF rec7.OutputChannel = 'RABO_RCM' THEN
                m_output_channel := 'RABO';
            ELSIF rec7.OutputChannel = 'RBS_DA' THEN
                m_output_channel := 'RBS_DA';
            ELSIF rec7.OutputChannel = 'RBS_DO' THEN
                m_output_channel := 'RBS_DO';
            ELSIF rec7.OutputChannel = 'ING_FTP' THEN
                m_output_channel := 'ING';
            ELSIF rec7.OutputChannel = 'ING_IBP' THEN
                m_output_channel := 'ING';
            ELSIF rec7.OutputChannel = 'DBIB' THEN
                m_output_channel := 'Deutsche Bank';
            ELSIF rec7.OutputChannel = 'DBDI' THEN
                m_output_channel := 'Deutsche Bank';
            END IF;     */

            m_output_channel := TD_GET_VALUE('EQ-ONBD-O-CHMAP', rec7.OutputChannel);

            m_return_code := mgmt_institutionparameter(p_action=>'UPDATE',p_institutionid=>m_id, p_path_old=>m_path, p_paramname=>'FILE_TYPE', p_paramvalue=>rec7.FileType);
            m_return_code := mgmt_institutionparameter(p_action=>'UPDATE',p_institutionid=>m_id, p_path_old=>m_path, p_paramname=>'VERWINFO_FILE_TYPE_SPECIAL', p_paramvalue=>rec7.VERWINFOCFileTypeSpecial);
            m_return_code := mgmt_institutionparameter(p_action=>'UPDATE',p_institutionid=>m_id, p_path_old=>m_path, p_paramname=>'STRUCTURE', p_paramvalue=>rec7.Structure);
            m_return_code := mgmt_institutionparameter(p_action=>'UPDATE',p_institutionid=>m_id, p_path_old=>m_path, p_paramname=>'AGGREGATION', p_paramvalue=>rec7.Aggregation);
            m_return_code := mgmt_institutionparameter(p_action=>'UPDATE',p_institutionid=>m_id, p_path_old=>m_path, p_paramname=>'OUTPUT_CHANNEL', p_paramvalue=>m_output_channel);
            m_return_code := mgmt_institutionparameter(p_action=>'UPDATE',p_institutionid=>m_id, p_path_old=>m_path, p_paramname=>'IBAN', p_paramvalue=>'@OUTPUT_SETTINGS-'||rec7.FileType||'-'||m_seqno);

            FOR rec18 IN c18(rec7.Accounts)
            LOOP
                m_iban := NULL;
                m_account_number := NULL;
                IF rec18.AccountNo <> 'NOTPROVIDED'
                THEN
                    m_account_number := rec18.AccountNo;
                END IF;

                IF rec18.IBAN <> 'NOTPROVIDED'
                THEN
                    m_iban  := rec18.IBAN;
                END IF;

                IF SUBSTR(rec18.IBAN, 1, 2) = 'NL'
                THEN
                IF LENGTH (rec18.IBAN) > 10
                THEN
                      m_account_number := SUBSTR(rec18.IBAN, -10, 10);
                    m_iban := rec18.IBAN;
                   ELSE
                      m_account_number :=LPAD(LTRIM(TO_CHAR(rec18.IBAN)),10,'0');
                    m_iban := m_account_number;
                    END IF;
                END IF;

                IF    rec7.FileType = 'VERWINFA'
                THEN
                    IF m_count_verwinfoa = 1 AND m_verwinfoa = TRUE
                    THEN
                        m_return_code := mgmt_institutionparameter(p_action=>'UPDATE',p_institutionid=>m_id, p_path_old=>'REPORTING.VERWINFOA', p_paramname=>'PRIMARYACCOUNTNUMBER', p_paramvalue=>rec18.IBAN);
                        DBMS_OUTPUT.put_line('FileType : ' || rec7.FileType);
                        DBMS_OUTPUT.put_line('VERWINFOA.IBAN : ' || rec18.IBAN);
                        m_verwinfoa := FALSE;
                    END IF;
                ELSIF rec7.FileType = 'VERWINFB' THEN
                    IF m_count_verwinfob = 1 AND m_verwinfob = TRUE
                    THEN
                        m_return_code := mgmt_institutionparameter(p_action=>'UPDATE',p_institutionid=>m_id, p_path_old=>'REPORTING.VERWINFOB', p_paramname=>'PRIMARYACCOUNTNUMBER', p_paramvalue=>rec18.IBAN);
                        DBMS_OUTPUT.put_line('FileType                  : ' || rec7.FileType);
                        DBMS_OUTPUT.put_line('VERWINFOB.IBAN : ' || rec18.IBAN);
                        m_verwinfob := FALSE;
                    END IF;
                ELSIF rec7.FileType = 'VERWINFC' THEN
                    IF m_count_verwinfoc = 1 AND m_verwinfoc = TRUE
                    THEN
                        m_return_code := mgmt_institutionparameter(p_action=>'UPDATE',p_institutionid=>m_id, p_path_old=>'REPORTING.VERWINFOC1', p_paramname=>'PRIMARYACCOUNTNUMBER', p_paramvalue=>rec18.IBAN);
                        m_return_code := mgmt_institutionparameter(p_action=>'UPDATE',p_institutionid=>m_id, p_path_old=>'REPORTING.VERWINFOC2', p_paramname=>'PRIMARYACCOUNTNUMBER', p_paramvalue=>rec18.IBAN);
                        DBMS_OUTPUT.put_line('FileType                  : ' || rec7.FileType);
                        DBMS_OUTPUT.put_line('VERWINFOC.IBAN : ' || rec18.IBAN);
                        m_verwinfoc := FALSE;
                    END IF;
                END IF;

                DBMS_OUTPUT.put_line('INGMigration  : ' || rec18.INGMigration);
                DBMS_OUTPUT.put_line('InputChannel  : ' || rec18.InputChannel);

             /*    IF rec18.InputChannel = 'AAB_DA'
                THEN
                    m_input_channel := 'ABNAMRO';
                ELSIF rec18.InputChannel = 'AAB_DO' THEN
                    m_input_channel := 'ABNAMRO';
                ELSIF rec18.InputChannel = 'RABO_RIBPRO' THEN
                    m_input_channel := 'RABO_RIBPRO';
                ELSIF rec18.InputChannel = 'RABO_RDC' THEN
                    m_input_channel := 'RABO_RDC';
                ELSIF rec18.InputChannel = 'RABO_RCM' THEN
                    m_input_channel := 'RABO';
                ELSIF rec18.InputChannel = 'RBS_DA' THEN
                    m_input_channel := 'RBS_DA';
                ELSIF rec18.InputChannel = 'RBS_DO' THEN
                    m_input_channel := 'RBS_DO';
                ELSIF rec18.InputChannel = 'ING_FTP' THEN
                    m_input_channel := 'ING';
                ELSIF rec18.InputChannel = 'ING_IBP' THEN
                    m_input_channel := 'ING';
                ELSIF rec18.InputChannel = 'DBIB' THEN
                    m_input_channel := 'Deutsche Bank';
                ELSIF rec18.InputChannel = 'DBDI' THEN
                    m_input_channel := 'Deutsche Bank';
                END IF;     */

                m_input_channel := TD_GET_VALUE('EQ-ONBD-I-CHMAP', rec18.InputChannel);
                DBMS_OUTPUT.PUT_LINE ('Reporting p_account_string : ' || p_account_string);
                DBMS_OUTPUT.PUT_LINE ('Reporting m_account_number : ' || m_account_number);

                IF m_account_number IS NOT NULL --AND INSTR(NVL(p_account_string, 0), m_account_number) <=0
                THEN
                    DBMS_OUTPUT.put_line('IBAN : ' || rec18.IBAN);
                    m_mode := 'INSERT-UPDATE';
                    mgmt_account_master
                    (
                    p_action              => m_mode,
                    p_institution_id      => m_id,
                    p_customer_id         => m_account_number,
                    p_bank_code           => 'NOT-PROVIDED',
                    p_branch              => 'NOT-PROVIDED',
                    p_account_number      => m_account_number,
                    p_account_iban        => m_iban,
                    p_account_type        => NULL,
                    p_account_curr        => NULL,
                    p_credit_limit        => NULL,
                    p_account_desc        => NULL,
                    p_country_code        => m_countrycode,
                    p_account_status      => 'VALIDATED',
                    p_account_updatedby   => 'ADMIN1',
                    p_account_validatedby => 'ADMIN2',
                    p_crscheme_id          => NULL,
                    p_account_addl_property => rec18.INGMigration,
                    p_input_channel          => m_input_channel,
                    p_account_title         => NULL,
                    p_account_id            => NULL,
                    p_bank_name             => NULL,
                    p_image_url             => NULL,
                    p_account_mode          => NULL,
                    p_AccountSchemeId       => NULL,
                    p_acc_customer_id       => NULL,
                    p_defaultaccount_flag   => NULL,
                    p_created_by            => NULL
                    );
                END IF;

                 m_return_code := mgmt_institutionparameter(p_action=>'UPDATE',p_institutionid=>m_id, p_path_old=>m_path, p_paramname=>'ING_MIGRATION', p_paramvalue=>rec18.INGMigration);

                /*m_path := '@OUTPUT_SETTINGS-' || m_seqno;
                m_mode := 'INSERT-UPDATE';
                mgmt_institutionparameter_map
                (
                p_action              => m_mode,
                p_institutionid       => m_id,
                p_label                  => m_path,
                p_value                  => m_account_number,
                p_key                 => 'ACCOUNT_MASTER'
                ); */

                m_mode := 'INSERT-UPDATE';
                m_label_file_type := rec7.FileType;
                mgmt_institutionparameter_map
                (
                p_action           => m_mode,
                  p_institutionid    => m_id,
                p_label               => m_parent_id||'-'||m_CustomerType ||'-REPORTING',
                       p_value               => NVL(m_account_number,m_iban) ,
                   p_key              => 'CUSTOMER-TYPE',
                   p_data_keyid_list  => p_data_keyid_list
                );

                m_label_file_type := rec7.FileType;
                m_mode := 'INSERT-UPDATE';
                        IF m_account_number IS NOT NULL
                THEN

                mgmt_institutionparameter_map
                (
                p_action           => m_mode,
                  p_institutionid    => m_id,
                p_label               => '@OUTPUT_SETTINGS-'||m_label_file_type || '-' || m_seqno,
                   p_value               => m_account_number,
                   p_key              => 'ACCOUNT_MASTER',
                   p_data_keyid_list  => p_data_keyid_list
                );

                END IF;
                m_mode := 'INSERT-UPDATE';
                IF m_iban IS NOT NULL
                THEN
                mgmt_institutionparameter_map
                (
                p_action           => m_mode,
                  p_institutionid    => m_id,
                p_label               => '@OUTPUT_SETTINGS-'||m_label_file_type || '-' || m_seqno,
                   p_value               => m_iban,
                   p_key              => 'ACCOUNT_MASTER.ACCOUNT_IBAN',
                   p_data_keyid_list  => p_data_keyid_list
                );
                END IF;
            END LOOP;
            ctr := ctr + 1;
        END LOOP;

        DBMS_OUTPUT.put_line('Reporting END');
        DBMS_OUTPUT.put_line('-----------------------------------------------');

        DBMS_OUTPUT.put_line('----------------------------');
        DBMS_OUTPUT.put_line('BalanceManagement service information START');
        DBMS_OUTPUT.put_line('----------------------------');

        m_function := ob_BalanceMgmt_service(p_onboard_info,m_id);
        IF m_function <> 0
        THEN
            m_return_number  := 6.2;
            m_exception_desc := 'BalanceManagement onboarding failed';
            DBMS_OUTPUT.put_line('BalanceManagement onboarding failed');
        END IF;

        DBMS_OUTPUT.put_line('----------------------------');
        DBMS_OUTPUT.put_line('BalanceManagement service information END');
        DBMS_OUTPUT.put_line('----------------------------');


        DBMS_OUTPUT.put_line('Conversion START');
        DBMS_OUTPUT.put_line('----------------------------------------------');
        ctr := 1;
        DBMS_OUTPUT.put_line('Count : ' || ctr);
        m_xpath := '/ProductConfiguration/Customer/Conversion';
        FOR rec3 IN c3(m_xpath)
        LOOP
            DBMS_OUTPUT.put_line('ServiceSubscription                : ' || rec3.ServiceSubscription);
            m_return_code := mgmt_institutionparameter(p_action=>'UPDATE',p_institutionid=>m_id, p_path_old=>'CONVERSION', p_paramname=>'SERVICE_SUBSCRIBED', p_paramvalue=>rec3.ServiceSubscription);
            ctr := ctr + 1;
        END LOOP;
        IF ctr = 1
        THEN
            m_return_code := mgmt_institutionparameter(p_action=>'UPDATE',p_institutionid=>m_id, p_path_old=>'CONVERSION', p_paramname=>'SERVICE_SUBSCRIBED', p_paramvalue=>'NO');
        END IF;

        DBMS_OUTPUT.put_line('Ordering Agreement');
        DBMS_OUTPUT.put_line('-------------------------------------------------');

        ctr := 1;
        DBMS_OUTPUT.put_line('Count : ' || ctr);
        m_xpath := '/ProductConfiguration/Customer/Conversion/OrderingAgreement';
        FOR rec4 IN c4(m_xpath)
        LOOP
            DBMS_OUTPUT.put_line('Count : ' || ctr);
            DBMS_OUTPUT.put_line('SEPAScheme             : ' || rec4.SEPAScheme);
            DBMS_OUTPUT.put_line('SDDTransactionType     : ' || rec4.SDDTransactionType);
            DBMS_OUTPUT.put_line('CreditorSchemeId       : ' || rec4.CreditorSchemeId);
            DBMS_OUTPUT.put_line('MandateDeliveryType    : ' || rec4.MandateDeliveryType);
            DBMS_OUTPUT.put_line('OutputDestination      : ' || rec4.OutputDestination);
            DBMS_OUTPUT.put_line('OnboardingAllServiced  : ' || rec4.OnboardingAllServiced);

            IF ctr = 1
            THEN
                OPEN c9(m_id);
                FETCH c9 BULK COLLECT INTO t_order_agg;
                IF t_order_agg.FIRST > 0
                THEN
                        FORALL  acc_order_agg IN t_order_agg.FIRST..t_order_agg.LAST
                     DELETE FROM    institutionparameters
                     WHERE    institutionid    = t_order_agg(acc_order_agg).institutionid
                     AND      paramname        = t_order_agg(acc_order_agg).paramname
                     AND      path             = t_order_agg(acc_order_agg).path;
                    END IF;
                    CLOSE c9;

                OPEN c13(m_id);
                FETCH c13 BULK COLLECT INTO t_creditorschemeid;
                IF t_creditorschemeid.FIRST > 0
                 THEN
                       FORALL acc_crdtsch IN t_creditorschemeid.FIRST..t_creditorschemeid.LAST
                       UPDATE    creditorschemeid
                       SET        crscheme_status = 'DELETED'
                       WHERE    institution_id  = t_creditorschemeid(acc_crdtsch).institution_id
                       AND        crscheme_id     = t_creditorschemeid(acc_crdtsch).crscheme_id;
                 END IF;
                 CLOSE c13;

                OPEN c16(m_id);
                 FETCH c16 BULK COLLECT INTO t_order_acc;
                 IF t_order_acc.FIRST > 0
                  THEN
                       FORALL order_acc IN t_order_acc.FIRST..t_order_acc.LAST
                       DELETE FROM    institutionparameters
                       WHERE  institutionid    = t_order_acc(order_acc).institutionid
                       AND    paramname        = t_order_acc(order_acc).paramname
                       AND    path             = t_order_acc(order_acc).path;
                 END IF;
                 CLOSE c16;

                DELETE FROM institutionparameters_map
                WHERE institutionid =  m_id
                AND label LIKE '@ORDERING_AGREEMENT-%';

                DELETE FROM institutionparameters_map
                WHERE institutionid =  m_id
                AND label LIKE '@%ORDERING_AGREEMENT-%';

                DELETE FROM institutionparameters
                WHERE institutionid =  m_id
                AND PATH = 'CONVERSION.ORDERING_AGREEMENT-[nn]';

                DELETE FROM institutionparameters
                WHERE institutionid =  m_id
                AND PATH = 'CONVERSION.ORDERING_AGREEMENT-[nn].ORDERING_ACCOUNTS';
            END IF;

            --m_seqno := TO_NUMBER(LPAD(LTRIM(TO_CHAR(ctr)),4,'0'));

              SELECT LENGTH (TO_CHAR(ctr)) INTO m_ctr from dual;
              IF m_ctr <= 1
              THEN
                 m_seqno := LPAD(LTRIM(TO_CHAR(ctr)),2,'0');
              ELSE
                m_seqno := TO_NUMBER(LPAD(LTRIM(TO_CHAR(ctr)),4,'0'));
              END IF;

            m_path  := 'CONVERSION.ORDERING_AGREEMENT-' || m_seqno;

            OPEN c9(p_cinstitutionid);
            FETCH c9 BULK COLLECT INTO t_institutionparameters;
            IF t_institutionparameters.FIRST > 0
            THEN
                   FOR i IN t_institutionparameters.FIRST..t_institutionparameters.LAST
                   LOOP
                       t_institutionparameters(i).institutionid := m_id;
                       t_institutionparameters(i).path          := 'CONVERSION.ORDERING_AGREEMENT-'||m_seqno;
                       t_institutionparameters(i).sequenceno    := t_institutionparameters(i).sequenceno||'.'||m_seqno;
                   END LOOP;
                FORALL i IN t_institutionparameters.FIRST..t_institutionparameters.LAST
                INSERT INTO institutionparameters VALUES t_institutionparameters(i);
            END IF;
            CLOSE c9;

            OPEN c16(p_cinstitutionid);
            FETCH c16 BULK COLLECT INTO t_institutionparameters;
            IF t_institutionparameters.FIRST > 0
            THEN
                FOR i IN t_institutionparameters.FIRST..t_institutionparameters.LAST
                LOOP
                    t_institutionparameters(i).institutionid := m_id;
                    t_institutionparameters(i).path          := 'CONVERSION.ORDERING_AGREEMENT-'||m_seqno||'.ORDERING_ACCOUNTS';
                    t_institutionparameters(i).sequenceno    := t_institutionparameters(i).sequenceno||'.'||m_seqno;
                END LOOP;
                FORALL i IN t_institutionparameters.FIRST..t_institutionparameters.LAST
                INSERT INTO institutionparameters VALUES t_institutionparameters(i);
            END IF;
            CLOSE c16;

            m_return_code := mgmt_institutionparameter(p_action=>'UPDATE',p_institutionid=>m_id, p_path_old=>m_path, p_paramname=>'SEPA_SCHEME', p_paramvalue=>rec4.SEPAScheme);
            m_return_code := mgmt_institutionparameter(p_action=>'UPDATE',p_institutionid=>m_id, p_path_old=>m_path, p_paramname=>'SDD_TRANSACTION_TYPE', p_paramvalue=>rec4.SDDTransactionType);
            m_return_code := mgmt_institutionparameter(p_action=>'UPDATE',p_institutionid=>m_id, p_path_old=>m_path, p_paramname=>'CREDITOR_SCHEME_ID', p_paramvalue=>rec4.CreditorSchemeId);
            m_return_code := mgmt_institutionparameter(p_action=>'UPDATE',p_institutionid=>m_id, p_path_old=>m_path, p_paramname=>'MANDATE_DELIVERY_TYPE', p_paramvalue=>rec4.MandateDeliveryType);
            m_return_code := mgmt_institutionparameter(p_action=>'UPDATE',p_institutionid=>m_id, p_path_old=>m_path, p_paramname=>'OUTPUT_DESTINATION', p_paramvalue=>rec4.OutputDestination);
            m_return_code := mgmt_institutionparameter(p_action=>'UPDATE',p_institutionid=>m_id, p_path_old=>m_path, p_paramname=>'ONBOARDING_ALL_SERVICED_CORPORATES', p_paramvalue=>rec4.OnboardingAllServiced);

            IF rec4.CreditorSchemeId IS NOT NULL
            THEN
                m_mode := 'INSERT-UPDATE';
                mgmt_creditorschemeid (
                                         p_action               => m_mode,
                                         p_institution_id       => m_id,
                                         p_crscheme_id          => rec4.CreditorSchemeId,
                                         p_crscheme_name        => NULL,
                                         p_crscheme_addr1       => NULL,
                                         p_crscheme_addr2       => NULL,
                                         p_crscheme_addr3       => NULL,
                                         p_crscheme_addr4       => NULL,
                                         p_crscheme_status      => 'VALIDATED',
                                         p_crscheme_updatedby   => 'ADMIN1',
                                         p_crscheme_validatedby => 'ADMIN2'
                                       );
            END IF;

            FOR rec20 IN c20(rec4.IBANXML)
            LOOP
                DBMS_OUTPUT.put_line('IBAN  : ' || rec20.IBAN);

                IF LENGTH (rec20.IBAN) > 10
                THEN
                      m_account_number := SUBSTR(rec20.IBAN, -10, 10);
                    m_iban := rec20.IBAN;
                ELSE
                      m_account_number :=LPAD(LTRIM(TO_CHAR(rec20.IBAN)),10,'0');
                    m_iban := m_account_number;
                END IF;

                DBMS_OUTPUT.PUT_LINE ('Conversion p_account_string : ' || p_account_string);
                DBMS_OUTPUT.PUT_LINE ('Conversion m_account_number : ' || m_account_number);
                IF m_account_number IS NOT NULL --AND INSTR(NVL(p_account_string, 0), m_account_number) <=0
                THEN

                    m_mode := 'INSERT-UPDATE';
                    mgmt_account_master
                    (
                    p_action              => m_mode,
                    p_institution_id      => m_id,
                    p_customer_id         => m_account_number,
                    p_bank_code           => 'NOT-PROVIDED',
                    p_branch              => 'NOT-PROVIDED',
                    p_account_number      => m_account_number,
                    p_account_iban        => m_iban,
                    p_account_type        => NULL,
                    p_account_curr        => NULL,
                    p_credit_limit        => NULL,
                    p_account_desc        => NULL,
                    p_country_code        => m_countrycode,
                    p_account_status      => 'VALIDATED',
                    p_account_updatedby   => 'ADMIN1',
                    p_account_validatedby => 'ADMIN2',
                    p_crscheme_id          => rec4.CreditorSchemeId,
                    p_account_addl_property => 'X',
                    p_input_channel          => 'X',
                    p_account_title         => NULL,
                    p_account_id             => NULL,
                    p_bank_name             => NULL,
                    p_image_url             => NULL,
                    p_account_mode          => NULL,
                    p_acc_customer_id       => NULL,
                    p_AccountSchemeId       => NULL,
                    p_defaultaccount_flag   => NULL,
                    p_created_by            => NULL
                    );
                END IF;

                m_path := 'CONVERSION.ORDERING_AGREEMENT-'||m_seqno||'.ORDERING_ACCOUNTS';

                m_sepascheme := rec4.SEPAScheme;
                IF rec4.SEPAScheme IS NULL
                THEN
                     m_sepascheme := 'SCT';
                END IF;

                m_return_code := mgmt_institutionparameter(p_action=>'UPDATE',p_institutionid=>m_id, p_path_old=>m_path, p_paramname=>'IBAN', p_paramvalue=>'@' ||m_sepascheme||'-ORDERING_AGREEMENT-'||m_seqno);

                /*m_path := '@ORDERING_AGREEMENT-'||m_seqno;

                m_mode := 'INSERT-UPDATE';
                mgmt_institutionparameter_map
                (
                p_action              => m_mode,
                p_institutionid       => m_id,
                p_label                  => m_path,
                p_value                  => m_account_number,
                p_key                 => 'ACCOUNT_MASTER'
                ); */


                m_mode := 'INSERT-UPDATE';
                mgmt_institutionparameter_map
                (
                p_action              => m_mode,
                p_institutionid       => m_id,
                p_label                  => '@'||m_sepascheme||'-ORDERING_AGREEMENT-'||m_seqno,
                p_value                  => m_account_number,
                p_key                 => 'ACCOUNT_MASTER',
                p_data_keyid_list  => p_data_keyid_list
                );

                m_mode := 'INSERT-UPDATE';
                mgmt_institutionparameter_map
                (
                p_action              => m_mode,
                p_institutionid       => m_id,
                p_label                  => '@'||m_sepascheme||'-ORDERING_AGREEMENT-'||m_seqno,
                p_value                  => m_iban,
                p_key                 => 'ACCOUNT_MASTER.ACCOUNT_IBAN',
                p_data_keyid_list  => p_data_keyid_list
                );

            END LOOP;
            ctr := ctr + 1;
        END LOOP;

        DBMS_OUTPUT.put_line('Accounts Per Channel START');
        DBMS_OUTPUT.put_line('-----------------------------------------------');

        ctr := 1;
        m_xpath := '/ProductConfiguration/Customer/Conversion/AccountInformation/AccountsPerChannel';
        FOR rec6 IN c6(m_xpath)
        LOOP
            DBMS_OUTPUT.put_line('Count : ' || ctr);
            DBMS_OUTPUT.put_line('OutputChannel : ' || rec6.OutputChannel);
            DBMS_OUTPUT.put_line('AccountNumber : ' || rec6.AccountNumber);
            DBMS_OUTPUT.put_line('IBAN          : ' || rec6.IBAN);
            DBMS_OUTPUT.put_line('AgentBIC      : ' || rec6.AgentBIC);
            --DBMS_OUTPUT.put_line('CreditorName  : ' || rec6.CreditorName);
            DBMS_OUTPUT.put_line('CorporateName : ' || rec6.CorporateName);

            IF ctr = 1
            THEN
                OPEN c10(m_id);
                FETCH c10 BULK COLLECT INTO t_accperchan;
                IF t_accperchan.FIRST > 0
                 THEN
                    FORALL acc_accperchan IN t_accperchan.FIRST..t_accperchan.LAST
                    DELETE FROM    institutionparameters
                    WHERE  institutionid    = t_accperchan(acc_accperchan).institutionid
                    AND    paramname        = t_accperchan(acc_accperchan).paramname
                    AND    path             = t_accperchan(acc_accperchan).path;
                END IF;
                CLOSE c10;

                DELETE FROM institutionparameters_map
                WHERE institutionid =  m_id
                AND label LIKE '@ACCOUNTS_PER_CHANNEL-%';

                DELETE FROM institutionparameters_map
                WHERE institutionid =  m_id
                AND label LIKE '%-CONVERSION';

                DELETE FROM institutionparameters
                WHERE institutionid =  m_id
                AND PATH = 'CONVERSION.ACCOUNT_INFORMATION.ACCOUNTS_PER_CHANNEL-[nn]';

            END IF;

            --m_seqno := TO_NUMBER(LPAD(LTRIM(TO_CHAR(ctr)),4,'0'));
              SELECT LENGTH (TO_CHAR(ctr)) INTO m_ctr from dual;
              IF m_ctr <= 1
              THEN
                 m_seqno := LPAD(LTRIM(TO_CHAR(ctr)),2,'0');
              ELSE
                m_seqno := TO_NUMBER(LPAD(LTRIM(TO_CHAR(ctr)),4,'0'));
              END IF;

            m_path  := 'CONVERSION.ACCOUNT_INFORMATION.ACCOUNTS_PER_CHANNEL-' || m_seqno;

                OPEN c10(p_cinstitutionid);
                FETCH c10 BULK COLLECT INTO t_institutionparameters;
                IF t_institutionparameters.FIRST > 0
                THEN
                    FOR i IN t_institutionparameters.FIRST..t_institutionparameters.LAST
                    LOOP
                        t_institutionparameters(i).institutionid := m_id;
                        t_institutionparameters(i).path          := 'CONVERSION.ACCOUNT_INFORMATION.ACCOUNTS_PER_CHANNEL-'||m_seqno;
                        t_institutionparameters(i).sequenceno    := t_institutionparameters(i).sequenceno||'.'||m_seqno;
                    END LOOP;
                    FORALL i IN t_institutionparameters.FIRST..t_institutionparameters.LAST
                    INSERT INTO institutionparameters VALUES t_institutionparameters(i);
                END IF;
                CLOSE c10;


               m_return_code := mgmt_institutionparameter(p_action=>'UPDATE',p_institutionid=>m_id, p_path_old=>m_path, p_paramname=>'OUTPUT_CHANNEL', p_paramvalue=>rec6.OutputChannel);
               m_return_code := mgmt_institutionparameter(p_action=>'UPDATE',p_institutionid=>m_id, p_path_old=>m_path, p_paramname=>'IBAN', p_paramvalue=>'@ACCOUNTS_PER_CHANNEL-'||m_seqno);
               m_return_code := mgmt_institutionparameter(p_action=>'UPDATE',p_institutionid=>m_id, p_path_old=>m_path, p_paramname=>'AGENT_BIC', p_paramvalue=>rec6.AgentBIC);
               m_return_code := mgmt_institutionparameter(p_action=>'UPDATE',p_institutionid=>m_id, p_path_old=>m_path, p_paramname=>'CORPORATE_NAME', p_paramvalue=>rec6.CorporateName);

                IF LENGTH (rec6.IBAN) > 10
                THEN
                      m_account_number := SUBSTR(rec6.IBAN, -10, 10);
                    m_iban := rec6.IBAN;
                ELSE
                      m_account_number :=LPAD(LTRIM(TO_CHAR(rec6.IBAN)),10,'0');
                    m_iban := m_account_number;
                END IF;

                m_return_code := mgmt_institutionparameter(p_action=>'UPDATE',p_institutionid=>m_id, p_path_old=>m_path, p_paramname=>'ACCOUNT_NUMBER', p_paramvalue=>m_account_number);

                m_path := '@ACCOUNTS_PER_CHANNEL-'||m_seqno;

                DBMS_OUTPUT.PUT_LINE ('Accounts p_account_string : ' || p_account_string);
                DBMS_OUTPUT.PUT_LINE ('Accounts m_account_number : ' || m_account_number);
                IF m_account_number IS NOT NULL --AND INSTR(NVL(p_account_string, 0), m_account_number) <=0
                THEN
                    DBMS_OUTPUT.PUT_LINE ('Inside transaction delivery loop');
                m_mode := 'INSERT-UPDATE';
                mgmt_account_master
                (
                p_action              => m_mode,
                p_institution_id      => m_id,
                p_customer_id         => m_account_number,
                p_bank_code           => 'NOT-PROVIDED',
                p_branch              => 'NOT-PROVIDED',
                p_account_number      => m_account_number,
                p_account_iban        => m_iban,
                p_account_type        => NULL,
                p_account_curr        => NULL,
                p_credit_limit        => NULL,
                p_account_desc        => NULL,
                p_country_code        => m_countrycode,
                p_account_status      => 'VALIDATED',
                p_account_updatedby   => 'ADMIN1',
                p_account_validatedby => 'ADMIN2',
                p_crscheme_id         => NULL,
                p_account_addl_property => 'X',
                p_input_channel          => 'X',
                p_account_title         => NULL,
                p_Account_id             => NULL,
                p_bank_name             => NULL,
                p_image_url             => NULL,
                p_account_mode          => NULL,
                p_acc_customer_id       => NULL,
                p_AccountSchemeId       => NULL,
                p_defaultaccount_flag   => NULL,
                p_created_by            => NULL
                );
                END IF;

                m_mode := 'INSERT-UPDATE';
                mgmt_institutionparameter_map
                (
                p_action              => m_mode,
                p_institutionid       => m_id,
                p_label                  => m_path,
                p_value                  => m_account_number,
                p_key                 => 'ACCOUNT_MASTER',
                p_data_keyid_list  => p_data_keyid_list
                );

                m_mode := 'INSERT-UPDATE';
                mgmt_institutionparameter_map
                (
                p_action              => m_mode,
                p_institutionid       => m_id,
                p_label                  => m_path,
                p_value                  => m_iban,
                p_key                 => 'ACCOUNT_MASTER.ACCOUNT_IBAN',
                p_data_keyid_list  => p_data_keyid_list
                );

                m_mode := 'INSERT-UPDATE';
                mgmt_institutionparameter_map
                (
                p_action              => m_mode,
                p_institutionid       => m_id,
                p_label                  => m_parent_id||'-'||m_CustomerType ||'-CONVERSION',
                p_value                  => m_account_number,
                p_key                 => 'CUSTOMER-TYPE',
                p_data_keyid_list  => p_data_keyid_list
                );

            ctr := ctr + 1;
        END LOOP;

        ctr := 0;
        m_result := NULL;
        m_xpath := '/ProductConfiguration/Customer/Conversion/AccountInformation/OutputChannel_SA';
        FOR rec11 IN c11(m_xpath)
        LOOP
            ctr := ctr + 1;
            DBMS_OUTPUT.put_line('Count : ' || ctr);
            DBMS_OUTPUT.put_line('OutputChannel_SA : ' || rec11.OutputChannel_SA);

            m_temp := rec11.OutputChannel_SA;
            IF m_temp = rec11.OutputChannel_SA
            THEN
                m_result := m_temp||'|'||m_result;
            END IF;
        END LOOP;

        SELECT     SUBSTR(m_result,1,(length(m_result))-1)
        INTO     m_result
        from     dual;
        DBMS_OUTPUT.put_line('OutputChannel_SA '||m_result);

        m_return_code := mgmt_institutionparameter(p_action=>'UPDATE',p_institutionid=>m_id, p_path_old=>'CONVERSION.ACCOUNT_INFORMATION', p_paramname=>'OUTPUT_CHANNEL_SA', p_paramvalue=>m_result);

        UPDATE  institutionparameters
        SET     record_type       = NULL
        WHERE   record_type       = 'T'
        AND     institutionid     = m_id;

        IF m_CustomerType = 'SERVICED_CORPORATE'
        THEN
            -- Start - MJ: If InvoicePay service (YES/NO) or any other service subscription is YES or then execute below 21-03-2017
            IF m_del_updt_usr_det = 1
            THEN
                DELETE FROM PROFILEAPPLICATIONINSTANCE WHERE INSTITUTIONID = m_id AND PROFILEID IN ('FNC_UPLD','FNC_DNLD');
                DELETE FROM PROFILEATTRIBUTE WHERE INSTITUTIONID = m_id AND PROFILEID IN ('FNC_UPLD','FNC_DNLD');
                DELETE FROM PROFILEQUEUE WHERE INSTITUTIONID = m_id AND PROFILEID IN ('FNC_UPLD','FNC_DNLD');
                DELETE FROM UPROFILE WHERE INSTITUTIONID = m_id AND PROFILEID IN ('FNC_UPLD','FNC_DNLD');
    --            COMMIT;
            END IF;
            -- End - MJ: If InvoicePay service (YES/NO) or any other service subscription is YES or then execute below 21-03-2017

            mi_add_profiles_no_workgroup(p_cinstitutionid,m_id,NULL,NULL,m_error_code,m_erroratlevel,m_return_value,'FNC_UPLD');
            mi_add_profiles_no_workgroup(p_cinstitutionid,m_id,NULL,NULL,m_error_code,m_erroratlevel,m_return_value,'FNC_DNLD');

            DELETE FROM INSTITUTIONPARAMETERS WHERE INSTITUTIONID = m_id AND PARAMNAME = 'ROLE_OF_USER' AND PARAMVALUE = 'DOWNLOAD' AND PATH = 'TRANSACTION_DELIVERY.GRANTACCESS_TO_SERVICE_AGENT-LIMIT.Role-21';
            Insert into INSTITUTIONPARAMETERS (INSTITUTIONID, PARENTGROUPID, CHILDGROUPID, PARAMNAME, PARAMVALUE, PARAMDATATYPE, PARAMVALUELENGTH, VALIDATION, USERID, STATUS, MODIFIEDVALUE, PATH, POSSIBLEPARAMTYPE, NONCONCSTATUS, RECORD_TYPE, PRODUCT_FLAVOR, SEQUENCENO) Values (m_id,NULL, NULL, 'ROLE_OF_USER', 'DOWNLOAD', NULL, NULL, NULL, 'ADMIN1', 'V', NULL, 'TRANSACTION_DELIVERY.GRANTACCESS_TO_SERVICE_AGENT-LIMIT.Role-21', NULL, NULL, NULL, 'PCOR', '4.6.0.0.0.21');

            DELETE FROM INSTITUTIONPARAMETERS_MAP WHERE INSTITUTIONID = m_id AND LABEL = '@TA-GRANTACCESSTOSERVICEAGENTDOWNLOAD-Role-21' AND VALUE = encrypt_decrypt_basedon_session_cntx('ENCRYPT',m_id,'DOWNLOAD') AND KEY = 'GRANTROLE';
            Insert into INSTITUTIONPARAMETERS_MAP (INSTITUTIONID, LABEL, VALUE, KEY ,DATAKEYID) Values (m_id,'@TA-GRANTACCESSTOSERVICEAGENTDOWNLOAD-Role-21', encrypt_decrypt_basedon_session_cntx('ENCRYPT',m_id,'DOWNLOAD'),'GRANTROLE', p_data_keyid_list);
        END IF;


        m_function := pelicanpay_transaction_onboard(p_onboard_info, p_account_string, m_id, m_parent_id,p_data_keyid_list);
         --m_function := pelicanpay_transaction_onboard(p_onboard_info, p_account_string);

        IF m_function <> 0
        THEN
            m_return_number  := 6.1;
            m_exception_desc := 'TA Onboarding failed';
            RAISE ONBOARDING_EXCEPTION;
        END IF;

        DBMS_OUTPUT.put_line('----------------------------');
        DBMS_OUTPUT.put_line('Billing Service service');
        DBMS_OUTPUT.put_line('----------------------------');

        m_function := ob_Billing_service(p_onboard_info,m_id);
        IF m_function <> 0
        THEN
            m_return_number  := 6.5;
            m_exception_desc := 'Billing onboarding failed';
            DBMS_OUTPUT.put_line('Billing onboarding failed');
        END IF;


        DBMS_OUTPUT.put_line('----------------------------');
        DBMS_OUTPUT.put_line('Emandate service information');
        DBMS_OUTPUT.put_line('----------------------------');

        m_function := ob_emandate_service(p_onboard_info,m_id);
        IF m_function <> 0
        THEN
            m_return_number  := 6.2;
            m_exception_desc := 'Emandate onboarding failed';
            DBMS_OUTPUT.put_line('Emandate onboarding failed');
        END IF;

        DBMS_OUTPUT.put_line('----------------------------------------');
        DBMS_OUTPUT.put_line('Invoice pay solution service information');
        DBMS_OUTPUT.put_line('----------------------------------------');

        m_function := ob_invoicepay_service(p_onboard_info,m_id,p_data_keyid_list);
        IF m_function <> 0
        THEN
            m_return_number  := 6.3;
            m_exception_desc := 'Invoice pay service onboarding failed';
            DBMS_OUTPUT.put_line('Invoice pay service onboarding failed');
        END IF;

        m_function := ob_user_service(p_onboard_info);
        IF m_function <> 0
        THEN
            m_return_number  := 6.4;
            m_exception_desc := 'User service onboarding failed';
            DBMS_OUTPUT.put_line('User service onboarding failed');
        END IF;


        DBMS_OUTPUT.put_line('----------------------------');
        DBMS_OUTPUT.put_line('Merchant Pay Service information');
        DBMS_OUTPUT.put_line('----------------------------');

        m_function := ob_merchant_service(p_onboard_info,m_id);
        IF m_function <> 0
        THEN
            m_return_number  := 6.2;
            m_exception_desc := 'MerchantService onboarding failed';
            DBMS_OUTPUT.put_line('MerchantService onboarding failed');
        END IF;
        
        DBMS_OUTPUT.put_line('----------------------------');
        DBMS_OUTPUT.put_line('Wallet funding Service information');
        DBMS_OUTPUT.put_line('----------------------------');
        
        m_function := OB_WALLET_FUNDING_SERVICE(p_onboard_info,m_id);
        IF m_function <> 0
        THEN
            m_return_number  := 6.2;
            m_exception_desc := 'walletfunding_service onboarding failed';
            DBMS_OUTPUT.put_line('walletfunding_service onboarding failed');
        END IF;

        DBMS_OUTPUT.put_line('----------------------------');
        DBMS_OUTPUT.put_line('Payment Request Service information');
        DBMS_OUTPUT.put_line('----------------------------');

        m_function := ob_payment_request_service(p_onboard_info,m_id);
        IF m_function <> 0
        THEN
            m_return_number  := 6.2;
            m_exception_desc := 'PaymentRequestService onboarding failed';
            DBMS_OUTPUT.put_line('PaymentRequestService onboarding failed');
        END IF;

        DBMS_OUTPUT.put_line('----------------------------');
        DBMS_OUTPUT.put_line('Account Access Service information');
        DBMS_OUTPUT.put_line('----------------------------');

        m_function := ob_account_access_service(p_onboard_info,m_id);
        IF m_function <> 0
        THEN
            m_return_number  := 6.2;
            m_exception_desc := 'AccountAccessService onboarding failed';
            DBMS_OUTPUT.put_line('AccountAccessService onboarding failed');
        END IF;
        
        DBMS_OUTPUT.put_line('----------------------------');
        DBMS_OUTPUT.put_line('Account Holder Service information');
        DBMS_OUTPUT.put_line('----------------------------');

        m_function := ob_account_holder_service(p_onboard_info,m_id);
        IF m_function <> 0
        THEN
            m_return_number  := 6.2;
            m_exception_desc := 'AccountHolderService onboarding failed';
            DBMS_OUTPUT.put_line('AccountHolderService onboarding failed');
        END IF;
        DBMS_OUTPUT.put_line('----------------------------');
        DBMS_OUTPUT.put_line('DynamicTheme Service information');
        DBMS_OUTPUT.put_line('----------------------------');

        m_function := ob_DynamicTheme_Service(p_onboard_info,m_id);
        IF m_function <> 0
        THEN
            m_return_number  := 6.2;
            m_exception_desc := 'DynamicThemeService onboarding failed';
            DBMS_OUTPUT.put_line('DynamicThemeService onboarding failed');
        END IF;

        DBMS_OUTPUT.put_line('----------------------------');
        DBMS_OUTPUT.put_line('Compliance Service information');
        DBMS_OUTPUT.put_line('----------------------------');

        m_function := ob_compliance_Service(p_onboard_info,m_id);
        IF m_function <> 0
        THEN
            m_return_number  := 6.2;
            m_exception_desc := 'Compliance Service onboarding failed';
            DBMS_OUTPUT.put_line('Compliance Service onboarding failed');
        END IF;

        DBMS_OUTPUT.put_line('----------------------------');
        DBMS_OUTPUT.put_line('Income Verification Service information');
        DBMS_OUTPUT.put_line('----------------------------');

        m_function := ob_Income_Verification_service(p_onboard_info,m_id);
        IF m_function <> 0
        THEN
            m_return_number  := 6.2;
            m_exception_desc := 'IncomeVerificationService onboarding failed';
            DBMS_OUTPUT.put_line('IncomeVerificationService onboarding failed');
        END IF;

        DBMS_OUTPUT.put_line('----------------------------');
        DBMS_OUTPUT.put_line('Affordability Verification Service information');
        DBMS_OUTPUT.put_line('----------------------------');

        m_function := ob_Affordability_Verification_Service(p_onboard_info,m_id);
        IF m_function <> 0
        THEN
            m_return_number  := 6.2;
            m_exception_desc := 'AffordabilityVerificationService onboarding failed';
            DBMS_OUTPUT.put_line('AffordabilityVerificationService onboarding failed');
        END IF;
        
        m_function := ob_payment_initiation_sevice(p_onboard_info,m_id);
        IF m_function <> 0
        THEN
            m_return_number  := 6.2;
            m_exception_desc := 'Payment_Initiation_SERVICE onboarding failed';
            DBMS_OUTPUT.put_line('Payment_Initiation_SERVICE onboarding failed');
        END IF;
        
        m_function := ob_income_expense_analysis_sevice(p_onboard_info,m_id);
        IF m_function <> 0
        THEN
            m_return_number  := 6.2;
            m_exception_desc := 'Income_Expense_Analysis_SERVICE onboarding failed';
            DBMS_OUTPUT.put_line('Income_Expense_Analysis_SERVICE onboarding failed');
        END IF;
        
--        m_function := ob_KYC_Service(p_onboard_info,m_id);
--        IF m_function <> 0
--        THEN
--            m_return_number  := 6.2;
--            m_exception_desc := 'ob_kyc_service onboarding failed';
--            DBMS_OUTPUT.put_line('ob_kyc_service onboarding failed');
--        END IF;

 
        m_function := ob_Account_Aggregation_Service(p_onboard_info,m_id);
        IF m_function <> 0
        THEN
            m_return_number  := 6.2;
            m_exception_desc := 'AccountAggregationService onboarding failed';
            DBMS_OUTPUT.put_line('AccountAggregationService onboarding failed');
        END IF;
        
        
        FOR i in (
					select distinct userid, profileid from userprofile
					where CHILD_INSTITUTIONID='ALL' AND institutionid=m_parent_id
					)
		LOOP
            		mi_add_user_insti_attrib_access(m_id,i.profileid,i.userid,'INSERT-UPDATE',NULL);
		END LOOP;

        m_return_number  := m_function;

        Genaudit_Insert_Enchash_Wrap
        (
        p_messageno=>g_messageno,
        p_queueid=>g_queueid,
        p_username=>NULL,
        p_application=>'PELICAN',
        p_modulename=>'ONBOARDING',
        p_action=>'IMPORT',
        p_audittext=>'Customer ==> '|| m_id || ' successfully onboarded.',
        p_institutionid=>m_institutionid,
        p_incr_count=>0
        );

    SELECT COUNT(*) INTO m_count_tenant_roles
    FROM TABLEDETAILS
    WHERE TDIDCODE = m_tenantname||'_ROLES';

    IF m_count_tenant_roles > 0
    THEN

        DELETE FROM UPROFILE
        WHERE institutionid = m_id
        AND PROFILEID NOT IN (SELECT TDVALUE FROM TABLEDETAILS WHERE TDIDCODE = m_tenantname||'_ROLES');

    END IF;

        COMMIT;

        DBMS_OUTPUT.put_line('Level 10');

        RETURN 0;
    EXCEPTION
           WHEN NO_DATA_FOUND THEN
            ROLLBACK;
            DBMS_OUTPUT.put_line('Invalid XML File provided ! : ' || SQLERRM);
            RETURN 1;

        WHEN INVALID_ACCESS_CONTROL
        THEN
            ROLLBACK;
            DBMS_OUTPUT.put_line('Invalid stage authentication principle.');
            RETURN 1;
        WHEN INVALID_INST_ACCESS_CTRL
        THEN
            ROLLBACK;
            DBMS_OUTPUT.put_line('Invalid institution access control.');
            RETURN 1;
        WHEN INVALID_PRODUCTID
        THEN
            ROLLBACK;
            DBMS_OUTPUT.put_line('Invalid ProductId.');
            RETURN 1;
        WHEN INVALID_STAGENAME
        THEN
            ROLLBACK;
            DBMS_OUTPUT.put_line('Invalid Stage Name.');
            RETURN 1;

        WHEN CUSTOMER_INACTIVE_STATUS
        THEN
            DELETE    FROM institutionparameters_map
            WHERE    institutionid  = m_id;

            UPDATE    account_master
            SET        account_status = 'DELETED'
            WHERE    institution_id = m_id;

            UPDATE    institutionparameters
            SET        paramvalue        = 'NO'
            WHERE    institutionid     = m_id
            AND     paramname        = 'SERVICE_SUBSCRIBED'
            AND     path    IN ('CONVERSION','REPORTING','TRANSACTION_DELIVERY');

            UPDATE    institutionparameters
            SET        paramvalue        = 'NO'
            WHERE    institutionid    = m_id
            AND     paramname        = 'SUBSCRIPTION'
            AND     path            = 'SERVICES.Dutch eMandate Service';

            UPDATE    institutionparameters
            SET        paramvalue        = NULL
            WHERE    institutionid    = m_id
            AND     paramname        = 'EQUENS_ID';

            UPDATE    institutionparameters
            SET        paramvalue        = 'INACTIVE'
            WHERE    institutionid    = m_id
            AND     paramname        = 'STATUS_CUSTOMER';

            -- Start - MJ: If InvoicePay service (YES/NO) or any other service subscription is YES or then execute below 21-03-2017
            IF m_del_updt_usr_det = 1
            THEN
                -- To disable the user in uuser table
                UPDATE  uuser
                SET     status            = 'D'
                WHERE   institutionid    = m_id;

                -- Even if disable the user in uuser table we are able to login in SSO
                -- so all records from userprofile must be deleted
                DELETE    FROM userprofile
                WHERE    institutionid  = m_id;
            END IF;
            -- End - MJ: If InvoicePay service (YES/NO) or any other service subscription is YES or then execute below 21-03-2017

            Genaudit_Insert_Enchash_Wrap
            (
            p_messageno=>g_messageno,
            p_queueid=>g_queueid,
            p_username=>NULL,
            p_application=>'PELICAN',
            p_modulename=>'ONBOARDING',
            p_action=>'IMPORT',
            p_audittext=>'Customer ==> '|| m_id || ' successfully offboarded.',
            p_institutionid=>m_institutionid,
            p_incr_count=>0
            );

            COMMIT;
            RETURN 0;
        WHEN ONBOARDING_EXCEPTION
        THEN
            ROLLBACK;
            genaudit_insert_enchash_wrap
            (
            p_messageno=>g_messageno,
            p_queueid=>g_queueid,
            p_username=>NULL,
            p_application=>'PELICAN',
            p_modulename=>'ONBOARDING',
            p_action=>'IMPORT',
            p_audittext=>m_exception_desc,
            p_institutionid=>m_institutionid,
            p_incr_count=>0
            );
            genaudit_insert_enchash_wrap
            (
            p_messageno=>g_messageno,
            p_queueid=>g_queueid,
            p_username=>NULL,
            p_application=>'PELICAN',
            p_modulename=>'ONBOARDING',
            p_action=>'IMPORT',
            p_audittext=>'Customer ==> '|| m_id || ' issues encountered while onboarding. Onboarding Failed',
            p_institutionid=>m_institutionid,
            p_incr_count=>0
            );
            COMMIT;
            RETURN m_return_number;
    END;
/
-- [8.1.90.7] [20221109] [PTRAMBAKE] [END]
EXIT;