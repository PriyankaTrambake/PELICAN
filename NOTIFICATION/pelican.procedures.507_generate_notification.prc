-- [9.06.00.000.03] [20230517] [PTRAMBAKE] [START]
SET DEFINE OFF;
create or replace PROCEDURE            generate_notification
(
    p_queueid_status        IN VARCHAR2 DEFAULT NULL,
    p_notification_type     IN USER_NOTIFICATION_TYPE.notification_type%TYPE DEFAULT NULL,
    p_msgdb_id              IN NUMBER DEFAULT 0,
    p_notification_template IN VARCHAR2 DEFAULT NULL
)
IS
    m_institutionid             MSGDB.institutionid%TYPE                                := NULL;
    m_append_str                CLOB                                                    := NULL;
    m_header_str                CLOB                                                    := NULL;
    m_footer_str                CLOB                                                    := NULL;
    m_path                      INSTITUTIONPARAMETERS.path%TYPE                         := 'INSTITUTION_DETAILS';
    m_brandname                 INSTITUTIONPARAMETERS.PARAMNAME%TYPE                     := 'BRAND_NAME';
    m_buffer_days               INSTITUTIONPARAMETERS.paramvalue%TYPE                   := NULL;
    m_buffer_day_param          INSTITUTIONPARAMETERS.paramname%TYPE                    := 'DUE_DATE_BUFFER_DAYS';
    m_beg_ctr                   NUMBER                                                  := 0;
    m_end_ctr                   NUMBER                                                  := 0;
    m_language_id               PREFERENCES.languageid%TYPE                             := NULL;
    m_result                    CLOB                                                    := NULL;
    m_subject                   VARCHAR2(1000)                                          := NULL;
    m_subject_template          VARCHAR2(1000)                                          := NULL;
    m_subject_str               VARCHAR2(1000)                                          := NULL;
    m_subject_str_temp          VARCHAR2(1000)                                          := NULL;
    m_result_blob               BLOB                                                    := NULL;
    m_notification_no           NUMBER                                                  := 0;
    m_toList                    NOTIFICATION.TO_LIST%TYPE                               := NULL;
    m_ccList                    NOTIFICATION.CC_LIST%TYPE                               := NULL;
    m_institution_email_id      NOTIFICATION.TO_LIST%TYPE                               := NULL;
    m_user_name                 UUSER.username%TYPE                                     := NULL;
    m_clob                      CLOB                                                    := NULL;
    m_template_clob             CLOB                                                    := NULL;
    m_currency                  CURRENCYINFO.symbol%TYPE                                := 0;
    m_no_of_messages            NUMBER                                                  := 0;
    m_total_amount              VARCHAR2(50)                                            := 0;
    m_notification_link         VARCHAR2(254)                                           := NULL;
    m_tdidcode                  VARCHAR2(25)                                            := 'PUSH_NOTI_CONF';
    m_tdkey_brand_name          VARCHAR2(25)                                            := 'NOTIFY-BRAND-NAME';
    m_tdkey_brand_logo          VARCHAR2(25)                                            := 'NOTIFY-BRAND-LOGO';
    m_start_date                MSGDB.payment_duedate%TYPE                              := NULL;
    m_end_date                  MSGDB.payment_duedate%TYPE                              := NULL;
    m_record_group_type         MSGDB.record_group_type%TYPE                            := NULL;
    m_msgdb_id_list             CLOB                                                    := EMPTY_CLOB();
    g_application               GENAUDIT.application%TYPE                               := 'PELICAN';
    g_action                    VARCHAR2(100)                                           := 'INSERT';
    g_modulename                VARCHAR2(100)                                           := 'NOTIFICATION';
    m_last_record_flag          BOOLEAN                                                 := FALSE;
    m_messageno                 MSGDB.messageno%TYPE                                    := NULL;
    m_processing_stage          MSGDB.processing_stage%TYPE                             := NULL;
    m_transactiongroup          MSGDB.transactiongroup%TYPE                             := NULL;
    m_compare_str               VARCHAR2(100)                                           := NULL;
    m_next_compare_str          VARCHAR2(100)                                           := NULL;
    m_currency_symbol_found     BOOLEAN                                                 := TRUE;
    m_priorityamountnum         MSGDB.priorityamountnum%TYPE                            := 0;
    m_msgdb_id                  MSGDB.msgdb_id%TYPE                                     := 0;
    m_unhandled_exception       BOOLEAN                                                 := FALSE;
    m_notification_generated    BOOLEAN                                                 :=FALSE;
    m_prev_institutionid        INSTITUTIONMASTER.institutionid%TYPE                    := NULL;
    m_msg_institutionid         MSGDB.institutionid%TYPE                                := NULL;
    m_notification_mode         USER_NOTIFICATION_MODE.notification_mode%TYPE           := NULL;
    m_originating_system        INSTITUTION_ORGANIZATION_INFO.originating_system%TYPE   := NULL;
    m_page_parameters           NOTIFICATION.PAGE_PARAMETERS%TYPE                       := NULL;
    m_pageinstanceid            VARCHAR2(100)                                           := NULL;
    m_payment_day               VARCHAR(100)                                            := NULL;
    m_benefname                 MSGDB.benefname%TYPE                                    := NULL;
    m_logo                      VARCHAR2(254)                                           := NULL;
    m_signature                 VARCHAR2(254)                                           := NULL;
    m_current_year              VARCHAR2(254)                                           := to_char(sysdate, 'YYYY');
    m_less_tag                  VARCHAR2(1000)                                          := NULL;
    m_greater_tag               VARCHAR2(1000)                                          := NULL;
    m_user_inst_end_ctr         NUMBER                                                  := 0;
    m_user_inst_beg_ctr         NUMBER                                                  := 0;
    m_count                     NUMBER                                                  := 0;
    m_institutioncode           INSTITUTIONMASTER.institutioncode%TYPE                  := NULL;
    m_delinkuser                UUSER.delinkuser%TYPE                                   := NULL;
    m_notification_type         USER_NOTIFICATION_TYPE.notification_type%TYPE           := NULL;
    m_start_ctr                 NUMBER                                                  := 0;
    m_stop_ctr                  NUMBER                                                  := 0;
    m_start_stage_ctr                 NUMBER                                                  := 0;
    m_stop_stage_ctr                  NUMBER                                                  := 0;
    m_roles                     VARCHAR2(255)                           := NULL;
    m_profile_id                VARCHAR2(255)                                           := NULL;
    m_query                     VARCHAR2(32764)                                         := NULL;
    m_where_clause              VARCHAR2(32764)                                         := NULL;
    m_noti_onarrival_type       TABLEDETAILS.TDVALUE%TYPE                               := NULL;
    m_body_loop_part            CLOB                                    := EMPTY_CLOB();
    m_noti_limit                NUMBER;

-----------------EXCEPTIONS-----------------------------------------------
    NO_RECORD_FOUND             EXCEPTION;
    NO_USER_FOUND               EXCEPTION;
    UNHANDLED_EXCEPTION         EXCEPTION;
--------------------------------------------------------------------------

    TYPE s_msgdb IS RECORD
    (
        transactiongroup    MSGDB.transactiongroup%TYPE,
        currency            MSGDB.currency%TYPE,
        msgdb_id            MSGDB.msgdb_id%TYPE,
        record_group_type   MSGDB.record_group_type%TYPE,
        processing_stage    MSGDB.processing_stage%TYPE,
        priorityamountnum   MSGDB.priorityamountnum%TYPE,
        institutionid       MSGDB.institutionid%TYPE,
        groupinginfo        MSGDB.groupinginfo%TYPE,
        compare_str         VARCHAR2(4000),
        messageno           MSGDB.messageno%TYPE,
        queueid             MSGDB.queueid%TYPE,
        status              MSGDB.status%TYPE,
        repairedby         msgdb.repairedby%TYPE,
        releasedby         msgdb.releasedby%TYPE
    );

    TYPE a_tbldtls     IS TABLE OF TABLEDETAILS.tdvalue%TYPE;
    t_tbldtls          a_tbldtls        := a_tbldtls();

    TYPE t_msgdb        IS TABLE OF s_msgdb;
    a_msgdb             t_msgdb            := t_msgdb();

    TYPE s_msgdb_links IS RECORD
    (
    msgdb_id    MSGDB_LINKS.msgdb_id%TYPE
    );

    TYPE t_msgdb_links        IS TABLE OF s_msgdb_links;
    a_msgdb_links           t_msgdb_links := t_msgdb_links();

    TYPE a_msgdb_id_list     IS TABLE OF VARCHAR(4000);
    t_msgdb_id_list          a_msgdb_id_list        := a_msgdb_id_list();


    TYPE a_msgdb_id        IS TABLE OF MSGDB.msgdb_id%TYPE;
    t_msgdb_id          a_msgdb_id        := a_msgdb_id();

    TYPE a_processing_stage        IS TABLE OF MSGDB.processing_stage%TYPE;
    t_processing_stage          a_processing_stage        := a_processing_stage();
    

    TYPE a_queueid        IS TABLE OF MSGDB.queueid%TYPE;
    t_queueid          a_queueid        := a_queueid();

    TYPE a_status        IS TABLE OF MSGDB.status%TYPE;
    t_status          a_status        := a_status();

    TYPE a_profile_id     IS TABLE OF USERPROFILE.profileid%TYPE;
    t_profile_id          a_profile_id        := a_profile_id();


    TYPE a_notification_mode        IS TABLE OF USER_NOTIFICATION_TYPE.notification_mode%TYPE;
    t_notification_mode          a_notification_mode        := a_notification_mode();

    TYPE a_notification_type        IS TABLE OF USER_NOTIFICATION_TYPE.notification_type%TYPE;
    t_notification_type         a_notification_type        := a_notification_type();

    TYPE a_userid        IS TABLE OF UUSER.userid%TYPE;
    t_userid          a_userid        := a_userid();

    NO_MATCHING_TYPE    EXCEPTION;
    NO_ROLES_FOUND      EXCEPTION;

    TYPE s_user_institution IS RECORD
    (
        institution_id    user_notification_mode.institution_id%TYPE,
        user_id            user_notification_mode.user_id%TYPE,
        notification_mode            user_notification_mode.notification_mode%TYPE,
        user_updated_datetime        user_notification_type.user_updated_datetime%TYPE,
        inst_user_mode_str   VARCHAR2(1000)
    );

    TYPE t_user_institution        IS TABLE OF s_user_institution;
    a_user_institution             t_user_institution            := t_user_institution();

    cursor c_institution_hierarchy
    (
        c_institutionid IN institutionmaster.institutionid%TYPE,
        c_userid  IN user_notification_mode.user_id%TYPE,
        c_notification_type IN user_notification_type.notification_type%TYPE
    )
    IS
    SELECT   INSTITUTIONID_HIER_M  INSTITUTION_ID,
      user_id,
      NOTIFICATION_MODE, user_updated_datetime ,INSTITUTIONID_HIER_M || '*' || user_id || '*' || NOTIFICATION_MODE inst_user_mode_str
    FROM
    (
    SELECT childinstitution AS INSTITUTIONID_HIER_M
      FROM institutionhierarchy
        START WITH parentinstitution = c_institutionid
        CONNECT BY parentinstitution = PRIOR childinstitution
      UNION
      SELECT INSTITUTIONID AS INSTITUTIONID_HIER
      FROM INSTITUTIONMASTER
      WHERE INSTITUTIONID = c_institutionid
      ) ,
        user_notification_type UM
    where user_id = c_userid
    AND notification_type = c_notification_type
    ORDER BY INSTITUTIONID_HIER_M;

    cursor c_userprofile_institution
    (
        c_userid  IN user_notification_mode.user_id%TYPE,
        c_notification_type IN user_notification_type.notification_type%TYPE
    )
    IS
    SELECT  INSTITUTIONID_DELINK INSTITUTIONID,
            user_id,
            NOTIFICATION_MODE, user_updated_datetime ,INSTITUTIONID_DELINK || '*' || user_id || '*' || NOTIFICATION_MODE inst_user_mode_str
    FROM (SELECT DISTINCT
    CASE CHILD_INSTID_UP
      WHEN 'ALL'
      THEN INSTITUTIONID_HIER
      ELSE INSTITUTIONID_UP
    END INSTITUTIONID_DELINK
  FROM
    (SELECT INSTITUTIONID_HIER,
      INSTITUTIONID_UP,
      CHILD_INSTID_UP
    FROM
      (SELECT childinstitution AS INSTITUTIONID_HIER
      FROM institutionhierarchy
        START WITH parentinstitution IN (SELECT DISTINCT INSTITUTIONID AS INSTITUTIONID_DELINK FROM USERPROFILE WHERE userid = c_userid AND PROFILEPRIORITY = 1)
        CONNECT BY parentinstitution = PRIOR childinstitution
      UNION
      SELECT INSTITUTIONID AS INSTITUTIONID_HIER
      FROM INSTITUTIONMASTER
      WHERE INSTITUTIONID IN (SELECT DISTINCT INSTITUTIONID AS INSTITUTIONID_DELINK FROM USERPROFILE WHERE userid = c_userid AND PROFILEPRIORITY = 1)
      ) A,
      (SELECT DISTINCT INSTITUTIONID AS INSTITUTIONID_UP
      FROM USERPROFILE
      WHERE userid        = c_userid
      AND PROFILEPRIORITY = 1
      ) B ,
      (SELECT DISTINCT NVL(CHILD_INSTITUTIONID,'A') AS CHILD_INSTID_UP
      FROM USERPROFILE up
      WHERE up.userid     = c_userid
      AND PROFILEPRIORITY = 1
      ) C
      )),
    USER_NOTIFICATION_TYPE
    WHERE  user_id = c_userid
    AND notification_type = c_notification_type
    ORDER BY INSTITUTIONID_DELINK;

BEGIN

    m_noti_limit := td_get_value('NOTIFICATION','MAX_TXNS_LIMIT');
    m_signature := NVL(TD_GET_VALUE
                            (
                            p_tdidcode    => m_tdidcode,
                            p_tdkey     => m_tdkey_brand_name
                            ),'OneLinQ-');
    --DBMS_OUTPUT.PUT_LINE('-------m_signature -------: ' || m_signature);

    m_logo  :=   NVL(TD_GET_VALUE
                            (
                                p_tdidcode    => m_tdidcode,
                                p_tdkey     => m_tdkey_brand_logo
                            ),'https://daks2k3a4ib2z.cloudfront.net/59d13e4162a25200013c9af8/59d20d7725076c00015dbcee_OneLinQ-logo-RGB.png');
    --DBMS_OUTPUT.PUT_LINE('-------m_logo -------: ' || m_logo);

    FOR rec1 IN (SELECT DISTINCT institution_id ,user_id, NOTIFICATION_TYPE FROM user_notification_type where notification_type='HV-STAGE' order by institution_id)
    LOOP
      --  DBMS_OUTPUT.PUT_LINE('rec1.user_id' || rec1.user_id);
        BEGIN
            IF p_notification_type IS NULL
            THEN
               -- DBMS_OUTPUT.PUT_LINE('IF');
                m_notification_type := rec1.notification_type;

            ELSE
                --DBMS_OUTPUT.PUT_LINE('ELSE');
                m_notification_type := p_notification_type;

                IF p_notification_type !=    rec1.notification_type
                THEN
                    RAISE NO_MATCHING_TYPE;
                END IF;

            END IF;
          --  DBMS_OUTPUT.PUT_LINE('------------------------------------m_notification_type : '||m_notification_type);

            BEGIN
                select  NVL(delinkuser, 'N')
                INTO    m_delinkuser
                from    uuser
                where   userid = rec1.user_id
                and     institutionid = rec1.institution_id;
            EXCEPTION
                WHEN NO_DATA_FOUND
                THEN
                    RAISE NO_USER_FOUND;
            END;

--            DBMS_OUTPUT.PUT_LINE(' rec1.institution_id: '||rec1.institution_id);
--            DBMS_OUTPUT.PUT_LINE(' rec1.user_id: '||rec1.user_id);
--            DBMS_OUTPUT.PUT_LINE(' m_delinkuser: '||m_delinkuser);

            IF m_delinkuser = 'Y'
            THEN
                OPEN  c_userprofile_institution(rec1.user_id, rec1.notification_type);
                FETCH c_userprofile_institution BULK COLLECT INTO a_user_institution;
            ELSE
                OPEN  c_institution_hierarchy(rec1.institution_id,rec1.user_id,rec1.notification_type);
                FETCH c_institution_hierarchy BULK COLLECT INTO a_user_institution;
            END IF;

            IF c_userprofile_institution%ISOPEN
            THEN
                CLOSE c_userprofile_institution;
            ELSIF c_institution_hierarchy%ISOPEN
            THEN
                CLOSE c_institution_hierarchy;
            END IF;

            m_user_inst_beg_ctr := NVL(a_user_institution.FIRST,0);
            m_user_inst_end_ctr := NVL(a_user_institution.LAST,0);

          --  DBMS_OUTPUT.PUT_LINE('m_user_inst_end_ctr' || m_user_inst_end_ctr);

            IF m_user_inst_end_ctr > 0
            THEN
                FOR m_user_inst_ctr IN m_user_inst_beg_ctr..m_user_inst_end_ctr
                LOOP
                    BEGIN
                        SELECT  institutioncode
                        INTO    m_institutioncode
                        FROM    institutionmaster
                        WHERE   institutionid = a_user_institution(m_user_inst_ctr).institution_id;
                    EXCEPTION
                        WHEN NO_DATA_FOUND
                        THEN
                          --  DBMS_OUTPUT.PUT_LINE('Institution code not available');
                          NULL;
                    END;

                    BEGIN
                        IF m_unhandled_exception
                        THEN
                            RAISE UNHANDLED_EXCEPTION;
                        END IF;

                        m_institutionid                 := a_user_institution(m_user_inst_ctr).institution_id;
                        m_notification_mode             := a_user_institution(m_user_inst_ctr).notification_mode;
                        m_last_record_flag                 := FALSE;
                        m_notification_generated         := FALSE;
                        m_subject_str                     := NULL;

--                        DBMS_OUTPUT.PUT_LINE('-------m_institutionid -------: ' || m_institutionid);
--                        DBMS_OUTPUT.PUT_LINE('a_user_institution(m_user_inst_ctr).user_id: ' || a_user_institution(m_user_inst_ctr).user_id);
--                        DBMS_OUTPUT.PUT_LINE('a_user_institution(m_user_inst_ctr).notification_mode: ' || a_user_institution(m_user_inst_ctr).notification_mode);
--                        DBMS_OUTPUT.PUT_LINE('notification_type : ' || rec1.notification_type);

                        BEGIN
                            SELECT  distinct UPPER(languageid)
                            INTO    m_language_id
                            FROM    preferences
                            WHERE   user_id = a_user_institution(m_user_inst_ctr).user_id --institution_id = a_user_institution(m_user_inst_ctr).institution_id
                            AND     APPLICATIONID = 'PELICAN'
                            AND     languageid IS NOT NULL;
                        EXCEPTION
                            WHEN TOO_MANY_ROWS
                            THEN
                                --DBMS_OUTPUT.PUT_LINE('More than one record found in preferences');
                                m_language_id := 'EN';
                            WHEN NO_DATA_FOUND
                            THEN
                                --DBMS_OUTPUT.PUT_LINE('No data found in PREFERENCES table. ');
                                m_language_id := 'EN';
                        END;
                        --DBMS_OUTPUT.PUT_LINE('m_language_id : ' || m_language_id);

                        BEGIN
                            SELECT  username
                            INTO    m_user_name
                            FROM    uuser
                            WHERE   userid = a_user_institution(m_user_inst_ctr).user_id;

                        EXCEPTION
                            WHEN NO_DATA_FOUND
                            THEN
                                --DBMS_OUTPUT.PUT_LINE('NO_DATA_FOUND FOR uuser');
                                m_user_name := '';
                        END;

                        BEGIN
                             SELECT  NVL(subject_line,''),
                                     notifcation_template_text
                             INTO    m_subject_template,
                                     m_template_clob
                             FROM    notification_template
                             WHERE   notification_type_id = NVL(Get_Institution_Param_Value(rec1.institution_id, m_path,m_brandname), 'DEFAULT') 
                                                            || '_' || rec1.notification_type
                             AND     notification_mode           = a_user_institution(m_user_inst_ctr).notification_mode
                             AND     notification_language_id    = m_language_id;
                        EXCEPTION
                            WHEN NO_DATA_FOUND
                            THEN                                                                    
                                BEGIN
                                    SELECT   NVL(subject_line,''),
                                             notifcation_template_text
                                     INTO    m_subject_template,
                                             m_template_clob
                                     FROM    notification_template
                                     WHERE   notification_type_id = 'DEFAULT' ||'_' || rec1.notification_type
                                     AND     notification_mode           = a_user_institution(m_user_inst_ctr).notification_mode
                                     AND     notification_language_id    = m_language_id;

                                EXCEPTION
                                WHEN NO_DATA_FOUND
                                THEN

                                    SELECT  NVL(subject_line,''),
                                            notifcation_template_text
                                    INTO    m_subject_template,
                                            m_template_clob
                                    FROM    notification_template
                                    WHERE   notification_type_id = NVL(Get_Institution_Param_Value(rec1.institution_id, m_path,m_brandname), 'DEFAULT') 
                                                || '_' || rec1.notification_type
                                    AND     notification_mode           = a_user_institution(m_user_inst_ctr).notification_mode
                                    AND     notification_language_id    = 'NL';
                                END;
                        END;

                        m_notification_link:= NVL(NVL(NVL(TD_GET_VALUE('BRAND-CONFIG',UPPER(Get_Institution_Param_Value(rec1.institution_id, m_path,m_brandname))),TD_GET_VALUE('BRAND-CONFIG',Get_Institution_Param_Value(rec1.institution_id, m_path,m_brandname))),TD_GET_VALUE('BRAND-CONFIG',upper('OneLinQ'))),'LINK_NOT_CONFIGURED');

                        IF a_user_institution(m_user_inst_ctr).notification_mode = 'EMAIL'
                        THEN
                            m_less_tag      := '&lt;';
                            m_greater_tag   := '&gt;';
                        ELSE
                            m_less_tag := '<';
                            m_greater_tag := '>';
                        END IF;

                        m_template_clob := REPLACE(m_template_clob,m_less_tag || 'Name of user' || m_greater_tag,INITCAP(m_user_name));
                        m_template_clob := REPLACE(m_template_clob,'<IP_ADDRESS/HOST_NAME/DNS_NAME>:<PORT_NO>',m_notification_link);
                        m_template_clob := REPLACE(m_template_clob,m_less_tag || 'signature' || m_greater_tag ,m_signature);
                        m_template_clob := REPLACE(m_template_clob,m_less_tag || 'logo' || m_greater_tag ,m_logo);
                           --   DBMS_OUTPUT.PUT_LINE('CURRENT YEAR' || m_current_year);
                        m_template_clob := REPLACE(m_template_clob, m_less_tag || 'Current year' || m_greater_tag ,m_current_year);

                       --DBMS_OUTPUT.PUT_LINE('m_template_clob: '||m_template_clob);

                        IF a_user_institution(m_user_inst_ctr).notification_mode IN ('SMS','ONSCREEN')
                        THEN
                            m_append_str := SUBSTR(m_template_clob,INSTR(m_template_clob, m_less_tag || 'Number of Payments/Transactions' || m_greater_tag),(INSTR(m_template_clob,'.')+1)-INSTR(m_template_clob, m_less_tag || 'Number of Payments/Transactions'||m_greater_tag));
                            m_footer_str := SUBSTR(m_template_clob,INSTR(m_template_clob,'.')+1,LENGTH(m_template_clob)-INSTR(m_template_clob,'.')+1);
                        ELSE
--                            m_append_str := SUBSTR(m_template_clob,INSTR(m_template_clob, '<!--Body start-->'),(INSTR(m_template_clob,'<!--Footer start-->'))-INSTR(m_template_clob, '<!--Body start-->'));
--                            m_footer_str := SUBSTR(m_template_clob,INSTR(m_template_clob,'<!--Footer start-->'),LENGTH(m_template_clob)-INSTR(m_template_clob,'<!--Footer start-->')+1);
--                
                        m_append_str := SUBSTR(m_template_clob,INSTR(m_template_clob, m_less_tag || 'Number of Payments/Transactions' || m_greater_tag),(INSTR(m_template_clob,'Stage.')+6)-INSTR(m_template_clob, m_less_tag || 'Number of Payments/Transactions'||m_greater_tag));
                        m_footer_str := SUBSTR(m_template_clob,INSTR(m_template_clob,'Stage.')+6,LENGTH(m_template_clob)-INSTR(m_template_clob,'Stage.')+6);

                        END IF;

                        --m_header_str := SUBSTR(m_template_clob,1,INSTR(m_template_clob,'<!--Body start-->')-1);
                        m_header_str := SUBSTR(m_template_clob,1,INSTR(m_template_clob, m_less_tag || 'Number of Payments/Transactions' || m_greater_tag)-1);

--                        DBMS_OUTPUT.PUT_LINE('m_header_str: '||m_header_str);
 --                       DBMS_OUTPUT.PUT_LINE('m_append_str: '||m_append_str);
--                        DBMS_OUTPUT.PUT_LINE('m_footer_str: '||m_footer_str);

                        IF m_notification_type = 'ONDUEDATE'  
                        THEN
                            m_start_date:= TO_DATE(TO_CHAR(TRUNC(SYSDATE),'YYYYMMDDHH24MISS'),'YYYYMMDDHH24MISS');
                            m_end_date := TO_DATE(TO_CHAR(TRUNC(SYSDATE),'YYYYMMDD') || '235959','YYYYMMDDHH24MISS');
                        ELSIF m_notification_type = 'PREDUEDATE'
                        THEN
                            m_buffer_days    := GET_INSTITUTION_PARAM_VALUE
                                                (
                                                    p_institutionid => UPPER(a_user_institution(m_user_inst_ctr).institution_id),
                                                    p_path          => m_path,
                                                    p_paramname     => m_buffer_day_param
                                                );
                            m_start_date:= TO_DATE(TO_CHAR(TRUNC(SYSDATE + NVL(m_buffer_days,3)),'YYYYMMDDHH24MISS'),'YYYYMMDDHH24MISS');
                            m_end_date := TO_DATE(TO_CHAR(TRUNC(SYSDATE + NVL(m_buffer_days,3)),'YYYYMMDD') || '235959','YYYYMMDDHH24MISS');
                        END IF;

                        m_institution_email_id    := GET_INSTITUTION_PARAM_VALUE
                                                    (
                                                        p_institutionid => UPPER(rec1.institution_id),
                                                        p_path          => m_path,
                                                        p_paramname     => 'NOTIFICATION_EMAIL_ID'
                                                    );

                        BEGIN
                            SELECT  emailid
                            INTO    m_toList
                            FROM    uuser
                            WHERE   userid = rec1.user_id
                            and     institutionid = rec1.institution_id;
                        EXCEPTION
                            WHEN NO_DATA_FOUND
                            THEN
                             --  DBMS_OUTPUT.PUT_LINE('No email id found for the user : ' || a_user_institution(m_user_inst_ctr).user_id);
                            NULL;
                        END;

                        IF LENGTH(m_institution_email_id) > 0
                        THEN
                            IF m_toList = m_institution_email_id
                            THEN
                                m_ccList := m_toList;
                            ELSE
                                IF m_toList IS NULL
                                THEN
                                    m_toList := m_institution_email_id;
                                END IF;
                                m_ccList := LTRIM(RTRIM(m_institution_email_id));
                            END IF;
                        ELSE
                            m_ccList := m_toList;
                        END IF;


                        m_roles := INSTR(TD_GET_VALUE('NOTIFICATION','ROLES'),','||m_notification_type||',');
                      --  DBMS_OUTPUT.PUT_LINE(' m_roles ' || m_roles);
                        IF m_roles > 0
                        THEN
                            t_profile_id := a_profile_id();
                            SELECT DISTINCT(PROFILEID)
                            BULK COLLECT INTO t_profile_id
                            FROM (SELECT PROFILEID FROM GROUPPROFILE A, USERGROUP B
                            where A.GROUPID=B.GROUPID
                            AND A.INSTITUTIONID=B.INSTITUTIONID
                            AND B.userid=rec1.user_id) C ,(SELECT * FROM TABLE (GET_CODE_FROM_LIST(TD_GET_VALUE('NOTI_TO_ROLES', m_notification_type), '|'))) D
                            WHERE C.PROFILEID = D.PARA_CODE;



                            m_start_ctr := NVL(t_profile_id.FIRST,0);
                            m_stop_ctr := NVL(t_profile_id.LAST,0);


                            IF m_stop_ctr = 0
                            THEN
                           -- DBMS_OUTPUT.PUT_LINE(' no roles found');
                            RAISE NO_ROLES_FOUND;
                            END IF;

                        ELSE

                        --DBMS_OUTPUT.PUT_LINE(' ABC 1');
                        t_profile_id.EXTEND;
                        t_profile_id(1) := m_notification_type;
                        m_start_ctr:= 1;
                        m_stop_ctr:= 1;
--                        DBMS_OUTPUT.PUT_LINE(' m_start_ctr'|| m_start_ctr);
--                        DBMS_OUTPUT.PUT_LINE(' m_stop_ctr'|| m_stop_ctr);

                        END IF;
                    

                        FOR i in m_start_ctr..m_stop_ctr
                        LOOP
                            BEGIN
                                t_msgdb_id              :=    a_msgdb_id();
                                t_processing_stage      :=   a_processing_stage();
                                m_msgdb_id_list         := EMPTY_CLOB();
                                m_prev_institutionid    := NULL;
                                m_unhandled_exception   := FALSE;

                                IF m_notification_type NOT IN ('ONDUEDATE', 'PREDUEDATE')
                                THEN
                                    SELECT *
                                    INTO m_noti_onarrival_type
                                    FROM TABLE (GET_CODE_FROM_LIST(TD_GET_VALUE('NOTIFICATION', 'NOTI_TYPES_ONARRIVAL'), '|'))
                                    WHERE PARA_CODE = m_notification_type;
                                ELSE
                                     m_noti_onarrival_type := NULL;
                                END IF;

                                FOR rec2 IN (SELECT DISTINCT STAGE FROM MESSAGESTAGE ORDER BY STAGE)
                                LOOP
                                    --        DBMS_OUTPUT.PUT_LINE('rec2.STAGE' || rec2.STAGE);
                                  BEGIN 
                                
                                    SELECT LISTAGG(tdvalue, ' ') WITHIN GROUP (ORDER BY tdkey) 
                                    into m_query 
                                    FROM tabledetails where TDIDCODE = m_noti_onarrival_type AND TDKEY LIKE 'QUERY%' ;

--                                DBMS_OUTPUT.PUT_LINE('m_query : ' || m_query);
--                                DBMS_OUTPUT.PUT_LINE('rec1.institution_id : ' || rec1.institution_id);
                                
                                
                                        --m_query := m_query || 'AND INSTITUTIONID IN ('||''''|| m_institutionid ||''''||') AND ROWNUM <=12';
                                        m_query := m_query || ''''||m_notification_type||''''||'||'||'''@'''||'||'||''''||a_user_institution(m_user_inst_ctr).notification_mode
                                                   ||''''||'||'||'''@'''||'||'||''''||a_user_institution(m_user_inst_ctr).user_id||''''||') = '||''''||'N'||''''||
                                                   'AND INSTITUTIONID IN ('||''''|| rec1.institution_id ||''''||') AND PROCESSING_STAGE = ('||''''|| rec2.STAGE ||''''||
                                                    ') AND (inputdatetime      >= NVL('||''''|| a_user_institution(m_user_inst_ctr).user_updated_datetime ||''''||
                                                    ', inputdatetime) OR currqueueindatetime >= NVL(' ||''''|| a_user_institution(m_user_inst_ctr).user_updated_datetime ||''''||', currqueueindatetime)) AND ROWNUM <=' || m_noti_limit;
                                        --ROWNUM <=12';
                                    --    DBMS_OUTPUT.PUT_LINE('m_query : ' || m_query);

                                     LOOP      
                                            IF m_prev_institutionid IS NULL 
                                            THEN
                                                EXECUTE IMMEDIATE m_query  BULK COLLECT INTO a_msgdb ;
                                            END IF;


                                        BEGIN
                                            m_beg_ctr := NVL(a_msgdb.FIRST,0);
                                            m_end_ctr := NVL(a_msgdb.LAST,0);

                                      --   DBMS_OUTPUT.PUT_LINE(' --m_end_ctr--' || m_end_ctr);

                                            IF m_end_ctr = 0
                                            THEN
                                           --     DBMS_OUTPUT.PUT_LINE(' NO_RECORD_FOUND in MSGDB');
                                               -- RAISE NO_RECORD_FOUND;
                                                EXIT;
                                            END IF;

                                            m_no_of_messages    := 0;
                                            m_total_amount      := 0;
                                            m_result            := NULL;
                                            m_clob              := m_append_str;

                                          --  DBMS_OUTPUT.PUT_LINE('m_end_ctr : ' || m_end_ctr);

                                            FOR m_ctr IN  m_beg_ctr..m_end_ctr
                                            LOOP
                                              --  DBMS_OUTPUT.PUT_LINE('m_ctr : ' || m_ctr);
                                                m_subject   := m_subject_template;
--                                                  DBMS_OUTPUT.PUT_LINE('--- m_footer_str --: ' || m_footer_str);
--                                                  DBMS_OUTPUT.PUT_LINE('--- m_append_str --: 1' || m_append_str);

                                                IF m_notification_mode = 'EMAIL'
                                                THEN
                                                generate_transaction_DATA(m_footer_str,a_msgdb(m_ctr).msgdb_id,m_body_loop_part);
                                                END IF;
--                                                DBMS_OUTPUT.PUT_LINE('--- m_body_loop_part --: ' || m_body_loop_part);
--                                                DBMS_OUTPUT.PUT_LINE('--- m_body_loop_part --: ' || m_body_loop_part);
--                                                DBMS_OUTPUT.PUT_LINE('--- m_append_str --:2' || m_append_str);
                                                BEGIN
                                                    IF m_notification_mode = 'EMAIL'
                                                    THEN
                                                        BEGIN
                                                            SELECT  NVL(symbol,a_msgdb(m_ctr).currency)
                                                            INTO    m_currency
                                                            FROM    currencyinfo
                                                            WHERE   currencycode = a_msgdb(m_ctr).currency;

                                                            m_currency_symbol_found := TRUE;
                                                        EXCEPTION
                                                            WHEN NO_DATA_FOUND
                                                            THEN
                                                                m_currency_symbol_found := FALSE;
                                                                m_currency        := a_msgdb(m_ctr).currency;
                                                                m_currency_symbol_found := TRUE;
                                                        END;
                                                    ELSE
                                                        m_currency_symbol_found := TRUE;
                                                        m_currency        := a_msgdb(m_ctr).currency;
                                                    END IF;

                                                    m_messageno := a_msgdb(m_ctr).messageno;
                                                    m_msgdb_id := a_msgdb(m_ctr).msgdb_id;
                                                    m_processing_stage := a_msgdb(m_ctr).processing_stage;
                                                    m_transactiongroup := a_msgdb(m_ctr).transactiongroup;
                                                    m_priorityamountnum := a_msgdb(m_ctr).priorityamountnum;
                                                    m_record_group_type := a_msgdb(m_ctr).record_group_type;

                                                    IF INSTR(td_get_value('NOTIFICATION','NOTI_BASED_MKCK'),a_msgdb(m_ctr).queueid) > 0
                                                    THEN
                                                        IF INSTR(td_get_value('NOTIFICATION','NOTI_BASED_LVL2'),a_msgdb(m_ctr).status) > 0
                                                        THEN
                                                            m_compare_str       := a_msgdb(m_ctr).compare_str || a_msgdb(m_ctr).repairedby;
                                                        ELSIF INSTR(td_get_value('NOTIFICATION','NOTI_BASED_LVL3'),a_msgdb(m_ctr).status) > 0
                                                        THEN
                                                            m_compare_str       := a_msgdb(m_ctr).compare_str || a_msgdb(m_ctr).releasedby;
                                                        ELSE
                                                            m_compare_str       := a_msgdb(m_ctr).compare_str ;
                                                         --   DBMS_OUTPUT.PUT_LINE('m_compare_str 1' || m_compare_str);
                                                        END IF;
                                                    ELSE
                                                        m_compare_str       := a_msgdb(m_ctr).compare_str ;
                                                    END IF;

                                                    m_msg_institutionid := a_msgdb(m_ctr).institutionid;

                                                   -- DBMS_OUTPUT.PUT_LINE('m_msgdb_id : ' || m_msgdb_id);

                                                    IF m_ctr < m_end_ctr
                                                    THEN
                                                        IF INSTR(td_get_value('NOTIFICATION','NOTI_BASED_MKCK'),a_msgdb(m_ctr).queueid) > 0
                                                        THEN
                                                            IF INSTR(td_get_value('NOTIFICATION','NOTI_BASED_LVL2'),a_msgdb(m_ctr).status) > 0
                                                            THEN
                                                                m_next_compare_str  := a_msgdb(m_ctr+1).compare_str || a_msgdb(m_ctr+1).repairedby;
                                                            ELSIF INSTR(td_get_value('NOTIFICATION','NOTI_BASED_LVL3'),a_msgdb(m_ctr).status) > 0
                                                            THEN
                                                                m_next_compare_str  := a_msgdb(m_ctr+1).compare_str || a_msgdb(m_ctr+1).releasedby;
                                                            ELSE
                                                                m_next_compare_str  := a_msgdb(m_ctr+1).compare_str ;
                                                              --  DBMS_OUTPUT.PUT_LINE(' m_next_compare_str '|| m_next_compare_str);
                                                            END IF;
                                                        ELSE
                                                            m_next_compare_str  := a_msgdb(m_ctr + 1).compare_str;
                                                             --  DBMS_OUTPUT.PUT_LINE('ELSE: ');
                                                        END IF;
                                                    ELSE
                                                            m_next_compare_str := 'LAST_RECORD';
                                                            m_last_record_flag := TRUE;
                                                          --     DBMS_OUTPUT.PUT_LINE('LAST_RECORD: ');

                                                    END IF;

                                                    IF INSTR(td_get_value('NOTIFICATION','NOTI_BASED_MKCK'),a_msgdb(m_ctr).queueid) > 0
                                                    THEN
                                                        IF INSTR(td_get_value('NOTIFICATION','NOTI_BASED_LVL2'),a_msgdb(m_ctr).status) > 0
                                                        THEN
                                                            IF a_msgdb(m_ctr).repairedby=rec1.user_id
                                                            THEN
                                                                m_currency_symbol_found := FALSE;
                                                            ELSE
                                                                m_currency_symbol_found := TRUE;
                                                            END IF;
                                                        ELSIF INSTR(td_get_value('NOTIFICATION','NOTI_BASED_LVL3'),a_msgdb(m_ctr).status) > 0
                                                        THEN
                                                            IF a_msgdb(m_ctr).releasedby=rec1.user_id OR a_msgdb(m_ctr).repairedby=rec1.user_id
                                                            THEN
                                                                m_currency_symbol_found := FALSE;
                                                            ELSE
                                                                m_currency_symbol_found := TRUE;
                                                            END IF;
                                                        END IF;
                                                    END IF;

                                                    IF m_currency_symbol_found
                                                    THEN
                                                       -- DBMS_OUTPUT.PUT_LINE(' m_msgdb_id_list :' ||m_msgdb_id_list);

                                                        m_no_of_messages    := m_no_of_messages + 1;

                                                        m_total_amount      := m_total_amount + m_priorityamountnum;
                                                      --  DBMS_OUTPUT.PUT_LINE(' m_total_amount :' ||m_total_amount);

                                                        IF instr(m_total_amount,'.') = 0
                                                        THEN
                                                            m_total_amount  := m_total_amount||'.00';
                                                        ELSIF NVL(m_total_amount,0) = 0
                                                        THEN
                                                            m_total_amount  := '0.00';
                                                        ELSE
                                                            m_total_amount    := SUBSTR(m_total_amount,1, INSTR(m_total_amount,'.') - 1) || '.' || RPAD(NVL(SUBSTR(m_total_amount, INSTR(m_total_amount,'.') + 1),'0'),2,'0');
                                                        END IF;

                                                        IF m_last_record_flag AND m_compare_str != m_next_compare_str 
                                                        THEN
                                                            ------------------------------------------------TO BE DECIDED--------------------------------
                                                            IF UPPER(m_language_id) = 'NL' AND m_record_group_type = 'M' AND m_next_compare_str != 'LAST_RECORD'
                                                            THEN
                                                                m_subject_str := 'Betalingen en Incasso''s wachten';
                                                            ELSIF UPPER(m_language_id) = 'NL' AND m_record_group_type = 'B' AND m_next_compare_str != 'LAST_RECORD'
                                                            THEN
                                                                m_subject_str := 'Betaalbatches en Incassobatches wachten';
                                                            END IF;
                                                            -----------------------------------------------------------------------------------------------------
                                                            BEGIN
                                                                SELECT  originating_system
                                                                INTO    m_originating_system
                                                                FROM    institution_organization_info
                                                                WHERE   institution_id = m_institutionid;
                                                            EXCEPTION
                                                                WHEN NO_DATA_FOUND
                                                                THEN
                                                                    --DBMS_OUTPUT.PUT_LINE('No institution found');
                                                                NULL;
                                                                WHEN OTHERS
                                                                THEN
                                                                    m_originating_system := 'X';
                                                            END;
                                                          -- DBMS_OUTPUT.PUT_LINE('m_clob : ' || m_clob);
                                                            generate_notification_data
                                                            (
                                                                p_clob                  => m_clob,
                                                                p_notification_type     => m_notification_type,
                                                                p_notification_mode     => m_notification_mode,
                                                                p_record_group_type     => m_record_group_type,
                                                                p_transactiongroup      => m_transactiongroup,
                                                                p_currency              => m_currency,
                                                                p_processing_stage      => m_processing_stage,
                                                                p_language_id           => m_language_id,
                                                                p_no_of_messages        => m_no_of_messages,
                                                                p_total_amount          => m_total_amount,
                                                                p_companyname           => get_institution_name(m_msg_institutionid),
                                                                p_append_str            => m_append_str,
                                                                p_subject               => m_subject,
                                                                p_result                => m_result,
                                                                p_payment_day           => m_payment_day,
                                                                p_benefname             => m_benefname,
                                                                p_profile               => m_profile_id
                                                            );

                                                            ------------------------------------------------TO BE DECIDED--------------------------------
                                                            IF LENGTH(m_subject_str) > 0 AND m_notification_mode = 'EMAIL'
                                                            THEN
                                                                m_subject_str_temp:= TRIM(SUBSTR(m_subject,(INSTR(m_subject,'OneLinQ - ')+10),INSTR(m_subject,'op')-11));
                                                                m_subject := REPLACE(m_subject,m_subject_str_temp,m_subject_str);
                                                            END IF;
                                                            ---------------------------------------------------------------------------------------------------
                                                            m_subject := REPLACE(m_subject,m_currency,a_msgdb(m_ctr).currency);
                                                            m_notification_generated := TRUE;
                                                       --     DBMS_OUTPUT.PUT_LINE('m_notification_generated := TRUE');
                                                        ELSE
                                                            m_notification_generated := FALSE;
                                                          --  DBMS_OUTPUT.PUT_LINE('m_notification_generated := FALSE');
                                                        END IF;

                                                        IF m_prev_institutionid IS NULL --OR m_institutionid != m_prev_institutionid
                                                        THEN
                                                            IF m_noti_onarrival_type IS NOT NULL
                                                            THEN
                                                               --    DBMS_OUTPUT.PUT_LINE('m_notification_type: ' ||m_notification_type);

                                                                m_msgdb_id_list :=  m_msgdb_id_list || m_msgdb_id || '@' ||m_processing_stage || '@' || a_msgdb(m_ctr).queueid || '@'|| a_msgdb(m_ctr).status || '@'|| m_notification_type || '@' || a_user_institution(m_user_inst_ctr).notification_mode || '@'|| a_user_institution(m_user_inst_ctr).user_id || '|';
                                                               -- DBMS_OUTPUT.PUT_LINE('m_msgdb_id_list: ' ||m_msgdb_id_list);
                                                            END IF;
                                                        END IF;
                                                    END IF;
                                                END;

                                                IF (m_last_record_flag AND DBMS_LOB.getlength(m_result) > 0  AND m_notification_generated) 
                                                    OR (DBMS_LOB.getlength(m_result) > 0  AND m_notification_generated)
                                                THEN
                                                    m_result := m_header_str || m_result || m_footer_str;
                                                    m_result_blob:= CLOB_TO_BLOB(m_result);
                                                    m_notification_no := notification_seq.NEXTVAL;

                                                    insert_notification_data
                                                    (
                                                        p_notification_no    => m_notification_no,
                                                        p_user_id            => rec1.user_id,
                                                        p_institution_id    => rec1.institution_id,
                                                        p_notification_mode    => a_user_institution(m_user_inst_ctr).notification_mode,
                                                        p_notification_type    => m_notification_type,
                                                        p_toList            => m_toList,
                                                        p_ccList            => m_ccList,
                                                        p_subject            => m_subject,
                                                        p_result_blob        => m_result_blob,
                                                        p_pageinstanceid    =>  m_pageinstanceid,
                                                        p_page_parameters    =>  m_page_parameters
                                                    );
                                                    genaudit_insert_enchash_wrap
                                                    (
                                                        m_messageno,
                                                        NULL,
                                                        NULL,
                                                        g_application,
                                                        g_modulename,
                                                        g_action,
                                                        'Notification generated for '|| a_user_institution(m_user_inst_ctr).user_id ||' user in '||' mode : '||m_notification_mode,
                                                        m_institutionid,
                                                        0
                                                    );

                                                    m_result            := EMPTY_CLOB();
                                                    m_last_record_flag  := FALSE;
                                                    m_no_of_messages    := 0;
                                                    m_total_amount      := 0;
                                                    m_result            := NULL;
                                                    m_clob              := m_append_str;

                                                   -- DBMS_OUTPUT.PUT_LINE('---------- Notification generated successfully -----------');

                                                    m_body_loop_part := NULL;
                                                END IF;
                                            END LOOP;

                                            IF m_noti_onarrival_type IS NOT NULL AND DBMS_LOB.INSTR(m_msgdb_id_list,'@') > 0
                                            THEN
                                               -- DBMS_OUTPUT.PUT_LINE('msgdb_output counter');
                                                SELECT getstringitemwithsepformatch (para_code,1,'@') BULK COLLECT INTO  t_msgdb_id
                                                FROM
                                                (SELECT  DISTINCT to_char(para_code) para_code FROM TABLE
                                                (get_code_from_list_clob (m_msgdb_id_list, '|'))where para_code is not null);

                                                SELECT getstringitemwithsepformatch (para_code,2,'@') BULK COLLECT INTO  t_processing_stage
                                                FROM
                                                (SELECT  DISTINCT to_char(para_code) para_code FROM TABLE
                                                (get_code_from_list_clob (m_msgdb_id_list, '|'))where para_code is not null);

                                                SELECT getstringitemwithsepformatch (para_code,3,'@') BULK COLLECT INTO  t_queueid
                                                FROM
                                                (SELECT  DISTINCT to_char(para_code) para_code FROM TABLE
                                                (get_code_from_list_clob (m_msgdb_id_list, '|'))where para_code is not null);

                                                SELECT getstringitemwithsepformatch (para_code,4,'@') BULK COLLECT INTO  t_status
                                                FROM
                                                (SELECT  DISTINCT to_char(para_code) para_code FROM TABLE
                                                (get_code_from_list_clob (m_msgdb_id_list, '|'))where para_code is not null);

                                                SELECT getstringitemwithsepformatch (para_code,5,'@') BULK COLLECT INTO  t_notification_type
                                                FROM
                                                (SELECT  DISTINCT to_char(para_code) para_code FROM TABLE
                                                (get_code_from_list_clob (m_msgdb_id_list, '|'))where para_code is not null);

                                                SELECT getstringitemwithsepformatch (para_code,6,'@') BULK COLLECT INTO  t_notification_mode
                                                FROM
                                                (SELECT  DISTINCT to_char(para_code) para_code FROM TABLE
                                                (get_code_from_list_clob (m_msgdb_id_list, '|'))where para_code is not null);

                                                SELECT getstringitemwithsepformatch (para_code,7,'@') BULK COLLECT INTO  t_userid
                                                FROM
                                                (SELECT  DISTINCT to_char(para_code) para_code FROM TABLE
                                                (get_code_from_list_clob (m_msgdb_id_list, '|'))where para_code is not null);

                                                FOR i IN 1..t_msgdb_id.LAST
                                                LOOP


                                                 INSERT INTO MSGDB_OUTPUT
                                                    (
                                                    msgdb_id,
                                                    mdbout_mode,
                                                    mdbout_status,
                                                    mdbout_date_time,
                                                    arch_status,
                                                    arch_date,
                                                    instanceid
                                                    )
                                                    VALUES
                                                    (
                                                    t_msgdb_id(i),
                                                    t_processing_stage(i) || '@' ||t_queueid(i)|| '@' || t_status(i)|| '@' || t_notification_type(i) || '@' || t_notification_mode(i) || '@' || t_userid(i),
                                                    'Y',
                                                    sysdate,
                                                    NULL,
                                                    NULL,
                                                    NULL
                                                    );
                                                  --  DBMS_OUTPUT.PUT_LINE('records inserted in msgdb_output : '||SQL%ROWCOUNT);

                                                END LOOP;
                                                 m_msgdb_id_list := EMPTY_CLOB();

                                                END IF;
                                            COMMIT;
                                            m_prev_institutionid :=  NULL;
                                            END;

            --                                IF m_prev_institutionid IS NULL 
            --                                THEN
            --                                    EXECUTE IMMEDIATE m_query  BULK COLLECT INTO a_msgdb ;
            --                                END IF;
            --                                
            --                                EXCEPTION
            --                                WHEN NO_RECORD_FOUND
            --                                THEN
            --                                    DBMS_OUTPUT.PUT_LINE('NO_RECORD_FOUND : For Institution ' || m_institutionid);
            --                                    
            --                                      EXIT;    
            --                                WHEN OTHERS
            --                                THEN
            --                                    DBMS_OUTPUT.PUT_LINE('others: '||SQLCODE||SQLERRM|| DBMS_UTILITY.format_error_backtrace);
            --                                 END;

                                         END LOOP;
                                        
                                
                                
                                   
                                 EXCEPTION
                                    WHEN NO_RECORD_FOUND
                                    THEN
                                        DBMS_OUTPUT.PUT_LINE('NO_RECORD_FOUND : For Institution ' || m_institutionid);
                                            
                                    WHEN OTHERS
                                    THEN
                                        DBMS_OUTPUT.PUT_LINE('others: '||SQLCODE||SQLERRM|| DBMS_UTILITY.format_error_backtrace);
                                   NULL;
                                END;
                                
                                END LOOP;
                                
                        EXCEPTION
                            WHEN NO_RECORD_FOUND
                            THEN
                                DBMS_OUTPUT.PUT_LINE('NO_RECORD_FOUND : For Institution ' || m_institutionid);
                           
                            WHEN OTHERS
                            THEN
                               DBMS_OUTPUT.PUT_LINE('others: '||SQLCODE||SQLERRM|| DBMS_UTILITY.format_error_backtrace);
                            
                        END;

                        END LOOP;
                        

                    EXCEPTION
                    WHEN UNHANDLED_EXCEPTION
                    THEN
                        IF (m_user_inst_ctr < a_user_institution.LAST AND a_user_institution(m_user_inst_ctr).institution_id = a_user_institution(m_user_inst_ctr + 1).institution_id)
                        THEN
                            m_unhandled_exception := TRUE;
                        ELSE
                            m_unhandled_exception := FALSE;
                        END IF;
                    WHEN NO_ROLES_FOUND
                    THEN
                       DBMS_OUTPUT.PUT_LINE('No roles found for user '|| a_user_institution(m_user_inst_ctr).user_id || ' for notification_type '|| m_notification_type);
                    NULL;
                    WHEN OTHERS
                    THEN
                        ROLLBACK;
                        DBMS_OUTPUT.PUT_LINE('generate_pymnt_notification others: '||SQLCODE||SQLERRM|| DBMS_UTILITY.format_error_backtrace);
                        genaudit_insert_enchash_wrap
                        (
                        NULL,
                        NULL,
                        NULL,
                        g_application,
                        g_modulename,
                        g_action,
                        'GENERATE_NOTIFICATION others : '||SQLCODE||SQLERRM|| DBMS_UTILITY.format_error_backtrace,
                        m_institutionid,
                        0
                        );
                        COMMIT;

                        IF (m_user_inst_ctr < a_user_institution.LAST AND a_user_institution(m_user_inst_ctr).institution_id = a_user_institution(m_user_inst_ctr + 1).institution_id)
                        THEN
                            m_unhandled_exception := TRUE;
                        ELSE
                            m_unhandled_exception := FALSE;
                        END IF;
                    END;
                END LOOP;
            END IF;
            --END IF;
        EXCEPTION
            WHEN NO_USER_FOUND
            THEN
               -- DBMS_OUTPUT.PUT_LINE('User not found in uuser ' || rec1.user_id);
            NULL;
            WHEN NO_MATCHING_TYPE
            THEN
               -- DBMS_OUTPUT.PUT_LINE('NO_MATCHING_TYPE');
            NULL;
        END;
    END LOOP;
       --DBMS_OUTPUT.PUT_LINE('Procedure Execution Ends');
EXCEPTION
    WHEN OTHERS
    THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('others: '||t_msgdb_id.LAST||SQLCODE||SQLERRM|| DBMS_UTILITY.format_error_backtrace);
        genaudit_insert_enchash_wrap
                               (
                               NULL,
                               NULL,
                               NULL,
                               g_application,
                               g_modulename,
                               g_action,
                               'GENERATE_NOTIFICATION others : '||SQLCODE||SQLERRM|| DBMS_UTILITY.format_error_backtrace,
                               NULL,
                               0
                               );
                               COMMIT;
END;
/
-- [9.06.00.000.03] [20230517] [PTRAMBAKE] [END]
EXIT;