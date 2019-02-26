"""
MAL Syntax Checker
"""
__author__ = "Kenneth Berry"

import sys
import datetime

"""
TODO:
 - Add support for instructions on same line as labels
 - Don't print warning if error already exists on line
"""

#########################################################################################
#                                    Module Constants                                   #
#########################################################################################

# Valid MAL opcodes and corresponding operands
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

# Valid registers R0-R7
REGISTERS = ['R' + str(n) for n in range(8)]

# Possible errors
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

# Possible warnings
WARNINGS = {"branch to non-existent label":
            "    ** warning: branch to non-existent label [{}] **",
            "label not branched to":
            "\n    ** warning: label [{}] is never branched to **"}

#########################################################################################
#                                    Module Functions                                   #
#########################################################################################


def find_labels(lines):
    """
    Finds labels in a dictionary of mal program lines
        input: dict(str(line_num): str(line text))
        output: dictionary labels = {line_num: 'label_name'
    """
    # Look for labels in program
    labels = {}
    for line_num in lines:
        first_token = lines[line_num].split()[0]
        if ':' in first_token:  # Label
            # Add label to labels dictionary:
            labels.update({line_num: first_token.replace(':', '')})
    return labels


def is_octal_number(number):
    """
    Checks if a number is in base 8.
        Input: int(number)
        Outut: True or False
    """
    valid_octal = list(str(n) for n in range(8))  # Valid octal numerals 0-7
    octal = True
    for num in str(number):
        if num not in valid_octal:  # Digit in number is not octal
            octal = False
    return octal


def open_file(mal_file):
    """
    Opens and reads MAL program file.
        Input: str(mal_file)
        Output: dict({"line_num": "line_text})
    """
    lines = dict()
    with open(mal_file, 'r') as file:
        # Add lines to dictionary: {line_num: line}
        for index, line in enumerate(file):
            lines.update({str(index + 1): line.replace('\n'or'\r', '')})
    return lines


def strip(original):
    """
    Strip blank lines and comments from program.
        Input: dict({"line_num": "line_text})
        Output: dict({"line_num": "line_text})
    """
    stripped = {}
    for line in original:
        if ";" in original[line]:  # Line contains a comment
            index = original[line].find(';')
            if index != 0:  # In-line comment
                # Remove comment from line
                stripped.update({line: original[line][:index - 1]})
        elif original[line] != '':  # Line not blank and has no comments
            stripped.update({line: original[line]})
    return stripped

#########################################################################################
#                                   Module Classes                                      #
#########################################################################################


class SyntaxChecker:
    """
    MAL syntax checker
    """

    def __init__(self):
        self.__labels = None  # stores all labels in the MAL program
        self.__error_count = None  # stores count of each type of error
        self.__warning_count = None  # stores count of each type of warning

    def __evaluate_program(self, stripped):
        """
        Evaluate syntax for each line in MAL program.
            Input: dict({"line_num": "line_text})
            Output: dict({"line_num": "line_text})
        """
        evaluated = dict()
        # Look for labels in program
        self.__labels.update(
            {value: [key, 0] for (key, value) in find_labels(stripped).items()})
        # Check each line in program for valid syntax
        for line in stripped:
            error = None
            evaluated.update({line: stripped[line]})
            first_item = stripped[line].split()[0]
            if ':' in first_item:
                # First item in line is a label
                label = first_item.replace(':', '')
                # Evaluate label
                error = self.__evaluate_identifier(label)
                if error:
                    # If there is an error, add the specific type of error
                    error = "ill-formed label" + error
                    error_line = stripped[line] + ERRORS[error].format(label)
                    evaluated.update({line: error_line})
                elif len(stripped[line].split()) > 1 and first_item.upper() in MAL:
                    # Valid opcode following label in same line
                    instruction = stripped[line].replace(first_item, '')
                    evaluated_line = self.__evaluate_instruction(instruction)
                    evaluated.update({line: evaluated_line})
            elif first_item.upper() in MAL:
                # First item is a valid opcode
                evaluated_line = self.__evaluate_instruction(stripped[line])
                evaluated.update({line: evaluated_line})
            else:  # First item is an invalid opcode
                error = "invalid opcode"
                error_line = stripped[line] + \
                    (ERRORS[error]).format(first_item)
                evaluated.update({line: error_line})
            if error:
                self.__increment_count(self.__error_count, error)
        # Check if there are labels that were not branched to
        for label in self.__labels:
            # Add warning if the label if the reference count is zero
            label_reference_count = self.__labels[label][1]
            if label_reference_count == 0:
                warning = "label not branched to"
                self.__increment_count(self.__warning_count, warning)

                if "error" not in evaluated[self.__labels[label][0]]:
                    new_line = evaluated[self.__labels[label]
                                         [0]] + WARNINGS[warning].format(label)
                    evaluated.update({self.__labels[label][0]: new_line})
        return evaluated

    def __evaluate_instruction(self, instruction):
        """
        Evaluate if an instruction contains errors. Return the instruction with
        the first error listed below as a string.
            Input: str(instruction)
            Output: str(evaluated_line)
        """
        evaluated_line = instruction
        opcode = instruction.split()[0]
        operands = instruction.replace(',', '').split()[1:]
        error = None
        # Check for valid number of operands
        if len(operands) < len(MAL[opcode]):  # Too few operands
            error = "too few operands"
        elif len(operands) > len(MAL[opcode]):  # Too many operands
            error = "too many operands"
        if error:
            # Invalid number of operands
            if len(MAL[opcode]) == 1:
                evaluated_line += (ERRORS[error].replace("operands", "operand", 2).replace(
                    "operand", "operands", 1)).format(len(MAL[opcode]), opcode)
            else:
                evaluated_line += (ERRORS[error]
                                   ).format(len(MAL[opcode]), opcode)
            self.__increment_count(self.__error_count, error)
        else:  # Valid number of operands
            # Check for errors in operands
            operand_errors = self.__evaluate_operands(opcode, operands)
            # Add operand errors below instruction
            if operand_errors:
                for operand_error in operand_errors:
                    evaluated_line += '\n' + operand_error
                    break  # stop after the first error in the line
        return evaluated_line

    def __evaluate_operands(self, opcode, operands):
        """
        Checks if a list of operands are valid for a particular opcode.
            Input: str(opcode), list(operands)
            Output: list(operand_errors)
        """
        operand_errors = []  # List to store operand errors
        valid_operands = MAL[opcode]  # Valid operands for opcode
        for index, valid_operand in enumerate(valid_operands):
            operand = operands[index]
            error, warning = self.__evaluate_operand(valid_operand, operand)
            if error:
                # Increment error count
                operand_errors.append((ERRORS[error]).format(operand))
                self.__increment_count(self.__error_count, error)
            if warning:
                # Increment warning count
                operand_errors.append(
                    (WARNINGS[warning]).format(operand))
                self.__increment_count(self.__warning_count, warning)
        return operand_errors

    def __evaluate_operand(self, valid_operand, operand):
        """
        Compares an operand to what the valid operand should be.
            Input: str(valid_operand), str(operand)
            Output: str(error), str(warning)
        """
        error = None
        warning = None
        if 'R' in valid_operand:  # Register
            if operand.upper() not in REGISTERS:  # Not R0-R7
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
                self.__increment_reference_count(operand)
        return error, warning

    def __increment_reference_count(self, label):
        """
        Increment the reference count for a label.
            Input: str(label)
        """
        for label_index, key in enumerate(self.__labels.keys()):
            if label.casefold() == key.casefold():
                keys = [key for key in self.__labels]
                label_key = keys[label_index]
                label_reference_list = self.__labels[label_key]
                label_reference_list[1] += 1
                self.__labels.update({label_key: label_reference_list})

    def __increment_count(self, count_dict, problem):
        """
        Increment the error or warning count for a particular problem.
            Input: dict({str(problem): int(count)}, str(problem)
        """
        count = count_dict[problem]
        count_dict.update({problem: count + 1})

    def __evaluate_identifier(self, identifier):
        """
        Check if an identifier is valid.
        If valid return True, else return specific error
            Input: str(identifier)
        """
        if len(identifier) > 5:
            return " too long"
        elif not identifier.isalpha():
            return " contains non-letter"
        return None

    def check_file(self, mal_file):
        """
        Check syntax of MAL program
            Input: str(mal_file)
            Output: tuple(sections) tuple(counts)
        """
        # Reset label reference dictionary for new mal_file
        self.__labels = {}

        # Copy keys from ERRORS dictionary and set each count to 0
        self.__error_count = {key: 0 for key in ERRORS}

        # Copy keys from WARNINGS dictionary and set each count to 0
        self.__warning_count = {key: 0 for key in WARNINGS}

        # Read MAL program file and generate list of original lines with
        # no blank lines or comments.
        original_lines = open_file(mal_file)
        stripped_lines = strip(original_lines)
        # Evaluate the syntax in the stripped program lines
        evaluated_lines = self.__evaluate_program(stripped_lines)

        # Package for output
        sections = (original_lines, stripped_lines, evaluated_lines)
        counts = (self.__error_count, self.__warning_count)
        return sections, counts


class SyntaxReport:
    """
    Takes the output from a SyntaxChecker and creates a report.
    Contains methods for printing the otuput to the console and
    writing the report to a log file.

        Input: str(mal_file), tuple(syntax_checker_output)
    """

    def __init__(self, mal_file, syntax_checker_output):
        self.__mal_file = mal_file
        self.__report_file = mal_file.replace(".mal".casefold(), ".log")
        self.__sections, self.__counts = syntax_checker_output
        self.__report = self.__make_report()

    def __make_report(self):
        """
        Makes syntax error report.  Returns the report as a string.
        """
        report_lines = list()
        divider = "\n-------------\n\n"
        # Make header section and add to
        report_lines.append(self.__make_header())
        # Add original, stripped, and error report sections to report
        section_names = ["original MAL program listing:",
                         "stripped MAL program listing:",
                         "error report listing:"]
        for index, section in enumerate(self.__sections):
            report_lines.append(divider + section_names[index] + "\n\n")
            for line in section:
                report_lines.append(line)
                if int(line) < 10:
                    report_lines.append('.  ' + section[line] + '\n')
                else:
                    report_lines.append('. ' + section[line] + '\n')
        report_lines.append(self.__make_footer())
        report = str()
        for line in report_lines:
            report = report + line
        return report

    def __make_header(self):
        """Generates report file header"""
        now = datetime.datetime.now()
        date = str(now.month) + '/' + str(now.day) + '/' + str(now.year)
        header = self.__mal_file + ' - ' + self.__report_file + ' - ' + \
            date + ' - ' + __author__ + ' - ' + "CS3210\n"
        return header

    def __make_footer(self):
        """
        Makes report footer.
        """
        footer_lines = list()
        error_counts, warning_counts = self.__counts
        total_errors = sum([value for value in error_counts.values()])
        footer_lines.append(("total errors = {}\n").format(total_errors))
        if total_errors > 0:
            for error in error_counts:
                error_count = error_counts[error]
                if error_count > 0:
                    footer_lines.append(
                        ("   {} {}\n").format(error_count, error))
            footer_lines.append(
                "Processing complete - MAL program is not valid.")
        else:
            footer_lines.append("Processing complete - MAL program is valid.")
        footer = str()
        for line in footer_lines:
            footer = footer + line
        return footer

    def write_to_file(self):
        """Write syntax report to file"""
        with open(self.__report_file, 'w') as file:
            file.write(self.__report)

    def print_to_console(self):
        """Print syntax report to console"""
        print(self.__report)


if __name__ == "__main__":
    if len(sys.argv) > 1:
        FILE = sys.argv[1]  # MAL program file
        if ".mal" not in FILE.lower():
            # ADD .mal suffix to ARG
            FILE = FILE + ".mal"
        CHECKER = SyntaxChecker()
        REPORT = SyntaxReport(FILE, CHECKER.check_file(FILE))
        REPORT.write_to_file()
        REPORT.print_to_console()
    else:
        print("** ERROR: Missing MAL filename argument **\n" +
              "Valid format: \n\
            python mal_syntax_checker.py filename")
