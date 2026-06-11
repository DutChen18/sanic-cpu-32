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
	LUI GP2, #244140
	ORI GP2, #707072
	CMP GP23, GP2
	LUI GP2, #1024
	LUI GP5, #104857
	LUI GP4, #838860
	LLI GP3, #10
	JLTU LBB1_2
	JMP LBB1_1
LBB1_2:                                 ; %if.end
	LUI GP6, #24414
	ORI GP6, #385280
	CMP GP23, GP6
	JLTU LBB1_4
	JMP LBB1_3
LBB1_4:                                 ; %if.end.1
	LUI GP6, #2441
	ORI GP6, #562816
	CMP GP23, GP6
	JLTU LBB1_6
	JMP LBB1_5
LBB1_6:                                 ; %if.end.2
	LLI GP6, #1000000
	CMP GP23, GP6
	JLTU LBB1_8
	JMP LBB1_7
LBB1_8:                                 ; %if.end.3
	LLI GP6, #100000
	CMP GP23, GP6
	JLTU LBB1_10
	JMP LBB1_9
LBB1_10:                                ; %if.end.4
	LLI GP6, #10000
	CMP GP23, GP6
	JLTU LBB1_12
	JMP LBB1_11
LBB1_12:                                ; %if.end.5
	LLI GP6, #1000
	CMP GP23, GP6
	JLTU LBB1_14
	JMP LBB1_13
LBB1_14:                                ; %if.end.6
	LLI GP6, #100
	CMP GP23, GP6
	JLTU LBB1_16
	JMP LBB1_15
LBB1_16:                                ; %if.end.7
	CMP GP23, GP3
	JLTU LBB1_18
	JMP LBB1_17
LBB1_18:                                ; %if.end.8
	LLI GP5, #0
	CMP GP23, GP5
	JEQ LBB1_20
	JMP LBB1_19
LBB1_1:                                 ; %if.end.thread
	MOV GP6, GP2
	ORI GP6, #1
	MOV GP7, GP23
	SHRI GP7, #9
	MULI GP7, #281475
	AMOV GP7
	SHRI GP7, #7
	ORI GP7, #48
	STB GP7, GP6, #0
LBB1_3:                                 ; %if.end.1.thread
	LUI GP6, #351843
	ORI GP6, #408457
	MOV GP7, GP23
	MUL GP7, GP6
	AMOV GP6
	SHRI GP6, #25
	MOV GP7, GP5
	ORI GP7, #629146
	MOV GP8, GP6
	MUL GP8, GP7
	AMOV GP7
	MULI GP7, #10
	SUB GP6, GP7
	ORI GP6, #48
	MOV GP7, GP2
	ORI GP7, #1
	STB GP6, GP7, #0
LBB1_5:                                 ; %if.end.2.thread
	LUI GP6, #439804
	ORI GP6, #1034859
	MOV GP7, GP23
	MUL GP7, GP6
	AMOV GP6
	SHRI GP6, #22
	MOV GP7, GP5
	ORI GP7, #629146
	MOV GP8, GP6
	MUL GP8, GP7
	AMOV GP7
	MULI GP7, #10
	SUB GP6, GP7
	ORI GP6, #48
	MOV GP7, GP2
	ORI GP7, #1
	STB GP6, GP7, #0
LBB1_7:                                 ; %if.end.3.thread
	LUI GP6, #274877
	ORI GP6, #777859
	MOV GP7, GP23
	MUL GP7, GP6
	AMOV GP6
	SHRI GP6, #18
	MOV GP7, GP5
	ORI GP7, #629146
	MOV GP8, GP6
	MUL GP8, GP7
	AMOV GP7
	MULI GP7, #10
	SUB GP6, GP7
	ORI GP6, #48
	MOV GP7, GP2
	ORI GP7, #1
	STB GP6, GP7, #0
LBB1_9:                                 ; %if.end.4.thread
	LUI GP6, #42949
	ORI GP6, #809669
	MOV GP7, GP23
	SHRI GP7, #5
	MUL GP7, GP6
	AMOV GP6
	SHRI GP6, #7
	MOV GP7, GP5
	ORI GP7, #629146
	MOV GP8, GP6
	MUL GP8, GP7
	AMOV GP7
	MULI GP7, #10
	SUB GP6, GP7
	ORI GP6, #48
	MOV GP7, GP2
	ORI GP7, #1
	STB GP6, GP7, #0
LBB1_11:                                ; %if.end.5.thread
	LUI GP6, #858993
	ORI GP6, #464729
	MOV GP7, GP23
	MUL GP7, GP6
	AMOV GP6
	SHRI GP6, #13
	MOV GP7, GP5
	ORI GP7, #629146
	MOV GP8, GP6
	MUL GP8, GP7
	AMOV GP7
	MULI GP7, #10
	SUB GP6, GP7
	ORI GP6, #48
	MOV GP7, GP2
	ORI GP7, #1
	STB GP6, GP7, #0
LBB1_13:                                ; %if.end.6.thread
	LUI GP6, #67108
	ORI GP6, #150995
	MOV GP7, GP23
	MUL GP7, GP6
	AMOV GP6
	SHRI GP6, #6
	MOV GP7, GP5
	ORI GP7, #629146
	MOV GP8, GP6
	MUL GP8, GP7
	AMOV GP7
	MULI GP7, #10
	SUB GP6, GP7
	ORI GP6, #48
	MOV GP7, GP2
	ORI GP7, #1
	STB GP6, GP7, #0
LBB1_15:                                ; %if.end.7.thread
	LUI GP6, #335544
	ORI GP6, #754975
	MOV GP7, GP23
	MUL GP7, GP6
	AMOV GP6
	SHRI GP6, #5
	MOV GP7, GP5
	ORI GP7, #629146
	MOV GP8, GP6
	MUL GP8, GP7
	AMOV GP7
	MULI GP7, #10
	SUB GP6, GP7
	ORI GP6, #48
	MOV GP7, GP2
	ORI GP7, #1
	STB GP6, GP7, #0
LBB1_17:                                ; %if.end.8.thread
	MOV GP6, GP4
	ORI GP6, #838861
	MOV GP7, GP23
	MUL GP7, GP6
	AMOV GP6
	SHRI GP6, #3
	ORI GP5, #629146
	MOV GP7, GP6
	MUL GP7, GP5
	AMOV GP5
	MULI GP5, #10
	SUB GP6, GP5
	ORI GP6, #48
	MOV GP5, GP2
	ORI GP5, #1
	STB GP6, GP5, #0
LBB1_19:                                ; %if.then.9
	ORI GP4, #838861
	MOV GP5, GP23
	MUL GP5, GP4
	AMOV GP4
	SHRI GP4, #3
	MULI GP4, #10
	SUB GP23, GP4
	ORI GP23, #48
	MOV GP4, GP2
	ORI GP4, #1
	STB GP23, GP4, #0
LBB1_20:                                ; %if.end.9
	ORI GP2, #1
	STB GP3, GP2, #0
	RET
                                        ; -- End function
	SECTION .main
main:                                   ; -- Begin function main
                                        ; @main
; %bb.0:                                ; %entry
	LLI GP21, #1
	LLI GP2, #0
	LUI GP3, #244140
	ORI GP3, #707071
	LUI GP4, #24414
	ORI GP4, #385279
	LUI GP5, #2441
	ORI GP5, #562815
	LLI GP6, #999999
	LLI GP7, #99999
	LLI GP8, #9999
	LLI GP9, #999
	LLI GP10, #99
	LLI GP11, #9
	LUI GP12, #1024
	ORI GP12, #1
	LLI GP13, #10
	LUI GP14, #838860
	ORI GP14, #838861
	LUI GP15, #104857
	ORI GP15, #629146
	LUI GP16, #335544
	ORI GP16, #754975
	LUI GP17, #67108
	ORI GP17, #150995
	LUI GP18, #858993
	ORI GP18, #464729
	MOV GP22, GP2
	MOV GP19, GP2
	JMP LBB2_1
LBB2_23:                                ;   in Loop: Header=BB2_1 Depth=1
	MOV GP21, GP20
LBB2_24:                                ; %if.end.sink.split.sink.split.sink.split.sink.split.sink.split.sink.split.sink.split.sink.split.sink.split.sink.split
                                        ;   in Loop: Header=BB2_1 Depth=1
	MOV GP23, GP20
	SHRI GP23, #9
	MULI GP23, #281475
	AMOV GP23
	SHRI GP23, #7
	ORI GP23, #48
	STB GP23, GP12, #0
LBB2_25:                                ; %if.end.sink.split.sink.split.sink.split.sink.split.sink.split.sink.split.sink.split.sink.split.sink.split
                                        ;   in Loop: Header=BB2_1 Depth=1
	LUI GP23, #351843
	ORI GP23, #408457
	MOV GP24, GP20
	MUL GP24, GP23
	AMOV GP23
	SHRI GP23, #25
	MOV GP24, GP23
	MUL GP24, GP15
	AMOV GP24
	MULI GP24, #10
	SUB GP23, GP24
	ORI GP23, #48
	STB GP23, GP12, #0
LBB2_26:                                ; %if.end.sink.split.sink.split.sink.split.sink.split.sink.split.sink.split.sink.split.sink.split
                                        ;   in Loop: Header=BB2_1 Depth=1
	LUI GP23, #439804
	ORI GP23, #1034859
	MOV GP24, GP20
	MUL GP24, GP23
	AMOV GP23
	SHRI GP23, #22
	MOV GP24, GP23
	MUL GP24, GP15
	AMOV GP24
	MULI GP24, #10
	SUB GP23, GP24
	ORI GP23, #48
	STB GP23, GP12, #0
LBB2_27:                                ; %if.end.sink.split.sink.split.sink.split.sink.split.sink.split.sink.split.sink.split
                                        ;   in Loop: Header=BB2_1 Depth=1
	LUI GP23, #274877
	ORI GP23, #777859
	MOV GP24, GP20
	MUL GP24, GP23
	AMOV GP23
	SHRI GP23, #18
	MOV GP24, GP23
	MUL GP24, GP15
	AMOV GP24
	MULI GP24, #10
	SUB GP23, GP24
	ORI GP23, #48
	STB GP23, GP12, #0
LBB2_28:                                ; %if.end.sink.split.sink.split.sink.split.sink.split.sink.split.sink.split
                                        ;   in Loop: Header=BB2_1 Depth=1
	LUI GP23, #42949
	ORI GP23, #809669
	MOV GP24, GP20
	SHRI GP24, #5
	MUL GP24, GP23
	AMOV GP23
	SHRI GP23, #7
	MOV GP24, GP23
	MUL GP24, GP15
	AMOV GP24
	MULI GP24, #10
	SUB GP23, GP24
	ORI GP23, #48
	STB GP23, GP12, #0
LBB2_29:                                ; %if.end.sink.split.sink.split.sink.split.sink.split.sink.split
                                        ;   in Loop: Header=BB2_1 Depth=1
	MOV GP23, GP20
	MUL GP23, GP18
	AMOV GP23
	SHRI GP23, #13
	MOV GP24, GP23
	MUL GP24, GP15
	AMOV GP24
	MULI GP24, #10
	SUB GP23, GP24
	ORI GP23, #48
	STB GP23, GP12, #0
LBB2_30:                                ; %if.end.sink.split.sink.split.sink.split.sink.split
                                        ;   in Loop: Header=BB2_1 Depth=1
	MOV GP23, GP20
	MUL GP23, GP17
	AMOV GP23
	SHRI GP23, #6
	MOV GP24, GP23
	MUL GP24, GP15
	AMOV GP24
	MULI GP24, #10
	SUB GP23, GP24
	ORI GP23, #48
	STB GP23, GP12, #0
LBB2_31:                                ; %if.end.sink.split.sink.split.sink.split
                                        ;   in Loop: Header=BB2_1 Depth=1
	MOV GP23, GP20
	MUL GP23, GP16
	AMOV GP23
	SHRI GP23, #5
	MOV GP24, GP23
	MUL GP24, GP15
	AMOV GP24
	MULI GP24, #10
	SUB GP23, GP24
	ORI GP23, #48
	STB GP23, GP12, #0
LBB2_32:                                ; %if.end.sink.split.sink.split
                                        ;   in Loop: Header=BB2_1 Depth=1
	MOV GP23, GP20
	MUL GP23, GP14
	AMOV GP23
	SHRI GP23, #3
	MOV GP24, GP23
	MUL GP24, GP15
	AMOV GP24
	MULI GP24, #10
	SUB GP23, GP24
	ORI GP23, #48
	STB GP23, GP12, #0
LBB2_33:                                ; %if.end.sink.split
                                        ;   in Loop: Header=BB2_1 Depth=1
	MOV GP23, GP20
	MUL GP23, GP14
	AMOV GP23
	SHRI GP23, #3
	MULI GP23, #10
	SUB GP20, GP23
	ORI GP20, #48
	STB GP20, GP12, #0
LBB2_52:                                ; %if.end
                                        ;   in Loop: Header=BB2_1 Depth=1
	STB GP13, GP12, #0
	ADDI GP19, #1
LBB2_1:                                 ; %while.cond
                                        ; =>This Inner Loop Header: Depth=1
	MOV GP20, GP21
	ADD GP20, GP22
	MOV GP23, GP19
	ANDI GP23, #1
	CMP GP23, GP2
	JNE LBB2_22
LBB2_2:                                 ; %if.then
                                        ;   in Loop: Header=BB2_1 Depth=1
	CMP GP20, GP3
	JGTU LBB2_3
LBB2_4:                                 ; %if.end.i
                                        ;   in Loop: Header=BB2_1 Depth=1
	CMP GP20, GP4
	JGTU LBB2_5
LBB2_6:                                 ; %if.end.1.i
                                        ;   in Loop: Header=BB2_1 Depth=1
	CMP GP20, GP5
	JGTU LBB2_7
LBB2_8:                                 ; %if.end.2.i
                                        ;   in Loop: Header=BB2_1 Depth=1
	CMP GP20, GP6
	JGTU LBB2_9
LBB2_10:                                ; %if.end.3.i
                                        ;   in Loop: Header=BB2_1 Depth=1
	CMP GP20, GP7
	JGTU LBB2_11
LBB2_12:                                ; %if.end.4.i
                                        ;   in Loop: Header=BB2_1 Depth=1
	CMP GP20, GP8
	JGTU LBB2_13
LBB2_14:                                ; %if.end.5.i
                                        ;   in Loop: Header=BB2_1 Depth=1
	CMP GP20, GP9
	JGTU LBB2_15
LBB2_16:                                ; %if.end.6.i
                                        ;   in Loop: Header=BB2_1 Depth=1
	CMP GP20, GP10
	JGTU LBB2_17
LBB2_18:                                ; %if.end.7.i
                                        ;   in Loop: Header=BB2_1 Depth=1
	CMP GP20, GP11
	JGTU LBB2_19
LBB2_20:                                ; %if.end.8.i
                                        ;   in Loop: Header=BB2_1 Depth=1
	CMP GP20, GP2
	MOV GP22, GP20
	JEQ LBB2_21
	JMP LBB2_33
LBB2_21:                                ;   in Loop: Header=BB2_1 Depth=1
	MOV GP22, GP20
	JMP LBB2_52
LBB2_22:                                ; %if.else
                                        ;   in Loop: Header=BB2_1 Depth=1
	CMP GP20, GP3
	JGTU LBB2_23
LBB2_34:                                ; %if.end.i50
                                        ;   in Loop: Header=BB2_1 Depth=1
	CMP GP20, GP4
	JGTU LBB2_35
LBB2_36:                                ; %if.end.1.i52
                                        ;   in Loop: Header=BB2_1 Depth=1
	CMP GP20, GP5
	JGTU LBB2_37
LBB2_38:                                ; %if.end.2.i54
                                        ;   in Loop: Header=BB2_1 Depth=1
	CMP GP20, GP6
	JGTU LBB2_39
LBB2_40:                                ; %if.end.3.i56
                                        ;   in Loop: Header=BB2_1 Depth=1
	CMP GP20, GP7
	JGTU LBB2_41
LBB2_42:                                ; %if.end.4.i58
                                        ;   in Loop: Header=BB2_1 Depth=1
	CMP GP20, GP8
	JGTU LBB2_43
LBB2_44:                                ; %if.end.5.i60
                                        ;   in Loop: Header=BB2_1 Depth=1
	CMP GP20, GP9
	JGTU LBB2_45
LBB2_46:                                ; %if.end.6.i62
                                        ;   in Loop: Header=BB2_1 Depth=1
	CMP GP20, GP10
	JGTU LBB2_47
LBB2_48:                                ; %if.end.7.i64
                                        ;   in Loop: Header=BB2_1 Depth=1
	CMP GP20, GP11
	JGTU LBB2_49
LBB2_50:                                ; %if.end.8.i66
                                        ;   in Loop: Header=BB2_1 Depth=1
	LLI GP21, #0
	CMP GP20, GP21
	MOV GP21, GP20
	JEQ LBB2_51
	JMP LBB2_33
LBB2_51:                                ;   in Loop: Header=BB2_1 Depth=1
	MOV GP21, GP20
	JMP LBB2_52
LBB2_3:                                 ;   in Loop: Header=BB2_1 Depth=1
	MOV GP22, GP20
	JMP LBB2_24
LBB2_5:                                 ;   in Loop: Header=BB2_1 Depth=1
	MOV GP22, GP20
	JMP LBB2_25
LBB2_35:                                ;   in Loop: Header=BB2_1 Depth=1
	MOV GP21, GP20
	JMP LBB2_25
LBB2_7:                                 ;   in Loop: Header=BB2_1 Depth=1
	MOV GP22, GP20
	JMP LBB2_26
LBB2_37:                                ;   in Loop: Header=BB2_1 Depth=1
	MOV GP21, GP20
	JMP LBB2_26
LBB2_9:                                 ;   in Loop: Header=BB2_1 Depth=1
	MOV GP22, GP20
	JMP LBB2_27
LBB2_39:                                ;   in Loop: Header=BB2_1 Depth=1
	MOV GP21, GP20
	JMP LBB2_27
LBB2_11:                                ;   in Loop: Header=BB2_1 Depth=1
	MOV GP22, GP20
	JMP LBB2_28
LBB2_41:                                ;   in Loop: Header=BB2_1 Depth=1
	MOV GP21, GP20
	JMP LBB2_28
LBB2_13:                                ;   in Loop: Header=BB2_1 Depth=1
	MOV GP22, GP20
	JMP LBB2_29
LBB2_43:                                ;   in Loop: Header=BB2_1 Depth=1
	MOV GP21, GP20
	JMP LBB2_29
LBB2_15:                                ;   in Loop: Header=BB2_1 Depth=1
	MOV GP22, GP20
	JMP LBB2_30
LBB2_45:                                ;   in Loop: Header=BB2_1 Depth=1
	MOV GP21, GP20
	JMP LBB2_30
LBB2_17:                                ;   in Loop: Header=BB2_1 Depth=1
	MOV GP22, GP20
	JMP LBB2_31
LBB2_47:                                ;   in Loop: Header=BB2_1 Depth=1
	MOV GP21, GP20
	JMP LBB2_31
LBB2_19:                                ;   in Loop: Header=BB2_1 Depth=1
	MOV GP22, GP20
	JMP LBB2_32
LBB2_49:                                ;   in Loop: Header=BB2_1 Depth=1
	MOV GP21, GP20
	JMP LBB2_32
                                        ; -- End function
