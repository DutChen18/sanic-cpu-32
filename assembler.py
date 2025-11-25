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
    IntegerImmediate20 = 1
    IntegerImmediate16 = 2
    AddressImmediate = 3
    Condition = 4
    SpecialRegister = 5
    One = 6
    Zero = 7

operandtype_prefixes = {
    OperandType.Register: "",
    OperandType.IntegerImmediate20: "#",
    OperandType.IntegerImmediate16: "#",
    OperandType.AddressImmediate: "$",
    OperandType.Condition: "",
    OperandType.SpecialRegister: ""
}

class Operand:
    operand_type: OperandType
    offset_1: int
    def __init__(self, operand_type, offset):
        self.operand_type = operand_type
        self.offset = offset

class Operands:
    Register = Operand(OperandType.Register, 5)
    Register6 = Operand(OperandType.Register, 6)
    IntegerImmediate20 = Operand(OperandType.IntegerImmediate20, 20)
    IntegerImmediate16 = Operand(OperandType.IntegerImmediate16, 16)
    Condition = Operand(OperandType.Condition, 4)

class Opcode:
    operand_1: Operand
    operand_2: Operand
    operand_3: Operand
    operand_4: Operand
    machine_code: int

    def __init__(self, operand_1, operand_2, operand_3, operand_4, machine_code = 0b0):
        self.operand_1 = operand_1
        self.operand_2 = operand_2
        self.operand_3 = operand_3
        self.operand_4 = operand_4
        self.machine_code = machine_code

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
    operand_4: str

    def __init__(self, opcode, operand_1, operand_2, operand_3, operand_4):
        self.opcode = opcode
        self.operand_1 = operand_1
        self.operand_2 = operand_2
        self.operand_3 = operand_3
        self.operand_4 = operand_4

instruction_table = {
    "CMP":      Opcode(Operands.Register,   Operands.Register,              None,                           None, 0b0010000),
    "BR":       Opcode(Operands.Condition,  Operands.Register,              Operands.IntegerImmediate16,    None, 0b0010001),
    "JMP":      Opcode(Operands.Condition,  Operands.IntegerImmediate16,    None,                           None, 0b0010010),
    "CALL":     Opcode(Operands.Register,   Operands.IntegerImmediate16,    None,                           None, 0b0010011),
    "RET":      Opcode(None,                None,                           None,                           None, 0b0010100),

    "LD":       Opcode(Operands.Register,   Operands.Register,              Operands.IntegerImmediate16,    None, 0b0100000),
    "ST":       Opcode(Operands.Register,   Operands.Register,              Operands.IntegerImmediate16,    None, 0b0100001),
    "MOV":      Opcode(Operands.Register6,  Operands.Register,              None,                           None, 0b0100010),
    "LUI":      Opcode(Operands.Register,   Operands.IntegerImmediate16,    None,                           None, 0b0100011),
    "NOT":      Opcode(Operands.Register,   None,                           None,                           None, 0b0100100),

    "ADD":      Opcode(Operands.Register,   Operands.Register,              None,                           None, 0b1000000),
    "SUB":      Opcode(Operands.Register,   Operands.Register,              None,                           None, 0b1000001),
    "MUL":      Opcode(Operands.Register,   Operands.Register,              None,                           None, 0b1000010),
    "DIV":      Opcode(Operands.Register,   Operands.Register,              None,                           None, 0b1000011),
    "OR" :      Opcode(Operands.Register,   Operands.Register,              None,                           None, 0b1000100),
    "AND":      Opcode(Operands.Register,   Operands.Register,              None,                           None, 0b1000101),
    "XOR":      Opcode(Operands.Register,   Operands.Register,              None,                           None, 0b1000110),
    "SHR":      Opcode(Operands.Register,   Operands.Register,              None,                           None, 0b1000111),
    "SHL":      Opcode(Operands.Register,   Operands.Register,              None,                           None, 0b1001000),

    "ADDI":     Opcode(Operands.Register,   Operands.IntegerImmediate20,    None,                           None, 0b1010000),
    "SUBI":     Opcode(Operands.Register,   Operands.IntegerImmediate20,    None,                           None, 0b1010001),
    "MULI":     Opcode(Operands.Register,   Operands.IntegerImmediate20,    None,                           None, 0b1010010),
    "DIVI":     Opcode(Operands.Register,   Operands.IntegerImmediate20,    None,                           None, 0b1010011),
    "ORI" :     Opcode(Operands.Register,   Operands.IntegerImmediate20,    None,                           None, 0b1010100),
    "ANDI":     Opcode(Operands.Register,   Operands.IntegerImmediate20,    None,                           None, 0b1010101),
    "XORI":     Opcode(Operands.Register,   Operands.IntegerImmediate20,    None,                           None, 0b1010110),
    "SHIR":     Opcode(Operands.Register,   Operands.IntegerImmediate20,    None,                           None, 0b1010111),
    "SHIL":     Opcode(Operands.Register,   Operands.IntegerImmediate20,    None,                           None, 0b1011000),
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
        operand_2 = ""
        operand_3 = ""
        operand_4 = ""
        if len(arguments) > 1:
            operand_2 = arguments[1].strip()
        if len(arguments) > 2: 
            operand_3 = arguments[2].strip()
        if len(arguments) > 3:
            operand_4 = arguments[3].strip()

        if opcode.operand_1 != None:
            if opcode.operand_1.operand_type != OperandType.Register and opcode.operand_1.operand_type != OperandType.SpecialRegister and opcode.operand_1.operand_type != OperandType.Condition:
                if operand_1[0] != operandtype_prefixes[opcode.operand_1.operand_type]:
                    operand_start = line.find(operand_1)
                    right_justified_error = " " * operand_start + "^Invalid operand - possibly bad symbol"
                    errors.append( line + "\n" +  right_justified_error)
                    continue
            if opcode.operand_1.operand_type == OperandType.Register:
                if not operand_1.strip() in Register.__members__:
                    operand_start = line.find(operand_1)
                    right_justified_error = " " * operand_start + "^Register by that name does not exist."
                    errors.append( line + "\n" +  right_justified_error)
                    continue
            if len(operand_1) > 0 and opcode.operand_1.operand_type == OperandType.IntegerImmediate20 or opcode.operand_1.operand_type == OperandType.IntegerImmediate16:
                if not can_decode_to_int(operand_1.strip("#")):
                    operand_start = line.find(operand_1)
                    right_justified_error = " " * operand_start + "^Immediate not decodable to integer."
                    errors.append( line + "\n" +  right_justified_error)
                    continue
            if opcode.operand_1.operand_type == OperandType.Condition and not operand_1 in BranchCond.__members__:
                operand_start = line.find(operand_1)
                right_justified_error = " " * operand_start + "^Invalid Condition"
                errors.append( line + "\n" +  right_justified_error)
                continue
        if opcode.operand_2 != None:
            if opcode.operand_2.operand_type != OperandType.Register and opcode.operand_2.operand_type != OperandType.SpecialRegister and opcode.operand_2.operand_type != OperandType.Condition:
                if operand_2[0] != operandtype_prefixes[opcode.operand_2.operand_type]:
                    operand_start = line.find(operand_2)
                    right_justified_error = " " * operand_start + "^Invalid operand - possibly bad symbol"
                    errors.append( line + "\n" +  right_justified_error)
                    continue
            if len(operand_2) > 0 and opcode.operand_2.operand_type == OperandType.Register:
                if not operand_2.strip() in Register.__members__:
                    operand_start = line.find(operand_2)
                    right_justified_error = " " * operand_start + "^Register by that name does not exist."
                    errors.append( line + "\n" +  right_justified_error)
                    continue
            if len(operand_2) > 0 and opcode.operand_2.operand_type == OperandType.IntegerImmediate20 or opcode.operand_2.operand_type == OperandType.IntegerImmediate16:
                if not can_decode_to_int(operand_2.strip("#")):
                    operand_start = line.find(operand_2)
                    right_justified_error = " " * operand_start + "^Immediate not decodable to integer."
                    errors.append( line + "\n" +  right_justified_error)
                    continue
            if len(operand_2) > 0 and opcode.operand_2.operand_type == OperandType.AddressImmediate:
                if opcode_str == "ST" and int(operand_2.strip("$")) < 0x3FFFFF and int(operand_2.strip("$")) >= 0x000000:
                    operand_start = line.find(operand_2)
                    right_justified_error = " " * operand_start + "^Illegal write to read-only memory."
                    errors.append( line + "\n" +  right_justified_error)
                    continue
                if opcode_str == "ST" or opcode_str == "LD" and int(operand_2.strip("$")) > 0xFFFFFF:
                    operand_start = line.find(operand_2)
                    right_justified_error = " " * operand_start + "^Invalid memory address"
                    errors.append( line + "\n" +  right_justified_error)
                    continue
        if opcode.operand_3 != None:
            if len(operand_3) > 0 and opcode.operand_3.operand_type != OperandType.Register and opcode.operand_3.operand_type != OperandType.SpecialRegister and opcode.operand_3.operand_type != OperandType.Condition:
                if operand_3[0] != operandtype_prefixes[opcode.operand_3.operand_type]:
                    operand_start = line.find(operand_3)
                    right_justified_error = " " * operand_start + "^Invalid operand - possibly bad symbol"
                    errors.append( line + "\n" +  right_justified_error)
                    continue
            if len(operand_3) > 0 and opcode.operand_3.operand_type == OperandType.Register:
                if not operand_3.strip() in Register.__members__:
                    operand_start = line.find(operand_3)
                    right_justified_error = " " * operand_start + "^Register by that name does not exist."
                    errors.append( line + "\n" +  right_justified_error)
                    continue
            if len(operand_3) > 0 and opcode.operand_3.operand_type == OperandType.IntegerImmediate20 or opcode.operand_3.operand_type == OperandType.IntegerImmediate16:
                if not can_decode_to_int(operand_3.strip("#")):
                    operand_start = line.find(operand_3)
                    right_justified_error = " " * operand_start + "^Immediate not decodable to integer."
                    errors.append( line + "\n" +  right_justified_error)
                    continue
            if len(operand_3) > 0 and opcode.operand_3.operand_type == OperandType.AddressImmediate:
                if opcode_str == "ST" and int(operand_3.strip("$")) < 0x3FFFFF and int(operand_2.strip("$")) >= 0x000000:
                    operand_start = line.find(operand_3)
                    right_justified_error = " " * operand_start + "^Illegal write to read-only memory."
                    errors.append( line + "\n" +  right_justified_error)
                    continue
                if opcode_str == "ST" or opcode_str == "LD" and int(operand_3.strip("$")) > 0xFFFFFF:
                    operand_start = line.find(operand_3)
                    right_justified_error = " " * operand_start + "^Invalid memory address"
                    errors.append( line + "\n" +  right_justified_error)
                    continue
        if opcode.operand_4 != None:
            if len(operand_4) > 0 and opcode.operand_4.operand_type != OperandType.Register and opcode.operand_4.operand_type != OperandType.SpecialRegister and opcode.operand_4.operand_type != OperandType.Condition:
                if operand_4[0] != operandtype_prefixes[opcode.operand_4.operand_type]:
                    operand_start = line.find(operand_4)
                    right_justified_error = " " * operand_start + "^Invalid operand - possibly bad symbol"
                    errors.append( line + "\n" +  right_justified_error)
                    continue
            if len(operand_4) > 0 and opcode.operand_4.operand_type == OperandType.Register:
                if not operand_4.strip() in Register.__members__:
                    operand_start = line.find(operand_4)
                    right_justified_error = " " * operand_start + "^Register by that name does not exist."
                    errors.append( line + "\n" +  right_justified_error)
                    continue
            if len(operand_4) > 0 and opcode.operand_4.operand_type == OperandType.IntegerImmediate20 or opcode.operand_4.operand_type == OperandType.IntegerImmediate16:
                if not can_decode_to_int(operand_4.strip("#")):
                    operand_start = line.find(operand_4)
                    right_justified_error = " " * operand_start + "^Immediate not decodable to integer."
                    errors.append( line + "\n" +  right_justified_error)
                    continue
            if len(operand_4) > 0 and opcode.operand_4.operand_type == OperandType.AddressImmediate:
                if opcode_str == "ST" and int(operand_4.strip("$")) < 0x3FFFFF and int(operand_2.strip("$")) >= 0x000000:
                    operand_start = line.find(operand_4)
                    right_justified_error = " " * operand_start + "^Illegal write to read-only memory."
                    errors.append( line + "\n" +  right_justified_error)
                    continue
                if opcode_str == "ST" or opcode_str == "LD" and int(operand_4.strip("$")) > 0xFFFFFF:
                    operand_start = line.find(operand_4)
                    right_justified_error = " " * operand_start + "^Invalid memory address"
                    errors.append( line + "\n" +  right_justified_error)
                    continue
        instruction_opcode_decoded.append(Instruction(opcode, operand_1.strip(" #$"), operand_2.strip(" #$"), operand_3.strip(" #$"), operand_4.strip(" #$")))

if len(errors) > 0:
    for error in errors:
        print(error)
    exit(1)

for decode_middle in instruction_opcode_decoded:
    operand_1 = None
    operand_2 = None
    operand_3 = None
    operand_4 = None
    if decode_middle.opcode.operand_1 != None:
        if decode_middle.opcode.operand_1.operand_type == OperandType.Register:
            operand_1 = Register[decode_middle.operand_1].value
        if decode_middle.opcode.operand_1.operand_type == OperandType.AddressImmediate or decode_middle.opcode.operand_1.operand_type == OperandType.IntegerImmediate20 or decode_middle.opcode.operand_1.operand_type == OperandType.IntegerImmediate16:
            operand_1 = int(decode_middle.operand_1)
        if decode_middle.opcode.operand_1.operand_type == OperandType.Condition:
            operand_1 = BranchCond[decode_middle.operand_1].value
    # Operand 2
    if decode_middle.opcode.operand_2 != None:
        if decode_middle.opcode.operand_2.operand_type == OperandType.Register:
            operand_2 = Register[decode_middle.operand_2].value
        if decode_middle.opcode.operand_2.operand_type == OperandType.AddressImmediate or decode_middle.opcode.operand_2.operand_type == OperandType.IntegerImmediate20 or decode_middle.opcode.operand_2.operand_type == OperandType.IntegerImmediate16:
            operand_2 = int(decode_middle.operand_2)
        if decode_middle.opcode.operand_2.operand_type == OperandType.Condition:
            operand_2 = BranchCond[decode_middle.operand_2].value
    # Operand 3
    if decode_middle.opcode.operand_3 != None:
        if decode_middle.opcode.operand_3.operand_type == OperandType.Register:
            operand_3 = Register[decode_middle.operand_3].value
        if decode_middle.opcode.operand_3.operand_type == OperandType.AddressImmediate or decode_middle.opcode.operand_3.operand_type == OperandType.IntegerImmediate20 or decode_middle.opcode.operand_3.operand_type == OperandType.IntegerImmediate16:
            operand_3 = int(decode_middle.operand_3)
        if decode_middle.opcode.operand_3.operand_type == OperandType.Condition:
            operand_3 = BranchCond[decode_middle.operand_3].value
    # Operand 4
    if decode_middle.opcode.operand_4 != None:
        if decode_middle.opcode.operand_4.operand_type == OperandType.Register:
            operand_4 = Register[decode_middle.operand_4].value
        if decode_middle.opcode.operand_4.operand_type == OperandType.AddressImmediate or decode_middle.opcode.operand_4.operand_type == OperandType.IntegerImmediate20 or decode_middle.opcode.operand_4.operand_type == OperandType.IntegerImmediate16:
            operand_4 = int(decode_middle.operand_4)
        if decode_middle.opcode.operand_4.operand_type == OperandType.Condition:
            operand_4 = BranchCond[decode_middle.operand_4].value
    
    instruction = decode_middle.opcode.machine_code
    offset = 7
    
    if(operand_1 != None):
        instruction += (operand_1 << offset)
        offset += decode_middle.opcode.operand_1.offset
    if(operand_2 != None):
        instruction += (operand_2 << offset)
        offset += decode_middle.opcode.operand_2.offset
    if(operand_3 != None):
        instruction += (operand_3 << offset)
        offset += decode_middle.opcode.operand_3.offset
    if(operand_4 != None):
        instruction += (operand_4 << offset)
        offset += decode_middle.opcode.operand_4.offset
    instructions.append(instruction)

with open(out_path, "wb") as bf:
    bytes_used = len(instructions * 4)
    bytes_to_pad = 16768 - bytes_used
    for instruction in instructions:
        bf.write(instruction.to_bytes(4, byteorder='little', signed=False))
    for num in range(0, bytes_to_pad):
        bf.write((0).to_bytes(4, byteorder='little', signed=False))
