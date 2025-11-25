from enum import Enum


class OpCode(Enum):
    CMP = 16
    BR = 17
    JMP = 18
    CALL = 19
    RET = 20

    LD = 32
    ST = 33
    MOV = 34
    LUI = 35
    NOT = 36

    ADD = 64
    SUB = 65
    MUL = 66
    DIV = 67
    AND = 68
    OR = 69
    XOR = 70
    SHL = 71
    SHR = 72

    ADDI = 80
    SUBI = 81
    MULI = 82
    DIVI = 83
    ANDI = 84
    ORI = 85
    XORI = 86
    SHLI = 87
    SHRI = 88

class MicroOp(Enum):
    HALT             = 0b00000000000000000001
    MEM_WRITE_ENABLE = 0b00000000000000000010
    REG_B_LS_LITERAL = 0b00000000000000000100
    IMM_TO_A         = 0b00000000000000001000
    MDR_CU_WRITE     = 0b00000000000000010000
    PC_WRITE_ENABLE  = 0b00000000000000100000
    MDR_MEM_WRITE    = 0b00000000000001000000
    # MOV micro-ops (2-bit encoded)
    REG_B_TO_A       = 0b00000000000000000000
    MEM_TO_A         = 0b00000000000010000000
    ALU_TO_A         = 0b00000000000100000000
    AUX_TO_A         = 0b00000000000110000000
    #
    MAR_CLEAR_ENABLE = 0b00000000001000000000
    MDR_CLEAR_ENABLE = 0b00000000010000000000
    REG_CLEAR_ENABLE = 0b00000000100000000000
    NEXT_INSTRUCTION = 0b00000001000000000000
    REG_WRITE_ENABLE = 0b00000010000000000000
    REG_READ_A       = 0b00000100000000000000
    REG_READ_B       = 0b00001000000000000000
    ALU_ENABLE       = 0b00010000000000000000
    MAR_WRITE_ENABLE = 0b00100000000000000000
    MDR_WRITE_ENABLE = 0b01000000000000000000
    MDR_READ_ENABLE  = 0b10000000000000000000

class Instruction:
    shorthand = OpCode.ADD
    clock0 = []
    clock1 = []
    clock2 = []
    clock3 = []
    def __init__(self, shorthand, clock0, clock1=None, clock2=None, clock3=None):
        self.shorthand = shorthand
        self.clock0 = clock0
        self.clock1 = clock1
        self.clock2 = clock2
        self.clock3 = clock3



# Register A = 1st set of bits (5-7)
# Register B = 2nd set of bits (8-10)



instructions = [
    Instruction(OpCode.ADD,     [MicroOp.REG_READ_A, MicroOp.REG_READ_B, MicroOp.ALU_ENABLE],                                   [MicroOp.REG_WRITE_ENABLE, MicroOp.ALU_TO_A, MicroOp.NEXT_INSTRUCTION]),
    Instruction(OpCode.SUB,     [MicroOp.REG_READ_A, MicroOp.REG_READ_B, MicroOp.ALU_ENABLE],                                   [MicroOp.REG_WRITE_ENABLE, MicroOp.ALU_TO_A, MicroOp.NEXT_INSTRUCTION]),
    Instruction(OpCode.MUL,     [MicroOp.REG_READ_A, MicroOp.REG_READ_B, MicroOp.ALU_ENABLE],                                   [MicroOp.REG_WRITE_ENABLE, MicroOp.ALU_TO_A, MicroOp.NEXT_INSTRUCTION]),
    Instruction(OpCode.DIV,     [MicroOp.REG_READ_A, MicroOp.REG_READ_B, MicroOp.ALU_ENABLE],                                   [MicroOp.REG_WRITE_ENABLE, MicroOp.ALU_TO_A, MicroOp.NEXT_INSTRUCTION]),
    Instruction(OpCode.AND,     [MicroOp.REG_READ_A, MicroOp.REG_READ_B, MicroOp.ALU_ENABLE],                                   [MicroOp.REG_WRITE_ENABLE, MicroOp.ALU_TO_A, MicroOp.NEXT_INSTRUCTION]),
    Instruction(OpCode.OR,      [MicroOp.REG_READ_A, MicroOp.REG_READ_B, MicroOp.ALU_ENABLE],                                   [MicroOp.REG_WRITE_ENABLE, MicroOp.ALU_TO_A, MicroOp.NEXT_INSTRUCTION]),
    Instruction(OpCode.XOR,     [MicroOp.REG_READ_A, MicroOp.REG_READ_B, MicroOp.ALU_ENABLE],                                   [MicroOp.REG_WRITE_ENABLE, MicroOp.ALU_TO_A, MicroOp.NEXT_INSTRUCTION]),
    Instruction(OpCode.NOT,     [MicroOp.REG_READ_A, MicroOp.REG_READ_B, MicroOp.ALU_ENABLE],                                   [MicroOp.REG_WRITE_ENABLE, MicroOp.ALU_TO_A, MicroOp.NEXT_INSTRUCTION]),
    Instruction(OpCode.ADDI,    [MicroOp.REG_READ_A, MicroOp.ALU_ENABLE],                                                       [MicroOp.REG_WRITE_ENABLE, MicroOp.ALU_TO_A, MicroOp.NEXT_INSTRUCTION]),
    Instruction(OpCode.SUBI,    [MicroOp.REG_READ_A, MicroOp.ALU_ENABLE],                                                       [MicroOp.REG_WRITE_ENABLE, MicroOp.ALU_TO_A, MicroOp.NEXT_INSTRUCTION]),
    Instruction(OpCode.MULI,    [MicroOp.REG_READ_A, MicroOp.ALU_ENABLE],                                                       [MicroOp.REG_WRITE_ENABLE, MicroOp.ALU_TO_A, MicroOp.NEXT_INSTRUCTION]),
    Instruction(OpCode.DIVI,    [MicroOp.REG_READ_A, MicroOp.ALU_ENABLE],                                                       [MicroOp.REG_WRITE_ENABLE, MicroOp.ALU_TO_A, MicroOp.NEXT_INSTRUCTION]),
    Instruction(OpCode.ANDI,    [MicroOp.REG_READ_A, MicroOp.ALU_ENABLE],                                                       [MicroOp.REG_WRITE_ENABLE, MicroOp.ALU_TO_A, MicroOp.NEXT_INSTRUCTION]),
    Instruction(OpCode.ORI,     [MicroOp.REG_READ_A, MicroOp.ALU_ENABLE],                                                       [MicroOp.REG_WRITE_ENABLE, MicroOp.ALU_TO_A, MicroOp.NEXT_INSTRUCTION]),
    Instruction(OpCode.XORI,    [MicroOp.REG_READ_A, MicroOp.ALU_ENABLE],                                                       [MicroOp.REG_WRITE_ENABLE, MicroOp.ALU_TO_A, MicroOp.NEXT_INSTRUCTION]),
    Instruction(OpCode.CMP,     [MicroOp.REG_READ_A, MicroOp.REG_READ_B, MicroOp.ALU_ENABLE],                                   MicroOp.NEXT_INSTRUCTION),
    Instruction(OpCode.BR,      [MicroOp.PC_WRITE_ENABLE],                                                                      MicroOp.NEXT_INSTRUCTION),
    Instruction(OpCode.LD,      [MicroOp.REG_READ_B, MicroOp.MAR_WRITE_ENABLE, MicroOp.MDR_READ_ENABLE],  [MicroOp.MDR_READ_ENABLE, MicroOp.MDR_WRITE_ENABLE],  [MicroOp.MEM_TO_A , MicroOp.REG_WRITE_ENABLE, MicroOp.NEXT_INSTRUCTION]),
    Instruction(OpCode.ST,      [MicroOp.REG_READ_A, MicroOp.REG_READ_B, MicroOp.MAR_WRITE_ENABLE, MicroOp.MDR_WRITE_ENABLE],   [MicroOp.MEM_WRITE_ENABLE], MicroOp.NEXT_INSTRUCTION),
    Instruction(OpCode.LUI,     MicroOp.REG_CLEAR_ENABLE,                                                                       [MicroOp.REG_WRITE_ENABLE, MicroOp.IMM_TO_A, MicroOp.NEXT_INSTRUCTION])
]

opcode_pad_width = len(MicroOp)-2
opcode_width = 7
cycle_width = 2
micro_op_width = opcode_width + cycle_width

with open("pla.txt", "w") as file:
    for instruction in instructions:
        combined_op = 0b0
        if isinstance(instruction.clock0, list):
            for op in instruction.clock0:
                if op != None:
                    combined_op |= op.value
        else:
            if(instruction.clock0 != None):
                combined_op |= instruction.clock0.value
        if(instruction.clock0 != None):
            binary_string = format(combined_op, f"0{opcode_pad_width}b")
            op_string = format(instruction.shorthand.value,             f"0{micro_op_width}b")
            file.write(op_string + " " + binary_string + "\n")
        combined_op = 0b0
        if isinstance(instruction.clock1, list):
            for op in instruction.clock1:
                if op != None:
                    combined_op |= op.value
        else:
            if(instruction.clock1 != None):
                combined_op |= instruction.clock1.value
        if(instruction.clock1 != None):
            binary_string = format(combined_op, f"0{opcode_pad_width}b")
            op_string = format(instruction.shorthand.value + 0b010000000, f"0{micro_op_width}b")
            file.write(op_string + " " + binary_string + "\n")
        combined_op = 0b0
        if isinstance(instruction.clock2, list):
            for op in instruction.clock2:
                if op != None:
                    combined_op |= op.value
        else:
            if(instruction.clock2 != None):
                combined_op |= instruction.clock2.value
        if(instruction.clock2 != None):
            binary_string = format(combined_op, f"0{opcode_pad_width}b")
            op_string = format(instruction.shorthand.value + 0b100000000, f"0{micro_op_width}b")
            file.write(op_string + " " + binary_string + "\n")
        combined_op = 0b0
        if isinstance(instruction.clock3, list):
            for op in instruction.clock3:
                if op != None:
                    combined_op |= op.value
        else:
            if(instruction.clock3 != None):
                combined_op |= instruction.clock3.value
        if(instruction.clock3 != None):
            binary_string = format(combined_op, f"0{opcode_pad_width}b")
            op_string = format(instruction.shorthand.value + 0b110000000, f"0{micro_op_width}b")
            file.write(op_string + " " + binary_string + "\n")
        combined_op = 0b0