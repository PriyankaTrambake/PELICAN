create or replace PROCEDURE dynamic_context
IS
m_sql_command            varchar2(5000)                          := NULL;
m_epoch_time                varchar2(5000)                          := NULL;
m_context_name           varchar2(5000)                          := NULL;
m_insert                 VARCHAR2(3800)                          := NULL;
m_count                   NUMBER :=0;

TYPE a_tenant_name     IS TABLE OF datakeystore.tenant_name%TYPE;
t_tenant_name          a_tenant_name        := a_tenant_name();

b_ctr_start            NUMBER := 0;
b_ctr_end              NUMBER := 0;

BEGIN

select date_to_epoch(sysdate) into m_epoch_time from dual;
DBMS_OUTPUT.PUT_LINE('m_epoch_time ' ||m_epoch_time);

select distinct(tenant_name)
bulk collect
into t_tenant_name
from datakeystore;

b_ctr_start := NVL(t_tenant_name.FIRST,0);
b_ctr_end   := NVL(t_tenant_name.LAST,0);

IF b_ctr_end > 0
THEN 
    FOR i in b_ctr_start..b_ctr_end
    LOOP
        m_context_name := t_tenant_name(i)||m_epoch_time;
        DBMS_OUTPUT.PUT_LINE('m_context_name ' ||m_context_name);

        SELECT COUNT(*) 
        INTO m_count 
        FROM tabledetails 
        WHERE tdidcode='CONTEXT' AND tdkey=t_tenant_name(i);
        DBMS_OUTPUT.PUT_LINE('m_count ' ||m_count);

        IF m_count = 0
        THEN
            m_sql_command := 'CREATE OR REPLACE CONTEXT '||m_context_name||' USING plcn_security_pkg';
            DBMS_OUTPUT.PUT_LINE('m_sql_command ' ||m_sql_command);
            EXECUTE IMMEDIATE m_sql_command;
            INSERT INTO TABLEDETAILS VALUES('CONTEXT',t_tenant_name(i),m_context_name,'V','ADMIN1') ;
            COMMIT;
        ELSE 
            DBMS_OUTPUT.PUT_LINE(' Context is already present for tenant');
        END IF;

    END LOOP;
ELSE
    DBMS_OUTPUT.PUT_LINE('no tenant found in datakeystore');
END IF;

END;