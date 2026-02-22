main:                                   ; -- Begin function main
                                        ; @main
; %bb.0:                                ; %entry
	PUSH GP0
	MOV GP0, GP29
	SUBI GP29, #16
	LLI GP2, #0
	ST GP2, GP0, #-4
	ST GP2, GP0, #-8
	LLI GP3, #1
	ST GP3, GP0, #-12
	ST GP2, GP0, #-16
	JMP LBB2_1
LBB2_1:                                 ; %while.body
                                        ; =>This Inner Loop Header: Depth=1
	LDB GP2, GP0, #-16
	ANDI GP2, #1
	LLI GP3, #0
	CMP GP2, GP3
	JNE LBB2_3
	JMP LBB2_2
LBB2_2:                                 ; %if.then
                                        ;   in Loop: Header=BB2_1 Depth=1
	LD GP2, GP0, #-8
	LD GP3, GP0, #-12
	ADD GP2, GP3
	ST GP2, GP0, #-8
	LD GP23, GP0, #-8
	CALLI printi
	JMP LBB2_4
LBB2_3:                                 ; %if.else
                                        ;   in Loop: Header=BB2_1 Depth=1
	LD GP2, GP0, #-8
	LD GP3, GP0, #-12
	ADD GP2, GP3
	ST GP2, GP0, #-12
	LD GP23, GP0, #-12
	CALLI printi
	JMP LBB2_4
LBB2_4:                                 ; %if.end
                                        ;   in Loop: Header=BB2_1 Depth=1
	LD GP2, GP0, #-16
	ADDI GP2, #1
	ST GP2, GP0, #-16
	JMP LBB2_1
                                        ; -
putc:                                   ; -- Begin function putc
                                        ; @putc
; %bb.0:                                ; %entry
	PUSH GP0
	MOV GP0, GP29
	SUBI GP29, #1
                                        ; kill: def $gp2 killed $gp23
	STB GP23, GP0, #-1
	LDB GP2, GP0, #-1
	LUI GP3, #1024
	ORI GP3, #1
	STB GP2, GP3, #0
	MOV GP29, GP0
	POP GP0
	RET
                                        ; -- End function
printi:                                 ; -- Begin function printi
                                        ; @printi
; %bb.0:                                ; %entry
	PUSH GP0
	MOV GP0, GP29
	SUBI GP29, #20
	ST GP23, GP0, #-4
	LUI GP2, #2048
	ST GP2, GP0, #-20
	JMP LBB1_1
LBB1_1:                                 ; %while.cond
                                        ; =>This Inner Loop Header: Depth=1
	LD GP2, GP0, #-4
	LLI GP3, #0
	CMP GP2, GP3
	JEQ LBB1_3
	JMP LBB1_2
LBB1_2:                                 ; %while.body
                                        ;   in Loop: Header=BB1_1 Depth=1
	LD GP2, GP0, #-4
	LUI GP3, #838860
	ORI GP3, #838861
	MOV GP4, GP2
	MUL GP4, GP3
	AMOV GP4
	SHRI GP4, #3
	MULI GP4, #10
	SUB GP2, GP4
	ORI GP2, #48
	LD GP4, GP0, #-20
	MOV GP5, GP4
	ADDI GP5, #1
	ST GP5, GP0, #-20
	MOV GP1, GP0
	SUBI GP1, #14
	ADD GP1, GP4
	STB GP2, GP4, #0
	LD GP2, GP0, #-4
	MUL GP2, GP3
	AMOV GP2
	SHRI GP2, #3
	ST GP2, GP0, #-4
	JMP LBB1_1
LBB1_3:                                 ; %while.end
	JMP LBB1_4
LBB1_4:                                 ; %while.cond1
                                        ; =>This Inner Loop Header: Depth=1
	LD GP2, GP0, #-20
	LLI GP3, #0
	CMP GP2, GP3
	JEQ LBB1_6
	JMP LBB1_5
LBB1_5:                                 ; %while.body4
                                        ;   in Loop: Header=BB1_4 Depth=1
	LD GP2, GP0, #-20
	LUI GP3, #1048575
	ORI GP3, #1048575
	ADD GP2, GP3
	ST GP2, GP0, #-20
	MOV GP1, GP0
	SUBI GP1, #14
	ADD GP1, GP2
	LDB GP23, GP2, #0
	CALLI putc
	JMP LBB1_4
LBB1_6:                                 ; %while.end6
	LLI GP23, #10
	CALLI putc
	MOV GP29, GP0
	POP GP0
	RET
                                        ; -- End function

