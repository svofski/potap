100 CLEAR1000,&HD8FF
    :KEYOFF
    :SCREEN1,2,0
    :COLOR 2,1,1
    :WIDTH 32
    :DEFINT A-Y
110 GOSUB 2200
    :GOSUB 1960
    :HS=2000
120 DIM FR(5),M(2),MX(2),MY(2):
    FR(1)=1:      ' ценность айтемов
    FR(2)=3:
    FR(3)=5:
    FR(4)=8:
    BN=RND(-TIME)

' завставка
130 SC=0:
    RO=0:
    RE=100:
    K1=0:
    K2=1:
    SS=2000:
    P1=1:
    P2=2:
    RESTORE 1360 ' первый уровень
140 CLS:
    LOCATE0 ,23
150 PRINT"   ›››  ›› › ››››  ›› › ›››"
160 PRINT"   ›› › ›› ›  ››   ›› › ›› ›"
170 PRINT"   ›› › ›› ›  ››   ›› › ›› ›"
180 PRINT"   ›››  ›› ›  ››   ›› › ›››"
190 PRINT"   ››    ››   ››    ››  ››"
200 FOR I=1 TO 10:LOCATE 0,23:PRINT:NEXT
210 LOCATE 8,17:PRINT"PUSH SPACE KEY":
    LOCATE 2,20:PRINT"MSX MAGAZINE & NEMOSOFT,1987"
220 LOCATE 10,2:PRINTUSING"HI #####0";HS
230 IF STRIG(0) OR STRIG(1) THEN 1270 ELSE 230 ' циклимся пока не нажата кнопа

' на одну времянную бусинку меньше
235 LOCATE21-T\20,23:PRINT" ";:RETURN

240 ' обработка Потапа (sub)
250 IF STRIG(0) OR STRIG(1) THEN 
      ON JU GOTO 710,760 ' all return to 280
' ju=0 or no trigger: начинаем падение
260 Y = Y + 1:
    V = 6144 + X + Y * 32:       ' $1800 -- top of name table
    Z = 0:
    Z = Z - (VPEEK(V+32)>&H76):   ' под нами или под нами справа пол?
    Z = Z - (VPEEK(V+33)>&H76)
270 IF Z THEN 
        Y = Y - 1:                ' пол, ниже пола не упасть, вернули Y
        JU = 1:                   ' жумп = 1, почему?
        PW = 0                    ' прыжковый таймер
    ELSE
        JU = 0
280 A=STICK(0) OR STICK(1)
290 ON A GOTO 300,300,450,450,520,490,490,300 ' UP, UP+RIGHT, RIGHT, DOWN+RIGHT, DOWN, DOWN+LEFT, LEFT, UP+LEFT

'joy up (default no-action)
300 C3=3
' рисуем спрайт: RL - куда смотрит C3 - фаза ходьбы
310 PUT SPRITE 0,(X*8,Y*8-1),15,RL*6+C3*2-1:  ' потап - белый
    PUT SPRITE 1,(X*8,Y*8-1),14,RL*6+C3*2     ' потап - серый
320 POKE &HDA00,117:
    G$(P1)=USR2(G$(P1))       ' анимация огонька: загружаем тайл G$(1/2)
330 V=6144+X+Y*32:            ' тайл прямо где Потап
    Z=0:
    Z=Z-(VPEEK(V)>&H74):      ' +1 впечатались в кирпич или еще какого врага?
    Z=Z-(VPEEK(V+1)>&H74):    ' +1 если справа   
    Z=Z-(VPEEK(V+32)>&H74):   ' +1 если под нами
    Z=Z-(VPEEK(V+33)>&H74)    ' +1 если на юго-востоке?
340 IF Z THEN 790             ' бо-бо, жизнь -1

350 T=T+1:                    ' таймер
    IF T MOD 20 = 0 THEN
      GOSUB 235:              ' тик-так на один меньше
      ON T\280 GOTO 690       ' make haste

360 Z=VPEEK(V+32):
    IF Z < &H6E THEN RETURN   ' не вкусняшка и не зло

370 PLAY"T255O5V10C+32V8D32":
    ON Z-&H6D GOTO 390, 390, 390, 390, 400, 410, 420
    ' 6e,6f,70,71: -> 390 ? вишенка, яблочко, ананасик, виноградик
    ' 72:          -> 400 бусинка
    ' 73:          -> 410 перстень (жизнь)
    ' 74:          -> 420 выход

' враги -- это вообще основной цикл, 240 -- обработка потапа
380 FOR I=1 TO 2:
        ON M(I) GOSUB 
            890,    ' капля вправо
            930,    ' капля влево
            970,    ' крыска вверх
            1010,   ' крыска вниз
            1050,
            1090,
            1130,
            1170,
            1210,
            1240:
        GOSUB 240:
    NEXT:
    SWAP P1,P2:
    GOTO 380

' съедаем вкусняшку
390 SC=SC+FR(Z-&H6D)*10:
    GOSUB 630: 'printscore
    LOCATE X,Y:PRINT A$(1):
    GOTO 240

' нашлась бусинка-ключ
400 SC=SC+100:
    CL=CL+1: ' cles
    LOCATE 23+2*CL,23:PRINT"rm";: ' напечатали бусинку в кармане
    GOSUB 630: 'printscore
    LOCATE X,Y:PRINT A$(1):
    GOTO 240

' Потап++ (перстень)
410 RE=RE+1:
    GOSUB 640:   ' печатаем клонв
    LOCATE X,Y:PRINT A$(1): ' стираем тайл перстня
    GOTO 240

' выход: меняем время на бонусы и переходим к следующему уровню
420 PUT SPRITE 0,(X*8,Y*8),15,13
430 PUT SPRITE 1,(X*8,Y*8),14,14
433 IF PLAY(0) THEN 433
435 T=T+1:
    IF T MOD 20=0 THEN PLAY"O6V9C32","O5V7C32":
        GOSUB 235:    ' убираем бусинки
        SC=SC+10:     ' и превращаем их в бонус
        GOSUB 630:    ' printscore
        ON T\280 GOTO 1270
440 GOTO 435

'joy right
450 X=X+1:
    RL=0:             ' RL = Right/Left ориентация спрайта Потапа
    V=6144+X+Y*32:
    Z=0:
    Z=Z-(VPEEK(V+1)>&H76):
    Z=Z-(VPEEK(V+33)>&H76)
460 IF Z THEN X=X-1
470 SWAP K1,K2:         ' tail of joy left
    ON K1 GOTO 300      ' - if K1=1 C3=3
480 C3=P1:
    GOTO 310

'joy left
490 X=X-1:
    RL=1:             ' RL = Right/Left ориентация спрайта Потапа
    V=6144+X+Y*32:
    Z=0:
    Z=Z-(VPEEK(V)>&H76):
    Z=Z-(VPEEK(V+32)>&H76)
500 IF Z THEN X=X+1
510 GOTO 470  ' mid joy right

'joy down
520 V=6144+X+Y*32
530 IF VPEEK(V+64)=&H7E THEN 590  ' [?]
540 IF VPEEK(V+64)=&H7D THEN 620  ' секретный кирпич
550 ON CL GOTO 560,560:
    GOTO 300 'joy up
560 IF VPEEK(V+64)<>&H79 THEN 300 'joy up если не замочек

' вложили пупочку в дырочку
570 PLAY"S1M2000T150O7C32":
    LOCATE X,Y+2:PRINT"{|":CL=CL-1: ' напечатали пупочку в дырочке, уменьшили cles
    LOCATE 25+2*CL,23:PRINT"  ";:   ' стерли пупочку в кармане
    K=K+1:
    IF K<INT(RO/10)+1 THEN 
      300 'joy up
    ELSE 
      LOCATE EX,EY:PRINT A$(9):     ' печатаем выход и играем музон
      PLAY"T150O3L4V12EV6EV3E"
580 FOR I=1 TO 40:
      PUT SPRITE 2,(EX*8,EY*8),7,15: ' мерцаем спрайтом выхода
      PUT SPRITE 2,(EX*8,EY*8),4,15:
    NEXT:
    GOTO 300 'joy up

' открываем [?] под Потапом
590 LOCATE X,Y+2:
    BN=INT(RND(1)*5)    ' 0..4 inclusive
600 IF BN=4 THEN
      IF INT(RND(1)*2)=1 THEN 590 ' пока не выберем годную вкусняшку
610 PRINT A$(10+BN):
    GOTO 300 'joy up

' открываем секретный кирпич под Потапом, превращаем его в [?]
620 LOCATE X,Y+2:PRINT A$(4):
    GOTO 300 'joy up

'printscore
630 LOCATE1,22:PRINTUSING"SCORE #####0";SC:
    IF SC>SS-1 THEN
        RE=RE+1:        ' Потап++
        GOSUB 640:      ' обновляем изображение оставшихся клонов
        SS=SS+2000:     ' счет до следующего клона
        RETURN
    ELSE
        RETURN

640 PLAY"T250O5V12D32V9E32V6E32"
' печатаем живых Потапов
650 IF RE>6 THEN RR=6 ELSE RR=RE
660 LOCATE 25,22:PRINT STRING$(RR,CHR$(&H8A)):
    RETURN

' printstats
670 LOCATE 15,22:PRINT USING"ROUND ##";RO:PRINT"  TIME ";STRING$(NT,"›");
680 RETURN

' make haste: dispatch злое солнышко
690 T=120:
    NT=7:
    GOSUB 670:                          ' printstats
    BN=INT(RND(1)*4)+10:
    LOCATE MX(1),MY(1):PRINT A$(BN):    ' превратить врага 1 во фрукт
    LOCATE MX(2),MY(2):PRINT A$(BN):    ' превратить врага 2 во фрукт
    MX(1)=X:
    MY(1)=35:                           ' солнышко начинается в (X,35)
    LOCATE10,0:PRINT" HURRY UP ! "
700 PLAY"M600T180S8O7C2","M600T180S8O5C2":
    M(1)=9:
    M(2)=10:
    GOTO 360

'ju=1
710 Y=Y-1:
    V=6144+X+Y*32:
    Z=0
720 Z=Z-(VPEEK(V)>&H76):
    Z=Z-(VPEEK(V+1)>&H76)
730 IF Z THEN 
        JU=0:
        PW=0:
        Y=Y+1:
        GOTO 280

740 PW=PW+1:            ' время в прыжке
    IF PW>3 THEN
        PW=0:
        JU=2
750 GOTO 280

'ju=2  PW = время в прыжке
760 PW=PW+1:
    IF PW>2 THEN
      PW=0:
      JU=0
770 GOTO 280

' спрятать все спрайты
780 FOR I=0 TO 4:
      PUT SPRITE I,(0,0),0:
    NEXT:
    RETURN

' Потапу бо-бо, анимация как он падает вниз, вычитаем жизнь, уровень заново
790 PLAY"T250O5V11D16","T250O4V9D16"
800 I=Y*8-36:
    Z=X*8
810 FOR J=-4 TO 30:
      FOR A=0 TO 50:NEXT A
820   PUT SPRITE 0,(Z,I+J^2),15,13:
      PUT SPRITE 1,(Z,I+J^2),14,14
830   IF I+J^2 < 200 THEN NEXT
840   GOSUB 780: ' спрятать спрайты
      CL=0:            ' ключей = 0
      RE=RE-1:         ' на 1 жизнь старше
      IF RE<0 THEN 860 ' Потап всё, игра окончена
850   GOTO 1290        ' начать уровень сначала

860 CLS:
    LOCATE10,10:PRINT"лпоег йзтщ" ' ~ этаоин шрдлу
870 IF SC>HS THEN HS=SC           ' новый хайскор
880 FOR I=1 TO 4000:NEXT I: GOTO 130 ' задержка почета и переход на заставку

' мозги капельки
' SUB M(I) = 1, капелька(I) вправо
890  MX(I)=MX(I)+1:
     V=6144+MX(I)+MY(I)*32
900  Z=0:
     Z=Z-(VPEEK(V+1)<>&H20):
     Z=Z-(VPEEK(V+33)<>&H20)
910  IF Z THEN                  ' дальше нельзя: стена или предмет/затычка
        MX(I)=MX(I)-1:          ' ушли с кирипича
        M(I)=2:                 ' следующее направление
        RETURN
     ' else
920     LOCATE MX(I)-1,MY(I): PRINT A$(1):  ' пустота в старой клетке
        LOCATEMX(I),MY(I): PRINT A$(20):    ' капелька вправо на новом месте
        RETURN

' мозги капельки
' SUB M(I) = 2, капелька(I) влево
930  MX(I)=MX(I)-1:
     V=6144+MX(I)+MY(I)*32
940  Z=0:
     Z=Z-(VPEEK(V)<>&H20):
     Z=Z-(VPEEK(V+32)<>&H20)
950  IF Z THEN MX(I)=MX(I)+1:
         M(I)=1:
         RETURN
     ' else
960     LOCATE MX(I)+1,MY(I): PRINT A$(1):  ' пусто в старую клетку
        LOCATE MX(I),MY(I): PRINT A$(19):   ' капелька влево на новом месте
        RETURN

' мозги крыски
' SUB M(I) = 3, крыска(I) вверх
970  MY(I)=MY(I)-1:
     V=6144+MX(I)+MY(I)*32
980  Z=0:
     Z=Z-(VPEEK(V)<>&H20):
     Z=Z-(VPEEK(V+1)<>&H20)
990  IF Z THEN MY(I)=MY(I)+1:
        M(I)=4:                   ' следующий стейт -> 4: крыска вниз
        RETURN
     ' else
1000    LOCATE MX(I),MY(I)+1:
        PRINT A$(1):
        LOCATE MX(I),MY(I):
        PRINT A$(16+P1):
        RETURN

' мозги крыски
' SUB M(I) = 4, крыска(I) вниз
1010 MY(I)=MY(I)+1:
     V=6144+MX(I)+MY(I)*32
1020 Z=0:Z=Z-(VPEEK(V+32)<>&H20):Z=Z-(VPEEK(V+33)<>&H20)
1030 IF Z THEN
        MY(I)=MY(I)-1:
        M(I)=3:                   ' -> 3: крыска вверх
        RETURN
1040 LOCATE MX(I),MY(I)-1:PRINT A$(1):
     LOCATEMX(I),MY(I):PRINT A$(17):
     RETURN

' мозги лимона
' M(I) = 5, лимон(I) вправо
1050 MX(I)=MX(I)+1:V=6144+MX(I)+MY(I)*32
1060 Z=0:Z=Z-(VPEEK(V+1)<>&H20):Z=Z-(VPEEK(V+33)<>&H20)
1070 IF Z THEN
        MX(I)=MX(I)-1:
        LOCATE MX(I),MY(I): PRINT A$(14+P1):
        IF Y>MY(I) THEN 
          M(I)=8:                 ' -> 8 вниз
          RETURN
        ELSE 
          M(I)=7:                 ' -> 7 вверх
          RETURN
1080 LOCATE MX(I)-1,MY(I):PRINT A$(1):
     LOCATEMX(I),MY(I):PRINT A$(14+P1):
     RETURN

' мозги лимона
' M(I) = 6, лимон(I) влево
1090 MX(I)=MX(I)-1:V=6144+MX(I)+MY(I)*32
1100 Z=0:Z=Z-(VPEEK(V)<>&H20):Z=Z-(VPEEK(V+32)<>&H20)
1110 IF Z THEN
        MX(I)=MX(I)+1:
        LOCATE MX(I),MY(I):PRINT A$(14+P1):
        IF Y>MY(I) THEN
          M(I)=8:                 ' -> 8 вниз
          RETURN
        ELSE
          M(I)=7:                 ' -> 7 вверх
          RETURN
1120 LOCATEMX(I)+1,MY(I):PRINT A$(1):
     LOCATEMX(I),MY(I):PRINT A$(14+P1):
     RETURN

' мозги лимона
' M(I) = 7, лимон(I) вверх
1130 MY(I)=MY(I)-1:V=6144+MX(I)+MY(I)*32
1140 Z=0:Z=Z-(VPEEK(V)<>&H20):Z=Z-(VPEEK(V+1)<>&H20)
1150 IF Z THEN
        MY(I)=MY(I)+1:
        LOCATE MX(I),MY(I):PRINT A$(14+P1):
        IF X>MX(I) THEN
          M(I)=5:                 ' -> 5 вправо
          RETURN
        ELSE
          M(I)=6:                 ' -> 6 влево
          RETURN
1160 LOCATEMX(I),MY(I)+1:PRINT A$(1):
     LOCATEMX(I),MY(I):PRINT A$(14+P1):
     RETURN

' мозги лимона
' M(I) = 8, лимон(I) вниз
1170 MY(I)=MY(I)+1:V=6144+MX(I)+MY(I)*32
1180 Z=0:Z=Z-(VPEEK(V+32)<>&H20):Z=Z-(VPEEK(V+33)<>&H20)
1190 IF Z THEN
        MY(I)=MY(I)-1:
        LOCATEMX(I),MY(I):PRINT A$(14+P1):
        IF X>MX(I) THEN
          M(I)=5:                 ' -> 5 вправо
          RETURN
        ELSE
          M(I)=6:                 ' -> 6 влево
          RETURN
1200 LOCATEMX(I),MY(I)-1:PRINT A$(1):
     LOCATEMX(I),MY(I):PRINT A$(14+P1):
     RETURN

' M(I) = 9 -- злое солнышко летит к нам снизу
1210 IF MX(1)<X THEN
        MX(1)=MX(1)+1
     ELSE
        MX(1)=MX(1)-1
1220 IF MY(1)<Y THEN
        MY(1)=MY(1)+1
     ELSE
        MY(1)=MY(1)-1
1230 RETURN

' M(I) = 10 -- злое солнышко прилетело
1240 IF MY(1)<23 THEN
        PUT SPRITE 3,(MX(1)*8,MY(1)*8),1,16:         ' злое солнышко
        PUT SPRITE 4,(MX(1)*8,MY(1)*8),11,17
1250 IF ABS(X-MX(1))<2 AND ABS(Y-MY(1))<2 THEN 790   ' бобо, жизнь -1
1260 RETURN

''''''''''' конец мозгов ''''''''''

' следующий уровень / загрузка уровня  11 строк 16 столбцов
1270 RO=RO+1:
     IF RO>15 THEN 
        2070 ' победа
     ELSE
        CL=0:
        READ EX,EY,NN,Z1,Z2,MM,Z3,Z4
1280 FOR I=0 TO 10:
        READ RO$(I):
     NEXT

' рестарт уровня
1290 CLS:
     DEFUSR=&H41:A=USR(0) ' $41 = DISSCR Disable Screen Display 
1295 PLAY"S1M3000T150R2L16O5CDEFM20000G1.","S1M2000T150R2L16O7CDEFM10000G1."

' отрисовываем макротайлы
1300 FOR I=0 TO 10:
        FOR J=0 TO 15
1310        LOCATEJ*2,I*2:
            PRINT A$(VAL("&H"+MID$(RO$(I),J+1,1))):
        NEXT:
     NEXT
1320 GOSUB 630: 'printscore
     GOSUB 640: 'printlives
     NT=14:     ' NishTyak = 14 (бусы времени)
     GOSUB 670  'printstats
1330 X=2:
     Y=1:
     JU=0:      ' не прыжок
     M(1)=NN:   ' level data...
     M(2)=MM:
     MX(1)=Z1:
     MY(1)=Z2:
     MX(2)=Z3:
     MY(2)=Z4:
     K=0:
     T=0

1340 GOSUB 780: ' спрятать все спрайты
     DEFUSR=&H44:A=USR(0)  ' $44 = ENASCR Enable Screen Display

1350 RL=0:              ' RL = Right/Left ориентация спрайта Потапа
     C3=3:
     GOTO 380

' данные уровней: 11 строк в каждом экране
' 2 = кирпич
' 1 = фон
' 8 = замок
' A = вишенка
' B = яблочко
' 3 = затычка для врага
' 4 = [?]
' 5 = секретный кирпич
'

1360 DATA20,16,1,10,6,1,10,12       ' EX,EY, NN, Z1, Z2, MM, Z3,Z4
1370 DATA2222222222222222,2111111111111112,2111111111111182,211AA11111131122
1380 DATA2222222222511222,2111111111111222,21BB111113112222,2222222221142222
1390 DATA2222211111222222,27111111111AABB2,2222222222222222
1400 DATA28,16,1,8,18,1,23,18
1410 DATA2222222222222222,211111AA2BB11112,2112222228222212,221111AA2BB11112
1420 DATA2711222222252122,221111AA2BB11122,2221122222221222,222211AA2B111222
1430 DATA2222212222122222,2B111111111111B2,2222222222222222
1440 DATA8,18,1,4,10,1,24,10
1450 DATA2111111111111112,2111111111111112,2111111BB1111112,2211111281111152
1460 DATA2111111111111112,2311111331111132,2122222112222212,2C112117B11211C2
1470 DATA2211211221121122,2111211111121112,2666266666626662
1480 DATA30,18,5,10,8,6,20,8
1490 DATA2222222222222222,2111133111111132,2111113111111172,2182111111112222
1500 DATA2131111331111112,2111121111211112,2111111CC1111112,2311111221111132
1510 DATA2111112222111112,2BBBB222225BBBB2,2222222222222222
1520 DATA2,18,1,18,18,1,10,10
1530 DATA2222222222222222,211122221CCCCC12,211111211CCCCCD2,2212212412222222
1540 DATA2212111111221112,2712311111128112,2212666666621122,2212222222221112
1550 DATA2211122112222112,2211111111111122,2222222222222222
1560 DATA24,20,2,14,8,2,22,14
1570 DATA2222222222222222,2111111111111112,2111111111111712,2111111111111212
1580 DATA23BCD11111111132,2122211111111112,2121111111111112,2128111111111112
1590 DATA2111111111111112,2111111111111112,2666666666666662
1600 DATA12,16,4,14,2,5,20,2
1610 DATA2222222222222222,2111111121111112,211122212AA11112,2111121125211112
1620 DATA2211522111111112,21BB221112211182,212222211221DD12,21CC121112212212
1630 DATA2222122112111112,2171121112111112,2222222662666662
1640 DATA16,14,8,12,6,7,22,18
1650 DATA2222222222222222,2111111DDDDDDDD2,2112122222222282,2112111222111372
1660 DATA2212211221111322,2111111211121112,2112221222311112,2111111221111512
1670 DATA2221122222212212,2B311111111112E2,2222222222222222
1680 DATA30,16,6,14,10,5,16,10
1690 DATA2222222222222222,2112111221111172,2111111111112222,2211121111211112
1700 DATA2111111121111112,2112111111112112,2D111121121111D2,2111211111121112
1710 DATA2181111221111212,2111111331111112,2666666666666662
1720 DATA2,20,6,14,8,5,16,8
1730 DATA2222222222222222,2111111221111112,2112711111117512,2112811DD1118212
1740 DATA2111111111111112,2111111111111112,2111112332111112,2332332112332332
1750 DATA2112112112112112,2112112112112112,2662662662662662
1760 DATA4,4,7,14,17,6,14,14
1770 DATA2222222222222222,2111221111711112,2121228171222112,2111112626211112
1780 DATA2221212222212122,2221111121111122,2222212121212522,2222211111112522
1790 DATA2222222181222522,2222222111222222,2222222222222222
1800 DATA20,14,4,16,4,4,26,4
1810 DATA2222222222222222,2111111111111112,2111221111DD1112,2211122212222182
1820 DATA2111121111111112,2112228212211112,2111125222221112,2221127DCC222112
1830 DATA2111121111111112,2711221111111122,2266226626626622
1840 DATA28,20,7,18,18,7,22,18
1850 DATA2222222222222222,21111111DDDDDDD2,2555551262626262,2AAAA11222222222
1860 DATA2222212211111112,2BBB112112112212,2222122122122212,2CC1121121112212
1870 DATA2221221221212212,27711112211122E2,2282222222822222
1880 DATA30,4,1,6,16,2,24,16
1890 DATA2222222222222222,2111111111111112,2111111111111112,2111DDD11DDD1112
1900 DATA2111282112851112,2111272112751112,2211212112121122,2111111111111112
1910 DATA2131111331111312,21111D1111D11112,2666626666266662
1920 DATA0,14,5,8,6,6,22,14
1930 DATA2222222222222222,2113333111111132,2111111111111112,2811111111311172
1940 DATA2266266266266422,2222222222222522,2112221222122512,2111111111111112
1950 DATA2111131111111312,2726662666266682,2222222222222222

1960 DIM A$(20),  ' объекты
         G$(2),
         CH(4):
         RESTORE2020
1970 G$(1)="00000C60266046606760BE6825684068" ' огонь (см строку 320)
1980 G$(2)="08601060B0603A607F60CD6882681068"

' читаем макротайлы 4х4 из 2020
' собираем в A$строки типа [1][2], курсор влево-влево-вниз, [3][4]
1990 FOR I=1 TO 20:
        READ S$
2000    FOR J=1 TO 4:
          CH(J)=VAL("&H"+MID$(S$,J*2-1,2)): ' ch(j) = hex из data 2020
        NEXT
        ' ch(1) + ch(2) + cursor left + cursor left + cursor down + ch(3) + ch(4)
2010    A$(I)=CHR$(CH(1))+CHR$(CH(2))+CHR$(&H1D)+CHR$(&H1D)+CHR$(&H1F)+
            CHR$(CH(3))+CHR$(CH(4)):
     NEXT:
     RETURN

' 20x по 4 тайла квадратиками 2х2 (начинаем с 1)
' 1:фон, 2:кирпичи, 3:заглушка куда врагам не пройти, 4: [?]
2020 DATA 20202020,77787877,60606060,7E808182
' 5:секретный кирпич, 6: огонь, 7: бусинка, 8: кирпич под бусинку
2030 DATA 7D787877,75757676,2020726D,797A7877
' 9:успешный выход, 10:вишенка (счет), 11: яблочко (счет), 12: ананасик (счет)
2040 DATA 60607460,206B6E6C,63646F65,66677068
' 13: виноградик, 14: перстень, 15: лимонолет, 16: лимонолет
2050 DATA 2069716A,61207362,84858687,88898687
' 17: крыска, 18: крыска, 19: капелька, 20: капелька
2060 DATA 8B8C8D8E,8F909192,93949596,9798999A


' бобеда, последний экран, A WINRAR IS YOU
2070 GOSUB 780: ' спрайты нах
     CLS
2080 DEFUSR=&H41:A=USR(0)   ' $41 = DISSCR Disable Screen Display
2090 FOR I=1 TO 12:
        LOCATE0,7+I:PRINT STRING$(32,CHR$(&H9C)):   ' синяя стена
     NEXT

2100 FOR I=0 TO 15:
        LOCATE I*2,20:PRINTA$(2): ' все кирпичи в нижней строке уровня 
     NEXT:
     X=0:
     GOSUB 630: 'printscore
     GOSUB 650: 'printlives
     GOSUB 670  'printstats
2110 LOCATE 16,18:PRINT CHR$(&H9D):
     LOCATE 16,19:PRINT CHR$(&H9E)   ' амулет Йендора
2120 DEFUSR=&H44:A=USR(0)  ' $44 = ENASCR Enable Screen Display
2130 SWAP K1,K2:
     X=X+1:
     IF K1=1 THEN
        Z=3
     ELSE
        SWAP P1,P2:
        Z=P1
2140 PUT SPRITE 0,(X*4,143),15,Z*2-1:
     PUT SPRITE 1,(X*4,143),14,Z*2
2150 FOR I=1 TO 100:
     NEXT I:
     IF X<28 THEN 2130
2160 PUT SPRITE 0,(X*4,143),15,13:
     PUT SPRITE 1,(X*4,143),14,14
2170 LOCATE 16,18: PRINT CHR$(&H9C)
2180 LOCATE 7,4: PRINT"CONGRATULATION !"
2190 LOCATE 6,6: PRINT"BONUS 50000 POINTS":
     SC=SC+5000:
     GOSUB 630:   ' printscore
     GOSUB 780:   ' hide_sprites
     GOTO 870     ' hiscore


2200 GOSUB 2240:
     POKE &HDA00,32:
     POKE &HDA01,&H38:
     RESTORE 2340

    ' загружаем 17 спрайтов
2210 FOR I=1 TO 17:
        READQ$:
        Q$=USR9(Q$):
     NEXT:
     A=USR1(0)

     ' загружаем 62 тайла с кодами 97..158
2220 FOR I=1 TO 62:
        READ Q$:
        POKE &HDA00,96+I:
        Q$=USR2(Q$):
     NEXT

2230 DEFUSR=&H7E:  ' $7E = SETGRP Sets the VDP for high-resolution mode
     A=USR(0):
     RETURN

2240 ' создаем процедуру загрузки спрайта USR9()
2250 RESTORE 2270:
     VV=&HDA00:
     DEFUSR9=&HDA02
2260 READ S$:
     A=LEN(S$)/2-1:
     FORI=0TOA:
        POKEVV+I,VAL("&H"+MID$(S$,I*2+1,2)):
     NEXT

' Line 2270:  USR9=$DA02-$DA36
' DA00:   dw     0
' DA02:   ld     a,(de)     
' DA03:   srl    a          
' DA05:   ld     b,a        
' DA06:   inc    de         
' DA07:   ex     de,hl      
' DA08:   ld     (#da0c),hl 
' DA0B:   ld     hl,(#b527) 
' DA0E:   ld     a,(hl)     
' DA0F:   sub    #30        
' DA11:   cp     #10        
' DA13:   jr     c,#da17    
' DA15:   sub    #07        
' DA17:   inc    hl         
' DA18:   rlca              
' DA19:   rlca              
' DA1A:   rlca              
' DA1B:   rlca              
' DA1C:   ld     c,a        
' DA1D:   ld     a,(hl)     
' DA1E:   sub    #30        
' DA20:   cp     #10        
' DA22:   jr     c,#da26    
' DA24:   sub    #07        
' DA26:   or     c          
' DA27:   ex     de,hl      
' DA28:   ld     hl,(#da00) 
' DA2B:   call   #004d ' WRTVRM Writes to the VRAM addressed by [HL]
' DA2E:   inc    hl         
' DA2F:   ld     (#da00),hl 
' DA32:   inc    de         
' DA33:   ex     de,hl      
' DA34:   djnz   #da0e      
' DA36:   ret               
2270 DATA00001ACB3F4713EB220CDA2A00007ED630FE103802D60723070707074F7ED630FE103802D607B1EB2A00DACD4D00232200DA13EB10D8C9

' USR1=D900
D900:   ld     de,#0100   
D903:   ld     hl,#1bbf   ; xref d951 jr nc, #d903
D906:   add    hl,de      
D907:   ld     a,(hl)     
D908:   ld     b,a        
D909:   sra    a          
D90B:   or     b          
D90C:   push   de         
D90D:   pop    hl         
D90E:   call   #d954     ; WRTVRM 
D911:   ld     hl,#0800   
D914:   add    hl,de      
D915:   call   #d954     ; WRTVRM 
D918:   ld     hl,#1000   
D91B:   add    hl,de      
D91C:   call   #d954     ; WRTVRM 
D91F:   or     a          
D920:   ld     hl,#0180   
D923:   sbc    hl,de      
D925:   jr     c,#d933    
D927:   ld     hl,#01d0   
D92A:   or     a          
D92B:   sbc    hl,de      
D92D:   jr     nc,#d933   
D92F:   ld     a,#f1      
D931:   jr     #d935      
D933:   ld     a,#f0      
D935:   ld     hl,#2000   
D938:   add    hl,de      
D939:   call   #d954     ; WRTVRM 
D93C:   ld     hl,#2800   
D93F:   add    hl,de      
D940:   call   #d954     ; WRTVRM 
D943:   ld     hl,#3000   
D946:   add    hl,de      
D947:   call   #d954     ; WRTVRM 
D94A:   inc    de         
D94B:   ld     hl,#02d8   ; 728
D94E:   or     a          
D94F:   sbc    hl,de      
D951:   jr     nc,#d903   
D953:   ret               

D954:   push   af         
D955:   push   de         
D956:   push   hl         
D957:   call   #004d ' WRTVRM Writes to the VRAM addressed by [HL]
D95A:   pop    hl         
D95B:   pop    de         
D95C:   pop    af         
D95D:   ret               

' загрузка тайла из строки
' USR2=D95E
' DA00 = tile index
D95E:   inc    de         
D95F:   ex     de,hl      
D960:   ld     (#d964),hl 
D963:   ld     hl,(#b527)   ; SELFMOD xref D960
D966:   ld     (#d9fe),hl 
D969:   xor    a          
D96A:   ld     (#da01),a  
D96D:   ld     a,(#da00)  
D970:   ld     l,a        
D971:   ld     h,#00      
D973:   add    hl,hl      
D974:   add    hl,hl      
D975:   add    hl,hl      
D976:   ld     a,(#da01)  
D979:   or     l          
D97A:   ld     l,a        
D97B:   ld     (#d9fc),hl 
D97E:   ld     a,(#da01)  
D981:   rlca              
D982:   rlca              
D983:   ld     e,a        
D984:   ld     d,#00      
D986:   ld     hl,(#d9fe) 
D989:   add    hl,de      
D98A:   call   #d9d6      
D98D:   ld     hl,(#d9fc) 
D990:   call   #d954      ; WRTVRM
D993:   ld     de,#0800   
D996:   add    hl,de      
D997:   call   #d954      ; WRTVRM
D99A:   ld     de,#0800   
D99D:   add    hl,de      
D99E:   call   #d954      ; WRTVRM
D9A1:   ld     a,(#da01)  ; msb mystery arg
D9A4:   rlca              
D9A5:   rlca              
D9A6:   inc    a          
D9A7:   inc    a          
D9A8:   ld     e,a        
D9A9:   ld     d,#00      
D9AB:   ld     hl,(#d9fe) 
D9AE:   add    hl,de      
D9AF:   call   #d9d6      
D9B2:   ld     hl,(#d9fc) 
D9B5:   ld     de,#2000   
D9B8:   add    hl,de      
D9B9:   call   #d954      
D9BC:   ld     de,#0800   
D9BF:   add    hl,de      
D9C0:   call   #d954      
D9C3:   ld     de,#0800   
D9C6:   add    hl,de      
D9C7:   call   #d954      
D9CA:   ld     a,(#da01)  
D9CD:   inc    a          
D9CE:   ld     (#da01),a  
D9D1:   cp     #08        
D9D3:   jr     c,#d96d    
D9D5:   ret               

; преобразование hex байта из ascii в A
D9D6:   ld     a,(hl)     
D9D7:   inc    hl         
D9D8:   sub    #30        
D9DA:   cp     #0a        
D9DC:   jr     c,#d9e0    
D9DE:   sub    #07        
D9E0:   rlca              
D9E1:   rlca              
D9E2:   rlca              
D9E3:   rlca              
D9E4:   ld     b,a        
D9E5:   ld     a,(hl)     
D9E6:   sub    #30        
D9E8:   cp     #0a        
D9EA:   jr     c,#d9ee    
D9EC:   sub    #07        
D9EE:   or     b          
D9EF:   ret               

; data
D9F0:   jr     nz,#da37   
D9F2:   ld     d,b        
D9F3:   ld     d,h        
D9F4:   ld     d,l        
D9F5:   ld     c,(hl)     
D9F6:   ld     b,l        
D9F7:   jr     nz,#da4c   
D9F9:   ld     h,h        
D9FA:   jr     nz,#da69   

; переменные
D9FC:   rst    30h
D9FD:   inc    b          
D9FE:   ret    po         
D9FF:   or     h          


2280 DATA11000121BF1B197E47CB2FB0D5E1CD54D921000819CD54D921001019CD54D9B7218001ED52380C21D001B7ED5230043EF118023EF021002019CD54D921002819
2290 DATACD54D921003019CD54D91321D802B7ED5230B0C9F5D5E5CD4D00E1D1F1C913EB2264D92A000022FED9AF3201DA3A00DA6F26002929293A01DAB56F22FCD93A01
2300 DATADA07075F16002AFED919CDD6D92AFCD9CD54D911000819CD54D911000819CD54D93A01DA07073C3C5F16002AFED919CDD6D92AFCD911002019CD54D911000819
2310 DATACD54D911000819CD54D93A01DA3C3201DAFE083898C97E23D630FE0A3802D60707070707477ED630FE0A3802D607B0C920455054554E45205364206D6564469B

' DATA сейчас показывает на строку 2280
' Создаем подпрограммы USR1=$D900 и USR2=D95E
2320 V=&HD900:
     FORI=0TO3:
        READS$:
        A=LEN(S$)/2-1:
        FORJ=0TOA:
            POKEV+J,VAL("&H"+MID$(S$,J*2+1,2)):
        NEXT:
        V=V+64:
     NEXT

2330 DEFUSR1=&HD900:
     DEFUSR2=&HD95E:
     RETURN

2340 DATA03070F0F1F1F1F1F0F00310101000000C0F0F8FCB4B6B6B6FC02F4F0ECD87020
2350 DATA0008103020606060300F0E3E060B0D0E000000000000000000FC0808102488D0
2360 DATA03070F0F1F1F1F1F0F000D0E06000E07C0F0F8FCB4B6B6B6FC00F0F0E61C3800
2370 DATA0008103020606060300F1211093F3018000000000000000000F0000010E24438
2380 DATA03070F0F1F1F1F1F0F00070B0B010303C0F0F8FCB4B6B6B6FC00F4F4E400D8EC
2390 DATA0008103020606060300F181414060C0C000000000000000000F8080818F82010
2400 DATA030F1F3F2D6D6D6D3F402F0F371B0E04C0E0F0F0F8F8F8F8F000888080000000
2410 DATA0000000000000000003F10100824110B0010080C040606060CF0F0FC60D0B070
2420 DATA030F1F3F2D6D6D6D3F000F0F67381C00C0E0F0F0F8F8F8F8F000B070600070E0
2430 DATA0000000000000000000F00000847221C0010080C040606060CF0488890FC0C18
2440 DATA030F1F3F2D6D6D6D3F002F2F27001B37C0E0F0F0F8F8F8F8F000E0D0D080C0C0
2450 DATA0000000000000000001F1010180F04080010080C040606060CF0182828603030
2460 DATA030F1F3F3D7D7D7D3F002F4F07003C7CC0E0F0F0B8B8B8B8F000CCC080003038
2470 DATA0000000000000000000F1030080F02020010080C040606060CF0303E70F04C46
2480 DATAFF8080FF00754572457500FF8080FF00FF0101FF005C4848484800FF0101FF00
2490 DATA030C102040408C8280834F4320100C03C03008040202314101C1F2C2040830C0
2500 DATA00030F1F3F3F7F7F7F7F3F3F2F0F030000C0F0F8FCFCFEFEFEFEFCFCF8F0C000
2510 DATA0000000000000EF01F603F803C9003F0,60F070703870185018703850F050E040
2520 DATA0000032003C002C03F807F8030F830F8,0000000000000000E080F060F860F860
2530 DATAF860F860F860F060F060E0A0E0A0C030,03301D300E20072003C003C001C00EF0
2540 DATA8C30D820D8C01E3CADC038307C20C6C0,02C080A0806080A00000000000000000
2550 DATA000030701C500E500A4060C0F030F6C0,CF30101CE1C1C6C13731BBC1BAC130C0
2560 DATA000000000000603020205020502048C0,482088C008C038F07C907C907C803860
2570 DATA000000000000C060E060E080E080C090,0000000001C00EF01F901F801F800E60
2580 DATA20F8016883687F607F603F603FA01FA0,35B07FB0AA6B1FABAA6A00AAA96A78A0
2590 DATA000001300D301EC06BC1F730F7C063C0,000000000000016003F002F003600180
2600 DATA0F70065008F00CF00C700E7007700350,00000000000000000000000000000000
2610 DATA00002660436067602386116833890889,FD8A668A4D8A108A82FAACFA26FAFFFF
2620 DATA7F31C032803280328032803280327FC1,FE3101C201C201C201C201C203C2FEC1
2630 DATA7F310112031203120312011280C27FC1,FE31C012E012E0C2E0C2C0C203C2FEC1
2640 DATA7F31016203F203F20362018280C27FC1,FE31C062E062E082E082C09203C2FEC1
2650 DATA7F30C032803280328032803280327FC1,7FA0C0BAC0B4C0B4C7B4CCB4CCB4CCB4
2660 DATA7FF0C0FBC0F6D8F6D7F6CCB8CCF8CCB8,FEA0FCBA03B403B4E3B433B433B433B4
2670 DATAC0B4C1B4C1B4C0B4C1B4C0B4C0BA7FA0,E3B483B483B403B483B403B4FCABFEA0
2680 DATAC071E8F174F174717471EC51DC511A41,03F0014001F0037007B01FB03FB03FB0
2690 DATAC0F080408070C040E0B0F8B0FCB0FCB0,73B07DB07FB07EB038B03FB01FB007B0
2700 DATACEB0BEB0FEB07EB01CB0FCB0F8B0E0B0,7DF4014001F0037007B01FB03FB03FB0
2710 DATA414780408070C040E0B0F8B0FCB0FCB0,38F07CF0D6F0D6F07CE07CF0EEF00000
2720 DATA0CF016F01EF00CF00F703F707F707F70,60F0B0F0F0F060F0E070F840FC40FC40
2730 DATA014703471F4701600180018000000000,FE40FE40FE40806080808080C0806080
2740 DATA0CF01AF01EF00CF007700F700F701F70,60F0D0F0F0F060F0C070E040E040F040
2750 DATA1F701F701F701F400360038006800C80,F040F040F040F04000000000000000000
2760 DATA000001F007F01EF03C7038F078707970,0000C7F01EF03C707CF0F870F870F070
2770 DATA7F705B705B705B705B703F703F401F40,F070F070F040E070E040E040C0400000
2780 DATA0000E3F078F03CF03E701FF01F700F70,000080F0E0F078703CF01C701E709E70
2790 DATA0F700F700F7007700770074003400000,FE70DA70DA40DA70DA40FC40FC40F840
2800 DATA3C617E6106F606F60F6803687E803C80,04140414041500112014201420150011
2810 DATA3C747E74C37F817F817F817F7EF53C71,99F499F41EFA7EA13C647EF40CFA0CFA
