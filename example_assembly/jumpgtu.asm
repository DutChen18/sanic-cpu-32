LLI GP0, #2
LLI GP1, #1
CMP GP0, GP1
JGTU correct

wrong:
LLI GP2, #20
JMP wrong
correct:
LLI GP2, #21
