LUI GP0, #64 ; Load 64 in upper 16 bits
ADDI GP0, #1 ; Add 1 to get the memory address for the tty
LLI GP1, #72 ; H
ST GP1, GP0, #0
LLI GP1, #69 ; E 
ST GP1, GP0, #0 ; store E on TTY
LLI GP1, #76 ; L 
ST GP1, GP0, #0
ST GP1, GP0, #0 ; Repeated since we don't need to store L again
LLI GP1, #79 ; O
ST GP1, GP0, #0 
LLI GP1, #44 ; ,
ST GP1, GP0, #0 
LLI GP1, #32 ; ' ' 
ST GP1, GP0, #0 
LLI GP1, #87 ; W
ST GP1, GP0, #0 
LLI GP1, #79 ; O
ST GP1, GP0, #0
LLI GP1, #82 ; R
ST GP1, GP0, #0
LLI GP1, #76 ; L
ST GP1, GP0, #0
LLI GP1, #68 ; D
ST GP1, GP0, #0
LLI GP1, #33 ; !
ST GP1, GP0, #0
