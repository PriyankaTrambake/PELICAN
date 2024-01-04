set serveroutput on;
set heading off;
set echo off;
Set pages 999;
set long 90000;
spool D:\index_schema_DPH6_2.sql
SELECT DBMS_METADATA.GET_DDL('INDEX',u.object_name)
FROM user_objects u
WHERE object_type = 'INDEX'; --INDEX
 
set serveroutput on;
set heading off;
set echo off;
Set pages 999;
set long 90000;
spool D:\PK_UK_CHECK_schema_DPH6_2.sql
SELECT DBMS_METADATA.GET_DEPENDENT_DDL('CONSTRAINT',c.table_name)
FROM user_constraints C WHERE c.constraint_type IN('P','U','C'); --FOR CONSTRINT OTHER THAN FK


set serveroutput on;
set heading off;
set echo off;
Set pages 999;
set long 90000;
spool D:\FK_schema_DPH6_2.sql
SELECT DBMS_METADATA.GET_DEPENDENT_DDL('REF_CONSTRAINT',c.table_name)
FROM user_constraints C WHERE c.constraint_type IN('R');  --FOR CONSTRINT FK
