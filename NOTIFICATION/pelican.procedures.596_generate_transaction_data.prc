-- [9.06.00.006.02] [20230724] [PTRAMBAKE] [START]
SET DEFINE OFF;
create or replace PROCEDURE            generate_transaction_DATA
(
    p_clob          IN OUT CLOB,
    p_msgdb_id      IN msgdb.msgdb_id%TYPE,
    p_body_loop_part            IN OUT CLOB
)
AS
    m_new_row_data                      CLOB                                    := EMPTY_CLOB();
    M_BODY_POSITION_START               NUMBER;
    M_BODY_POSITION_END                 NUMBER;
    M_HEADER                            CLOB;
    M_BODY                              CLOB;
    m_footer                            CLOB;
    m_body_loop                         CLOB;
    m_body_loop_part                    CLOB;
    m_body_to_append                    CLOB;
    m_queueid                           QUEUE.queuedesc%TYPE                    := NULL;
    m_messageno                         MSGDB.messageno%TYPE                    := NULL;
    m_messageclasstype                  MSGDB.messageclasstype%TYPE             := NULL;
    m_institutionid                     MSGDB.institutionid%TYPE                := NULL;
    m_valuedate                         MSGDB.prioritydate%TYPE                 := NULL;
    m_transrefno                        MSGDB.transrefno%TYPE                   := NULL;
    m_inputdatetime                     MSGDB.inputdatetime%TYPE                := NULL;
    m_priorityamountnum                 MSGDB.priorityamountnum%TYPE            := NULL;
    m_account_dr                        MSGDB.ACCOUNT_DR%TYPE                   := NULL;
    m_account_cr                        MSGDB.ACCOUNT_CR%TYPE                   := NULL;

BEGIN
    --m_body_loop_part    := '<tr><td style="color: #333333; padding-top: 10px; padding-bottom: 10px; text-align: center; word-wrap: break-word; width: 10%;">$queue</td><td style="color: #333333; padding-top: 10px; padding-bottom: 10px; text-align: center; word-wrap: break-word; width: 10%;">$messageno</td><td style="color: #333333; padding-top: 10px; padding-bottom: 10px; text-align: center; word-wrap: break-word; width: 10%;">$messageclasstype</td><td style="color: #333333; padding-top: 10px; padding-bottom: 10px; text-align: center; word-wrap: break-word; width: 10%;">$institutionid</td><td style="color: #333333; padding-top: 10px; padding-bottom: 10px; text-align: center; word-wrap: break-word; width: 10%;">$valuedate</td><td style="color: #333333; padding-top: 10px; padding-bottom: 10px; text-align: center; word-wrap: break-word; width: 10%;">$referenceno</td><td style="color: #333333; padding-top: 10px; padding-bottom: 10px; text-align: center; word-wrap: break-word; width: 10%;">$inputdatetime</td><td style="color: #333333; padding-top: 10px; padding-bottom: 10px; text-align: center; word-wrap: break-word; width: 10%;">$amount</td><td style="color: #333333; padding-top: 10px; padding-bottom: 10px; text-align: center; word-wrap: break-word; width: 10%;">$Ordering amount</td><td style="color: #333333; padding-top: 10px; padding-bottom: 10px; text-align: center; word-wrap: break-word; width: 10%;">$Receiving amount</td></tr>';

    --m_body_loop_part    := '<tr><td style="color: #333333; padding-top: 10px; padding-bottom: 10px; text-align: center; word-wrap: break-word; width: 10%;">$queue</td><td style="color: #333333; padding-top: 10px; padding-bottom: 10px; text-align: center; word-wrap: break-word; width: 10%;">$messageno</td></tr>';
    --m_body_loop_part    := '<tr><td style="color: #333333; padding-top: 10px; padding-bottom: 10px; text-align: center; word-wrap: break-word; width: 10%;">$queue</td><td style="color: #333333; padding-top: 10px; padding-bottom: 10px; text-align: center; word-wrap: break-word; width: 10%;">$messageno</td><td style="color: #333333; padding-top: 10px; padding-bottom: 10px; text-align: center; word-wrap: break-word; width: 10%;">$messageclasstype</td><td style="color: #333333; padding-top: 10px; padding-bottom: 10px; text-align: center; word-wrap: break-word; width: 10%;">$institutionid</td><td style="color: #333333; padding-top: 10px; padding-bottom: 10px; text-align: center; word-wrap: break-word; width: 10%;">$referenceno</td><td style="color: #333333; padding-top: 10px; padding-bottom: 10px; text-align: center; word-wrap: break-word; width: 10%;">$inputdatetime</td><td style="color: #333333; padding-top: 10px; padding-bottom: 10px; text-align: center; word-wrap: break-word; width: 10%;">$amount</td><td style="color: #333333; padding-top: 10px; padding-bottom: 10px; text-align: center; word-wrap: break-word; width: 10%;">$Ordering amount</td><td style="color: #333333; padding-top: 10px; padding-bottom: 10px; text-align: center; word-wrap: break-word; width: 10%;">$Receiving amount</td></tr>';
        --m_body_loop_part    := '<tr><td style="color: #333333; padding: 10px; text-align: center; word-wrap: break-word; width: 10%;">$queue</td><td style="color: #333333; padding: 5px; text-align: center; word-wrap: break-word; width: 10%;">$messageno</td><td style="color: #333333; padding: 5px; text-align: center; word-wrap: break-word; width: 10%;">$messageclasstype</td><td style="color: #333333; padding: 5px; text-align: center; word-wrap: break-word; width: 10%;">$institutionid</td><td style="color: #333333; padding: 5px; text-align: center; word-wrap: break-word; width: 10%;">$referenceno</td><td style="color: #333333; padding: 5px; text-align: center; word-wrap: break-word; width: 10%;">$inputdatetime</td><td style="color: #333333; padding: 5px; text-align: center; word-wrap: break-word; width: 10%;">$amount</td><td style="color: #333333; padding: 5px; text-align: center; word-wrap: break-word; width: 10%;">$Ordering amount</td><td style="color: #333333; padding: 5px; text-align: center; word-wrap: break-word; width: 10%;">$Receiving amount</td></tr>';
  
    
    m_body_loop_part    := '<tr><td style="border: 1px solid #87CEFA; color: #333333; padding: 10px; text-align: center; word-wrap: break-word; width: 10%;">$queue</td><td style="border: 1px solid #87CEFA; color: #333333; padding: 5px; text-align: center; word-wrap: break-word; width: 10%;">$messageno</td><td style="border: 1px solid #87CEFA; color: #333333; padding: 5px; text-align: center; word-wrap: break-word; width: 10%;">$messageclasstype</td><td style="border: 1px solid #87CEFA; color: #333333; padding: 5px; text-align: center; word-wrap: break-word; width: 10%;">$institutionid</td><td style="border: 1px solid #87CEFA; color: #333333; padding: 5px; text-align: center; word-wrap: break-word; width: 10%;">$valuedate</td><td style="border: 1px solid #87CEFA; color: #333333; padding: 5px; text-align: center; word-wrap: break-word; width: 10%;">$referenceno</td><td style="border: 1px solid #87CEFA; color: #333333; padding: 5px; text-align: center; word-wrap: break-word; width: 10%;">$inputdatetime</td><td style="border: 1px solid #87CEFA; color: #333333; padding: 5px; text-align: center; word-wrap: break-word; width: 10%;">$amount</td><td style="border: 1px solid #87CEFA; color: #333333; padding: 5px; text-align: center; word-wrap: break-word; width: 10%;">$Ordering amount</td><td style="border: 1px solid #87CEFA; color: #333333; padding: 5px; text-align: center; word-wrap: break-word; width: 10%;">$Receiving amount</td></tr>';
    m_body_position_start := INSTR(p_clob, '<tbody>');
 --   dbms_output.put_line('---p_clob--- : ' || p_clob);

    m_body_position_end     := INSTR(p_clob, '</tbody>')+8;
   --dbms_output.put_line('M_BODY_POSITION_END : ' || M_BODY_POSITION_END);

    m_header := SUBSTR(p_clob, 1, m_body_position_start-1);
  -- dbms_output.put_line('M_HEADER : ' || M_HEADER);

   -- m_body    := SUBSTR(p_clob, m_body_position_start-1, ((m_body_position_end)-m_body_position_start)-1);
  --  dbms_output.put_line('M_BODY : ' || M_BODY);

    m_footer    := SUBSTR(p_clob,m_body_position_end);
   -- dbms_output.put_line('m_footer : ' || m_footer);

    SELECT  DISTINCT(q.ALIASID),
            m.messageno,
            m.messageclasstype,
            m.institutionid,
            m.prioritydate,
            m.transrefno,
            m.inputdatetime,
            m.priorityamountnum,
            m.account_dr,
            m.account_cr
    INTO    m_queueid,
            m_messageno,
            m_messageclasstype,
            m_institutionid,
            m_valuedate,
            m_transrefno,
            m_inputdatetime,
            m_priorityamountnum,
            m_account_dr,
            m_account_cr
    FROM    MSGDB m, QUEUE q
    WHERE   m.MSGDB_ID = p_msgdb_id
    AND     m.queueid = q.queueid
    AND    m.institutionid = q.institutionid;

    m_body_loop_part  := REPLACE(m_body_loop_part, '$queue', m_queueid);
    m_body_loop_part  := REPLACE(m_body_loop_part, '$messageno',m_messageno);
    m_body_loop_part  := REPLACE(m_body_loop_part, '$messageclasstype',m_messageclasstype);
    m_body_loop_part  := REPLACE(m_body_loop_part, '$institutionid', m_institutionid);
    --m_body_loop_part  := REPLACE(m_body_loop_part, '$valuedate', m_valuedate);
    m_body_loop_part  := REPLACE(m_body_loop_part, '$valuedate', TO_CHAR(m_inputdatetime, 'DD MON YYYY'));
    m_body_loop_part  := REPLACE(m_body_loop_part, '$referenceno', m_transrefno);
    m_body_loop_part  := REPLACE(m_body_loop_part, '$inputdatetime', TO_CHAR(m_inputdatetime, 'DD MON YYYY'));
    m_body_loop_part  := REPLACE(m_body_loop_part, '$amount', m_priorityamountnum);
    m_body_loop_part  := REPLACE(m_body_loop_part, '$Ordering amount', m_ACCOUNT_DR);
    m_body_loop_part  := REPLACE(m_body_loop_part, '$Receiving amount', m_ACCOUNT_CR);

    p_body_loop_part := p_body_loop_part || m_body_loop_part;
  --  dbms_output.put_line('m_body_loop_part : ' || m_body_loop_part);

    p_clob := m_header || '<tbody>' || p_body_loop_part || '</tbody>' || m_footer;
  --  dbms_output.put_line('p_clob 3: ' || p_clob);

END;
/
-- [9.06.00.006.02] [20230724] [PTRAMBAKE] [END]
EXIT;