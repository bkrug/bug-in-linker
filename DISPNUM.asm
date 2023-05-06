       DEF  START
*
       REF  NUM1,NUM2,NUM3
       REF  STACK,HEXTXT
       REF  VDPADR,VDPWRT

*
* Uncomment this line as a work-around for the bug
* NOTHNG DATA 0

NUMBRS DATA NUM1,NUM2,NUM3
       DATA NUM1,NUM2,NUM3
NUMBRE

START  LI   R12,STACK
       LI   R2,NUMBRS
       LI   R3,>22
       LIMI 0
* Convert number to text      
L1     MOV  *R2+,R0
       LI   R1,HEXTXT
       BL   @MAKEHX
* Print text to screen
       MOV  R3,R0
       BL   @VDPADR
       LI   R0,HEXTXT
       LI   R1,4
       BL   @VDPWRT       
       AI   R3,>20
* Check if we reached end of data
       CI   R2,NUMBRE
       JL   L1
*
JMP    JMP  JMP

*
* Convert to Hex
* Input:
*   R0 - word to Convert
*   R1 - address to place it at
*
MAKEHX DECT R12
       MOV  R11,*R12
       BL   @MAKEP1
       SWPB R0
       BL   @MAKEP1
       SWPB R0
* return
       MOV  *R12+,R11
       RT
 
MAKEP1 DECT R12
       MOV  R11,*R12
       DECT R12
       MOV  R4,*R12
* High Nibble
       MOVB R0,R4
       SRL  R4,4
       BL   @CONVB
       MOVB R4,*R1+
* Low Nibble
       MOVB R0,R4
       SLA  R4,4
       SRL  R4,4
       BL   @CONVB
       MOVB R4,*R1+
* Return
       MOV  *R12+,R4
       MOV  *R12+,R11
       RT
* Convert Byte to ASCII code
CONVB  CI   R4,>0A00
       JHE  CNVB2
       AI   R4,>3000
       RT
CNVB2  AI   R4,>3700
       RT