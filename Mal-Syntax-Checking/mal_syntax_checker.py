"""
mal_syntax_checker.py
"""
__author__ = "Kenneth Berry"

import sys
import datetime

# MAL instructions
MAL = {"LOAD": ['r', 's'],
       "LOADI": ['r', 'v'],
       "STORE": ['r', 'd'],
       "ADD": ['r1', 'r2', 'r3'],
       "SUB": ['r1', 'r2', 'r3'],
       "INC": ['r'],
       "DEC": ['r'],
       "BEQ": ['r1', 'r2', 'lab'],
       "BLT": ['r1', 'r2', 'lab'],
       "BGT": ['r1', 'r2', 'lab'],
       "BR": ['lab'],
       "NOOP": [],
       "END": []}

# Valid Registers r0-r7
REGISTERS = ['r' + str(n) for n in range(8)]


class SyntaxChecker:
    """MAL syntax checker"""

    def __init__(self):
        self.__labels = None # stores all labels in the MAL program

    def __read_program(self, mal_file):
        """Opens and reads MAL program file."""
        lines = {}
        with open(mal_file, 'r') as file:
            # Add lines to dictionary: {line_num: line}
            for index, line in enumerate(file):
                lines.update(
                    {str(index + 1): line.replace('\n'or'\r', '')})
        stripped = self.__strip_program(lines)
        return lines, stripped

    def __strip_program(self, original):
        """Strip blank lines and comments from program."""
        stripped = {}
        for line in original:
            if ";" in original[line]: # Line contains a comment
                index = original[line].find(';')
                if index != 0: # In-line comment
                    # Remove comment from line
                    stripped.update(
                        {line: original[line][:index - 1]})
            elif original[line] != '': # Line not blank and has no comments
                stripped.update({line: original[line]})
        return stripped

    def __write_report(self, original, stripped, evaluated):
        """Generate MAL program error listing section of report, finish up
        report and close report file.
        """
        mal_file = sys.argv[1] + ".mal"
        report_file = sys.argv[1] + ".log"
        now = datetime.datetime.now()
        date = str(now.month) + '/' + str(now.day) + '/' + str(now.year)
        header = mal_file + ' - ' + report_file + ' - ' + \
            date + ' - ' + __author__ + ' - ' + "CS3210\n"
        divider = "\n-------------\n\n"

        with open(report_file, 'w') as file:
            file.write(header)
            file.write(divider)
            file.write("original MAL program listing:\n\n")
            for line in original:
                file.write(line)
                if int(line) < 10:
                    file.write('.  ' + original[line] + '\n')
                else:
                    file.write('. ' + original[line] + '\n')
            file.write(divider)
            file.write("stripped MAL program listing:\n\n")
            for line in stripped:
                file.write(line)
                if int(line) < 10:
                    file.write('.  ' + stripped[line] + '\n')
                else:
                    file.write('. ' + stripped[line] + '\n')
            file.write(divider)
            file.write("error report listing:\n\n")
            for line in evaluated:
                file.write(line)
                if int(line) < 10:
                    file.write('.  ' + evaluated[line] + '\n')
                else:
                    file.write('. ' + evaluated[line] + '\n')

    def __evaluate_program(self, stripped):
        """Evaluate syntax for each line in MAL program."""
        evaluated = {}
        # Look for labels in program
        for line in stripped:
            first_item = stripped[line].split()[0]
            if ':' in first_item: # Label
                # Add label to labels dictionary:
                # {label_name: [line_num, reference_count]}
                self.__labels.update({first_item.replace(':', ''): [line, 0]})
        # Check each line in program for valid syntax
        for line in stripped:
            evaluated.update({line: stripped[line]})
            first_item = stripped[line].split()[0]
            if ":" in first_item: # First item in line is a label
                label = first_item.replace(':', '')
                if len(label) > 5:
                    error_line = stripped[line] \
                        + ("\n    ** error: ill-formed label {} \
- too long **").format(label)
                    evaluated.update({line: error_line})
            elif stripped[line].split()[0] in MAL.keys(): # First item is valid opcode
                evaluated_line = self.__evaluate_instruction(stripped[line])
                evaluated.update({line: evaluated_line})
            else: # First item is invalid opcode
                error_line = stripped[line] + \
                    ("\n    ** error: invalid opcode {} **").format(first_item)
                evaluated.update({line: error_line})
        # Check if there are labels that were not branched to
        for label in self.__labels:
            # Add warning if the label if the referenced count is zero
            if self.__labels[label][1] == 0:
                warning = "\n    ** warning: label is never branched to **"
                new_line = evaluated[self.__labels[label][0]] + warning
                evaluated.update({self.__labels[label][0]: new_line})
        return evaluated

    def __evaluate_instruction(self, instruction):
        """Evaluate if an instruction contains errors."""
        evaluated_line = instruction
        opcode = instruction.split()[0]
        operands = instruction.replace(',', '').split()[1:]
        # Check for valid number of operands
        if len(operands) < len(MAL[opcode]): # Too few operands
            if len(MAL[opcode]) == 1:
                evaluated_line += ("\n    ** error: too few operands \
- {} operand expected for {} **").format(len(MAL[opcode]), opcode)
            else:
                evaluated_line += ("\n    ** error: too few operands \
- {} operands expected for {} **").format(len(MAL[opcode]), opcode)
        elif len(operands) > len(MAL[opcode]): # Too many operands
            if len(MAL[opcode]) == 1:
                evaluated_line += ("\n    ** error: too many operands \
- {} operand expected for {} **").format(len(MAL[opcode]), opcode)
            else:
                evaluated_line += ("\n    ** error: too many operands \
- {} operands expected for {} **").format(len(MAL[opcode]), opcode)
        else: # Valid number of operands
            # Check for errors in operands
            operand_errors = self.__evaluate_operands(opcode, operands)
            # Add operand errors below instruction
            if operand_errors:
                for operand_error in operand_errors:
                    evaluated_line += '\n' + operand_error
        return evaluated_line

    def __evaluate_operands(self, opcode, operands):
        """Evaluate if an operand is valid"""
        operand_errors = []  # List to store operand errors
        valid_operands = MAL[opcode]  # Valid operands for opcode
        for index, valid_operand in enumerate(valid_operands):
            if 'r' in valid_operand: # Register
                if operands[index] not in REGISTERS:
                    # Register not r0-r9
                    operand_errors.append(
                        ("    ** error: invalid register \
                            {} **").format(operands[index]))
            elif 'v' in valid_operand: # Literal value
                if not self.is_octal_num(operands[index]):
                    operand_errors.append(
                        ("    ** error: ill-formed literal {} \
- not an octal number **").format(operands[index]))
            elif 's' in valid_operand or 'd' in valid_operand: # Identifier
                if len(operands[index]) > 5: # identifier too long
                    operand_errors.append(
                        ("    ** error: ill-formed identifier {} \
- too long **").format(operands[index]))
            elif 'lab' in valid_operand: # Label
                if len(operands[index]) > 5: # Label too long
                    operand_errors.append(
                        ("    ** error: ill-formed label {} \
- too long **").format(operands[index]))
                if operands[index] not in self.__labels:
                    # Referenced label is not in program
                    operand_errors.append(
                        ("    ** warning: branch to non-existant label \
{} **").format(operands[index]))
                else: # Increase reference count for label
                    label_lst = self.__labels[operands[index]]
                    label_lst[1] += 1
                    self.__labels.update({operands[index]: label_lst})
        return operand_errors

    def is_octal_num(self, number):
        """Returns True if a number is octal and False if not"""
        valid_octal = [str(n) for n in range(8)] # Valid octal numerals 0-7
        octal = True
        for num in str(number):
            if num not in valid_octal: # Digit in number is not octal
                octal = False
        return octal

    def check(self, mal_file):
        """Check syntax of MAL program"""
        self.__labels = {}
        original, stripped = self.__read_program(mal_file)
        evaluated = self.__evaluate_program(stripped)
        self.__write_report(original, stripped, evaluated)


if __name__ == "__main__":
    ARG = sys.argv[1]
    if ".mal" in ARG:
        MAL_FILE = sys.argv[1]
    else:
        MAL_FILE = sys.argv[1] + ".mal"
    SYNTAX_CHECKER = SyntaxChecker()
    SYNTAX_CHECKER.check(MAL_FILE)
