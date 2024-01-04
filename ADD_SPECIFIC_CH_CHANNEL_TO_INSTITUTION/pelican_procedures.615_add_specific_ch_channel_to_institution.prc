-- [9.06.00.006.08] [20230907] [PTRAMBAKE] [START]
create or replace PROCEDURE ADD_SPECIFIC_CH_CHANNEL_TO_INSTITUTION
(
p_channel_id IN ch_channel.ch_channel_id%TYPE
)
AS
              TYPE t_ch_channel IS TABLE OF CH_CHANNEL%ROWTYPE;

              a_ch_channel    t_ch_channel    := t_ch_channel();

              CURSOR              c1(c_institutionid IN institutionmaster.institutionid%TYPE)
              IS
              SELECT  *
              FROM    ch_channel
              WHERE   ch_institutionid = c_institutionid
              AND     ch_channel_id = p_channel_id;
     

              m_concentrator_id    INSTITUTIONMASTER.institutionid%TYPE    := NULL;

              CURSOR c2
              IS
              SELECT  institutionid
              FROM    institutionmaster
              WHERE   concentrator = 'N';

              m_ctr_beg    NUMBER     := 0;
              m_ctr_end    NUMBER    := 0;

BEGIN
              m_concentrator_id := mi_get_concentratorid();

              IF m_concentrator_id IS NOT NULL 
              THEN
                  OPEN               c1(m_concentrator_id);
                  FETCH             c1 BULK COLLECT INTO a_ch_channel;
                  CLOSE              c1;

                  m_ctr_beg := NVL(a_ch_channel.FIRST,0);
                  m_ctr_end := NVL(a_ch_channel.LAST,0);
                   

                  FOR rec2 IN c2
                  LOOP

                      FOR ctr IN m_ctr_beg..m_ctr_end
                      LOOP

                          a_ch_channel(ctr).ch_institutionid := rec2.institutionid;

                          BEGIN
                            INSERT INTO ch_channel VALUES a_ch_channel(ctr);
                    
                            Genaudit_Insert_Enchash_Wrap(NULL,
                                               NULL,
                                               NULL,
                                               'PELICAN',
                                               'MESSAGE',
                                               'INSERT',
                                               'Channel '|| p_channel_id || ' copied for institition ' || rec2.institutionid || ' from concentrator institutionid',
                                               rec2.institutionid,
                                               0
                                               );

                          EXCEPTION
                              WHEN DUP_VAL_ON_INDEX
                              THEN
                         NULL;
                WHEN OTHERS
                    THEN
                         Genaudit_Insert_Enchash_Wrap(NULL,
                                               NULL,
                                               NULL,
                                               'PELICAN',
                                               'MESSAGE',
                                               'ERROR',
                                               'OTHERS '|| SQLCODE|| SQLERRM|| DBMS_UTILITY.format_error_backtrace,
                                               rec2.institutionid,
                                               0
                                               );
                END;
                      END LOOP;
                      COMMIT;
                  END LOOP;
              END IF;
    
EXCEPTION
    WHEN OTHERS
    THEN
           Genaudit_Insert_Enchash_Wrap(NULL,
               NULL,
               NULL,
               'PELICAN',
               'MESSAGE',
               'ERROR',
               'OTHERS '|| SQLCODE|| SQLERRM|| DBMS_UTILITY.format_error_backtrace,
               m_concentrator_id,
               0
               );        
                                                                                                                                                                  DBMS_OUTPUT.PUT_LINE ('OTHERS...'|| SQLCODE|| SQLERRM|| DBMS_UTILITY.format_error_backtrace);

END;
/

-- [9.06.00.006.08] [20230907] [PTRAMBAKE] [END]
COMMIT;
EXIT;