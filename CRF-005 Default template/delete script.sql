-- [9.06.00.027.02] [20231206] [PTRAMBAKE] [START]

DELETE FROM TABLEDETAILS WHERE TDIDCODE = 'GENERIC-CONFIG' AND TDKEY='DEFAULT_TEMPLATE';

-- [9.06.00.027.02] [20231206] [PTRAMBAKE] [END]
COMMIT;
EXIT;