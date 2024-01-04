-- [9.06.00.012.02] [20231022] [PTRAMBAKE] [START]
SET SERVEROUTPUT ON;
DECLARE
    m_msgdb_id              msgdb.msgdb_id%type             := NULL;
    m_messageno             msgdb.messageno%type            := NULL;
    m_CUSTOM7               msgdb.CUSTOM7%type              := NULL;
    m_tdvalue               tabledetails.tdvalue%type       := NULL;
    m_messageclasstype_beg  NUMBER                          :=0;
    m_messageclasstype_end  NUMBER                          :=0;
    m_institutionid_beg     NUMBER                          :=0;
    m_institutionid_end     NUMBER                          :=0;
    m_location_beg          NUMBER                          :=0;
    m_location_end          NUMBER                          :=0;
    m_keyid                 msgblocks.key_id%type           :='PELICAN_INTERNAL_KEY_ID';
    m_secretkey             VARCHAR2(32767)                 := NULL;
    m_pac3_blob             BLOB;
    m_pac8_blob             BLOB;
    g_application           GENAUDIT.application%TYPE       := 'PELICAN';
    g_modulename            GENAUDIT.modulename%TYPE        := 'DASHBOARD';
    g_action                GENAUDIT.action%TYPE            := 'INSERT';
    TEMPLATES_ALREADY_INSERTED EXCEPTION;
  
    m_pacs3_1_2_175_clob CLOB := '<FIToFICstmrDrctDbt>
   <GrpHdr>
      <MsgId>20230904134549153</MsgId>
      <CreDtTm>2023-09-04T13:45:49</CreDtTm>
      <NbOfTxs>1</NbOfTxs>
      <TtlIntrBkSttlmAmt Ccy="EUR"/>
      <IntrBkSttlmDt>2023-09-04</IntrBkSttlmDt>
      <SttlmInf>
         <SttlmMtd>CLRG</SttlmMtd>
      </SttlmInf>
      <InstgAgt>
         <FinInstnId>
            <BIC>SANTATWWXXX</BIC>
         </FinInstnId>
      </InstgAgt>
      <InstdAgt>
         <FinInstnId>
            <BIC>RZBAATWWXXX</BIC>
         </FinInstnId>
      </InstdAgt>
   </GrpHdr>
   <DrctDbtTxInf>
      <PmtId>
         <EndToEndId>null</EndToEndId>
         <TxId>null</TxId>
      </PmtId>
      <PmtTpInf>
         <SvcLvl>
            <Cd>SEPA</Cd>
         </SvcLvl>
         <LclInstrm>
            <Cd>CORE</Cd>
         </LclInstrm>
      </PmtTpInf>
      <IntrBkSttlmAmt Ccy="EUR"/>
      <ChrgBr>SLEV</ChrgBr>
      <ReqdColltnDt>2023-09-04</ReqdColltnDt>
      <DrctDbtTx>
         <MndtRltdInf>
            <DtOfSgntr>2023-09-04</DtOfSgntr>
            <AmdmntInd>false</AmdmntInd>
         </MndtRltdInf>
      </DrctDbtTx>
      <Cdtr/>
      <CdtrAgt>
         <FinInstnId>
            <BIC>SANTATWWXXX</BIC>
         </FinInstnId>
      </CdtrAgt>
      <Dbtr/>
      <DbtrAgt>
         <FinInstnId>
            <BIC>SANTATWWXXX</BIC>
         </FinInstnId>
      </DbtrAgt>
   </DrctDbtTxInf>
</FIToFICstmrDrctDbt>';

    m_pacs8_1_2_175_clob CLOB := '<FIToFICstmrCdtTrf>
   <GrpHdr>
      <MsgId>20230904131902218</MsgId>
      <CreDtTm>2023-09-04T13:19:02</CreDtTm>
      <NbOfTxs>1</NbOfTxs>
      <TtlIntrBkSttlmAmt Ccy="EUR"/>
      <IntrBkSttlmDt>2023-09-04</IntrBkSttlmDt>
      <SttlmInf>
         <SttlmMtd>CLRG</SttlmMtd>
      </SttlmInf>
      <InstgAgt>
         <FinInstnId>
            <BIC>SANTATWWXXX</BIC>
         </FinInstnId>
      </InstgAgt>
   </GrpHdr>
   <CdtTrfTxInf>
      <PmtId>
         <EndToEndId>2023090413174435</EndToEndId>
         <TxId>2023090413174435</TxId>
      </PmtId>
      <PmtTpInf>
         <SvcLvl>
            <Cd>SEPA</Cd>
         </SvcLvl>
      </PmtTpInf>
      <IntrBkSttlmAmt Ccy="EUR"/>
      <ChrgBr>SLEV</ChrgBr>
      <Dbtr>
         <Nm/>
      </Dbtr>
      <DbtrAcct>
         <Id>
            <IBAN/>
         </Id>
      </DbtrAcct>
      <DbtrAgt>
         <FinInstnId>
            <BIC>SANTATWWXXX</BIC>
         </FinInstnId>
      </DbtrAgt>
      <CdtrAgt>
         <FinInstnId>
            <BIC>SANTATWWXXX</BIC>
         </FinInstnId>
      </CdtrAgt>
      <Cdtr>
         <Nm/>
      </Cdtr>
   </CdtTrfTxInf>
</FIToFICstmrCdtTrf>' ; 

    
    TYPE t_messageclasstype IS RECORD (
      messageclasstype        msgdb.messageclasstype%TYPE
    );
    
    TYPE t_institutionid IS RECORD (
      institutionid        msgdb.institutionid%TYPE
    );
    
    TYPE t_location IS RECORD (
      msgsegr        msgdb.msgsegr%TYPE
    );
    
    TYPE a_messageclasstype IS TABLE OF t_messageclasstype;
    s_messageclasstype         a_messageclasstype           := a_messageclasstype();

    TYPE a_institutionid IS TABLE OF t_institutionid;
    s_institutionid         a_institutionid           := a_institutionid();

    TYPE a_location IS TABLE OF t_location;
    s_location         a_location           := a_location();

    
    CURSOR c_messageclasstype 
    is
    SELECT para_code messagetype
    FROM TABLE (get_code_from_list ('pacs.003.001.08,pacs.008.001.08', ','));
    
    CURSOR c_institutionid 
    is
    SELECT para_code institutionid
    FROM TABLE (get_code_from_list ('SANTATWW,SANTAT00,ACEABANK,PLCNGBWB', ','));

    CURSOR c_location 
    IS
    SELECT para_code location
    FROM TABLE (get_code_from_list (('AT,DEFAULT,0000001'), ','));

    PROCEDURE INSERT_BLOB_RECORD
    (
    p_msgdb_id       IN NUMBER,
    p_msgblocktype IN NUMBER,
    p_blob_message IN BLOB
    ) AS
    BEGIN
        INSERT INTO MSGBLOCKS(
        MSGDB_ID,
        MSGBLOCKTYPE,
        MSGFAMILY, 
        MESSAGE,
        KEY_ID, 
        DISPLAY_FLAG)
        VALUES
        (
        p_msgdb_id,
        p_msgblocktype,
        'SEPA',
         p_blob_message,
          m_keyid, 
          'Y'
          );
    END INSERT_BLOB_RECORD;

    
  
BEGIN
    BEGIN 
        SELECT tdvalue 
        INTO m_tdvalue 
        FROM TABLEDETAILS 
        WHERE TDIDCODE = 'GENERIC-CONFIG'
        AND TDKEY='DEFAULT_TEMPLATE';
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
         m_tdvalue := 'N';
    END;
    
    IF m_tdvalue = 'Y'
    THEN
        RAISE TEMPLATES_ALREADY_INSERTED;
    END IF;
    
    

    Getkeyidandsecretkey (m_keyid,m_secretkey);
    
    
    m_pac3_blob := clob_to_blob('{"accountInfo":{"account_number":"","account_curr":"","institutionname":"","bank_code":"SANTATWWXXX","account_desc":"","accountMode":null,"customerId":null,"actualAccNum":null,"currency_symbol":null,"bank_logo":null,"bankLabel":null,"scheme":null,"ordering_address":"","priority":null,"swift_priority":null,"balance":null,"virtualBalance":"","idType":null,"idValue":null,"nameAndAddress":"Santander Consumer Bank GmbH\nWagramer Strasse 19\nWien\nAUSTRIA","option":null,"partyId":null,"residenceDetails":null,"senderToReceiverInfo":null,"addressList":null,"nameAndAddressList":null,"country":null,"postalCode":null,"city":null,"buildingNo":null,"streetName":null,"clearingSystem":null,"clearingSystemCode":null,"clearingSystemMemberId":null,"bankName":null,"bankAddress":null,"bankPostalCode":null,"bankTown":null,"bankCountry":null,"lei":null,"mmbid":null,"orderingInfo":null,"id":"","accounttype":null,"datakeyid":null,"account_NUMBER_ENC":null,"account_IBAN_ENC":null,"account_TITLE_ENC":null},"ordAccountInfo":null,"beneficiaryInfo":{"ncp_name":null,"ncp_address_1":null,"ncp_address_2":null,"ncp_address_3":null,"ncp_code":"","ncp_bic":"SANTATWWXXX","institution":null,"scheme":null,"beneficiary_address":"","address":"","buildingNo":null,"city":null,"country":null,');
    DBMS_LOB.APPEND(m_pac3_blob, clob_to_blob('"postalCode":null,"streetDetails":null,"ncp_logo":null,"idType":null,"idValue":null,"nameAndAddress":"Santander Consumer Bank GmbH\nWagramer Strasse 19\nWien\nAUSTRIA","option":null,"partyId":null,"clearingSystem":null,"lei":null,"mmbid":null,"residenceDetails":null,"creditorAgent":null,"currency":null,"addressList":null,"nameAndAddressList":null,"clearingSystemCode":null,"clearingSystemMemberId":null,"bankName":null,"bankAddress":null,"bankPostalCode":null,"bankTown":null,"bankCountry":null,"benefInfo":null,"account_curr":null,"sepaScheme":null},"ordBeneficiaryInfo":null,"paymentDetails":{"executionDate":1693814950000,"collectionDate":1693814950000,"executionDateInString":"20230904","collectionDateInString":"20230904","currency":"EUR","pAmount2":"","reference":"","paymentInfo":null,"priority":"","method":null,"requestID":null,"account_number":null,"charge":null,"currency_symbol":null,"chargesBorneBy":"","chargesAccount":"","endToEndId":null,"transactionId":null,"receiverBic":null,"senderBic":"SANTATWWXXX","operationCode":null,"relatedReference":null,"custSpecifiedRef":null,"orgMsgInfo":null,"orgMsgType":null,"remitanceInfo":[null,null,null],"clearingSystem":null,"lei":null,"instructionId":null,"formatOfInstruction":null,"originalUETR":null,"instructedAgtBic":"RZBAATWWXXX","returnFor":null,"messageID":null,"itemId":null,"purpose":null,"settlementMethod":"CLRG","settlementAccount":null,"transactionIdentification":null,"instructingAgent":null,"instructedAgent":null,"thirdAgent":null,"block4tags":null,"initiatingParty":null,"dateFormat":null,"amtModificationAlloewd":null,"paymentGuarenteeNedeed":null},"payDetails95":null,"originalAccountInfo":null,"originalBeneficiaryInfo":null,"originalPaymentDetails":null,"additionalDetails":{"aRegulatoryReporting":null,"aInstructedAmount1":null,"aInstructedAmount2":null,"aFXRate":null,"aFXReference":null,"aCode11":null,"aCode12":null,"aCode21":null,"aCode22":null,"aInstructingParty":null,"aForwardingBank":null,"aPymtPurpose":null,"aStuctUnstruct":"_","aIssuer":null,"aUdebtor":null,"aUcreditor":null,"aUdebtorId":null,"aUcreditorId":null,"aUcreditorInfo":null,"aUdebtorInfo":null,"formatOfInstruction":null,"code":null,"issuer":null,"reference":null,"sToRInformation":null,"chargeBearer":null,"aditionalPurpose":null,"additionalInfoFlag":null,"mdbpay_ordering_cust_name":"","mdbpay_custaccno":"",'));
    DBMS_LOB.APPEND(m_pac3_blob, clob_to_blob('"detailsOfCharges":"","mdbpay_ord_inst_name_addr1":"","mdbpay_ord_inst_addr2":"","mdbpay_ord_inst_addr3":"","mdbpay_ord_inst_addr4":"","mdbpay_ordering_cust_bic":"","mdbpay_sending_inst_bic":"","mdbpay_thrd_reimb_inst_bic":"","mdbpay_rcvr_corr_bic":"","mdbpay_acc_with_inst_bic":"","mdbpay_sender_corr_bic":"","mdbpay_interm_inst_bic":"","msgdb_id":0,"MDBPAY_CUSTACCNO_ENC":"","MDBPAY_BENEFNAME_ENC":"","MDBPAY_ORDERING_CUST_NAME_ENC":"","mdbpay_charge_code":"","payment_info":null,"fxInstructedAmt":0.0,"fxInstructedCurr":null,"fxRate":null,"fxReference":null,"orderparty_currency":null,"mdbpay_benef_bic":null,"mdbpay_benefname":null,"mdbpay_benef_details":null,"remittance_info":null,"regulatory_reporting":null,"mdbpay_CUSTACCNO_ENC":"","mdbpay_BENEFNAME_ENC":"","mdbpay_ORDERING_CUST_NAME_ENC":""},"originalAdditionalDetails":null,"fxDetails":null,"paymentInfo":null,"ultimateDebtor":{"name":null,"idType":null,"idValue":null,"scheme":null,"id":null,"address":null,"iban":null,"account_curr":null,"bic":null,"bank_code":null,"currency":null,"city":null,"postalCode":null,"country":null,"clearingSystem":null,"clearingSystemCode":null,"clearingSystemMemberId":null,"residenceDetails":null,"lei":null,"instructions":null},"ultimateCreditor":{"name":null,"idType":null,"idValue":null,"scheme":null,"id":null,"address":null,"iban":null,"account_curr":null,"bic":null,"bank_code":null,"currency":null,"city":null,"postalCode":null,"country":null,"clearingSystem":null,"clearingSystemCode":null,"clearingSystemMemberId":null,"residenceDetails":null,"lei":null,"instructions":null},"originalUltimateDebtor":null,"originalUltimateCreditor":null,"returnDetails":null,"recallDetails":null,"rejectionDetails":null,"orderingInstitution":null,"originalOrderingInstitution":null,"accountWithInstitution":null,"originalAccountWithInstitution":null,"senderCorrespondant":null,"recieverCorrespondant":null,"reimbursementParty":null,"senderInstitution":null,"intermediaryParty":null,"originalIntermediaryParty":null,"instructionDetails":null,"instructionDetailsInfo":null,"instructingParty":null,"partyDetails":null,"settlementInfo":null,"senderCharges":null,"recieverCharges":null,"originalMandateInfo":{"mandateId":null,"creditorSchemeName":null,"creditorSchemeId":null,"debtorIban":null,"debtorBankBic":null}'));
    DBMS_LOB.APPEND(m_pac3_blob, clob_to_blob(',"mandateRelatedInfo":{"amendmentIndicator":false,"mandateId":null,"dateOfSign":1693814950000,"dateOfSignInString":"20230904","creditorSchemeId":null,"electronicSign":null},"institutionId":"SANTATWW","department":"AT","manualDebitingAccount":false,"manualAccountSchemeType":null,"saveManualAccount":false,"messagesAction":null,"messageFamily":"SEPA","recordGroupType":"T","templateName":"pacs.003.001.08_SANTATWW_AT","messageClassType":"pacs.003.001.02","public1":"Y","userId":"DPH96DT2","transactionGroup":"DD","targetMsgType":null,"translatedNativeMsg":null,"status":null,"msgdbId":399563,"orgPrevInstAgtDetails":null,"orgIntermediaryAgtDetails":null,"pageInstanceId":null,"desktop":false,"bpspsd2":false,"direction":"I","transactionType":null,"envelopeContents":null,"recallFlow":false,"custom2":null,"action":null,"srcMessageDBId":0,"destMessageDbId":0,"parentMessage":null,"parentMessageFlag":null,"srcMessageDirection":null,"queryRelatedInfo":null,"additionDetailsChargesInfo":null,"additionDetailsChargesInfo1":null,"additionDetailsChargesInfo2":null,"previousInstructingAgentDetails":null,"intermediaryAgentDetails":null,"initiatingPartyDetails":null,"orginitiatingPartyDetails":null,"debtorAgent":null,"creditorAgent":null,"orgCreditorAgent":null,"translationError":null,"nextInstructingAgentDetails":null,"senderBic":"SANTATWWXXX","warningCodes":null,"status1":0,"queueId":null}'));

    m_pac8_blob := clob_to_blob('{"accountInfo":{"account_number":"","account_curr":null,"institutionname":null,"bank_code":"SANTATWWXXX","account_desc":"","accountMode":null,"customerId":null,"actualAccNum":null,"currency_symbol":null,"bank_logo":null,"bankLabel":null,"scheme":null,"ordering_address":null,"priority":null,"swift_priority":null,"balance":null,"virtualBalance":null,"idType":"other","idValue":"","nameAndAddress":"Santander Consumer Bank GmbH\nWagramer Strasse 19\nWien\nAUSTRIA","option":null,"partyId":null,"residenceDetails":null,"senderToReceiverInfo":null,"addressList":null,"nameAndAddressList":null,"country":null,"postalCode":null,"city":null,"buildingNo":null,"streetName":null,"clearingSystem":null,"clearingSystemCode":null,"clearingSystemMemberId":null,"bankName":null,"bankAddress":null,"bankPostalCode":null,"bankTown":null,"bankCountry":null,"lei":null,"mmbid":null,"orderingInfo":null,"id":null,"accounttype":null,"datakeyid":null,"account_NUMBER_ENC":null,"account_IBAN_ENC":null,"account_TITLE_ENC":null},"ordAccountInfo":null,"beneficiaryInfo":{"ncp_name":"","ncp_address_1":null,"ncp_address_2":null,"ncp_address_3":null,"ncp_code":"","ncp_bic":"SANTATWWXXX","institution":null,"scheme":null,"beneficiary_address":null,"address":"","buildingNo":null,"city":null,"country":null,');
    DBMS_LOB.APPEND(m_pac8_blob, clob_to_blob('"postalCode":null,"streetDetails":null,"ncp_logo":null,"idType":"other","idValue":"","nameAndAddress":"Santander Consumer Bank GmbH\nWagramer Strasse 19\nWien\nAUSTRIA","option":null,"partyId":null,"clearingSystem":null,"lei":null,"mmbid":null,"residenceDetails":null,"creditorAgent":null,"currency":null,"addressList":null,"nameAndAddressList":null,"clearingSystemCode":null,"clearingSystemMemberId":null,"bankName":null,"bankAddress":null,"bankPostalCode":null,"bankTown":null,"bankCountry":null,"benefInfo":null,"account_curr":null,"sepaScheme":null},"ordBeneficiaryInfo":null,"paymentDetails":{"executionDate":1693813317000,"collectionDate":null,"executionDateInString":"20230904","currency":"EUR","pAmount2":"","reference":null,"paymentInfo":null,"priority":null,"method":null,"requestID":null,"account_number":null,"charge":null,"currency_symbol":null,"chargesBorneBy":null,"chargesAccount":null,"endToEndId":"2023090413174435","transactionId":"2023090413174435","receiverBic":null,"senderBic":"SANTATWWXXX","operationCode":null,"relatedReference":null,"custSpecifiedRef":null,"orgMsgInfo":null,"orgMsgType":null,"remitanceInfo":[null,null,null],"clearingSystem":null,"lei":null,"instructionId":null,"formatOfInstruction":null,"originalUETR":null,"instructedAgtBic":"RZBAATWWXXX","returnFor":null,"messageID":null,"itemId":null,"purpose":null,"settlementMethod":"CLRG","settlementAccount":null,"transactionIdentification":null,"instructingAgent":null,"instructedAgent":null,"thirdAgent":null,"block4tags":null,"initiatingParty":null,"dateFormat":null,"amtModificationAlloewd":null,"paymentGuarenteeNedeed":null},"payDetails95":null,"originalAccountInfo":null,"originalBeneficiaryInfo":null,"originalPaymentDetails":null,"additionalDetails":{"aRegulatoryReporting":null,"aInstructedAmount1":null,"aInstructedAmount2":null,"aFXRate":null,"aFXReference":null,"aCode11":null,"aCode12":null,"aCode21":null,"aCode22":null,"aInstructingParty":null,"aForwardingBank":null,"aPymtPurpose":null,"aStuctUnstruct":"_","aIssuer":null,"aUdebtor":null,"aUcreditor":null,"aUdebtorId":null,"aUcreditorId":null,"aUcreditorInfo":null,"aUdebtorInfo":null,"formatOfInstruction":"U","code":"SCOR","issuer":"","reference":"","sToRInformation":null,"chargeBearer":null,"aditionalPurpose":null,"additionalInfoFlag":null,"mdbpay_ordering_cust_name":"","mdbpay_custaccno":"",'));
    DBMS_LOB.APPEND(m_pac8_blob, clob_to_blob('"detailsOfCharges":"","mdbpay_ord_inst_name_addr1":"","mdbpay_ord_inst_addr2":"","mdbpay_ord_inst_addr3":"","mdbpay_ord_inst_addr4":"","mdbpay_ordering_cust_bic":"","mdbpay_sending_inst_bic":"","mdbpay_thrd_reimb_inst_bic":"","mdbpay_rcvr_corr_bic":"","mdbpay_acc_with_inst_bic":"","mdbpay_sender_corr_bic":"","mdbpay_interm_inst_bic":"","msgdb_id":0,"MDBPAY_CUSTACCNO_ENC":"","MDBPAY_BENEFNAME_ENC":"","MDBPAY_ORDERING_CUST_NAME_ENC":"","mdbpay_charge_code":"","payment_info":null,"fxInstructedAmt":0.0,"fxInstructedCurr":null,"fxRate":null,"fxReference":null,"orderparty_currency":null,"mdbpay_benef_bic":null,"mdbpay_benefname":null,"mdbpay_benef_details":null,"remittance_info":null,"regulatory_reporting":null,"mdbpay_CUSTACCNO_ENC":"","mdbpay_BENEFNAME_ENC":"","mdbpay_ORDERING_CUST_NAME_ENC":""},"originalAdditionalDetails":null,"fxDetails":null,"paymentInfo":{"purpose":"","servicelevel":null,"localInstrument":"","sequenceType":null,"purpose1":null,"localInstrument1":null,"serviceLevels":null},"ultimateDebtor":null,"ultimateCreditor":null,"originalUltimateDebtor":null,"originalUltimateCreditor":null,"returnDetails":null,"recallDetails":null,"rejectionDetails":null,"orderingInstitution":null,"originalOrderingInstitution":null,"accountWithInstitution":null,"originalAccountWithInstitution":null,"senderCorrespondant":null,"recieverCorrespondant":null,"reimbursementParty":null,"senderInstitution":null,"intermediaryParty":null,"originalIntermediaryParty":null,"instructionDetails":null,"instructionDetailsInfo":null,"instructingParty":null,"partyDetails":null,"settlementInfo":null,"senderCharges":null,"recieverCharges":null,"originalMandateInfo":null,"mandateRelatedInfo":null,"institutionId":"SANTATWW","department":"AT","manualDebitingAccount":false,"manualAccountSchemeType":null,"saveManualAccount":false,"messagesAction":null,"messageFamily":"SEPA","recordGroupType":"T","templateName":"pacs.008.001.08_SANTATWW_AT","messageClassType":"pacs.008.001.02","public1":"Y","userId":"DPH96DT2","transactionGroup":"CT","targetMsgType":null,"translatedNativeMsg":null,"status":null,"msgdbId":399554,"orgPrevInstAgtDetails":null,"orgIntermediaryAgtDetails":null,"pageInstanceId":null,"desktop":false,"bpspsd2":false,"direction":"I","transactionType":null,'));
    DBMS_LOB.APPEND(m_pac8_blob, clob_to_blob('"envelopeContents":null,"recallFlow":false,"custom2":null,"action":null,"srcMessageDBId":0,"destMessageDbId":0,"parentMessage":null,"parentMessageFlag":null,"srcMessageDirection":null,"queryRelatedInfo":null,"additionDetailsChargesInfo":null,"additionDetailsChargesInfo1":null,"additionDetailsChargesInfo2":null,"previousInstructingAgentDetails":null,"intermediaryAgentDetails":null,"initiatingPartyDetails":null,"orginitiatingPartyDetails":null,"debtorAgent":null,"creditorAgent":null,"orgCreditorAgent":null,"translationError":null,"nextInstructingAgentDetails":null,"senderBic":"SANTATWWXXX","warningCodes":null,"status1":0,"queueId":null}'));
    
        
    OPEN c_messageclasstype;
    FETCH c_messageclasstype BULK COLLECT INTO s_messageclasstype;
    CLOSE c_messageclasstype;
                    
    m_messageclasstype_beg := NVL(s_messageclasstype.FIRST,0);
    m_messageclasstype_end := NVL(s_messageclasstype.LAST,0);

    FOR i IN m_messageclasstype_beg..m_messageclasstype_end
    LOOP                

        OPEN c_institutionid;
        FETCH c_institutionid BULK COLLECT INTO s_institutionid;
        CLOSE c_institutionid;

        m_institutionid_beg := NVL(s_institutionid.FIRST,0);
        m_institutionid_end := NVL(s_institutionid.LAST,0);
                                        
                            
        FOR j IN m_institutionid_beg..m_institutionid_end
        LOOP   
        BEGIN                              
            OPEN c_location;
            FETCH c_location BULK COLLECT INTO s_location;
            CLOSE c_location;                                   
                                                        
            m_location_beg := NVL(s_location.FIRST,0);
            m_location_end := NVL(s_location.LAST,0);                
                                          
            FOR k IN m_location_beg..m_location_end
            LOOP
            BEGIN
                                
                m_msgdb_id := MSGDB_SEQ.NEXTVAL;
                
                m_messageno := 'M'||LPAD(MSGDB_MESSAGENO.NEXTVAL,11,0);
                
                m_CUSTOM7:=s_messageclasstype(i).messageclasstype||'_'||s_institutionid(j).institutionid||'_'||s_location(k).msgsegr;
                

                IF s_messageclasstype(i).messageclasstype='pacs.003.001.08'
                THEN

                    IF s_institutionid(j).institutionid IN ('SANTATWW','SANTAT00','ACEABANK') AND s_location(k).msgsegr in ('0000001')
                    THEN 
                        NULL;
                    ELSE
                     Insert into MSGDB
                           (MSGDB_ID, QUEUEID, MESSAGENO, FILENAME, MESSAGECLASSTYPE, 
                            STATUS, MSGSTATEMEANING, INPUTDATE, INPUTTIME, CURRQUEUEINDATE, 
                            CURRQUEUEINTIME, PREVQUEUEID, PREVQUEUEINDATE, PREVQUEUEINTIME, PRIORITY, 
                            SENDER, RECEIVER, NUMOFMESSAGES, MESSAGERESERVEDATE, MESSAGERESERVETIME, 
                            PRIORITYDATE, PRIORITYAMOUNT, PRIORITYAMOUNTNUM, CURRENCY, STACHEMMESSAGEFLAG, 
                            SUMOFALLTESTKEYAMOUNTS, LOCALCURRENCYAMOUNT, LOCALCURRENCYAMOUNTNUM, TESTKEYRESULT, LOCKSTATUS, 
                            LOCKEDBY, REPAIREDBY, RELEASEDBY, AUTHORIZEDBY, FORWARDEDBY, 
                            OPERATOR, BLOCK4CRLFPRESENT, PRINTFLAG, MSGATTRIBUTE, MSG_MODE_IN, 
                            CUSTOMER, FUNCTION, SUBFUNCTION, MSDA, INSTITUTIONID, 
                            CUSTOMMSGID, DEALTYPES, MSGCLASS, MSG_MODE_OUT, MESSAGEDIRECTION, 
                            CORRESPONDENT, COUNTRYCODE, CATEGORY, PAYMENTSYSTEM, TRANSREFNO, 
                            COMMENTS, SEQUENCENO, TERMID, RETURNCODE, BATCH, 
                            MSGSEGR, MSGGROUP, CUSTOM1, CUSTOM2, CUSTOM3, 
                            CUSTOM4, CUSTOM5, CUSTOM6, CUSTOM7, CUSTOM8, 
                            CUSTOM9, CUSTOM10, CUSTOM11, CUSTOM12, CUSTOM13, 
                            CUSTOM14, CUSTOM15, CUSTOM16, CUSTOM17, CUSTOM18, 
                            CUSTOM19, CUSTOM20, CUSTOM21, CUSTOM22, CUSTOM23, 
                            CUSTOM24, CUSTOM25, MSGSOURCE, MSGTARGET, CUSTOM26, 
                            CUSTOM27, CUSTOM28, CUSTOM29, CUSTOM30, CUSTOM31, 
                            CUSTOM32, CUSTOM33, CUSTOM34, CUSTOM35, CUSTOM36, 
                            CUSTOM37, CUSTOM38, CUSTOM39, CUSTOM40, CUSTOM41, 
                            CUSTOM42, CUSTOM43, CUSTOM44, CUSTOM45, CUSTOM46, 
                            CUSTOM47, CUSTOM48, CUSTOM49, CUSTOM50, BENBANKNAME, 
                            BENBANKADDR1, BENBANKADDR2, BENBANKADDR3, BENBANKADDR4, BENBANKCITY, 
                            BENBANKSTATECODE, BENBANKZIPCODE, BENBANKCTRY, BENEFNAME, ORIGBANKNAME, 
                            ORIGNAME, TASKID, ACE_APPLN_DOMAIN, MSG_FAMILY, SERVICE_NAME, 
                            REQUEST_TYPE, REQUESTER_DN, RESPONDER_DN, ACTION_TIMESTAMP, SWIFTNET_TOKEN, 
                            MAX_ATTEMPTS, ATTEMPTS_MADE, LAST_ATTEMPT_TS, ERROR_CODE, ERROR_DESC, 
                            NR_FLAG, SIGN_DN, ENCRYPT_DN, AUTHORISER_DN, SNF_FLAG, 
                            SNF_REF, ACKNOWLEDGEMENT, RECORD_TYPE, SWIFTNETATTRIBUTES, CRYPTO_MEMBER_REF, 
                            CUSTOMERACCNO, TRANSACTIONTYPE, EXCEPTIONTYPE, PREVSTATUS, SOURCECHANNELID, 
                            TARGETCHANNELID, MSGDB_ID_ORG, OUTPUT_COUNT, MSGDB_ID_SOURCE, MSGDB_ID_TARGET, 
                            ACCOUNT_DR, ACCOUNT_CR, MSGDB_ID_BATCH, RECORD_GROUP_TYPE, RECORD_END_MARKER, 
                            CHANNEL_ID_SOURCE, CHANNEL_ID_TARGET, CONTROLFLAG, MSGFAMIN, MSGFAMOUT, 
                            MUIF1, MUIF2, REASON_CODE, USER_RESPONSE_FLAG, DUPLICATE_RECORD_KEY, 
                            CHANNEL_RELEASE_MODE, CHANNEL_RELEASE_DATE, BUSINESS_RECEIPT_DATE, MSGDB_ID_OUTPUT_BATCH, HASHCODE1, 
                            HASHCODE2, INSTANCEID, PREVINSTANCEID, RESEND_QUEUEID, RESUBMIT_QUEUEID, 
                            ORG_MSG_REF_DATE, STREAMID, APPLICATIONID, MSGDB_ID_COPY, ENCODED_DIGEST, 
                            ENCODED_ALGORITHM, POSSIBLE_DUPLICATE, RESEND_FLAG, RESUBMIT_FLAG, ACK_STATUS, 
                            RESUBMIT_STATUS, DEBTORAGENTBIC, CREDITORAGENTBIC, OUT_ENVELOPE, OUT_AUTHCODE, 
                            OUT_ALGO, IN_ENVELOPE, IN_AUTHCODE, IN_ALGO, ACK_REQUIRED, 
                            ROUTECHANNELID, COPYCHANNELID, RESEND_COUNT, OTHERREF, GROUPINGINFO, 
                            ACCOUNTBOOKINGINFO, UNLOAD_QUEUEID, LAST_UNLOAD_ATTEMPT, UNLOAD_ATTEMPT, ARCH_STATUS, 
                            ARCH_DATE, MESSAGENO_SOURCE, MESSAGENO_TARGET, ENI_STATUS, ENI_ISCASEOPEN, 
                            MSG_INPUT_MODE, RELATED_REFERENCE, STMT_ENTRYDATE, STMT_FUNDCODE, STMT_REFINFO_FOR_ACCOWNER, 
                            STMT_REFINFO_OF_ACCSERVICINST, STMT_SUPPLEMENTARY_DETAILS, STMT_ADD_REFINFO_FOR_ACCOWNER, DERIVED_BRANCH, DERIVED_PAYMENT_SYSTEM, 
                            DERIVED_PRODUCT, DERIVED_APPLICATION, OTHER_ACCNO, OTHER_PARTY_DETAILS, USR_ACTION_STATUS, 
                            USR_ACTION_QUEUEID, LOCK_CHILD_RECORDS, USR_ACTION_DATETIME, PROCESSING_STATUS, FINAL_SCAN_STATUS, 
                            STP_STATUS, MSGCOUNT, REPAIR_AMOUNT, SERVICE_AMOUNT, DISCOUNT_AMOUNT, 
                            COMM_RECEIVED, COMM_PAID, CREATEDBY, CALCULATEDAMOUNT, SCORE, 
                            EXCHANGE_RATE, SWIFT_PRIORITY, INSTRUCTED_AMOUNT, INSTRUCTED_CURRENCY, SENDER_RECEIVER_INFO, 
                            BENBANKCODE, DEST_COUNTRYCODE, KBTIMESTAMP, INPUTDATETIME, USR_ACTION_TIMESTAMP, 
                            CURRQUEUEINDATETIME, TWOPHASECOMMIT_ID, MSGDB_XA_PARENT_ID, MSGDB_XA_CHILD_ID, MSGDB_XA_HASH_CODE, 
                            PAYMENT_CHANNEL, REPORT_TYPE, PROCESS_ID, PAGE_NUMBER, TOTAL_PAGES, 
                            ACCOUNT_NUMBER, MANDATE_DATA, TRANSACTIONGROUP, RECORD_HASH, HASH_ALGORITHM, 
                            TRANSSUBTYPE, PROCESSING_STAGE, ORIG_RECORD, REPAIR_STATS, MANDATE_ID, 
                            UPLD_BY, UPLD_STATUS, DWNLD_BY, DWNLD_STATUS, ADDITIONAL_INFO, 
                            BALANCE_UPDATED, BALANCE_UPDATED_DATE, OLAP_OPERATOR, NEXT_WORKFLOW_QUEUE_ID, NEXT_WORKFLOW_STATUS, 
                            MQ_ACKN_FEEDBACK_CODE, REPLY_TO_MQ_QUEUE_MANAGER, REPLY_TO_MQ_QUEUE, APPLICATION_IDENTITY_DATA, STATISTICS_ID, 
                            SERVICE_TYPE_ID, UNIQUE_END_TRAN_REFERENCE, PAYMENT_DUEDATE, DISPLAY_FLAG, CURRENT_AUTH_LEVEL, 
                            SETTLEMENTMETHOD, STMT_BALN_CALC_FLAG, SL_DB_POPULATE, ACCOUNT_OPEN_BALANCE, ADDITIONAL_INFO_FLAG, 
                            AUTH_MODE, BALANCE_FLAG, BEN_ADDRESS1, COMPUTE_BALANCE_FLAG, DETAILSOFCHARGES, 
                            DOCUMENT_COUNT, EMAIL_COUNT, GROUPINGINFO_BATCH, GROUPINGINFO_FILE, IMAGES_COUNT, 
                            INV_PAY_REF_ID, LATEST_STMT_RECORD_FLAG, MATCH_STATMENT_FLAG, NATURE_OF_TRANSACTION, NOTES_COUNT, 
                            ORDERPARTY_CURRENCY, ORIGINATING_SYSTEM, OTHERS_ATTACHMENTS_COUNT_1, OTHERS_ATTACHMENTS_COUNT_2, OTHERS_ATTACHMENTS_COUNT_3, 
                            PAYMENT_RUN_ID, PREV_MSGDATE, STATUS_STRING, STMT_BALANCE_TYPE, STMT_CLOSING_BALANCE, 
                            STMT_CLOSING_BOOKED_BALANCE, STMT_OPEN_BALN, STMT_TXNS_SEQNO, TENANT_NAME, VIDEO_COUNT, 
                            GROUP_ID, DATAKEYID, CUSTOMER_ENC, CORRESPONDENT_ENC, BENEFNAME_ENC, 
                            ORIGNAME_ENC, CUSTOMERACCNO_ENC, ACCOUNT_DR_ENC, ACCOUNT_CR_ENC, OTHER_ACCNO_ENC, 
                            OTHER_PARTY_DETAILS_ENC, ACCOUNT_NUMBER_ENC, PELICAN_ACCOUNT_NO, ORG_MESSAGECLASSTYPE, ORDERING_INSTITUTION_ID, 
                            STMT_CLOSING_AVAILABLE_BALANCE, STMT_FWD_AVAILABLE_BALANCES, ISINPUT, ISOUTPUT, NOSTRO_ACCOUNT_NUMBER, 
                            COMPANY_CODE, CONTRACT_NUMBER, LAST_SANCTION_DT, GROUPINGINFO_EOD, AGGREGATE_FLAG, 
                            SAP_CR, SAP_DR, SUB_SAP_DR, SUB_SAP_CR, EXCHANGE_AMOUNT, 
                            INSTRUCTINGAGENT, INSTRUCTEDAGENT, NOSTRO_ACCOUNT_NUMBER_CPTY)
                     Values
                           (m_msgdb_id, 'TEMPLTQ', m_messageno, NULL, s_messageclasstype(i).messageclasstype, 
                            99, NULL, to_char(sysdate, 'YYYYMMDD'), to_char(sysdate, 'HHMISS'), to_char(sysdate, 'YYYYMMDD'), 
                            to_char(sysdate, 'HHMISS'), NULL, NULL, NULL, '9', 
                            'SANTATWWXXX', 'RZBAATWWXXX', 0, NULL, NULL, 
                            '20230904', NULL, 0, 'EUR', NULL, 
                            NULL, NULL, 0, NULL, 0, 
                            NULL, 'DPH96DT2', NULL, NULL, NULL, 
                            'SRVRUSER', NULL, 0, 0, 'MANUAL', 
                            NULL, 'NOTA', NULL, 'SEPA', s_institutionid(j).institutionid, 
                            NULL, NULL, 'EPC', NULL, 'I', 
                            NULL, NULL, 0, NULL, NULL, 
                            NULL, NULL, NULL, 0, 0, 
                            s_location(k).msgsegr, NULL, NULL, NULL, NULL, 
                            NULL, NULL, 'Y', m_CUSTOM7, NULL, 
                            NULL, NULL, NULL, NULL, NULL, 
                            NULL, NULL, NULL, NULL, NULL, 
                            NULL, 0, 0, 0, NULL, 
                            NULL, NULL, NULL, NULL, NULL, 
                            NULL, NULL, NULL, NULL, NULL, 
                            NULL, NULL, NULL, NULL, NULL, 
                            NULL, NULL, NULL, NULL, NULL, 
                            NULL, NULL, NULL, 0, 0, 
                            0, NULL, NULL, NULL, NULL, 
                            NULL, NULL, NULL, NULL, NULL, 
                            NULL, NULL, NULL, NULL, NULL, 
                            NULL, 0, NULL, 'SEPA', NULL, 
                            NULL, NULL, NULL, NULL, NULL, 
                            0, 0, NULL, NULL, NULL, 
                            NULL, NULL, NULL, NULL, NULL, 
                            NULL, NULL, 0, 0, NULL, 
                            NULL, NULL, NULL, 0, 'PELICAN', 
                            NULL, 0, 0, 0, 0, 
                            NULL, NULL, 0, 'T', NULL, 
                            'PELICAN', NULL, 0, NULL, NULL, 
                            NULL, NULL, NULL, NULL, NULL, 
                            NULL, NULL, TO_DATE('09/04/2023 13:46:01', 'MM/DD/YYYY HH24:MI:SS'), NULL, NULL, 
                            NULL, 'PELICAN1', 0, NULL, NULL, 
                            NULL, NULL, NULL, 0, NULL, 
                            NULL, NULL, NULL, NULL, 0, 
                            0, NULL, NULL, NULL, NULL, 
                            NULL, NULL, NULL, NULL, NULL, 
                            NULL, NULL, 0, NULL, NULL, 
                            NULL, NULL, NULL, 0, NULL, 
                            NULL, NULL, NULL, NULL, NULL, 
                            NULL, '20230904134549057', NULL, NULL, NULL, 
                            NULL, NULL, NULL, NULL, NULL, 
                            NULL, NULL, NULL, NULL, 0, 
                            NULL, NULL, NULL, NULL, NULL, 
                            NULL, 1, 0, 0, 0, 
                            0, 0, NULL, 0, 0, 
                            0, NULL, 0, NULL, NULL, 
                            NULL, NULL, NULL, TO_TIMESTAMP('9/4/2023 1:46:01.528000 PM','fmMMfm/fmDDfm/YYYY fmHH12fm:MI:SS.FF AM'), NULL, 
                            TO_TIMESTAMP('9/4/2023 1:46:01.528000 PM','fmMMfm/fmDDfm/YYYY fmHH12fm:MI:SS.FF AM'), NULL, NULL, 0, NULL, 
                            NULL, NULL, 'NONE', 0, 0, 
                            NULL, NULL, 'DD', NULL, NULL, 
                            NULL, 'REPR', NULL, NULL, NULL, 
                            NULL, 0, NULL, 0, NULL, 
                            NULL, NULL, NULL, NULL, NULL, 
                            NULL, NULL, NULL, NULL, NULL, 
                            NULL, NULL, NULL, NULL, NULL, 
                            NULL, NULL, NULL, NULL, NULL, 
                            NULL, NULL, NULL, NULL, NULL, 
                            NULL, NULL, NULL, NULL, NULL, 
                            NULL, NULL, NULL, NULL, NULL, 
                            NULL, NULL, NULL, NULL, NULL, 
                            NULL, NULL, NULL, NULL, NULL, 
                            NULL, NULL, NULL, NULL, NULL, 
                            NULL, NULL, NULL, NULL, NULL, 
                            NULL, NULL, NULL, NULL, NULL, 
                            NULL, NULL, NULL, NULL, NULL, 
                            NULL, NULL, 'N', 'N', NULL, 
                            NULL, NULL, NULL, NULL, NULL, 
                            NULL, NULL, NULL, NULL, NULL, 
                            NULL, NULL, NULL);
                                                          
                        INSERT_BLOB_RECORD(m_msgdb_id,1, clob_to_blob(m_pacs3_1_2_175_clob));
                        INSERT_BLOB_RECORD(m_msgdb_id,2, clob_to_blob(m_pacs3_1_2_175_clob));
                        INSERT_BLOB_RECORD(m_msgdb_id,175, clob_to_blob(m_pacs3_1_2_175_clob));
                        INSERT_BLOB_RECORD(m_msgdb_id,145, m_pac3_blob);
                        INSERT_BLOB_RECORD(m_msgdb_id,146, m_pac3_blob);         

                            
                                                                                                 
                                                                                  
                                                        
                        Insert into MSGDB_PAY
                               (MSGDB_ID, MDBPAY_PAYMENTSYSTEM, MDBPAY_ORDERING_CUST_BIC, MDBPAY_ORDERING_CUST_LCODE, MDBPAY_ORDERING_CUST_LC_TYPE, 
                                MDBPAY_SENDING_INST_BIC, MDBPAY_SENDING_INST_LCODE, MDBPAY_SENDING_INST_LC_TYPE, MDBPAY_ORDERING_INST_BIC, MDBPAY_ORDERING_INST_LCODE, 
                                MDBPAY_ORDERING_INST_LC_TYPE, MDBPAY_SENDER_CORR_BIC, MDBPAY_SENDER_CORR_LCODE, MDBPAY_SENDER_CORR_LC_TYPE, MDBPAY_RCVR_CORR_BIC, 
                                MDBPAY_RCVR_CORR_LCODE, MDBPAY_RCVR_CORR_LC_TYPE, MDBPAY_THRD_REIMB_INST_BIC, MDBPAY_THRD_REIMB_INST_LCODE, MDBPAY_THRD_REIMB_INST_LC_TYPE, 
                                MDBPAY_INTERM_INST_BIC, MDBPAY_INTERM_INST_LCODE, MDBPAY_INTERM_INST_LC_TYPE, MDBPAY_ACC_WITH_INST_BIC, MDBPAY_ACC_WITH_INST_LCODE, 
                                MDBPAY_ACC_WITH_INST_LC_TYPE, MDBPAY_BENEF_BIC, MDBPAY_CUSTACCNO, MDBPAY_RELATED_REF, MDBPAY_EXCH_RATE, 
                                MDBPAY_ORI_VAL_DT, MDBPAY_ORI_VAL_AMT, MDBPAY_CHARGE_1, MDBPAY_CHARGE_1_CURR, MDBPAY_CHARGE_2, 
                                MDBPAY_CHARGE_2_CURR, MDBPAY_CHARGE_CODE, MDBPAY_BRANCH, MDBPAY_BENEFNAME, MDBPAY_ORDERING_CUST_NAME, 
                                MDBPAY_BENF_TYPE, ARCH_STATUS, ARCH_DATE, REMITTANCE_INFO, MDBPAY_ORD_INST_NAME_ADDR1, 
                                MDBPAY_ORD_INST_ADDR2, MDBPAY_ORD_INST_ADDR3, MDBPAY_ORD_INST_ADDR4, CHARGE_CODE_NEW, MDBPAY_BENEF_DETAILS, 
                                MDBPAY_ORD_INST_ADDR1, REGULATORY_RPT, REMITTANCE_STR_CODE, REMITTANCE_STR_ISSUER, REMITTANCE_STR_REF, 
                                REMITTANCE_UNSTR_INFO, MDBPAY_CUSTACCNO_ENC, MDBPAY_BENEFNAME_ENC, MDBPAY_ORDERING_CUST_NAME_ENC, END2END_ID, 
                                BI_TRANS_CODE, SOURCE_SYS, UETR)
                        Values
                               (m_msgdb_id, NULL, NULL, NULL, NULL, 
                                NULL, NULL, NULL, NULL, NULL, 
                                NULL, NULL, NULL, NULL, NULL, 
                                NULL, NULL, NULL, NULL, NULL, 
                                NULL, NULL, NULL, NULL, NULL, 
                                NULL, 'SANTATWWXXX', NULL, NULL, NULL, 
                                NULL, NULL, NULL, NULL, NULL, 
                                NULL, NULL, NULL, NULL, NULL, 
                                NULL, NULL, NULL, NULL, NULL, 
                                NULL, NULL, NULL, NULL, 'Santander Consumer Bank GmbH
                        Wagramer Strasse 19
                        Wien
                        AUSTRIA', 
                                'N', NULL, NULL, NULL, NULL, 
                                NULL, NULL, NULL, NULL, NULL, 
                                NULL, NULL, NULL);
                                                            
                                                                                 
                        Insert into MSGDB_OUTPUT
                               (MSGDB_ID, MDBOUT_MODE, MDBOUT_STATUS, MDBOUT_DATE_TIME, ARCH_STATUS, 
                                ARCH_DATE, INSTANCEID)
                        Values
                               (m_msgdb_id, 'RECEIVE', 'N', NULL, NULL, 
                                NULL, NULL);
                                                                                  
                    END IF;
                ELSE
                                                    
                    IF s_institutionid(j).institutionid IN ('SANTATWW','SANTAT00','ACEABANK') AND s_location(k).msgsegr in ('0000001')
                    THEN 
                        NULL;
                    ELSE
                     Insert into MSGDB
                           (MSGDB_ID, QUEUEID, MESSAGENO, FILENAME, MESSAGECLASSTYPE, 
                            STATUS, MSGSTATEMEANING, INPUTDATE, INPUTTIME, CURRQUEUEINDATE, 
                            CURRQUEUEINTIME, PREVQUEUEID, PREVQUEUEINDATE, PREVQUEUEINTIME, PRIORITY, 
                            SENDER, RECEIVER, NUMOFMESSAGES, MESSAGERESERVEDATE, MESSAGERESERVETIME, 
                            PRIORITYDATE, PRIORITYAMOUNT, PRIORITYAMOUNTNUM, CURRENCY, STACHEMMESSAGEFLAG, 
                            SUMOFALLTESTKEYAMOUNTS, LOCALCURRENCYAMOUNT, LOCALCURRENCYAMOUNTNUM, TESTKEYRESULT, LOCKSTATUS, 
                            LOCKEDBY, REPAIREDBY, RELEASEDBY, AUTHORIZEDBY, FORWARDEDBY, 
                            OPERATOR, BLOCK4CRLFPRESENT, PRINTFLAG, MSGATTRIBUTE, MSG_MODE_IN, 
                            CUSTOMER, FUNCTION, SUBFUNCTION, MSDA, INSTITUTIONID, 
                            CUSTOMMSGID, DEALTYPES, MSGCLASS, MSG_MODE_OUT, MESSAGEDIRECTION, 
                            CORRESPONDENT, COUNTRYCODE, CATEGORY, PAYMENTSYSTEM, TRANSREFNO, 
                            COMMENTS, SEQUENCENO, TERMID, RETURNCODE, BATCH, 
                            MSGSEGR, MSGGROUP, CUSTOM1, CUSTOM2, CUSTOM3, 
                            CUSTOM4, CUSTOM5, CUSTOM6, CUSTOM7, CUSTOM8, 
                            CUSTOM9, CUSTOM10, CUSTOM11, CUSTOM12, CUSTOM13, 
                            CUSTOM14, CUSTOM15, CUSTOM16, CUSTOM17, CUSTOM18, 
                            CUSTOM19, CUSTOM20, CUSTOM21, CUSTOM22, CUSTOM23, 
                            CUSTOM24, CUSTOM25, MSGSOURCE, MSGTARGET, CUSTOM26, 
                            CUSTOM27, CUSTOM28, CUSTOM29, CUSTOM30, CUSTOM31, 
                            CUSTOM32, CUSTOM33, CUSTOM34, CUSTOM35, CUSTOM36, 
                            CUSTOM37, CUSTOM38, CUSTOM39, CUSTOM40, CUSTOM41, 
                            CUSTOM42, CUSTOM43, CUSTOM44, CUSTOM45, CUSTOM46, 
                            CUSTOM47, CUSTOM48, CUSTOM49, CUSTOM50, BENBANKNAME, 
                            BENBANKADDR1, BENBANKADDR2, BENBANKADDR3, BENBANKADDR4, BENBANKCITY, 
                            BENBANKSTATECODE, BENBANKZIPCODE, BENBANKCTRY, BENEFNAME, ORIGBANKNAME, 
                            ORIGNAME, TASKID, ACE_APPLN_DOMAIN, MSG_FAMILY, SERVICE_NAME, 
                            REQUEST_TYPE, REQUESTER_DN, RESPONDER_DN, ACTION_TIMESTAMP, SWIFTNET_TOKEN, 
                            MAX_ATTEMPTS, ATTEMPTS_MADE, LAST_ATTEMPT_TS, ERROR_CODE, ERROR_DESC, 
                            NR_FLAG, SIGN_DN, ENCRYPT_DN, AUTHORISER_DN, SNF_FLAG, 
                            SNF_REF, ACKNOWLEDGEMENT, RECORD_TYPE, SWIFTNETATTRIBUTES, CRYPTO_MEMBER_REF, 
                            CUSTOMERACCNO, TRANSACTIONTYPE, EXCEPTIONTYPE, PREVSTATUS, SOURCECHANNELID, 
                            TARGETCHANNELID, MSGDB_ID_ORG, OUTPUT_COUNT, MSGDB_ID_SOURCE, MSGDB_ID_TARGET, 
                            ACCOUNT_DR, ACCOUNT_CR, MSGDB_ID_BATCH, RECORD_GROUP_TYPE, RECORD_END_MARKER, 
                            CHANNEL_ID_SOURCE, CHANNEL_ID_TARGET, CONTROLFLAG, MSGFAMIN, MSGFAMOUT, 
                            MUIF1, MUIF2, REASON_CODE, USER_RESPONSE_FLAG, DUPLICATE_RECORD_KEY, 
                            CHANNEL_RELEASE_MODE, CHANNEL_RELEASE_DATE, BUSINESS_RECEIPT_DATE, MSGDB_ID_OUTPUT_BATCH, HASHCODE1, 
                            HASHCODE2, INSTANCEID, PREVINSTANCEID, RESEND_QUEUEID, RESUBMIT_QUEUEID, 
                            ORG_MSG_REF_DATE, STREAMID, APPLICATIONID, MSGDB_ID_COPY, ENCODED_DIGEST, 
                            ENCODED_ALGORITHM, POSSIBLE_DUPLICATE, RESEND_FLAG, RESUBMIT_FLAG, ACK_STATUS, 
                            RESUBMIT_STATUS, DEBTORAGENTBIC, CREDITORAGENTBIC, OUT_ENVELOPE, OUT_AUTHCODE, 
                            OUT_ALGO, IN_ENVELOPE, IN_AUTHCODE, IN_ALGO, ACK_REQUIRED, 
                            ROUTECHANNELID, COPYCHANNELID, RESEND_COUNT, OTHERREF, GROUPINGINFO, 
                            ACCOUNTBOOKINGINFO, UNLOAD_QUEUEID, LAST_UNLOAD_ATTEMPT, UNLOAD_ATTEMPT, ARCH_STATUS, 
                            ARCH_DATE, MESSAGENO_SOURCE, MESSAGENO_TARGET, ENI_STATUS, ENI_ISCASEOPEN, 
                            MSG_INPUT_MODE, RELATED_REFERENCE, STMT_ENTRYDATE, STMT_FUNDCODE, STMT_REFINFO_FOR_ACCOWNER, 
                            STMT_REFINFO_OF_ACCSERVICINST, STMT_SUPPLEMENTARY_DETAILS, STMT_ADD_REFINFO_FOR_ACCOWNER, DERIVED_BRANCH, DERIVED_PAYMENT_SYSTEM, 
                            DERIVED_PRODUCT, DERIVED_APPLICATION, OTHER_ACCNO, OTHER_PARTY_DETAILS, USR_ACTION_STATUS, 
                            USR_ACTION_QUEUEID, LOCK_CHILD_RECORDS, USR_ACTION_DATETIME, PROCESSING_STATUS, FINAL_SCAN_STATUS, 
                            STP_STATUS, MSGCOUNT, REPAIR_AMOUNT, SERVICE_AMOUNT, DISCOUNT_AMOUNT, 
                            COMM_RECEIVED, COMM_PAID, CREATEDBY, CALCULATEDAMOUNT, SCORE, 
                            EXCHANGE_RATE, SWIFT_PRIORITY, INSTRUCTED_AMOUNT, INSTRUCTED_CURRENCY, SENDER_RECEIVER_INFO, 
                            BENBANKCODE, DEST_COUNTRYCODE, KBTIMESTAMP, INPUTDATETIME, USR_ACTION_TIMESTAMP, 
                            CURRQUEUEINDATETIME, TWOPHASECOMMIT_ID, MSGDB_XA_PARENT_ID, MSGDB_XA_CHILD_ID, MSGDB_XA_HASH_CODE, 
                            PAYMENT_CHANNEL, REPORT_TYPE, PROCESS_ID, PAGE_NUMBER, TOTAL_PAGES, 
                            ACCOUNT_NUMBER, MANDATE_DATA, TRANSACTIONGROUP, RECORD_HASH, HASH_ALGORITHM, 
                            TRANSSUBTYPE, PROCESSING_STAGE, ORIG_RECORD, REPAIR_STATS, MANDATE_ID, 
                            UPLD_BY, UPLD_STATUS, DWNLD_BY, DWNLD_STATUS, ADDITIONAL_INFO, 
                            BALANCE_UPDATED, BALANCE_UPDATED_DATE, OLAP_OPERATOR, NEXT_WORKFLOW_QUEUE_ID, NEXT_WORKFLOW_STATUS, 
                            MQ_ACKN_FEEDBACK_CODE, REPLY_TO_MQ_QUEUE_MANAGER, REPLY_TO_MQ_QUEUE, APPLICATION_IDENTITY_DATA, STATISTICS_ID, 
                            SERVICE_TYPE_ID, UNIQUE_END_TRAN_REFERENCE, PAYMENT_DUEDATE, DISPLAY_FLAG, CURRENT_AUTH_LEVEL, 
                            SETTLEMENTMETHOD, STMT_BALN_CALC_FLAG, SL_DB_POPULATE, ACCOUNT_OPEN_BALANCE, ADDITIONAL_INFO_FLAG, 
                            AUTH_MODE, BALANCE_FLAG, BEN_ADDRESS1, COMPUTE_BALANCE_FLAG, DETAILSOFCHARGES, 
                            DOCUMENT_COUNT, EMAIL_COUNT, GROUPINGINFO_BATCH, GROUPINGINFO_FILE, IMAGES_COUNT, 
                            INV_PAY_REF_ID, LATEST_STMT_RECORD_FLAG, MATCH_STATMENT_FLAG, NATURE_OF_TRANSACTION, NOTES_COUNT, 
                            ORDERPARTY_CURRENCY, ORIGINATING_SYSTEM, OTHERS_ATTACHMENTS_COUNT_1, OTHERS_ATTACHMENTS_COUNT_2, OTHERS_ATTACHMENTS_COUNT_3, 
                            PAYMENT_RUN_ID, PREV_MSGDATE, STATUS_STRING, STMT_BALANCE_TYPE, STMT_CLOSING_BALANCE, 
                            STMT_CLOSING_BOOKED_BALANCE, STMT_OPEN_BALN, STMT_TXNS_SEQNO, TENANT_NAME, VIDEO_COUNT, 
                            GROUP_ID, DATAKEYID, CUSTOMER_ENC, CORRESPONDENT_ENC, BENEFNAME_ENC, 
                            ORIGNAME_ENC, CUSTOMERACCNO_ENC, ACCOUNT_DR_ENC, ACCOUNT_CR_ENC, OTHER_ACCNO_ENC, 
                            OTHER_PARTY_DETAILS_ENC, ACCOUNT_NUMBER_ENC, PELICAN_ACCOUNT_NO, ORG_MESSAGECLASSTYPE, ORDERING_INSTITUTION_ID, 
                            STMT_CLOSING_AVAILABLE_BALANCE, STMT_FWD_AVAILABLE_BALANCES, ISINPUT, ISOUTPUT, NOSTRO_ACCOUNT_NUMBER, 
                            COMPANY_CODE, CONTRACT_NUMBER, LAST_SANCTION_DT, GROUPINGINFO_EOD, AGGREGATE_FLAG, 
                            SAP_CR, SAP_DR, SUB_SAP_DR, SUB_SAP_CR, EXCHANGE_AMOUNT, 
                            INSTRUCTINGAGENT, INSTRUCTEDAGENT, NOSTRO_ACCOUNT_NUMBER_CPTY)
                    Values
                           (m_msgdb_id, 'TEMPLTQ', m_messageno, NULL, s_messageclasstype(i).messageclasstype, 
                            99, NULL, to_char(sysdate, 'YYYYMMDD'), to_char(sysdate, 'HHMISS'), to_char(sysdate, 'YYYYMMDD'), to_char(sysdate, 'HHMISS'), NULL, NULL, NULL, '9', 
                            'SANTATWWXXX', 'RZBAATWWXXX', 0, NULL, NULL, 
                            '20230904', NULL, 0, 'EUR', NULL, 
                            NULL, NULL, 0, NULL, 0, 
                            NULL, 'DPH96DT2', NULL, NULL, NULL, 
                            'SRVRUSER', NULL, 0, 0, 'MANUAL', 
                            NULL, 'NOTA', NULL, 'SEPA', s_institutionid(j).institutionid, 
                            NULL, NULL, 'EPC', NULL, 'I', 
                            NULL, NULL, 0, NULL, '2023090413174435', 
                            NULL, NULL, NULL, 0, 0, 
                            s_location(k).msgsegr, NULL, NULL, NULL, NULL, 
                            NULL, NULL, 'Y', m_CUSTOM7, NULL, 
                            NULL, NULL, NULL, NULL, NULL, 
                            NULL, NULL, NULL, NULL, NULL, 
                            NULL, 0, 0, 0, NULL, 
                            NULL, NULL, NULL, NULL, NULL, 
                            NULL, NULL, NULL, NULL, NULL, 
                            NULL, NULL, NULL, NULL, NULL, 
                            NULL, NULL, NULL, NULL, NULL, 
                            NULL, NULL, NULL, 0, 0, 
                            0, NULL, NULL, NULL, NULL, 
                            NULL, NULL, NULL, NULL, NULL, 
                            NULL, NULL, NULL, NULL, NULL, 
                            NULL, 0, NULL, 'SEPA', NULL, 
                            NULL, NULL, NULL, NULL, NULL, 
                            0, 0, NULL, NULL, NULL, 
                            NULL, NULL, NULL, NULL, NULL, 
                            NULL, NULL, 0, 0, NULL, 
                            NULL, NULL, NULL, 0, 'PELICAN', 
                            NULL, 0, 0, 0, 0, 
                            NULL, NULL, 0, 'T', NULL, 
                            'PELICAN', NULL, 0, NULL, NULL, 
                            NULL, NULL, NULL, NULL, NULL, 
                            NULL, NULL, TO_DATE('09/04/2023 13:19:14', 'MM/DD/YYYY HH24:MI:SS'), NULL, NULL, 
                            NULL, 'PELICAN1', 0, NULL, NULL, 
                            NULL, NULL, NULL, 0, NULL, 
                            NULL, NULL, NULL, NULL, 0, 
                            0, NULL, NULL, NULL, NULL, 
                            NULL, NULL, NULL, NULL, NULL, 
                            NULL, NULL, 0, NULL, NULL, 
                            NULL, NULL, NULL, 0, NULL, 
                            NULL, NULL, NULL, NULL, NULL, 
                            NULL, '2023090413174435', NULL, NULL, NULL, 
                            NULL, NULL, NULL, NULL, NULL, 
                            NULL, NULL, NULL, NULL, 0, 
                            NULL, NULL, NULL, NULL, NULL, 
                            NULL, 1, 0, 0, 0, 
                            0, 0, NULL, 0, 0, 
                            0, NULL, 0, NULL, NULL, 
                            NULL, NULL, NULL, TO_TIMESTAMP('9/4/2023 1:19:14.580000 PM','fmMMfm/fmDDfm/YYYY fmHH12fm:MI:SS.FF AM'), NULL, 
                            TO_TIMESTAMP('9/4/2023 1:19:14.580000 PM','fmMMfm/fmDDfm/YYYY fmHH12fm:MI:SS.FF AM'), NULL, NULL, 0, NULL, 
                            NULL, NULL, 'NONE', 0, 0, 
                            NULL, NULL, 'CT', NULL, NULL, 
                            'NONE', 'REPR', NULL, NULL, NULL, 
                            NULL, 0, NULL, 0, NULL, 
                            NULL, NULL, NULL, NULL, NULL, 
                            NULL, NULL, NULL, NULL, NULL, 
                            NULL, NULL, NULL, NULL, NULL, 
                            NULL, NULL, NULL, NULL, NULL, 
                            NULL, NULL, NULL, NULL, NULL, 
                            NULL, NULL, NULL, NULL, NULL, 
                            NULL, NULL, NULL, NULL, NULL, 
                            NULL, NULL, NULL, NULL, NULL, 
                            NULL, NULL, NULL, NULL, NULL, 
                            NULL, NULL, NULL, NULL, NULL, 
                            NULL, NULL, NULL, NULL, NULL, 
                            NULL, NULL, NULL, NULL, NULL, 
                            NULL, NULL, NULL, NULL, NULL, 
                            NULL, NULL, 'N', 'N', NULL, 
                            NULL, NULL, NULL, NULL, NULL, 
                            NULL, NULL, NULL, NULL, NULL, 
                            NULL, NULL, NULL);
                                                                                                        
                        INSERT_BLOB_RECORD(m_msgdb_id,1, clob_to_blob(m_pacs8_1_2_175_clob));
                        INSERT_BLOB_RECORD(m_msgdb_id,2, clob_to_blob(m_pacs8_1_2_175_clob));
                        INSERT_BLOB_RECORD(m_msgdb_id,175, clob_to_blob(m_pacs8_1_2_175_clob));
                        INSERT_BLOB_RECORD(m_msgdb_id,145, m_pac8_blob);
                        INSERT_BLOB_RECORD(m_msgdb_id,146, m_pac8_blob);        
                                                                                                       
                                                                                                           
                             
                                                                                  
                             

                                                                                                                        
                                                                                        
                        Insert into MSGDB_PAY
                               (MSGDB_ID, MDBPAY_PAYMENTSYSTEM, MDBPAY_ORDERING_CUST_BIC, MDBPAY_ORDERING_CUST_LCODE, MDBPAY_ORDERING_CUST_LC_TYPE, 
                                MDBPAY_SENDING_INST_BIC, MDBPAY_SENDING_INST_LCODE, MDBPAY_SENDING_INST_LC_TYPE, MDBPAY_ORDERING_INST_BIC, MDBPAY_ORDERING_INST_LCODE, 
                                MDBPAY_ORDERING_INST_LC_TYPE, MDBPAY_SENDER_CORR_BIC, MDBPAY_SENDER_CORR_LCODE, MDBPAY_SENDER_CORR_LC_TYPE, MDBPAY_RCVR_CORR_BIC, 
                                MDBPAY_RCVR_CORR_LCODE, MDBPAY_RCVR_CORR_LC_TYPE, MDBPAY_THRD_REIMB_INST_BIC, MDBPAY_THRD_REIMB_INST_LCODE, MDBPAY_THRD_REIMB_INST_LC_TYPE, 
                                MDBPAY_INTERM_INST_BIC, MDBPAY_INTERM_INST_LCODE, MDBPAY_INTERM_INST_LC_TYPE, MDBPAY_ACC_WITH_INST_BIC, MDBPAY_ACC_WITH_INST_LCODE, 
                                MDBPAY_ACC_WITH_INST_LC_TYPE, MDBPAY_BENEF_BIC, MDBPAY_CUSTACCNO, MDBPAY_RELATED_REF, MDBPAY_EXCH_RATE, 
                                MDBPAY_ORI_VAL_DT, MDBPAY_ORI_VAL_AMT, MDBPAY_CHARGE_1, MDBPAY_CHARGE_1_CURR, MDBPAY_CHARGE_2, 
                                MDBPAY_CHARGE_2_CURR, MDBPAY_CHARGE_CODE, MDBPAY_BRANCH, MDBPAY_BENEFNAME, MDBPAY_ORDERING_CUST_NAME, 
                                MDBPAY_BENF_TYPE, ARCH_STATUS, ARCH_DATE, REMITTANCE_INFO, MDBPAY_ORD_INST_NAME_ADDR1, 
                                MDBPAY_ORD_INST_ADDR2, MDBPAY_ORD_INST_ADDR3, MDBPAY_ORD_INST_ADDR4, CHARGE_CODE_NEW, MDBPAY_BENEF_DETAILS, 
                                MDBPAY_ORD_INST_ADDR1, REGULATORY_RPT, REMITTANCE_STR_CODE, REMITTANCE_STR_ISSUER, REMITTANCE_STR_REF, 
                                REMITTANCE_UNSTR_INFO, MDBPAY_CUSTACCNO_ENC, MDBPAY_BENEFNAME_ENC, MDBPAY_ORDERING_CUST_NAME_ENC, END2END_ID, 
                                BI_TRANS_CODE, SOURCE_SYS, UETR)
                        Values
                               (m_msgdb_id, NULL, NULL, NULL, NULL, 
                                NULL, NULL, NULL, NULL, NULL, 
                                NULL, NULL, NULL, NULL, NULL, 
                                NULL, NULL, NULL, NULL, NULL, 
                                NULL, NULL, NULL, NULL, NULL, 
                                NULL, 'SANTATWWXXX', NULL, NULL, NULL, 
                                NULL, NULL, NULL, NULL, NULL, 
                                NULL, NULL, NULL, NULL, NULL, 
                                NULL, NULL, NULL, 'Unstructured', NULL, 
                                NULL, NULL, NULL, NULL, 'Santander Consumer Bank GmbH
                        Wagramer Strasse 19
                        Wien
                        AUSTRIA', 
                                'N', NULL, NULL, NULL, NULL, 
                                NULL, NULL, NULL, NULL, NULL, 
                                NULL, NULL, NULL);
                                                                                        
                        Insert into MSGDB_OUTPUT
                               (MSGDB_ID, MDBOUT_MODE, MDBOUT_STATUS, MDBOUT_DATE_TIME, ARCH_STATUS, 
                                ARCH_DATE, INSTANCEID)
                        Values
                               (m_msgdb_id, 'RECEIVE', 'N', NULL, NULL, 
                                NULL, NULL);
                    END IF; 
                                                                    
                END IF;
               
                   
               BEGIN
                    INSERT INTO TABLEDETAILS 
                    (
                    TDIDCODE,
                    TDKEY,
                    TDVALUE,
                    STATUS,
                    USERID
                    ) 
                    VALUES (
                    'GENERIC-CONFIG',
                    'DEFAULT_TEMPLATE',
                    'Y',
                    'V',
                    'ADMIN1');
                        COMMIT;
               EXCEPTION
               WHEN DUP_VAL_ON_INDEX
               THEN
                         NULL;
               WHEN OTHERS
               THEN
                    null;
--                        DBMS_OUTPUT.PUT_LINE ('OTHERS...'|| SQLCODE|| SQLERRM|| DBMS_UTILITY.format_error_backtrace);
               END;
               
               COMMIT;
            
            EXCEPTION    
            
            WHEN OTHERS 
            THEN
                ROLLBACK;
--                    DBMS_OUTPUT.PUT_LINE('OTHERS : '||SQLCODE||SQLERRM|| DBMS_UTILITY.format_error_backtrace);
                    genaudit_insert_enchash_wrap
                                           (
                                           NULL,
                                           NULL,
                                           NULL,
                                           g_application,
                                           g_modulename,
                                           g_action,
                                           'OTHERS1 : '||SQLCODE||SQLERRM|| DBMS_UTILITY.format_error_backtrace,
                                           NULL,
                                           0
                                           );
                                           COMMIT;  
            END;                                               
            END LOOP; --LOCATION LOOP
        
        EXCEPTION    
            
            WHEN OTHERS 
            THEN
                ROLLBACK;
--                    DBMS_OUTPUT.PUT_LINE('OTHERS2 : '||SQLCODE||SQLERRM|| DBMS_UTILITY.format_error_backtrace);
                    genaudit_insert_enchash_wrap
                                           (
                                           NULL,
                                           NULL,
                                           NULL,
                                           g_application,
                                           g_modulename,
                                           g_action,
                                           'OTHERS : '||SQLCODE||SQLERRM|| DBMS_UTILITY.format_error_backtrace,
                                           NULL,
                                           0
                                           );
                                           COMMIT;   
        END;                                           
        END LOOP; --INSTITUTION LOOP
      
    END LOOP; -- MESSAGECLASSTYPE

    genaudit_insert_enchash_wrap
                               (
                               NULL,
                               NULL,
                               NULL,
                               g_application,
                               g_modulename,
                               g_action,
                               'Templates inserted for SANTATWW,SANTAT00,ACEABANK,PLCNGBWB institutions',
                               NULL,
                               0
                               );
                               COMMIT; 
EXCEPTION 
WHEN TEMPLATES_ALREADY_INSERTED
THEN
    NULL;
--    DBMS_OUTPUT.PUT_LINE ('TEMPLATES_ALREADY_INSERTED');
WHEN OTHERS 
THEN
    ROLLBACK;
--        DBMS_OUTPUT.PUT_LINE('OTHERS3 : '||SQLCODE||SQLERRM|| DBMS_UTILITY.format_error_backtrace);
        genaudit_insert_enchash_wrap
                               (
                               NULL,
                               NULL,
                               NULL,
                               g_application,
                               g_modulename,
                               g_action,
                               'OTHERS : '||SQLCODE||SQLERRM|| DBMS_UTILITY.format_error_backtrace,
                               NULL,
                               0
                               );
                               COMMIT;       
END;
/
-- [9.06.00.012.02] [20231022] [PTRAMBAKE] [END]
EXIT;