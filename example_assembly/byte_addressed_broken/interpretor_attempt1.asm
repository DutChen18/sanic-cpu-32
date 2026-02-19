; consts
.rom_addr_hi #0
.peripheral_addr_hi #64
.memory_addr_hi #128
.char_NUL #0
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

; I want the interpreter to do more than just reply back with some text. So, maybe we need something more generic
; Say I enter add as a command. It should prompt for input again asking for the operands one at a time.
; So, prompt label becomes a function that prompts for input and returns the pointer to the input on heap?
; What problems do I foresee with that approach:
;   - Having to deal with allocating heap each time we fill a word and need to push it
;   - Given a character, we need to convert it to the actual numerical value of the text, not the ascii values.
;   - number 0 is 48 in ascii, number 9 is 57 in ascii
;   - Subtract 48 from the character we pull in, check if it's GE (JGE) 0 and LE (JLE) 9
;   - If the given value is not between those two, we know it's not valid
;   - We reject adding that character unless it's a newline. If it's a newline, that's the end of input.
; Building the number
;   - We're given one digit at a time, starting from the topmost digit. We multiply it by 10, since base 10, then add the next digit to it.
;   - One register for obtaining the next character and converting it into the digit
;   - One register holding the number we are assembling
;   - We can check whether the number would overflow before allowing it to overflow. Copy the value we want to check, 
; "Hello there, traveller!\n" 6 words for reply, 1 word for command
; Allocate memory for command and response
LLI GP23, #26 ; Allocate 26 words for both commands
CALLI :malloc ; Obtain the pointer, it's now on GP28

; Add command words
LLI GP0, .i      ; set to .h value 
SHLI GP0, #16     ; Shift left 24  bits 
ADD GP1, GP0 ; Add value
ADDI GP0, .h     ; Add ascii value for LLI
SHLI GP0, #24    ; Shift left 16 bits
ADD GP1, GP0 ; Add value 
MOV GP10, GP28    ; Copy function return value to somewhere we can control a bit better.
ST GP1, GP10, #0 ; Store command in first word

LLI GP20, .char_newline
LLI GP21, .char_NUL

LLI GP0, .H
SHLI GP0, #8
ADDI GP0, .e
SHLI GP0, #8
ADDI GP0, .l
SHLI GP0, #8
ADDI GP0, .l
ST GP0, GP10, #1 ; Store first chunk of reply

LLI GP0, .o
SHLI GP0, #8
ADDI GP0, .char_space
SHLI GP0, #8
ADDI GP0, .t
SHLI GP0, #8
ADDI GP0, .h
ST GP0, GP10, #2 ; Store second chunk of reply

LLI GP0, .e
SHLI GP0, #8
ADDI GP0, .r
SHLI GP0, #8
ADDI GP0, .e
SHLI GP0, #8
ADDI GP0, .char_comma
ST GP0, GP10, #3 ; Store third chunk of reply
; CALL/RET are 3 cycles each, 6 cycles per fuction call for overhead, plus the push/pops of registers we may or may not care about
; Plus the 1 cycle to MOV into GP23 and the 1 cycle to MOV into GP28 for return value. 6 + 2 cycles minimum - unless the function returns no value?
;
LLI GP0, .char_space ; 2 cycles
SHLI GP0, #8 ; 1 cycle per arithmetic
ADDI GP0, .t 
SHLI GP0, #8 
ADDI GP0, .r
SHLI GP0, #8
ADDI GP0, .a
ST GP0, GP10, #4 ; Store 4th chunk of reply (2 cycles for a store) (6 cycles for arithemtic + 4 cycles = 10 cycles per word created from immediates)
; Roughly 60% performance impact to throw these into a function call, but would clean up the code? 
; Maybe better to just expand a pseudoinstruction?
; Scratch the above - would be WAY better if this was just baked into the ROM as data. Then anywhere it's referenced you expand to the address in ROM

SHLI GP0, #8
ADDI GP0, .e
SHLI GP0, #8
ADDI GP0, .l
SHLI GP0, #8
ADDI GP0, .l
ST GP0, GP10, #5 ; Store 5th chunk of reply

LLI GP0, .e
SHLI GP0, #8
ADDI GP0, .r
SHLI GP0, #8
ADDI GP0, .char_exclamation
SHLI GP0, #8
ADDI GP0, .char_newline
ST GP0, GP10, #6 ; Store final chunk of reply 
; wood, "How much wood could a woodchuck chuck if a woodchuck could chuck wood? \n" 18 words
LLI GP0, .w 
SHLI GP0, #8
ADDI GP0, .o
SHLI GP0, #8
ADDI GP0, .o
SHLI GP0, #8
ADDI GP0, .d
ST GP0, GP10, #7 ; Store next command word

LLI GP0, .H
SHLI GP0, #8
ADDI GP0, .o
SHLI GP0, #8
ADDI GP0, .w
SHLI GP0, #8
ADDI GP0, .char_space
ST GP0, GP10, #8

LLI GP0, .m
SHLI GP0, #8
ADDI GP0, .u
SHLI GP0, #8
ADDI GP0, .c
SHLI GP0, #8
ADDI GP0, .h
ST GP0, GP10, #9

LLI GP0, .char_space 
SHLI GP0, #8
ADDI GP0, .w
SHLI GP0, #8
ADDI GP0, .o
SHLI GP0, #8
ADDI GP0, .o
ST GP0, GP10, #10

LLI GP0, .d
SHLI GP0, #8
ADDI GP0, .char_space
SHLI GP0, #8
ADDI GP0, .c
SHLI GP0, #8
ADDI GP0, .o
ST GP0, GP10, #11

LLI GP0, .u
SHLI GP0, #8
ADDI GP0, .l
SHLI GP0, #8
ADDI GP0, .d
SHLI GP0, #8
ADDI GP0, .char_space
ST GP0, GP10, #12 

LLI GP0, .a
SHLI GP0, #8
ADDI GP0, .char_space
SHLI GP0, #8
ADDI GP0, .w
SHLI GP0, #8
ADDI GP0, .o
ST GP0, GP10, #13

LLI GP0, .o
SHLI GP0, #8
ADDI GP0, .d
SHLI GP0, #8
ADDI GP0, .c
SHLI GP0, #8
ADDI GP0, .h
ST GP0, GP10, #14

LLI GP0, .u
SHLI GP0, #8
ADDI GP0, .c
SHLI GP0, #8
ADDI GP0, .k
SHLI GP0, #8
ADDI GP0, .char_space
ST GP0, GP10, #15

LLI GP0, .c
SHLI GP0, #8
ADDI GP0, .h
SHLI GP0, #8
ADDI GP0, .u
SHLI GP0, #8
ADDI GP0, .c
ST GP0, GP10, #16

LLI GP0, .k
SHLI GP0, #8
ADDI GP0, .char_space
SHLI GP0, #8
ADDI GP0, .i
SHLI GP0, #8
ADDI GP0, .f
ST GP0, GP10, #17

LLI GP0, .char_space
SHLI GP0, #8
ADDI GP0, .a
SHLI GP0, #8
ADDI GP0, .char_space
SHLI GP0, #8
ADDI GP0, .w
ST GP0, GP10, #18

LLI GP0, .o
SHLI GP0, #8
ADDI GP0, .o
SHLI GP0, #8
ADDI GP0, .d
SHLI GP0, #8
ADDI GP0, .c
ST GP0, GP10, #19

LLI GP0, .h
SHLI GP0, #8
ADDI GP0, .u
SHLI GP0, #8
ADDI GP0, .c
SHLI GP0, #8
ADDI GP0, .k
ST GP0, GP10, #20

LLI GP0, .char_space
SHLI GP0, #8
ADDI GP0, .c
SHLI GP0, #8
ADDI GP0, .o
SHLI GP0, #8
ADDI GP0, .u
ST GP0, GP10, #21

LLI GP0, .l
SHLI GP0, #8
ADDI GP0, .d
SHLI GP0, #8
ADDI GP0, .char_space
SHLI GP0, #8
ADDI GP0, .c
ST GP0, GP10, #22

LLI GP0, .h
SHLI GP0, #8
ADDI GP0, .u
SHLI GP0, #8
ADDI GP0, .c
SHLI GP0, #8
ADDI GP0, .k
ST GP0, GP10, #23

LLI GP0, .char_space
SHLI GP0, #8
ADDI GP0, .w
SHLI GP0, #8
ADDI GP0, .o
SHLI GP0, #8
ADDI GP0, .o
ST GP0, GP10, #24

LLI GP0, .d
SHLI GP0, #8
ADDI GP0, .char_question
SHLI GP0, #8
ADDI GP0, .char_NUL
SHLI GP0, #8
ADDI GP0, .char_newline
ST GP0, GP10, #25

JMP :prompt
; Calling convention
; GP 
; GP23-26 (4) = function parameters
; 27 = return pointer (to return to calling function entrypoint + 1)
; 28 = return value
; 29 = stack pointer (grows down)
; 30 = heap pointer (grows up)
; 31 = peripheral pointer
malloc: 
; Given a number of words to allocate, add that value to the heap pointer and return the old heap pointer value for use in those bounds 
  MOV GP0, GP30  ; Save heap pointer
  ADD GP30, GP23 ; Add GP23 words to heap pointer
  MOV GP28, GP0  ; Mov old heap pointer to return register
  RET            ; return

more_to_process:
  ADDI GP0, #1 ; Next address
  JMP :do_loop
display_output:
  MOV GP0, GP23
  do_loop:
  LD GP1, GP0, #0 ; Load first word of reply
  MOV GP2, GP1 ; Copy
  SHRI GP2, #24 ; Shifts right 24 bits, effectively putting top 8 bits at bottom.
  ST GP2, GP31, #1 ; Store character on tty
  MOV GP2, GP1 ; Copy
  SHLI GP2, #8 ; Shift up 8 bits to throw away the top 8 bits
  SHRI GP2, #24 ; Shift down 24 bits to throw away the bottom 16 bits and keep the 3rd highest 8 bits
  ST GP2, GP31, #1 ; store cahracter on tty
  MOV GP2, GP1 ; Copy
  SHLI GP2, #16 ; Shift up 16 bits to throw away top 16 bits
  SHRI GP2, #24 ; Shift down 24 bits to throw away the bottom 8 bits, keeping 2nd highest 8 bits
  ST GP2, GP31, #1
  MOV GP2, GP1 ; Copy
  SHLI GP2, #24 ; Shift up 24 bits to throw away top 24
  SHRI GP2, #24 ; Shift down 24 bits to put it back where it belongs.
  ST GP2, GP31, #1
  CMP GP2, GP20 ; Check if newline
  JNE :more_to_process
  RET

process_input:
  MOV GP0, GP23 ; Copy parameter
  MOV GP2, GP10 ; Copy heap pointer 
  pi_loop:
  LD GP1, GP2, #0 ; Load in the first command word for the command table
  CMP GP0, GP1 ; Check if they match
  JNE :not_match ; Jump away if they don't match
  ADDI GP2, #1 ; Add one to advance pointer to the beginning of the reply 
  MOV GP23, GP2 ; Set parameter to pointer
  CALLI :display_output
  RET
  not_match:
  ADDI GP2, #1 ; Advance pointer
  JMP :pi_loop ; Jump back to beginning of function to try again
prompt:
  LLI GP1, #3 ; Init GP1 to 3, so we shift up by 24 bits for the first one
  LLI GP2, #0 ; Init GP2 to 0, mostly to allow for multiple prompts
  loop:
    LD GP0, GP31, #2    ; Load keyboard next value into register
    CMP GP0, GP21       ; Check if it's empty
    JEQ :loop
    ST GP0, GP31, #1    ; Display it on the screen
    CMP GP0, GP20       ; check if this character is a newline
    JNE :continue_prompt  ; Jump if that character is a newline
    MOV GP23, GP2
    PUSH GP0
    PUSH GP1
    PUSH GP2
    PUSH GP4
    CALLI :process_input  ; Call process input
    POP GP4
    POP GP2
    POP GP1
    POP GP0
    JMP :prompt
  continue_prompt: 
    MOV GP4, GP1 ; Copy counter
    MULI GP4, #8 ; Multiply by bits to shift
    SHL GP0, GP4 ; Shift left the number of bits appropriate
    ADD GP2, GP0 ; We have a value, so add it to the word
    SUBI GP1, #1 ; Counter to adjust the shift value
    JMP :loop
