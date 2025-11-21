from enum import Enum


class OpCode(Enum):
    ADD   = 0b11000
    SUB   = 0b11001
    MUL   = 0b11010
    DIV   = 0b11011
    OR    = 0b11100
    AND   = 0b11101
    XOR   = 0b11110
    NOT   = 0b11111
    ADDI  = 0b10000
    SUBI  = 0b10001
    MULI  = 0b10010
    DIVI  = 0b10011
    ORI   = 0b10100
    ANDI  = 0b10101
    XORI  = 0b10110
    CMP   = 0b10111
    BR    = 0b01000
    BRI   = 0b01001
    LD    = 0b01010
    LDI   = 0b01011
    ST    = 0b01100
    STI   = 0b01101
    MOV   = 0b01110
    PUSH  = 0b01111
    NOP   = 0b00000
    HALT  = 0b00001
    CALL  = 0b00010
    CALLI = 0b00011
    RET   = 0b00100
    SHR   = 0b00101
    LIU   = 0b00110
    
class MicroOp(Enum):
    IMM_TO_A         = 0b00000000000000001
    UPPER_IMM_MODE   = 0b00000000000000010
    PC_WRITE_ENABLE  = 0b00000000000000100
    IMM_MODE         = 0b00000000000001000
    # MOV micro-ops (2-bit encoded)
    REG_B_TO_A       = 0b00000000000000000
    MEM_TO_A         = 0b00000000000010000
    ALU_TO_A         = 0b00000000000100000
    AUX_TO_A         = 0b00000000000110000
    #
    MAR_CLEAR_ENABLE = 0b00000000001000000
    MDR_CLEAR_ENABLE = 0b00000000010000000
    REG_CLEAR_ENABLE = 0b00000000100000000
    NEXT_INSTRUCTION = 0b00000001000000000
    REG_WRITE_ENABLE = 0b00000010000000000
    REG_READ_A       = 0b00000100000000000
    REG_READ_B       = 0b00001000000000000
    ALU_ENABLE       = 0b00010000000000000
    MAR_WRITE_ENABLE = 0b00100000000000000
    MDR_WRITE_ENABLE = 0b01000000000000000
    MDR_READ_ENABLE  = 0b10000000000000000

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
    Instruction(OpCode.ADD, [MicroOp.REG_READ_A, MicroOp.REG_READ_B, MicroOp.ALU_ENABLE], [MicroOp.REG_WRITE_ENABLE, MicroOp.ALU_TO_A, MicroOp.NEXT_INSTRUCTION]),
    Instruction(OpCode.SUB, [MicroOp.REG_READ_A, MicroOp.REG_READ_B, MicroOp.ALU_ENABLE], [MicroOp.REG_WRITE_ENABLE, MicroOp.ALU_TO_A, MicroOp.NEXT_INSTRUCTION]),
    Instruction(OpCode.MUL, [MicroOp.REG_READ_A, MicroOp.REG_READ_B, MicroOp.ALU_ENABLE], [MicroOp.REG_WRITE_ENABLE, MicroOp.ALU_TO_A, MicroOp.NEXT_INSTRUCTION]),
    Instruction(OpCode.DIV, [MicroOp.REG_READ_A, MicroOp.REG_READ_B, MicroOp.ALU_ENABLE], [MicroOp.REG_WRITE_ENABLE, MicroOp.ALU_TO_A, MicroOp.NEXT_INSTRUCTION]),
    Instruction(OpCode.AND, [MicroOp.REG_READ_A, MicroOp.REG_READ_B, MicroOp.ALU_ENABLE], [MicroOp.REG_WRITE_ENABLE, MicroOp.ALU_TO_A, MicroOp.NEXT_INSTRUCTION]),
    Instruction(OpCode.OR,  [MicroOp.REG_READ_A, MicroOp.REG_READ_B, MicroOp.ALU_ENABLE], [MicroOp.REG_WRITE_ENABLE, MicroOp.ALU_TO_A, MicroOp.NEXT_INSTRUCTION]),
    Instruction(OpCode.XOR, [MicroOp.REG_READ_A, MicroOp.REG_READ_B, MicroOp.ALU_ENABLE], [MicroOp.REG_WRITE_ENABLE, MicroOp.ALU_TO_A, MicroOp.NEXT_INSTRUCTION]),
    Instruction(OpCode.NOT, [MicroOp.REG_READ_A, MicroOp.REG_READ_B, MicroOp.ALU_ENABLE], [MicroOp.REG_WRITE_ENABLE, MicroOp.ALU_TO_A, MicroOp.NEXT_INSTRUCTION]),
    Instruction(OpCode.ADDI, [MicroOp.REG_READ_A, MicroOp.IMM_MODE, MicroOp.ALU_ENABLE], [MicroOp.REG_WRITE_ENABLE, MicroOp.IMM_MODE, MicroOp.ALU_TO_A, MicroOp.NEXT_INSTRUCTION]),
    Instruction(OpCode.SUBI, [MicroOp.REG_READ_A, MicroOp.IMM_MODE, MicroOp.ALU_ENABLE], [MicroOp.REG_WRITE_ENABLE, MicroOp.IMM_MODE, MicroOp.ALU_TO_A, MicroOp.NEXT_INSTRUCTION]),
    Instruction(OpCode.MULI, [MicroOp.REG_READ_A, MicroOp.IMM_MODE, MicroOp.ALU_ENABLE], [MicroOp.REG_WRITE_ENABLE, MicroOp.IMM_MODE, MicroOp.ALU_TO_A, MicroOp.NEXT_INSTRUCTION]),
    Instruction(OpCode.DIVI, [MicroOp.REG_READ_A, MicroOp.IMM_MODE, MicroOp.ALU_ENABLE], [MicroOp.REG_WRITE_ENABLE, MicroOp.IMM_MODE, MicroOp.ALU_TO_A, MicroOp.NEXT_INSTRUCTION]),
    Instruction(OpCode.ANDI, [MicroOp.REG_READ_A, MicroOp.IMM_MODE, MicroOp.ALU_ENABLE], [MicroOp.REG_WRITE_ENABLE, MicroOp.IMM_MODE, MicroOp.ALU_TO_A, MicroOp.NEXT_INSTRUCTION]),
    Instruction(OpCode.ORI, [MicroOp.REG_READ_A, MicroOp.IMM_MODE, MicroOp.ALU_ENABLE], [MicroOp.REG_WRITE_ENABLE, MicroOp.IMM_MODE, MicroOp.ALU_TO_A, MicroOp.NEXT_INSTRUCTION]),
    Instruction(OpCode.XORI, [MicroOp.REG_READ_A, MicroOp.IMM_MODE, MicroOp.ALU_ENABLE], [MicroOp.REG_WRITE_ENABLE, MicroOp.IMM_MODE, MicroOp.ALU_TO_A, MicroOp.NEXT_INSTRUCTION]),
    Instruction(OpCode.CMP, [MicroOp.REG_READ_A, MicroOp.REG_READ_B, MicroOp.ALU_ENABLE], MicroOp.NEXT_INSTRUCTION),
    Instruction(OpCode.BR, [MicroOp.PC_WRITE_ENABLE, MicroOp.IMM_MODE], MicroOp.NEXT_INSTRUCTION),
    Instruction(OpCode.BRI, [MicroOp.PC_WRITE_ENABLE, MicroOp.REG_READ_B], MicroOp.NEXT_INSTRUCTION),
    Instruction(OpCode.LD, [MicroOp.MAR_WRITE_ENABLE, MicroOp.IMM_MODE, MicroOp.MDR_READ_ENABLE], [MicroOp.REG_WRITE_ENABLE, MicroOp.NEXT_INSTRUCTION]),
    Instruction(OpCode.LDI, [MicroOp.REG_READ_B, MicroOp.MAR_WRITE_ENABLE, MicroOp.MDR_READ_ENABLE], [MicroOp.REG_WRITE_ENABLE, MicroOp.NEXT_INSTRUCTION]),
    Instruction(OpCode.ST, [MicroOp.REG_READ_A, MicroOp.IMM_MODE, MicroOp.MAR_WRITE_ENABLE, MicroOp.MDR_WRITE_ENABLE], [MicroOp.REG_WRITE_ENABLE, MicroOp.NEXT_INSTRUCTION]),
    
    Instruction(OpCode.LIU, MicroOp.REG_CLEAR_ENABLE, [MicroOp.REG_WRITE_ENABLE, MicroOp.IMM_MODE, MicroOp.UPPER_IMM_MODE, MicroOp.IMM_TO_A, MicroOp.NEXT_INSTRUCTION])
]



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
            binary_string = format(combined_op, f"0{17}b")
            op_string = format(instruction.shorthand.value,             f"0{7}b")
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
            binary_string = format(combined_op, f"0{17}b")
            op_string = format(instruction.shorthand.value + 0b0100000, f"0{7}b")
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
            binary_string = format(combined_op, f"0{17}b")
            op_string = format(instruction.shorthand.value + 0b1000000, f"0{7}b")
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
            binary_string = format(combined_op, f"0{17}b")
            op_string = format(instruction.shorthand.value + 0b1100000, f"0{7}b")
            file.write(op_string + " " + binary_string + "\n")
        combined_op = 0b0