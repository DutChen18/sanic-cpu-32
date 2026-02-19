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
    IntegerImmediate15 = 3
    AddressImmediate = 4
    RegSpacer = 5
    SpecialRegister = 6
    One = 7
    Zero = 8
    Label = 9

operandtype_prefixes = {
    OperandType.Register: "",
    OperandType.IntegerImmediate20: "#",
    OperandType.IntegerImmediate16: "#",
    OperandType.IntegerImmediate15: "#",
    OperandType.AddressImmediate: "$",
    OperandType.SpecialRegister: "",
    OperandType.Label: "%"
}

class Operand:
    operand_type: OperandType
    offset: int
    def __init__(self, operand_type, offset):
        self.operand_type = operand_type
        self.offset = offset

class Operands:
    Register = Operand(OperandType.Register, 5)
    Register6 = Operand(OperandType.Register, 6)
    IntegerImmediate20 = Operand(OperandType.IntegerImmediate20, 20)
    IntegerImmediate16 = Operand(OperandType.IntegerImmediate16, 16)
    IntegerImmediate15 = Operand(OperandType.IntegerImmediate15, 15)
    RegSpacer = Operand(OperandType.RegSpacer, 5)

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
    "NOP":      Opcode(None,                        None,                           None,                           None, 0),
    "CALL":     Opcode(Operands.RegSpacer,          Operands.Register,              None,                           None, 16),
    "CALLI":    Opcode(Operands.RegSpacer,          Operands.IntegerImmediate16,    None,                           None, 17),
    "RET":      Opcode(None,                        None             ,              None,                           None, 18),
    "PUSH":     Opcode(Operands.RegSpacer,          Operands.Register,              None,                           None, 19),
    "POP":      Opcode(Operands.Register,           None             ,              None,                           None, 20),
    "BR":       Opcode(Operands.Register,           Operands.Register,              None,                           None, 32),
    "BEQ":      Opcode(Operands.Register,           Operands.Register,              None,                           None, 33),
    "BNE":      Opcode(Operands.Register,           Operands.Register,              None,                           None, 34),
    "BLE":      Opcode(Operands.Register,           Operands.Register,              None,                           None, 35),
    "BLT":      Opcode(Operands.Register,           Operands.Register,              None,                           None, 36),
    "BGT":      Opcode(Operands.Register,           Operands.Register,              None,                           None, 37),
    "BGE":      Opcode(Operands.Register,           Operands.Register,              None,                           None, 38),
    "BLEU":     Opcode(Operands.Register,           Operands.Register,              None,                           None, 39),
    "BLTU":     Opcode(Operands.Register,           Operands.Register,              None,                           None, 40),
    "BGEU":     Opcode(Operands.Register,           Operands.Register,              None,                           None, 41),
    "BGTU":     Opcode(Operands.Register,           Operands.Register,              None,                           None, 42),

    "JMP":      Opcode(Operands.RegSpacer,          Operands.IntegerImmediate16,    None,                           None, 48),
    "JEQ":      Opcode(Operands.RegSpacer,          Operands.IntegerImmediate16,    None,                           None, 49),
    "JNE":      Opcode(Operands.RegSpacer,          Operands.IntegerImmediate16,    None,                           None, 50),
    "JLE":      Opcode(Operands.RegSpacer,          Operands.IntegerImmediate16,    None,                           None, 51),
    "JLT":      Opcode(Operands.RegSpacer,          Operands.IntegerImmediate16,    None,                           None, 52),
    "JGT":      Opcode(Operands.RegSpacer,          Operands.IntegerImmediate16,    None,                           None, 53),
    "JGE":      Opcode(Operands.RegSpacer,          Operands.IntegerImmediate16,    None,                           None, 54),
    "JLEU":     Opcode(Operands.RegSpacer,          Operands.IntegerImmediate16,    None,                           None, 55),
    "JLTU":     Opcode(Operands.RegSpacer,          Operands.IntegerImmediate16,    None,                           None, 56),
    "JGEU":     Opcode(Operands.RegSpacer,          Operands.IntegerImmediate16,    None,                           None, 57),
    "JGTU":     Opcode(Operands.RegSpacer,          Operands.IntegerImmediate16,    None,                           None, 58),

    "ADD":      Opcode(Operands.Register,           Operands.Register,              None,                           None, 0b1000000),
    "SUB":      Opcode(Operands.Register,           Operands.Register,              None,                           None, 0b1000001),
    "MUL":      Opcode(Operands.Register,           Operands.Register,              None,                           None, 0b1000010),
    "DIV":      Opcode(Operands.Register,           Operands.Register,              None,                           None, 0b1000011),
    "OR" :      Opcode(Operands.Register,           Operands.Register,              None,                           None, 0b1000101),
    "AND":      Opcode(Operands.Register,           Operands.Register,              None,                           None, 0b1000100),
    "XOR":      Opcode(Operands.Register,           Operands.Register,              None,                           None, 0b1000110),
    "SHL":      Opcode(Operands.Register,           Operands.Register,              None,                           None, 0b1000111),
    "SHR":      Opcode(Operands.Register,           Operands.Register,              None,                           None, 0b1001000),

    "ADDI":     Opcode(Operands.Register,           Operands.IntegerImmediate20,    None,                           None, 0b1010000),
    "SUBI":     Opcode(Operands.Register,           Operands.IntegerImmediate20,    None,                           None, 0b1010001),
    "MULI":     Opcode(Operands.Register,           Operands.IntegerImmediate20,    None,                           None, 0b1010010),
    "DIVI":     Opcode(Operands.Register,           Operands.IntegerImmediate20,    None,                           None, 0b1010011),
    "ORI" :     Opcode(Operands.Register,           Operands.IntegerImmediate20,    None,                           None, 0b1010101),
    "ANDI":     Opcode(Operands.Register,           Operands.IntegerImmediate20,    None,                           None, 0b1010100),
    "XORI":     Opcode(Operands.Register,           Operands.IntegerImmediate20,    None,                           None, 0b1010110),
    "SHLI":     Opcode(Operands.Register,           Operands.IntegerImmediate20,    None,                           None, 0b1010111),
    "SHRI":     Opcode(Operands.Register,           Operands.IntegerImmediate20,    None,                           None, 0b1011000),

    "LD":       Opcode(Operands.Register,           Operands.Register,              Operands.IntegerImmediate15,    None, 96),
    "LDB":      Opcode(Operands.Register,           Operands.Register,              Operands.IntegerImmediate15,    None, 97),
    "ST":       Opcode(Operands.Register,           Operands.Register,              Operands.IntegerImmediate15,    None, 98),
    "STB":      Opcode(Operands.Register,           Operands.Register,              Operands.IntegerImmediate15,    None, 99),
    "LUI":      Opcode(Operands.Register,           Operands.IntegerImmediate16,    None,                           None, 100),
    "LLI":      Opcode(Operands.Register,           Operands.IntegerImmediate16,    None,                           None, 101),
    "NOT":      Opcode(Operands.Register,           None,                           None,                           None, 102),
    "CMP":      Opcode(Operands.Register,           Operands.Register,              None,                           None, 103),
    "MOV":      Opcode(Operands.Register,           Operands.Register,              None,                           None, 104),
    "AMOV":     Opcode(Operands.Register,           None,                           None,                           None, 105)
}

assembly_file = ""
out_path = ""
debug = False
vars_and_stuff = False
if len(sys.argv) > 1:
    assembly_file = sys.argv[1]
    out_path = sys.argv[2]
    if(len(sys.argv) > 3):
        vars_and_stuff = True
    if(len(sys.argv) > 4):
        debug = True 


#XORI GP0, #1
#XORI GP1, #2
#ADD  GP0, GP1



def pack_operand(instruction, operand, offset, bit_width):
    if operand is None:
        return instruction, offset
    mask = (1 << bit_width) - 1
    instruction |= (operand & mask) << offset
    offset += bit_width
    return instruction, offset

# First, get all lines, and attempt to find instructions that match the opcode (split by " ", first cell is opcode)
# If any are found that don't match an instruction, error with the line # and reason like a compiler.
instructions =  []
instruction_opcode_decoded = []
labels = {}
variables = {}
with open(assembly_file, "r") as af:
    line_count = 0
    # Gather labels first
    for line in af:
        stripped_line = line.strip('\n').strip().split(';')[0]
        if(len(stripped_line) > 0):
            if(debug):
                print(f"last char: {stripped_line[len(stripped_line)-1]}")
            if(stripped_line[len(stripped_line) - 1] == ':'):
                labels[stripped_line.strip(':')] = line_count+1
            if(stripped_line[0] == '.'):
                if(vars_and_stuff):
                    print(f"DEBUG: {stripped_line}")
                    print(f"DEBUG: {stripped_line.strip('.').split(' ')[0]}")
                    print(f"DEBUG: {stripped_line.strip('.').split(' ')[1]}")
                variables[stripped_line.strip('.').split(' ')[0]] = stripped_line.split(' ')[1]
            if(stripped_line[0] != ';' and stripped_line[0] != '\n' and stripped_line[len(stripped_line) - 1] != ':' and stripped_line[0] != '.'):
                line_count += 1 
errors = []
line_count = 1
if(vars_and_stuff):
    for variable in variables:
        print(f"Variable: {variable} val: {variables[variable]}")
    for label in labels:
        print(f"Label: {label} val: {labels[label]}")

with open(assembly_file, "r") as af:
    for line in af:
        temp_line = line
        stripped_line = temp_line.strip()
        split = stripped_line.split(" ")
        opcode_str = split[0]
        if debug == True:
            print(f"raw line: {repr(temp_line)} len: {len(temp_line)}")
            print(f"opcode split count: {len(split)}")
            print(f"opcode str: {opcode_str} (len: {len(opcode_str)})")
        if temp_line == "" or temp_line == "\n":
            # Skip empty lines
            continue
        #print(f"opcode str: {opcode_str} len: {len(opcode_str)}")
        if(len(opcode_str) == 0):
            continue
        if opcode_str[0] == ';':
            continue # It's a comment
        if opcode_str[len(opcode_str)-1] == ':':
            # Skip labels, already gathered
            continue
        if opcode_str[0] == '.':
            # Skip variables, already gathered
            continue
        if opcode_str not in instruction_table:
            right_justified_error = "Invalid opcode"
            errors.append( temp_line + "\n^" + right_justified_error)
            continue
        line_count += 1
        opcode = instruction_table[opcode_str]
        arguments = stripped_line[len(opcode_str):].strip().split(",")
        operand_1 = ""
        operand_2 = ""
        operand_3 = ""
        operand_4 = ""
        op1_comment = False
        op2_comment = False
        op3_comment = False
        op4_comment = False 
        if(opcode.operand_1 == Operands.RegSpacer):
            operand_2 = arguments[0].strip().split(';')[0]
            if len(arguments[0].strip().split(';')) > 1:
                op1_comment = True
                op2_comment = True
                op3_comment = True
            if operand_2.strip(':').strip() in labels:
                if debug:
                    print(f"label exists in dict")
                # Replace label with instruction number to allow the jump to work.
                label_value = labels[operand_2.strip(':').strip()]
                operand_2 = f"#{(label_value - line_count)}"# Set operand_2 to the difference
                if vars_and_stuff:
                    print(f"translated op: {operand_2}")
                # Added complexity as well if the target line is more than 16-bits of lines away? It should be rejected until we implement some kind of far branching

        elif opcode.operand_1 != None:
            operand_1 = arguments[0].strip().split(';')[0]
            if len(arguments[0].strip().split(';')) > 1:
                op1_comment = True
                op2_comment = True
                op3_comment = True
            if(debug):
                print(f"operand_1: {operand_1}")
            if operand_1.strip() in labels:
                if debug:
                    print(f"label exists in dict")
                # Replace label with instruction number to allow the jump to work.
                label_value = labels[operand_1.strip(':').strip()]
                operand_1 = f"#{(label_value - line_count)}"# Set operand_2 to the difference 
                # Added complexity as well if the target line is more than 16-bits of lines away? It should be rejected until we implement some kind of far branching
        if len(arguments) > 1 and op1_comment == False:
            operand_2 = arguments[1].strip().split(";")[0]
            if debug:
                print(f"operand_2: {operand_2}")
            if len(arguments[1].strip().split(';')) > 1:
                op2_comment = True
            if operand_2.strip() in labels:
                if debug:
                    print(f"label exists in dict")
                # Replace label with instruction number to allow the jump to work.
                label_value = labels[operand_2.strip(':').strip()]
                operand_2 = f"#{(label_value - line_count)}"# Set operand_2 to the difference 
                #Added complexity as well if the target line is more than 16-bits of lines away? It should be rejected until we implement some kind of far branching
            if operand_2[0] == '.':
                # Is variable
                if operand_2.strip('.').strip() in variables:
                    var_value = variables[operand_2.strip('.').strip()]
                    operand_2 = f"#{var_value}"
        if len(arguments) > 2 and op1_comment == False and op2_comment == False: 
            operand_3 = arguments[2].strip().split(";")[0]
            if len(arguments[2].strip().split(';')) > 1:
                op3_comment = True
        if len(arguments) > 3 and op1_comment == False and op2_comment == False and op3_comment == False:
            if len(arguments[3].strip().split(';')) > 1:
                op4_comment = True
            operand_4 = arguments[3].strip().split(";")[0]
        if opcode.operand_1 != None and opcode.operand_1 != Operands.RegSpacer:
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
            if len(operand_1) > 0 and opcode.operand_1.operand_type == OperandType.IntegerImmediate20 or opcode.operand_1.operand_type == OperandType.IntegerImmediate16 or opcode.operand_1.operand_type == OperandType.IntegerImmediate15:
                if not can_decode_to_int(operand_1.strip("#")):
                    operand_start = line.find(operand_1)
                    right_justified_error = " " * operand_start + "^Immediate not decodable to integer."
                    errors.append( line + "\n" +  right_justified_error)
                    continue
        if opcode.operand_2 != None and len(arguments) > 1:
            if opcode.operand_2.operand_type != OperandType.Register and opcode.operand_2.operand_type != OperandType.SpecialRegister:
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
            if len(operand_2) > 0 and opcode.operand_2.operand_type == OperandType.IntegerImmediate20 or opcode.operand_2.operand_type == OperandType.IntegerImmediate16 or opcode.operand_2.operand_type == OperandType.IntegerImmediate15:
                if not can_decode_to_int(operand_2.strip("#")):
                    if operand_2[0] == ':':
                        # Check for Label
                        if operand_2.strip('.') in variables:
                            operand_2 = f"{variables[operand_2.strip('.')]}"
                        else:                            
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
            if len(operand_3) > 0 and opcode.operand_3.operand_type != OperandType.Register and opcode.operand_3.operand_type != OperandType.SpecialRegister:
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
            if len(operand_4) > 0 and opcode.operand_4.operand_type != OperandType.Register and opcode.operand_4.operand_type != OperandType.SpecialRegister:
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
            if len(operand_4) > 0 and opcode.operand_4.operand_type == OperandType.IntegerImmediate20 or opcode.operand_4.operand_type == OperandType.IntegerImmediate16 or opcode.operand_2.operand_type == OperandType.IntegerImmediate15:
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
    if decode_middle.opcode.operand_1 != None and decode_middle.opcode.operand_1.operand_type != OperandType.RegSpacer:
        if decode_middle.opcode.operand_1.operand_type == OperandType.Register:
            operand_1 = Register[decode_middle.operand_1].value
        if decode_middle.opcode.operand_1.operand_type == OperandType.AddressImmediate or decode_middle.opcode.operand_1.operand_type == OperandType.IntegerImmediate20 or decode_middle.opcode.operand_1.operand_type == OperandType.IntegerImmediate16:
            operand_1 = int(decode_middle.operand_1)
    # Operand 2
    if decode_middle.opcode.operand_2 != None:
        if decode_middle.opcode.operand_2.operand_type == OperandType.Register:
            operand_2 = Register[decode_middle.operand_2].value
        if decode_middle.opcode.operand_2.operand_type == OperandType.AddressImmediate or decode_middle.opcode.operand_2.operand_type == OperandType.IntegerImmediate20 or decode_middle.opcode.operand_2.operand_type == OperandType.IntegerImmediate16:
            operand_2 = int(decode_middle.operand_2)
    # Operand 3
    if decode_middle.opcode.operand_3 != None:
        if decode_middle.opcode.operand_3.operand_type == OperandType.Register:
            operand_3 = Register[decode_middle.operand_3].value
        if decode_middle.opcode.operand_3.operand_type == OperandType.AddressImmediate or decode_middle.opcode.operand_3.operand_type == OperandType.IntegerImmediate20 or decode_middle.opcode.operand_3.operand_type == OperandType.IntegerImmediate16 or decode_middle.opcode.operand_3.operand_type == OperandType.IntegerImmediate15:
            operand_3 = int(decode_middle.operand_3)
            mask = (1 << decode_middle.opcode.operand_3.offset) - 1
            sign_bit = ((1 << decode_middle.opcode.operand_3.offset - 1))
            raw_operand = int(decode_middle.operand_3)
            operand_3 = raw_operand & mask
            if(debug):
                print(f"raw: {raw_operand}, op3: {operand_3}")
                print(f"bin: {bin(raw_operand)}\n{bin(operand_3)}")
    # Operand 4
    if decode_middle.opcode.operand_4 != None:
        if decode_middle.opcode.operand_4.operand_type == OperandType.Register:
            operand_4 = Register[decode_middle.operand_4].value
        if decode_middle.opcode.operand_4.operand_type == OperandType.AddressImmediate or decode_middle.opcode.operand_4.operand_type == OperandType.IntegerImmediate20 or decode_middle.opcode.operand_4.operand_type == OperandType.IntegerImmediate16 or decode_middle.opcode.operand_3.operand_type == OperandType.IntegerImmediate15:
            operand_4 = int(decode_middle.operand_4)
    instruction = decode_middle.opcode.machine_code
    offset = 7
    if(debug):
        print(f"Opcode: {decode_middle.opcode.machine_code}")
        if(decode_middle.opcode.operand_1 != None):
            print(f"Op1: {decode_middle.opcode.operand_1.operand_type.value}, {decode_middle.operand_1}")
        if(decode_middle.opcode.operand_2 != None):
            print(f"Op2: {decode_middle.opcode.operand_2.operand_type.value}, {decode_middle.operand_2}")
        if(decode_middle.opcode.operand_3 != None):
            print(f"Op3: {decode_middle.opcode.operand_3.operand_type.value}, {decode_middle.operand_3}")
        if(decode_middle.opcode.operand_4 != None):
            print(f"Op4: {decode_middle.opcode.operand_4.operand_type.value}, {decode_middle.operand_4}")

    if(decode_middle.opcode.operand_1 == Operands.RegSpacer):
        offset += Operands.RegSpacer.offset
    if(operand_1 != None):
        instruction, offset = pack_operand(instruction, operand_1, offset, decode_middle.opcode.operand_1.offset)
        if(debug):
            print(f"Op1: {bin(instruction)} ({instruction})")
    if(operand_2 != None):
        instruction, offset = pack_operand(instruction, operand_2, offset, decode_middle.opcode.operand_2.offset)
        if(debug):
            print(f"Op2: {bin(instruction)} ({instruction})")
    if(operand_3 != None):
        instruction, offset = pack_operand(instruction, operand_3, offset, decode_middle.opcode.operand_3.offset)
        if(debug):
            print(f"Op3: {bin(instruction)} ({instruction})")
    if(operand_4 != None):
        instruction, offset = pack_operand(instruction, operand_4, offset, decode_middle.opcode.operand_4.offset)
        if(debug):
            print(f"Op4: {bin(instruction)}")
    instructions.append(instruction)

with open(out_path, "wb") as bf:
    for instruction in instructions:
        if(debug):
            print(f"writing instruction: {instruction}")
            print(f"bin: {bin(instruction)}")
        bf.write(instruction.to_bytes(4, byteorder='little', signed=False))

