SQL> SELECT DBMS_METADATA.GET_DEPENDENT_DDL('REF_CONSTRAINT',c.table_name)
  2  FROM user_constraints C WHERE c.constraint_type IN('R');

                                                                                
  ALTER TABLE "DPH96QT01"."VALIDATIONLIST" ADD CONSTRAINT "FK_VALIDATIONLIST" FO
REIGN KEY ("VALIDATIONID")                                                      
	  REFERENCES "DPH96QT01"."VALIDATIONMASTER" ("VALIDATIONID") ENABLE            
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."BPMPATTERNCOMPONENT" ADD CONSTRAINT "FK_BPMPATTERNCOM
PONENT" FOREIGN KEY ("BPMPATTERNID")                                            
	  REFERENCES "DPH96QT01"."BPMPATTERNMASTER" ("BPMPATTERNID") ENABLE            
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."ENHCRTRINSTANCEMAPINFO" ADD CONSTRAINT "FK_ENHCRTRINS
TANCEMAPINFO" FOREIGN KEY ("APPLICATIONID", "ID", "STANDARD", "RELEASE", "MSGINS
TANCENAME", "INOUTMSGFLAG")                                                     
	  REFERENCES "DPH96QT01"."ENHCRTRMSGRECORD" ("APPLICATIONID", "ID", "STANDARD",
 "RELEASE", "MSGINSTANCENAME", "INOUTMSGFLAG") ENABLE                           
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."PRODPROFILESCANFIELDS" ADD CONSTRAINT "FK_PRODPROFSCA
NFIELDS_PROFID" FOREIGN KEY ("PROFILEID")                                       
	  REFERENCES "DPH96QT01"."PROFILETBL" ("PROFILEID") ENABLE                     
  ALTER TABLE "DPH96QT01"."PRODPROFILESCANFIELDS" ADD CONSTRAINT "FK_PRODPROFILE
SCANFIELDS_PID" FOREIGN KEY ("PRODUCTID")                                       
	  REFERENCES "DPH96QT01"."PRODUCTS" ("PRODUCT_ID") ENABLE                      
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."PRODPROFILESCANFIELDS" ADD CONSTRAINT "FK_PRODPROFSCA
NFIELDS_PROFID" FOREIGN KEY ("PROFILEID")                                       
	  REFERENCES "DPH96QT01"."PROFILETBL" ("PROFILEID") ENABLE                     
  ALTER TABLE "DPH96QT01"."PRODPROFILESCANFIELDS" ADD CONSTRAINT "FK_PRODPROFILE
SCANFIELDS_PID" FOREIGN KEY ("PRODUCTID")                                       
	  REFERENCES "DPH96QT01"."PRODUCTS" ("PRODUCT_ID") ENABLE                      
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."PRODUCTPROFILESERVICEDTLSTBL" ADD CONSTRAINT "FK_PROD
UCTID" FOREIGN KEY ("PRODUCTID")                                                
	  REFERENCES "DPH96QT01"."PRODUCTS" ("PRODUCT_ID") ENABLE                      
  ALTER TABLE "DPH96QT01"."PRODUCTPROFILESERVICEDTLSTBL" ADD CONSTRAINT "FK_PROF
ILESERVICEDTLSTBL" FOREIGN KEY ("PROFILEID")                                    
	  REFERENCES "DPH96QT01"."PROFILETBL" ("PROFILEID") ENABLE                     
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."PRODUCTPROFILESERVICEDTLSTBL" ADD CONSTRAINT "FK_PROD
UCTID" FOREIGN KEY ("PRODUCTID")                                                
	  REFERENCES "DPH96QT01"."PRODUCTS" ("PRODUCT_ID") ENABLE                      
  ALTER TABLE "DPH96QT01"."PRODUCTPROFILESERVICEDTLSTBL" ADD CONSTRAINT "FK_PROF
ILESERVICEDTLSTBL" FOREIGN KEY ("PROFILEID")                                    
	  REFERENCES "DPH96QT01"."PROFILETBL" ("PROFILEID") ENABLE                     
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."DICTTYPE" ADD CONSTRAINT "FK_DICTTYPE_CONCEPTID" FORE
IGN KEY ("DEFAULTCONCEPTID")                                                    
	  REFERENCES "DPH96QT01"."CONCEPTMASTER" ("CONCEPTID") ENABLE                  
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."PATTERN" ADD CONSTRAINT "FK_PATTERN_PATTERNID" FOREIG
N KEY ("PATTERNID")                                                             
	  REFERENCES "DPH96QT01"."PATTERNMASTER" ("PATTERNID") ENABLE                  
  ALTER TABLE "DPH96QT01"."PATTERN" ADD CONSTRAINT "FK_PATTERN_ORGPATTRNID" FORE
IGN KEY ("ORIGINALPATTERNID")                                                   
	  REFERENCES "DPH96QT01"."PATTERNMASTER" ("PATTERNID") ENABLE                  
  ALTER TABLE "DPH96QT01"."PATTERN" ADD CONSTRAINT "FK_PATTERN_DICTTYPE" FOREIGN
 KEY ("DICTIONARYID", "INSTITUTIONID")                                          
	  REFERENCES "DPH96QT01"."DICTTYPE_INSTANCE" ("DICTIONARYID", "INSTITUTIONID") 
ENABLE                                                                          
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."PATTERN" ADD CONSTRAINT "FK_PATTERN_PATTERNID" FOREIG
N KEY ("PATTERNID")                                                             
	  REFERENCES "DPH96QT01"."PATTERNMASTER" ("PATTERNID") ENABLE                  
  ALTER TABLE "DPH96QT01"."PATTERN" ADD CONSTRAINT "FK_PATTERN_ORGPATTRNID" FORE
IGN KEY ("ORIGINALPATTERNID")                                                   
	  REFERENCES "DPH96QT01"."PATTERNMASTER" ("PATTERNID") ENABLE                  
  ALTER TABLE "DPH96QT01"."PATTERN" ADD CONSTRAINT "FK_PATTERN_DICTTYPE" FOREIGN
 KEY ("DICTIONARYID", "INSTITUTIONID")                                          
	  REFERENCES "DPH96QT01"."DICTTYPE_INSTANCE" ("DICTIONARYID", "INSTITUTIONID") 
ENABLE                                                                          
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."PATTERNCONCEPTS" ADD CONSTRAINT "FK_PATTERNCONCEPTS_D
ICTTYPE" FOREIGN KEY ("DICTIONARYID", "INSTITUTIONID")                          
	  REFERENCES "DPH96QT01"."DICTTYPE_INSTANCE" ("DICTIONARYID", "INSTITUTIONID") 
ENABLE                                                                          
  ALTER TABLE "DPH96QT01"."PATTERNCONCEPTS" ADD CONSTRAINT "FK_PATRNCPTS_CPTID" 
FOREIGN KEY ("CONCEPTID", "INSTITUTIONID")                                      
	  REFERENCES "DPH96QT01"."CONCEPTMASTER_INSTANCE" ("CONCEPTID", "INSTITUTIONID"
) ENABLE                                                                        
  ALTER TABLE "DPH96QT01"."PATTERNCONCEPTS" ADD CONSTRAINT "FK_PATTERNCONCEPTS_P
ATTERNID" FOREIGN KEY ("ORIGINALPATTERNID")                                     
	  REFERENCES "DPH96QT01"."PATTERNMASTER" ("PATTERNID") ENABLE                  
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."EMAIL_ATTACHMENTS" ADD CONSTRAINT "FK_EMAIL_ATTACHMEN
TS" FOREIGN KEY ("EMA_APPLICATION_ID", "EMA_MAIL_ID")                           
	  REFERENCES "DPH96QT01"."EMAIL_MAIN" ("EMM_APPLICATION_ID", "EMM_MAIL_ID") ENA
BLE                                                                             
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."EMAIL_USERS" ADD CONSTRAINT "FK_EMU_APPLNID" FOREIGN 
KEY ("EMU_APPLICATION_ID", "EMU_MAIL_ID")                                       
	  REFERENCES "DPH96QT01"."EMAIL_MAIN" ("EMM_APPLICATION_ID", "EMM_MAIL_ID") ENA
BLE                                                                             
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."LANGDESC" ADD CONSTRAINT "FK_LANGDESC" FOREIGN KEY ("
LANGCODE")                                                                      
	  REFERENCES "DPH96QT01"."LANG" ("LANGCODE") ENABLE                            
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."FAMILYMSGRECORD" ADD CONSTRAINT "FK_FAMILYMSGRECORD" 
FOREIGN KEY ("FMMSGFAMILYID")                                                   
	  REFERENCES "DPH96QT01"."FAMILYRECORD" ("FAFAMILYID") ENABLE                  
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."AML_CASE_TRANSACTION" ADD CONSTRAINT "ACT_MSGDB_ID_FK
" FOREIGN KEY ("ACT_TRAN_ID")                                                   
	  REFERENCES "DPH96QT01"."MSGDB" ("MSGDB_ID") ENABLE                           
  ALTER TABLE "DPH96QT01"."AML_CASE_TRANSACTION" ADD CONSTRAINT "ACT_AML_CASE_MT
_FK" FOREIGN KEY ("ACT_APPLICATION_ID", "ACT_CASE_ID", "ACT_INSTITUTIONID")     
	  REFERENCES "DPH96QT01"."AML_CASE_MANAGEMENT" ("ACM_APPLICATION_ID", "ACM_CASE
_ID", "ACM_INSTITUTIONID") ENABLE                                               
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."AML_CASE_USERS" ADD CONSTRAINT "AML_CASE_MGT_FK" FORE
IGN KEY ("ACU_APPLICATION_ID", "ACU_CASE_ID", "ACU_INSTITUTIONID")              
	  REFERENCES "DPH96QT01"."AML_CASE_MANAGEMENT" ("ACM_APPLICATION_ID", "ACM_CASE
_ID", "ACM_INSTITUTIONID") ENABLE                                               
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."AML_CASE_MANAGEMENT" ADD CONSTRAINT "AML_CASE_MANAGEM
ENT_FK" FOREIGN KEY ("ACM_CUST_TYPE", "ACM_CUST_CODE", "ACM_INSTITUTIONID")     
	  REFERENCES "DPH96QT01"."AML_CUST_INFO" ("ACI_CUST_TYPE", "ACI_CUST_CODE", "AC
I_INSTITUTIONID") ENABLE                                                        
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."AML_CUST_PARAM_INFO" ADD CONSTRAINT "ACPI_CUST_PARCD_
FK" FOREIGN KEY ("ACPI_PARA_CODE")                                              
	  REFERENCES "DPH96QT01"."AML_PARAMS" ("AP_NUMBER") ENABLE                     
  ALTER TABLE "DPH96QT01"."AML_CUST_PARAM_INFO" ADD CONSTRAINT "ACPI_CUST_TYPE_C
ODE_FK" FOREIGN KEY ("ACPI_CUST_TYPE", "ACPI_CUST_CODE", "ACPI_INSTITUTIONID")  
	  REFERENCES "DPH96QT01"."AML_CUST_INFO" ("ACI_CUST_TYPE", "ACI_CUST_CODE", "AC
I_INSTITUTIONID") ENABLE                                                        
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."AML_CUST_PARAM_INFO_SUMM" ADD CONSTRAINT "ACPIS_CUST_
TYPE_CODE_FK" FOREIGN KEY ("ACPIS_CUST_TYPE", "ACPIS_CUST_CODE", "ACPIS_INSTITUT
IONID")                                                                         
	  REFERENCES "DPH96QT01"."AML_CUST_INFO" ("ACI_CUST_TYPE", "ACI_CUST_CODE", "AC
I_INSTITUTIONID") ENABLE                                                        
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."AML_CUST_RISK_INFO" ADD CONSTRAINT "ACRI_CUST_PARCD_F
K" FOREIGN KEY ("ACRI_CUST_PARCD")                                              
	  REFERENCES "DPH96QT01"."AML_RISK_PARAMS" ("ARP_NUMBER") ENABLE               
  ALTER TABLE "DPH96QT01"."AML_CUST_RISK_INFO" ADD CONSTRAINT "ACRI_CUST_TYPE_CO
DE_FK" FOREIGN KEY ("ACRI_CUST_TYPE", "ACRI_CUST_CODE", "ACRI_INSTITUTIONID")   
	  REFERENCES "DPH96QT01"."AML_CUST_INFO" ("ACI_CUST_TYPE", "ACI_CUST_CODE", "AC
I_INSTITUTIONID") ENABLE                                                        
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."CUST_CONTACT" ADD CONSTRAINT "FK_CUST_CONTACT" FOREIG
N KEY ("ACI_CUST_TYPE", "ACI_CUST_CODE", "ACI_INSTITUTIONID")                   
	  REFERENCES "DPH96QT01"."AML_CUST_INFO" ("ACI_CUST_TYPE", "ACI_CUST_CODE", "AC
I_INSTITUTIONID") ENABLE                                                        
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."FIELD_VIOLATIONS" ADD CONSTRAINT "FK_FIELD_VIOLATIONS
" FOREIGN KEY ("MSGDB_ID")                                                      
	  REFERENCES "DPH96QT01"."MSGDB" ("MSGDB_ID") ENABLE                           
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."INSTITUTIONPARAMETERS" ADD CONSTRAINT "FK_INSTN_PARAM
_INSTNID" FOREIGN KEY ("INSTITUTIONID")                                         
	  REFERENCES "DPH96QT01"."INSTITUTIONMASTER" ("INSTITUTIONID") ENABLE          
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."ACCEPTDENYPHRASEPATTERN" ADD FOREIGN KEY ("PHRASEID")
                                                                                
	  REFERENCES "DPH96QT01"."ACCEPTDENYPHRASETABLE" ("PHRASEID") ENABLE           
  ALTER TABLE "DPH96QT01"."ACCEPTDENYPHRASEPATTERN" ADD FOREIGN KEY ("PATTERNID"
)                                                                               
	  REFERENCES "DPH96QT01"."PATTERNMASTER" ("PATTERNID") ENABLE                  
  ALTER TABLE "DPH96QT01"."ACCEPTDENYPHRASEPATTERN" ADD FOREIGN KEY ("DICTID")  
	  REFERENCES "DPH96QT01"."DICTTYPE" ("DICTIONARYID") ENABLE                    
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."ACCEPTDENYPHRASEPATTERN" ADD FOREIGN KEY ("PHRASEID")
                                                                                
	  REFERENCES "DPH96QT01"."ACCEPTDENYPHRASETABLE" ("PHRASEID") ENABLE           
  ALTER TABLE "DPH96QT01"."ACCEPTDENYPHRASEPATTERN" ADD FOREIGN KEY ("PATTERNID"
)                                                                               
	  REFERENCES "DPH96QT01"."PATTERNMASTER" ("PATTERNID") ENABLE                  
  ALTER TABLE "DPH96QT01"."ACCEPTDENYPHRASEPATTERN" ADD FOREIGN KEY ("DICTID")  
	  REFERENCES "DPH96QT01"."DICTTYPE" ("DICTIONARYID") ENABLE                    
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."ACCEPTDENYPHRASEPATTERN" ADD FOREIGN KEY ("PHRASEID")
                                                                                
	  REFERENCES "DPH96QT01"."ACCEPTDENYPHRASETABLE" ("PHRASEID") ENABLE           
  ALTER TABLE "DPH96QT01"."ACCEPTDENYPHRASEPATTERN" ADD FOREIGN KEY ("PATTERNID"
)                                                                               
	  REFERENCES "DPH96QT01"."PATTERNMASTER" ("PATTERNID") ENABLE                  
  ALTER TABLE "DPH96QT01"."ACCEPTDENYPHRASEPATTERN" ADD FOREIGN KEY ("DICTID")  
	  REFERENCES "DPH96QT01"."DICTTYPE" ("DICTIONARYID") ENABLE                    
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."SDNMASTER" ADD FOREIGN KEY ("SOURCENAME")            
	  REFERENCES "DPH96QT01"."SDNSOURCE" ("SOURCENAME") ENABLE                     
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."SDNADDRESS" ADD CONSTRAINT "FK_SDNADDR_SDNMST" FOREIG
N KEY ("SDNID")                                                                 
	  REFERENCES "DPH96QT01"."SDNMASTER" ("SDNID") ENABLE                          
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."ACCEPTDENYPHRASEINFO" ADD CONSTRAINT "ACCEPTDENYPHRAS
EINFO_FK" FOREIGN KEY ("PHRASEID")                                              
	  REFERENCES "DPH96QT01"."ACCEPTDENYPHRASETABLE" ("PHRASEID") ENABLE           
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."BRANCHMASTER" ADD CONSTRAINT "FK_BRANCHMASTER_PID" FO
REIGN KEY ("PROFILEID")                                                         
	  REFERENCES "DPH96QT01"."PROFILETBL" ("PROFILEID") ENABLE                     
  ALTER TABLE "DPH96QT01"."BRANCHMASTER" ADD CONSTRAINT "FK_BRANCHMASTER_BPID" F
OREIGN KEY ("BPMPATTERNID")                                                     
	  REFERENCES "DPH96QT01"."BPMPATTERNMASTER" ("BPMPATTERNID") ENABLE            
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."BRANCHMASTER" ADD CONSTRAINT "FK_BRANCHMASTER_PID" FO
REIGN KEY ("PROFILEID")                                                         
	  REFERENCES "DPH96QT01"."PROFILETBL" ("PROFILEID") ENABLE                     
  ALTER TABLE "DPH96QT01"."BRANCHMASTER" ADD CONSTRAINT "FK_BRANCHMASTER_BPID" F
OREIGN KEY ("BPMPATTERNID")                                                     
	  REFERENCES "DPH96QT01"."BPMPATTERNMASTER" ("BPMPATTERNID") ENABLE            
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."LITERAL" ADD CONSTRAINT "FK_LITERAL" FOREIGN KEY ("CO
DETYPE", "BANKCODE")                                                            
	  REFERENCES "DPH96QT01"."LITERALMAIN" ("CODETYPE", "BANKCODE") ENABLE         
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."CRI_CHANNEL_ROUTE_INFO" ADD CONSTRAINT "FK_CRI_CHANNE
L_ROUTE_INFO" FOREIGN KEY ("CRI_CHANNEL_ID", "CRI_INSTITUTIONID")               
	  REFERENCES "DPH96QT01"."CH_CHANNEL" ("CH_CHANNEL_ID", "CH_INSTITUTIONID") ENA
BLE                                                                             
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."TABLEDETAILS" ADD CONSTRAINT "FK_TDIDCODE" FOREIGN KE
Y ("TDIDCODE")                                                                  
	  REFERENCES "DPH96QT01"."TABLEMAIN" ("TMIDCODE") ENABLE                       
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."FORWARD_CONTRACT" ADD FOREIGN KEY ("FRWD_BASE_CUR")  
	  REFERENCES "DPH96QT01"."CURRENCYINFO" ("CURRENCYCODE") ENABLE                
  ALTER TABLE "DPH96QT01"."FORWARD_CONTRACT" ADD FOREIGN KEY ("FRWD_CONV_CUR")  
	  REFERENCES "DPH96QT01"."CURRENCYINFO" ("CURRENCYCODE") ENABLE                
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."FORWARD_CONTRACT" ADD FOREIGN KEY ("FRWD_BASE_CUR")  
	  REFERENCES "DPH96QT01"."CURRENCYINFO" ("CURRENCYCODE") ENABLE                
  ALTER TABLE "DPH96QT01"."FORWARD_CONTRACT" ADD FOREIGN KEY ("FRWD_CONV_CUR")  
	  REFERENCES "DPH96QT01"."CURRENCYINFO" ("CURRENCYCODE") ENABLE                
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."ACC_ENTRY" ADD FOREIGN KEY ("ACC_CURR_CODE")         
	  REFERENCES "DPH96QT01"."CURRENCYINFO" ("CURRENCYCODE") ENABLE                
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."EXCHANGE_RATE" ADD FOREIGN KEY ("XCHG_BASE_CUR")     
	  REFERENCES "DPH96QT01"."CURRENCYINFO" ("CURRENCYCODE") ENABLE                
  ALTER TABLE "DPH96QT01"."EXCHANGE_RATE" ADD FOREIGN KEY ("XCHG_CONV_CUR")     
	  REFERENCES "DPH96QT01"."CURRENCYINFO" ("CURRENCYCODE") ENABLE                
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."EXCHANGE_RATE" ADD FOREIGN KEY ("XCHG_BASE_CUR")     
	  REFERENCES "DPH96QT01"."CURRENCYINFO" ("CURRENCYCODE") ENABLE                
  ALTER TABLE "DPH96QT01"."EXCHANGE_RATE" ADD FOREIGN KEY ("XCHG_CONV_CUR")     
	  REFERENCES "DPH96QT01"."CURRENCYINFO" ("CURRENCYCODE") ENABLE                
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."ACE_SSIMASTER" ADD CONSTRAINT "ACE_SSIMASTER_1_FK" FO
REIGN KEY ("CURRENCY")                                                          
	  REFERENCES "DPH96QT01"."CURRENCYINFO" ("CURRENCYCODE") ENABLE                
  ALTER TABLE "DPH96QT01"."ACE_SSIMASTER" ADD CONSTRAINT "ACE_SSIMASTER_2_FK" FO
REIGN KEY ("BENF_BANK_CNTRY")                                                   
	  REFERENCES "DPH96QT01"."CTRYDB" ("CTRYCODE") ENABLE                          
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."ACE_SSIMASTER" ADD CONSTRAINT "ACE_SSIMASTER_1_FK" FO
REIGN KEY ("CURRENCY")                                                          
	  REFERENCES "DPH96QT01"."CURRENCYINFO" ("CURRENCYCODE") ENABLE                
  ALTER TABLE "DPH96QT01"."ACE_SSIMASTER" ADD CONSTRAINT "ACE_SSIMASTER_2_FK" FO
REIGN KEY ("BENF_BANK_CNTRY")                                                   
	  REFERENCES "DPH96QT01"."CTRYDB" ("CTRYCODE") ENABLE                          
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."CURRENCYINFO" ADD CONSTRAINT "FK_CURRENCYINFO" FOREIG
N KEY ("CHL_CLGSYS_ID", "CHL_INSTITUTIONID")                                    
	  REFERENCES "DPH96QT01"."CL_CLGSYS" ("CL_CLGSYS_ID", "CL_INSTITUTIONID") ENABL
E                                                                               
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."ER_EXCHANGE_RATE" ADD CONSTRAINT "FK_ER_EXCHANGE_RATE
" FOREIGN KEY ("ER_CURR_CODE")                                                  
	  REFERENCES "DPH96QT01"."CURRENCYINFO" ("CURRENCYCODE") ENABLE                
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."CTRYDB" ADD CONSTRAINT "FK_CTRYDB" FOREIGN KEY ("CURR
ENCYCODE")                                                                      
	  REFERENCES "DPH96QT01"."CURRENCYINFO" ("CURRENCYCODE") ENABLE                
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."CITY" ADD CONSTRAINT "FK_CITY" FOREIGN KEY ("COUNTRYC
ODE")                                                                           
	  REFERENCES "DPH96QT01"."CTRYDB" ("CTRYCODE") ENABLE                          
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."ENHCRTRMSGRECORD" ADD CONSTRAINT "FK_ENHCRTRMSGREC_AP
PNID" FOREIGN KEY ("APPLICATIONID", "ID", "STANDARD", "RELEASE")                
	  REFERENCES "DPH96QT01"."ENHCRTRMAPPINGREC" ("APPLICATIONID", "ID", "STANDARD"
, "RELEASE") ENABLE                                                             
  ALTER TABLE "DPH96QT01"."ENHCRTRMSGRECORD" ADD CONSTRAINT "FK_ENHCRTRMSGRECORD
" FOREIGN KEY ("MESSAGEID", "MSGSTANDARD", "MSGRELEASE")                        
	  REFERENCES "DPH96QT01"."COMPONENTRECORD" ("ID", "STANDARD", "RELEASE") ENABLE
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."ENHCRTRMSGRECORD" ADD CONSTRAINT "FK_ENHCRTRMSGREC_AP
PNID" FOREIGN KEY ("APPLICATIONID", "ID", "STANDARD", "RELEASE")                
	  REFERENCES "DPH96QT01"."ENHCRTRMAPPINGREC" ("APPLICATIONID", "ID", "STANDARD"
, "RELEASE") ENABLE                                                             
  ALTER TABLE "DPH96QT01"."ENHCRTRMSGRECORD" ADD CONSTRAINT "FK_ENHCRTRMSGRECORD
" FOREIGN KEY ("MESSAGEID", "MSGSTANDARD", "MSGRELEASE")                        
	  REFERENCES "DPH96QT01"."COMPONENTRECORD" ("ID", "STANDARD", "RELEASE") ENABLE
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."MESSAGEPATHRECORD" ADD CONSTRAINT "FK_MSGPATHREC_ID" 
FOREIGN KEY ("MSGID", "MSGSTANDARD", "MSGRELEASE")                              
	  REFERENCES "DPH96QT01"."COMPONENTRECORD" ("ID", "STANDARD", "RELEASE") ENABLE
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."ASSIGNCODELISTRECORD" ADD CONSTRAINT "FK_ACLREC_PATHI
D" FOREIGN KEY ("PATHID")                                                       
	  REFERENCES "DPH96QT01"."MESSAGEPATHRECORD" ("PATHID") ENABLE                 
  ALTER TABLE "DPH96QT01"."ASSIGNCODELISTRECORD" ADD CONSTRAINT "FK_ACLREC_CODEL
ISTID" FOREIGN KEY ("CODELISTID", "CODELISTSTANDARD", "CODELISTRELEASE")        
	  REFERENCES "DPH96QT01"."COMPONENTRECORD" ("ID", "STANDARD", "RELEASE") ENABLE
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."ASSIGNCODELISTRECORD" ADD CONSTRAINT "FK_ACLREC_PATHI
D" FOREIGN KEY ("PATHID")                                                       
	  REFERENCES "DPH96QT01"."MESSAGEPATHRECORD" ("PATHID") ENABLE                 
  ALTER TABLE "DPH96QT01"."ASSIGNCODELISTRECORD" ADD CONSTRAINT "FK_ACLREC_CODEL
ISTID" FOREIGN KEY ("CODELISTID", "CODELISTSTANDARD", "CODELISTRELEASE")        
	  REFERENCES "DPH96QT01"."COMPONENTRECORD" ("ID", "STANDARD", "RELEASE") ENABLE
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."CODEQUALIFIERVALIDATIONRECORD" ADD CONSTRAINT "FK_CQV
R_PATHID" FOREIGN KEY ("PATHID")                                                
	  REFERENCES "DPH96QT01"."MESSAGEPATHRECORD" ("PATHID") ENABLE                 
  ALTER TABLE "DPH96QT01"."CODEQUALIFIERVALIDATIONRECORD" ADD CONSTRAINT "FK_CQV
R_DEPENDENTPATHID" FOREIGN KEY ("DEPENDENTPATHID")                              
	  REFERENCES "DPH96QT01"."MESSAGEPATHRECORD" ("PATHID") ENABLE                 
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."CODEQUALIFIERVALIDATIONRECORD" ADD CONSTRAINT "FK_CQV
R_PATHID" FOREIGN KEY ("PATHID")                                                
	  REFERENCES "DPH96QT01"."MESSAGEPATHRECORD" ("PATHID") ENABLE                 
  ALTER TABLE "DPH96QT01"."CODEQUALIFIERVALIDATIONRECORD" ADD CONSTRAINT "FK_CQV
R_DEPENDENTPATHID" FOREIGN KEY ("DEPENDENTPATHID")                              
	  REFERENCES "DPH96QT01"."MESSAGEPATHRECORD" ("PATHID") ENABLE                 
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."IDENT_BUSI_ELEM" ADD CONSTRAINT "FK_IDENT_BUSI_ELEM" 
FOREIGN KEY ("BUSICLASSTYPE", "BUSICLASSID", "BUSICLASSSTANDARD", "BUSICLASSRELE
ASE")                                                                           
	  REFERENCES "DPH96QT01"."BUSI_CLASS_DOMAIN" ("TYPE", "ID", "STANDARD", "RELEAS
E") ENABLE                                                                      
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."ELEM_FRMT_LNK" ADD CONSTRAINT "FK_ELEM_FRMT_LNK" FORE
IGN KEY ("ID")                                                                  
	  REFERENCES "DPH96QT01"."IDENT_BUSI_ELEM" ("ID") ENABLE                       
  ALTER TABLE "DPH96QT01"."ELEM_FRMT_LNK" ADD CONSTRAINT "FK_ELEM_FRMT_LNK_FRMTI
D" FOREIGN KEY ("FRMTID", "STANDARD", "RELEASE")                                
	  REFERENCES "DPH96QT01"."BUSI_FRMT" ("ID", "STANDARD", "RELEASE") ENABLE      
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."ELEM_FRMT_LNK" ADD CONSTRAINT "FK_ELEM_FRMT_LNK" FORE
IGN KEY ("ID")                                                                  
	  REFERENCES "DPH96QT01"."IDENT_BUSI_ELEM" ("ID") ENABLE                       
  ALTER TABLE "DPH96QT01"."ELEM_FRMT_LNK" ADD CONSTRAINT "FK_ELEM_FRMT_LNK_FRMTI
D" FOREIGN KEY ("FRMTID", "STANDARD", "RELEASE")                                
	  REFERENCES "DPH96QT01"."BUSI_FRMT" ("ID", "STANDARD", "RELEASE") ENABLE      
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."ELE_DOMAIN_MAP" ADD CONSTRAINT "FK_ELE_DOMAIN_MAP" FO
REIGN KEY ("ID")                                                                
	  REFERENCES "DPH96QT01"."IDENT_BUSI_ELEM" ("ID") ENABLE                       
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."FIELDMAPRECORD" ADD CONSTRAINT "FK_FLDMAPRCRD_APPID" 
FOREIGN KEY ("APPLICATIONID", "ID", "STANDARD", "RELEASE")                      
	  REFERENCES "DPH96QT01"."ENHCRTRMAPPINGREC" ("APPLICATIONID", "ID", "STANDARD"
, "RELEASE") ENABLE                                                             
  ALTER TABLE "DPH96QT01"."FIELDMAPRECORD" ADD CONSTRAINT "FK_FLDMAPRCRD_OPMSGID
" FOREIGN KEY ("OUTPUTMSGPATHID")                                               
	  REFERENCES "DPH96QT01"."MESSAGEPATHRECORD" ("PATHID") ENABLE                 
  ALTER TABLE "DPH96QT01"."FIELDMAPRECORD" ADD CONSTRAINT "FK_FLDMAPRCRD_RULESET
" FOREIGN KEY ("RULESET", "RULENAME", "APPLICATIONID")                          
	  REFERENCES "DPH96QT01"."RULRULLIBTBL" ("LIBID", "RULENAME", "APPLICATIONID") 
ENABLE                                                                          
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."FIELDMAPRECORD" ADD CONSTRAINT "FK_FLDMAPRCRD_APPID" 
FOREIGN KEY ("APPLICATIONID", "ID", "STANDARD", "RELEASE")                      
	  REFERENCES "DPH96QT01"."ENHCRTRMAPPINGREC" ("APPLICATIONID", "ID", "STANDARD"
, "RELEASE") ENABLE                                                             
  ALTER TABLE "DPH96QT01"."FIELDMAPRECORD" ADD CONSTRAINT "FK_FLDMAPRCRD_OPMSGID
" FOREIGN KEY ("OUTPUTMSGPATHID")                                               
	  REFERENCES "DPH96QT01"."MESSAGEPATHRECORD" ("PATHID") ENABLE                 
  ALTER TABLE "DPH96QT01"."FIELDMAPRECORD" ADD CONSTRAINT "FK_FLDMAPRCRD_RULESET
" FOREIGN KEY ("RULESET", "RULENAME", "APPLICATIONID")                          
	  REFERENCES "DPH96QT01"."RULRULLIBTBL" ("LIBID", "RULENAME", "APPLICATIONID") 
ENABLE                                                                          
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."FIELDMAPRECORD" ADD CONSTRAINT "FK_FLDMAPRCRD_APPID" 
FOREIGN KEY ("APPLICATIONID", "ID", "STANDARD", "RELEASE")                      
	  REFERENCES "DPH96QT01"."ENHCRTRMAPPINGREC" ("APPLICATIONID", "ID", "STANDARD"
, "RELEASE") ENABLE                                                             
  ALTER TABLE "DPH96QT01"."FIELDMAPRECORD" ADD CONSTRAINT "FK_FLDMAPRCRD_OPMSGID
" FOREIGN KEY ("OUTPUTMSGPATHID")                                               
	  REFERENCES "DPH96QT01"."MESSAGEPATHRECORD" ("PATHID") ENABLE                 
  ALTER TABLE "DPH96QT01"."FIELDMAPRECORD" ADD CONSTRAINT "FK_FLDMAPRCRD_RULESET
" FOREIGN KEY ("RULESET", "RULENAME", "APPLICATIONID")                          
	  REFERENCES "DPH96QT01"."RULRULLIBTBL" ("LIBID", "RULENAME", "APPLICATIONID") 
ENABLE                                                                          
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."FIELDMAPINPUTPARAMETERS" ADD CONSTRAINT "FK_FLDMAPIP"
 FOREIGN KEY ("APPLICATIONID", "ID", "STANDARD", "RELEASE", "MAPPINGID")        
	  REFERENCES "DPH96QT01"."FIELDMAPRECORD" ("APPLICATIONID", "ID", "STANDARD", "
RELEASE", "MAPPINGID") ENABLE                                                   
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."FLDMAPINPUTPARAMSRECORD" ADD CONSTRAINT "FK_FMIPPRCRD
_TRANSID" FOREIGN KEY ("FMIPTRANSLATORID", "FMIPSTANDARD", "FMIPRELEASE", "FMIPM
APPINGID")                                                                      
	  REFERENCES "DPH96QT01"."FLDMAPRECORD" ("FMTRANSLATORID", "FMSTANDARD", "FMREL
EASE", "FMMAPPINGID") ENABLE                                                    
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."FMTVALIDATEFNREC" ADD CONSTRAINT "FK_FMVALDTREC" FORE
IGN KEY ("FMTVALID", "FMTVALSTANDARD", "FMTVALRELEASE")                         
	  REFERENCES "DPH96QT01"."FMTRECORD" ("FMTID", "FMTSTANDARD", "FMTRELEASE") ENA
BLE                                                                             
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."FRMT_FAM_MAP" ADD CONSTRAINT "FK_FRMT_FAM_MAP" FOREIG
N KEY ("ID", "STANDARD", "RELEASE")                                             
	  REFERENCES "DPH96QT01"."BUSI_FRMT" ("ID", "STANDARD", "RELEASE") ENABLE      
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."FRMT_FRMT_LNK" ADD CONSTRAINT "FK_FRMT_LNK_PARENTID" 
FOREIGN KEY ("PARENTFRMTID", "PARENTFRMTSTANDARD", "PARENTFRMTRELEASE")         
	  REFERENCES "DPH96QT01"."BUSI_FRMT" ("ID", "STANDARD", "RELEASE") ENABLE      
  ALTER TABLE "DPH96QT01"."FRMT_FRMT_LNK" ADD CONSTRAINT "FK_FRMT_LNK_CHILDID" F
OREIGN KEY ("CHILDFRMTID", "CHILDFRMTSTANDARD", "CHILDFRMTRELEASE")             
	  REFERENCES "DPH96QT01"."BUSI_FRMT" ("ID", "STANDARD", "RELEASE") ENABLE      
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."FRMT_FRMT_LNK" ADD CONSTRAINT "FK_FRMT_LNK_PARENTID" 
FOREIGN KEY ("PARENTFRMTID", "PARENTFRMTSTANDARD", "PARENTFRMTRELEASE")         
	  REFERENCES "DPH96QT01"."BUSI_FRMT" ("ID", "STANDARD", "RELEASE") ENABLE      
  ALTER TABLE "DPH96QT01"."FRMT_FRMT_LNK" ADD CONSTRAINT "FK_FRMT_LNK_CHILDID" F
OREIGN KEY ("CHILDFRMTID", "CHILDFRMTSTANDARD", "CHILDFRMTRELEASE")             
	  REFERENCES "DPH96QT01"."BUSI_FRMT" ("ID", "STANDARD", "RELEASE") ENABLE      
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."GLOBVARMSGPARAMS" ADD CONSTRAINT "FK_GVMP_TRANSID" FO
REIGN KEY ("GVMPTRANSLATORID", "GVMPSTANDARD", "GVMPRELEASE", "GVMPNAME")       
	  REFERENCES "DPH96QT01"."GLOBVARRECORD" ("GVTRANSLATORID", "GVSTANDARD", "GVRE
LEASE", "GVNAME") ENABLE                                                        
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."MSG_BUSI_ELEM_MAP" ADD CONSTRAINT "FK_MSG_BUSI_ELEM_M
AP_ID" FOREIGN KEY ("ID")                                                       
	  REFERENCES "DPH96QT01"."IDENT_BUSI_ELEM" ("ID") ENABLE                       
  ALTER TABLE "DPH96QT01"."MSG_BUSI_ELEM_MAP" ADD CONSTRAINT "FK_MSG_BUSI_ELEM_M
AP_MSGPATHID" FOREIGN KEY ("MSGCOMPPATHID")                                     
	  REFERENCES "DPH96QT01"."MESSAGEPATHRECORD" ("PATHID") ENABLE                 
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."MSG_BUSI_ELEM_MAP" ADD CONSTRAINT "FK_MSG_BUSI_ELEM_M
AP_ID" FOREIGN KEY ("ID")                                                       
	  REFERENCES "DPH96QT01"."IDENT_BUSI_ELEM" ("ID") ENABLE                       
  ALTER TABLE "DPH96QT01"."MSG_BUSI_ELEM_MAP" ADD CONSTRAINT "FK_MSG_BUSI_ELEM_M
AP_MSGPATHID" FOREIGN KEY ("MSGCOMPPATHID")                                     
	  REFERENCES "DPH96QT01"."MESSAGEPATHRECORD" ("PATHID") ENABLE                 
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."MSG_BUSI_FRMT_MAP" ADD CONSTRAINT "FK_MSG_BUSI_FRMT_M
AP_FRMTID" FOREIGN KEY ("FRMTID", "STANDARD", "RELEASE")                        
	  REFERENCES "DPH96QT01"."BUSI_FRMT" ("ID", "STANDARD", "RELEASE") ENABLE      
  ALTER TABLE "DPH96QT01"."MSG_BUSI_FRMT_MAP" ADD CONSTRAINT "FK_MSG_BUSI_FRMT_M
AP_MSGPATHID" FOREIGN KEY ("MSGCOMPPATHID")                                     
	  REFERENCES "DPH96QT01"."MESSAGEPATHRECORD" ("PATHID") ENABLE                 
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."MSG_BUSI_FRMT_MAP" ADD CONSTRAINT "FK_MSG_BUSI_FRMT_M
AP_FRMTID" FOREIGN KEY ("FRMTID", "STANDARD", "RELEASE")                        
	  REFERENCES "DPH96QT01"."BUSI_FRMT" ("ID", "STANDARD", "RELEASE") ENABLE      
  ALTER TABLE "DPH96QT01"."MSG_BUSI_FRMT_MAP" ADD CONSTRAINT "FK_MSG_BUSI_FRMT_M
AP_MSGPATHID" FOREIGN KEY ("MSGCOMPPATHID")                                     
	  REFERENCES "DPH96QT01"."MESSAGEPATHRECORD" ("PATHID") ENABLE                 
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."RELMASTER" ADD CONSTRAINT "FK_RELMASTER" FOREIGN KEY 
("STDID")                                                                       
	  REFERENCES "DPH96QT01"."STDMASTER" ("STDID") ENABLE                          
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."SEQUENCEMAPRECORD" ADD CONSTRAINT "FK_SEQUENCEAMPREC_
APPID" FOREIGN KEY ("APPLICATIONID", "ID", "STANDARD", "RELEASE")               
	  REFERENCES "DPH96QT01"."ENHCRTRMAPPINGREC" ("APPLICATIONID", "ID", "STANDARD"
, "RELEASE") ENABLE                                                             
  ALTER TABLE "DPH96QT01"."SEQUENCEMAPRECORD" ADD CONSTRAINT "FK_SEQUENCEAMPREC_
PATHID" FOREIGN KEY ("OUTPUTMSGPATHID")                                         
	  REFERENCES "DPH96QT01"."MESSAGEPATHRECORD" ("PATHID") ENABLE                 
  ALTER TABLE "DPH96QT01"."SEQUENCEMAPRECORD" ADD CONSTRAINT "FK_SEQUENCEAMPREC_
LIBID" FOREIGN KEY ("RULESET", "RULENAME", "APPLICATIONID")                     
	  REFERENCES "DPH96QT01"."RULRULLIBTBL" ("LIBID", "RULENAME", "APPLICATIONID") 
ENABLE                                                                          
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."SEQUENCEMAPRECORD" ADD CONSTRAINT "FK_SEQUENCEAMPREC_
APPID" FOREIGN KEY ("APPLICATIONID", "ID", "STANDARD", "RELEASE")               
	  REFERENCES "DPH96QT01"."ENHCRTRMAPPINGREC" ("APPLICATIONID", "ID", "STANDARD"
, "RELEASE") ENABLE                                                             
  ALTER TABLE "DPH96QT01"."SEQUENCEMAPRECORD" ADD CONSTRAINT "FK_SEQUENCEAMPREC_
PATHID" FOREIGN KEY ("OUTPUTMSGPATHID")                                         
	  REFERENCES "DPH96QT01"."MESSAGEPATHRECORD" ("PATHID") ENABLE                 
  ALTER TABLE "DPH96QT01"."SEQUENCEMAPRECORD" ADD CONSTRAINT "FK_SEQUENCEAMPREC_
LIBID" FOREIGN KEY ("RULESET", "RULENAME", "APPLICATIONID")                     
	  REFERENCES "DPH96QT01"."RULRULLIBTBL" ("LIBID", "RULENAME", "APPLICATIONID") 
ENABLE                                                                          
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."SEQUENCEMAPRECORD" ADD CONSTRAINT "FK_SEQUENCEAMPREC_
APPID" FOREIGN KEY ("APPLICATIONID", "ID", "STANDARD", "RELEASE")               
	  REFERENCES "DPH96QT01"."ENHCRTRMAPPINGREC" ("APPLICATIONID", "ID", "STANDARD"
, "RELEASE") ENABLE                                                             
  ALTER TABLE "DPH96QT01"."SEQUENCEMAPRECORD" ADD CONSTRAINT "FK_SEQUENCEAMPREC_
PATHID" FOREIGN KEY ("OUTPUTMSGPATHID")                                         
	  REFERENCES "DPH96QT01"."MESSAGEPATHRECORD" ("PATHID") ENABLE                 
  ALTER TABLE "DPH96QT01"."SEQUENCEMAPRECORD" ADD CONSTRAINT "FK_SEQUENCEAMPREC_
LIBID" FOREIGN KEY ("RULESET", "RULENAME", "APPLICATIONID")                     
	  REFERENCES "DPH96QT01"."RULRULLIBTBL" ("LIBID", "RULENAME", "APPLICATIONID") 
ENABLE                                                                          
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."SEQMAPINPUTPARAMETERS" ADD CONSTRAINT "FK_SEQMAPIPPAR
AM_APPID" FOREIGN KEY ("APPLICATIONID", "ID", "STANDARD", "RELEASE", "MAPPINGID"
)                                                                               
	  REFERENCES "DPH96QT01"."SEQUENCEMAPRECORD" ("APPLICATIONID", "ID", "STANDARD"
, "RELEASE", "MAPPINGID") ENABLE                                                
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."SEQMAPINPUTPARAMSRECORD" ADD CONSTRAINT "FK_SEQMAPIPP
ARAMREC" FOREIGN KEY ("SMIPTRANSLATORID", "SMIPSTANDARD", "SMIPRELEASE", "SMIPMA
PPINGID")                                                                       
	  REFERENCES "DPH96QT01"."SEQMAPRECORD" ("SMTRANSLATORID", "SMSTANDARD", "SMREL
EASE", "SMMAPPINGID") ENABLE                                                    
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."SUBCOMPONENTVALIDATEREC" ADD CONSTRAINT "FK_SUBCOMPVA
LREC_VALCMPID" FOREIGN KEY ("VALCMPID", "VALCMPSTANDARD", "VALCMPRELEASE", "VALS
EQNO")                                                                          
	  REFERENCES "DPH96QT01"."SUBCOMPONENTRECORD" ("CMPID", "CMPSTANDARD", "CMPRELE
ASE", "SEQNO") ENABLE                                                           
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."TRANSLATORMSGINSTANCEREC" ADD CONSTRAINT "FK_TMIR_TRA
NSID" FOREIGN KEY ("TMITRANSLATORID", "TMISTANDARD", "TMIRELEASE", "TMIMSGTYPE",
 "TMIMSGNAME")                                                                  
	  REFERENCES "DPH96QT01"."TRANSLATORMSGRECORD" ("TMTRANSLATORID", "TMSTANDARD",
 "TMRELEASE", "TMMSGTYPE", "TMMSGNAME") ENABLE                                  
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."MSGHDRTLR" ADD CONSTRAINT "FK_MSGHDRTLR" FOREIGN KEY 
("MSGDB_ID")                                                                    
	  REFERENCES "DPH96QT01"."MSGDB" ("MSGDB_ID") ENABLE                           
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."MSGALERTS" ADD CONSTRAINT "FK_MSGALERTS" FOREIGN KEY 
("MSGDB_ID")                                                                    
	  REFERENCES "DPH96QT01"."MSGDB" ("MSGDB_ID") ENABLE                           
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."MSGDB_OUTPUT" ADD CONSTRAINT "FK_MSGDB_OUTPUT" FOREIG
N KEY ("MSGDB_ID")                                                              
	  REFERENCES "DPH96QT01"."MSGDB" ("MSGDB_ID") ENABLE                           
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."MSGDB_COMMENTS" ADD CONSTRAINT "MSGDB_ID_FK" FOREIGN 
KEY ("MSGDB_ID")                                                                
	  REFERENCES "DPH96QT01"."MSGDB" ("MSGDB_ID") ENABLE                           
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."AML_PARAMS" ADD CONSTRAINT "AP_LIB_RULE_APPL_FK" FORE
IGN KEY ("AP_LIB_ID", "AP_LIB_RULE", "AP_LIB_APPL_ID")                          
	  REFERENCES "DPH96QT01"."RULRULLIBTBL" ("LIBID", "RULENAME", "APPLICATIONID") 
ENABLE                                                                          
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."AML_CUST_ACC_INFO" ADD CONSTRAINT "ACAI_PROD_CODE_FK"
 FOREIGN KEY ("ACAI_PROD_CODE")                                                 
	  REFERENCES "DPH96QT01"."AML_BANK_PRODUCTS" ("ABP_CODE") ENABLE               
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."AML_CUST_PARAM_INFO" ADD CONSTRAINT "ACPI_CUST_PARCD_
FK" FOREIGN KEY ("ACPI_PARA_CODE")                                              
	  REFERENCES "DPH96QT01"."AML_PARAMS" ("AP_NUMBER") ENABLE                     
  ALTER TABLE "DPH96QT01"."AML_CUST_PARAM_INFO" ADD CONSTRAINT "ACPI_CUST_TYPE_C
ODE_FK" FOREIGN KEY ("ACPI_CUST_TYPE", "ACPI_CUST_CODE", "ACPI_INSTITUTIONID")  
	  REFERENCES "DPH96QT01"."AML_CUST_INFO" ("ACI_CUST_TYPE", "ACI_CUST_CODE", "AC
I_INSTITUTIONID") ENABLE                                                        
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."AML_ACC_PARAM_INFO" ADD CONSTRAINT "AAPI_ACCT_PARCD_F
K" FOREIGN KEY ("AAPI_PARA_CODE")                                               
	  REFERENCES "DPH96QT01"."AML_PARAMS" ("AP_NUMBER") ENABLE                     
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."AML_ACC_PARAM_INFO_SUMM" ADD CONSTRAINT "AAPIS_ACCT_N
UMBER_FK" FOREIGN KEY ("AAPIS_ACCT_NUMBER")                                     
	  REFERENCES "DPH96QT01"."AML_CUST_ACC_INFO" ("ACAI_ACCT_NUMBER") ENABLE       
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."AML_CASE_TRANSACTION" ADD CONSTRAINT "ACT_MSGDB_ID_FK
" FOREIGN KEY ("ACT_TRAN_ID")                                                   
	  REFERENCES "DPH96QT01"."MSGDB" ("MSGDB_ID") ENABLE                           
  ALTER TABLE "DPH96QT01"."AML_CASE_TRANSACTION" ADD CONSTRAINT "ACT_AML_CASE_MT
_FK" FOREIGN KEY ("ACT_APPLICATION_ID", "ACT_CASE_ID", "ACT_INSTITUTIONID")     
	  REFERENCES "DPH96QT01"."AML_CASE_MANAGEMENT" ("ACM_APPLICATION_ID", "ACM_CASE
_ID", "ACM_INSTITUTIONID") ENABLE                                               
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."AML_RISK_PARAMS" ADD CONSTRAINT "ARP_LIB_RULE_APPL_FK
" FOREIGN KEY ("ARP_LIB_ID", "ARP_LIB_RULE", "ARP_LIB_APPL_ID")                 
	  REFERENCES "DPH96QT01"."RULRULLIBTBL" ("LIBID", "RULENAME", "APPLICATIONID") 
ENABLE                                                                          
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."AML_CUST_RISK_INFO" ADD CONSTRAINT "ACRI_CUST_PARCD_F
K" FOREIGN KEY ("ACRI_CUST_PARCD")                                              
	  REFERENCES "DPH96QT01"."AML_RISK_PARAMS" ("ARP_NUMBER") ENABLE               
  ALTER TABLE "DPH96QT01"."AML_CUST_RISK_INFO" ADD CONSTRAINT "ACRI_CUST_TYPE_CO
DE_FK" FOREIGN KEY ("ACRI_CUST_TYPE", "ACRI_CUST_CODE", "ACRI_INSTITUTIONID")   
	  REFERENCES "DPH96QT01"."AML_CUST_INFO" ("ACI_CUST_TYPE", "ACI_CUST_CODE", "AC
I_INSTITUTIONID") ENABLE                                                        
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."ANALYSISDETAILS" ADD CONSTRAINT "ANALYSISDETAILS_FK" 
FOREIGN KEY ("ANALYSISID")                                                      
	  REFERENCES "DPH96QT01"."GLOBALINFO" ("ANALYSISID") ENABLE                    
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."MESSAGESTATS" ADD CONSTRAINT "MESSAGESTATS_FK" FOREIG
N KEY ("ANALYSISID", "ANALYSISTYPE")                                            
	  REFERENCES "DPH96QT01"."ANALYSISDETAILS" ("ANALYSISID", "ANALYSISTYPE") ENABL
E                                                                               
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."FIELDSTATS" ADD CONSTRAINT "FIELDSTATS_FK" FOREIGN KE
Y ("ANALYSISID", "ANALYSISTYPE", "ANALYSISCODE", "MSGTYPE", "FILTERCODEFORVIO") 
	  REFERENCES "DPH96QT01"."MESSAGESTATS" ("ANALYSISID", "ANALYSISTYPE", "ANALYSI
SCODE", "MSGTYPE", "FILTERCODEFORVIO") ENABLE                                   
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."VIOLATIONSTATS" ADD CONSTRAINT "VIOLATIONSTATS_FK" FO
REIGN KEY ("ANALYSISID", "ANALYSISTYPE", "ANALYSISCODE", "MSGTYPE", "FILTERCODEF
ORVIO", "FIELDNO")                                                              
	  REFERENCES "DPH96QT01"."FIELDSTATS" ("ANALYSISID", "ANALYSISTYPE", "ANALYSISC
ODE", "MSGTYPE", "FILTERCODEFORVIO", "FIELDNO") ENABLE                          
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."VIOLNTBL" ADD CONSTRAINT "FK_VIOLNTBL" FOREIGN KEY ("
SEVERITY")                                                                      
	  REFERENCES "DPH96QT01"."SEVRTYTBL" ("SEVERITY") ENABLE                       
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."INSTITUTION_OTHERNAME" ADD CONSTRAINT "INSTITUTION_OT
HERNAME_FK" FOREIGN KEY ("SERIALNUMBER")                                        
	  REFERENCES "DPH96QT01"."INSTITUTION_INFO" ("SERIALNUMBER") ENABLE            
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."INSTITUTION_CODE" ADD CONSTRAINT "INSTITUTION_CODE_FK
" FOREIGN KEY ("SERIALNUMBER")                                                  
	  REFERENCES "DPH96QT01"."INSTITUTION_INFO" ("SERIALNUMBER") ENABLE            
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."BILLPROFCORRTBL" ADD CONSTRAINT "FK_BILLPROFCORRTBL" 
FOREIGN KEY ("BILLPROFID")                                                      
	  REFERENCES "DPH96QT01"."BILLPROFTBL" ("BILLPROFID") ENABLE                   
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."BILLPROFSEVTBL" ADD CONSTRAINT "FK_BILLPROFSEVTBL" FO
REIGN KEY ("BILLPROFID")                                                        
	  REFERENCES "DPH96QT01"."BILLPROFTBL" ("BILLPROFID") ENABLE                   
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."MSGBLOCKS" ADD CONSTRAINT "FK_MSGBLOCKS" FOREIGN KEY 
("MSGDB_ID")                                                                    
	  REFERENCES "DPH96QT01"."MSGDB" ("MSGDB_ID") ENABLE                           
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."MSGDB_FILE" ADD CONSTRAINT "FK_MSGDB_FILE" FOREIGN KE
Y ("MSGDB_ID")                                                                  
	  REFERENCES "DPH96QT01"."MSGDB" ("MSGDB_ID") ENABLE                           
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."MSGDB_PAY" ADD CONSTRAINT "FK_MSGDB_PAY" FOREIGN KEY 
("MSGDB_ID")                                                                    
	  REFERENCES "DPH96QT01"."MSGDB" ("MSGDB_ID") ENABLE                           
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."MSGDB_SWIFTNET" ADD CONSTRAINT "FK_SWIFTNET" FOREIGN 
KEY ("MSGDB_ID")                                                                
	  REFERENCES "DPH96QT01"."MSGDB" ("MSGDB_ID") ENABLE                           
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."MANDATE" ADD CONSTRAINT "FK_INSTLOC_ID" FOREIGN KEY (
"LOCATIONID", "INSTITUTION_ID")                                                 
	  REFERENCES "DPH96QT01"."LOCATIONDETAILS" ("LOCATIONID", "INSTITUTIONID") ENAB
LE                                                                              
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."MANDATE_UPDATE" ADD CONSTRAINT "FK_INSTILOC_ID" FOREI
GN KEY ("LOCATIONID", "INSTITUTION_ID")                                         
	  REFERENCES "DPH96QT01"."LOCATIONDETAILS" ("LOCATIONID", "INSTITUTIONID") ENAB
LE                                                                              
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."MANDATE_CACHE" ADD CONSTRAINT "FK_INSTILOCA_ID" FOREI
GN KEY ("LOCATIONID", "INSTITUTION_ID")                                         
	  REFERENCES "DPH96QT01"."LOCATIONDETAILS" ("LOCATIONID", "INSTITUTIONID") ENAB
LE                                                                              
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."NOTIFICATION_COMMENTS" ADD CONSTRAINT "FK_NOTIFICATIO
N_COMMENTS" FOREIGN KEY ("NOTIFICATION_NO")                                     
	  REFERENCES "DPH96QT01"."NOTIFICATION" ("NOTIFICATION_NO") ENABLE             
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."PAYMENT_TXN_SCAN" ADD CONSTRAINT "FK_PAYT_TXN_ID" FOR
EIGN KEY ("PYMT_TXN_ID")                                                        
	  REFERENCES "DPH96QT01"."PAYMENT_TXN" ("PYMT_TXN_ID") ENABLE                  
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."MSGDB" ADD FOREIGN KEY ("INSTITUTIONID", "QUEUEID")  
	  REFERENCES "DPH96QT01"."QUEUE" ("INSTITUTIONID", "QUEUEID") ENABLE           
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."MSGDB_CATEGORIZATION" ADD CONSTRAINT "FK_MSGDB" FOREI
GN KEY ("MSGDB_ID")                                                             
	  REFERENCES "DPH96QT01"."MSGDB" ("MSGDB_ID") ENABLE                           
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."PATTERN" ADD CONSTRAINT "FK_PATTERN_PATTERNID" FOREIG
N KEY ("PATTERNID")                                                             
	  REFERENCES "DPH96QT01"."PATTERNMASTER" ("PATTERNID") ENABLE                  
  ALTER TABLE "DPH96QT01"."PATTERN" ADD CONSTRAINT "FK_PATTERN_ORGPATTRNID" FORE
IGN KEY ("ORIGINALPATTERNID")                                                   
	  REFERENCES "DPH96QT01"."PATTERNMASTER" ("PATTERNID") ENABLE                  
  ALTER TABLE "DPH96QT01"."PATTERN" ADD CONSTRAINT "FK_PATTERN_DICTTYPE" FOREIGN
 KEY ("DICTIONARYID", "INSTITUTIONID")                                          
	  REFERENCES "DPH96QT01"."DICTTYPE_INSTANCE" ("DICTIONARYID", "INSTITUTIONID") 
ENABLE                                                                          
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."PATTERNCONCEPTS" ADD CONSTRAINT "FK_PATTERNCONCEPTS_D
ICTTYPE" FOREIGN KEY ("DICTIONARYID", "INSTITUTIONID")                          
	  REFERENCES "DPH96QT01"."DICTTYPE_INSTANCE" ("DICTIONARYID", "INSTITUTIONID") 
ENABLE                                                                          
  ALTER TABLE "DPH96QT01"."PATTERNCONCEPTS" ADD CONSTRAINT "FK_PATRNCPTS_CPTID" 
FOREIGN KEY ("CONCEPTID", "INSTITUTIONID")                                      
	  REFERENCES "DPH96QT01"."CONCEPTMASTER_INSTANCE" ("CONCEPTID", "INSTITUTIONID"
) ENABLE                                                                        
  ALTER TABLE "DPH96QT01"."PATTERNCONCEPTS" ADD CONSTRAINT "FK_PATTERNCONCEPTS_P
ATTERNID" FOREIGN KEY ("ORIGINALPATTERNID")                                     
	  REFERENCES "DPH96QT01"."PATTERNMASTER" ("PATTERNID") ENABLE                  
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."PATTERNCONCEPTS" ADD CONSTRAINT "FK_PATTERNCONCEPTS_D
ICTTYPE" FOREIGN KEY ("DICTIONARYID", "INSTITUTIONID")                          
	  REFERENCES "DPH96QT01"."DICTTYPE_INSTANCE" ("DICTIONARYID", "INSTITUTIONID") 
ENABLE                                                                          
  ALTER TABLE "DPH96QT01"."PATTERNCONCEPTS" ADD CONSTRAINT "FK_PATRNCPTS_CPTID" 
FOREIGN KEY ("CONCEPTID", "INSTITUTIONID")                                      
	  REFERENCES "DPH96QT01"."CONCEPTMASTER_INSTANCE" ("CONCEPTID", "INSTITUTIONID"
) ENABLE                                                                        
  ALTER TABLE "DPH96QT01"."PATTERNCONCEPTS" ADD CONSTRAINT "FK_PATTERNCONCEPTS_P
ATTERNID" FOREIGN KEY ("ORIGINALPATTERNID")                                     
	  REFERENCES "DPH96QT01"."PATTERNMASTER" ("PATTERNID") ENABLE                  
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."MSGDB_PARAMETERS" ADD CONSTRAINT "MSGDB_PARAMETERS_FK
" FOREIGN KEY ("MSGDB_ID")                                                      
	  REFERENCES "DPH96QT01"."MSGDB" ("MSGDB_ID") ENABLE                           
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."MSGDB_KEYINFO" ADD CONSTRAINT "FK_MSGDB_KEYINFO" FORE
IGN KEY ("MSGDB_ID")                                                            
	  REFERENCES "DPH96QT01"."MSGDB" ("MSGDB_ID") ENABLE                           
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."ACE_APPLICATION_TEMPLATE_FILES" ADD CONSTRAINT "FK_TE
MP_FILE" FOREIGN KEY ("APPLICATIONID", "PRODUCT_LINE", "PRODUCT_VERSION")       
	  REFERENCES "DPH96QT01"."ACE_APPLICATION" ("APPLICATIONID", "PRODUCT_LINE", "P
RODUCT_VERSION") ENABLE                                                         
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."ACE_PROJECT_RELEASE_INFO" ADD CONSTRAINT "FK_PROJECT_
RELEASE_INFO" FOREIGN KEY ("PROJECT_CODE")                                      
	  REFERENCES "DPH96QT01"."ACE_PROJECT_MASTER_INFO" ("PROJECT_CODE") ENABLE     
                                                                                
                                                                                
  ALTER TABLE "DPH96QT01"."ACE_PROJECT_MASTER_INFO" ADD CONSTRAINT "FK_PROJECT_M
ASTER_INFO" FOREIGN KEY ("INSTITUTIONID")                                       
	  REFERENCES "DPH96QT01"."ACE_CLIENT_DETAILS" ("INSTITUTIONID") ENABLE         
                                                                                

119 rows selected.

SQL> commit;
ERROR:
ORA-03114: not connected to ORACLE 


commit
*
ERROR at line 1:
ORA-03113: end-of-file on communication channel 
Process ID: 418942 
Session ID: 52 Serial number: 64198 


SQL> spool off;
