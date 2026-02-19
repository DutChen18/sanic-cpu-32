; consts
.rom_addr_hi #0
.peripheral_addr_hi #64
.memory_addr_hi #128
.char_NUL #0
.char_Backspace #8
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

LLI GP20, .char_newline
LLI GP21, .char_NUL
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
; pointer to command - 1 word + nul word to terminate array
; pointer to cmd word - 1 word
; pointer to cmd prompts arr - 1 word
; pointer to 1st prompt, 2nd prompt, 3rd prompt, and null word - 4 words
; word: "add\0": 1 word (includes nul byte)
; "Enter first number: " 6 words (5 + null)
; "Enter second number: " 6 words (5 + space and null)
; "Result: " 3 words (last word for nul)
; 15 words total for add command
LLI GP23, #96 ; Allocate for 1 command word and the addition prompts
CALLI :malloc ; Obtain the pointer, it's now on GP28

MOV GP10, GP28   ; Move heap pointer result into new reg, it's 24 words, we know.
LLI GP23, #4 ; Allocate another on heap for general prompt
CALLI :malloc
MOV GP22, GP28 ; Put pointer on GP22
MOV GP11, GP10   ; Get pointer to command struct array
ADDI GP11, #2    ; Add 2 to get the true pointer
ST GP11, GP10, #0 ; Store pointer to the command struct

MOV GP12, GP11   ; Copy command struct pointer
                 ; Struct needs 2 words, so +2 begins the word (1 length in our case)
                 ; +4 begins prompt pointers
ADDI GP12, #2    ; Add 2 to get to word
ST GP12, GP11, #0 ; Store pointer to command word
MOV GP12, GP11   ; Copy command struct pointer
ADDI GP12, #3    ; Add 3 to get to prompt pointers
ST GP12, GP11, #1 ; Store pointer to command prompts

; Set prompt pointers
LLI GP0, .char_gt
SHLI GP0, #8
ADDI GP0, .char_space
SHLI GP0, #8
ST GP0, GP22, #0 ; Store in prompt pointer area

MOV GP0, GP10    ; Copy heap pointer
ADDI GP0, #9     ; Set to first prompt pointer
ST GP0, GP10, #5 ; Store as first prompt pointer
MOV GP0, GP10    ; Copy pointer again
ADDI GP0, #15
ST GP0, GP10, #6
MOV GP0, GP10
ADDI GP0, #21
ST GP0, GP10, #7
; GP10, #0 - Pointer to command struct
; GP10, #1 - Null
; GP10, #2 - Pointer to command word
; GP10, #3 - Pointer to command prompt
; GP10, #4 - Command word (includes null)
; GP10, #5 - Command prompt pointer
; GP10, #6 - Command prompt pointer
; GP10, #7 - Command prompt pointer
; GP10, #8 - Null
; GP10, #9-14 - Command prompt 1 (last word is null)
; GP10, #15-20 - Command prompt 2 (last word includes Null)
; GP10, #21-23 - Command prompt 3 (last word includes null)

; Add command words
LLI GP0, .a      ; set to .h value 
SHLI GP0, #8     ; Shift left 24  bits 
ADDI GP0, .d     ; Add ascii value for LLI
SHLI GP0, #8     ; Shift left 16 bits
ADDI GP0, .d     ; Add value 
SHLI GP0, #8     ; Shift one last time, bottom byte is null

MOV GP1, GP10    ; copy heap pointer
ADDI GP1, #4     ; Set to command word value
ST GP0, GP1, #0  ; Store it

MOV GP1, GP10    ; Copy heap pointer
ADDI GP1, #9     ; Set to first word of first prompt
LLI GP0, .E
SHLI GP0, #8
ADDI GP0, .n
SHLI GP0, #8
ADDI GP0, .t
SHLI GP0, #8
ADDI GP0, .e
ST GP0, GP1, #0

LLI GP0, .r
SHLI GP0, #8
ADDI GP0, .char_space
SHLI GP0, #8
ADDI GP0, .f
SHLI GP0, #8
ADDI GP0, .i
ST GP0, GP1, #1

LLI GP0, .r
SHLI GP0, #8
ADDI GP0, .s
SHLI GP0, #8
ADDI GP0, .t
SHLI GP0, #8
ADDI GP0, .char_space
ST GP0, GP1, #2

LLI GP0, .n
SHLI GP0, #8
ADDI GP0, .u
SHLI GP0, #8
ADDI GP0, .m
SHLI GP0, #8
ADDI GP0, .b
ST GP0, GP1, #3

LLI GP0, .e
SHLI GP0, #8
ADDI GP0, .r
SHLI GP0, #8
ADDI GP0, .char_colon
SHLI GP0, #8
ADDI GP0, .char_space
ST GP0, GP1, #4

MOV GP1, GP10
ADDI GP1, #15

LLI GP0, .E
SHLI GP0, #8
ADDI GP0, .n
SHLI GP0, #8
ADDI GP0, .t
SHLI GP0, #8
ADDI GP0, .e
ST GP0, GP1, #0

LLI GP0, .r
SHLI GP0, #8
ADDI GP0, .char_space
SHLI GP0, #8
ADDI GP0, .s
SHLI GP0, #8
ADDI GP0, .e
ST GP0, GP1, #1

LLI GP0, .c
SHLI GP0, #8
ADDI GP0, .o
SHLI GP0, #8
ADDI GP0, .n
SHLI GP0, #8 
ADDI GP0, .d
ST GP0, GP1, #2

LLI GP0, .char_space
SHLI GP0, #8
ADDI GP0, .n
SHLI GP0, #8
ADDI GP0, .u
SHLI GP0, #8
ADDI GP0, .m
ST GP0, GP1, #3

LLI GP0, .b
SHLI GP0, #8
ADDI GP0, .e
SHLI GP0, #8
ADDI GP0, .r
SHLI GP0, #8
ADDI GP0, .char_colon
ST GP0, GP1, #4

LLI GP0, .char_space
SHLI GP0, #24
ST GP0, GP1, #5

MOV GP1, GP10
ADDI GP1, #21

LLI GP0, .R
SHLI GP0, #8
ADDI GP0, .e
SHLI GP0, #8
ADDI GP0, .s
SHLI GP0, #8
ADDI GP0, .u
ST GP0, GP1, #0

LLI GP0, .l
SHLI GP0, #8
ADDI GP0, .t
SHLI GP0, #8
ADDI GP0, .char_colon
SHLI GP0, #8
ADDI GP0, .char_space
ST GP0, GP1, #1
JMP :main_loop

find_match:
  ; Iterate over the command words pointers, sub-iterate on those pointers until we find a null character.
  ; Each sub-loop, check if that word matches the word given by the user at that offset.
  ; If the word does match, continue. If not, early exit and have the outer loop continue.
  ; If we find a null character, and it's matched up to this point, consider it a pass.
  ; Command word start is really like... We're looping over command structs, and the first pointer in a command struct is the pointer.
  ; So instead of simply looping and doing LD GP1, <command word pointer> 
  ; We have to first retrieve the command word pointer from the command struct pointer
  MOV GP2, GP24 ; Copy beginning of command pointers array
  MOV GP3, GP23 ; Copy beginning of entered command
  ; GP7 will be the "non-zero means we didn't match" reg, because we need to check if there's a null byte at the end of the word so we know to stop scanning.
  outer_loop:
    CMP GP2, GP21   ; Check if the pointer is null
    JEQ :fail_exit  ; Early exit if we reached the end of the pointers array
    LD GP4, GP2, #0 ; Load pointer to command struct
    LD GP5, GP4, #0 ; Load command word pointer
    LD GP1, GP5, #0 ; Load command word
    LD GP0, GP3, #0 ; Load first entered command word
    inner_loop:
      LLI GP13, #3 ; Shift byte amount
      LLI GP14, #8 ; Byte
      MUL GP14, GP13 ; Multiply to get shift amount
      byte_loop:
        MOV GP11, GP0
        MOV GP12, GP1
        SHR GP11, GP14
        SHR GP12, GP14
        CMP GP11, GP12
        JEQ :match
        LLI GP7, #1 ; Didn't match
        match:
        SUBI GP13, #1
        CMP GP13, GP21 ; Check if counter is less than 0
        JGE :byte_loop ; Keep getting bytes from this word
        CMP GP12, GP21 ; Check if it's zero (end)
        JNE :more_bytes
        ; We reached the end of the command word we're checking.
        CMP GP7, GP21  ; Check if it's zero
        JNE :not_match ; Jump away if it didn't match
        MOV GP28, GP4  ; Pointer to matching command
        RET
        more_bytes:
          ADDI GP3, #1 ; Add 1 to get next word
          ADDI GP5, #1 ; Add 1 to get next word
          LD GP0, GP3, #0 ; Load entered command next word
          LD GP1, GP5, #0 ; Load next command word
          JMP :inner_loop

  
  not_match:
    ADDI GP2, #1
    MOV GP3, GP23
    JMP :outer_loop ; Try again
  success_exit:
    MOV GP28, GP4 ; Copy command struct pointer to return
    RET
  fail_exit:
    LLI GP28, #0
    RET



; All words and prompts have been stored, now.
; Now, we do the main loop, where we get some input and find a match for it.
cmd_fail:
; TODO: display output with command not found text
main_loop:
MOV GP23, GP22 ; Copy GP22 to parameter
CALLI :get_input
; GP28 now contains the pointer to the given input
MOV GP0, GP28  ; Copy return value
MOV GP23, GP0 ; Copy return value to next function call
MOV GP24, GP10
PUSH GP10 ; Stack: Command struct pointer
CALLI :find_match
CMP GP28,  GP21 ; Check if it's zero (no pointer found to matching command struct)
JEQ :cmd_fail  ; Jump back to get input again
; We got a match, so this is a pointer to the struct. 
; For the add command, we're given a sequence of prompts, and we should take in values to add together.
; But, in future, this ought to be more generic with prompt types and what kind of input we're expecting, and what we do with it.
MOV GP0, GP28 ; Get pointer to struct
LD GP1, GP0, #1 ; Load the pointer from the #1 offset from that pointer, which is the prompts pointer
LD GP23, GP1, #0 ; Load first prompt pointer
PUSH GP0 ; Struct pointer, command struct array pointer 
CALLI :get_input ; Get input again
MOV GP23, GP28 ; Pointer to text of value we want
CALLI :ascii_to_binary
POP GP0 ; command struct array pointer
LD GP1, GP0, #1 ; Load the pointer again
LD GP23, GP1, #1 ; Second prompt pointer
PUSH GP0 ; struct pointer, command struct array pointers
PUSH GP28 ; binary_val, struct pointer, command struct array pointers
CALLI :get_input
MOV GP23, GP28 ; Pointer to text of value we want
CALLI :ascii_to_binary
POP GP5       ; Pop 1st value to GP5 stack: struct, command struct array pointers
MOV GP6, GP28 ; Mov 2nd value to GP6

ADD GP5, GP6  ; Add them together
LLI GP23, #3  ; malloc 3 words
CALLI :malloc
MOV GP10, GP28 ; Copy pointer to beginning of array
MOV GP11, GP10 ; Copy pointer so we can modify GP10
; 11101110011010 1100101000000000 == 1B
; LLI 51712
; LUI 15258
LUI GP1, #15258
ADDI GP1, #51712 ; Build 1B
LLI GP2, #-1     ; Error value
LLI GP6, #0      ; Init word we're building
LLI GP8, #0      ; Min value for counter
LLI GP9, #1      ; Min value for divisor
build_ascii:
  ; GP5 is our number
  ; Start with 1B, reduce it until we find the first legit value, then loop until we are at #1 and we've built our value at that point
  ; Max word length it could be: 10 chars + null = 11 = 3 words
  MOV GP23, GP5
  MOV GP24, GP1
  PUSH GP5
  PUSH GP2
  PUSH GP1
  CALLI :get_digit
  POP GP1
  POP GP2
  POP GP5
  CMP GP28, GP2
  JEQ :next_digit
  ADDI GP28, #48 ; Add 48
  ADD GP6, GP28 ; Add char to value
  CMP GP7, GP8   ; Check counter
  JEQ :next_word
  SUBI GP7, #1   ; Subtract 1 from counter
  SHLI GP6, #8   ; Shift left 1 byte for next char
  next_digit:
    CMP GP1, GP9     ; Check if we're at divisor of 1
    JEQ :end_build_ascii ; Done building
    DIVI GP1, #10    ; Divide divisor by 10
    JMP :build_ascii ; Loop again
  next_word:
    ST GP6, GP10, #0 ; Store the word
    ADDI GP10, #1    ; Add 1 to the pointer for next word
    LLI GP6, #0      ; Re-init
    LLI GP7, #3      ; Re-init counter
    JMP :next_digit  ; Proceed
  end_build_ascii:
    CMP GP7, GP8 ; Check counter to see if we can put null in the current word, or if we need another word
    JNE :skip_new_word
    ST GP6, GP10, #0 ; Store the word
    LLI GP6, #0 ; Re-init
    ST GP6, GP10, #1 ; Add 1 to the pointer for next word
    JMP :done_ascii
    skip_new_word:
    ST GP6, GP10, #0 ; Store the final word
  done_ascii:
    POP GP0 ;
    LD GP1, GP0, #1 ; prompt array pointer
    LD GP23, GP1, #2 ; Third prompt pointer 
    CALLI :display_output
    MOV GP23, GP11 ; Put number in there
    CALLI :display_output
    ST GP20, GP31, #1 ; New Line
    POP GP10
    JMP :main_loop ; Next command

get_digit:
  ; GP23 - Full number
  ; GP24 - Desired divisor (1, 10, 100, 1000, 10000, 100000, 1000000, 10000000, 100000000, 1000000000) (32-bit max is 4B so can't do 10B)
  CMP GP23, GP24 ; Compare the values
  JLT :too_large ; divisor too large to get a digit
  MOV GP0, GP23 ; Get full number
  DIV GP0, GP24 ; Divide it
  DIVI GP0, #10 ; Divide by 10
  AMOV GP28     ; Get the remainder
  RET           ; Return the remainder
  too_large:
    LLI GP28, #-1 ; Set to -1 to indicate error
    RET


; Now, to display it on screen, we need to convert each digit to ASCII again looooool fun fun fun
; How would you even do this in concept...
; Given value 1234:
; produce "1" "2" "3" "4" "\NUL"
; We have the number in binary format, so bitshifting won't help that much
; How would I do this in C?
; int value_to_convert = 1234;
; /1000
; /100
; /10
; /
; 2026-02-13 - Where I left off:
; I need to change how I do these command words.
; Rather than having the prompt -> reply -> prompt for example, i need to change it so that I can command phrases longer than one word.
; I need to point to an array of pointers, each pointer points to a string (char array) and I loop over those instead of looping over the whole heap
; Array of pointers, loop over the array of pointers to check command words
; Also need an array of prompts for each command word to reference. Well, that'd be another array of pointers for each command.
; I guess the data structure would look like:
;
;  *command[] commands;
; 
; struct command{
;   *int cmd_word_addr;
;   *char[] cmd_prompt_addr;
; }
; So...
; First array we're given to loop over are pointers to the command struct
; Then we're given a command_word_addr in the 1st cell, a pointer to the cmd_prompt_addr array in the 2nd cell
; cmd_promtp_addr is another array like the first array. But it's pointers to each prompt (null terminated)
; struct cmd_prompts{
;   
; }
; Calling convention
; GP 
; GP23-26 (4) = function parameters
; 27 = return pointer (to return to calling function entrypoint + 1)
; 28 = return value
; 29 = stack pointer (grows down)
; 30 = heap pointer (grows up)
; 31 = peripheral pointer
;
; Below function takes a pointer to a char array, and builds an actual number from them.
; i.e. given ascii characters "1234", it will produce GP28 containing 0x4D2
ascii_to_binary:
LLI GP5, #0
digit_loop:
  LD GP3, GP23, #0 ; Load the word 49504848
  MOV GP4, GP3    ; Copy it
  SHRI GP4, #24   ; Get top character 49
  CMP GP4, GP21   ; Check if null
  JEQ :end_of_number ; Jump to end
  SUBI GP4, #48   ; Subtract 48 to get the digit value 1
  MULI GP5, #10   ; Multiply by 10 as we add a digit 0 x 10 = 0
  ADD GP5, GP4    ; Add to GP5 0 + 1 = 1
  MOV GP4, GP3    ; Copy again 49504848
  SHLI GP4, #8    ; Shift up 8 bits to discard the top 8 50484800
  SHRI GP4, #24   ; Shift down 24 (there's 8 bits left) 00000050
  CMP GP4, GP21   ; Check if null character 
  JEQ :end_of_number ; No more to process 
  MULI GP5, #10   ; Multiply current value by 10 again 1 x 10 = 10
  SUBI GP4, #48   ; Subtract 48 from current character 50-48 = 2
  ADD GP5, GP4    ; Add digit 10 + 2 = 12
  MOV GP4, GP3    ; copy again 49504848
  SHLI GP4, #16   ; Discard top 16 bits 48480000
  SHRI GP4, #24    ; Discard bottom 8 bits 00000048 
  CMP GP4, GP21   ; Check if null character 
  JEQ :end_of_number
  MULI GP5, #10   ; Multiply current value by 10 again 12 x 10 = 120
  SUBI GP4, #48   ; 
  ADD GP5, GP4    ; Add digit 120 + 0 = 120
  MOV GP4, GP3    ; Copy again 49584848
  SHLI GP4, #24   ; Discard top 24 bits 48000000
  SHRI GP4, #24   ; Put bottom 8 bits back in bottom 8 00000048
  CMP GP4, GP21   ; check if null character No
  JEQ :end_of_number
  MULI GP5, #10   ; Multiply current value by 10 again 120 x 10 = 1200
  SUBI GP4, #48   ; 48-48 = 0
  ADD GP5, GP4    ; Add digit 1200 + 0 = 1200
  ADDI GP23, #1    ; Add 1 to the input pointer 
  JMP :digit_loop ; Loop again
  
  end_of_number: 
    MOV GP28, GP5   ; Set return value to GP5
    RET


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
  CMP GP2, GP21 ; Check if null
  JNE :more_to_process
  RET

; What is the input?  (pointer to heap allocated prompt? Or nothing.)
; What is the output? (pointer to heap allocated value containing Initput)
; GP0 - input from keyboard
; GP1 - counter to prevent overflows
; GP2 - Currently built word (before it's pushed to stack)
; GP3 - Used to multiply shift value temporarily
; GP4 - Contains minimum counter value before we need to push to heap
; GP5 - Contains the pointer to beginning of heap allocation for command phrase
; GP6 - Contains next pointer value to write to in heap
; GP7 - Contains command word length
; GP20 - Contains newline
; GP21 - Contains 0
; GP23 - Function parameter, it's the pointer on heap where the prompt text lives.

get_input:
  LLI GP1, #3             ; Set GP1 to shift amount
  LLI GP4, #1             ; Explicitly set GP4
  LLI GP5, #0             ; Explicitly set GP5
  LLI GP6, #0             ; Explicitly set GP6
  LLI GP7, #0             ; Explicitly set GP7
  LLI GP8, .char_Backspace ; Set to backspace ascii code
  LLI GP12, #0        ; Used to store current reg's memory storage location, so I can subtract when I remove
  CMP GP23, GP5
  JEQ :input_poll_loop
  PUSH GP7
  PUSH GP6
  PUSH GP5
  PUSH GP4 
  PUSH GP1
  CALLI :display_output   ; Call display_output with the pointer to the prompt text (reusing GP23 from the function call)
  POP GP1
  POP GP4 
  POP GP5
  POP GP6 
  POP GP7
  LLI GP2, #0
  input_poll_loop:
    LD GP0, GP31, #2      ; Load keyboard value
    CMP GP0, GP21         ; Check if it's empty
    JEQ :input_poll_loop
    ST GP0, GP31, #1      ; Print value on screen
    CMP GP0, GP8          ; Backspace?
    JNE :skip_rem_char
    CALLI :remove_char
    JMP :input_poll_loop
    skip_rem_char:
    CMP GP0, GP20         ; New line?
    JNE :add_text_and_loop
    ; Here we take the pointer to the beginning of the heap allocated memory and return it.
    CMP GP1, GP21         ; Check if counter is >= 1, if it is, skip extending because we can insert the newline and null and move on.
    JGE :add_nl_and_ret ; Jump past the call to push to heap if there's at least 1 more char of room in the current word
    CALLI :extend_and_push_heap
  add_nl_and_ret:
    LLI GP23, #1
    CALLI :malloc
    MOV GP6, GP28
    ST GP2, GP6, #0 ; Store on heap
    CMP GP5, GP21 ; If GP5 is zero, we don't have a beginning yet, use GP6
    JNE :use_gp5
    MOV GP28, GP6
    RET
    use_gp5:
    MOV GP28, GP5
    RET             ; Return
  add_text_and_loop:
    CMP GP1, GP21         ; Check if counter is 0
    JGE :skip_push
    CALLI :extend_and_push_heap 
  skip_push:
    MOV GP3, GP1          ; Copy counter
    MULI GP3, #8          ; Multiply by bits to shift
    SHL GP0, GP3          ; Shift left by GP3
    ADD GP2, GP0          ; Add new char
    SUBI GP1, #1          ; Subtract byte counter
    JMP :input_poll_loop  ; Loop back

extend_and_push_heap:
  LLI GP23, #1
  PUSH GP0
  CALLI :malloc
  POP GP0
  ST GP2, GP28, #0
  CMP GP5, GP21 ; check if gp5 is zero
  JNE :skip_set_ret
  MOV GP5, GP28 ; Set gp5 to heap pointer
  skip_set_ret:
  MOV GP12, GP28 ; Store last mem addr
  LLI GP2, #0
  LLI GP1, #3
  RET

remove_char:
  ; The counter will tell us which character is next, so we know which to remove
  ; Counter = -1 means we remove bits 0-7
  ; Counter = 0 means we remove bits 8-15
  ; Counter = 1 means we remove bits 16-23
  ; Counter = 2 means we remove bits 24-31
  ; Counter = 3 means one of two things:
  ;   If GP5 is set, we go back to the previous word and remove a char from it, and remove it from memory so we can write it again.
  ;     This also means we need to free the memory address, so we reduce the heap pointer by 1.
  ;   If GP5 is not set, we do nothing, because there was never a character there to begin with
  ; Instead of CMPing the counter, we should just add 1 to it and mult by 8 so we know how many bits to shift.
  ; Shift right 8 bits, left 8 bits at 0
  ; Shift right 16 bits, right 16 bits at 1
  ; Shift left 24 bits, right 24 bits at 2
  ; Don't shift immediately at 3. Set counter to 0 (because we're removing a char) and then SHR 8 bits, SHL 8 bits
  MOV GP9, GP1
  ADDI GP9, #2 ; Add 2
  MULI GP9, #8 ; Multiply by byte
  LLI GP11, #3 ; Compare
  LLI GP13, #32 ; Compare
  CMP GP1, GP11 ; If == 3
  JEQ :remove_word_from_mem
  CMP GP9, GP13
  JEQ :set_to_zero
  SHR GP2, GP9 ; Shift by number of bits to remove character
  SHL GP2, GP9 ; Shift back
  ADDI GP1, #1 ; Add 1 to counter
  RET
  remove_word_from_mem:
  CMP GP5, GP21 ; If GP5 == 0
  JEQ :do_nothing
  LD GP2, GP12, #0 ; Load word
  ST GP21, GP12, #0 ; Empty it
  SUBI GP12, #1 ; Decrement
  LLI GP1, #0
  SHRI GP2, #8 ; Shift by known number of bits
  SHLI GP2, #8 ; Shift by known number of bits
  do_nothing:
  RET

  set_to_zero:
  LLI GP2, #0 ; Set to zero
  ADDI GP1, #1 ; Add 1 to counter
  RET
