	SECTION .text
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
	SUBI GP29, #12
	ST GP23, GP0, #-4
	LUI GP2, #244140
	ORI GP2, #707072
	ST GP2, GP0, #-8
	JMP LBB1_1
LBB1_1:                                 ; %while.cond
                                        ; =>This Inner Loop Header: Depth=1
	LD GP2, GP0, #-8
	LLI GP3, #0
	CMP GP2, GP3
	JEQ LBB1_5
	JMP LBB1_2
LBB1_2:                                 ; %while.body
                                        ;   in Loop: Header=BB1_1 Depth=1
	LD GP2, GP0, #-8
	LD GP3, GP0, #-4
	CMP GP2, GP3
	JGTU LBB1_4
	JMP LBB1_3
LBB1_3:                                 ; %if.then
                                        ;   in Loop: Header=BB1_1 Depth=1
	LD GP2, GP0, #-4
	LD GP3, GP0, #-8
	DIV GP2, GP3
	LUI GP4, #838860
	ORI GP4, #838861
	MOV GP3, GP2
	MUL GP3, GP4
	AMOV GP3
	SHRI GP3, #3
	MULI GP3, #10
	SUB GP2, GP3
	ST GP2, GP0, #-12
	LD GP2, GP0, #-12
	ADDI GP2, #48
	ST GP2, GP0, #-12
	LDB GP23, GP0, #-12
	CALLI putc
	JMP LBB1_4
LBB1_4:                                 ; %if.end
                                        ;   in Loop: Header=BB1_1 Depth=1
	LD GP2, GP0, #-8
	LUI GP3, #838860
	ORI GP3, #838861
	MUL GP2, GP3
	AMOV GP2
	SHRI GP2, #3
	ST GP2, GP0, #-8
	JMP LBB1_1
LBB1_5:                                 ; %while.end
	LLI GP23, #10
	CALLI putc
	MOV GP29, GP0
	POP GP0
	RET
                                        ; -- End function
	SECTION .main
main:                                   ; -- Begin function main
                                        ; @main
; %bb.0:                                ; %entry
	LLI GP23, #1234
	CALLI printi
	LLI GP28, #0
	RET
                                        ; -- End function
