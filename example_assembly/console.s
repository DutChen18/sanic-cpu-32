SECTION .text
putc:                                   ; -- Begin function putc
                                        ; @putc
; %bb.0:                                ; %entry
	PUSH GP0
	MOV GP0, GP29
	SUBI GP29, #8
                                        ; kill: def $gp2 killed $gp24
	ST GP23, GP0, #-4
	STB GP24, GP0, #-5
	LDB GP2, GP0, #-5
	LD GP3, GP0, #-4
	STB GP2, GP3, #0
	MOV GP29, GP0
	POP GP0
	RET
                                        ; -- End function
printf:                                 ; -- Begin function printf
                                        ; @printf
; %bb.0:                                ; %entry
	PUSH GP0
	MOV GP0, GP29
	SUBI GP29, #12
	ST GP23, GP0, #-4
	ST GP24, GP0, #-8
	LLI GP2, #0
	ST GP2, GP0, #-12
	JMP LBB1_1
LBB1_1:                                 ; %for.cond
                                        ; =>This Inner Loop Header: Depth=1
	LD GP2, GP0, #-12
	LLI GP3, #3
	CMP GP2, GP3
	JGTU LBB1_4
	JMP LBB1_2
LBB1_2:                                 ; %for.body
                                        ;   in Loop: Header=BB1_1 Depth=1
	LD GP23, GP0, #-4
	LD GP2, GP0, #-8
	LD GP3, GP0, #-12
	ADD GP2, GP3
	LDB GP24, GP2, #0
	SHLI GP24, #24
	SRAI GP24, #24
	CALLI putc
	JMP LBB1_3
LBB1_3:                                 ; %for.inc
                                        ;   in Loop: Header=BB1_1 Depth=1
	LD GP2, GP0, #-12
	ADDI GP2, #1
	ST GP2, GP0, #-12
	JMP LBB1_1
LBB1_4:                                 ; %for.end
	MOV GP29, GP0
	POP GP0
	RET
                                        ; -- End function

SECTION .main
main:                                   ; -- Begin function main
                                        ; @main
; %bb.0:                                ; %entry
	LUI GP24, .str
	ORI GP24, .str
	LUI GP23, #1024
	ORI GP23, #1
	CALLI printf
	LLI GP28, #0
	RET
                                        ; -- End function
	SECTION .rodata.str1.1
.str:                                   ; @.str
	DB 84
	DB 104
	DB 105
	DB 115
	DB 32
	DB 105
	DB 115
	DB 32
	DB 97
	DB 32
	DB 116
	DB 101
	DB 115
	DB 116
	DB 0

