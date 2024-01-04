create or replace PROCEDURE insert_notification_data
(
p_notification_no    IN NUMBER,
p_user_id           IN user_notification_mode.user_id%TYPE,
p_institution_id    IN user_notification_mode.institution_id%TYPE,
p_notification_mode IN user_notification_mode.notification_mode%TYPE,
p_notification_type IN USER_NOTIFICATION_TYPE.notification_type%TYPE,
p_toList            IN NOTIFICATION.TO_LIST%TYPE,
p_ccList            IN NOTIFICATION.CC_LIST%TYPE,
p_subject           IN VARCHAR2,
p_result_blob       IN BLOB,
p_pageinstanceid    IN VARCHAR2 default null,
p_page_parameters   IN VARCHAR2 default null
)
AS

m_application NOTIFICATION.application%TYPE := NULL;

BEGIN
    --DBMS_OUTPUT.PUT_LINE('p_notification_no : '||p_notification_no);

    select  DECODE(NVL(get_originating_system(p_institution_id),'X'),'SAGE','PELICANPAY','X','PELICAN','PELICAN')
    INTO    m_application
    FROM    dual;

    INSERT INTO notification_user
        (
        notification_no,
        user_id,
        notification_read_flag,
        notification_read_datetime,
        notification_sent_flag,
        notification_sent_datetime,
        arch_status,
        arch_date
        )
        VALUES
        (
        p_notification_no,
        p_user_id,
        'UNREAD',
        NULL,
        'NO',
        NULL,
        NULL,
        NULL
        );
        DBMS_OUTPUT.PUT_LINE('record inserted into notification_user');

    INSERT INTO notification
        (
        notification_no,
        notifcation_log_time,
        institutionid,
        application,
        notification_mode,
        alert_type,
        to_list,
        cc_list,
        subject,
        text,
        notification_status,
        notification_read_flag,
        resolution_status,
        arch_status,
        arch_date,
        user_notification_datetime,
        notification_type_id,
        pageinstanceid,
        page_parameters
        )
        VALUES
        (
        p_notification_no,
        SYSTIMESTAMP,
        p_institution_id,
        m_application,
        p_notification_mode,
        'INFO',
        p_toList,
        p_ccList,
        p_subject,
        p_result_blob,
        'UNSENT',
        'UNREAD',
        NULL,
        NULL,
        NULL,
        sysdate,
        p_notification_type,
        p_pageinstanceid,
        p_page_parameters
        );

        DBMS_OUTPUT.PUT_LINE('record inserted into notification');

END;