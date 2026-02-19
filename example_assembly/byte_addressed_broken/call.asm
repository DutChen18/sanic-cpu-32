; GP23-26 = function params
; GP27 = return function pointer
; GP28 = return value
; GP29 = SP
; GP0-22 = ephemeral
LUI GP29, #255    ; Init stack
ADDI GP29, #65535 ; Init stack

JMP :main
add_values:
  MOV GP0, GP23     ; Move 1st param to ephemeral register
  ADD GP0, GP24     ; add 2nd param to ephemeral 1st param (params aren't pointers in this function)
  MOV GP28, GP0     ; mov result to return of function
  RET               ; return control to main 

main:
  LLI GP23, #5      ; First param is 5
  LLI GP24, #6      ; Second param is 6 
  CALLI :add_values ; Call function, placing next memory address for PC on stack
  MOV GP5, GP28     ; Move result to GP5
  ADDI GP5, #2      ; Add 2 to result

