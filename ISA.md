# Overview

SanicCPU32 (defined hereafter as SC32) is a 32-bit little-endian RISC with an integer ALU, support for up to 23-bit memory (in the current implementation), and 32 general purpose registers.


# Instruction encoding

- Format 1 (Reg-reg arithmetic, indirect load/store):
    - AAAAACCCCCEEEEE
- Format 2 (Immediate arithmetic, direct load/store):
    - AAAAABBBDDDDDDDDDDDDDDDDDDDDDDDD
- Format 3 (Call):
    - AAAAADDDDDDDDDDDDDDDDDDDDDDDD
- Format 4 (Call indirect, Shift Right, POP, NOT):
    - AAAAACCCCC
- Format 5 (Load immediate upper):
    - AAAAACCCCCFFFFFFFFFFFFFFFF
- Format 6 (SMOV):
    - AAAAACCCCCGGGGG
- Format 7 (Branch):
    - AAAAAHHHDDDDDDDDDDDDDDDDDDDDDDDD
- Format 8 (Branch indirect):
    - AAAAAHHHCCCCC

- Legend
    * A: Always Opcode
    * B: 3-bit register index
    * C: 5-bit register index if the specific instruction supports it
    * D: 24-bit immediate for specific instructions that take that.
    * E: 5-bit register index for 2nd operand
    * F: 16-bit immediate
    * G: 5-bit special register index
    * H: 3-bit Branch condition

# Instructions

TODO


# Calling convention
There isn't a specific stack pointer register.

The ABI, though, uses the following:

R0 - function return
R1 - return memory address
R2 - stack pointer
R3 - 