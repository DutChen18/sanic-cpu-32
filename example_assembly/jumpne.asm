LLI GP0, #2
LLI GP1, #2 
CMP GP0, GP1
JEQ correct

wrong:
LLI GP2, #15

correct:
LLI GP2, #10
