create or replace PROCEDURE upsert_account_balance (
   p_queue_id    IN   msgdb.queueid%TYPE,
   p_processid   IN   msgdb.process_id%TYPE
)
IS
   CURSOR c_msgdb_batch_data
   IS
      SELECT   msgdb_id, messageno, institutionid, stmt_open_baln,
               account_number, prioritydate, stmt_closing_booked_balance,
               stmt_closing_available_balance, stmt_fwd_available_balances
          FROM msgdb
         WHERE queueid = p_queue_id
           AND process_id = p_processid
           AND stmt_baln_calc_flag = 'Y'
      ORDER BY account_number, prioritydate, page_number;

   CURSOR c_msgdb_data (c_msgdb_id msgdb.msgdb_id%TYPE)
   IS
      SELECT   am.account_number, am.account_number_enc, am.bank_code,
               prioritydate, stmt_baln_calc_flag, stmt_open_baln,
               transactiontype, priorityamountnum, institutionid, page_number,
               total_pages, msgdb_id, messageno, currency, process_id,
               stmt_closing_balance, msg_family, messageclasstype,
                m.datakeyid,
                m.nostro_account_number
          FROM msgdb m, account_master am
         WHERE msgdb_id_batch = c_msgdb_id
           AND (   m.customeraccno = am.account_number
                OR m.customeraccno = am.account_iban
                OR m.customeraccno_enc = am.account_number_enc
                OR m.customeraccno_enc = am.account_iban_enc)
AND am.account_status = 'VALIDATED'
           AND am.institution_id = m.institutionid
      ORDER BY account_number_enc,
      prioritydate,
       page_number,
        sequenceno;

    CURSOR c_msgdb_data_nostro
    (
    c_msgdb_id     msgdb.msgdb_id%TYPE
    )
    IS
    SELECT      am.account_number,
                am.account_number_enc,
                am.bank_code,
                prioritydate,
                stmt_baln_calc_flag,
                stmt_open_baln,
                transactiontype,
                priorityamountnum,
                institutionid,
                page_number,
                total_pages,
                msgdb_id,
                messageno,
                currency,
                process_id,
                stmt_closing_balance,
                msg_family,
                messageclasstype,
                m.datakeyid,
                m.nostro_account_number
    FROM        msgdb m,
                account_master am
    WHERE       msgdb_id_batch          = c_msgdb_id
    AND         (m.nostro_account_number = am.account_number_enc
             OR m.nostro_account_number = am.account_number
        OR m.nostro_account_number =am.account_iban_enc
        OR m.nostro_account_number =am.account_iban)
    AND am.ACCOUNT_STATUS='VALIDATED'
    AND am.institution_id =m.institutionid
    ORDER BY    account_number_enc,
                prioritydate,
                page_number,
                sequenceno;

   CURSOR c_update_acbalance (
      c_institution_id   account_balance.institution_id%TYPE,
      c_account_number   account_balance.account_number_enc%TYPE,
      c_entry_date       account_balance.entry_date%TYPE
   )
   IS
      SELECT   account_number, account_number_enc, institution_id,
               baln_update_source, entry_date
          FROM account_balance
         WHERE institution_id = c_institution_id
           AND (   account_number_enc = c_account_number
                OR account_number = c_account_number
               )
           AND entry_date > c_entry_date
      ORDER BY entry_date;

   TYPE t_account_balance IS TABLE OF c_update_acbalance%ROWTYPE;

   a_updt_data                     t_account_balance   := t_account_balance
                                                                           ();
   no_batches_found                EXCEPTION;
   no_tran_found                   EXCEPTION;

   TYPE t_msgdb IS TABLE OF c_msgdb_data%ROWTYPE;

   a_data                          t_msgdb                       := t_msgdb
                                                                           ();

   TYPE tt_msgdb IS TABLE OF c_msgdb_batch_data%ROWTYPE;

   a_batch_id                      tt_msgdb                     := tt_msgdb
                                                                           ();
   no_local_currency_found         EXCEPTION;

   TYPE t_prev_data IS TABLE OF account_balance%ROWTYPE;

   a_prev_data                     t_prev_data               := t_prev_data
                                                                           ();
   m_ctr_beg                       NUMBER                                 := 0;
   m_ctr_end                       NUMBER                                 := 0;
   b_ctr_beg                       NUMBER                                 := 0;
   b_ctr_end                       NUMBER                                 := 0;
   m_record_cnt                    NUMBER                                 := 0;
   m_prev_account_number           msgdb.account_number%TYPE            := 'X';
   m_close_bal                     VARCHAR2 (50)                       := NULL;
   m_open_bal                      VARCHAR2 (50)                       := NULL;
   m_total_bal                     VARCHAR2 (50)                       := NULL;
   -- m_eod_messageclasstype          VARCHAR2(500)                               := NULL;
   m_encrypt                       VARCHAR2 (500)                 := 'ENCRYPT';
   m_decrypt                       VARCHAR2 (500)                 := 'DECRYPT';
   m_context_name                  VARCHAR2 (32664)             := NULL;
   m_prefix                        VARCHAR2 (32664)                := 'PREFIX';
   m_active_datakeyid              VARCHAR2 (32664)                    := NULL;
   m_tenant_list                   VARCHAR2 (32664)                    := NULL;
   m_tenant                        VARCHAR2 (32664)                    := NULL;
   m_update_balance                BOOLEAN                            := FALSE;
   m_action                        genaudit.action%TYPE                := NULL;
   m_audit_text                    genaudit.audittext%TYPE             := NULL;
   m_msgdb_id                      msgdb.msgdb_id%TYPE                 := NULL;
   m_batch_id                      msgdb.msgdb_id%TYPE                 := NULL;
   m_batch_messageno               msgdb.messageno%TYPE                := NULL;
   m_messageno                     msgdb.messageno%TYPE                := NULL;
   m_institutionid                 msgdb.institutionid%TYPE            := NULL;
   m_acc_count                     NUMBER                                 := 0;
   m_start                         NUMBER                                 := 0;
   m_end                           NUMBER                                 := 0;
   u_ctr_beg                       NUMBER                                 := 0;
   u_ctr_end                       NUMBER                                 := 0;
   m_xchg_rate                     exchange_rate.xchg_rate%TYPE           := 0;
   m_to_convert_curr               exchange_rate.xchg_conv_cur%TYPE    := NULL;
   m_priorityamountnum             msgdb.priorityamountnum%TYPE           := 0;
   m_total_days_count              NUMBER                                 := 0;
   m_today_balance                 account_balance.open_actual%TYPE       := 0;
   m_no_of_days                    NUMBER                                 := 0;
   m_bank_code                     account_balance.bank_code%TYPE      := NULL;
   m_timestamp_beg                 TIMESTAMP;
   m_timestamp_end                 TIMESTAMP;
   m_error_transactions            BOOLEAN;
   m_entry_date                    account_balance.entry_date%TYPE     := NULL;
   m_monthly_balance_flag          account_balance.monthly_balance_flag%TYPE
                                                                       := NULL;
   m_weekly_balance_flag           account_balance.weekly_balance_flag%TYPE
                                                                       := NULL;
   m_cnt                           NUMBER                                 := 0;
   m_statement_flag                NUMBER                                 := 0;
   m_opebal_cnt                    NUMBER                                 := 0;
   m_prev_prioritydate             msgdb.prioritydate%TYPE              := 'X';
   m_eod_messageclasstype          VARCHAR2 (500)                      := NULL;
   m_stmt_closing_booked_balance   account_balance.stmt_closing_booked_balance%TYPE
                                                                       := NULL;
   m_stmt_fwd_available_balance    VARCHAR2 (500)                      := NULL;
   m_fwd_balance                   account_balance.stmt_closing_booked_balance%TYPE
                                                                       := NULL;
   m_fwd_available_balance         VARCHAR2 (500)                      := NULL;
   n_string_count                  NUMBER                                 := 0;
   n_cnt                           NUMBER                                 := 0;
   m_fwd_entry_date                account_balance.entry_date%TYPE;
   m_path                          INSTITUTIONPARAMETERS.path%TYPE             := 'INSTITUTION_DETAILS';
    m_columnconfig_tdvalue                           TABLEDETAILS.TDVALUE%TYPE               := NULL;
   m_tdvalue                       TABLEDETAILS.TDVALUE%TYPE                   := NULL;

   m_tenant_name                   INSTITUTIONPARAMETERS.PARAMNAME%TYPE        := 'TENANT_NAME';
   m_paramvalue                    INSTITUTIONPARAMETERS.PARAMVALUE%TYPE       := NULL;
   m_tdidcode_display_flag         TABLEDETAILS.TDIDCODE%TYPE                  := 'DISPLAY_FLAG';
BEGIN
--   m_active_datakeyid := SYS_CONTEXT (m_context_name, 'ACTIVE_DATAKEYID');
--   m_tenant_list := SYS_CONTEXT (m_context_name, 'ENCRYPTION_TENANT_LIST');
   m_timestamp_beg :=
      TO_TIMESTAMP ((TO_CHAR (SYSDATE, 'YYYY-MM-DD') || ' 00:00:00.000'),
                    'YYYY-MM-DD HH24:MI:SS.FF3'
                   );
   m_timestamp_end :=
      TO_TIMESTAMP ((TO_CHAR (SYSDATE, 'YYYY-MM-DD') || ' 23:59:59.999'),
                    'YYYY-MM-DD HH24:MI:SS.FF3'
                   );

   FOR rec1 IN (SELECT *
                  FROM account_master
                 WHERE account_status = 'VALIDATED')
   LOOP
      SELECT COUNT (*)
        INTO m_acc_count
        FROM account_balance
       WHERE institution_id = rec1.institution_id
         AND (   account_number_enc = rec1.account_number_enc
              OR account_number = rec1.account_number
             )
         AND entry_date BETWEEN m_timestamp_beg AND m_timestamp_end;

      IF m_acc_count = 0
      THEN
         EXIT;
      END IF;
   END LOOP;

   DBMS_OUTPUT.put_line ('m_acc_count : ' || m_acc_count);

   IF m_acc_count = 0
   THEN
      SELECT ac.*
      BULK COLLECT INTO a_prev_data
        FROM (SELECT *
                FROM account_balance) ac,
             (SELECT   i.institution_id, j.account_number,
                       j.account_number_enc, MAX (i.entry_date) entry_date
                  FROM account_balance i, account_master j
                 WHERE (   i.account_number_enc = j.account_number_enc
                        OR i.account_number = j.account_number
                       )
                   AND i.institution_id = j.institution_id
                   AND j.account_status = 'VALIDATED'
                   AND i.baln_update_source IS NOT NULL
              GROUP BY i.institution_id,
                       j.account_number,
                       j.account_number_enc) pac
       WHERE ac.institution_id = pac.institution_id
         AND (   ac.account_number_enc = pac.account_number_enc
              OR ac.account_number = pac.account_number
             )
         AND ac.entry_date = pac.entry_date;

      IF NVL (a_prev_data.LAST, 0) > 0
      THEN
         FOR i IN 1 .. NVL (a_prev_data.LAST, 0)
         LOOP
            IF TO_CHAR (a_prev_data (i).entry_date, 'YYYYMMDD') <
                                                TO_CHAR (SYSDATE, 'YYYYMMDD')
            THEN
               a_prev_data (i).baln_update_source := 'CARRIED-FORWARD';
               a_prev_data (i).open_actual := a_prev_data (i).close_actual;
               m_no_of_days :=
                    TO_DATE (TO_CHAR (SYSDATE, 'YYYYMMDD'), 'YYYYMMDD')
                  - TO_DATE (TO_CHAR (a_prev_data (i).entry_date, 'YYYYMMDD'),
                             'YYYYMMDD'
                            );
               a_prev_data (i).stmt_closing_booked_balance :=
                                   a_prev_data (i).stmt_closing_booked_balance;
               DBMS_OUTPUT.put_line ('After m_no_of_days : ' || m_no_of_days);

               FOR x IN 1 .. m_no_of_days
               LOOP
                  BEGIN
                     a_prev_data (i).entry_date :=
                        TO_TIMESTAMP (TO_CHAR (a_prev_data (i).entry_date + 1,
                                               'YYYYMMDD'
                                              ),
                                      'yyyymmddHH24:MI:SS'
                                     );
                     a_prev_data (i).monthly_balance_flag := 'Y';
                     a_prev_data (i).weekly_balance_flag := 'Y';
                     a_prev_data (i).datakeyid := a_prev_data (i).datakeyid;
                     a_prev_data (i).sum_of_forecast_payments := NULL;
                     a_prev_data (i).sum_of_payments := NULL;
                     a_prev_data (i).sum_of_receivables := NULL;
                     a_prev_data (i).sum_of_unreconciled_payments := NULL;
                     a_prev_data (i).sum_unreconciled_receivables := NULL;
                     a_prev_data (i).sum_of_forecast_receivables := NULL;
                     DBMS_OUTPUT.put_line (   'a_prev_data(i).entry_date : '
                                           || a_prev_data (i).entry_date
                                          );

                     INSERT INTO account_balance
                          VALUES a_prev_data (i);

                     m_timestamp_beg :=
                        TO_TIMESTAMP
                                    ((   TO_CHAR (  a_prev_data (i).entry_date
                                                  - 1,
                                                  'YYYY-MM-DD'
                                                 )
                                      || ' 00:00:00.000'
                                     ),
                                     'YYYY-MM-DD HH24:MI:SS.FF3'
                                    );
                     m_timestamp_end :=
                        TO_TIMESTAMP
                                    ((   TO_CHAR (  a_prev_data (i).entry_date
                                                  - 1,
                                                  'YYYY-MM-DD'
                                                 )
                                      || ' 23:59:59.999'
                                     ),
                                     'YYYY-MM-DD HH24:MI:SS.FF3'
                                    );

                     IF balance_period_flag ('M',
                                             a_prev_data (i).entry_date - 1
                                            ) = 'N'
                     THEN
                        UPDATE account_balance
                           SET monthly_balance_flag = 'N'
                         WHERE entry_date BETWEEN m_timestamp_beg
                                              AND m_timestamp_end
                           AND institution_id = a_prev_data (i).institution_id
                           AND account_number = a_prev_data (i).account_number;
                     END IF;

                     IF balance_period_flag ('W',
                                             a_prev_data (i).entry_date - 1
                                            ) = 'N'
                     THEN
                        UPDATE account_balance
                           SET weekly_balance_flag = 'N'
                         WHERE entry_date BETWEEN m_timestamp_beg
                                              AND m_timestamp_end
                           AND institution_id = a_prev_data (i).institution_id
                           AND account_number = a_prev_data (i).account_number;
                     END IF;

                     COMMIT;
                  EXCEPTION
                     WHEN DUP_VAL_ON_INDEX
                     THEN
                        DBMS_OUTPUT.put_line ('DUP_VAL_ON_INDEX');

                        UPDATE account_balance
                           SET open_actual = a_prev_data (i).open_actual,
                               close_actual = a_prev_data (i).close_actual,
                               curr_actual_local_curr_bal =
                                    a_prev_data (i).curr_actual_local_curr_bal,
                               last_acnt_baln_record_flag = 'Y',
                               baln_update_source = 'CARRIED-FORWARD',
                               stmt_closing_booked_balance =
                                   a_prev_data (i).stmt_closing_booked_balance,
                               monthly_balance_flag = 'Y',
                               weekly_balance_flag = 'Y'
                         WHERE entry_date =
                                  TO_TIMESTAMP
                                         (TO_CHAR (a_prev_data (i).entry_date,
                                                   'YYYYMMDD'
                                                  ),
                                          'yyyymmddHH24:MI:SS'
                                         )
                           AND (   account_number_enc =
                                            a_prev_data (i).account_number_enc
                                OR account_number =
                                                a_prev_data (i).account_number
                               )
                           AND institution_id = a_prev_data (i).institution_id;

                        m_timestamp_beg :=
                           TO_TIMESTAMP
                                    ((   TO_CHAR (  a_prev_data (i).entry_date
                                                  - 1,
                                                  'YYYY-MM-DD'
                                                 )
                                      || ' 00:00:00.000'
                                     ),
                                     'YYYY-MM-DD HH24:MI:SS.FF3'
                                    );
                        m_timestamp_end :=
                           TO_TIMESTAMP
                                    ((   TO_CHAR (  a_prev_data (i).entry_date
                                                  - 1,
                                                  'YYYY-MM-DD'
                                                 )
                                      || ' 23:59:59.999'
                                     ),
                                     'YYYY-MM-DD HH24:MI:SS.FF3'
                                    );

                        IF balance_period_flag ('M',
                                                a_prev_data (i).entry_date - 1
                                               ) = 'N'
                        THEN
                           UPDATE account_balance
                              SET monthly_balance_flag = 'N'
                            WHERE entry_date BETWEEN m_timestamp_beg
                                                 AND m_timestamp_end;
                        END IF;

                        IF balance_period_flag ('W',
                                                a_prev_data (i).entry_date - 1
                                               ) = 'N'
                        THEN
                           UPDATE account_balance
                              SET weekly_balance_flag = 'N'
                            WHERE entry_date BETWEEN m_timestamp_beg
                                                 AND m_timestamp_end;
                        END IF;
                     WHEN OTHERS
                     THEN
                        DBMS_OUTPUT.put_line
                                          (   'Record already present for : '
                                           || a_prev_data (i).account_number
                                          );
                  END;
               END LOOP;
            END IF;
         END LOOP;
      END IF;
   END IF;

   DBMS_OUTPUT.put_line ('p_queue_id : ' || p_queue_id);
   DBMS_OUTPUT.put_line ('p_processid : ' || p_processid);

   OPEN c_msgdb_batch_data;

   FETCH c_msgdb_batch_data
   BULK COLLECT INTO a_batch_id;

   CLOSE c_msgdb_batch_data;

   b_ctr_beg := NVL (a_batch_id.FIRST, 0);
   b_ctr_end := NVL (a_batch_id.LAST, 0);

   IF b_ctr_end = 0
   THEN
      RAISE no_batches_found;
   END IF;

   FOR b_ctr IN b_ctr_beg .. b_ctr_end
   LOOP
      BEGIN
         m_error_transactions := FALSE;
         DBMS_OUTPUT.put_line (   'Running batch ID : '
                               || a_batch_id (b_ctr).msgdb_id
                              );
         m_batch_id := a_batch_id (b_ctr).msgdb_id;
         m_batch_messageno := a_batch_id (b_ctr).messageno;
         m_open_bal := NVL (a_batch_id (b_ctr).stmt_open_baln, 0);
         m_stmt_closing_booked_balance :=
            NVL (a_batch_id (b_ctr).stmt_closing_available_balance,
                 a_batch_id (b_ctr).stmt_closing_booked_balance
                );
         m_stmt_fwd_available_balance :=
                                a_batch_id (b_ctr).stmt_fwd_available_balances;
         DBMS_OUTPUT.put_line (   'm_stmt_fwd_available_balance: '
                               || m_stmt_fwd_available_balance
                              );
         DBMS_OUTPUT.put_line ('m_open_ball: ' || m_open_bal);
         DBMS_OUTPUT.put_line (   'a_batch_id(b_ctr).prioritydate : '
                               || a_batch_id (b_ctr).prioritydate);
            BEGIN

                m_tenant     := get_institution_param_value(a_batch_id(b_ctr).institutionid,'INSTITUTION_DETAILS','TENANT_NAME');--NVL(GET_TENANTNAME(a_institutions(rec).institutionid),'X');

            EXCEPTION
            WHEN NO_dATA_FOUND
            THEN
                m_tenant:='X';
            END;
            m_columnconfig_tdvalue    := NVL(TD_GET_VALUE(m_tenant,'ACCOUNT_REF'),'XX');

            DBMS_OUTPUT.put_line('m_tenant : ' || m_tenant);
            DBMS_OUTPUT.put_line('m_columnconfig_tdvalue : ' || m_columnconfig_tdvalue);

            IF m_columnconfig_tdvalue = 'NOSTRO_ACCOUNT_NUMBER'
            THEN
                OPEN  c_msgdb_data_nostro(a_batch_id(b_ctr).msgdb_id);
                FETCH c_msgdb_data_nostro BULK COLLECT INTO  a_data;
                CLOSE c_msgdb_data_nostro;
            ELSE
                OPEN  c_msgdb_data(a_batch_id(b_ctr).msgdb_id);
                FETCH c_msgdb_data BULK COLLECT INTO  a_data;
                CLOSE c_msgdb_data;
            END IF;

         m_ctr_beg := NVL (a_data.FIRST, 0);
         m_ctr_end := NVL (a_data.LAST, 0);
         DBMS_OUTPUT.put_line ('m_ctr_beg: ' || m_ctr_beg);
         DBMS_OUTPUT.put_line ('m_ctr_end: ' || m_ctr_end);
         m_today_balance := 0;

         IF m_ctr_end = 0
         THEN
            RAISE no_tran_found;
         END IF;

         FOR m_ctr IN m_ctr_beg .. m_ctr_end
         LOOP
            BEGIN
               a_data (m_ctr).prioritydate :=
                  NVL (a_batch_id (b_ctr).prioritydate,a_data (m_ctr).prioritydate);

               IF a_data (m_ctr).prioritydate <> m_prev_prioritydate
               THEN
                  /*SELECT COUNT(1)
                  INTO m_statement_flag
                  FROM msgdb
                  WHERE account_number = a_data(m_ctr).account_number
                  AND institutionid   =   a_data(m_ctr).institutionid
                  AND process_id = 'CALCULATED'
                  AND STMT_OPEN_BALN IS NOT NULL
                  AND ROWNUM < 2
                  AND msgdb_id IN (SELECT msgdb_id_batch FROM msgdb WHERE account_number = a_data(m_ctr).account_number
                                  AND institutionid   =   a_data(m_ctr).institutionid AND prioritydate = a_data(m_ctr).prioritydate ); */
                  m_eod_messageclasstype :=
                     eod_statement_messageclasstype (a_data (m_ctr).msg_family
                                                    );
                  DBMS_OUTPUT.put_line (   'm_eod_messageclasstype: '
                                        || m_eod_messageclasstype
                                       );

                  BEGIN
                     SELECT NVL (paramvalue, 'X')
                       INTO m_tenant
                       FROM institutionparameters
                      WHERE institutionid = a_data (m_ctr).institutionid
                        AND paramname = 'TENANT_NAME';
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        m_tenant := 'X';
                  END;

             BEGIN

                  SELECT TDVALUE
                  INTO m_context_name
                  FROM TABLEDETAILS
                  WHERE TDIDCODE ='CONTEXT'
                  AND
                  TDKEY = m_tenant ;
                        --DBMS_OUTPUT.PUT_LINE('m_context_name -->'||m_context_name);

              EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN

                       DBMS_OUTPUT.PUT_LINE ('No CONTEXT found ');
             END;

               m_tenant_list := SYS_CONTEXT (m_context_name, 'ENCRYPTION_TENANT_LIST');
               m_active_datakeyid := sys_context(m_context_name,'ACTIVE_DATAKEYID');
              --DBMS_OUTPUT.PUT_LINE('m_tenant_list -->'||m_tenant_list);

             --DBMS_OUTPUT.PUT_LINE('m_active_datakeyid -->'||m_active_datakeyid);


                  IF  instr(m_tenant_list,m_tenant)>0
                  THEN
                     m_statement_flag :=
                        is_eod_statement_received
                                           (a_data (m_ctr).account_number_enc,
                                            a_data (m_ctr).institutionid,
                                            m_eod_messageclasstype,
                                            a_data (m_ctr).prioritydate
                                           );
                  ELSE
                     m_statement_flag :=
                        is_eod_statement_received
                                               (a_data (m_ctr).account_number,
                                                a_data (m_ctr).institutionid,
                                                m_eod_messageclasstype,
                                                a_data (m_ctr).prioritydate
                                               );
                  END IF;

                  DBMS_OUTPUT.put_line (   'm_statement_flag: '
                                        || m_statement_flag
                                       );

                  IF m_statement_flag = 1
                  THEN
                     IF a_data (m_ctr).messageclasstype =
                           eod_statement_messageclasstype
                                                    (a_data (m_ctr).msg_family
                                                    )
                     THEN
                        m_statement_flag := 0;
                     END IF;
                  END IF;
               END IF;

               m_prev_prioritydate := a_data (m_ctr).prioritydate;
               a_data (m_ctr).process_id := 'CALCULATED';
               m_msgdb_id := a_data (m_ctr).msgdb_id;
               m_messageno := a_data (m_ctr).messageno;
               m_institutionid := a_data (m_ctr).institutionid;
               m_timestamp_beg :=
                  TO_TIMESTAMP ((a_data (m_ctr).prioritydate
                                 || ' 00:00:00.000'
                                ),
                                'YYYY-MM-DD HH24:MI:SS.FF3'
                               );
               m_timestamp_end :=
                  TO_TIMESTAMP ((a_data (m_ctr).prioritydate
                                 || ' 23:59:59.999'
                                ),
                                'YYYY-MM-DD HH24:MI:SS.FF3'
                               );
               DBMS_OUTPUT.put_line ('m_timestamp_beg : ' || m_timestamp_beg);
               DBMS_OUTPUT.put_line ('m_timestamp_end : ' || m_timestamp_end);
               DBMS_OUTPUT.put_line (   'a_data(m_ctr).account_number : '
                                     || a_data (m_ctr).account_number
                                    );
               DBMS_OUTPUT.put_line (   'm_prev_account_number : '
                                     || m_prev_account_number
                                    );

               IF    a_data (m_ctr).account_number_enc !=
                                                         m_prev_account_number
                  OR a_data (m_ctr).account_number != m_prev_account_number
               THEN
                  m_close_bal := 0;
                  m_total_bal := 0;
                  DBMS_OUTPUT.put_line ('Inside');

                  BEGIN
                     IF m_open_bal = 0
                     THEN
                        DBMS_OUTPUT.put_line ('Inside1');

                        SELECT   close_actual
                            INTO m_open_bal
                            FROM account_balance
                           WHERE (   account_number_enc =
                                             a_data (m_ctr).account_number_enc
                                  OR account_number =
                                                 a_data (m_ctr).account_number
                                 )
                             AND entry_date BETWEEN m_timestamp_beg
                                                AND m_timestamp_end
                             AND institution_id = a_data (m_ctr).institutionid
                             AND ROWNUM < 2
                        ORDER BY entry_date DESC;

                        DBMS_OUTPUT.put_line
                                      (   'From closing balance m_open_bal : '
                                       || m_open_bal
                                      );
                     END IF;
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        m_open_bal := 0;
                        DBMS_OUTPUT.put_line
                                       (   'From NO_DATA_FOUND m_open_bal : '
                                        || m_open_bal
                                       );
                  END;

                  DBMS_OUTPUT.put_line ('fIRST m_open_bal : ' || m_open_bal);
                  m_total_bal := NVL (m_open_bal, 0);
               END IF;

               IF  instr(m_tenant_list,m_tenant)>0
               THEN
                  IF    (    m_ctr < m_ctr_end
                         AND (   a_data (m_ctr).prioritydate !=
                                               a_data (m_ctr + 1).prioritydate
                              OR a_data (m_ctr).account_number_enc !=
                                         a_data (m_ctr + 1).account_number_enc
                             )
                        )
                     OR m_ctr = m_ctr_end
                  THEN
                     m_update_balance := TRUE;
                  END IF;
               ELSE
                  IF    (    m_ctr < m_ctr_end
                         AND (   a_data (m_ctr).prioritydate !=
                                               a_data (m_ctr + 1).prioritydate
                              OR a_data (m_ctr).account_number !=
                                             a_data (m_ctr + 1).account_number
                             )
                        )
                     OR m_ctr = m_ctr_end
                  THEN
                     m_update_balance := TRUE;
                  END IF;
               END IF;

               BEGIN
                  SELECT account_curr, bank_code
                    INTO m_to_convert_curr, m_bank_code
                    FROM account_master
                   WHERE institution_id = a_data (m_ctr).institutionid
                     AND (   account_number = a_data (m_ctr).account_number
                          OR account_number_enc =
                                             a_data (m_ctr).account_number_enc
                         )
                     AND account_status = 'VALIDATED';
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     m_to_convert_curr :=
                        NVL
                           (get_institution_param_value
                               (p_institutionid      => a_data (m_ctr).institutionid,
                                p_path               => 'INSTITUTION_DETAILS',
                                p_paramname          => 'LOCAL_CURRENCY_CODE'
                               ),
                            a_data (m_ctr).currency
                           );
               END;

               DBMS_OUTPUT.put_line ('Before m_total_bal  : ' || m_total_bal);
               DBMS_OUTPUT.put_line ('Before m_close_bal  : ' || m_close_bal);
               DBMS_OUTPUT.put_line (   'Before transactiontype  : '
                                     || a_data (m_ctr).transactiontype
                                    );

               IF a_data (m_ctr).currency != m_to_convert_curr
               THEN
                  BEGIN
                     SELECT xchg_rate
                       INTO m_xchg_rate
                       FROM exchange_rate
                      WHERE xchg_base_cur = a_data (m_ctr).currency
                        AND xchg_conv_cur = m_to_convert_curr
                        AND tenant_name   = m_tenant
                        AND xchg_update_date = SYSDATE;
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        RAISE no_local_currency_found;
                  END;

                  m_priorityamountnum :=
                                a_data (m_ctr).priorityamountnum * m_xchg_rate;
               ELSE
                  m_priorityamountnum := a_data (m_ctr).priorityamountnum;
               END IF;

               IF a_data (m_ctr).transactiontype = 'C'
               THEN
                  m_total_bal :=
                               m_total_bal + a_data (m_ctr).priorityamountnum;
                  m_today_balance :=
                           m_today_balance + a_data (m_ctr).priorityamountnum;
               ELSIF a_data (m_ctr).transactiontype = 'D'
               THEN
                  m_total_bal :=
                               m_total_bal - a_data (m_ctr).priorityamountnum;
                  m_today_balance :=
                           m_today_balance - a_data (m_ctr).priorityamountnum;
               END IF;

               m_total_bal := NVL (m_stmt_closing_booked_balance, m_total_bal);
               m_close_bal := m_total_bal;
               a_data (m_ctr).stmt_closing_balance := m_total_bal;

               IF INSTR (m_total_bal, '.') = 0
               THEN
                  m_total_bal := m_total_bal || '.00';
               ELSE
                  m_total_bal :=
                        SUBSTR (m_total_bal, 1, INSTR (m_total_bal, '.') - 1)
                     || '.'
                     || RPAD (NVL (SUBSTR (m_total_bal,
                                           INSTR (m_total_bal, '.') + 1
                                          ),
                                   '0'
                                  ),
                              2,
                              '0'
                             );
               END IF;

               IF INSTR (m_open_bal, '.') = 0
               THEN
                  m_open_bal := m_open_bal || '.00';
               ELSE
                  m_open_bal :=
                        SUBSTR (m_open_bal, 1, INSTR (m_open_bal, '.') - 1)
                     || '.'
                     || RPAD (NVL (SUBSTR (m_open_bal,
                                           INSTR (m_open_bal, '.') + 1
                                          ),
                                   '0'
                                  ),
                              2,
                              '0'
                             );
               END IF;

               IF INSTR (m_close_bal, '.') = 0
               THEN
                  m_close_bal := m_close_bal || '.00';
               ELSE
                  m_close_bal :=
                        SUBSTR (m_close_bal, 1, INSTR (m_close_bal, '.') - 1)
                     || '.'
                     || RPAD (NVL (SUBSTR (m_close_bal,
                                           INSTR (m_close_bal, '.') + 1
                                          ),
                                   '0'
                                  ),
                              2,
                              '0'
                             );
               END IF;

               DBMS_OUTPUT.put_line ('msgdb_id  : ' || a_data (m_ctr).msgdb_id);
               DBMS_OUTPUT.put_line (   'priorityamountnum  : '
                                     || a_data (m_ctr).priorityamountnum
                                    );
               DBMS_OUTPUT.put_line ('after m_total_bal  : ' || m_total_bal);
               DBMS_OUTPUT.put_line ('after m_close_bal  : ' || m_close_bal);
               DBMS_OUTPUT.put_line ('after m_open_bal  : ' || m_open_bal);

                    IF m_update_balance
                    THEN

                        IF m_columnconfig_tdvalue = 'NOSTRO_ACCOUNT_NUMBER'
                        THEN
                            DBMS_OUTPUT.put_line('inside m_update_balance   m_columnconfig_tdvalue : ' || m_columnconfig_tdvalue);
                            SELECT  count(*)
                INTO    m_cnt
                            FROM    account_balance
                            WHERE   (account_number = a_data(m_ctr).nostro_account_number)
                            AND     institution_id  = a_data(m_ctr).institutionid
                            AND     entry_date         BETWEEN m_timestamp_beg AND m_timestamp_end
                            AND     baln_update_source  =   'CARRIED-FORWARD';

                        ELSE
          SELECT COUNT (*)
INTO m_cnt
                    FROM account_balance
                   WHERE (   account_number_enc =
                                             a_data (m_ctr).account_number_enc
                          OR account_number = a_data (m_ctr).account_number
                         )
                     AND institution_id = a_data (m_ctr).institutionid
                     AND entry_date BETWEEN m_timestamp_beg AND m_timestamp_end
                     AND (   baln_update_source = 'CARRIED-FORWARD'
                          OR baln_update_source IS NULL
                         );

            END IF;

                  DBMS_OUTPUT.put_line ('m_cnt : ' || m_cnt);

                  IF m_cnt = 0
                  THEN
                     IF m_statement_flag = 0
                     THEN
                        UPDATE account_balance
                           SET last_acnt_baln_record_flag = 'N'
                         WHERE (   account_number_enc =
                                             a_data (m_ctr).account_number_enc
                                OR account_number =
                                                 a_data (m_ctr).account_number
                               )
                           AND institution_id = a_data (m_ctr).institutionid
                           AND entry_date BETWEEN m_timestamp_beg
                                              AND m_timestamp_end;
                     END IF;

                     m_monthly_balance_flag :=
                        balance_period_flag
                                    ('M',
                                     TO_TIMESTAMP (a_data (m_ctr).prioritydate,
                                                   'YYYYMMDD'
                                                  )
                                    );
                     m_weekly_balance_flag :=
                        balance_period_flag
                                    ('W',
                                     TO_TIMESTAMP (a_data (m_ctr).prioritydate,
                                                   'YYYYMMDD'
                                                  )
                                    );

                     BEGIN
                        DBMS_OUTPUT.put_line
                                (   'iNSERTING --------------- m_open_bal : '
                                 || m_open_bal
                                );
                        DBMS_OUTPUT.put_line
                                (   'iNSERTING --------------- m_close_bal : '
                                 || m_close_bal
                                );
                        BEGIN
                        INSERT INTO account_balance
                                    (account_number,
                                     account_number_enc,
                                     entry_date,
                                     open_actual,
                                     close_actual,
                                     curr_actual_local_curr_bal,
                                     institution_id,
                                     monthly_balance_flag,
                                     weekly_balance_flag, baln_update_source,
                                     last_acnt_baln_record_flag,
                                     stmt_closing_booked_balance,
                                     bank_code, datakeyid
                                    )
                             VALUES (return_masked_info
                                        (m_prefix,
                                         a_data (m_ctr).institutionid,
                                         NVL
                                            (encrypt_decrypt_basedon_session_cntx
                                                (m_decrypt,
                                                 a_data (m_ctr).institutionid,
                                                 a_data (m_ctr).account_number_enc,
                                                 m_active_datakeyid
                                                ),
                                             a_data (m_ctr).account_number
                                            )
                                        ),
                                     a_data (m_ctr).account_number_enc,
                                     TO_TIMESTAMP ((a_data (m_ctr).prioritydate
                                 || ' 00:00:00.000'
                                ),
                                'YYYY-MM-DD HH24:MI:SS.FF3'
                               ),
                                     TO_NUMBER (m_open_bal, '999999999999.99'),
                                     TO_NUMBER (m_close_bal, '999999999999.99'),
                                     TO_NUMBER (m_close_bal, '999999999999.99'),
                                     a_data (m_ctr).institutionid,
                                     m_monthly_balance_flag,
                                     m_weekly_balance_flag, 'STATEMENT',
                                     CASE m_statement_flag
                                        WHEN 1
                                           THEN 'N'
                                        WHEN 0
                                           THEN 'Y'
                                     END,
                                     m_stmt_closing_booked_balance,
                                     m_bank_code, m_active_datakeyid
                                    );
                            EXCEPTION
                            WHEN dup_val_on_index
                            THEN
                             UPDATE account_balance
                        SET account_number =
                               return_masked_info
                                  (m_prefix,
                                   a_data (m_ctr).institutionid,
                                   NVL
                                      (encrypt_decrypt_basedon_session_cntx
                                             (m_decrypt,
                                              a_data (m_ctr).institutionid,
                                              a_data (m_ctr).account_number_enc,
                                              m_active_datakeyid
                                             ),
                                       a_data (m_ctr).account_number
                                      )
                                  ),
                            account_number_enc =
                                             a_data (m_ctr).account_number_enc,
                            entry_date =
                              TO_TIMESTAMP ((a_data (m_ctr).prioritydate
                                 || ' 00:00:00.000'
                                ),
                                'YYYY-MM-DD HH24:MI:SS.FF3'
                               ),
                            open_actual =
                                         TO_NUMBER (m_open_bal, '999999999999.99'),
                            close_actual =
                                        TO_NUMBER (m_close_bal, '999999999999.99'),
                            curr_actual_local_curr_bal =
                                        TO_NUMBER (m_close_bal, '999999999999.99'),
                            institution_id = a_data (m_ctr).institutionid,
                            monthly_balance_flag = m_monthly_balance_flag,
                            weekly_balance_flag = m_weekly_balance_flag,
                            baln_update_source = 'STATEMENT',
                            last_acnt_baln_record_flag =
                               CASE m_statement_flag
                                  WHEN 1
                                     THEN 'N'
                                  WHEN 0
                                     THEN 'Y'
                               END,
                            stmt_closing_booked_balance =
                                                 m_stmt_closing_booked_balance,
                            bank_code = m_bank_code,
                            datakeyid = m_active_datakeyid
                      WHERE (   account_number_enc =
                                             a_data (m_ctr).account_number_enc
                             OR account_number = a_data (m_ctr).account_number
                            )
                        AND institution_id = a_data (m_ctr).institutionid
                        AND entry_date BETWEEN m_timestamp_beg AND m_timestamp_end;
                        END;



                        a_prev_data := t_prev_data ();
                        a_prev_data.EXTEND;
                        a_prev_data (1).account_number :=
                                                 a_data (m_ctr).account_number;
                        a_prev_data (1).account_number_enc :=
                                             a_data (m_ctr).account_number_enc;
                        a_prev_data (1).entry_date :=
                           TO_TIMESTAMP ((a_data (m_ctr).prioritydate
                                 || ' 00:00:00.000'
                                ),
                                'YYYY-MM-DD HH24:MI:SS.FF3'
                               );
                        a_prev_data (1).open_actual := m_close_bal;
                        a_prev_data (1).close_actual := m_close_bal;
                        a_prev_data (1).curr_actual_local_curr_bal :=
                                                                   m_close_bal;
                        a_prev_data (1).institution_id :=
                                                  a_data (m_ctr).institutionid;
                        a_prev_data (1).baln_update_source :=
                                                             'CARRIED-FORWARD';
                        a_prev_data (1).last_acnt_baln_record_flag := 'Y';
                        a_prev_data (1).stmt_closing_booked_balance :=
                                                 m_stmt_closing_booked_balance;
                        a_prev_data (1).bank_code := m_bank_code;

                        SELECT NVL (MIN (entry_date), SYSDATE + 1)
                          INTO m_entry_date
                          FROM account_balance
                         WHERE (   account_number_enc =
                                            a_prev_data (1).account_number_enc
                                OR account_number =
                                                a_prev_data (1).account_number
                               )
                           AND institution_id = a_prev_data (1).institution_id
                           AND entry_date > a_prev_data (1).entry_date;

                        DBMS_OUTPUT.put_line ('m_entry_date : '
                                              || m_entry_date
                                             );
                        DBMS_OUTPUT.put_line
                                            (   'a_prev_data(1).entry_date : '
                                             || a_prev_data (1).entry_date
                                            );
                        m_no_of_days :=
                             TO_DATE (TO_CHAR (m_entry_date, 'YYYYMMDD'),
                                      'YYYYMMDD'
                                     )
                           - TO_DATE (TO_CHAR (a_prev_data (1).entry_date,
                                               'YYYYMMDD'
                                              ),
                                      'YYYYMMDD'
                                     );
                        m_no_of_days := m_no_of_days - 1;
                        DBMS_OUTPUT.put_line (   'After m_no_of_days : '
                                              || m_no_of_days
                                             );

                        FOR x IN 1 .. m_no_of_days
                        LOOP
                           BEGIN
                              a_prev_data (1).entry_date :=
                                 TO_TIMESTAMP
                                      (TO_CHAR (a_prev_data (1).entry_date + 1,
                                                'YYYYMMDD'
                                               ),
                                       'yyyymmddHH24:MI:SS'
                                      );
                              a_prev_data (1).monthly_balance_flag :=
                                 balance_period_flag
                                                    ('M',
                                                     a_prev_data (1).entry_date
                                                    );
                              --DECODE(a_prev_data(1).entry_date, TO_TIMESTAMP(TO_CHAR(SYSTIMESTAMP, 'YYYYMMDD'),'yyyymmddHH24:MI:SS'), 'Y', balance_period_flag('M',a_prev_data(1).entry_date));
                              a_prev_data (1).weekly_balance_flag :=
                                 balance_period_flag
                                                    ('W',
                                                     a_prev_data (1).entry_date
                                                    );
                              a_prev_data (1).datakeyid := m_active_datakeyid;

                              INSERT INTO account_balance
                                   VALUES a_prev_data (1);
                           EXCEPTION
                              WHEN OTHERS
                              THEN
                                 DBMS_OUTPUT.put_line
                                          (   'Record already present for : '
                                           || a_prev_data (1).account_number
                                          );
                           END;
                        END LOOP;

                        m_update_balance := FALSE;
                        m_action := 'INSERT';
--                            IF m_tenant = m_Tenant_list
--                            THEN
--                              m_audit_text     := 'Closing balance for Account Number '|| a_data(m_ctr).account_number_enc || ' is inserted';
--                            ELSE
                        m_audit_text :=
                              'Closing balance for Account Number '
                           || a_data (m_ctr).account_number
                           || ' is inserted';
--                            END IF;
                        DBMS_OUTPUT.put_line
                                     (   'Closing balance for Account Number '
                                      || a_data (m_ctr).account_number_enc
                                      || ' is inserted'
                                     );
                     EXCEPTION
                        WHEN OTHERS
                        THEN
                           DBMS_OUTPUT.put_line
                                         (   SQLCODE
                                          || SQLERRM
                                          || DBMS_UTILITY.format_error_backtrace
                                         );
                     END;
                  ELSE
                     UPDATE account_balance
                        SET account_number =
                               return_masked_info
                                  (m_prefix,
                                   a_data (m_ctr).institutionid,
                                   NVL
                                      (encrypt_decrypt_basedon_session_cntx
                                             (m_decrypt,
                                              a_data (m_ctr).institutionid,
                                              a_data (m_ctr).account_number_enc,
                                              m_active_datakeyid
                                             ),
                                       a_data (m_ctr).account_number
                                      )
                                  ),
                            account_number_enc =
                                             a_data (m_ctr).account_number_enc,
                            entry_date =
                              TO_TIMESTAMP ((a_data (m_ctr).prioritydate
                                 || ' 00:00:00.000'
                                ),
                                'YYYY-MM-DD HH24:MI:SS.FF3'
                               ),
                            open_actual =
                                         TO_NUMBER (m_open_bal, '999999999999.99'),
                            close_actual =
                                        TO_NUMBER (m_close_bal, '999999999999.99'),
                            curr_actual_local_curr_bal =
                                        TO_NUMBER (m_close_bal, '999999999999.99'),
                            institution_id = a_data (m_ctr).institutionid,
                            monthly_balance_flag = m_monthly_balance_flag,
                            weekly_balance_flag = m_weekly_balance_flag,
                            baln_update_source = 'STATEMENT',
                            last_acnt_baln_record_flag =
                               CASE m_statement_flag
                                  WHEN 1
                                     THEN 'N'
                                  WHEN 0
                                     THEN 'Y'
                               END,
                            stmt_closing_booked_balance =
                                                 m_stmt_closing_booked_balance,
                            bank_code = m_bank_code,
                            datakeyid = m_active_datakeyid
                      WHERE (   account_number_enc =
                                             a_data (m_ctr).account_number_enc
                             OR account_number = a_data (m_ctr).account_number
                            )
                        AND institution_id = a_data (m_ctr).institutionid
                        AND entry_date BETWEEN m_timestamp_beg AND m_timestamp_end;
                  END IF;

                  BEGIN
                     IF m_stmt_fwd_available_balance IS NOT NULL
                     THEN
                        n_string_count :=
                             LENGTH (m_stmt_fwd_available_balance)
                           - LENGTH (REPLACE (m_stmt_fwd_available_balance,
                                              '|',
                                              ''
                                             )
                                    )
                           + 1;
                        DBMS_OUTPUT.put_line (   'n_string_count '
                                              || n_string_count
                                             );

                        FOR i IN 1 .. n_string_count
                        LOOP
                           m_fwd_available_balance :=
                              getstringitemwithsep
                                               (m_stmt_fwd_available_balance,
                                                i,
                                                '|'
                                               );
                           DBMS_OUTPUT.put_line (   'm_fwd_available_bal '
                                                 || m_stmt_fwd_available_balance
                                                );
                           m_fwd_entry_date :=
                              TO_TIMESTAMP
                                 (TO_CHAR
                                     (TO_DATE
                                         (getstringitemwithsep
                                                     (m_fwd_available_balance,
                                                      1,
                                                      '='
                                                     ),
                                          'YYYYMMDD'
                                         ),
                                      'YYYYMMDD'
                                     ),
                                  'yyyymmddHH24:MI:SS'
                                 );
                           DBMS_OUTPUT.put_line (   'm_fwd_Entry_Date '
                                                 || m_fwd_entry_date
                                                );
                           --m_fwd_Entry_Date := TO_TIMESTAMP( ( TO_CHAR(getstringitemwithsep(m_fwd_available_bal, 1, '='), 'YYYY-MM-DD') || ' 00:00:00.000' ) , 'YYYY-MM-DD HH24:MI:SS.FF3');
                           m_fwd_balance :=
                              getstringitemwithsep (m_fwd_available_balance,
                                                    2,
                                                    '='
                                                   );
                           DBMS_OUTPUT.put_line (   'm_fwd_balance '
                                                 || m_fwd_balance
                                                );

                           SELECT COUNT (*)
                             INTO n_cnt
                             FROM account_balance
                            WHERE (   account_number_enc =
                                             a_data (m_ctr).account_number_enc
                                   OR account_number =
                                                 a_data (m_ctr).account_number
                                  )
                              AND institution_id =
                                                  a_data (m_ctr).institutionid
                              AND TRUNC (entry_date) =
                                                      TRUNC (m_fwd_entry_date);

                           BEGIN
                              SELECT stmt_closing_booked_balance
                                INTO m_close_bal
                                FROM account_balance
                               WHERE (   account_number_enc =
                                             a_data (m_ctr).account_number_enc
                                      OR account_number =
                                                 a_data (m_ctr).account_number
                                     )
                                 AND institution_id =
                                                  a_data (m_ctr).institutionid
                                 AND TRUNC (entry_date) =
                                                   TRUNC (m_fwd_entry_date)
                                                   - 1;
                           EXCEPTION
                              WHEN NO_DATA_FOUND
                              THEN
                                 m_close_bal := 0;
                                 DBMS_OUTPUT.put_line
                                    ('stmt_closing_booked_balance NOT AVAILABLE'
                                    );
                              WHEN OTHERS
                              THEN
                                 m_close_bal := 0;
                                 DBMS_OUTPUT.put_line
                                               ('ERROR IN CALCULTING BALANCE');
                           END;

                           DBMS_OUTPUT.put_line ('n_cnt ' || n_cnt);

                           IF n_cnt > 0
                           THEN
                              UPDATE account_balance
                                 SET stmt_closing_booked_balance =
                                                                 m_fwd_balance,
                                     open_actual = m_close_bal,
                                     close_actual = m_close_bal
                               WHERE (   account_number_enc =
                                             a_data (m_ctr).account_number_enc
                                      OR account_number =
                                                 a_data (m_ctr).account_number
                                     )
                                 AND institution_id =
                                                  a_data (m_ctr).institutionid
                                 AND TRUNC (entry_date) =
                                                      TRUNC (m_fwd_entry_date);

                              DBMS_OUTPUT.put_line ('1');
                           ELSE
--                                SELECT
--                                    open_actual,
--                                    close_actual
--                                INTO
--                                    m_open_bal,
--                                    m_close_bal
--                                FROM
--                                    account_balance
--                                WHERE
--                                    trunc(entry_date) = trunc(m_fwd_entry_date) - 1
--                                    AND institution_id = a_data(m_ctr).institutionid;
                              DBMS_OUTPUT.put_line ('m_open_bal');

                              INSERT INTO account_balance
                                          (account_number,
                                           account_number_enc,
                                           entry_date, open_actual,
                                           close_actual,
                                           curr_actual_local_curr_bal,
                                           institution_id,
                                           monthly_balance_flag,
                                           weekly_balance_flag,
                                           baln_update_source,
                                           last_acnt_baln_record_flag,
                                           stmt_closing_booked_balance,
                                           bank_code, datakeyid
                                          )
                                   VALUES (a_data (m_ctr).account_number,
                                           a_data (m_ctr).account_number_enc,
                                           m_fwd_entry_date, m_close_bal,
                                           m_close_bal,
                                           m_close_bal,
                                           a_data (m_ctr).institutionid,
                                           NULL,
                                           NULL,
                                           'CARRIED-FORWARD',
                                           CASE m_statement_flag
                                              WHEN 1
                                                 THEN 'N'
                                              WHEN 0
                                                 THEN 'Y'
                                           END,
                                           m_fwd_balance,
                                           m_bank_code, m_active_datakeyid
                                          );

                              DBMS_OUTPUT.put_line ('INSERTED 2: ');
                           END IF;
                        END LOOP;
                     END IF;
                  END;

--                        ELSE
--                            m_monthly_balance_flag  :=  balance_period_flag('M',TO_TIMESTAMP(a_data(m_ctr).prioritydate, 'YYYYMMDD'));
--                            m_weekly_balance_flag   :=  balance_period_flag('W',TO_TIMESTAMP(a_data(m_ctr).prioritydate, 'YYYYMMDD'));

                  --                            SELECT  count(*)
--                            INTO    m_cnt
--                            FROM    account_balance
--                            WHERE   account_number     = a_data(m_ctr).account_number
--                            AND     institution_id  = a_data(m_ctr).institutionid
--                            AND     entry_date         BETWEEN m_timestamp_beg AND m_timestamp_end
--                            AND     baln_update_source  =   'CARRIED-FORWARD';
--
--                            DBMS_OUTPUT.PUT_LINE('m_cnt : ' || m_cnt);
--
--                            IF m_cnt = 0
--                            THEN

                  --                                INSERT
--                                INTO account_balance
--                                (
--                                account_number,
--                                entry_date,
--                                open_actual,
--                                close_actual,
--                                curr_actual_local_curr_bal,
--                                institution_id,
--                                monthly_balance_flag,
--                                weekly_balance_flag,
--                                baln_update_source
--                                )
--                                VALUES
--                                (
--                                a_data(m_ctr).account_number,
--                                TO_TIMESTAMP(TO_DATE(a_data(m_ctr).prioritydate,'YYYYMMDD') || TO_CHAR(SYSDATE,'HH12:MI:SS AM')),
--                                TO_NUMBER(m_open_bal, '9999999999.99'),
--                                TO_NUMBER(m_close_bal, '9999999999.99'),
--                                TO_NUMBER(m_close_bal, '9999999999.99'),
--                                a_data(m_ctr).institutionid,
--                                m_monthly_balance_flag,
--                                m_weekly_balance_flag,
--                                'STATEMENT'
--                                );
--                            ELSE

                  --                                UPDATE     account_balance
--                                SET     open_actual                     = m_open_bal,
--                                        close_actual                    = m_close_bal,
--                                        curr_actual_local_curr_bal      = m_close_bal,
--                                        baln_update_source              = 'STATEMENT'
--                                WHERE   account_number                  = a_data(m_ctr).account_number
--                                AND     institution_id                  = a_data(m_ctr).institutionid
--                                AND     entry_date                         = TO_TIMESTAMP(TO_DATE(a_data(m_ctr).prioritydate,'YYYYMMDD'))
--                                AND     baln_update_source              = 'CARRIED-FORWARD';
--                            END IF;
                  DBMS_OUTPUT.put_line ('Third m_open_bal : ' || m_open_bal);
                  DBMS_OUTPUT.put_line ('Third m_close_bal : ' || m_close_bal);
                  DBMS_OUTPUT.put_line (   'm_statement_flag : '
                                        || m_statement_flag
                                       );

                  IF m_statement_flag = 0
                  THEN
                     IF  instr(m_tenant_list,m_tenant)>0
                     THEN
                        OPEN c_update_acbalance
                                           (a_data (m_ctr).institutionid,
                                            a_data (m_ctr).account_number_enc,
                                            NVL (m_fwd_entry_date,
                                                 m_timestamp_beg
                                                )
                                           );
                     ELSE
                        OPEN c_update_acbalance
                                               (a_data (m_ctr).institutionid,
                                                a_data (m_ctr).account_number,
                                                NVL (m_fwd_entry_date,
                                                     m_timestamp_beg
                                                    )
                                               );
                     END IF;

                     FETCH c_update_acbalance
                     BULK COLLECT INTO a_updt_data;

                     CLOSE c_update_acbalance;

                     u_ctr_beg := NVL (a_updt_data.FIRST, 0);
                     u_ctr_end := NVL (a_updt_data.LAST, 0);
                     DBMS_OUTPUT.put_line (   'a_updt_data.COUNT : '
                                           || a_updt_data.COUNT
                                          );

                     BEGIN
                        SELECT stmt_closing_booked_balance
                          INTO m_close_bal
                          FROM account_balance
                         WHERE (   account_number_enc =
                                             a_data (m_ctr).account_number_enc
                                OR account_number =
                                                 a_data (m_ctr).account_number
                               )
                           AND institution_id = a_data (m_ctr).institutionid
                           AND TRUNC (entry_date) =
                                  TRUNC (NVL (m_fwd_entry_date,
                                              m_timestamp_beg
                                             )
                                        );
                     EXCEPTION
                        WHEN NO_DATA_FOUND
                        THEN
                           m_close_bal := 0;
                           DBMS_OUTPUT.put_line
                                 ('stmt_closing_booked_balance NOT AVAILABLE');
                        WHEN OTHERS
                        THEN
                           m_close_bal := 0;
                           DBMS_OUTPUT.put_line
                                               ('ERROR IN CALCULTING BALANCE');
                     END;

                     IF u_ctr_end > 0
                     THEN
                        FOR u_cnt IN u_ctr_beg .. u_ctr_end
                        LOOP
                           IF a_updt_data (u_cnt).baln_update_source =
                                                                  'STATEMENT'
                           THEN
                              IF TO_CHAR (a_updt_data (u_cnt).entry_date,
                                          'YYYYMMDD'
                                         ) > a_data (m_ctr).prioritydate
                              THEN
                                 EXIT;
                              END IF;
                           ELSE
                              DBMS_OUTPUT.put_line
                                       (   'a_updt_data(u_cnt).entry_date : '
                                        || a_updt_data (u_cnt).entry_date
                                       );
                              DBMS_OUTPUT.put_line
                                    (   'UPDATE --------------- m_open_bal : '
                                     || m_open_bal
                                    );
                              DBMS_OUTPUT.put_line
                                   (   'UPDATE --------------- m_close_bal : '
                                    || m_close_bal
                                   );

                              UPDATE account_balance
                                 SET open_actual =
                                        DECODE (TO_CHAR (entry_date,
                                                         'YYYYMMDD'
                                                        ),
                                                a_data (m_ctr).prioritydate, m_open_bal,
                                                m_close_bal
                                               ),
                                     close_actual = m_close_bal,
                                     curr_actual_local_curr_bal = m_close_bal,
                                     stmt_closing_booked_balance = m_close_bal,
                                     baln_update_source =
                                        DECODE (TO_CHAR (entry_date,
                                                         'YYYYMMDD'
                                                        ),
                                                a_data (m_ctr).prioritydate, 'STATEMENT',
                                                baln_update_source
                                               )
                               WHERE (   account_number_enc =
                                            a_updt_data (u_cnt).account_number_enc
                                      OR account_number =
                                            a_updt_data (u_cnt).account_number
                                     )
                                 AND institution_id =
                                            a_updt_data (u_cnt).institution_id
                                 AND entry_date =
                                                a_updt_data (u_cnt).entry_date;
                           END IF;
                        END LOOP;
                     END IF;

                     m_update_balance := FALSE;
                     m_action := 'UPDATE';
--                    IF m_tenant = m_Tenant_list
--                    THEN
--                      m_audit_text     := 'Closing balance for Account Number '|| a_data(m_ctr).account_number_enc || ' is updated';
--                    ELSE
                     m_audit_text :=
                           'Closing balance for Account Number '
                        || a_data (m_ctr).account_number
                        || ' is updated';
--                    END IF;
                     DBMS_OUTPUT.put_line
                                     (   'Closing balance for Account Number '
                                      || a_data (m_ctr).account_number_enc
                                      || ' is updated as : '
                                      || m_close_bal
                                     );
                  END IF;

                  genaudit_insert_enchash_wrap (a_data (m_ctr).messageno,
                                                NULL,
                                                NULL,
                                                'EVNTSRVR',
                                                'MESSAGE',
                                                m_action,
                                                m_audit_text,
                                                a_data (m_ctr).institutionid,
                                                0
                                               );
                  DBMS_OUTPUT.put_line ('m_close_bal  : ' || m_close_bal);
                  m_total_bal := m_close_bal;
                  --m_open_bal := m_close_bal;
                  DBMS_OUTPUT.put_line ('Final m_open_bal : ' || m_open_bal);
               END IF;

               IF m_update_balance
               THEN
                  m_prev_account_number := 'X';
               ELSE
                  IF  instr(m_tenant_list,m_tenant)>0
                  THEN
                     m_prev_account_number :=
                                            a_data (m_ctr).account_number_enc;
                  ELSE
                     m_prev_account_number := a_data (m_ctr).account_number;
                  END IF;
               END IF;
            EXCEPTION
               WHEN no_local_currency_found
               THEN
                  DBMS_OUTPUT.put_line (   'NO_LOCAL_CURRENCY_FOUND for : '
                                        || m_institutionid
                                       );
                  a_data (m_ctr).process_id := 'ERROR';
                  m_error_transactions := TRUE;
                  genaudit_insert_enchash_wrap
                       (a_data (m_ctr).messageno,
                        NULL,
                        NULL,
                        'PELICAN',
                        'MESSAGE',
                        'UPDATE',
                           'Local currency configuration is not present for '
                        || a_data (m_ctr).messageno
                        || ' transaction of institutionid '
                        || m_institutionid
                        || ' Balance can not be calculated and added',
                        m_institutionid,
                        0
                       );
               WHEN OTHERS
               THEN
                  a_data (m_ctr).process_id := 'ERROR';
                  m_error_transactions := TRUE;
                  DBMS_OUTPUT.put_line ('upsert_account_balance Others issue');
                  DBMS_OUTPUT.put_line (   SQLCODE
                                        || SQLERRM
                                        || DBMS_UTILITY.format_error_backtrace
                                       );
                  genaudit_insert_enchash_wrap
                           (a_data (m_ctr).messageno,
                            NULL,
                            NULL,
                            'PELICAN',
                            'MESSAGE',
                            'UPDATE',
                               'upsert_account_balance : OTHERS Exception : '
                            || SQLCODE
                            || SQLERRM
                            || DBMS_UTILITY.format_error_backtrace,
                            m_institutionid,
                            0
                           );
            END;
         END LOOP;

         DBMS_OUTPUT.put_line (   'B4 BLIND UPDATE m_statement_flag : '
                               || m_statement_flag
                              );
         DBMS_OUTPUT.put_line (   'a_batch_id(b_ctr).account_number_enc : '
                               || a_batch_id (b_ctr).account_number
                              );
         DBMS_OUTPUT.put_line (   'a_batch_id(b_ctr).institutionid : '
                               || a_batch_id (b_ctr).institutionid
                              );
         DBMS_OUTPUT.put_line (   'a_batch_id(b_ctr).prioritydate : '
                               || a_batch_id (b_ctr).prioritydate
                              );

        m_tdvalue := NVL(TD_GET_VALUE(m_tdidcode_display_flag,m_tenant_name),'XXX');
        m_paramvalue  := NVL(Get_Institution_Param_Value(m_institutionid, m_path, m_tenant_name),'DEFAULT');
         IF m_statement_flag = 0
         THEN
            IF m_ctr_end > 0
            THEN
                IF INSTR(m_tdvalue , m_paramvalue)<=0
                THEN
               FORALL m_ctr IN m_ctr_beg .. m_ctr_end
                  UPDATE msgdb
                     SET display_flag = 'N'
                   WHERE (   account_number_enc =
                                             a_data (m_ctr).account_number_enc
                          OR account_number = a_data (m_ctr).account_number
                         )
                     AND institutionid = a_data (m_ctr).institutionid
                     AND prioritydate = a_data (m_ctr).prioritydate
                     AND transactiongroup = 'STMT'
                     AND msg_family = a_data (m_ctr).msg_family
                     AND display_flag = 'Y';
               --AND msgdb_id_batch     <>  a_batch_id(b_ctr).msgdb_id;
               DBMS_OUTPUT.put_line ('No. updated : ' || SQL%ROWCOUNT);
            END IF;
         END IF;
        END IF;
         IF m_ctr_end > 0
         THEN
            FORALL m_ctr IN m_ctr_beg .. m_ctr_end
               UPDATE msgdb
                  SET stmt_closing_balance =
                                           a_data (m_ctr).stmt_closing_balance,
                      display_flag =
                         CASE m_statement_flag
                            WHEN 1
                               THEN 'N'
                            WHEN 0
                               THEN 'Y'
                         END
                WHERE msgdb_id = a_data (m_ctr).msgdb_id                   --;
                  AND prioritydate IS NOT NULL
                  AND priorityamount IS NOT NULL;
         END IF;

         DBMS_OUTPUT.put_line (   'Balance calculated for : '
                               || a_batch_id (b_ctr).msgdb_id
                              );

         IF m_error_transactions
         THEN
            UPDATE msgdb
               SET process_id = 'ERROR'
             WHERE msgdb_id = a_batch_id (b_ctr).msgdb_id;

            m_audit_text := 'Error(s) encountered while balance calculation';
         ELSE
            m_audit_text := 'Balance calculation completed successfully';

            UPDATE msgdb
               SET process_id = 'CALCULATED'
             WHERE msgdb_id = a_batch_id (b_ctr).msgdb_id;
         END IF;

         genaudit_insert_enchash_wrap (a_batch_id (b_ctr).messageno,
                                       NULL,
                                       NULL,
                                       'EVNTSRVR',
                                       'BATCH',
                                       m_action,
                                       m_audit_text,
                                       a_batch_id (b_ctr).institutionid,
                                       0
                                      );
      EXCEPTION
         WHEN no_tran_found
         THEN
            UPDATE msgdb
               SET process_id = 'ERROR'
             WHERE msgdb_id = a_batch_id (b_ctr).msgdb_id;

            genaudit_insert_enchash_wrap
                               (m_batch_messageno,
                                NULL,
                                NULL,
                                'PELICAN',
                                'BATCH',
                                'UPDATE',
                                   'No transactions found '
                                || m_batch_messageno
                                || ' batch of institutionid '
                                || m_institutionid
                                || ' So Balance can not be calculated and added',
                                m_institutionid,
                                0
                               );
            DBMS_OUTPUT.put_line ('NO_TRAN_FOUND');
         WHEN OTHERS
         THEN
            ROLLBACK;
            DBMS_OUTPUT.put_line ('upsert_account_balance Others issue');
            DBMS_OUTPUT.put_line (   SQLCODE
                                  || SQLERRM
                                  || DBMS_UTILITY.format_error_backtrace
                                 );

            UPDATE msgdb
               SET process_id = 'ERROR'
             WHERE msgdb_id = m_batch_id;

            genaudit_insert_enchash_wrap
                           (m_batch_messageno,
                            NULL,
                            NULL,
                            'PELICAN',
                            'BATCH',
                            'UPDATE',
                               'upsert_account_balance : OTHERS Exception : '
                            || SQLCODE
                            || SQLERRM
                            || DBMS_UTILITY.format_error_backtrace,
                            m_institutionid,
                            0
                           );
      END;

      COMMIT;
   END LOOP;
EXCEPTION
   WHEN no_batches_found
   THEN
      DBMS_OUTPUT.put_line ('NO_BATCHES_FOUND');
END;