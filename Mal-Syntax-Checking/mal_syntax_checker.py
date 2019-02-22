"""
mal_syntax_checker.py
"""
__author__ = "Kenneth Berry"

import sys
import datetime

"""
TODO:
 - Add support for instructions on same line as labels
"""

# MAL instructions
MAL = {"LOAD": ['R', 'S'],
       "LOADI": ['R', 'V'],
       "STORE": ['R', 'D'],
       "ADD": ['R1', 'R2', 'R3'],
       "SUB": ['R1', 'R2', 'R3'],
       "INC": ['R'],
       "DEC": ['R'],
       "BEQ": ['R1', 'R2', 'LAB'],
       "BLT": ['R1', 'R2', 'LAB'],
       "BGT": ['R1', 'R2', 'LAB'],
       "BR": ['LAB'],
       "NOOP": [],
       "END": []}

ERRORS = {"invalid opcode":
          "\n    ** error: invalid opcode [{}] **",
          "ill-formed literal":
          "    ** error: ill-formed literal [{}] - not an octal number **",
          "ill-formed identifier too long":
          "    ** error: ill-formed identifier [{}] - too long **",
        "ill-formed identifier contains non-letter":
          "    ** error: ill-formed identifier [{}] - contains non-letter character **",
          "ill-formed register":
          "    ** error: invalid register [{}] - not R0-R7 **",
          "ill-formed label too long":
          "\n    ** error: ill-formed label [{}] - too long **",
          "ill-formed label contains non-letter":
          "\n    ** error: ill-formed label [{}] - contains non-letter character **",
          "too few operands":
          "\n    ** error: too few operands - {} operands expected for {} **",
          "too many operands":
          "\n    ** error: too many operands - {} operand expected for {} **"}

WARNINGS = {"branch to non-existent label":
            "    ** warning: branch to non-existent label [{}] **",
            "label not branched to":
            "\n    ** warning: label [{}] is never branched to **"}

# Valid Registers R0-R7
REGISTERS = ['R' + str(n) for n in range(8)]


def is_octal_number(number):
    """Returns True if a number is octal and False if not"""
    valid_octal = [str(n) for n in range(8)]  # Valid octal numerals 0-7
    octal = True
    for num in str(number):
        if num not in valid_octal:  # Digit in number is not octal
            octal = False
    return octal


class SyntaxChecker:
    """MAL syntax checker"""

    def __init__(self):
        self.__mal_file = None
        self.__report_file = None
        self.__labels = None  # stores all labels in the MAL program
        self.__error_count = None  # stores count of each type of error
        self.__warning_count = None  # stores count of each type of warning

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
            if ";" in original[line]:  # Line contains a comment
                index = original[line].find(';')
                if index != 0:  # In-line comment
                    # Remove comment from line
                    stripped.update({line: original[line][:index - 1]})
            elif original[line] != '': # Line not blank and has no comments
                stripped.update({line: original[line]})
        return stripped

    def __generate_report_header(self):
        """Generate report file header"""
        now = datetime.datetime.now()
        date = str(now.month) + '/' + str(now.day) + '/' + str(now.year)
        header = self.__mal_file + ' - ' + self.__report_file + ' - ' + \
            date + ' - ' + __author__ + ' - ' + "CS3210\n"
        return header

    def __write_report(self, original, stripped, evaluated):
        """Generate MAL program error listing section of report, finish up
        report and close report file.
        """
        header = self.__generate_report_header()
        divider = "\n-------------\n\n"
        with open(self.__report_file, 'w') as file:
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
            file.write(divider)
            total_errors = sum(self.__error_count.values())
            file.write(("total errors = {}\n").format(total_errors))
            if total_errors > 0:
                for error in self.__error_count:
                    error_count = self.__error_count[error]
                    if error_count > 0:
                        file.write(("   {} {}\n").format(error_count, error))
                file.write("Processing complete - MAL program is not valid.")
            else:
                file.write("Processing complete - MAL program is valid.")

    def __evaluate_program(self, stripped):
        """Evaluate syntax for each line in MAL program."""
        evaluated = {}
        # Look for labels in program
        for line in stripped:
            first_item = stripped[line].split()[0]
            if ':' in first_item:  # Label
                # Add label to labels dictionary:
                # {label_name: [line_num, reference_count]}
                self.__labels.update({first_item.replace(':', ''): [line, 0]})
        # Check each line in program for valid syntax
        for line in stripped:
            error = None
            evaluated.update({line: stripped[line]})
            first_item = stripped[line].split()[0]
            if ':' in first_item:  # First item in line is a label
                label = first_item.replace(':', '')
                error = self.__evaluate_identifier(label)
                if error:
                    error = "ill-formed label" + error
                    error_line = stripped[line] + ERRORS[error].format(label)
                    evaluated.update({line: error_line})
            elif stripped[line].split()[0].upper() in MAL:
                # First item is valid opcode
                evaluated_line = self.__evaluate_instruction(stripped[line])
                evaluated.update({line: evaluated_line})
            else:  # First item is invalid opcode
                error = "invalid opcode"
                error_line = stripped[line] + \
                    (ERRORS[error]).format(first_item)
                evaluated.update({line: error_line})
            if error:
                self.__error_count.update(
                    {error: self.__error_count[error] + 1})
        # Check if there are labels that were not branched to
        for label in self.__labels:
            # Add warning if the label if the reference count is zero
            label_reference_count = self.__labels[label][1]
            if label_reference_count == 0:
                warning = "label not branched to"
                self.__warning_count.update(
                    {warning: self.__warning_count[warning] + 1})
                new_line = evaluated[self.__labels[label]
                                     [0]] + WARNINGS[warning].format(label)
                evaluated.update({self.__labels[label][0]: new_line})
        return evaluated

    def __evaluate_instruction(self, instruction):
        """Evaluate if an instruction contains errors."""
        evaluated_line = instruction
        opcode = instruction.split()[0]
        operands = instruction.replace(',', '').split()[1:]
        error = None
        # Check for valid number of operands
        if len(operands) < len(MAL[opcode]):  # Too few operands
            error = "too few operands"
        elif len(operands) > len(MAL[opcode]):  # Too many operands
            error = "too many operands"
        if error:  # Invalid number of operands
            if len(MAL[opcode]) == 1:
                evaluated_line += (ERRORS[error].replace("operands", "operand", 2).replace(
                    "operand", "operands", 1)).format(len(MAL[opcode]), opcode)
            else:
                evaluated_line += (ERRORS[error]).format(len(MAL[opcode]), opcode)
            self.__error_count.update(
                {error: self.__error_count[error] + 1})
        else:  # Valid number of operands
            # Check for errors in operands
            operand_errors = self.__evaluate_operands(opcode, operands)
            # Add operand errors below instruction
            if operand_errors:
                for operand_error in operand_errors:
                    evaluated_line += '\n' + operand_error
                    break # stop after the first error in the line
        return evaluated_line

    def __evaluate_operands(self, opcode, operands):
        """Evaluate if an operand is valid"""
        operand_errors = []  # List to store operand errors
        valid_operands = MAL[opcode]  # Valid operands for opcode
        for index, valid_operand in enumerate(valid_operands):
            operand = operands[index]
            error = None
            warning = None
            if 'R' in valid_operand:  # Register
                if operand.upper() not in REGISTERS: # Not R0-R7
                    error = "ill-formed register"         
            elif 'V' in valid_operand:  # Literal value
                if not is_octal_number(operand):
                    error = "ill-formed literal"
            elif 'S' in valid_operand or 'D' in valid_operand:  # Identifier
                error = self.__evaluate_identifier(operand)
                if error:
                    error = "ill-formed identifier" + error
            elif 'LAB' in valid_operand:  # Label
                error = self.__evaluate_identifier(operand)
                if error:
                    error = "ill-formed label" + error
                if operand.casefold() not in [label.casefold() for label in self.__labels]:
                    # Referenced label is not in label reference dictionary
                    warning = "branch to non-existent label"
                else:
                    # Increase reference count for label
                    for label_index, key in enumerate(self.__labels.keys()):
                        if operand.casefold() == key.casefold():
                            keys = [key for key in self.__labels]
                            label_key = keys[label_index]
                            label_reference_list = self.__labels[label_key]
                            label_reference_list[1] += 1
                            self.__labels.update(
                                {label_key: label_reference_list})
            if error:
                # Increment error count
                operand_errors.append(
                    (ERRORS[error]).format(operand))
                self.__error_count.update(
                    {error: self.__error_count[error] + 1})
            if warning:
                # Increment warning count
                operand_errors.append(
                    (WARNINGS[warning]).format(operand))
                self.__warning_count.update(
                    {warning: self.__warning_count[warning] + 1})
        return operand_errors

    def __evaluate_identifier(self, string):
        """Check if identifier is valid - if valid return True
                                        - else return specific error
        """
        if len(string) > 5:
            return " too long"
        elif not string.isalpha():
            return " contains non-letter"
        return None

    def check(self, mal_file, report_file):
        """Check syntax of MAL program"""
        self.__mal_file = mal_file
        self.__report_file = report_file
        # Reset label reference dictionary for new mal_file
        self.__labels = {}
        # Copy keys from ERRORS dictionary and set each count to 0
        self.__error_count = {key: 0 for key in ERRORS}
        # Copy keys from WARNINGS dictionary and set each count to 0
        self.__warning_count = {key: 0 for key in WARNINGS}
        # Read MAL program file and generate list of original program lines and list with
        # no blank lines or comments.
        original, stripped = self.__read_program(mal_file)
        # Evaluate the syntax in the stripped program lines
        evaluated = self.__evaluate_program(stripped)
        # Write report with original, stipped, and evaluated program lines
        self.__write_report(original, stripped, evaluated)


if __name__ == "__main__":
    ARG = sys.argv[1]  # MAL program mile
    if ".mal" in ARG:
        # ARG included .mal suffix
        MAL_FILE = sys.argv[1]
    else:
        # ADD .mal suffix to ARG
        MAL_FILE = ARG + ".mal"
    REPORT_FILE = ARG + ".log"
    SYNTAX_CHECKER = SyntaxChecker()
    SYNTAX_CHECKER.check(MAL_FILE, REPORT_FILE)
