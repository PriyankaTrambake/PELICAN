SQL>   select DBMS_METADATA.GET_DDL('INDEX',u.object_name)
  2   from user_objects u
  3   where object_type = 'INDEX';

                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."MSGALERTS_PK" ON "DPH96QT01"."MSGALERTS" ("MS
GDB_ID", "SRNO")                                                                
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."MSGDB_CHECK_DUPL_CUSTOM44" ON "DPH96QT01"."MSGDB" ("
CUSTOM44")                                                                      
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."IDX_PELPAY_GROUPING" ON "DPH96QT01"."MSGDB" ("INSTAN
CEID", "PROCESS_ID", "QUEUEID", "MESSAGECLASSTYPE", "INSTITUTIONID", "STATUS", "
ACCOUNT_NUMBER")                                                                
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."INSTID_RECORDGRPTP" ON "DPH96QT01"."MSGDB" ("INSTITU
TIONID", "RECORD_GROUP_TYPE")                                                   
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."MESSAGE_NO" ON "DPH96QT01"."MSGDB" ("MESSAGENO")    
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."IDX_MSGDB_ID_OP_BTH" ON "DPH96QT01"."MSGDB" ("MSGDB_
ID_OUTPUT_BATCH")                                                               
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_MSGDB_LINKS" ON "DPH96QT01"."MSGDB_LINKS" 
("MSGDB_ID", "PARENT_ID")                                                       
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_C0016315" ON "DPH96QT01"."ACTIVEINSTANCE"
 ("AI_INSTITUTIONID", "AI_INSTANCEID")                                          
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."MSGBLOCKS_PK" ON "DPH96QT01"."MSGBLOCKS" ("MS
GDB_ID", "MSGBLOCKTYPE")                                                        
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."MSGHDRTLR_PK" ON "DPH96QT01"."MSGHDRTLR" ("MS
GDB_ID", "TYPE", "HDRTLRNO")                                                    
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."MSGDB_OUTPUT_PK" ON "DPH96QT01"."MSGDB_OUTPUT
" ("MSGDB_ID", "MDBOUT_MODE")                                                   
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."IDX_MDBSN_USR_REF" ON "DPH96QT01"."MSGDB_SWIFTNET" (
"MDBSN_USER_REF")                                                               
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."MSGDB_RECGROUPTYPE" ON "DPH96QT01"."MSGDB" ("RECORD_
GROUP_TYPE")                                                                    
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."IDX_EXT_ENC_HASH_CODE" ON "DPH96QT01"."MSGBLOCKS" ("
EXT_ENC_HASH_CODE")                                                             
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."IDX_INST_QUEUE_STATUS" ON "DPH96QT01"."MSGDB" ("INST
ANCEID", "QUEUEID", "STATUS", "PROCESS_ID", "TRANSACTIONTYPE")                  
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."IDX_INT_ENC_HASH_CODE" ON "DPH96QT01"."MSGBLOCKS" ("
INT_ENC_HASH_CODE")                                                             
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000089388C00041$$" ON "DPH96QT01"."MSG
DB_FILE" (                                                                      
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000089393C00051$$" ON "DPH96QT01"."MSG
DB_SWIFTNET" (                                                                  
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."MSGDB_SWIFTNET_IDX_ARCH_DATE" ON "DPH96QT01"."MSGDB_
SWIFTNET" ("ARCH_DATE")                                                         
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."MSGDB_SWIFTNET_IDX_ARCH_STATUS" ON "DPH96QT01"."MSGD
B_SWIFTNET" ("ARCH_STATUS")                                                     
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."MSGDB_BATCH_IDX_ARCH_DATE" ON "DPH96QT01"."MSGDB_BAT
CH" ("ARCH_DATE")                                                               
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."MSGDB_BATCH_IDX_ARCH_STATUS" ON "DPH96QT01"."MSGDB_B
ATCH" ("ARCH_STATUS")                                                           
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."MSGALERTS_IDX_ARCH_STATUS" ON "DPH96QT01"."MSGALERTS
" ("ARCH_STATUS")                                                               
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."MSGALERTS_IDX_ARCH_DATE" ON "DPH96QT01"."MSGALERTS" 
("ARCH_DATE")                                                                   
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."MSGDB_PAY_IDX_ARCH_STATUS" ON "DPH96QT01"."MSGDB_PAY
" ("ARCH_STATUS")                                                               
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."MSGDB_PAY_IDX_ARCH_DATE" ON "DPH96QT01"."MSGDB_PAY" 
("ARCH_DATE")                                                                   
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."MSGDB_FILE_IDX_ARCH_STATUS" ON "DPH96QT01"."MSGDB_FI
LE" ("ARCH_STATUS")                                                             
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."MSGDB_FILE_IDX_ARCH_DATE" ON "DPH96QT01"."MSGDB_FILE
" ("ARCH_DATE")                                                                 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."IDX_OUTFILEFLAG_STATUS" ON "DPH96QT01"."MSGDB_COMMEN
TS" ("OUTPUT_FILE_FLAG", "STATUS")                                              
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."MSGDB_OUTPUT_IDX_ARCH_DATE" ON "DPH96QT01"."MSGDB_OU
TPUT" ("ARCH_DATE")                                                             
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."MSGHDRTLR_IDX_ARCH_STATUS" ON "DPH96QT01"."MSGHDRTLR
" ("ARCH_STATUS")                                                               
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."MSGHDRTLR_IDX_ARCH_DATE" ON "DPH96QT01"."MSGHDRTLR" 
("ARCH_DATE")                                                                   
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."MSGBLOCKS_IDX_ARCH_STATUS" ON "DPH96QT01"."MSGBLOCKS
" ("ARCH_STATUS")                                                               
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."MSGBLOCKS_IDX_ARCH_DATE" ON "DPH96QT01"."MSGBLOCKS" 
("ARCH_DATE")                                                                   
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."MSGDB_IDX_ARCH_STATUS" ON "DPH96QT01"."MSGDB" ("ARCH
_STATUS")                                                                       
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."MSGDB_IDX_ARCH_DATE" ON "DPH96QT01"."MSGDB" ("ARCH_D
ATE")                                                                           
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."MSGDB_ORG_TRGT" ON "DPH96QT01"."MSGDB" ("MSGDB_ID_OR
G", "MSGDB_ID_TARGET")                                                          
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."MSGDB_ORG_QUEUEID" ON "DPH96QT01"."MSGDB" ("MSGDB_ID
_ORG", "QUEUEID")                                                               
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."MSGDB_INSTITUTIONID_QUEUEID" ON "DPH96QT01"."MSGDB" 
("INSTITUTIONID", "QUEUEID")                                                    
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."MSGDB_TRGT_QUEUEID_STATUS" ON "DPH96QT01"."MSGDB" ("
MSGDB_ID_TARGET", "QUEUEID", "STATUS")                                          
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."MSGDB_BATCH_QUEUEID" ON "DPH96QT01"."MSGDB" ("MSGDB_
ID_BATCH", "QUEUEID")                                                           
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."MSGDB_INSTITUTIONID_QID_STATUS" ON "DPH96QT01"."MSGD
B" ("INSTITUTIONID", "QUEUEID", "STATUS")                                       
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."IDX_SOURCEID_RECORDGROUPTYPE" ON "DPH96QT01"."MSGDB"
 ("MSGDB_ID_SOURCE", "RECORD_GROUP_TYPE")                                       
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."MSGDB_IDX_CUSTOMMSGID" ON "DPH96QT01"."MSGDB" ("CUST
OMMSGID")                                                                       
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."IDX_INPUTDATE_TIME" ON "DPH96QT01"."MSGDB" ("INPUTDA
TE"||' '||"INPUTTIME")                                                          
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."IDX_MSGDB_INPUTDATE" ON "DPH96QT01"."MSGDB" ("INPUTD
ATE")                                                                           
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."IDX_MSGDB_USR_DATE_STATUS" ON "DPH96QT01"."MSGDB" (T
O_CHAR("USR_ACTION_DATETIME",'YYYYMMDD'), "USR_ACTION_STATUS")                  
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."IDX_STATUS_TWOPHASECOMMIT_ID" ON "DPH96QT01"."MSGDB"
 ("TWOPHASECOMMIT_ID", "STATUS")                                                
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."INID_QID_RGTPY_MTYPE_PROCESSID" ON "DPH96QT01"."MSGD
B" ("INSTITUTIONID", "QUEUEID", "MESSAGECLASSTYPE", "PROCESS_ID")               
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."IDX_MSGDB_RSRV" ON "DPH96QT01"."MSGDB" ("INSTITUTION
ID", "LOCKEDBY", "RECORD_GROUP_TYPE")                                           
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."IDX_QID_RG_INSTID" ON "DPH96QT01"."MSGDB" ("QUEUEID"
, "RECORD_GROUP_TYPE", "INSTITUTIONID")                                         
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."IDX_QID_RG_INSTID_TRGR" ON "DPH96QT01"."MSGDB" ("QUE
UEID", "RECORD_GROUP_TYPE", "INSTITUTIONID", "TRANSACTIONGROUP")                
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."MSGDB_COMMENTS_PK" ON "DPH96QT01"."MSGDB_COMM
ENTS" ("MSGDB_ID", "MSGDB_ID_CHILD")                                            
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."IDX_PAIN_MAPPING_FILE" ON "DPH96QT01"."MSGDB" ("INST
ITUTIONID", "CUSTOM2", "PRIORITYAMOUNTNUM", "CURRENCY", "MESSAGEDIRECTION", "REC
ORD_GROUP_TYPE")                                                                
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."IDX_RGT_MIB_MIOB" ON "DPH96QT01"."MSGDB" ("RECORD_GR
OUP_TYPE", "MSGDB_ID_BATCH", "MSGDB_ID_OUTPUT_BATCH")                           
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."IDX_PID_PTYPE" ON "DPH96QT01"."MSGDB_LINKS" ("PARENT
_ID", "PARENT_TYPE")                                                            
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."MSGDB_OUTPUT_IDX_ARCH_STATUS" ON "DPH96QT01"."MSGDB_
OUTPUT" ("INSTANCEID", "MDBOUT_STATUS")                                         
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."INSTID_RECORDGRPTP_DASH" ON "DPH96QT01"."MSGDB" ("IN
PUTDATE", "MSGSEGR", "TRANSACTIONGROUP", "RECORD_GROUP_TYPE", "INSTITUTIONID")  
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."ALERTID_PKEY" ON "DPH96QT01"."ALERTMESSAGE" (
"ALERTID")                                                                      
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."ABP_CODE_PK" ON "DPH96QT01"."AML_BANK_PRODUCT
S" ("ABP_CODE")                                                                 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."ABP_INTR_CODE_UK" ON "DPH96QT01"."AML_BANK_PR
ODUCTS" ("ABP_INTR_CODE")                                                       
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."RULETBL2_PK" ON "DPH96QT01"."RULETBL2" ("NAME
", "APPLICATIONID")                                                             
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000089362C00006$$" ON "DPH96QT01"."RUL
ETBL2" (                                                                        
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."RULLIBTBL2_PK" ON "DPH96QT01"."RULLIBTBL2" ("
LIBID", "APPLICATIONID")                                                        
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."RULRULLIBTBL_PK" ON "DPH96QT01"."RULRULLIBTBL
" ("LIBID", "RULENAME", "APPLICATIONID")                                        
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."QUEUE_INSTID_QALIAS" ON "DPH96QT01"."QUEUE" (
"INSTITUTIONID", "ALIASID")                                                     
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."MSGDB_ID_PK" ON "DPH96QT01"."MSGDB" ("MSGDB_I
D")                                                                             
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."DUPLICATE_CHK" ON "DPH96QT01"."MSGDB" ("MESSAGECLASS
TYPE", "MESSAGEDIRECTION", "SENDER", "RECEIVER", "PRIORITYDATE", "CURRENCY", "PR
IORITYAMOUNTNUM", "TRANSREFNO")                                                 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."IDX_QUEUEID_INPUTDT_TM" ON "DPH96QT01"."MSGDB" ("QUE
UEID", "INPUTDATE", "INPUTTIME")                                                
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."IDX_QUEUEID_MSG_TYPE" ON "DPH96QT01"."MSGDB" ("QUEUE
ID", "MESSAGECLASSTYPE")                                                        
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."IDX_QUEUEID_MSG_MODE_IN" ON "DPH96QT01"."MSGDB" ("QU
EUEID", "MSG_MODE_IN")                                                          
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."IDX_QUEUEID_STATUS" ON "DPH96QT01"."MSGDB" ("QUEUEID
", "STATUS")                                                                    
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."IDX_QUEUEID_USER" ON "DPH96QT01"."MSGDB" ("QUEUEID",
 "OPERATOR")                                                                    
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000089383C00004$$" ON "DPH96QT01"."MSG
BLOCKS" (                                                                       
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01MSG"                                                 
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."MSGDB_BATCH_PK" ON "DPH96QT01"."MSGDB_BATCH" 
("MSGDB_ID")                                                                    
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."MSGDB_FILE_PK" ON "DPH96QT01"."MSGDB_FILE" ("
MSGDB_ID")                                                                      
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."MSGDB_PAY_PK" ON "DPH96QT01"."MSGDB_PAY" ("MS
GDB_ID")                                                                        
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."MSGDB_SWIFTNET_PK" ON "DPH96QT01"."MSGDB_SWIF
TNET" ("MSGDB_ID")                                                              
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."IDX_TRANSFER_REF" ON "DPH96QT01"."MSGDB_SWIFTNET" ("
MDBSN_TRANSFER_REF")                                                            
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."MSGEMAILLINK_PK" ON "DPH96QT01"."MSGEMAILLINK
" ("MSGEMAILLINKID")                                                            
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."MSGEMAILLINK_MSGNO" ON "DPH96QT01"."MSGEMAILLINK" ("
MSGNO")                                                                         
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."MSGEMAILLINK_STATUS" ON "DPH96QT01"."MSGEMAILLINK" (
"STATUS")                                                                       
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."AP_NUMBER_PK" ON "DPH96QT01"."AML_PARAMS" ("A
P_NUMBER")                                                                      
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."AP_NAME_UK" ON "DPH96QT01"."AML_PARAMS" ("AP_
NAME")                                                                          
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."AP_ORNO_UK" ON "DPH96QT01"."AML_PARAMS" ("AP_
ORNO")                                                                          
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."ACAI_ACCT_NUMBER_PK" ON "DPH96QT01"."AML_CUST
_ACC_INFO" ("ACAI_ACCT_NUMBER")                                                 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."AARPI_ACCT_CODE_SRNO_PK" ON "DPH96QT01"."AML_
ACCT_RELATED_PARTY_INFO" ("AARPI_ACCT_CODE", "AARPI_SRNO")                      
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."AARPI_ACCT_CODE_RELA_CUST_UK" ON "DPH96QT01".
"AML_ACCT_RELATED_PARTY_INFO" ("AARPI_ACCT_CODE", "AARPI_RELA_CUST")            
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_C0016350" ON "DPH96QT01"."AML_ACC_COMMODI
TY" ("AAC_ACC_NO", "AAC_FUND_NO")                                               
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."AAPI_ACCT_NUMBER_PARAM_CODE_PK" ON "DPH96QT01
"."AML_ACC_PARAM_INFO" ("AAPI_ACCT_NUMBER", "AAPI_PARA_CODE")                   
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."AAPIS_ACCT_NUMBER_PK" ON "DPH96QT01"."AML_ACC
_PARAM_INFO_SUMM" ("AAPIS_ACCT_NUMBER")                                         
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000089496C00002$$" ON "DPH96QT01"."AML
_ACC_PARAM_INFO_SUMM" (                                                         
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."ABD_CODE_PK" ON "DPH96QT01"."AML_BANK_DETAILS
" ("ABD_CODE")                                                                  
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."ABR_CODE_PK" ON "DPH96QT01"."AML_BANK_RELATIO
NSHIP" ("ABR_CODE")                                                             
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."AC_ID_PK" ON "DPH96QT01"."AML_CHANNELS" ("AC_
ID")                                                                            
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."AC_FUND_NO_PK" ON "DPH96QT01"."AML_COMMODITY"
 ("AC_FUND_NO")                                                                 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."ACD_CODE_PK" ON "DPH96QT01"."AML_COUNTRY_DETA
ILS" ("ACD_CODE")                                                               
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."ACC_CODE_PK" ON "DPH96QT01"."AML_CURRENCY_COU
NTRY" ("ACC_CODE")                                                              
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000089518C00003$$" ON "DPH96QT01"."AML
_CUST_PARAM_INFO_SUMM" (                                                        
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."ACRPI_CUST_CODE_RELA_CUST_PK" ON "DPH96QT01".
"AML_CUST_RELATED_PARTY_INFO" ("ACRPI_CUST_CODE", "ACRPI_SRNO")                 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."ACRPI_CUST_CODE_RELA_CUST_UK" ON "DPH96QT01".
"AML_CUST_RELATED_PARTY_INFO" ("ACRPI_CUST_CODE", "ACRPI_RELA_CUST")            
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."APR_NUMBER_PK" ON "DPH96QT01"."AML_RISK_PARAM
S" ("ARP_NUMBER")                                                               
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."APR_NAME_UK" ON "DPH96QT01"."AML_RISK_PARAMS"
 ("ARP_NAME")                                                                   
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."AED_CODE_PK" ON "DPH96QT01"."AML_EMPLOYER_DET
AILS" ("AED_CODE")                                                              
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."AML_EXCHANGE_RATE_INFO" ON "DPH96QT01"."AML_E
XCHANGE_RATE_INFO" ("AERI_CURY_CODE1", "AERI_CURY_CODE2", "AERI_RATE_TYPE", "AER
I_RATE_DATE")                                                                   
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."AID_CODE_PK" ON "DPH96QT01"."AML_INSTRUMENT_D
ETAILS" ("AID_CODE")                                                            
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."APPG_PROD_GROUP_PK" ON "DPH96QT01"."AML_PRODU
CT_PARAM_GROUP" ("APPG_PROD_CODE", "APPG_CODE")                                 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."APPG_PROD_GROUP_NAME_UK" ON "DPH96QT01"."AML_
PRODUCT_PARAM_GROUP" ("APPG_PROD_CODE", "APPG_NAME")                            
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."APPGP_PROD_GROUP_SRNO_PK" ON "DPH96QT01"."AML
_PRODUCT_PARAM_GROUP_PARAM" ("APPGP_PROD_CODE", "APPGP_GROUP_CODE", "APPGP_SRL_N
UMB")                                                                           
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."APPGP_PROD_PARAM_UK" ON "DPH96QT01"."AML_PROD
UCT_PARAM_GROUP_PARAM" ("APPGP_PROD_CODE", "APPGP_PARAM_CODE")                  
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             

  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."ARD_REF_TYPE_REF_CODE_PK" ON "DPH96QT01"."AML
_RCT_DETAILS" ("ARD_REF_TYPE", "ARD_REF_CODE")                                  
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."ARPF_CODE_PK" ON "DPH96QT01"."AML_RISK_PROFIL
E" ("ARPF_CODE")                                                                
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."ARPF_INTR_CODE_UK" ON "DPH96QT01"."AML_RISK_P
ROFILE" ("ARPF_INTR_CODE")                                                      
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."AML_TRANSACTIONS_PK" ON "DPH96QT01"."AML_TRAN
SACTIONS" ("AT_TRAN_ID", "AT_PART_TRAN_ID", "AT_TRAN_DATE")                     
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."GLOBALINFO_PK" ON "DPH96QT01"."GLOBALINFO" ("
ANALYSISID")                                                                    
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."ANALYSISDETAILS_PK" ON "DPH96QT01"."ANALYSISD
ETAILS" ("ANALYSISID", "ANALYSISTYPE")                                          
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000089485C00095$$" ON "DPH96QT01"."AML
_CUST_INFO" (                                                                   
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000089485C00098$$" ON "DPH96QT01"."AML
_CUST_INFO" (                                                                   
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."MESSAGESTATS_PK" ON "DPH96QT01"."MESSAGESTATS
" ("ANALYSISID", "ANALYSISTYPE", "ANALYSISCODE", "MSGTYPE", "FILTERCODEFORVIO") 
                                                                                
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."FIELDSTATS_PK" ON "DPH96QT01"."FIELDSTATS" ("
ANALYSISID", "ANALYSISTYPE", "ANALYSISCODE", "MSGTYPE", "FILTERCODEFORVIO", "FIE
LDNO")                                                                          
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SELECTION_PK" ON "DPH96QT01"."SELECTION" ("SE
LECTIONTYPE", "ANALYSISID", "SELECTIONCODE")                                    
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."ANALYSISID" ON "DPH96QT01"."SELECTION" ("ANALYSISID"
)                                                                               
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SEVRTYTBL_PK" ON "DPH96QT01"."SEVRTYTBL" ("SE
VERITY")                                                                        
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."STPANLY_PK" ON "DPH96QT01"."STPANLY" ("MESSAG
EID")                                                                           
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000089566C00016$$" ON "DPH96QT01"."STP
ANLY" (                                                                         
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."IDX_COUNTRY" ON "DPH96QT01"."STPANLY" ("COUNTRYCODE"
)                                                                               
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."IDX_CURRENCY" ON "DPH96QT01"."STPANLY" ("CURRENCY") 
                                                                                
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."IDX_MESSAGEDATE" ON "DPH96QT01"."STPANLY" ("MESSAGED
ATE")                                                                           
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."IDX_MESSAGEDIRECTION" ON "DPH96QT01"."STPANLY" ("MES
SAGEDIRECTION")                                                                 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."IDX_CORRESPONDENT" ON "DPH96QT01"."STPANLY" ("CORRES
PONDENT")                                                                       
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."VIOLATIONSTATS_PK" ON "DPH96QT01"."VIOLATIONS
TATS" ("ANALYSISID", "ANALYSISTYPE", "ANALYSISCODE", "MSGTYPE", "FILTERCODEFORVI
O", "FIELDNO", "VIOLATIONNO")                                                   
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."VIOLNTBL_PK" ON "DPH96QT01"."VIOLNTBL" ("VIOL
ATIONNO", "DIRECTION")                                                          
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."APPLICATION_PK" ON "DPH96QT01"."APPLICATION" 
("APPLICATIONID")                                                               
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."APPLICATIONATTRIBUTE_PK" ON "DPH96QT01"."APPL
ICATIONATTRIBUTE" ("ATTRIBUTEID", "APPLICATIONID")                              
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."APPLICATIONCONFIG_PK" ON "DPH96QT01"."APPLICA
TIONCONFIG" ("APPLICATION", "CONFIGSECTION", "CONFIGKEY", "INSTITUTIONID")      
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."APPLICATIONINSTANCE_PK" ON "DPH96QT01"."APPLI
CATIONINSTANCE" ("APPLICATIONINSTANCEID", "INSTITUTIONID")                      
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."APPLICATIONINSTANCEMAP_PK" ON "DPH96QT01"."AP
PLICATIONINSTANCEMAP" ("APPLICATIONINSTANCEID", "INSTITUTIONID")                
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."GENAUDIT_IDX_ARCH_STATUS" ON "DPH96QT01"."GENAUDIT" 
("ARCH_STATUS")                                                                 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."GENAUDIT_IDX_ARCH_DATE" ON "DPH96QT01"."GENAUDIT" ("
ARCH_DATE")                                                                     
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."AUDITDATETIME_SEQUENCENO" ON "DPH96QT01"."GENAUDIT" 
("AUDITDATETIME", "SEQUENCENO")                                                 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."GENAUDIT_IDX_MESSAGENO" ON "DPH96QT01"."GENAUDIT" ("
MESSAGENO")                                                                     
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SWIFT_PK" ON "DPH96QT01"."SWIFT" ("SWIFTID") 
                                                                                
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_BICPLUSDB" ON "DPH96QT01"."BICPLUSDB" ("BI
CPLUSKEY")                                                                      
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."IDX_BICPLUSDB_INSTCITY" ON "DPH96QT01"."BICPLUSDB" (
"INSTITUTIONNAME", "CITYNAME")                                                  
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."IDX_BICPLUSDB_INSTCOUNTRY" ON "DPH96QT01"."BICPLUSDB
" ("INSTITUTIONNAME", "COUNTRY")                                                
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."IDX_BICPLUSDB_NIDISOCCODE" ON "DPH96QT01"."BICPLUSDB
" ("NATIONALID", "ISOCOUNTRYCODE")                                              
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."IDX_BICPLUSDB_BICCODE" ON "DPH96QT01"."BICPLUSDB" ("
BICCODE")                                                                       
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."IDX_BICPLUSDB_IDXKEY1" ON "DPH96QT01"."BICPLUSDB" ("
IDXKEY1")                                                                       
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."IDX_BICPLUSDB_IDXKEY2" ON "DPH96QT01"."BICPLUSDB" ("
IDXKEY2")                                                                       
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."IDX_BICPLUSDB_IDXKEY3" ON "DPH96QT01"."BICPLUSDB" ("
IDXKEY3")                                                                       
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."IDX_BICPLUSDB_IDXKEY4" ON "DPH96QT01"."BICPLUSDB" ("
IDXKEY4")                                                                       
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."IDX_BICPLUSDB_IDXKEY5" ON "DPH96QT01"."BICPLUSDB" ("
IDXKEY5")                                                                       
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_C0016484" ON "DPH96QT01"."INSTITUTION_INF
O" ("SERIALNUMBER")                                                             
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_C0016490" ON "DPH96QT01"."INSTITUTION_OTH
ERNAME" ("SERIALNUMBER", "SEQUENCENO")                                          
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_C0016497" ON "DPH96QT01"."INSTITUTION_COD
E" ("SERIALNUMBER", "CODENAME")                                                 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."IDX_INSTINFO_KEYVAL_SRC_BDPKEY" ON "DPH96QT01
"."INSTITUTION_INFO" ("SOURCE", "KEYVALUE", "BDPKEY")                           
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."BILLINGSTATSINFO_PK" ON "DPH96QT01"."BILLINGS
TATSINFO" ("MESSAGEDATE", "DIRECTION", "CORRESPONDENT", "CURR", "PAYMENTSYSTEM",
 "CATEGORY", "MESSAGETYPE")                                                     
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."BILLINGSTATSMAIN_PK" ON "DPH96QT01"."BILLINGS
TATSMAIN" ("CORRESPONDENT", "CURR", "PAYMENTSYSTEM", "CATEGORY", "MESSAGETYPE") 
                                                                                
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."BILLPROFTBL_PK" ON "DPH96QT01"."BILLPROFTBL" 
("BILLPROFID")                                                                  
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."BILLPROFCORRTBL_PK" ON "DPH96QT01"."BILLPROFC
ORRTBL" ("CORRESPONDENT", "DIRECTION")                                          
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."BILLPROFSEVTBL_PK" ON "DPH96QT01"."BILLPROFSE
VTBL" ("BILLPROFID", "SEVERITY")                                                
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SWFNT_SAG_KEYS_PK" ON "DPH96QT01"."SWFNT_SAG_
KEYS" ("MODE_TYPE", "SAG_ID")                                                   
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."CL_CLGSYS_PK" ON "DPH96QT01"."CL_CLGSYS" ("CL
_CLGSYS_ID", "CL_INSTITUTIONID")                                                
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."ST_STREAM_PK" ON "DPH96QT01"."ST_STREAM" ("ST
_STREAMID", "INSTITUTIONID")                                                    
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000089632C00011$$" ON "DPH96QT01"."ST_
STREAM" (                                                                       
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."CHL_HOLIDAY_PK" ON "DPH96QT01"."CHL_HOLIDAY" 
("CHL_CLGSYS_ID", "CHL_INSTITUTIONID", "CHL_HOLIDAY_DATE")                      
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."CH_CHANNEL_PK" ON "DPH96QT01"."CH_CHANNEL" ("
CH_CHANNEL_ID", "CH_INSTITUTIONID")                                             
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."CURRENCY_PK" ON "DPH96QT01"."CURRENCYINFO" ("
CURRENCYCODE")                                                                  
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."ER_EXCHG_RATE_PK" ON "DPH96QT01"."ER_EXCHANGE
_RATE" ("ER_CURR_CODE", "ER_DATE")                                              
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."CTRY_PK" ON "DPH96QT01"."CTRYDB" ("CTRYCODE")
                                                                                
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."CITYKEY" ON "DPH96QT01"."CITY" ("CITYCODE", "
COUNTRYCODE")                                                                   
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."LEXKEY" ON "DPH96QT01"."CITY" ("LEXICONID")         
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."ENHCRTRMAPPINGREC_PK" ON "DPH96QT01"."ENHCRTR
MAPPINGREC" ("APPLICATIONID", "ID", "STANDARD", "RELEASE")                      
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."COMPONENTRECORD_PK" ON "DPH96QT01"."COMPONENT
RECORD" ("ID", "STANDARD", "RELEASE")                                           
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."COMPRECORD_COMPONENTNAMEKEY" ON "DPH96QT01"."
COMPONENTRECORD" ("COMPONENTNAME", "STANDARD", "RELEASE")                       
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."COMPRECORD_COMPONENTTYPEKEY" ON "DPH96QT01"."COMPONE
NTRECORD" ("COMPONENTTYPE", "ID", "STANDARD", "RELEASE")                        
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."COMPRECORD_STANDARDTYPEKEY" ON "DPH96QT01"."COMPONEN
TRECORD" ("STANDARD", "COMPONENTTYPE", "ID", "RELEASE")                         
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."COMPONENTRECORD_RELEASETYPEKEY" ON "DPH96QT01"."COMP
ONENTRECORD" ("RELEASE", "COMPONENTTYPE", "ID", "STANDARD")                     
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."COMPONENTRECORD_BUSINESSKEY" ON "DPH96QT01"."COMPONE
NTRECORD" ("BUSINESSCLASSID", "BUSINESSELEMENTID", "BUSINESSROLEID")            
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."COMPONENTRECORD_COMPONENTNAME" ON "DPH96QT01"."COMPO
NENTRECORD" ("COMPONENTNAME")                                                   
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."ENHCRTRMSGRECORD_PK" ON "DPH96QT01"."ENHCRTRM
SGRECORD" ("APPLICATIONID", "ID", "STANDARD", "RELEASE", "MSGINSTANCENAME", "INO
UTMSGFLAG")                                                                     
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."MSGPATHREC_PK" ON "DPH96QT01"."MESSAGEPATHREC
ORD" ("PATHID")                                                                 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."MSGPATHIDX" ON "DPH96QT01"."MESSAGEPATHRECORD" ("MSG
ID", "MSGSTANDARD", "MSGRELEASE")                                               
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."ASSIGNCODELISTRECORD_PK" ON "DPH96QT01"."ASSI
GNCODELISTRECORD" ("PATHID")                                                    
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."BUSI_CLASS_DOMAIN_PK" ON "DPH96QT01"."BUSI_CL
ASS_DOMAIN" ("TYPE", "ID", "STANDARD", "RELEASE")                               
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."BUSI_FRMT" ON "DPH96QT01"."BUSI_FRMT" ("ID", 
"STANDARD", "RELEASE")                                                          
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."CODEQUALVALREC_PK" ON "DPH96QT01"."CODEQUALIF
IERVALIDATIONRECORD" ("PATHID", "DEPENDENTPATHID", "PRIMARYCODEID", "DEPENDENTCO
DEID")                                                                          
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."CODERECORD_CRCODENO" ON "DPH96QT01"."CODERECO
RD" ("CRCODENO")                                                                
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."CODEUSEDBYRECORD_KEY" ON "DPH96QT01"."CODEUSEDBYRECO
RD" ("CRCODENO")                                                                
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."IBE_ID_PK" ON "DPH96QT01"."IDENT_BUSI_ELEM" (
"ID")                                                                           
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."ID_BU_ELE_UK" ON "DPH96QT01"."IDENT_BUSI_ELEM
" ("TYPE", "NAME", "STANDARD", "RELEASE")                                       
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."ELEM_FRMT_LNK_PK" ON "DPH96QT01"."ELEM_FRMT_L
NK" ("ID", "FRMTID", "STANDARD", "RELEASE", "ORDERNO")                          
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."ELE_DOMAIN_MAP_PK" ON "DPH96QT01"."ELE_DOMAIN
_MAP" ("ID", "DOMAINID", "DOMAINSTANDARD", "DOMAINRELEASE")                     
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."FLDMAPRCRD_PK" ON "DPH96QT01"."FIELDMAPRECORD
" ("APPLICATIONID", "ID", "STANDARD", "RELEASE", "MAPPINGID")                   
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."FIELDMAPRECORD_FLDMAPKEY" ON "DPH96QT01"."FIELDMAPRE
CORD" ("APPLICATIONID", "ID", "STANDARD", "RELEASE", "OPMSGINSTNAME", "OUTPUTMSG
PATHID", "ORDERNO")                                                             
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."FLDMAPIP_PK" ON "DPH96QT01"."FIELDMAPINPUTPAR
AMETERS" ("APPLICATIONID", "ID", "STANDARD", "RELEASE", "MAPPINGID", "PARAMETERN
O")                                                                             
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."FIELDMAPINPUTPARAMS_INFLDKEY" ON "DPH96QT01"."FIELDM
APINPUTPARAMETERS" ("APPLICATIONID", "ID", "STANDARD", "RELEASE", "MAPPINGID", "
PARAMETERNO", "TYPE")                                                           
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."FMAPRCRD_PK" ON "DPH96QT01"."FLDMAPRECORD" ("
FMTRANSLATORID", "FMSTANDARD", "FMRELEASE", "FMMAPPINGID")                      
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."FMIPPRCRD_PK" ON "DPH96QT01"."FLDMAPINPUTPARA
MSRECORD" ("FMIPTRANSLATORID", "FMIPSTANDARD", "FMIPRELEASE", "FMIPMAPPINGID", "
FMIPORDERNO")                                                                   
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."FLDMAPINPUTPARAMSREC_INFLDKEY" ON "DPH96QT01"."FLDMA
PINPUTPARAMSRECORD" ("FMIPTRANSLATORID", "FMIPSTANDARD", "FMIPRELEASE", "FMIPINP
UTMSGNAMES")                                                                    
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."FLDRCRD_PK" ON "DPH96QT01"."FMTRECORD" ("FMTI
D", "FMTSTANDARD", "FMTRELEASE")                                                
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."FMVALDTREC_PK" ON "DPH96QT01"."FMTVALIDATEFNR
EC" ("FMTVALID", "FMTVALSTANDARD", "FMTVALRELEASE", "FMTVALIDATEFNORDERNO")     
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."FREEZEDBYRECORD_KEY" ON "DPH96QT01"."FREEZEDBYRECORD
" ("PARENTCOMPID", "PARENTCOMPSTANDARD", "PARENTCOMPRELEASE")                   
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."FRMT_FAM_MAP_PK" ON "DPH96QT01"."FRMT_FAM_MAP
" ("ID", "STANDARD", "RELEASE", "FAMILYID")                                     
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."FRMT_FRMT_LNK_PK" ON "DPH96QT01"."FRMT_FRMT_L
NK" ("PARENTFRMTID", "PARENTFRMTSTANDARD", "PARENTFRMTRELEASE", "CHILDFRMTID", "
CHILDFRMTSTANDARD", "CHILDFRMTRELEASE", "ORDERNO")                              
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."GVREC_TRANS_PK" ON "DPH96QT01"."GLOBVARRECORD
" ("GVTRANSLATORID", "GVSTANDARD", "GVRELEASE", "GVNAME")                       
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."GVMP_TRANSID_PK" ON "DPH96QT01"."GLOBVARMSGPA
RAMS" ("GVMPTRANSLATORID", "GVMPSTANDARD", "GVMPRELEASE", "GVMPNAME", "GVMPORDER
NO")                                                                            
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."MSG_BUSI_ELEM_MAP_PK" ON "DPH96QT01"."MSG_BUS
I_ELEM_MAP" ("ID", "MSGCOMPPATHID")                                             
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."MSG_BUSI_FRMT_MAP_PK" ON "DPH96QT01"."MSG_BUS
I_FRMT_MAP" ("FRMTID", "STANDARD", "RELEASE", "MSGCOMPPATHID", "QUALIFIER")     
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."STDMASTER_PK" ON "DPH96QT01"."STDMASTER" ("ST
DID")                                                                           
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."RELEASE_MASTER_STDID_RELID" ON "DPH96QT01"."R
ELMASTER" ("STDID", "RELID")                                                    
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SEQMAPREC_PK" ON "DPH96QT01"."SEQMAPRECORD" (
"SMTRANSLATORID", "SMSTANDARD", "SMRELEASE", "SMMAPPINGID")                     
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SEQUENCEMAPREC_PK" ON "DPH96QT01"."SEQUENCEMA
PRECORD" ("APPLICATIONID", "ID", "STANDARD", "RELEASE", "MAPPINGID")            
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."SEQMAPRECORD_SEQMAPKEY" ON "DPH96QT01"."SEQUENCEMAPR
ECORD" ("APPLICATIONID", "ID", "STANDARD", "RELEASE", "OPMSGINSTNAME", "OUTPUTMS
GPATHID", "ORDERNO")                                                            
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SEQMAPIPPARAM_ID_PK" ON "DPH96QT01"."SEQMAPIN
PUTPARAMETERS" ("APPLICATIONID", "ID", "STANDARD", "RELEASE", "MAPPINGID", "PARA
METERNO")                                                                       
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."SEQMAPINPUTPARAMETERS_INSEQKEY" ON "DPH96QT01"."SEQM
APINPUTPARAMETERS" ("APPLICATIONID", "ID", "STANDARD", "RELEASE", "MAPPINGID", "
PARAMETERNO", "TYPE")                                                           
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SEQMAPIPPARAMREC_PK" ON "DPH96QT01"."SEQMAPIN
PUTPARAMSRECORD" ("SMIPTRANSLATORID", "SMIPSTANDARD", "SMIPRELEASE", "SMIPMAPPIN
GID", "SMIPORDERNO")                                                            
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SUBCOMPREC_PK" ON "DPH96QT01"."SUBCOMPONENTRE
CORD" ("CMPID", "CMPSTANDARD", "CMPRELEASE", "SEQNO")                           
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."SUBCOMPONENTRECORD_ORDERNO" ON "DPH96QT01"."SUBCOMPO
NENTRECORD" ("CMPID", "CMPSTANDARD", "CMPRELEASE", "SCORDERNO")                 

  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SUBCOMPVALREC_PK" ON "DPH96QT01"."SUBCOMPONEN
TVALIDATEREC" ("VALCMPID", "VALCMPSTANDARD", "VALCMPRELEASE", "VALSEQNO", "VALVA
LIDATEFNORDERNO")                                                               
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."TMR_TMTRANSID_PK" ON "DPH96QT01"."TRANSLATORM
SGRECORD" ("TMTRANSLATORID", "TMSTANDARD", "TMRELEASE", "TMMSGTYPE", "TMMSGNAME"
)                                                                               
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."TRANSMSGREC_TRANSMSGORDERKEY" ON "DPH96QT01"."TRANSL
ATORMSGRECORD" ("TMTRANSLATORID", "TMSTANDARD", "TMRELEASE", "TMMSGTYPE", "TMORD
ERNO", "TMMSGNAME")                                                             
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."TMIR_TRANSID_PK" ON "DPH96QT01"."TRANSLATORMS
GINSTANCEREC" ("TMITRANSLATORID", "TMISTANDARD", "TMIRELEASE", "TMIMSGTYPE", "TM
IMSGNAME", "TMIINSTANCENO")                                                     
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."TRANSLATORRECORD_TRANSLATORKEY" ON "DPH96QT01
"."TRANSLATORRECORD" ("TRTRANSLATORID", "TRSTANDARD", "TRRELEASE")              
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."TRANSUSEDBYREC_TRANSUSEDBYKEY" ON "DPH96QT01"
."TRANSUSEDBYRECORD" ("TRANSLATORID", "TRANSLATORSTD", "TRANSLATORREL", "TUID", 
"TUSTANDARD", "TURELEASE")                                                      
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."VALMASTER_PK" ON "DPH96QT01"."VALIDATIONMASTE
R" ("VALIDATIONID")                                                             
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."VALLIST_PK" ON "DPH96QT01"."VALIDATIONLIST" (
"VALIDATIONID", "SEQUENCENO")                                                   
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."UK_VALIDATIONLIST" ON "DPH96QT01"."VALIDATION
LIST" ("VALIDATIONID", "VALIDATIONVALUE")                                       
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_CODEUSEDBYRECORD" ON "DPH96QT01"."CODEUSED
BYRECORD" ("CUID", "CUSTANDARD", "CURELEASE", "CRCODENO")                       
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_FREEZEDBYRECORD" ON "DPH96QT01"."FREEZEDBY
RECORD" ("PARENTCOMPID", "PARENTCOMPSTANDARD", "PARENTCOMPRELEASE", "FREEZEDBY",
 "FREEZEDBYCOMPID", "FREEZEDBYCOMPSTANDARD", "FREEZEDBYCOMPRELEASE")            
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."BPMPATTERNMASTER_PK" ON "DPH96QT01"."BPMPATTE
RNMASTER" ("BPMPATTERNID")                                                      
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PROFILETBL_PK" ON "DPH96QT01"."PROFILETBL" ("
PROFILEID")                                                                     
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."BPMPATTERNCOMPONENT_PK" ON "DPH96QT01"."BPMPA
TTERNCOMPONENT" ("BPMPATTERNID", "FIELDNAME")                                   
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."CLIENTAP_PK" ON "DPH96QT01"."CLIENTAP" ("RECO
RDID")                                                                          
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."ENHCRTRMSGRECORD_ORDERNO" ON "DPH96QT01"."ENHCRTRMSG
RECORD" ("APPLICATIONID", "ID", "STANDARD", "RELEASE", "MSGINSTANCENAME", "INOUT
MSGFLAG", "ORDERNO")                                                            
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."ENHCRTRGENTABLERECORD_PK" ON "DPH96QT01"."ENH
CRTRGENTABLERECORD" ("APPLICATIONID", "ID", "STANDARD", "RELEASE", "TYPE", "NAME
")                                                                              
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."ENHCRTRGLOBVARRECORD_PK" ON "DPH96QT01"."ENHC
RTRGLOBVARRECORD" ("APPLICATIONID", "ID", "STANDARD", "RELEASE", "GLOBVARNAME") 
                                                                                
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."ENHCRTRINSTANCEMAPINFO_PK" ON "DPH96QT01"."EN
HCRTRINSTANCEMAPINFO" ("APPLICATIONID", "ID", "STANDARD", "RELEASE", "MSGINSTANC
ENAME", "INOUTMSGFLAG", "ORDERNO")                                              
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PRODUCTS_PK" ON "DPH96QT01"."PRODUCTS" ("PROD
UCT_ID")                                                                        
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PRODPROFILESCANFIELDS_PK" ON "DPH96QT01"."PRO
DPROFILESCANFIELDS" ("PROFILEID", "PRODUCTID", "SCANFIELDID")                   
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PRODUCTDETAILS_PK" ON "DPH96QT01"."PRODUCTDET
AILS" ("PRODUCTID", "ENTRYTYPE", "ENTRYKEY")                                    
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PROFILESERVICEDTLSTBL_PK" ON "DPH96QT01"."PRO
DUCTPROFILESERVICEDTLSTBL" ("PROFILEID", "PRODUCTID", "SERVICEID", "ENTRYTYPE", 
"ENTRYKEY")                                                                     
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SSIMASTER_PK" ON "DPH96QT01"."SSIMASTER" ("RE
CORDID")                                                                        
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."CONCEPTMASTER_PK" ON "DPH96QT01"."CONCEPTMAST
ER" ("CONCEPTID")                                                               
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."DICTTYPE_PK" ON "DPH96QT01"."DICTTYPE" ("DICT
IONARYID")                                                                      
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."IDX_DICTTYPE_NAME" ON "DPH96QT01"."DICTTYPE" 
("NAME")                                                                        
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PATTERNMASTER_PK" ON "DPH96QT01"."PATTERNMAST
ER" ("PATTERNID")                                                               
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."IDX_PATTERNMASTER" ON "DPH96QT01"."PATTERNMAS
TER" ("PATTERNNAME")                                                            
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."IDX_ORIGINALPATTERNID" ON "DPH96QT01"."PATTERN" ("OR
IGINALPATTERNID")                                                               
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."EMAIL_MAIN_PK" ON "DPH96QT01"."EMAIL_MAIN" ("
EMM_APPLICATION_ID", "EMM_MAIL_ID")                                             
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000089785C00006$$" ON "DPH96QT01"."EMA
IL_MAIN" (                                                                      
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."EMAIL_ATTACHMENTS_PK" ON "DPH96QT01"."EMAIL_A
TTACHMENTS" ("EMA_APPLICATION_ID", "EMA_MAIL_ID", "EMA_SRNO", "EMA_FILENAME")   
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000089789C00005$$" ON "DPH96QT01"."EMA
IL_ATTACHMENTS" (                                                               
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."EMAIL_FOLDER_PK" ON "DPH96QT01"."EMAIL_FOLDER
S" ("EMF_USERID", "EMF_FOLDERID")                                               
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."EMAIL_USER_PK" ON "DPH96QT01"."EMAIL_USERS" (
"EMU_APPLICATION_ID", "EMU_MAIL_ID", "EMU_LINK_TYPE", "EMU_USERID")             
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."ENVDB_PK" ON "DPH96QT01"."ENVDB" ("ENID", "EN
STANDARD", "ENRELEASE")                                                         
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000089797C00004$$" ON "DPH96QT01"."ENV
DB" (                                                                           
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."LANG_PK" ON "DPH96QT01"."LANG" ("LANGCODE")  
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."LANGDESC_PK" ON "DPH96QT01"."LANGDESC" ("LANG
CODE", "MODULECODE", "ITEMNO")                                                  
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."MODULECODE_ITEMNO" ON "DPH96QT01"."LANGDESC" ("MODUL
ECODE", "ITEMNO")                                                               
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_FAMILYRECORD" ON "DPH96QT01"."FAMILYRECORD
" ("FAFAMILYID")                                                                
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."FAMILYMSGRECORD_FMMSGKEY" ON "DPH96QT01"."FAM
ILYMSGRECORD" ("FMMSGID", "FMMSGSTANDARD", "FMMSGRELEASE")                      
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."FAMILYMSGRECORD_FMMSGFAMILYID" ON "DPH96QT01"."FAMIL
YMSGRECORD" ("FMMSGFAMILYID")                                                   
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_FAMILYMSGRECORD" ON "DPH96QT01"."FAMILYMSG
RECORD" ("FMMSGID", "FMMSGSTANDARD", "FMMSGRELEASE", "FMMSGFAMILYID")           
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."AML_CASE_USERS_PK" ON "DPH96QT01"."AML_CASE_U
SERS" ("ACU_APPLICATION_ID", "ACU_CASE_ID", "ACU_USER_ID", "ACU_INSTITUTIONID") 
                                                                                
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."AML_CASE_TRANSACTION_PK" ON "DPH96QT01"."AML_
CASE_TRANSACTION" ("ACT_APPLICATION_ID", "ACT_CASE_ID", "ACT_TRAN_ID", "ACT_INST
ITUTIONID")                                                                     
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."AML_CASE_MANAGEMENT_PK" ON "DPH96QT01"."AML_C
ASE_MANAGEMENT" ("ACM_APPLICATION_ID", "ACM_CASE_ID", "ACM_INSTITUTIONID")      
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."ACI_CUST_CODE_PK" ON "DPH96QT01"."AML_CUST_IN
FO" ("ACI_CUST_TYPE", "ACI_CUST_CODE", "ACI_INSTITUTIONID")                     
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."ACPI_CUST_TYPE_CODE_PARAM_PK" ON "DPH96QT01".
"AML_CUST_PARAM_INFO" ("ACPI_CUST_TYPE", "ACPI_CUST_CODE", "ACPI_PARA_CODE", "AC
PI_INSTITUTIONID")                                                              
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."ACPIS_CUST_TYPE_CODE_PK" ON "DPH96QT01"."AML_
CUST_PARAM_INFO_SUMM" ("ACPIS_CUST_TYPE", "ACPIS_CUST_CODE", "ACPIS_INSTITUTIONI
D")                                                                             
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."ACRI_CUST_CODE_PARCD_PK" ON "DPH96QT01"."AML_
CUST_RISK_INFO" ("ACRI_CUST_TYPE", "ACRI_CUST_CODE", "ACRI_CUST_PARCD", "ACRI_IN
STITUTIONID")                                                                   
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."CUST_CONTACT_PK" ON "DPH96QT01"."CUST_CONTACT
" ("ACI_CUST_TYPE", "ACI_CUST_CODE", "ACI_CONTACT_SR_NO", "ACI_INSTITUTIONID")  
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_FIELD_VIOLATIONS" ON "DPH96QT01"."FIELD_VI
OLATIONS" ("MSGDB_ID", "FIELD_NO", "VIOLATION_NO")                              
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."FIELD_VIO_IDX_ARCH_STATUS" ON "DPH96QT01"."FIELD_VIO
LATIONS" ("ARCH_STATUS")                                                        
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."FIELD_VIO_IDX_ARCH_DATE" ON "DPH96QT01"."FIELD_VIOLA
TIONS" ("ARCH_DATE")                                                            
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."FIELD_VIO_IDX_MSGDB_ID" ON "DPH96QT01"."FIELD_VIOLAT
IONS" ("MSGDB_ID")                                                              
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."INSTITUTIONNAME_UNIQUE" ON "DPH96QT01"."INSTI
TUTIONMASTER" ("INSTITUTIONNAME")                                               
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."INSTITUTIONPARAMETERS_PKEY" ON "DPH96QT01"."I
NSTITUTIONPARAMETERS" ("INSTITUTIONID", "PATH", "PARAMNAME")                    
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."INSTITUTION_PRODUCT_UNIQUE" ON "DPH96QT01"."I
NSTITUTIONPRODUCTLICENSE" ("INSTITUTIONID", "PRODUCTID")                        
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_INSTITUTIONINFO" ON "DPH96QT01"."INSTITUTI
ONINFO" ("PATH")                                                                
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_INSTITUTIONHIERARCHY" ON "DPH96QT01"."INST
ITUTIONHIERARCHY" ("PARENTINSTITUTION", "CHILDINSTITUTION")                     
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_INST_PARAM_MAP" ON "DPH96QT01"."INSTITUTIO
NPARAMETERS_MAP" ("INSTITUTIONID", "LABEL", "KEY", "VALUE")                     
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."LIBRARYMSGRECORD_LBMSGKEY" ON "DPH96QT01"."LI
BRARYMSGRECORD" ("LBMSGID", "LBMSGRELEASE", "LBMSGSTANDARD", "LBMSGLIBRARYID", "
LBMSGLIBRELEASE", "LBMSGLIBSTANDARD")                                           
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."LIBRARYMSGRECORD_LBLIBMSGKEY" ON "DPH96QT01"."LIBRAR
YMSGRECORD" ("LBMSGLIBRARYID", "LBMSGLIBRELEASE", "LBMSGLIBSTANDARD")           
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."LIBRARYRECORD_LBKEY" ON "DPH96QT01"."LIBRARYR
ECORD" ("LBLIBRARYID", "LBRELEASE", "LBSTANDARD")                               
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_LOCATIONDETAILS" ON "DPH96QT01"."LOCATIOND
ETAILS" ("LOCATIONID", "INSTITUTIONID")                                         
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."NOTESREC_PK" ON "DPH96QT01"."NOTESREC" ("MESS
AGENO", "NOTENO", "INSTITUTIONID")                                              
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."NOTESREC_IDX_ARCH_STATUS" ON "DPH96QT01"."NOTESREC" 
("ARCH_STATUS")                                                                 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."NOTESREC_IDX_ARCH_DATE" ON "DPH96QT01"."NOTESREC" ("
ARCH_DATE")                                                                     
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SDNSOURCE_PK" ON "DPH96QT01"."SDNSOURCE" ("SO
URCENAME")                                                                      
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."ACCEPTDENYPHRASETABLE_PK" ON "DPH96QT01"."ACC
EPTDENYPHRASETABLE" ("PHRASEID")                                                
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."ACCEPTDENYPHRASEPATTERN_PK" ON "DPH96QT01"."A
CCEPTDENYPHRASEPATTERN" ("PHRASEID", "PATTERNORDERNO")                          
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SDNMASTER_PK" ON "DPH96QT01"."SDNMASTER" ("SD
NID")                                                                           
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SOURCENAME_SOURCEID" ON "DPH96QT01"."SDNMASTE
R" ("SOURCENAME", "SOURCEID")                                                   
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."SDNMASTER_SDNID_SOURCENAME" ON "DPH96QT01"."SDNMASTE
R" ("SDNID", "SOURCENAME")                                                      
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SDNADDRESS_PK" ON "DPH96QT01"."SDNADDRESS" ("
SDNID", "ADDRESSID")                                                            
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SDNALIAS_PK" ON "DPH96QT01"."SDNALIAS" ("SDNI
D", "ALIASID")                                                                  
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."PHRASE_ID_SOURCENAME_SOURCEID" ON "DPH96QT01"."ACCEP
TDENYPHRASEINFO" ("PHRASEID", "SOURCENAME", "SOURCEID")                         
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."LITERALMAIN_PK" ON "DPH96QT01"."LITERALMAIN" 
("CODETYPE", "BANKCODE")                                                        
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."BRANCHMASTER_PK" ON "DPH96QT01"."BRANCHMASTER
" ("BANKID", "BRANCHID")                                                        
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."GENTABLERECORD_GENTABLEKEY" ON "DPH96QT01"."G
ENTABLERECORD" ("GTTRANSLATORID", "GTSTANDARD", "GTRELEASE", "GTNAME", "GTTYPE")
                                                                                
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."REPORTPRININFO_PK" ON "DPH96QT01"."REPORTPRIN
INFO" ("ID")                                                                    
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."ALL_PKEY" ON "DPH96QT01"."TOPICMAP" ("INSTITU
TIONID", "SOURCE", "TOPIC")                                                     
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."TOPIC_INST_PKEY" ON "DPH96QT01"."TOPICS" ("IN
STITUTIONID", "TOPIC")                                                          
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."WATCHLIST_PK" ON "DPH96QT01"."WATCHLIST" ("AP
PLICATIONID", "LISTID")                                                         
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."WORDRECORD_KEY" ON "DPH96QT01"."WORDRECORD" ("WRID",
 "WRSTANDARD", "WRRELEASE")                                                     
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."LITERAL_PK" ON "DPH96QT01"."LITERAL" ("CODETY
PE", "BANKCODE", "LITERALID")                                                   
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."UK_LITERAL" ON "DPH96QT01"."LITERAL" ("CODETY
PE", "LITERALSTRING")                                                           
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."CRI_CHANNEL_ROUTE_INFO_PK" ON "DPH96QT01"."CR
I_CHANNEL_ROUTE_INFO" ("CRI_CHANNEL_ID", "CRI_INSTITUTIONID", "CRI_ROUTE_ORDER_N
O")                                                                             
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."I_MODEDATE" ON "DPH96QT01"."MSGDB" ("MSG_MODE_IN", "
CUSTOM25")                                                                      
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."ROUTING_DIR_PK" ON "DPH96QT01"."ROUTING_DIR" 
("RECORD_KEY")                                                                  
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_WORDRECORD" ON "DPH96QT01"."WORDRECORD" ("
WRID", "WRSTANDARD", "WRRELEASE", "WRCODENO")                                   
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_CHANNELVIEW" ON "DPH96QT01"."CHANNELVIEW" 
("CHANNELS", "INSTITUTION")                                                     
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."GROUPHIERARCHY_PK" ON "DPH96QT01"."GROUPHIERA
RCHY" ("PARENTGROUPID", "CHILDGROUPID", "INSTITUTIONID")                        
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."GROUPPROFILE_PK" ON "DPH96QT01"."GROUPPROFILE
" ("GROUPID", "PROFILEID", "INSTITUTIONID", "PROFILEPRIORITY")                  
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PROFILEAPPLICATIONINSTANCE_PK" ON "DPH96QT01"
."PROFILEAPPLICATIONINSTANCE" ("PROFILEID", "APPLICATIONINSTANCEID", "VALUE1", "
INSTITUTIONID")                                                                 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PROFILEATTRIBUTE_PK" ON "DPH96QT01"."PROFILEA
TTRIBUTE" ("PROFILEID", "APPLICATIONID", "ATTRIBUTEID", "VALUE1", "INSTITUTIONID
")                                                                              
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PROFILELOCATION_PK" ON "DPH96QT01"."PROFILELO
CATION" ("PROFILEID", "LOCATIONID", "VALUE1", "INSTITUTIONID")                  
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PROFILEMESSAGETYPE_PK" ON "DPH96QT01"."PROFIL
EMESSAGETYPE" ("PROFILEID", "MESSAGETYPE", "VALUE1", "INSTITUTIONID")           
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PROFILEQUEUE_PK" ON "DPH96QT01"."PROFILEQUEUE
" ("PROFILEID", "QUEUEID", "VALUE1", "INSTITUTIONID")                           
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_RIB" ON "DPH96QT01"."RIB" ("BANKCODE", "BR
ANCHCODE")                                                                      
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."RIB_BANKNAME" ON "DPH96QT01"."RIB" ("BANKNAME")     
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."RIB_BANKNAMECITY" ON "DPH96QT01"."RIB" ("BANKNAME", 
"CITY")                                                                         
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."RIB_BICCODE" ON "DPH96QT01"."RIB" ("BICCODE")       
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."RIB_BANKNAMEBRANCHNAME" ON "DPH96QT01"."RIB" ("BANKN
AME", "BRANCHNAME")                                                             
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_TABLEMAIN" ON "DPH96QT01"."TABLEMAIN" ("TM
IDCODE")                                                                        
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_TABLEDETAIL" ON "DPH96QT01"."TABLEDETAILS"
 ("TDIDCODE", "TDKEY")                                                          
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 

                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."UGROUP_PK" ON "DPH96QT01"."UGROUP" ("GROUPID"
, "INSTITUTIONID")                                                              
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."UPROFILE_PK" ON "DPH96QT01"."UPROFILE" ("PROF
ILEID", "INSTITUTIONID")                                                        
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."USEDBYRECORD_KEY" ON "DPH96QT01"."USEDBYRECORD" ("PA
RENTCOMPID", "PARENTCOMPSTANDARD", "PARENTCOMPRELEASE")                         
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."USERAPPLNSESSION_PK" ON "DPH96QT01"."USERAPPL
ICATIONSESSION" ("USERID", "APPLICATIONID", "INSTITUTIONID")                    
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."USERGROUP_PK" ON "DPH96QT01"."USERGROUP" ("US
ERID", "GROUPID", "INSTITUTIONID")                                              
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."USERPASSWORDHISTORY_PK" ON "DPH96QT01"."USERP
ASSWORDHISTORY" ("USERID", "PASSWORD", "EFFECTIVEDATE", "INSTITUTIONID")        
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."USERPROFILE_PK" ON "DPH96QT01"."USERPROFILE" 
("USERID", "PROFILEID", "INSTITUTIONID", "PROFILEPRIORITY")                     
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."UUSER_PK" ON "DPH96QT01"."UUSER" ("USERID", "
INSTITUTIONID")                                                                 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."USERRAPPLNINSTSESSION_PK" ON "DPH96QT01"."USE
RAPPLICATIONINSTANCESESSION" ("USERID", "APPLICATIONINSTANCEID", "INSTITUTIONID"
, "INSTANCEID")                                                                 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."USERLIMITS_PK" ON "DPH96QT01"."USERLIMITS" ("
INSTITUTIONID", "USERID", "TRANSACTIONGROUP", "RECORD_GROUP_TYPE")              
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."DASHBOARD_PK" ON "DPH96QT01"."DASHBOARD" ("DB
_INSTITUTIONID", "DB_CHANNEL_ID", "DB_DIRECTION", "DB_RECORD_GROUP_TYPE", "DB_ST
ARTDATE", "DB_ENDDATE", "DB_INCLUDECOPY")                                       
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."MGMDB_SDT_EDT_INID" ON "DPH96QT01"."MANAGEMENT_DASHB
OARD" ("DB_STARTDATE", "DB_ENDDATE", "DB_INSTITUTIONID")                        
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."OPTDB_SDT_EDT_INID" ON "DPH96QT01"."OPERATIONDASHBOA
RD" ("DB_STARTDATE", "DB_ENDDATE", "DB_INSTITUTIONID")                          
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."QUEUEDASHBOARD_PK" ON "DPH96QT01"."QUEUEDASHB
OARD" ("DB_INSTITUTIONID", "DB_QUEUEID", "DB_DIRECTION", "DB_RECORD_GROUP_TYPE",
 "DB_STARTDATE", "DB_ENDDATE", "DB_INCLUDECOPY")                                
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_RTGSBRANCHES" ON "DPH96QT01"."RTGSBRANCHES
" ("BANK_NAME", "IFSC", "BRANCH_NAME", "CENTRE")                                
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."ATTRIBUTEHIERARCHY_PK" ON "DPH96QT01"."ATTRIB
UTEHIERARCHY" ("ATTRIBUTEID", "APPLICATIONID")                                  
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_C0017144" ON "DPH96QT01"."FILETRANSACTION
" ("CHANNELID", "FILENAME", "INPUTDIRECTORY", "INSTANCEID")                     
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_C0017145" ON "DPH96QT01"."FILETRANSACTION
" ("FILENAME", "INPUTDIRECTORY", "CHANNELID")                                   
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."KEYDATAAUTHENTICATION_PRIM_KEY" ON "DPH96QT01
"."KEYDATAAUTHENTICATION" ("PELICAN_DATA_KEY_ID")                               
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."KEYPASS_PRIM_KEY" ON "DPH96QT01"."KEYPASSWORD
" ("KEY_ID")                                                                    
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."KEYSTORE_PRIM_KEY" ON "DPH96QT01"."KEYSTORETA
B" ("KEYSTORE_ID")                                                              
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."KEYSTORETEMP_PRIM_KEY" ON "DPH96QT01"."KEYSTO
RETEMP" ("KEYSTORE_ID", "KEY_ID")                                               
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000089967C00008$$" ON "DPH96QT01"."KEY
STORETAB" (                                                                     
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."FORWARD_CONTRACT_PK" ON "DPH96QT01"."FORWARD_
CONTRACT" ("FRWD_CUST_ID", "FRWD_CONTRACT_NO")                                  
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_C0017171" ON "DPH96QT01"."ACC_CUSTOMER_MA
P" ("CUST_ACC_NO")                                                              
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_C0017174" ON "DPH96QT01"."ACC_ENTRY" ("AC
C_ENTRY_NO")                                                                    
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_C0017175" ON "DPH96QT01"."ACC_ENTRY" ("AC
C_ORDER_NO")                                                                    
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."CUSTOMER_RATE_PK" ON "DPH96QT01"."CUSTOMER_RA
TE" ("CUST_ID")                                                                 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_C0017187" ON "DPH96QT01"."CHG_CHARGES" ("
CHG_ENTRYNO")                                                                   
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_C0017188" ON "DPH96QT01"."CHG_CHARGES" ("
CHG_ORDER_NO")                                                                  
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."CUSTCUTOFF_PK" ON "DPH96QT01"."BR_CUSTOMER_CU
TOFF" ("BRANCH_ID", "INSTITUTIONID", "BR_DIRECTION")                            
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_C0017200" ON "DPH96QT01"."BLZINFODB" ("RE
CORDNUMBER")                                                                    
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SDNPHRASEPATTERN_PK" ON "DPH96QT01"."SDNPHRAS
EPATTERN" ("SOURCEID", "SOURCENAME", "DICTIONARYID", "ALIASID")                 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000089994C00004$$" ON "DPH96QT01"."SDN
PHRASEPATTERN" (                                                                
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_C0017233" ON "DPH96QT01"."FILE_INTERFACE_
DB" ("SENDING_CHANNEL_ID", "SENDING_CHANNEL_FILE_ID", "FILE_TYPE", "FILE_INSTANC
E_NO")                                                                          
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000090003C00011$$" ON "DPH96QT01"."FIL
E_INTERFACE_DB" (                                                               
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."IDX_FILE_INT_DB" ON "DPH96QT01"."FILE_INTERFACE_DB" 
("SENDING_CHANNEL_ID", "RECEIVING_CHANNEL_ID", "FILE_EXTENSION")                
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_CUSTOMER_INFORMATION" ON "DPH96QT01"."CUST
OMER_INFORMATION" ("CUST_CODE")                                                 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_CURR_CUTOF_TIME" ON "DPH96QT01"."CURR_CUTO
F_TIME" ("CURR_CODE")                                                           
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_SMS_ADVICE" ON "DPH96QT01"."SMS_ADVICE" ("
ADCB_TRAN_REF", "ADVICE_TYPE")                                                  
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000090012C00014$$" ON "DPH96QT01"."SMS
_ADVICE" (                                                                      
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_NOSTRO_ACC_INFO" ON "DPH96QT01"."NOSTRO_AC
C_INFO" ("INSTITUTIONID", "NOSTRO_ACC_NUM")                                     
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_ACCOUNT_INFO" ON "DPH96QT01"."ACCOUNT_INFO
" ("ACCOUNTNUMBER")                                                             
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_CUSTOMER_ADVICE" ON "DPH96QT01"."CUSTOMER_
ADVICE" ("CUST_CODE")                                                           
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_ACCOUNT_DETAIL" ON "DPH96QT01"."ACCOUNT_DE
TAIL" ("AD_ACCT_NUMBER")                                                        
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_C0017257" ON "DPH96QT01"."CUSTODIAN_DETAI
LS" ("CUSTDN_BIC", "PAY_RECEIVE")                                               
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_VOSTRO_ACC_INFO" ON "DPH96QT01"."VOSTRO_AC
C_INFO" ("INSTITUTIONID", "VOSTRO_ACC_NUM")                                     
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_BIC_TO_CB" ON "DPH96QT01"."BIC_TO_CB" ("IN
STITUTIONID", "BIC_CODE")                                                       
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."REGIONS_PK" ON "DPH96QT01"."REGIONS" ("REGION
_CODE")                                                                         
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."CALENDAR_PK" ON "DPH96QT01"."CALENDAR" ("DAY_
KEY")                                                                           
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."STATUS_EXCEPTION_PK" ON "DPH96QT01"."STATUS_E
XCEPTION" ("STATUS_ID")                                                         
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."STATUS_PROCESSING_PK" ON "DPH96QT01"."STATUS_
PROCESSING" ("STATUS_ID")                                                       
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."RECORD_TYPE_PK" ON "DPH96QT01"."RECORD_TYPE" 
("TYPE_ID")                                                                     
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."MSGDIRECTION_PK" ON "DPH96QT01"."MSGDIRECTION
" ("DIRECTION_ID")                                                              
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."BIC_CODES_PK" ON "DPH96QT01"."BIC_CODES" ("BI
C_CODE")                                                                        
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."TRAN_REASONS_PK" ON "DPH96QT01"."TRAN_REASONS
" ("REASON_CODE")                                                               
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PAYMENT_SYSTEMS_PK" ON "DPH96QT01"."PAYMENT_S
YSTEMS" ("PAYSYS_ID")                                                           
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."CLIENT_PRODUCTS_PK" ON "DPH96QT01"."CLIENT_PR
ODUCTS" ("CLIENTPROD_ID")                                                       
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."BACKOFFICE_APPL_PK" ON "DPH96QT01"."BACKOFFIC
E_APPL" ("BACKO_APP_ID")                                                        
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."STATUS_STP_PK" ON "DPH96QT01"."STP_STATUS" ("
STATUS_ID")                                                                     
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."FINAL_SCAN_STATUS_PK" ON "DPH96QT01"."FINAL_S
CAN_STATUS" ("STATUS_ID")                                                       
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."INIT_SCAN_STATUS_PK" ON "DPH96QT01"."INIT_SCA
N_STATUS" ("STATUS_ID")                                                         
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."ALERTTYPE_PK" ON "DPH96QT01"."ALERTTYPE" ("AL
ERT_CODE")                                                                      
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."MSGHITPATTERN_PK" ON "DPH96QT01"."MSGHITPATTE
RN" ("HIT_PATTERN")                                                             
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."MSGFAMILY_PK" ON "DPH96QT01"."MSGFAMILY" ("FA
MILY_ID")                                                                       
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PROCESSING_STATUS_MAPPING_PK" ON "DPH96QT01".
"PROCESSING_STATUS_MAPPING" ("QUEUEID", "QUEUE_STATUS")                         
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."ACCOUNT_MASTER_PK" ON "DPH96QT01"."ACCOUNT_MA
STER" ("INSTITUTION_ID", "CUSTOMER_ID", "BANK_CODE", "BRANCH", "ACCOUNT_NUMBER")
                                                                                
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."CREDITORSCHEMEID_PK" ON "DPH96QT01"."CREDITOR
SCHEMEID" ("INSTITUTION_ID", "CRSCHEME_ID")                                     
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."CRSCHEMEID_BANKACC_MAP_PK" ON "DPH96QT01"."CR
SCHEMEID_BANKACC_MAP" ("INSTITUTION_ID", "MAP_CRSCHEME_ID", "MAP_CUSTOMER_ID", "
MAP_BANK_CODE", "MAP_BRANCH", "MAP_ACCOUNT_NUMBER")                             
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."MANDATE_ID_PK" ON "DPH96QT01"."MANDATE" ("MAN
DATE_ID", "STATUS")                                                             
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000090077C00015$$" ON "DPH96QT01"."MAN
DATE" (                                                                         
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000090077C00014$$" ON "DPH96QT01"."MAN
DATE" (                                                                         
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000090077C00013$$" ON "DPH96QT01"."MAN
DATE" (                                                                         
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."MANDATECACHE_ID_PK" ON "DPH96QT01"."MANDATE_C
ACHE" ("MANDATE_ID", "STATUS")                                                  
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."IDX_ANY2ANY_MATCH01" ON "DPH96QT01"."MSGDB" ("TRANSR
EFNO", "RECORD_GROUP_TYPE")                                                     
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."IDX_MANDATE_MANDATESTATUS" ON "DPH96QT01"."MANDATE" 
("MANDATE_STATUS")                                                              
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."IDX_MANDUPDT_STATUS_2PC" ON "DPH96QT01"."MANDATE_UPD
ATE" ("STATUS", "TWOPHASECOMMIT_ID")                                            
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."IDX_MD_INSTID_EXTUMR_MDSTATUS" ON "DPH96QT01"."MANDA
TE" ("INSTITUTION_ID", "EXTERNAL_SYSTEM_UMR", "MANDATE_STATUS")                 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."IDX_MD_STATUS_COMMITID_EXTUMR" ON "DPH96QT01"."MANDA
TE" ("STATUS", "TWOPHASECOMMIT_ID", "EXTERNAL_SYSTEM_UMR")                      
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."IDX_MANDATE_UK" ON "DPH96QT01"."MANDATE" ("INSTITUTI
ON_ID", "LOCATIONID", "EXTERNAL_SYSTEM_UMR")                                    
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."IDX_MC_INSTID_EXTUMR_MDSTATUS" ON "DPH96QT01"."MANDA
TE_CACHE" ("INSTITUTION_ID", "EXTERNAL_SYSTEM_UMR", "MANDATE_STATUS")           
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL KEEP FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."IDX_MANDUPDT_INID_EXUMR" ON "DPH96QT01"."MANDATE_UPD
ATE" ("INSTITUTION_ID", "EXTERNAL_SYSTEM_UMR")                                  
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."IDX_MC_CRDR_ACCNO" ON "DPH96QT01"."MANDATE_CACHE" ("
INSTITUTION_ID", "CREDITOR_ACCT_NUMBER", "DEBTOR_ACCT_NUMBER")                  
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL KEEP FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."IDX_MANDATE_INST_INMEMSTAT" ON "DPH96QT01"."MANDATE"
 ("INSTANCEID", "INSTITUTION_ID", "IN_MEMORY_STATUS")                           
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."IDX_INIDCRDRACNO" ON "DPH96QT01"."MANDATE" ("INSTITU
TION_ID", "CREDITOR_ACCT_NUMBER", "DEBTOR_ACCT_NUMBER")                         
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."IDX_ANY2ANY_MATCH02" ON "DPH96QT01"."MSGDB" ("CUSTOM
2", "RECORD_GROUP_TYPE")                                                        
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."IDX_ANY2ANY_MANDATE" ON "DPH96QT01"."MANDATE" ("EXTE
RNAL_SYSTEM_UMR", "CREDITOR_SCHEME_ID", "INSTITUTION_ID")                       
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."IDX_ANY2ANY_MANDATE_CACHE" ON "DPH96QT01"."MANDATE_C
ACHE" ("EXTERNAL_SYSTEM_UMR", "CREDITOR_SCHEME_ID", "INSTITUTION_ID")           
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL KEEP FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)                
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."TRANSACTIONATTRIBUTE_PK" ON "DPH96QT01"."TRAN
SACTIONATTRIBUTE" ("ATTRIBUTEID", "APPLICATIONID")                              
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."TRANSACTIONHIERARCHY_PK" ON "DPH96QT01"."TRAN
SACTIONHIERARCHY" ("ATTRIBUTEID", "APPLICATIONID")                              
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PROFILETRANSACTIONS_PK" ON "DPH96QT01"."PROFI
LETRANSACTIONS" ("PROFILEID", "APPLICATIONID", "ATTRIBUTEID", "VALUE1", "INSTITU
TIONID")                                                                        
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."NOTIFICATION_NO_PK" ON "DPH96QT01"."NOTIFICAT
ION" ("NOTIFICATION_NO")                                                        
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000090113C00010$$" ON "DPH96QT01"."NOT
IFICATION" (                                                                    
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."NOTIFICATION_COMMENTS_PK" ON "DPH96QT01"."NOT
IFICATION_COMMENTS" ("NOTIFICATION_NO", "NOTIFICATION_SRNO")                    
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000090117C00004$$" ON "DPH96QT01"."NOT
IFICATION_COMMENTS" (                                                           
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_PAYT_TXN_ID" ON "DPH96QT01"."PAYMENT_TXN" 
("PYMT_TXN_ID")                                                                 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000090124C00005$$" ON "DPH96QT01"."PAY
MENT_TXN_SCAN" (                                                                
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000090124C00004$$" ON "DPH96QT01"."PAY
MENT_TXN_SCAN" (                                                                
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."QUEUE_PK" ON "DPH96QT01"."QUEUE" ("INSTITUTIO
NID", "QUEUEID")                                                                
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."INSTITUTIONID_PKEY" ON "DPH96QT01"."INSTITUTI
ONMASTER" ("INSTITUTIONID")                                                     
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."BALANCE_UPDATED_IND" ON "DPH96QT01"."MSGDB" ("BALANC
E_UPDATED")                                                                     
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."IDX_STAT_ACC_BAL_UPDT" ON "DPH96QT01"."MSGDB" ("STAT
US", "ACCOUNT_NUMBER", "INSTITUTIONID", "BALANCE_UPDATED")                      
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000089589C00016$$" ON "DPH96QT01"."GEN
AUDIT" (                                                                        
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."ACCOUNT_CURR_IND" ON "DPH96QT01"."ACCOUNT_MASTER" ("
ACCOUNT_CURR")                                                                  
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_OB_XPATH_IPPATH_MAP" ON "DPH96QT01"."OB_XP
ATH_INSTPARMPATH_MAP" ("XPATH_ROOT", "XPATH_NODE")                              
  PCTFREE 10 INITRANS 2 MAXTRANS 157 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000090613C00008$$" ON "DPH96QT01"."PEL
ICAN_XSD_REPOSITORY" (                                                          
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PELICAN_XSD_REPOSITORY_PKEY" ON "DPH96QT01"."
PELICAN_XSD_REPOSITORY" ("MODULE_NAME", "PRODUCT_VER_NUMBER", "PRODUCT_FLAVOR") 
                                                                                
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000090617C00010$$" ON "DPH96QT01"."PRE
FERENCES" (                                                                     
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000090617C00009$$" ON "DPH96QT01"."PRE
FERENCES" (                                                                     

  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000090617C00008$$" ON "DPH96QT01"."PRE
FERENCES" (                                                                     
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000090617C00007$$" ON "DPH96QT01"."PRE
FERENCES" (                                                                     
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PROFILEINSTITUTION_PK" ON "DPH96QT01"."PROFIL
EINSTITUTIONS" ("PROFILEID", "INSTITUTIONID", "VALUE1", "INSTITUTIONIDTOBEGRANTE
D")                                                                             
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000089589C00017$$" ON "DPH96QT01"."GEN
AUDIT" (                                                                        
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."IDX_INSTID_DATE_RG_TRGR_PS" ON "DPH96QT01"."MSGDB" (
"INSTITUTIONID", "INPUTDATETIME", "RECORD_GROUP_TYPE", "MSGSEGR", "PROCESSING_ST
AGE")                                                                           
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."IDX_MSGDB_RELREFNO" ON "DPH96QT01"."MSGDB" ("RELATED
_REFERENCE")                                                                    
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."IDX_ACCDET_UKIBAN" ON "DPH96QT01"."ACCOUNT_DETAIL" (
"UK_IBAN")                                                                      
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."IDX_ACCDET_UKACCNO" ON "DPH96QT01"."ACCOUNT_DETAIL" 
("UK_ACCT_NUMBER")                                                              
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."IDX_USER_EMAIL" ON "DPH96QT01"."UUSER" ("EMAILID")  
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."OPERATIONDASHB_PK" ON "DPH96QT01"."OPERATIOND
ASHBOARD" ("DB_USER", "DB_INSTITUTIONID", "DB_GROUPNAME", "DB_GROUPVALUE", "DB_T
RANSACTION_GROUP", "DB_STARTDATE", "DB_ENDDATE", "DB_RECORD_GROUP_TYPE")        
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."MGMT_DASHBOARD_PK" ON "DPH96QT01"."MANAGEMENT
_DASHBOARD" ("DB_USER", "DB_INSTITUTIONID", "DB_GROUPNAME", "DB_GROUPVALUE", "DB
_TRANSACTION_GROUP", "DB_STARTDATE", "DB_ENDDATE")                              
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000090754C00017$$" ON "DPH96QT01"."SIA
NET_XS" (                                                                       
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000090754C00010$$" ON "DPH96QT01"."SIA
NET_XS" (                                                                       
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000090754C00009$$" ON "DPH96QT01"."SIA
NET_XS" (                                                                       
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000089939C00036$$" ON "DPH96QT01"."UUS
ER" (                                                                           
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."CONTROL_PANEL_AUTH_RULE_PK" ON "DPH96QT01"."C
ONTROL_PANEL_AUTH_RULE" ("ACTIONID", "AUTH_LEVEL", "CURRENT_STATUS", "CURRENT_QU
EUEID", "CURRENT_STAGE")                                                        
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000090780C00005$$" ON "DPH96QT01"."CON
TROL_PANEL_METADATA" (                                                          
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000090780C00004$$" ON "DPH96QT01"."CON
TROL_PANEL_METADATA" (                                                          
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."CONTROL_PANEL_METADATA_PK" ON "DPH96QT01"."CO
NTROL_PANEL_METADATA" ("ACTIONID")                                              
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000090786C00011$$" ON "DPH96QT01"."CON
TROL_PANEL_POST_AUTH_STEPS" (                                                   
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000090786C00006$$" ON "DPH96QT01"."CON
TROL_PANEL_POST_AUTH_STEPS" (                                                   
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."CPANEL_POST_AUTH_STEPS_PK" ON "DPH96QT01"."CO
NTROL_PANEL_POST_AUTH_STEPS" ("ACTIONID", "SEQUENCE_NO", "AUTH_LEVEL", "CURRENT_
QUEUEID")                                                                       
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000090792C00035$$" ON "DPH96QT01"."INS
TITUTION_ORGANIZATION_INFO" (                                                   
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000090792C00034$$" ON "DPH96QT01"."INS
TITUTION_ORGANIZATION_INFO" (                                                   
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."INST_ORG_INFO_PK" ON "DPH96QT01"."INSTITUTION
_ORGANIZATION_INFO" ("INSTITUTION_ID", "ORIGINATING_SYSTEM", "ORGANIZATION_ID", 
"SERVICE_SUBSCRIBED")                                                           
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."UUSER_AUTH_PK" ON "DPH96QT01"."UUSER_AUTH" ("
USERID", "INSTITUTIONID", "IDENTITY_PROVIDER")                                  
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."UUSER_DEVICE_PK" ON "DPH96QT01"."UUSER_DEVICE
" ("USERID", "INSTITUTIONID", "DEVICEID")                                       
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."UUSER_MFA_PKEY" ON "DPH96QT01"."UUSER_MFA" ("
USERID", "INSTITUTIONID", "IDENTITY_PROVIDER")                                  
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000090805C00007$$" ON "DPH96QT01"."WID
GETSETTINGS" (                                                                  
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_WIDGETSETTINGS" ON "DPH96QT01"."WIDGETSETT
INGS" ("WIDGETSETTINGS_ID")                                                     
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."FILE_DOWNLOAD_PK" ON "DPH96QT01"."FILE_DOWNLO
AD" ("FILE_TYPE", "FILE_TYPE_DESC", "FILE_TYPE_CHANNEL_ID")                     
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000090812C00011$$" ON "DPH96QT01"."FIL
E_UPLOAD" (                                                                     
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."FILE_UPLOAD_PK" ON "DPH96QT01"."FILE_UPLOAD" 
("FILE_TYPE", "FILE_TYPE_DESC")                                                 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."INSTITUTION_RUN_PK" ON "DPH96QT01"."INSTITUTI
ON_DATASYNC_RUNCYCLE" ("INSTITUTIONID", "CATEGORY")                             
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."IDX_SERVICE_RQST_PK" ON "DPH96QT01"."SERVICE_
TRANSACTION" ("SERVICE_REQUEST_ID")                                             
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000090820C00004$$" ON "DPH96QT01"."REP
ORT_TAB" (                                                                      
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."REPORT_TAB_PK" ON "DPH96QT01"."REPORT_TAB" ("
USERID", "INSTITUTIONID", "APPLICATIONID", "REPORTID")                          
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PROFILEMESSAGESTAGE_PK" ON "DPH96QT01"."PROFI
LEMESSAGESTAGE" ("PROFILEID", "STAGE", "VALUE1", "INSTITUTIONID")               
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PROFILETRANSACTIONGROUP_PK" ON "DPH96QT01"."P
ROFILETRANSACTIONGROUP" ("PROFILEID", "GROUPID", "VALUE1", "INSTITUTIONID")     
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PROFILEMESSAGEFAMILY_PK" ON "DPH96QT01"."PROF
ILEMESSAGEFAMILY" ("PROFILEID", "FAMILY", "VALUE1", "INSTITUTIONID")            
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PELICAN_DASHBOARD_PK" ON "DPH96QT01"."PELICAN
_DASHBOARD" ("DB_INSTITUTIONID", "DB_LOCATION", "DB_GROUPNAME", "DB_GROUPVALUE",
 "DB_TRANSACTION_GROUP", "DB_STARTDATE", "DB_ENDDATE")                          
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."NOTIFICATION_USER_PK" ON "DPH96QT01"."NOTIFIC
ATION_USER" ("NOTIFICATION_NO", "USER_ID")                                      
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000090834C00005$$" ON "DPH96QT01"."NOT
IFICATION_TEMPLATE" (                                                           
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."NOTIFICATION_TEMPLATE_PK" ON "DPH96QT01"."NOT
IFICATION_TEMPLATE" ("NOTIFICATION_TYPE_ID", "NOTIFICATION_MODE", "NOTIFICATION_
LANGUAGE_ID")                                                                   
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000090838C00004$$" ON "DPH96QT01"."NOT
IFICATION_ATTACHMENTS" (                                                        
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."MSGDB_USER_ACTION_PK" ON "DPH96QT01"."MSGDB_U
SER_ACTION" ("MSGDB_ID", "STAGE", "USER", "ACTION")                             
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."STATUS_PK" ON "DPH96QT01"."MESSAGESTATUS" ("S
TATUS")                                                                         
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."STAGE_PK" ON "DPH96QT01"."MESSAGESTAGE" ("STA
GE")                                                                            
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."FAMILY_PK" ON "DPH96QT01"."MESSAGEFAMILY" ("F
AMILY")                                                                         
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000090849C00018$$" ON "DPH96QT01"."CUS
T_ONBOARD_HISTORY" (                                                            
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000090849C00005$$" ON "DPH96QT01"."CUS
T_ONBOARD_HISTORY" (                                                            
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."CUST_ONBOARD_HISTORY_PK" ON "DPH96QT01"."CUST
_ONBOARD_HISTORY" ("INSTITUTION_ID", "MODULE_NAME", "HIST_SRNO")                
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."CUST_ONBOARD_ENTITYVALID_PK" ON "DPH96QT01"."
CUST_ONBOARD_ENTITY_VALIDATION" ("MODULE_NAME", "XSD_VERSION", "XML_TAG", "XML_T
AG_SRNO")                                                                       
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000090857C00015$$" ON "DPH96QT01"."CUS
T_ONBOARD" (                                                                    
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000090857C00004$$" ON "DPH96QT01"."CUS
T_ONBOARD" (                                                                    
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."CUST_ONBOARD_PK" ON "DPH96QT01"."CUST_ONBOARD
" ("INSTITUTION_ID", "MODULE_NAME")                                             
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."CUST_CODE_PK" ON "DPH96QT01"."PACE_CUST_INFO"
 ("CUST_TYPE", "CUST_CODE", "INSTITUTIONID")                                    
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."UBO_PKEY" ON "DPH96QT01"."UBO" ("INSTITUTIONI
D", "UBOID")                                                                    
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."QUEUE_ROUTING_PK" ON "DPH96QT01"."QUEUE_ROUTI
NG" ("ACTIONID", "AUTH_LEVEL", "CURRENT_STATUS", "CURRENT_QUEUEID", "CURRENT_STA
GE")                                                                            
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000090869C00011$$" ON "DPH96QT01"."ENT
ITY_VERIFICATION" (                                                             
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000090869C00010$$" ON "DPH96QT01"."ENT
ITY_VERIFICATION" (                                                             
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000090869C00006$$" ON "DPH96QT01"."ENT
ITY_VERIFICATION" (                                                             
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."ENTITY_VERIFICATION_PK" ON "DPH96QT01"."ENTIT
Y_VERIFICATION" ("ENTITY_ID", "INSTITUTIONID", "DOCUMENT_TYPE", "STATUS", "UPDAT
ED_DATETIME")                                                                   
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000090877C00003$$" ON "DPH96QT01"."SER
VICE_TRANSACTION_DATA" (                                                        
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."IDX_SERVICE_TXNS_DATA_PK" ON "DPH96QT01"."SER
VICE_TRANSACTION_DATA" ("SERVICE_REQUEST_ID", "SERVICE_TRANSACTION_DATA_TYPE")  
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."GROUP_PK" ON "DPH96QT01"."TRANSACTIONGROUP" (
"GROUPID")                                                                      
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."USER_NOTIFICATION_MODE_PK" ON "DPH96QT01"."US
ER_NOTIFICATION_MODE" ("INSTITUTION_ID", "USER_ID", "NOTIFICATION_MODE")        
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000090113C00018$$" ON "DPH96QT01"."NOT
IFICATION" (                                                                    
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_STPSELFLEARNRULEDBPARAMS" ON "DPH96QT01"."
STPSELFLEARNRULEDBPARAMS" ("SELFLEARN_RULEID", "PARAMETER_ID")                  
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000090892C00007$$" ON "DPH96QT01"."REG
ULATORY_TXNS_SCREENING" (                                                       
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_ENHTABLEMAIN" ON "DPH96QT01"."ENHTABLEMAIN
" ("TMIDCODE")                                                                  
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."MSGDB_GPI_PK" ON "DPH96QT01"."MSGDB_GPI" ("MS
GDB_ID", "SEQUENCENO")                                                          
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_STPSELFLEARNCONCEPT" ON "DPH96QT01"."STPSE
LFLEARNCONCEPT" ("INSTITUTIONID", "CONCEPTID", "CONCEPTVALUE")                  
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_STPSELFLEARNDB" ON "DPH96QT01"."STPSELFLEA
RNDB" ("MSGDB_ID", "REPAIRED_FIELD")                                            
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_STPSELFLEARNDBPARAMS" ON "DPH96QT01"."STPS
ELFLEARNDBPARAMS" ("MSGDB_ID", "REPAIRED_FIELD", "PARAMETER_ID")                
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_ENHTABLEDETAILS" ON "DPH96QT01"."ENHTABLED
ETAILS" ("TDIDCODE", "TDKEY")                                                   
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."XSID_INST_UK" ON "DPH96QT01"."SIANET_XS" ("IN
STITUTION_ID", "XS_ID")                                                         
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_STPSELFLEARNRULEDB" ON "DPH96QT01"."STPSEL
FLEARNRULEDB" ("SELFLEARN_RULEID")                                              
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000090798C00021$$" ON "DPH96QT01"."UUS
ER_AUTH" (                                                                      
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."STATUS_INFO_PK" ON "DPH96QT01"."STATUS_INFO" 
("MODULE_NAME", "STATUS_VALUE")                                                 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_C0017529" ON "DPH96QT01"."USER_NOTIFICATI
ON_TYPE" ("INSTITUTION_ID", "USER_ID", "NOTIFICATION_TYPE", "NOTIFICATION_MODE")
                                                                                
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000090965C00015$$" ON "DPH96QT01"."ATT
ACHMENTS" (                                                                     
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000090965C00009$$" ON "DPH96QT01"."ATT
ACHMENTS" (                                                                     
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_ATTACHMNT_ID" ON "DPH96QT01"."ATTACHMENTS"
 ("ATTACHMENT_ID")                                                              
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_C0017536" ON "DPH96QT01"."BANK_ADDITIONAL
_INFO" ("BANK_CODE", "INFO_TYPE", "SOURCE_FORMAT")                              
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000090973C00017$$" ON "DPH96QT01"."BAN
K_INFO" (                                                                       
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_C0017538" ON "DPH96QT01"."BANK_INFO" ("BA
NK_CODE")                                                                       
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."NOTIFICATION_MODULES_PK" ON "DPH96QT01"."NOTI
FICATION_MODULES" ("NOTIFICATION_BRAND_NAME", "NOTIFICATION_MODULE_ID")         
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_C0017545" ON "DPH96QT01"."ORGANIZATION_PR
OPERTIES" ("INSTITUTIONID", "BANKCODE")                                         
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000090985C00004$$" ON "DPH96QT01"."ORG
ANIZATION_PROPERTIES_BLOCKS" (                                                  
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_C0017550" ON "DPH96QT01"."ORGANIZATION_PR
OPERTIES_BLOCKS" ("INSTITUTIONID", "BANKCODE", "DATATYPE")                      
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SHAREID_PK" ON "DPH96QT01"."REPORT_SHARING" (
"SHAREID")                                                                      
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000090991C00005$$" ON "DPH96QT01"."REP
ORT_TEMPLATES" (                                                                
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."JOBID_PK" ON "DPH96QT01"."REPORT_TEMPLATES" (
"JOBID")                                                                        
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."UNSHAREID_PK" ON "DPH96QT01"."REPORT_UNSHARIN
G" ("UNSHAREID")                                                                
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000091003C00019$$" ON "DPH96QT01"."MSG
DB_CATEGORIZATION" (                                                            
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000091003C00005$$" ON "DPH96QT01"."MSG
DB_CATEGORIZATION" (                                                            
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_MSGDB_CATEGORIZATION" ON "DPH96QT01"."MSGD
B_CATEGORIZATION" ("SEQUENCENO", "MSGDB_ID", "PARTNER_ID")                      
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_PREFRENCES" ON "DPH96QT01"."PREFERENCES" (
"USER_ID", "INSTITUTION_ID", "PREFERENCE_TYPE", "COMPONENT", "SUBCOMPONENT", "AP
PLICATIONID", "PREFERENCE_ID")                                                  
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_INSTITUTION_PARAMETER_GROUP" ON "DPH96QT01
"."INSTITUTION_PARAMETER_GROUP" ("GROUP_ID", "GROUP_SHORT_DESC")                
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000090869C00014$$" ON "DPH96QT01"."ENT
ITY_VERIFICATION" (                                                             
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."NOTIFICATION_OUTPUT_PK" ON "DPH96QT01"."NOTIF
ICATION_OUTPUT" ("MODULE_NAME", "MODULE_PRIMARY_KEY", "NOTIFICATION_MODE_TYPE_US
ER")                                                                            
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_QUEUEID" ON "DPH96QT01"."REPORT_QUEUE" ("Q
UEUEID")                                                                        
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000091083C00005$$" ON "DPH96QT01"."REP
ORT_QUEUE" (                                                                    
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000091055C00004$$" ON "DPH96QT01"."GEN
ERATED_REPORT" (                                                                

  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."REPORTNO_PK" ON "DPH96QT01"."GENERATED_REPORT
" ("REPORTNO")                                                                  
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000089774C00014$$" ON "DPH96QT01"."DIC
TTYPE" (                                                                        
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE INDEX "DPH96QT01"."IDX_AUDIT_TEXT" ON "DPH96QT01"."GENAUDIT" ("AUDITTEX
T")                                                                             
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_INSTITUTION_SERVICES" ON "DPH96QT01"."INST
ITUTION_SERVICES" ("INSTITUTION_ID", "PARTNER_PROD_SERVICE_ID", "ORGANIZATION_ID
", "PAYMENT_OUTPUT_MODE")                                                       
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_PARTNER_PRODUCTS_SERVICES" ON "DPH96QT01".
"PARTNER_PRODUCTS_SERVICES" ("PARTNER_PROD_SERVICE_ID", "PARTNER_ID", "PRODUCT_I
D", "SERVICE_ID")                                                               
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_PARTNERS" ON "DPH96QT01"."PARTNERS" ("PART
NER_ID", "PARTNER_NAME")                                                        
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."USER_INSTI_ATTRIB_ACCESS_PK" ON "DPH96QT01"."
USER_INSTI_ATTRIB_ACCESS" ("USERID", "INSTITUTIONID", "ATTRIBUTE_TYPE", "ATTRIBU
TE_VALUE")                                                                      
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."CONCEPTMASTER_INSTANCE_PK" ON "DPH96QT01"."CO
NCEPTMASTER_INSTANCE" ("CONCEPTID", "INSTITUTIONID")                            
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."DICTTYPE_INSTANCE_PK" ON "DPH96QT01"."DICTTYP
E_INSTANCE" ("DICTIONARYID", "INSTITUTIONID")                                   
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000091190C00016$$" ON "DPH96QT01"."DIC
TTYPE_INSTANCE" (                                                               
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_PATTERN" ON "DPH96QT01"."PATTERN" ("DICTIO
NARYID", "PATTERNID", "ORIGINALPATTERNID", "INSTITUTIONID")                     
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PATTERNCONCEPTS_PK" ON "DPH96QT01"."PATTERNCO
NCEPTS" ("DICTIONARYID", "ORIGINALPATTERNID", "CONCEPTID", "CONCEPTVALUE", "INST
ITUTIONID")                                                                     
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."EXCHANGE_RATE_PK" ON "DPH96QT01"."EXCHANGE_RA
TE" ("XCHG_BASE_CUR", "XCHG_CONV_CUR", "XCHG_RATE_TYPE", "TENANT_NAME")         
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."ACI_CASE_ADDL_PK" ON "DPH96QT01"."AML_CASE_AD
DL_INFO" ("ACAI_APPLICATION_ID", "ACAI_CASE_ID", "ACAI_INSTITUTIONID", "ACAI_LOC
ATIONID")                                                                       
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."AML_CASE_WORKFROUP_PK" ON "DPH96QT01"."AML_CA
SE_WORKGROUPS" ("ACW_APPLICATION_ID", "ACW_CASE_ID", "ACW_WORKGROUP_ID", "ACW_IN
STITUTIONID")                                                                   
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."ALC_CASE_LINK_PK" ON "DPH96QT01"."AML_LINKED_
CASE" ("ALC_INSTITUTIONID", "ALC_APPLICATION_ID", "ALC_CASE_ID", "ALC_LINK_CASE_
ID")                                                                            
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."AML_CASE_PROFILE_PK" ON "DPH96QT01"."AML_CASE
_PROFILES" ("ACP_APPLICATION_ID", "ACP_CASE_ID", "ACP_PROFILE_ID", "ACP_INSTITUT
IONID")                                                                         
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."MSGDB_PARAMETERS_PK" ON "DPH96QT01"."MSGDB_PA
RAMETERS" ("MSGDB_ID", "PARAM_NAME")                                            
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_C0017630" ON "DPH96QT01"."MSGDB_TRADE" ("
MSGDB_ID", "LC_NUMBER")                                                         
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_C0017631" ON "DPH96QT01"."MSGDB_TRADE" ("
LC_NUMBER")                                                                     
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000091246C00003$$" ON "DPH96QT01"."MSG
DB_TRADE_ACKNOWLEDGEMENTS" (                                                    
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."TRADE_ACKNOWLEDGEMENTS_PK" ON "DPH96QT01"."MS
GDB_TRADE_ACKNOWLEDGEMENTS" ("MSGDB_ID", "ACKNOWLEDGEMENT_ID")                  
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."CUSTOMER_ACCOUNT_DETAILS_PK" ON "DPH96QT01"."
CUSTOMER_ACCOUNT_DETAILS" ("IBAN_ACC")                                          
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."AML_SCENARIO_PARAMS_PK" ON "DPH96QT01"."AML_S
CENARIO_PARAMS" ("ASP_INSTITUTIONID", "ASP_SCENARIO_ID", "ASP_RULE_ID", "ASP_PAR
AM_TYPE", "ASP_PARAM_NAME", "ASP_PARA_BEHVR")                                   
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."AML_SCENARIOS_PK" ON "DPH96QT01"."AML_SCENARI
OS" ("AS_INSTITUTIONID", "AS_SCENARIO_ID")                                      
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000091256C00004$$" ON "DPH96QT01"."ARC
HIVE_TOOL_OUTPUT_FILES" (                                                       
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."ARCHIVE_TOOL_OUTPUT_FILES_PK" ON "DPH96QT01".
"ARCHIVE_TOOL_OUTPUT_FILES" ("ARCHIVE_FILE_SEQ_NO")                             
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."MSGDB_CLASSIFICATION_PK" ON "DPH96QT01"."MSGD
B_CLASSIFICATION" ("MSGDB_ID", "PRODUCT_FLAVOUR")                               
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."MSGDB_KEYINFO_PK" ON "DPH96QT01"."MSGDB_KEYIN
FO" ("MSGDB_ID", "FIELD_TYPE", "VALUE")                                         
  PCTFREE 10 INITRANS 2 MAXTRANS 165 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."MSGDB_TRADE_DOCUMENTS_PK" ON "DPH96QT01"."MSG
DB_TRADE_DOCUMENTS" ("MSGDB_ID", "DOCUMENT_TYPE")                               
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."MSGDB_USER_ACTIONS_PK" ON "DPH96QT01"."MSGDB_
USER_ACTIONS" ("MSGDB_ID", "STAGE", "USERID", "ACTION", "ACTION_TIMESTAMP")     
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_ACE_ENV_EDIT_FILELIST" ON "DPH96QT01"."ACE
_ENV_EDITABLE_FILELIST" ("SR_NO", "APPLICATIONID", "PRODUCT_LINE", "PRODUCT_VERS
ION")                                                                           
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_ACE_APPL_CNFG_DETAILS" ON "DPH96QT01"."ACE
_APPLICATION_CONFIG_DETAILS" ("APPLICATIONID", "CONFIGURATION_TYPE", "SECTIONNAM
E_TABLEID", "PARAMETER_TDKEY", "SEQUENCENO")                                    
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_ACE_APPL_CONF" ON "DPH96QT01"."ACE_APPLICA
TION_CONFIGURATION" ("APPLICATIONID", "CONFIGURATION_TYPE", "CONFIGURATION_FILEN
AME", "SECTIONNAME_TABLEID", "PARAMETER_TDKEY", "PRODUCT_LINE", "TOOLKITVERSION"
)                                                                               
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_ACE_APPL_FILEFOLDER" ON "DPH96QT01"."ACE_A
PPLICATION_FILEFOLDER" ("APPLICATIONID", "SECTIONNAME", "SEQUENCE_NUMBER")      
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_APPLICATION_LBOX" ON "DPH96QT01"."ACE_APPL
ICATION_LISTBOX" ("APPLICATIONID", "LISTBOXNAME", "PRODUCT_LINE", "PRODUCT_VERSI
ON")                                                                            
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_ACE_APPL_STRD_FILES" ON "DPH96QT01"."ACE_A
PPLICATION_STANDARD_FILES" ("APPLICATIONID", "SEQUENCENO")                      
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000093076C00006$$" ON "DPH96QT01"."ACE
_APPLICATION_STANDARD_FILES" (                                                  
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_FILTER_VIEW" ON "DPH96QT01"."ACE_TEMPLATE_
FILES_FILTER_VIEW" ("TAG_NAME", "SR_NO", "APPLICATIONID", "PRODUCT_LINE", "PRODU
CT_VERSION")                                                                    
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_TEMP_FILE" ON "DPH96QT01"."ACE_APPLICATION
_TEMPLATE_FILES" ("APPLICATIONID", "SR_NO", "PRODUCT_LINE", "PRODUCT_VERSION")  
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000093086C00005$$" ON "DPH96QT01"."ACE
_APPLICATION_TEMPLATE_FILES" (                                                  
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_APPLICATION" ON "DPH96QT01"."ACE_APPLICATI
ON" ("APPLICATIONID", "PRODUCT_LINE", "PRODUCT_VERSION")                        
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000093092C00011$$" ON "DPH96QT01"."ACE
_PRJREL_APPLICATION_DETAILS" (                                                  
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_ACE_PRJREL_APPL_DETAILS" ON "DPH96QT01"."A
CE_PRJREL_APPLICATION_DETAILS" ("PROJECT_CODE", "RELEASE_CODE", "APPLICATIONID",
 "CONFIGURATIONTYPE", "SECTIONNAME_TABLEID", "PARAMETER_TDKEY", "CONFIGURATION_F
ILENAME")                                                                       
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_ACE_CLIENT_DETAILS" ON "DPH96QT01"."ACE_CL
IENT_DETAILS" ("INSTITUTIONID")                                                 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000093097C00011$$" ON "DPH96QT01"."ACE
_CLIENT_DETAILS" (                                                              
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_ACE_PRJ_MASTER_INFO" ON "DPH96QT01"."ACE_P
ROJECT_MASTER_INFO" ("PROJECT_CODE")                                            
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_ACE_PRJ_RELEASE_INFO" ON "DPH96QT01"."ACE_
PROJECT_RELEASE_INFO" ("PROJECT_CODE", "RELEASE_CODE")                          
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_ACE_PRJ_REL_QUEUES" ON "DPH96QT01"."ACE_PR
OJECT_RELEASE_QUEUES" ("PROJECT_CODE", "RELEASE_CODE", "QUEUEID")               
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_COLUMNMAPPING" ON "DPH96QT01"."ACE_TABLE_C
OLUMNMAPPING" ("TABLENAME", "COLUMNNAME", "PRODUCT_LINE", "PRODUCT_VERSION")    
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_PRJREL_LICENSE_CONFIG" ON "DPH96QT01"."PRJ
REL_LICENSE_CONFIGURATION" ("PROJECT_CODE", "RELEASE_CODE", "APPLICATIONID")    
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_ACE_PRJREL_TOOLS_DTLS" ON "DPH96QT01"."ACE
_PRJREL_TOOLS_DETAILS" ("PROJECT_CODE", "RELEASE_CODE", "APPLICATIONID")        
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_ACE_PRJREL_APPL_FILES" ON "DPH96QT01"."ACE
_PRJREL_APPLICATION_FILES" ("SR_NO", "PROJECT_CODE", "RELEASE_CODE", "APPLICATIO
NID", "FILENAME")                                                               
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000093115C00007$$" ON "DPH96QT01"."ACE
_PRJREL_APPLICATION_FILES" (                                                    
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_ACE_RELEASE_STRUCTURE" ON "DPH96QT01"."ACE
_RELEASE_STRUCTURE" ("SRNO")                                                    
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_ACE_PRJ_RLS_STRUCTURE" ON "DPH96QT01"."ACE
_PROJECT_RELEASE_STRUCTURE" ("PROJECT_CODE", "RELEASE_CODE", "SRNO")            
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_ACE_SRVR_INI_FILE_MAP" ON "DPH96QT01"."ACE
_SERVER_INI_FILE_MAP" ("PROJECT_CODE", "RELEASE_CODE", "APPLICATIONID", "INI_FIL
ENAME", "INI_LOCATION")                                                         
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_ACE_SRVR_INSTANCE_MAP" ON "DPH96QT01"."ACE
_SERVER_INSTANCE_MAP" ("PROJECT_CODE", "RELEASE_CODE", "APPLICATIONID")         
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_NAMEMAP" ON "DPH96QT01"."ACE_SECTION_TDIDC
ODE_NAME_MAP" ("APPLICATIONID", "SECTION_TABLEID", "PRODUCT_LINE", "PRODUCT_VERS
ION")                                                                           
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_ACE_APPL_ENV_FILES" ON "DPH96QT01"."ACE_AP
PLICATION_ENV_FILES" ("PROJECT_CODE", "RELEASE_CODE", "APPLICATION_INSTANCEID", 
"FILENAME", "FILE_TYPE", "PATH")                                                
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."SYS_IL0000093132C00007$$" ON "DPH96QT01"."ACE
_APPLICATION_ENV_FILES" (                                                       
  PCTFREE 10 INITRANS 2 MAXTRANS 255                                            
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
  PARALLEL (DEGREE 0 INSTANCES 0)                                               
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_ACE_ENV_VLDATE_FLIST" ON "DPH96QT01"."ACE_
ENV_VALIDATE_FILELIST" ("PRODUCT", "VERSION", "SR_NO", "APPLICATIONID")         
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_ACE_MIGRATION_CHLD_TBLS" ON "DPH96QT01"."A
CE_MIGRATION_CHILD_TABLES" ("TABLE_KEY", "SRNO")                                
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_ACE_MIGRATION_MSTR_TBLS" ON "DPH96QT01"."A
CE_MIGRATION_MASTER_TABLES" ("TABLE_KEY")                                       
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_ACE_PRDATA_MASTERVER" ON "DPH96QT01"."ACE_
PRODUCTDATA_MASTERVERSION" ("PRODUCT_LINE", "PRODUCT_VERSION")                  
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_ACE_PRJREL_STRMS" ON "DPH96QT01"."ACE_PRJR
EL_STREAMS" ("PROJECT_CODE", "RELEASE_CODE", "ST_STREAMID", "INSTITUTIONID", "PR
ODUCT_LINE", "PRODUCT_VERSION")                                                 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_ACE_APPLICATIONLIST" ON "DPH96QT01"."ACE_A
PPLICATIONLIST" ("APPLICATIONID")                                               
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01IND"                                                 
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_APPLICATION_INI_FILES" ON "DPH96QT01"."ACE
_APPLICATION_INI_FILES" ("PROJECT_CODE", "RELEASE_CODE", "APPLICATIONID", "CONFI
GURATION_FILENAME")                                                             
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_TABLEDETAIL_SAFE" ON "DPH96QT01"."TABLEDET
AILS_SAFE" ("TDIDCODE", "TDKEY")                                                
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."PK_TABLEMAIN_SAFE" ON "DPH96QT01"."TABLEMAIN_
SAFE" ("TMIDCODE")                                                              
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."ACCOUNT_BALANCE_PK" ON "DPH96QT01"."ACCOUNT_B
ALANCE" ("INSTITUTION_ID", "ACCOUNT_NUMBER", "ENTRY_DATE")                      
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                
                                                                                
  CREATE UNIQUE INDEX "DPH96QT01"."MESSAGETYPE_PK" ON "DPH96QT01"."MESSAGETYPE" 
("TYPE", "TRANSACTIONGROUP")                                                    
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS                         
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645         
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1                                   
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)             
  TABLESPACE "TBS_DPH96QT01"                                                    
                                                                                

613 rows selected.

SQL> SPOOL OFF;
