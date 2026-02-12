; consts
.rom_addr_hi #0
.peripheral_addr_hi #64
.memory_addr_hi #128
.char_newline #10
.char_space #32
.char_exclamation #33
.char_dquote #34
.char_pound #35
.char_dollar #36
.char_percent #37
.char_ampersand #38
.char_quote #39
.char_lparan #40
.char_rparan #41
.char_star #42
.char_plus #43
.char_comma #44
.char_dash #45
.char_period #46
.char_forwardslash #47
.0 #48
.1 #49
.2 #50
.3 #51
.4 #52
.5 #53
.6 #54
.7 #55
.8 #56
.9 #57
.char_colon #58
.char_semicolon #59
.char_lt #60
.char_equals #61
.char_gt #62
.char_question #63
.char_at #64
.A #65
.B #66
.C #67
.D #68
.E #69
.F #70
.G #71
.H #72
.I #73
.J #74
.K #75
.L #76
.M #77
.N #78
.O #79
.P #80
.Q #81
.R #82
.S #83
.T #84
.U #85
.V #86
.W #87
.X #88
.Y #89
.Z #90
.char_leftbrack #91
.char_backslash #92
.char_rightbrack #93
.char_carat #94
.char_underscore #95
.char_grave #96
.a #97
.b #98
.c #99
.d #100
.e #101
.f #102
.g #103
.h #104
.i #105
.j #106
.k #107
.l #108
.m #109
.n #110
.o #111
.p #112
.q #113
.r #114
.s #115
.t #116
.u #117
.v #118
.w #119
.x #120
.y #121
.z #122
.char_leftcurly #123
.char_pipe #124
.char_rightcurly #125
.char_tilde #126


; Load peripheral address into dedicated register
LUI GP31, #64 ; Peripheral address

; Stack allocation
LUI GP29, #255 ; Memory
ADDI GP29, #65535 ; Max memory address

; Heap allocation
LUI GP30, #128 ; Minimum memory address, heap grow upward?

; "Hello there, traveller!\n" 6 words for reply, 1 word for command
; Allocate memory for command and response
LLI GP23, #7 ; Allocate 7 words total 
CALL :malloc ; Obtain the pointer, it's now on GP28

; Add command words
LLI GP0, .i      ; set to .h value 
SHLI GP0, #8     ; Shift left 8  bits 
ADDI GP0, .h     ; Add ascii value for LLI
ST GP0, GP28, #0 ; Store command in first word

LLI GP0, .l
SHLI GP0, #8
ADDI GP0, .l
SHLI GP0, #8
ADDI GP0, .e
SHLI GP0, .h
ST GP0, GP28, #1 ; Store first chunk of reply
LLI GP0, .h
SHLI GP0, #8

SHLI GP

; Calling convention
; GP 
; GP23-26 (4) = function parameters
; 27 = return pointer (to return to calling function entrypoint + 1)
; 28 = return value
; 29 = stack pointer (grows down)
; 30 = heap pointer (grows up)
; 31 = peripheral pointer
malloc: ; Given a number of words to allocate, add that value to the heap pointer and return the old heap pointer value for use in those bounds 
  MOV GP0, GP30  ; Save heap pointer
  ADD GP30, GP23 ; Add GP23 words to heap pointer
  MOV GP28, GP0  ; Mov old heap pointer to return register
  RET            ; return
