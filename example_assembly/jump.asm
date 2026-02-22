

main:
  LLI GP0, #1
  JMP add_one

add_two:
  LLI GP1, #2
  ADD GP0, GP1

add_one:
  LLI GP1, #1
  ADD GP0, GP1

