#!/usr/bin/env python3
# pyright: strict

from enum import Enum, auto
from typing import Optional
from argparse import ArgumentParser
from abc import ABC, abstractmethod

class Operand(ABC):
    @abstractmethod
    def parse(self, context: Context, parser: Parser) -> int:
        ...

class RegisterOperand(Operand):
    def __init__(self, offset: int):
        self.offset = offset

    def parse(self, context: Context, parser: Parser):
        token = parser.expect(TokenKind.IDENTIFIER)
        register = parser.file.get_register(token)
        return register.code << self.offset

class ImmediateOperand(Operand):
    def __init__(self, offset: int, bits: int, shift: int, relative: bool):
        self.offset = offset
        self.bits = bits
        self.shift = shift
        self.relative = relative

    def parse(self, context: Context, parser: Parser):
        if parser.match(TokenKind.HASH):
            token = parser.expect(TokenKind.NUMBER)
            number = parser.file.get_number(token)
            return (number & (1 << self.bits) - 1) << self.offset
        else:
            token = parser.expect(TokenKind.IDENTIFIER)
            text = parser.file.get_text(token)
            symbol = context.module.get_symbol(text)
            origin = len(context.section.data)
            relocation = Relocation(symbol, origin, self.offset, self.bits, self.shift, self.relative)
            context.section.relocations.append(relocation)
            return 0

class Register:
    by_name: dict[str, Register] = {}

    def __init__(self, name: str, code: int):
        Register.by_name[name] = self

        self.name = name
        self.code = code

class Instruction:
    by_name: dict[str, Instruction] = {}

    def __init__(self, name: str, code: int, operands: list[Operand]):
        Instruction.by_name[name] = self

        self.name = name
        self.code = code
        self.operands = operands

for i in range(32):
    Register(f"GP{i}", i)

Instruction("NOP", 0, [])
Instruction("HALT", 1, [])

Instruction("CALL", 16, [RegisterOperand(12)])
Instruction("CALLI", 17, [ImmediateOperand(12, 16, 0, True)])
Instruction("RET", 18, [])
Instruction("PUSH", 19, [RegisterOperand(12)])
Instruction("POP", 20, [RegisterOperand(7)])

Instruction("BR", 32, [RegisterOperand(7), ImmediateOperand(12, 16, 0, False)])
Instruction("BEQ", 33, [RegisterOperand(7), ImmediateOperand(12, 16, 0, False)])
Instruction("BNE", 34, [RegisterOperand(7), ImmediateOperand(12, 16, 0, False)])
Instruction("BLE", 35, [RegisterOperand(7), ImmediateOperand(12, 16, 0, False)])
Instruction("BLT", 36, [RegisterOperand(7), ImmediateOperand(12, 16, 0, False)])
Instruction("BGE", 37, [RegisterOperand(7), ImmediateOperand(12, 16, 0, False)])
Instruction("BGT", 38, [RegisterOperand(7), ImmediateOperand(12, 16, 0, False)])
Instruction("BLEU", 39, [RegisterOperand(7), ImmediateOperand(12, 16, 0, False)])
Instruction("BLTU", 40, [RegisterOperand(7), ImmediateOperand(12, 16, 0, False)])
Instruction("BGEU", 41, [RegisterOperand(7), ImmediateOperand(12, 16, 0, False)])
Instruction("BGTU", 42, [RegisterOperand(7), ImmediateOperand(12, 16, 0, False)])

Instruction("JMP", 48, [ImmediateOperand(12, 16, 0, True)])
Instruction("JEQ", 49, [ImmediateOperand(12, 16, 0, True)])
Instruction("JNE", 50, [ImmediateOperand(12, 16, 0, True)])
Instruction("JLE", 51, [ImmediateOperand(12, 16, 0, True)])
Instruction("JLT", 52, [ImmediateOperand(12, 16, 0, True)])
Instruction("JGE", 53, [ImmediateOperand(12, 16, 0, True)])
Instruction("JGT", 54, [ImmediateOperand(12, 16, 0, True)])
Instruction("JLEU", 55, [ImmediateOperand(12, 16, 0, True)])
Instruction("JLTU", 56, [ImmediateOperand(12, 16, 0, True)])
Instruction("JGEU", 57, [ImmediateOperand(12, 16, 0, True)])
Instruction("JGTU", 58, [ImmediateOperand(12, 16, 0, True)])

Instruction("ADD", 64, [RegisterOperand(7), RegisterOperand(12)])
Instruction("SUB", 65, [RegisterOperand(7), RegisterOperand(12)])
Instruction("MUL", 66, [RegisterOperand(7), RegisterOperand(12)])
Instruction("DIV", 67, [RegisterOperand(7), RegisterOperand(12)])
Instruction("AND", 68, [RegisterOperand(7), RegisterOperand(12)])
Instruction("OR", 69, [RegisterOperand(7), RegisterOperand(12)])
Instruction("XOR", 70, [RegisterOperand(7), RegisterOperand(12)])
Instruction("SHL", 71, [RegisterOperand(7), RegisterOperand(12)])
Instruction("SHR", 72, [RegisterOperand(7), RegisterOperand(12)])
Instruction("SRA", 73, [RegisterOperand(7), RegisterOperand(12)])

Instruction("ADDI", 80, [RegisterOperand(7), ImmediateOperand(12, 20, 0, False)])
Instruction("SUBI", 81, [RegisterOperand(7), ImmediateOperand(12, 20, 0, False)])
Instruction("MULI", 82, [RegisterOperand(7), ImmediateOperand(12, 20, 0, False)])
Instruction("DIVI", 83, [RegisterOperand(7), ImmediateOperand(12, 20, 0, False)])
Instruction("ANDI", 84, [RegisterOperand(7), ImmediateOperand(12, 20, 0, False)])
Instruction("ORI", 85, [RegisterOperand(7), ImmediateOperand(12, 20, 0, False)])
Instruction("XORI", 86, [RegisterOperand(7), ImmediateOperand(12, 20, 0, False)])
Instruction("SHLI", 87, [RegisterOperand(7), ImmediateOperand(12, 20, 0, False)])
Instruction("SHRI", 88, [RegisterOperand(7), ImmediateOperand(12, 20, 0, False)])
Instruction("SRAI", 89, [RegisterOperand(7), ImmediateOperand(12, 20, 0, False)])

Instruction("LD", 96, [RegisterOperand(7), RegisterOperand(12), ImmediateOperand(17, 15, 0, False)])
Instruction("LDB", 97, [RegisterOperand(7), RegisterOperand(12), ImmediateOperand(17, 15, 0, False)])
Instruction("ST", 98, [RegisterOperand(7), RegisterOperand(12), ImmediateOperand(17, 15, 0, False)])
Instruction("STB", 99, [RegisterOperand(7), RegisterOperand(12), ImmediateOperand(17, 15, 0, False)])
Instruction("LUI", 100, [RegisterOperand(7), ImmediateOperand(12, 20, 12, False)])
Instruction("LLI", 101, [RegisterOperand(7), ImmediateOperand(12, 20, 0, False)])
Instruction("NOT", 102, [RegisterOperand(7)])
Instruction("CMP", 103, [RegisterOperand(7), RegisterOperand(12)])
Instruction("MOV", 104, [RegisterOperand(7), RegisterOperand(12)])
Instruction("AMOV", 105, [RegisterOperand(7)])

class Relocation:
    def __init__(self, symbol: Symbol, origin: int, offset: int, bits: int, shift: int, relative: bool):
        self.symbol = symbol
        self.origin = origin
        self.offset = offset
        self.bits = bits
        self.shift = shift
        self.relative = relative

class Section:
    def __init__(self, name: str):
        self.name = name
        self.data = bytearray()
        self.relocations: list[Relocation] = []
        self.offset = 0

class Label:
    def __init__(self, section: Section, offset: int):
        self.section = section
        self.offset = offset

class Symbol:
    def __init__(self, name: str):
        self.name = name
        self.label: Optional[Label] = None

class Module:
    def __init__(self):
        self.sections: dict[str, Section] = {}
        self.symbols: dict[str, Symbol] = {}

    def get_section(self, name: str):
        if name in self.sections:
            return self.sections[name]

        section = Section(name)
        self.sections[name] = section
        return section

    def get_symbol(self, name: str):
        if name in self.symbols:
            return self.symbols[name]

        symbol = Symbol(name)
        self.symbols[name] = symbol
        return symbol

class TokenKind(Enum):
    NEWLINE = auto()
    COLON = auto()
    COMMA = auto()
    HASH = auto()
    NUMBER = auto()
    IDENTIFIER = auto()

class Token:
    def __init__(self, kind: TokenKind, start: int, end: int):
        self.kind = kind
        self.start = start
        self.end = end

def is_space(char: str):
    return char == " " or char == "\t"

def is_digit(char: str):
    return char in "0123456789"

def is_identifier_start(char: str):
    return char in "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_."

def is_identifier_continue(char: str):
    return is_identifier_start(char) or is_digit(char)

class File:
    def __init__(self, name: str, text: str):
        self.name = name
        self.text = text

    def error(self, position: int, message: str):
        line = self.text[:position].count("\n") + 1
        print(f"{self.name}:{line}: {message}")
        exit(1)

    def get_token(self, position: int):
        while position < len(self.text):
            start = position
            position += 1

            if self.text[start] == ";":
                while position < len(self.text) and self.text[position] != "\n":
                    position += 1
            elif self.text[start] == "\n":
                return Token(TokenKind.NEWLINE, start, position)
            elif self.text[start] == ":":
                return Token(TokenKind.COLON, start, position)
            elif self.text[start] == ",":
                return Token(TokenKind.COMMA, start, position)
            elif self.text[start] == "#":
                return Token(TokenKind.HASH, start, position)
            elif is_digit(self.text[start]) or self.text[start] == "-":
                while position < len(self.text) and is_digit(self.text[position]):
                    position += 1

                return Token(TokenKind.NUMBER, start, position)
            elif is_identifier_start(self.text[start]):
                while position < len(self.text) and is_identifier_continue(self.text[position]):
                    position += 1

                return Token(TokenKind.IDENTIFIER, start, position)
            elif not is_space(self.text[start]):
                self.error(start, f"invalid character {self.text[start]!r}")

    def get_text(self, token: Token):
        return self.text[token.start:token.end]

    def get_number(self, token: Token):
        return int(self.get_text(token))

    def get_register(self, token: Token):
        text = self.get_text(token)

        if text not in Register.by_name:
            self.error(token.start, f"unknown register {text!r}")

        return Register.by_name[text]

class Parser:
    def __init__(self, file: File):
        self.file = file
        self.token = file.get_token(0)

    def unexpected_token(self):
        if self.token:
            self.file.error(self.token.start, f"unexpected token {self.token.kind}")
        else:
            self.file.error(len(self.file.text), f"unexpected end of file")

    def match(self, token_kind: TokenKind):
        if self.token and self.token.kind is token_kind:
            token = self.token
            self.token = self.file.get_token(token.end)
            return token

    def expect(self, token_kind: TokenKind):
        if token := self.match(token_kind):
            return token

        self.unexpected_token()

class Context:
    def __init__(self, module: Module):
        self.module = module
        self.section = module.get_section(".text")

    def parse(self, file_name: str):
        with open(file_name) as f:
            text = f.read()

        file = File(file_name, text)
        parser = Parser(file)

        while parser.token:
            if token := parser.match(TokenKind.IDENTIFIER):
                identifier = file.get_text(token)

                if parser.match(TokenKind.COLON):
                    symbol = self.module.get_symbol(identifier)

                    if symbol.label:
                        file.error(token.start, f"duplicate symbol {identifier!r}")

                    symbol.label = Label(self.section, len(self.section.data))
                elif identifier == "DB":
                    while True:
                        if parser.match(TokenKind.HASH):
                            token = parser.expect(TokenKind.NUMBER)
                            self.section.data.append(file.get_number(token))
                        else:
                            parser.unexpected_token()

                        if not parser.match(TokenKind.COMMA):
                            break
                elif identifier == "SECTION":
                    token = parser.expect(TokenKind.IDENTIFIER)
                    text = parser.file.get_text(token)
                    self.section = self.module.get_section(text)
                elif identifier in Instruction.by_name:
                    instruction = Instruction.by_name[identifier]
                    code = instruction.code

                    for i, operand in enumerate(instruction.operands):
                        if i > 0:
                            parser.expect(TokenKind.COMMA)

                        code |= operand.parse(self, parser)

                    self.section.data += code.to_bytes(4, byteorder="little")
                else:
                    file.error(token.start, f"unknown statement {identifier!r}")

            parser.expect(TokenKind.NEWLINE)

if __name__ == "__main__":
    parser = ArgumentParser()
    parser.add_argument("file", nargs="+")
    parser.add_argument("--out", required=True)

    args = parser.parse_args()
    module = Module()

    for file_name in args.file:
        context = Context(module)
        context.parse(file_name)

    sections = list(module.sections.values())
    sections.sort(key=lambda section: section.name != ".main")
    offset = 0

    for section in sections:
        section.offset = offset
        offset += len(section.data)

    for section in sections:
        for relocation in section.relocations:
            if not relocation.symbol.label:
                print(f"undefined reference to symbol {relocation.symbol.name!r}")
                continue

            origin = relocation.origin
            code = int.from_bytes(section.data[origin:origin + 4], byteorder="little")
            offset = relocation.symbol.label.section.offset + relocation.symbol.label.offset

            if relocation.relative:
                offset -= section.offset + origin + 4

            code |= (offset >> relocation.shift & (1 << relocation.bits) - 1) << relocation.offset
            section.data[origin:origin + 4] = code.to_bytes(4, byteorder="little")

    with open(args.out, "wb") as f:
        for section in sections:
            f.write(section.data)
