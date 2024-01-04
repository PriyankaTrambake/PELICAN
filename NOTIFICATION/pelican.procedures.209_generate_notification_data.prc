-- [9.06.00.006.10] [20230915] [ASARAF] [START]
SET DEFINE OFF;
create or replace PROCEDURE        generate_notification_data
(   p_clob  				IN CLOB,
    p_notification_type 	IN USER_NOTIFICATION_TYPE.notification_type%TYPE,
    p_notification_mode 	IN user_notification_mode.notification_mode%TYPE,
    p_record_group_type 	IN MSGDB.record_group_type%TYPE,
    p_transactiongroup  	IN MSGDB.transactiongroup%TYPE,
    p_currency          	IN CURRENCYINFO.symbol%TYPE,
    p_processing_stage  	IN MSGDB.processing_stage%TYPE,
    p_language_id   		IN PREFERENCES.languageid%TYPE,
    p_no_of_messages 		IN NUMBER,
    p_total_amount             IN VARCHAR2,
    p_companyname              IN INSTITUTION_ORGANIZATION_INFO.est_statutory_name%TYPE,
    p_append_str    		IN CLOB,
    p_subject 				IN OUT CLOB,
    p_result 				IN OUT CLOB,
    p_payment_day 			IN VARCHAR2,
    p_benefname 			IN MSGDB.benefname%TYPE,
    p_profile               IN VARCHAR2 DEFAULT NULL
)
AS
    m_less_tag              VARCHAR2(1000)						:= NULL;
    m_greater_tag           VARCHAR2(1000)                      := NULL;
    m_stagename             VARCHAR2(100)         := NULL;
    m_subject               VARCHAR2(1000)                      := NULL;
    m_clob                  CLOB                                := NULL;
    m_result                CLOB                                := NULL;
    m_no_of_messages        NUMBER                              := 0;
    m_benefname             VARCHAR2(1000)                      := NULL;
    m_payment_day           VARCHAR2(1000)                      := NULL;
    m_companyname             INSTITUTION_ORGANIZATION_INFO.est_statutory_name%TYPE    := NULL;

    m_language_id           PREFERENCES.languageid%TYPE         := NULL;
    m_total_amount          VARCHAR2(50)                        := 0;
    m_notification_type         USER_NOTIFICATION_TYPE.notification_type%TYPE       := NULL;
    m_processing_stage      MSGDB.processing_stage%TYPE         := NULL;

BEGIN
    m_clob 		:= p_clob;
    m_subject 	:= p_subject;
    m_result 	:= p_result;
    m_processing_stage := p_processing_Stage;

    m_language_id       := p_language_id;
    m_no_of_messages    := p_no_of_messages;
    m_total_amount      := p_total_amount;
    m_payment_day       := p_payment_day;
    m_benefname         := p_benefname;
    m_companyname := p_companyname;

    IF m_notification_type NOT IN ('ONDUEDATE', 'PREDUEDATE')
    THEN
        SELECT *
        INTO m_notification_type
        FROM TABLE (GET_CODE_FROM_LIST(TD_GET_VALUE('NOTIFICATION', 'ONARRIVAL'), '|'))
        WHERE PARA_CODE = p_notification_type;
    ELSE
         m_notification_type := NULL;
    END IF;

    IF  INSTR(TD_GET_VALUE('NOTIFICATION','ROLE_BASED_NOTI'),p_notification_type) > 0
    THEN
        m_processing_stage := getstringitemwithsep(NVL(TD_GET_VALUE('NOTIFICATION',p_profile),'X'),'1','|');
    END IF;



    IF p_notification_mode != 'EMAIL'
    THEN
        m_less_tag := '<';
        m_greater_tag := '>';
    ELSIF  p_notification_mode = 'EMAIL'
    THEN
        m_less_tag := '&lt;';
        m_greater_tag := '&gt;';
    END IF;

    IF p_record_group_type = 'B'
    THEN
        IF m_notification_type IS NOT NULL
        THEN
            IF m_language_id = 'EN'
            THEN
                m_clob    :=    REPLACE(m_clob, m_less_tag || 'Number of Payments/Transactions' || m_greater_tag || ' ' || m_less_tag || 'Payment Type' || m_greater_tag || ' Payments amounting to ' || m_less_tag || 'currency' || m_greater_tag || ' ' || m_less_tag || 'amount' || m_greater_tag || ' are ',CASE m_no_of_messages WHEN '1' THEN 'A ' || m_less_tag || 'Payment Type' || m_greater_tag || ' Payments of ' || m_less_tag || 'currency' || m_greater_tag || ' ' || m_less_tag || 'amount' || m_greater_tag || ' is ' ELSE m_less_tag || 'Number of Payments/Transactions' || m_greater_tag || ' ' || m_less_tag || 'Payment Type' || m_greater_tag || ' Payments amounting to ' || m_less_tag || 'currency' || m_greater_tag || ' ' || m_less_tag || 'amount' || m_greater_tag || ' are ' END);
            ELSE
                m_clob    :=   REPLACE(m_clob, m_less_tag || 'Number of Payments/Transactions' || m_greater_tag || ' ' || m_less_tag || 'Payment Type' || m_greater_tag || ' Betalingen ',CASE m_no_of_messages WHEN '1' THEN 'Een '||m_less_tag || 'Payment Type' || m_greater_tag || ' ' ELSE m_less_tag || 'Number of Payments/Transactions' || m_greater_tag || ' ' || m_less_tag || 'Payment Type' || m_greater_tag || ' Betalingen ' END);
            END IF;
        END IF;
    ELSIF p_record_group_type = 'M'
    THEN
        IF m_notification_type IS NOT NULL
        THEN
            IF m_language_id = 'EN'
            THEN
                m_clob    :=    REPLACE(m_clob, m_less_tag || 'Number of Payments/Transactions' || m_greater_tag || ' ' || m_less_tag || 'Payment Type' || m_greater_tag || ' Payments amounting to ' || m_less_tag || 'currency' || m_greater_tag || ' ' || m_less_tag || 'amount' || m_greater_tag || ' are ',CASE m_no_of_messages WHEN '1' THEN 'An Invoice Payment of ' || m_less_tag || 'currency' || m_greater_tag || ' ' || m_less_tag || 'amount' || m_greater_tag || ' is ' ELSE m_less_tag || 'Number of Payments/Transactions' || m_greater_tag || ' Invoice Payments amounting to ' || m_less_tag || 'currency' || m_greater_tag || ' ' || m_less_tag || 'amount' || m_greater_tag || ' are ' END);
                m_clob    :=    REPLACE(m_clob, m_less_tag || 'Number of Payments/Transactions' || m_greater_tag || ' ' || m_less_tag || 'Payment Type' || m_greater_tag || ' Payments amounting to ' || m_less_tag || 'currency' || m_greater_tag || ' ' || m_less_tag || 'amount' || m_greater_tag || ' are ',CASE m_no_of_messages WHEN '1' THEN 'An Invoice Payment of ' || m_less_tag || 'currency' || m_greater_tag || ' ' || m_less_tag || 'amount' || m_greater_tag || ' is ' ELSE m_less_tag || 'Number of Payments/Transactions' || m_greater_tag || ' Invoice Payments amounting to ' || m_less_tag || 'currency' || m_greater_tag || ' ' || m_less_tag || 'amount' || m_greater_tag || ' are ' END);
                m_subject :=    REPLACE(m_subject, '<Number of Payments/Transactions> payments ', CASE m_no_of_messages WHEN '1' THEN '<Number of Payments/Transactions> payment ' ELSE '<Number of Payments/Transactions> payments ' END);
            ELSE
                m_clob    :=   REPLACE(m_clob, m_less_tag || 'Number of Payments/Transactions' || m_greater_tag || ' ' || m_less_tag || 'Payment Type' || m_greater_tag || ' Betalingen ',CASE m_no_of_messages WHEN '1' THEN 'Een '||m_less_tag || 'Payment Type' || m_greater_tag || ' ' ELSE m_less_tag || 'Number of Payments/Transactions' || m_greater_tag || ' ' || m_less_tag || 'Payment Type' || m_greater_tag || ' Betalingen ' END);
            END IF;
        END IF;
    ELSIF p_record_group_type = 'F'
    THEN
        IF m_language_id = 'EN'
        THEN
            m_clob    := REPLACE(m_clob, m_less_tag || 'Payment Type' || m_greater_tag || ' Payments amounting to ' || m_less_tag || 'currency' || m_greater_tag || ' ' || m_less_tag || 'amount' || m_greater_tag,' Files');
        ELSE
            m_clob     := REPLACE(m_clob, m_less_tag || 'Payment Type' || m_greater_tag || ' Betalingen voor een bedrag van ' || m_less_tag || 'currency' || m_greater_tag || ' ' || m_less_tag || 'amount' || m_greater_tag || ' wachten op uw goedkeuring in de ',' Bestanden wachten op uw akkoord in de ');
        END IF;
    END IF;

    BEGIN
        SELECT  INITCAP(DESCRIPTION)
        INTO    m_stagename
        FROM    messagestage
        WHERE   stage = m_processing_stage;
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            IF  INSTR(TD_GET_VALUE('NOTIFICATION','ROLE_BASED_NOTI'),p_notification_type) > 0
            THEN
                m_stagename := getstringitemwithsep(NVL(TD_GET_VALUE('NOTIFICATION',p_profile),'X'),'2','|');
            ELSE
                m_stagename := m_processing_stage;
            END IF;
    END;

    IF m_language_id = 'NL'
    THEN
        select rtrim(to_char(m_total_amount, 'FM9G999G999G999G999G999G999D99', 'NLS_NUMERIC_CHARACTERS='',.'''),',') into m_total_amount from dual;
        IF INSTR(m_total_amount, ',') > 0
        THEN
            IF INSTR(m_total_amount, ',') = 1
            THEN
                m_total_amount := '0' || m_total_amount;
            --ELSE
            END IF;

            m_total_amount := SUBSTR(m_total_amount,1, INSTR(m_total_amount,',') - 1) || ',' || RPAD(NVL(SUBSTR(m_total_amount, INSTR(m_total_amount,',') + 1),'0'),2,'0');
        ELSIF   INSTR(m_total_amount, ',')  <= 0
        THEN
             m_total_amount := m_total_amount || ',' || '00';
        END IF;

    ELSE
        select rtrim(to_char(m_total_amount, 'FM9G999G999G999G999G999G999D99', 'NLS_NUMERIC_CHARACTERS=''.,'''),'.') into m_total_amount from dual;
        IF INSTR(m_total_amount, '.') > 0
        THEN
            IF INSTR(m_total_amount, '.') = 1
            THEN
                m_total_amount := '0' || m_total_amount;
            --ELSE
            END IF;
            m_total_amount := SUBSTR(m_total_amount,1, INSTR(m_total_amount,'.') - 1)  || '.' || RPAD(NVL(SUBSTR(m_total_amount, INSTR(m_total_amount,'.') + 1),'0'),2,'0');

        ELSIF   INSTR(m_total_amount, '.')  <= 0
        THEN
             m_total_amount := m_total_amount || '.' || '00';
        END IF;
    END IF;

    m_clob := REPLACE(m_clob, m_less_tag || 'currency' || m_greater_tag ,TRIM(p_currency));
    m_clob := REPLACE(m_clob, m_less_tag || 'amount' || m_greater_tag ,m_total_amount);
    m_clob := REPLACE(m_clob, m_less_tag || 'Number of Payments/Transactions' || m_greater_tag ,m_no_of_messages);
    m_subject := REPLACE(m_subject, '<Number of Payments/Transactions>',m_no_of_messages);
    m_subject := REPLACE(m_subject, m_less_tag || 'currency' || m_greater_tag ,TRIM(p_currency));
    m_subject := REPLACE(m_subject, m_less_tag || 'amount' || m_greater_tag ,m_total_amount);
    m_clob := REPLACE(m_clob, m_less_tag || 'day/date' || m_greater_tag ,m_payment_day);
    m_clob := REPLACE(m_clob, m_less_tag || 'Beneficiary name' || m_greater_tag ,m_benefname);
    m_clob := REPLACE(m_clob, m_less_tag || 'CompanyName ChildInstitution' || m_greater_tag ,m_companyname);
    
   -- DBMS_OUTPUT.PUT_LINE('m_language_id: '||m_language_id);

    IF m_language_id = 'NL'
    THEN
        IF p_record_group_type = 'M'
        THEN
            IF m_no_of_messages > 1
            THEN
                m_clob := REPLACE(m_clob, m_less_tag || 'Payment Type' || m_greater_tag ||' Betalingen',CASE p_transactiongroup WHEN 'CT' THEN 'Betalingen' WHEN 'DD' THEN 'Incasso''s' WHEN 'EFT' THEN 'Betalingen' ELSE p_transactiongroup END);
                m_clob := REPLACE(m_clob, m_less_tag ||'placeholder' || m_greater_tag, 'staan');
            ELSE
                m_clob := REPLACE(m_clob, m_less_tag || 'Payment Type' || m_greater_tag ,CASE p_transactiongroup WHEN 'CT' THEN 'Betaling' WHEN 'DD' THEN 'Incasso' WHEN 'EFT' THEN 'Betaling' ELSE p_transactiongroup END);
                m_clob := REPLACE(m_clob, ' Betalingen','');
                m_clob := REPLACE(m_clob, m_less_tag ||'placeholder' || m_greater_tag, 'staat');
            END IF;
        ELSIF  p_record_group_type = 'B'
        THEN
            IF m_no_of_messages > 1
            THEN
                m_clob := REPLACE(m_clob, m_less_tag || 'Payment Type' || m_greater_tag || ' Betalingen ',CASE p_transactiongroup WHEN 'CT' THEN 'betaalbatches ' WHEN 'DD' THEN 'incassobatches ' ELSE p_transactiongroup END);
                m_subject := REPLACE(m_subject,'Payments',CASE p_transactiongroup WHEN 'CT' THEN 'Betaalbatches' WHEN 'DD' THEN 'Incassobatches' ELSE p_transactiongroup END);
                m_clob := REPLACE(m_clob, m_less_tag ||'placeholder' || m_greater_tag, 'staan');
            ELSE
                m_clob := REPLACE(m_clob, m_less_tag || 'Payment Type' || m_greater_tag ,CASE p_transactiongroup WHEN 'CT' THEN 'betaalbatch' WHEN 'DD' THEN 'incassobatch' ELSE p_transactiongroup END);
                m_subject := REPLACE(m_subject,'Payments',CASE p_transactiongroup WHEN 'CT' THEN 'Betaalbatch' WHEN 'DD' THEN 'Incassobatch' ELSE p_transactiongroup END);
                m_clob := REPLACE(m_clob, m_less_tag ||'placeholder' || m_greater_tag, 'staan');
            END IF;
            ELSIF  p_record_group_type = 'F'
        THEN
            IF m_no_of_messages > 1
            THEN
                m_clob := REPLACE(m_clob, m_less_tag || 'Payment Type' || m_greater_tag ,CASE p_transactiongroup WHEN 'CT' THEN 'betaalfiles ' WHEN 'DD' THEN 'incassofiles ' ELSE p_transactiongroup END);
                m_subject := REPLACE(m_subject,'Payments',CASE p_transactiongroup WHEN 'CT' THEN 'Betaalfiles' WHEN 'DD' THEN 'Incassofiles' ELSE p_transactiongroup END);
                m_clob := REPLACE(m_clob, m_less_tag ||'placeholder' || m_greater_tag, 'staan');
            ELSE
                m_clob := REPLACE(m_clob, m_less_tag || 'Payment Type' || m_greater_tag ,CASE p_transactiongroup WHEN 'CT' THEN 'betaalfile' WHEN 'DD' THEN 'incassofile' ELSE p_transactiongroup END);
               m_subject := REPLACE(m_subject,'Payments' ,CASE p_transactiongroup WHEN 'CT' THEN 'Betaalfile' WHEN 'DD' THEN 'Incassofile' ELSE p_transactiongroup END);
                m_clob := REPLACE(m_clob, m_less_tag ||'placeholder' || m_greater_tag, 'staat');
            END IF;
        END IF;
        m_stagename:= TD_GET_VALUE('STAGE_MAPPING',m_stagename);
        m_clob := REPLACE(m_clob, m_less_tag || 'Stagename' || m_greater_tag, m_stagename);
        m_subject := REPLACE(m_subject, m_less_tag || 'Stagename' || m_greater_tag, m_stagename);
        m_clob := REPLACE(m_clob, ' Stage' , 'fase');
    ELSE
       -- DBMS_OUTPUT.PUT_LINE(' ==ELSE== ');

        IF m_no_of_messages > 1
        THEN
            m_clob := REPLACE(m_clob, m_less_tag || 'Payment Type' || m_greater_tag ,CASE p_transactiongroup WHEN 'CT' THEN 'Credit transfers' WHEN 'DD' THEN 'Direct debits' ELSE p_transactiongroup END);
            m_clob := REPLACE(m_clob,'Credit transfers Payments ',CASE p_record_group_type WHEN 'B' THEN 'Credit transfer batches ' WHEN 'F' THEN 'Files ' ELSE 'Credit transfers ' END);
            m_clob := REPLACE(m_clob,'Direct debits Payments ',CASE p_record_group_type WHEN 'B' THEN 'Direct debit batches ' WHEN 'F' THEN 'Files ' ELSE 'Direct debits ' END);
            m_clob := REPLACE(m_clob,'Payment',CASE p_record_group_type WHEN 'B' THEN 'Batches' WHEN 'F' THEN 'Files' ELSE 'Payments' END);
           m_clob := REPLACE(m_clob,'Payments',CASE p_record_group_type WHEN 'B' THEN 'Batches' WHEN 'F' THEN 'Files' ELSE 'Payments' END);
           m_clob := REPLACE(m_clob,'messages',CASE p_record_group_type WHEN 'B' THEN 'batches' WHEN 'F' THEN 'files' ELSE 'messages' END);

           m_clob := REPLACE(m_clob,'files/batches/payments',CASE p_record_group_type WHEN 'F' THEN 'files' WHEN 'B' THEN 'batches' ELSE 'payments' END);
           m_clob := REPLACE(m_clob,'files/batches/messages',CASE p_record_group_type WHEN 'F' THEN 'files' WHEN 'B' THEN 'batches' ELSE 'messages' END);
           m_clob := REPLACE(m_clob,'files/payments',CASE p_record_group_type WHEN 'F' THEN 'files' ELSE 'payments' END);
           m_clob := REPLACE(m_clob,'Message','Messages');
           
--           DBMS_OUTPUT.PUT_LINE('HERE1 : m_subject' || m_subject);
--           DBMS_OUTPUT.PUT_LINE('HERE1 : m_clob' || m_clob);
            m_subject := REPLACE(m_subject,'Payments',CASE p_record_group_type WHEN 'B' THEN 'Batches' WHEN 'F' THEN 'Files' ELSE 'Payments' END);
            m_subject := REPLACE(m_subject,'messages',CASE p_record_group_type WHEN 'B' THEN 'batches' WHEN 'F' THEN 'files' ELSE 'messages' END);
            m_subject := REPLACE(m_subject,'Message','Messages');
            
            m_subject := REPLACE(m_subject,'Messagess','Messages');
            m_clob := REPLACE(m_clob,'Messagess','Messages');
            m_clob := REPLACE(m_clob,' message ', ' messages ');
        --    DBMS_OUTPUT.PUT_LINE('HERE1 : m_clob' || m_clob);
            m_subject := REPLACE(m_subject,'Files/Messages','Files');
            m_clob := REPLACE(m_clob,'Files/Messages','Files');
            m_subject := REPLACE(m_subject,'Batches/Messages','Batches');
            m_clob := REPLACE(m_clob,'Batches/Messages','Batches');
           /* IF p_notification_mode = 'EMAIL'
            THEN
               m_subject := REPLACE(m_subject,'acknowledgement','acknowledgements');
               m_clob := REPLACE(m_clob,'acknowledgement','acknowledgements');
            END IF; */
            --DBMS_OUTPUT.PUT_LINE('-----m_clob8--------: '||m_clob);

        ELSE
            m_clob := REPLACE(m_clob, m_less_tag || 'Payment Type' || m_greater_tag ,CASE p_transactiongroup WHEN 'CT' THEN 'Credit transfer' WHEN 'DD' THEN 'Direct debit' ELSE p_transactiongroup END);
            m_clob := REPLACE(m_clob,'Payments ',CASE p_record_group_type WHEN 'B' THEN 'batch ' WHEN 'F' THEN 'File ' ELSE 'Payment ' END);
            m_subject := REPLACE(m_subject,'Payments',CASE p_record_group_type WHEN 'B' THEN 'Batch' WHEN 'F' THEN 'File' ELSE 'Payment' END);
            m_subject := REPLACE(m_subject,'messages',CASE p_record_group_type WHEN 'B' THEN 'batch' WHEN 'F' THEN 'file' ELSE 'message' END);
            m_clob := REPLACE(m_clob,'messages',CASE p_record_group_type WHEN 'B' THEN 'batch' WHEN 'F' THEN 'file' ELSE 'message' END);
            m_clob := REPLACE(m_clob,'Payment',CASE p_record_group_type WHEN 'B' THEN 'Batch' WHEN 'F' THEN 'File' ELSE 'Payment' END);
            m_clob := REPLACE(m_clob,'files/batches/payments',CASE p_record_group_type WHEN 'F' THEN 'file' WHEN 'B' THEN 'batch' ELSE 'payment' END);
            m_clob := REPLACE(m_clob,'files/batches/messages',CASE p_record_group_type WHEN 'F' THEN 'file' WHEN 'B' THEN 'batch' ELSE 'message' END);
           m_clob := REPLACE(m_clob,'files/payments',CASE p_record_group_type WHEN 'F' THEN 'file' ELSE 'payment' END);
            m_clob := REPLACE(m_clob,'payments',CASE p_record_group_type WHEN 'B' THEN 'Batch' WHEN 'F' THEN 'File' ELSE 'Payment' END);

            m_clob := REPLACE(m_clob,'Messages','Message');
           
           m_subject := REPLACE(m_subject,'Messages', 'Message');
            m_subject := REPLACE(m_subject,'messages', 'message');
            m_subject := REPLACE(m_subject,'File/Message','Files');
            m_clob := REPLACE(m_clob,'File/Message','Files');
            m_subject := REPLACE(m_subject,'Batch/Message','Batch');
            m_clob := REPLACE(m_clob,'Batch/Message','Batch');
            m_subject := REPLACE(m_subject,'payments', 'payment');
            m_clob := REPLACE(m_clob,'records','record');
            m_subject := REPLACE(m_subject,'records', 'record');

            --DBMS_OUTPUT.PUT_LINE('-----m_clob9--------: '||m_clob);


        END IF;
        m_clob := REPLACE(m_clob, m_less_tag || 'Stagename' || m_greater_tag, m_stagename);
               -- DBMS_OUTPUT.PUT_LINE('m_stagename 1: ' || m_stagename);

        m_clob := REPLACE(m_clob, '<Stagename>', m_stagename);
                 --       DBMS_OUTPUT.PUT_LINE('m_stagename 2: ' || m_stagename);
                --DBMS_OUTPUT.PUT_LINE('====m_clob ====: ' || m_clob);

       -- DBMS_OUTPUT.PUT_LINE('HERE1');
        m_subject := REPLACE(m_subject, '<Stagename>', m_stagename);
       -- DBMS_OUTPUT.PUT_LINE('m_subject : ' || m_subject);
    END IF;

    IF m_no_of_messages = 1
    THEN
         m_clob := REPLACE(m_clob,'wachten','wacht');
         m_clob := REPLACE(m_clob,' are ',' is ');
         m_clob := REPLACE(m_clob,' have ',' has ');
         m_clob := REPLACE(m_clob,' records ',' record ');
         m_clob := REPLACE(m_clob,'Files','File');
         m_clob := REPLACE(m_clob,'Bestanden','Bestand');
         m_clob := REPLACE(m_clob,'invoices','invoice');
         m_clob := REPLACE(m_clob,' These ',' This ');
         m_clob := REPLACE(m_clob,' dit zijn ',' dit is ');
         m_clob := REPLACE(m_clob,' messages ',' message ');
         m_clob := REPLACE(m_clob,' afwijzingsberichten ',' afwijzingsbericht ');
	 m_clob := REPLACE(m_clob,' Betalingen ',' Betaling ');
     m_clob := REPLACE(m_clob,'has/have','has');
         m_clob := REPLACE(m_clob,'is/are','is');
         m_subject := REPLACE(m_subject,'has/have','has');
        m_subject := REPLACE(m_subject,'is/are','is');
        m_subject := REPLACE(m_subject,'records','record');

         IF m_language_id = 'NL'
         THEN
            m_subject := REPLACE(m_subject,'wachten','wacht');
            m_subject := REPLACE(m_subject,'Payments',CASE p_record_group_type WHEN 'M' THEN CASE p_transactiongroup WHEN 'CT' THEN 'Betaling' WHEN 'DD' THEN 'Incasso' WHEN 'EFT' THEN 'Betaling' END WHEN 'B' THEN 'Batch' ELSE 'Bestand' END);
            m_subject := REPLACE(m_subject, m_less_tag ||'placeholder' || m_greater_tag, 'staat');
         END IF;
    ELSE

        m_clob := REPLACE(m_clob,'has/have','have');
        m_clob := REPLACE(m_clob,'is/are','are');
        m_subject := REPLACE(m_subject,'has/have','have');
        m_subject := REPLACE(m_subject,'is/are','are');


        IF m_language_id = 'NL'
        THEN
            m_subject := REPLACE(m_subject,'Payments',CASE p_record_group_type WHEN 'M' THEN CASE p_transactiongroup WHEN 'CT' THEN 'Betalingen' WHEN 'DD' THEN 'Incasso''s' WHEN 'EFT' THEN 'Betalingen' END WHEN 'B' THEN 'Batches' ELSE 'Bestanden' END);
            m_subject := REPLACE(m_subject, m_less_tag ||'placeholder' || m_greater_tag, 'staan');
        END IF;
    END IF;
            m_clob := REPLACE(m_clob, 'cancelled.', 'cancelled');


    IF LENGTH(m_result) > 0 AND m_no_of_messages <=1 --ask vinaya
    THEN
        m_result := m_result || chr(13)||chr(10) || m_clob;
    ELSE
        m_result := m_clob;
    END IF;
--    DBMS_OUTPUT.PUT_LINE('m_result: '||m_result);
--    DBMS_OUTPUT.PUT_LINE('m_subject: '||m_subject);

    m_clob := EMPTY_CLOB();

    IF  p_record_group_type = 'B'
    THEN
        m_clob := p_append_str;
    END IF;

    IF  p_record_group_type = 'M'
    THEN
        m_clob := p_append_str;
    END IF;

    p_subject := m_subject;
    p_result := m_result;
EXCEPTION
WHEN OTHERS
THEN
    DBMS_OUTPUT.PUT_LINE('others: '||SQLCODE||SQLERRM|| DBMS_UTILITY.format_error_backtrace);
END;
/
-- [9.06.00.006.10] [20230915] [ASARAF] [END]
EXIT;