                 MY_DATA SEGMENT PARA 'DATA'
n DB 10
a DB 5, 2, 3, 6, 12, 7, 14, 9, 10, 11
ort DW ?
MY_DATA ENDS
MY_CODE SEGMENT PARA 'CODE'
;--------------------------------------
partition PROC

MOV DH, [DI]   ;pivot olarak arr[end] degeri atandi

LEA BX, SI     ;begin degerinin offseti BX'e atandi
DEC BX

LEA BP, SI     ;Dongude kullanilacak BP atandi.

CMP DI,BP      ;Begin degeri end degerinden kucuk degilse for loop'u atlandi.
JBE FOR_LOOP_END

FOR_LOOP:

MOV CL, [BP]  ; CL = ARR[J] atandi.
CMP CL, DH    ; CL degeri pivot degerinden buyukse IF'i atlamak icin komut
JA IF_END
IF:
INC BX
MOV AL, [BX]    ;arr[i] degeri gecici olarak AL degerine atandi
MOV [BX], CL    ;arr[i] ve arr[j] degerleri degistirildi.
MOV [BP], AL

IF_END:
INC BP
CMP DI,BP       ; Begin degeri end degeriyle karsilastirildi.
JA FOR_LOOP     ; End degeri begin degerinden buyukse donguyu donduren komut

FOR_LOOP_END:

INC BX

MOV AL, [BX]      ;arr[i] ve pivot degerlerini degistiren komutlar
MOV [BX], DH
MOV [DI], AL


RET
partition ENDP

;--------------------------------------

quickSort PROC

CMP SI,DI         ; begin >= end durumunda metodu gecen kod
JAE END

CALL partition    ; partition metodu cagrildi.
MOV CX, BX        ; partition indexi tutan bx degeri cx'e atandi.

INC CX

PUSH CX           ; pi+1 ve end degeri daha sonra kullanmak icin saklandi
PUSH DI

MOV DI, BX
DEC DI
CALL quickSort    ; Call quickSort(a, begin, pi-1)

POP DI
POP SI

CALL quickSort    ; Call quickSort(a, pi+1, high)

END:

RET
quickSort ENDP

;--------------------------------------

MY_PROG PROC FAR
ASSUME CS:MY_CODE, DS:MY_DATA

MOV AX,MY_DATA
MOV DS,AX


MOV ort,0       ;Ortalama degerini 0 degerinden baslattik
LEA SI, a       ;Dizimizin Offsetini aldik
MOV CL, n
MOV CH, 00      ;Dizi uzunlugu CX'te tutuldu.
MOV AX, 0       ;AX degeri toplamada kullanilacagindan 0'a esitlendi.
ORTALAMA:

MOV AL, [SI]    ; AL'ye degerleri atiyoruz.
ADD ort, AX     ; ORT elemanina dizinin elemanlari atiliyor.
INC SI          ; Bir sonraki elemana geciliyor.
CMP SI, CX
JBE ORTALAMA    ; Tum elemanlara bakilmadiysa geri donduk.

MOV AX, ort     ;AX'e toplam deger atandi.
MOV BL, n       ;BL degerine dizinin uzunlugu atandi.
DIV BL          ;AX/BL islemi yapildi. AH:Kalan, AL:Bolum

MOV ort, AX     ;Bolum sonucunu ort degiskenine atadik

;ORTALAMA_END:

LEA SI, a   ;Dizinin offsetini aldik  Begin degeri icin.
LEA DI, a   ;Dizinin offsetini aldik. End degeri icin.

MOV CL,n    ;Dizi uzunlugu CX'te tutuldu.
MOV CH,00
DEC DI
ADD DI,CX   ;End degeri dizi uzunluguna esitlendi.


CALL quickSort   ;quickSort metodu cagrildi.


MOV AH, 04CH
INT 21H
RET



MY_PROG ENDP
MY_CODE ENDS
END MY_PROG




