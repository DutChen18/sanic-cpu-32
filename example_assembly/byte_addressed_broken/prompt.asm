.periph_hi #64
LUI GP0, .periph_hi ; Peripheral address
ADDI GP0, #1
loop:
LD GP2, GP0, #1   ; Load 2nd peripheral address (value) into GP2
ST GP2, GP0, #0   ; Store GP2 on TTY
MOV GP3, GP2      ; Move the value from GP3 (0) into GP2
JMP :loop         ; Jump to loop label
