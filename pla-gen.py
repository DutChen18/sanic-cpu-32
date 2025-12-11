from enum import Enum


class OpCode(Enum):
    NOP = 0
    HALT = 1

    CALL = 16
    RET  = 17

    BR = 32
    BEQ = 33
    BNE = 34
    BLE = 35
    BLT = 36
    BGT = 37
    BGE = 38
    BLEU = 39
    BLTU = 40
    BGEU = 41
    BGTU = 42

    JMP = 48
    JEQ = 49
    JNE = 50
    JLE = 51
    JLT = 52
    JGT = 53
    JGE = 54
    JLEU = 55
    JLTU = 56
    JGEU = 57
    JGTU = 58

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

    LD = 96
    ST = 97
    MOV = 98
    LUI = 99
    NOT = 100
    CMP = 101

class MicroOp(Enum):
    CONDITION_EQ     = 0b0000000000000000000011010
    CONDITION_NE     = 0b0000000000000000000011001
    CONDITION_LE     = 0b0000000000000000000011000
    CONDITION_LT     = 0b0000000000000000000010111
    CONDITION_GT     = 0b0000000000000000000010110
    CONDITION_GE     = 0b0000000000000000000010101
    CONDITION_LEU    = 0b0000000000000000000010100
    CONDITION_LTU    = 0b0000000000000000000010011
    CONDITION_GEU    = 0b0000000000000000000010010
    CONDITION_GTU    = 0b0000000000000000000010001
    CONDITION_ALWAYS = 0b0000000000000000000010000
    HALT             = 0b0000000000000000000100000
    MEM_WRITE_ENABLE = 0b0000000000000000001000000
    PC_RELATIVE_ADDR = 0b0000000000000000010000000
    IMM_TO_A         = 0b0000000000000000100000000
    INVERT_REG_A     = 0b0000000000000001000000000
    PC_WRITE_ENABLE  = 0b0000000000000010000000000
    MDR_MEM_WRITE    = 0b0000000000000100000000000
    # MOV micro-ops (2-bit encoded)
    REG_B_TO_A       = 0b0000000000000000000000000
    MEM_TO_A         = 0b0000000000001000000000000
    ALU_TO_A         = 0b0000000000010000000000000
    AUX_TO_A         = 0b0000000000011000000000000
    #
    MAR_CLEAR_ENABLE = 0b0000000000100000000000000
    MDR_CLEAR_ENABLE = 0b0000000001000000000000000
    REG_CLEAR_ENABLE = 0b0000000010000000000000000
    NEXT_INSTRUCTION = 0b0000000100000000000000000
    REG_WRITE_ENABLE = 0b0000001000000000000000000
    REG_READ_A       = 0b0000010000000000000000000
    REG_READ_B       = 0b0000100000000000000000000
    ALU_ENABLE       = 0b0001000000000000000000000
    MAR_WRITE_ENABLE = 0b0010000000000000000000000
    MDR_WRITE_ENABLE = 0b0100000000000000000000000
    MDR_READ_ENABLE  = 0b1000000000000000000000000

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
    Instruction(OpCode.ADDI,    [MicroOp.REG_READ_A, MicroOp.ALU_ENABLE],                                                       [MicroOp.REG_WRITE_ENABLE, MicroOp.ALU_TO_A, MicroOp.NEXT_INSTRUCTION]),
    Instruction(OpCode.SUBI,    [MicroOp.REG_READ_A, MicroOp.ALU_ENABLE],                                                       [MicroOp.REG_WRITE_ENABLE, MicroOp.ALU_TO_A, MicroOp.NEXT_INSTRUCTION]),
    Instruction(OpCode.MULI,    [MicroOp.REG_READ_A, MicroOp.ALU_ENABLE],                                                       [MicroOp.REG_WRITE_ENABLE, MicroOp.ALU_TO_A, MicroOp.NEXT_INSTRUCTION]),
    Instruction(OpCode.DIVI,    [MicroOp.REG_READ_A, MicroOp.ALU_ENABLE],                                                       [MicroOp.REG_WRITE_ENABLE, MicroOp.ALU_TO_A, MicroOp.NEXT_INSTRUCTION]),
    Instruction(OpCode.ANDI,    [MicroOp.REG_READ_A, MicroOp.ALU_ENABLE],                                                       [MicroOp.REG_WRITE_ENABLE, MicroOp.ALU_TO_A, MicroOp.NEXT_INSTRUCTION]),
    Instruction(OpCode.ORI,     [MicroOp.REG_READ_A, MicroOp.ALU_ENABLE],                                                       [MicroOp.REG_WRITE_ENABLE, MicroOp.ALU_TO_A, MicroOp.NEXT_INSTRUCTION]),
    Instruction(OpCode.XORI,    [MicroOp.REG_READ_A, MicroOp.ALU_ENABLE],                                                       [MicroOp.REG_WRITE_ENABLE, MicroOp.ALU_TO_A, MicroOp.NEXT_INSTRUCTION]),
    Instruction(OpCode.CMP,     [MicroOp.REG_READ_A, MicroOp.REG_READ_B, MicroOp.ALU_ENABLE, MicroOp.NEXT_INSTRUCTION]),
    Instruction(OpCode.BR,      [MicroOp.PC_WRITE_ENABLE, MicroOp.REG_READ_A, MicroOp.CONDITION_ALWAYS, MicroOp.NEXT_INSTRUCTION]),
    Instruction(OpCode.BEQ,     [MicroOp.PC_WRITE_ENABLE, MicroOp.REG_READ_A, MicroOp.CONDITION_EQ, MicroOp.NEXT_INSTRUCTION]),
    Instruction(OpCode.BNE,     [MicroOp.PC_WRITE_ENABLE, MicroOp.REG_READ_A, MicroOp.CONDITION_NE, MicroOp.NEXT_INSTRUCTION]),
    Instruction(OpCode.BLE,     [MicroOp.PC_WRITE_ENABLE, MicroOp.REG_READ_A, MicroOp.CONDITION_LE, MicroOp.NEXT_INSTRUCTION]),
    Instruction(OpCode.BLT,     [MicroOp.PC_WRITE_ENABLE, MicroOp.REG_READ_A, MicroOp.CONDITION_LT, MicroOp.NEXT_INSTRUCTION]),
    Instruction(OpCode.BGT,     [MicroOp.PC_WRITE_ENABLE, MicroOp.REG_READ_A, MicroOp.CONDITION_GT, MicroOp.NEXT_INSTRUCTION]),
    Instruction(OpCode.BGE,     [MicroOp.PC_WRITE_ENABLE, MicroOp.REG_READ_A, MicroOp.CONDITION_GE, MicroOp.NEXT_INSTRUCTION]),
    Instruction(OpCode.BLEU,    [MicroOp.PC_WRITE_ENABLE, MicroOp.REG_READ_A, MicroOp.CONDITION_LEU, MicroOp.NEXT_INSTRUCTION]),
    Instruction(OpCode.BLTU,    [MicroOp.PC_WRITE_ENABLE, MicroOp.REG_READ_A, MicroOp.CONDITION_LTU, MicroOp.NEXT_INSTRUCTION]),
    Instruction(OpCode.BGEU,    [MicroOp.PC_WRITE_ENABLE, MicroOp.REG_READ_A, MicroOp.CONDITION_GEU, MicroOp.NEXT_INSTRUCTION]),
    Instruction(OpCode.BGTU,    [MicroOp.PC_WRITE_ENABLE, MicroOp.REG_READ_A, MicroOp.CONDITION_GTU, MicroOp.NEXT_INSTRUCTION]),
    
    Instruction(OpCode.JMP,     [MicroOp.PC_WRITE_ENABLE, MicroOp.REG_READ_A, MicroOp.CONDITION_ALWAYS, MicroOp.PC_RELATIVE_ADDR, MicroOp.NEXT_INSTRUCTION]),
    Instruction(OpCode.JEQ,     [MicroOp.PC_WRITE_ENABLE, MicroOp.REG_READ_A, MicroOp.CONDITION_EQ, MicroOp.PC_RELATIVE_ADDR, MicroOp.NEXT_INSTRUCTION]),
    Instruction(OpCode.JNE,     [MicroOp.PC_WRITE_ENABLE, MicroOp.REG_READ_A, MicroOp.CONDITION_NE, MicroOp.PC_RELATIVE_ADDR, MicroOp.NEXT_INSTRUCTION]),
    Instruction(OpCode.JLE,     [MicroOp.PC_WRITE_ENABLE, MicroOp.REG_READ_A, MicroOp.CONDITION_LE, MicroOp.PC_RELATIVE_ADDR, MicroOp.NEXT_INSTRUCTION]),
    Instruction(OpCode.JLT,     [MicroOp.PC_WRITE_ENABLE, MicroOp.REG_READ_A, MicroOp.CONDITION_LT, MicroOp.PC_RELATIVE_ADDR, MicroOp.NEXT_INSTRUCTION]),
    Instruction(OpCode.JGT,     [MicroOp.PC_WRITE_ENABLE, MicroOp.REG_READ_A, MicroOp.CONDITION_GT, MicroOp.PC_RELATIVE_ADDR, MicroOp.NEXT_INSTRUCTION]),
    Instruction(OpCode.JGE,     [MicroOp.PC_WRITE_ENABLE, MicroOp.REG_READ_A, MicroOp.CONDITION_GE, MicroOp.PC_RELATIVE_ADDR, MicroOp.NEXT_INSTRUCTION]),
    Instruction(OpCode.JLEU,    [MicroOp.PC_WRITE_ENABLE, MicroOp.REG_READ_A, MicroOp.CONDITION_LEU, MicroOp.PC_RELATIVE_ADDR, MicroOp.NEXT_INSTRUCTION]),
    Instruction(OpCode.JLTU,    [MicroOp.PC_WRITE_ENABLE, MicroOp.REG_READ_A, MicroOp.CONDITION_LTU, MicroOp.PC_RELATIVE_ADDR, MicroOp.NEXT_INSTRUCTION]),
    Instruction(OpCode.JGEU,    [MicroOp.PC_WRITE_ENABLE, MicroOp.REG_READ_A, MicroOp.CONDITION_GEU, MicroOp.PC_RELATIVE_ADDR, MicroOp.NEXT_INSTRUCTION]),
    Instruction(OpCode.JGTU,    [MicroOp.PC_WRITE_ENABLE, MicroOp.REG_READ_A, MicroOp.CONDITION_GTU, MicroOp.PC_RELATIVE_ADDR, MicroOp.NEXT_INSTRUCTION]),
    
    Instruction(OpCode.LD,      [MicroOp.REG_READ_B, MicroOp.MAR_WRITE_ENABLE, MicroOp.MDR_READ_ENABLE],                        [MicroOp.MDR_READ_ENABLE, MicroOp.MDR_WRITE_ENABLE],                    [MicroOp.MEM_TO_A , MicroOp.REG_WRITE_ENABLE, MicroOp.NEXT_INSTRUCTION]),
    Instruction(OpCode.ST,      [MicroOp.REG_READ_A, MicroOp.REG_READ_B, MicroOp.MAR_WRITE_ENABLE, MicroOp.MDR_WRITE_ENABLE],   [MicroOp.MEM_WRITE_ENABLE],                                             MicroOp.NEXT_INSTRUCTION),
    Instruction(OpCode.LUI,     MicroOp.REG_CLEAR_ENABLE,                                                                       [MicroOp.REG_WRITE_ENABLE, MicroOp.IMM_TO_A, MicroOp.NEXT_INSTRUCTION]),
    Instruction(OpCode.NOT,     [MicroOp.REG_READ_A, MicroOp.INVERT_REG_A, MicroOp.REG_WRITE_ENABLE, MicroOp.NEXT_INSTRUCTION])

]

opcode_pad_width = len(MicroOp)-8
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