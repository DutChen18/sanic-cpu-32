	SECTION .text
get_val:                                ; -- Begin function get_val
                                        ; @get_val
; %bb.0:                                ; %entry
	PUSH GP0
	MOV GP0, GP29
	SUBI GP29, #8
	ST GP23, GP0, #-8
	LD GP2, GP0, #-8
	LLI GP3, #1001
	CMP GP2, GP3
	JLT LBB0_2
	JMP LBB0_1
LBB0_1:                                 ; %if.then
	LLI GP2, #1
	ST GP2, GP0, #-4
	JMP LBB0_7
LBB0_2:                                 ; %if.end
	LD GP2, GP0, #-8
	LUI GP3, #1048575
	ORI GP3, #1048575
	CMP GP2, GP3
	JGT LBB0_4
	JMP LBB0_3
LBB0_3:                                 ; %if.then2
	LLI GP2, #2
	ST GP2, GP0, #-4
	JMP LBB0_7
LBB0_4:                                 ; %if.end3
	LD GP2, GP0, #-8
	LLI GP3, #100
	CMP GP2, GP3
	JNE LBB0_6
	JMP LBB0_5
LBB0_5:                                 ; %if.then5
	LLI GP2, #3
	ST GP2, GP0, #-4
	JMP LBB0_7
LBB0_6:                                 ; %if.end6
	LLI GP2, #0
	ST GP2, GP0, #-4
	JMP LBB0_7
LBB0_7:                                 ; %return
	LD GP28, GP0, #-4
	MOV GP29, GP0
	POP GP0
	RET
                                        ; -- End function
