from enum import Enum
import sys

def can_decode_to_int(s):
    try:
        int(s)
        return True
    except ValueError:
        return False

class OperandType(Enum):
    Register = 0
    IntegerImmediate = 1
    AddressImmediate = 2
    Condition = 3
    SpecialRegister = 4
    One = 5
    Zero = 6

operandtype_prefixes = {
    OperandType.Register: "",
    OperandType.IntegerImmediate: "#",
    OperandType.AddressImmediate: "$",
    OperandType.Condition: "",
    OperandType.SpecialRegister: ""
}

class Opcode:
    operand_1_type: OperandType
    operand_2_type: OperandType
    operand_3_type: OperandType
    machine_code: int
    opcode_offset = 0
    operand_1_offset: int
    operand_2_offset: int
    operand_3_offset: int

    def __init__(self, operand_1_type, operand_2_type, operand_3_type = None, operand_1_offset = 0, operand_2_offset = 0, operand_3_offset = 0, machine_code = 0b0):
        self.operand_1_type = operand_1_type
        self.operand_2_type = operand_2_type
        self.operand_3_type = operand_3_type
        self.machine_code = machine_code
        self.operand_1_offset = operand_1_offset
        self.operand_2_offset = operand_2_offset
        self.operand_3_offset = operand_3_offset

# Always (Jmp)
# GEU (greater or equal unsigned)
# LTU (less than unsigned)
# LTEU (Less than or equal unsighed)
# GE (greater or equal signed)
# GT (greater than signed)
# LT (Less than signed
# LTE (Less than or equal)
# NE (not equal)
# EQ (Equal
class BranchCond(Enum):
    AL   =  0b0000
    GTU  =  0b0001  # Greater than unsigned x
    GEU  =  0b0010  # Greater or equal unsigned x
    LTU  =  0b0011  # Less than unsigned x
    LEU  =  0b0100  # Less than or equal unsigned x
    GE   =  0b0101  # Greater than or equal signed x
    GT   =  0b0110  # Greater than signed x
    LT   =  0b0111  # Less than signed x
    LE   =  0b1000  # Less than or equal signed x
    NE   =  0b1001  # Not equal x
    EQ   =  0b1010  # Equal x

class Register(Enum):
    GP0 = 0
    GP1 = 1
    GP2 = 2
    GP3 = 3
    GP4 = 4
    GP5 = 5
    GP6 = 6
    GP7 = 7
    GP8 = 8
    GP9 = 9
    GP10 = 10
    GP11 = 11
    GP12 = 12
    GP13 = 13
    GP14 = 14
    GP15 = 15
    GP16 = 16
    GP17 = 17
    GP18 = 18
    GP19 = 19
    GP20 = 20
    GP21 = 21
    GP22 = 22
    GP23 = 23
    GP24 = 24
    GP25 = 25
    GP26 = 26
    GP27 = 27
    GP28 = 28
    GP29 = 29
    GP30 = 30
    GP31 = 31

class Instruction:
    opcode: Opcode
    operand_1: str
    operand_2: str
    operand_3: str

    def __init__(self, opcode, operand_1, operand_2, operand_3):
        self.opcode = opcode
        self.operand_1 = operand_1
        self.operand_2 = operand_2
        self.operand_3 = operand_3

instruction_table = {
    "ADD":      Opcode(OperandType.Register,           OperandType.Register,           None,                           5,  10,  0, 0b11000),
    "SUB":      Opcode(OperandType.Register,           OperandType.Register,           None,                           5,  10,  0, 0b11001),
    "MUL":      Opcode(OperandType.Register,           OperandType.Register,           None,                           5,  10,  0, 0b11010),
    "DIV":      Opcode(OperandType.Register,           OperandType.Register,           None,                           5,  10,  0, 0b11011),
    "OR" :      Opcode(OperandType.Register,           OperandType.Register,           None,                           5,  10,  0, 0b11100),
    "AND":      Opcode(OperandType.Register,           OperandType.Register,           None,                           5,  10,  0, 0b11101),
    "XOR":      Opcode(OperandType.Register,           OperandType.Register,           None,                           5,  10,  0, 0b11110),
    "NOT":      Opcode(OperandType.Register,           None,                           None,                           5,  10,  0, 0b11111),
    "ADDI":     Opcode(OperandType.Register,           OperandType.IntegerImmediate,   None,                           5,  10,  0, 0b10000),
    "SUBI":     Opcode(OperandType.Register,           OperandType.IntegerImmediate,   None,                           5,  10,  0, 0b10001),
    "MULI":     Opcode(OperandType.Register,           OperandType.IntegerImmediate,   None,                           5,  10,  0, 0b10010),
    "DIVI":     Opcode(OperandType.Register,           OperandType.IntegerImmediate,   None,                           5,  10,  0, 0b10011),
    "ORI" :     Opcode(OperandType.Register,           OperandType.IntegerImmediate,   None,                           5,  10,  0, 0b10100),
    "ANDI":     Opcode(OperandType.Register,           OperandType.IntegerImmediate,   None,                           5,  10,  0, 0b10101),
    "XORI":     Opcode(OperandType.Register,           OperandType.IntegerImmediate,   None,                           5,  10,  0, 0b10110),
    "CMP":      Opcode(OperandType.Register,           OperandType.Register,           None,                           5,  10,  0, 0b10111),
    "BR":       Opcode(OperandType.Condition,          OperandType.Register,           OperandType.IntegerImmediate,   5,  10, 15, 0b01000),
    "BRI":      Opcode(OperandType.Condition,          OperandType.Register,           None,                           5,  10,  0, 0b01001),
    "LD":       Opcode(OperandType.Register,           OperandType.Register,           OperandType.IntegerImmediate,   5,  10, 15, 0b01010),
    "LDI":      Opcode(OperandType.Register,           OperandType.Register,           None,                           5,  10,  0, 0b01011),
    "ST":       Opcode(OperandType.Register,           OperandType.Register,           OperandType.IntegerImmediate,   5,  10, 15, 0b01100),
    "STI":      Opcode(OperandType.Register,           OperandType.Register,           None,                           5,  10,  0, 0b01100),
    "MOV":      Opcode(OperandType.Register,           OperandType.Register,           None,                           5,  10,  0, 0b01110),
    "PUSH":     Opcode(OperandType.Register,           OperandType.Register,           None,                           5,  10,  0, 0b01111),
    "NOP":      Opcode(None,                           None,                           None,                           0,  0,   0, 0b00000),
    "HALT":     Opcode(None,                           None,                           None,                           0,  0,   0, 0b00001),
    "CALL":     Opcode(OperandType.Register,           OperandType.IntegerImmediate,   None,                           5,  10,  0, 0b00010),
    "CALLI":    Opcode(OperandType.Register,           None,                           None,                           5,  10,  0, 0b00011),
    "RET":      Opcode(None,                           None,                           None,                           0,  0,   0, 0b00100),
    "SHR":      Opcode(OperandType.Register,           None,                           None,                           5,  10,  0, 0b00101),
    "LIU":      Opcode(OperandType.Register,           OperandType.IntegerImmediate,   None,                           5,  10,  0, 0b00110),
    "SMOV":     Opcode(OperandType.Register,           OperandType.SpecialRegister,    None,                           5,  10,  0, 0b00111),
    "SHIR":     Opcode(OperandType.Register,           OperandType.IntegerImmediate,   OperandType.One,                5,  10, 26, 0b10111),
    "SHIL":     Opcode(OperandType.Register,           OperandType.IntegerImmediate,   OperandType.Zero,               5,  10, 26, 0b10111),
    "SHR":      Opcode(OperandType.Register,           OperandType.Register,           OperandType.One,                5,  10, 15, 0b11111),
    "SHL":      Opcode(OperandType.Register,           OperandType.Register,           OperandType.Zero,               5,  10, 15, 0b11111),

}

assembly_file = ""
out_path = ""
if len(sys.argv) > 1:
    assembly_file = sys.argv[1]
    out_path = sys.argv[2]



#XORI GP0, #1
#XORI GP1, #2
#ADD  GP0, GP1


# First, get all lines, and attempt to find instructions that match the opcode (split by " ", first cell is opcode)
# If any are found that don't match an instruction, error with the line # and reason like a compiler.

instructions =  []
instruction_opcode_decoded = []
with open(assembly_file, "r") as af:
    errors = []
    line_count = 0
    for line in af:
        line_count += 1
        split = line.split(" ")
        opcode_str = split[0]
        if opcode_str not in instruction_table:
            right_justified_error = "Invalid opcode"
            
            errors.append( line + "\n^" + right_justified_error)
        opcode = instruction_table[opcode_str]
        arguments = line[len(opcode_str):].strip().split(",")
        operand_1 = arguments[0].strip()
        operand_2 = arguments[1].strip()
        operand_3 = ""
        if len(arguments) > 2: 
            operand_3 = arguments[2].strip()

        if opcode.operand_1_type != OperandType.Register and opcode.operand_1_type != OperandType.SpecialRegister and opcode.operand_1_type != OperandType.Condition:
            if operand_1[0] != operandtype_prefixes[opcode.operand_1_type]:
                operand_start = line.find(operand_1)
                right_justified_error = " " * operand_start + "^Invalid operand - possibly bad symbol"
                errors.append( line + "\n" +  right_justified_error)
                continue
        if opcode.operand_2_type != OperandType.Register and opcode.operand_2_type != OperandType.SpecialRegister and opcode.operand_2_type != OperandType.Condition:
            if operand_2[0] != operandtype_prefixes[opcode.operand_2_type]:
                operand_start = line.find(operand_2)
                right_justified_error = " " * operand_start + "^Invalid operand - possibly bad symbol"
                errors.append( line + "\n" +  right_justified_error)
                continue
        if len(operand_3) > 0 and opcode.operand_3_type != OperandType.Register and opcode.operand_3_type != OperandType.SpecialRegister and opcode.operand_3_type != OperandType.Condition:
            if operand_3[0] != operandtype_prefixes[opcode.operand_3_type]:
                operand_start = line.find(operand_3)
                right_justified_error = " " * operand_start + "^Invalid operand - possibly bad symbol"
                errors.append( line + "\n" +  right_justified_error)
                continue
        if opcode.operand_1_type == OperandType.Register:
            if not operand_1.strip() in Register.__members__:
                operand_start = line.find(operand_1)
                right_justified_error = " " * operand_start + "^Register by that name does not exist."
                errors.append( line + "\n" +  right_justified_error)
                continue
        if opcode.operand_2_type == OperandType.Register:
            if not operand_2.strip() in Register.__members__:
                operand_start = line.find(operand_2)
                right_justified_error = " " * operand_start + "^Register by that name does not exist."
                errors.append( line + "\n" +  right_justified_error)
                continue
        if len(operand_3) > 0 and opcode.operand_3_type == OperandType.Register:
            if not operand_3.strip() in Register.__members__:
                operand_start = line.find(operand_3)
                right_justified_error = " " * operand_start + "^Register by that name does not exist."
                errors.append( line + "\n" +  right_justified_error)
                continue
        if opcode.operand_1_type == OperandType.IntegerImmediate:
            if not can_decode_to_int(operand_1.strip("#")):
                operand_start = line.find(operand_1)
                right_justified_error = " " * operand_start + "^Immediate not decodable to integer."
                errors.append( line + "\n" +  right_justified_error)
                continue
        if opcode.operand_2_type == OperandType.IntegerImmediate:
            if not can_decode_to_int(operand_2.strip("#")):
                operand_start = line.find(operand_2)
                right_justified_error = " " * operand_start + "^Immediate not decodable to integer."
                errors.append( line + "\n" +  right_justified_error)
                continue
        if len(operand_3) > 0 and opcode.operand_3_type == OperandType.IntegerImmediate:
            if not can_decode_to_int(operand_3.strip("#")):
                operand_start = line.find(operand_3)
                right_justified_error = " " * operand_start + "^Immediate not decodable to integer."
                errors.append( line + "\n" +  right_justified_error)
                continue
        if opcode.operand_2_type == OperandType.AddressImmediate:
            if opcode_str == "ST" and int(operand_2.strip("$")) < 0x7FFFFF and int(operand_2.strip("$")) > 0x3FFFFF:
                operand_start = line.find(operand_2)
                right_justified_error = " " * operand_start + "^Illegal write to read-only memory."
                errors.append( line + "\n" +  right_justified_error)
                continue
            if opcode_str == "ST" or opcode_str == "LD" and int(operand_2.strip("$")) > 0xFFFFFF:
                operand_start = line.find(operand_2)
                right_justified_error = " " * operand_start + "^Invalid memory address"
                errors.append( line + "\n" +  right_justified_error)
                continue
        if len(operand_3) > 0 and opcode.operand_3_type == OperandType.AddressImmediate:
            if opcode_str == "ST" and int(operand_3.strip("$")) < 0x7FFFFF and int(operand_3.strip("$")) > 0x3FFFFF:
                operand_start = line.find(operand_3)
                right_justified_error = " " * operand_start + "^Illegal write to read-only memory."
                errors.append( line + "\n" +  right_justified_error)
                continue
            if opcode_str == "ST" or opcode_str == "LD" and int(operand_3.strip("$")) > 0xFFFFFF:
                operand_start = line.find(operand_3)
                right_justified_error = " " * operand_start + "^Invalid memory address"
                errors.append( line + "\n" +  right_justified_error)
                continue
        if opcode.operand_1_type == OperandType.Condition and not operand_1 in BranchCond.__members__:
                operand_start = line.find(operand_1)
                right_justified_error = " " * operand_start + "^Invalid Condition"
                errors.append( line + "\n" +  right_justified_error)
                continue
        
        instruction_opcode_decoded.append(Instruction(opcode, operand_1.strip(" #$"), operand_2.strip(" #$"), operand_3.strip(" #$")))
if len(errors) > 0:
    for error in errors:
        print(error)
    exit(1)

for decode_middle in instruction_opcode_decoded:
    operand_1 = None
    operand_2 = None
    operand_3 = None
    if decode_middle.opcode.operand_1_type == OperandType.Register:
        operand_1 = Register[decode_middle.operand_1].value
    if decode_middle.opcode.operand_1_type == OperandType.AddressImmediate or decode_middle.opcode.operand_1_type == OperandType.IntegerImmediate:
        operand_1 = int(decode_middle.operand_1)
    if decode_middle.opcode.operand_1_type == OperandType.Condition:
        operand_1 = BranchCond[decode_middle.operand_1].value

    if decode_middle.opcode.operand_2_type == OperandType.Register:
        operand_2 = Register[decode_middle.operand_2].value
    if decode_middle.opcode.operand_2_type == OperandType.AddressImmediate or decode_middle.opcode.operand_2_type == OperandType.IntegerImmediate:
        operand_2 = int(decode_middle.operand_2)
    if decode_middle.opcode.operand_2_type == OperandType.Condition:
        operand_2 = BranchCond[decode_middle.operand_2].value

    if decode_middle.opcode.operand_3_type == OperandType.Register:
        operand_3 = Register[decode_middle.operand_3].value
    if decode_middle.opcode.operand_3_type == OperandType.AddressImmediate or decode_middle.opcode.operand_3_type == OperandType.IntegerImmediate:
        operand_3 = int(decode_middle.operand_3)
    if decode_middle.opcode.operand_3_type == OperandType.Condition:
        operand_3 = BranchCond[decode_middle.operand_3].value
    if(operand_3 != None):
        instruction = decode_middle.opcode.machine_code + (operand_1 << decode_middle.opcode.operand_1_offset) + (operand_2 << decode_middle.opcode.operand_2_offset) + (operand_3 << decode_middle.opcode.operand_3_offset)
    else:
        instruction = decode_middle.opcode.machine_code + (operand_1 << decode_middle.opcode.operand_1_offset) + (operand_2 << decode_middle.opcode.operand_2_offset)
    instructions.append(instruction)

with open(out_path, "wb") as bf:
    bytes_used = len(instructions * 4)
    bytes_to_pad = 16768 - bytes_used
    for instruction in instructions:
        bf.write(instruction.to_bytes(4, byteorder='little', signed=False))
    for num in range(0, bytes_to_pad):
        bf.write((0).to_bytes(4, byteorder='little', signed=False))
