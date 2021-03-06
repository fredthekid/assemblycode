;START SETTING UP SEGMENTS
stack_Segment SEGMENT STACK 'STACK'
	DB 64 DUP(?)
stack_Segment ENDS

data_Segment SEGMENT PUBLIC 'DATA'
	CR EQU 0DH; moves cursor back to the left
	LF EQU 0AH; moves cursor down 1 line(enter)
data_Segment ENDS

code_Segment SEGMENT PUBLIC 'CODE'
MAIN PROC FAR
	ASSUME CS:code_Segment, DS:data_Segment, SS:stack_Segment
	PUSH DS
	MOV AX,0
	PUSH AX
	MOV AX,data_Segment
	MOV DS,AX
;FINISH SETTING UP SEGMENTS
	
asknumber:
	;NEXT LINE
	MOV AH,02H
	MOV DL,0AH
	INT 21H
	
	;DISPLAY 'N'
	MOV AH,02H
	MOV DL,4EH
	INT 21H
	
	;SPACE
	MOV AH,02H
	MOV DL,20H
	INT 21H
	
	;GET USER NUMBER
	MOV AH,01H
	INT 21H

checkifvalid:
	CMP AL,31H
	JLE asknumber
	
	;CHECK IF A-F IS INPUTTED
	CMP AL,3AH
	JL continue
	
	;ADJUST IF A-F IS INPUTTED. IF INVALID ASK USER AGAIN
	SUB AL,07H
	CMP AL,40H
	JGE asknumber
	CMP AL,39H
	JLE asknumber
	
continue:
	;CHANGE FROM ASCII TO HEX
	AND AX,000FH
	MOV CX,AX ;CX IS COUNTER FOR LOOP
	
	
	;STORES '00FF' INTO THE MEMORY LOCATION 1 GREATER THAN THE MAX MEMORY LOCATION NEEDED...
	;...USED FOR LOOPING LATER
	ADD AX,200H
	MOV SI,AX
	MOV AX,00FFH
	MOV [SI],AX
	MOV SI,0200H
	PUSH CX
	MOV BL,31H

;ASK FOR INTEGERS
MONUMBERS:
	;NEXT LINE
	MOV AH,02H
	MOV DL,0AH
	INT 21H
	
	;DISPLAY CURRENT NUMBER COUNT
	MOV AH,02H
	MOV DL,BL
	INT 21H
	
	;SPACE
	MOV AH,02H
	MOV DL,20H
	INT 21H
	
	;ASK FOR NUMBER AND STORE
	MOV AH, 01H
	INT 21H
	
;CHECK IF VALID....BLAHH
checkifvalid2:
	CMP AL,2FH
	JLE MONUMBERS
	CMP AL,3AH
	JL INCREMENT

	CMP AL, 40H
	JLE MONUMBERS
	CMP AL,47H
	JGE MONUMBERS

;IF VALID, STORE VALUE
INCREMENT:
	MOV [SI],AL
	CMP BL,39H
	JNE ABCDEFADJUST;INCASEA-FISENTERED LOL
	ADD BL,07H

;INCREMENT THE COUNTER AND ADDRESS
ABCDEFADJUST:
	INC BL
	INC SI
	DEC CX ;COUNTER FOR LOOP
	JNZ MONUMBERS
	
	;GET COUNTER FOR NEXT LOOP, SET UP THE REGISTERS
	POP CX
	MOV SI,0200H
	MOV BL,46H
	MOV DI,00FFH
	
	;NEW LINE
	MOV AH,02H
	MOV DL,0AH
	INT 21H
	
	;NEW LINE
	MOV AH,02H
	MOV DL,0AH
	INT 21H
	
STARTDISPLAY:
	CMP [SI],BL
	JNE NOTEQUAL
	MOV AH,02H
	MOV DL,BL
	INT 21H
	
	;NEW LINE
	MOV AH,02H
	MOV DL,0AH
	INT 21H

NOTEQUAL:
	INC SI
	CMP [SI],DI
	JNE STARTDISPLAY
	CMP BL,41H
	JNE KEEPGOINGDOE
	SUB BL,07H

KEEPGOINGDOE:
	MOV SI,0200H
	DEC BL
	CMP BL,47H
	JNE STARTDISPLAY
	RET
	
MAIN ENDP

code_Segment ENDS
	END MAIN
