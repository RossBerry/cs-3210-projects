"""
mal_syntax_checker.py
"""
__author__ = "Kenneth Berry"

import sys

# MAL instructions
MAL = {"LOAD": ['r', 's'],
       "LOADI": ['r', 'v'],
       "STORE": ['r', 'd'],
       "ADD": ['r1', 'r2', 'r3'],
       "INC": ['r'],
       "SUB": ['r1', 'r2', 'r3'],
       "DEC": ['r'],
       "BEQ": ['r1', 'r2', 'lab'],
       "BLT": ['r1', 'r2', 'lab'],
       "BGT": ['r1', 'r2', 'lab'],
       "BR": ['lab'],
       "NOOP": [],
       "END": []}

# r0-r8
REGISTERS = ['r' + str(n) for n in range(9)]


class SyntaxChecker:
    """MAL syntax checker"""

    def __init__(self):  # TODO: remove if not used
        self.__labels = None  # stores labels in MAL program

    def __read_program(self, mal_file):
        """Opens and reads MAL program file."""
        mal_program_lines = {}
        with open(mal_file, 'r') as file:
            for index, line in enumerate(file):
                mal_program_lines.update(
                    {str(index + 1): line.replace('\n'or'\r', '')})
        return mal_program_lines

    def __strip_program(self, original):
        """Strips blank lines and comments from program."""
        stripped = {}
        for line in original:
            if ";" in original[line]:
                index = original[line].find(';')
                if index != 0:
                    stripped.update(
                        {line: original[line][:index - 1]})
            elif original[line] != '':
                stripped.update({line: original[line]})
        return stripped

    def __write_report(self, original, stripped, evaluated):
        """Generate MAL program error listing section of report, finish up
        report and close report file.
        """
        divider = "\n-------------\n"
        print("HEADER")
        print(divider)
        for line in original:
            print(line, original[line])
        print(divider)
        for line in stripped:
            print(line, stripped[line])
        print(divider)
        for line in evaluated:
            print(line, evaluated[line])

    def __evaluate_program(self, stripped):
        """Process a line read in from the MAL program."""
        evaluated = {}
        for line in stripped:
            evaluated.update({line: stripped[line]})
            first_item = stripped[line].split()[0]
            if ":" in first_item:  # first item in line is a label
                self.__labels.update({first_item.replace(':', ''): [line, 0]})
                if len(first_item) > 6:
                    error_line = stripped[line] \
                        + ("\n   ** error: ill-formed label {} **").format(first_item)
                    evaluated.update({line: error_line})
            elif stripped[line].split()[0] in MAL.keys():  # first item is valid opcode
                evaluated_line = self.__evaluate_instruction(stripped[line])
                evaluated.update({line: evaluated_line})
            else:  # first item is invalid opcode
                error_line = stripped[line] + \
                    ("\n   ** error: invalid opcode {} **").format(first_item)
                evaluated.update({line: error_line})
        for label in self.__labels:
            if self.__labels[label][1] == 0:
                warning = "\n   ** warning: label is never branched to **"
                new_line = evaluated[self.__labels[label][0]] + warning
                evaluated.update({self.__labels[label][0]: new_line})
        return evaluated

    def __evaluate_instruction(self, instruction):
        """Evaluate if an instruction contains errors."""
        evaluated_line = instruction
        opcode = instruction.split()[0]
        operands = instruction.replace(",", "").split()[1:]

        # Check for valid number of operands
        if len(operands) < len(MAL[opcode]):
            evaluated_line += "\n   ** error: too few operands **"
        elif len(operands) > len(MAL[opcode]):
            evaluated_line += "\n   ** error: too many operands **"
        else:
            # Check for errors in operands
            operand_errors = self.__evaluate_operands(opcode, operands)
            if operand_errors:
                for operand_error in operand_errors:
                    evaluated_line += '\n' + operand_error
        return evaluated_line

    def __evaluate_operands(self, opcode, operands):
        """Evaluate if an operand is valid"""
        operand_errors = []
        valid_operands = MAL[opcode]
        for index, valid_operand in enumerate(valid_operands):
            if 'r' in valid_operand:  # register
                if operands[index] not in REGISTERS:
                    operand_errors.append(
                        ("   ** error: invalid register {} **").format(operands[index]))
            elif 'v' in valid_operand:  # literal value
                if '8' in operands[index] or '9' in operands[index]:
                    operand_errors.append(
                        ("   ** error: ill-formed literal {} **").format(operands[index]))
            elif 's' in valid_operand or 'd' in valid_operand:  # identifier
                if len(operands[index]) > 5:
                    operand_errors.append(
                        ("   ** error: ill-formed identifier {} **").format(operands[index]))
            elif 'lab' in valid_operand:  # label
                if len(operands[index]) > 5:
                    operand_errors.append(
                        ("   ** error: ill-formed label {} **").format(operands[index]))
                if operands[index] not in self.__labels.keys():
                    operand_errors.append(
                        ("   ** warning: branch to non-existant label {} **").format(operands[index]))
                else:
                    label_lst = self.__labels[operands[index]]
                    label_lst[1] += 1
                    self.__labels.update(
                        {operands[index]: label_lst})
        return operand_errors

    def check(self, mal_file):
        """Check syntax of MAL program"""
        self.__labels = {}  # Create empty label dictionary
        original = self.__read_program(mal_file)
        stripped = self.__strip_program(original)
        evaluated = self.__evaluate_program(stripped)
        self.__write_report(original, stripped, evaluated)


if __name__ == "__main__":
    MAL_FILE = sys.argv[1] + ".mal"
    SYNTAX_CHECKER = SyntaxChecker()
    SYNTAX_CHECKER.check(MAL_FILE)
