	SECTION .text
putc:                                   ; -- Begin function putc
                                        ; @putc
; %bb.0:                                ; %entry
	LUI GP2, #1024
	ORI GP2, #1
	STB GP23, GP2, #0
	RET
                                        ; -- End function
printi:                                 ; -- Begin function printi
                                        ; @printi
; %bb.0:                                ; %entry
	PUSH GP0
	MOV GP0, GP29
	SUBI GP29, #10
	LLI GP4, #0
	CMP GP23, GP4
	LUI GP2, #1024
	LLI GP3, #10
	JEQ LBB1_6
LBB1_1:                                 ; %while.body.preheader
	LUI GP5, #838860
	ORI GP5, #838861
LBB1_2:                                 ; %while.body
                                        ; =>This Inner Loop Header: Depth=1
	MOV GP6, GP23
	MUL GP6, GP5
	AMOV GP6
	SHRI GP6, #3
	MOV GP7, GP6
	MULI GP7, #10
	CMP GP23, GP3
	SUB GP23, GP7
	ORI GP23, #48
	MOV GP1, GP0
	SUBI GP1, #10
	ADD GP1, GP4
	STB GP23, GP7, #0
	ADDI GP4, #1
	MOV GP23, GP6
	JLTU LBB1_3
	JMP LBB1_2
LBB1_3:                                 ; %while.cond1.preheader
	LLI GP5, #0
	CMP GP4, GP5
	JEQ LBB1_6
LBB1_4:                                 ; %while.body4.preheader
	LUI GP6, #1048575
	ORI GP6, #1048575
	MOV GP7, GP2
	ORI GP7, #1
LBB1_5:                                 ; %while.body4
                                        ; =>This Inner Loop Header: Depth=1
	ADD GP4, GP6
	MOV GP1, GP0
	SUBI GP1, #10
	ADD GP1, GP4
	LDB GP8, GP8, #0
	STB GP8, GP7, #0
	CMP GP4, GP5
	JNE LBB1_5
LBB1_6:                                 ; %while.end6
	ORI GP2, #1
	STB GP3, GP2, #0
	MOV GP29, GP0
	POP GP0
	RET
                                        ; -- End function
	SECTION .main
main:                                   ; -- Begin function main
                                        ; @main
; %bb.0:                                ; %printi.exit
	LUI GP2, #1024
	ORI GP2, #1
	LLI GP3, #49
	STB GP3, GP2, #0
	LLI GP3, #50
	STB GP3, GP2, #0
	LLI GP3, #51
	STB GP3, GP2, #0
	LLI GP3, #52
	STB GP3, GP2, #0
	LLI GP3, #10
	STB GP3, GP2, #0
	LLI GP28, #0
	RET
                                        ; -- End function
