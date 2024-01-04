-- [8.1.90.7] [20221109] [PTRAMBAKE] [START]
SET DEFINE OFF;

DELETE FROM OB_XPATH_INSTPARMPATH_MAP WHERE XPATH_ROOT='ProductConfiguration' AND XPATH_NODE='Customer/IncomeExpansesAnalysisService/Redirectiondomains/domain';

DELETE FROM OB_XPATH_INSTPARMPATH_MAP WHERE XPATH_ROOT='ProductConfiguration' AND XPATH_NODE='Customer/IncomeExpansesAnalysisService/Subscription';

DELETE FROM OB_XPATH_INSTPARMPATH_MAP WHERE XPATH_ROOT='ProductConfiguration' AND XPATH_NODE='Customer/IncomeExpansesAnalysisService/LogoURL';

DELETE FROM OB_XPATH_INSTPARMPATH_MAP WHERE XPATH_ROOT='ProductConfiguration' AND XPATH_NODE='Customer/IncomeExpansesAnalysisService/VerificationRail';

DELETE FROM OB_XPATH_INSTPARMPATH_MAP WHERE XPATH_ROOT='ProductConfiguration' AND XPATH_NODE='Customer/IncomeExpansesAnalysisService/FlowType';

DELETE FROM OB_XPATH_INSTPARMPATH_MAP WHERE XPATH_ROOT='ProductConfiguration' AND XPATH_NODE='Customer/IncomeExpansesAnalysisService/RequestMethodS/ISEmail';

DELETE FROM OB_XPATH_INSTPARMPATH_MAP WHERE XPATH_ROOT='ProductConfiguration' AND XPATH_NODE='Customer/IncomeExpansesAnalysisService/RequestMethodS/ISSMS';

DELETE FROM OB_XPATH_INSTPARMPATH_MAP WHERE XPATH_ROOT='ProductConfiguration' AND XPATH_NODE='Customer/IncomeExpenseAnalysisService/Redirectiondomains/domain';

DELETE FROM OB_XPATH_INSTPARMPATH_MAP WHERE XPATH_ROOT='ProductConfiguration' AND XPATH_NODE='Customer/IncomeExpenseAnalysisService/Subscription';

DELETE FROM OB_XPATH_INSTPARMPATH_MAP WHERE XPATH_ROOT='ProductConfiguration' AND XPATH_NODE='Customer/IncomeExpenseAnalysisService/LogoURL';

DELETE FROM OB_XPATH_INSTPARMPATH_MAP WHERE XPATH_ROOT='ProductConfiguration' AND XPATH_NODE='Customer/IncomeExpenseAnalysisService/VerificationRail';

DELETE FROM OB_XPATH_INSTPARMPATH_MAP WHERE XPATH_ROOT='ProductConfiguration' AND XPATH_NODE='Customer/IncomeExpenseAnalysisService/FlowType';

DELETE FROM OB_XPATH_INSTPARMPATH_MAP WHERE XPATH_ROOT='ProductConfiguration' AND XPATH_NODE='Customer/IncomeExpenseAnalysisService/RequestMethodS/ISEmail';

DELETE FROM OB_XPATH_INSTPARMPATH_MAP WHERE XPATH_ROOT='ProductConfiguration' AND XPATH_NODE='Customer/IncomeExpenseAnalysisService/RequestMethodS/ISSMS';

Insert into OB_XPATH_INSTPARMPATH_MAP (XPATH_ROOT,XPATH_NODE,PARAMPATH,PARAMNAME,RECORD_TYPE,LABEL) values ('ProductConfiguration','Customer/IncomeExpenseAnalysisService/Redirectiondomains/domain','INCOME_EXPENSE_ANALYSIS_SERVICE.REDIRECTIONDOMAIN-[nn]','DOMAIN','T',null);

Insert into OB_XPATH_INSTPARMPATH_MAP (XPATH_ROOT,XPATH_NODE,PARAMPATH,PARAMNAME,RECORD_TYPE,LABEL) values ('ProductConfiguration','Customer/IncomeExpenseAnalysisService/Subscription','INCOME_EXPENSE_ANALYSIS_SERVICE.ACCOUNT.SUBSCRIPTION','SUBSCRIPTION','T',null);

Insert into OB_XPATH_INSTPARMPATH_MAP (XPATH_ROOT,XPATH_NODE,PARAMPATH,PARAMNAME,RECORD_TYPE,LABEL) values ('ProductConfiguration','Customer/IncomeExpenseAnalysisService/LogoURL','INCOME_EXPENSE_ANALYSIS_SERVICE.LOGOURL','LOGOURL','T',null);

Insert into OB_XPATH_INSTPARMPATH_MAP (XPATH_ROOT,XPATH_NODE,PARAMPATH,PARAMNAME,RECORD_TYPE,LABEL) values ('ProductConfiguration','Customer/IncomeExpenseAnalysisService/VerificationRail','INCOME_EXPENSE_ANALYSIS_SERVICE.VERIFICATIONRAIL','VERIFICATIONRAIL','T',null);

Insert into OB_XPATH_INSTPARMPATH_MAP (XPATH_ROOT,XPATH_NODE,PARAMPATH,PARAMNAME,RECORD_TYPE,LABEL) values ('ProductConfiguration','Customer/IncomeExpenseAnalysisService/FlowType','INCOME_EXPENSE_ANALYSIS_SERVICE.FLOWTYPE','FLOWTYPE','T',null);

Insert into OB_XPATH_INSTPARMPATH_MAP (XPATH_ROOT,XPATH_NODE,PARAMPATH,PARAMNAME,RECORD_TYPE,LABEL) values ('ProductConfiguration','Customer/IncomeExpenseAnalysisService/RequestMethodS/ISEmail','INCOME_EXPENSE_ANALYSIS_SERVICE.REQUESTMETHODS.ISEMAIL','ISEMAIL','T',null);

Insert into OB_XPATH_INSTPARMPATH_MAP (XPATH_ROOT,XPATH_NODE,PARAMPATH,PARAMNAME,RECORD_TYPE,LABEL) values ('ProductConfiguration','Customer/IncomeExpenseAnalysisService/RequestMethodS/ISSMS','INCOME_EXPENSE_ANALYSIS_SERVICE.REQUESTMETHODS.ISSMS','ISSMS','T',null);

DELETE FROM OB_XPATH_INSTPARMPATH_MAP WHERE XPATH_ROOT='ProductConfiguration' AND XPATH_NODE='Customer/AccountAggregationService/Redirectiondomains/domain';

DELETE FROM OB_XPATH_INSTPARMPATH_MAP WHERE XPATH_ROOT='ProductConfiguration' AND XPATH_NODE='Customer/AccountAggregationService/Subscription';

DELETE FROM OB_XPATH_INSTPARMPATH_MAP WHERE XPATH_ROOT='ProductConfiguration' AND XPATH_NODE='Customer/AccountAggregationService/LogoURL';

DELETE FROM OB_XPATH_INSTPARMPATH_MAP WHERE XPATH_ROOT='ProductConfiguration' AND XPATH_NODE='Customer/AccountAggregationService/VerificationRail';

DELETE FROM OB_XPATH_INSTPARMPATH_MAP WHERE XPATH_ROOT='ProductConfiguration' AND XPATH_NODE='Customer/AccountAggregationService/FlowType';

DELETE FROM OB_XPATH_INSTPARMPATH_MAP WHERE XPATH_ROOT='ProductConfiguration' AND XPATH_NODE='Customer/AccountAggregationService/RequestMethodS/ISEmail';

DELETE FROM OB_XPATH_INSTPARMPATH_MAP WHERE XPATH_ROOT='ProductConfiguration' AND XPATH_NODE='Customer/AccountAggregationService/RequestMethodS/ISSMS';

Insert into OB_XPATH_INSTPARMPATH_MAP (XPATH_ROOT,XPATH_NODE,PARAMPATH,PARAMNAME,RECORD_TYPE,LABEL) values ('ProductConfiguration','Customer/AccountAggregationService/Redirectiondomains/domain','ACCOUNT_AGGREGATION_SERVICE.REDIRECTIONDOMAIN-[nn]','DOMAIN','T',null);

Insert into OB_XPATH_INSTPARMPATH_MAP (XPATH_ROOT,XPATH_NODE,PARAMPATH,PARAMNAME,RECORD_TYPE,LABEL) values ('ProductConfiguration','Customer/AccountAggregationService/Subscription','ACCOUNT_AGGREGATION_SERVICE.ACCOUNT.SUBSCRIPTION','SUBSCRIPTION','T',null);

Insert into OB_XPATH_INSTPARMPATH_MAP (XPATH_ROOT,XPATH_NODE,PARAMPATH,PARAMNAME,RECORD_TYPE,LABEL) values ('ProductConfiguration','Customer/AccountAggregationService/LogoURL','ACCOUNT_AGGREGATION_SERVICE.LOGOURL','LOGOURL','T',null);

Insert into OB_XPATH_INSTPARMPATH_MAP (XPATH_ROOT,XPATH_NODE,PARAMPATH,PARAMNAME,RECORD_TYPE,LABEL) values ('ProductConfiguration','Customer/AccountAggregationService/VerificationRail','ACCOUNT_AGGREGATION_SERVICE.VERIFICATIONRAIL','VERIFICATIONRAIL','T',null);

Insert into OB_XPATH_INSTPARMPATH_MAP (XPATH_ROOT,XPATH_NODE,PARAMPATH,PARAMNAME,RECORD_TYPE,LABEL) values ('ProductConfiguration','Customer/AccountAggregationService/FlowType','ACCOUNT_AGGREGATION_SERVICE.FLOWTYPE','FLOWTYPE','T',null);

Insert into OB_XPATH_INSTPARMPATH_MAP (XPATH_ROOT,XPATH_NODE,PARAMPATH,PARAMNAME,RECORD_TYPE,LABEL) values ('ProductConfiguration','Customer/AccountAggregationService/RequestMethodS/ISEmail','ACCOUNT_AGGREGATION_SERVICE.REQUESTMETHODS.ISEMAIL','ISEMAIL','T',null);

Insert into OB_XPATH_INSTPARMPATH_MAP (XPATH_ROOT,XPATH_NODE,PARAMPATH,PARAMNAME,RECORD_TYPE,LABEL) values ('ProductConfiguration','Customer/AccountAggregationService/RequestMethodS/ISSMS','ACCOUNT_AGGREGATION_SERVICE.REQUESTMETHODS.ISSMS','ISSMS','T',null);

COMMIT;
-- [8.1.90.7] [20221109] [PTRAMBAKE] [START]
EXIT;
