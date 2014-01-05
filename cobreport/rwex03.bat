000100 IDENTIFICATION DIVISION.
000200 PROGRAM-ID. RWEX03.
000300 AUTHOR. JAY MOSELEY.
000400 DATE-WRITTEN. APRIL, 2008.
000500 DATE-COMPILED.
000600
000700* ************************************************************* *
000800* REPORT WRITER EXAMPLE #3.                                     *
000900* ************************************************************* *
001000
001100 ENVIRONMENT DIVISION.
001200 CONFIGURATION SECTION.
001300 SOURCE-COMPUTER. IBM-370.
001400 OBJECT-COMPUTER. IBM-370.
001500
001600 INPUT-OUTPUT SECTION.
001700 FILE-CONTROL.
001800
001900     SELECT TRANSACTION-DATA
002000         ASSIGN TO EXTERNAL DATAIN
                         ORGANIZATION IS LINE SEQUENTIAL.
002100
002200     SELECT REPORT-FILE
002300         ASSIGN TO EXTERNAL LINE ADVANCING SYSPRINT.
002400
002500 DATA DIVISION.
002600 FILE SECTION.
002700
002800 FD  TRANSACTION-DATA
002900     LABEL RECORDS ARE OMITTED
003000     BLOCK CONTAINS 0 RECORDS
003100     RECORD CONTAINS 80 CHARACTERS
003200     DATA RECORD IS TRANSACTION-RECORD.
003300
003400 01  TRANSACTION-RECORD.
003500     03  TR-CUSTOMER-NUMBER      PIC 9(04).
003600     03  FILLER                  PIC X(01).
003700     03  TR-CUSTOMER-NAME        PIC X(16).
003800     03  FILLER                  PIC X(01).
003900     03  TR-ITEM-NUMBER          PIC 9(05).
004000     03  FILLER                  REDEFINES TR-ITEM-NUMBER.
004100         05  TR-ITEM-DEPARTMENT  PIC 9(01).
004200         05  FILLER              PIC 9(04).
004300     03  FILLER                  PIC X(01).
004400     03  TR-ITEM-COST            PIC 9(03)V99.
004500     03  FILLER                  PIC X(47).
004600
004700 FD  REPORT-FILE
004800     LABEL RECORDS ARE OMITTED
004900     REPORT IS CUSTOMER-REPORT.
005000
005100 WORKING-STORAGE SECTION.
005200 77  END-OF-FILE-SWITCH          PIC X(1)    VALUE 'N'.
005300     88  END-OF-FILE                         VALUE 'Y'.
005400
005500 01  DISCOUNT-TABLE.
005600     02  FILLER                  PIC 99      VALUE 05.
005700     02  FILLER                  PIC 99      VALUE 07.
005800     02  FILLER                  PIC 99      VALUE 10.
005900     02  FILLER                  PIC 99      VALUE 15.
006000     02  FILLER                  PIC 99      VALUE 06.
006100     02  FILLER                  PIC 99      VALUE 22.
006200     02  FILLER                  PIC 99      VALUE 12.
006300     02  FILLER                  PIC 99      VALUE 09.
006400     02  FILLER                  PIC 99      VALUE 20.
006500 01  FILLER                      REDEFINES DISCOUNT-TABLE.
006600     02  DISCOUNT                OCCURS 9 TIMES
006700                                 INDEXED BY DISCOUNT-IX
006800                                 PIC V99.
006900
007000 01  CALCULATED-FIELDS.
007100     03  WS-DISCOUNT-AMT         PIC 9(3)V99.
007200     03  WS-CHARGE-AMT           PIC 9(3)V99.
007300
007400 REPORT SECTION.
007500 RD  CUSTOMER-REPORT
007600     CONTROLS ARE FINAL, TR-CUSTOMER-NUMBER
007700     PAGE LIMIT IS 66 LINES
007800     HEADING 1
007900     FIRST DETAIL 5
008000     LAST DETAIL 58.
008100
008200 01  PAGE-HEAD-GROUP TYPE PAGE HEADING.
008300     02  LINE 1.
008400         03  COLUMN 27   PIC X(41) VALUE
008500             'C U S T O M E R  C H A R G E  R E P O R T'.
008600         03  COLUMN 90   PIC X(04) VALUE 'PAGE'.
008700         03  COLUMN 95   PIC ZZZZ9 SOURCE PAGE-COUNTER.
008800     02  LINE PLUS 2.
008900         03  COLUMN 01   PIC X(09) VALUE 'CUST. NO.'.
009000         03  COLUMN 15   PIC X(10) VALUE 'CUST. NAME'.
009100         03  COLUMN 30   PIC X(05) VALUE 'DEPT.'.
009200         03  COLUMN 39   PIC X(08) VALUE 'ITEM NO.'.
009300         03  COLUMN 51   PIC X(09) VALUE 'ITEM COST'.
009400         03  COLUMN 64   PIC X(08) VALUE 'DISCT. %'.
009500         03  COLUMN 76   PIC X(11) VALUE 'DISCT. AMT.'.
009600         03  COLUMN 91   PIC X(06) VALUE 'CHARGE'.
009700
009800 01  CHARGE-DETAIL TYPE DETAIL.
009900     02  LINE PLUS 1.
010000         03  COLUMN 03   PIC Z(04) SOURCE TR-CUSTOMER-NUMBER
010100                                          GROUP INDICATE.
010200         03  COLUMN 10   PIC X(16) SOURCE TR-CUSTOMER-NAME
010300                                          GROUP INDICATE.
010400         03  COLUMN 32   PIC 9(01) SOURCE TR-ITEM-DEPARTMENT.
010500         03  COLUMN 40   PIC 9(05) SOURCE TR-ITEM-NUMBER.
010600         03  COLUMN 51   PIC $$$$.99 SOURCE TR-ITEM-COST.
010700         03  COLUMN 67   PIC V99 SOURCE DISCOUNT (DISCOUNT-IX).
010800         03  COLUMN 69   PIC X(01) VALUE '%'.
010900         03  COLUMN 78   PIC $$$$.99 SOURCE WS-DISCOUNT-AMT.
011000         03  COLUMN 93   PIC $$$$.99 SOURCE WS-CHARGE-AMT.
011100
011200 01  CUSTOMER-TOTAL TYPE CONTROL FOOTING TR-CUSTOMER-NUMBER
011300     NEXT GROUP IS PLUS 2.
011400     02  LINE PLUS 1.
011500         03  COLUMN 50   PIC $$$$$.99 SUM TR-ITEM-COST.
011600         03  COLUMN 59   PIC X VALUE '*'.
011700         03  COLUMN 77   PIC $$$$$.99 SUM WS-DISCOUNT-AMT.
011800         03  COLUMN 86   PIC X VALUE '*'.
011900         03  COLUMN 92   PIC $$$$$.99 SUM WS-CHARGE-AMT.
012000         03  COLUMN 101  PIC X VALUE '*'.
012100
012200 01  FINAL-TOTAL TYPE CONTROL FOOTING FINAL.
012300     02  LINE PLUS 1.
012400         03  COLUMN 10   PIC X(12) VALUE 'GRAND TOTALS'.
012500         03  COLUMN 48   PIC $$$,$$$.99 SUM TR-ITEM-COST.
012600         03  COLUMN 59   PIC XX VALUE '**'.
012700         03  COLUMN 75   PIC $$$,$$$.99 SUM WS-DISCOUNT-AMT.
012800         03  COLUMN 86   PIC XX VALUE '**'.
012900         03  COLUMN 90   PIC $$$,$$$.99 SUM WS-CHARGE-AMT.
013000         03  COLUMN 101  PIC XX VALUE '**'.
013100
013200 PROCEDURE DIVISION.
013300
013400 000-INITIATE.
013500
013600     OPEN INPUT TRANSACTION-DATA,
013700          OUTPUT REPORT-FILE.
013800
013900     INITIATE CUSTOMER-REPORT.
014000
014100     READ TRANSACTION-DATA
014200         AT END
014300             MOVE 'Y' TO END-OF-FILE-SWITCH.
014400*    END-READ.
014500
014600     PERFORM 100-PROCESS-TRANSACTION-DATA THRU 199-EXIT
014700         UNTIL END-OF-FILE.
014800
014900 000-TERMINATE.
015000     TERMINATE CUSTOMER-REPORT.
015100
015200     CLOSE TRANSACTION-DATA,
015300         REPORT-FILE.
015400
015500     STOP RUN.
015600
015700 100-PROCESS-TRANSACTION-DATA.
015800     SET DISCOUNT-IX TO TR-ITEM-DEPARTMENT.
015900     COMPUTE WS-DISCOUNT-AMT ROUNDED =
016000         TR-ITEM-COST * DISCOUNT (DISCOUNT-IX).
016100     COMPUTE WS-CHARGE-AMT =
016200         TR-ITEM-COST - WS-DISCOUNT-AMT.
016300     GENERATE CHARGE-DETAIL.
016400     READ TRANSACTION-DATA
016500         AT END
016600             MOVE 'Y' TO END-OF-FILE-SWITCH.
016700*    END-READ.
016800
016900 199-EXIT.
017000     EXIT.
017100
017200