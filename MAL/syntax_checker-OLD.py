"""
MAL Syntax Checker
"""
__author__ = "Kenneth Berry"

import sys
import datetime

"""
TODO:
 - duplicate labels
 - no warnings after errors
"""

#########################################################################################
#                                 Module Constants                                      #
#########################################################################################

# Valid MAL instructions
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
          "\n    ** error: invalid opcode {} **",
          "ill-formed literal":
          "    ** error: ill-formed literal {} (not an octal number) **",
          "ill-formed identifier too long":
          "    ** error: ill-formed identifier {} (too long) **",
          "ill-formed identifier contains non-letter":
          "    ** error: ill-formed identifier {} (contains non-letter character) **",
          "ill-formed register":
          "    ** error: invalid register {} (not R0-R7) **",
          "ill-formed label too long":
          "\n    ** error: ill-formed label {} (too long) **",
          "ill-formed label contains non-letter":
          "\n    ** error: ill-formed label {} (contains non-letter character) **",
          "too few operands":
          "\n    ** error: too few operands ({} operands expected for {}) **",
          "too many operands":
          "\n    ** error: too many operands ({} operand expected for {}) **",
          "missing comma":
          "\n    ** error: missing comma **",
          "misplaced comma":
          "\n    ** error: misplaced comma **"}

# Possible warnings
WARNINGS = {"branch to missing label":
            "    ** warning: branch to missing label {} **",
            "label not branched to":
            "\n    ** warning: label {} is not branched to **"}

#########################################################################################
#                                 Module Functions                                      #
#########################################################################################

def tokenize(instruction):
    instruction = instruction.strip()
    tokens = list()
    token = str()
    for index, char in enumerate(instruction):
        if not char.isspace():
            if not char == ',':
                token += char
            else:
                tokens.append(token)
                token = ','
                tokens.append(token)
                token = str()
        elif len(token) > 0:
            tokens.append(token)
            token = str()
        if index == len(instruction) - 1 and len(token) > 0:
            tokens.append(token)
    return tokens


def intersperse(lst, item):
    """Intersperse an item in between existing items in a list"""
    result = [item] * (len(lst) * 2 - 1)
    result[0::2] = lst
    return result


def find_labels(lines):
    """Find labels in a dictionary of lines from a mal program
    lines = {line_num: 'line text'}
    Returns dictionary labels = {line_num: 'label_name'"""
    # Look for labels in program
    labels = {}
    for line_num in lines:
        first_token = lines[line_num].split()[0]
        if ':' in first_token:  # Label
            # Remove colon from label
            first_token = first_token.replace(':', '')
            # Add label to labels dictionary
            labels.update({line_num: first_token})
    return labels


def is_octal_number(number):
    """Returns True if a number is octal and False if not"""
    valid_octal = [str(n) for n in range(8)]  # Valid octal numerals 0-7
    octal = True
    for num in str(number):
        if num not in valid_octal:  # Digit in number is not octal
            octal = False
    return octal


def open_file(mal_file):
    """Opens and reads MAL program file.
    Returns original lines and lines not containing blanks or comments"""
    lines = {}
    with open(mal_file, 'r') as file:
        # Add lines to dictionary: {line_num: line}
        for index, line in enumerate(file):
            line = line.replace('\n', '') # Remove newline characters
            line = line.replace('\r', '') # Remove return characters
            lines.update(
                {str(index + 1): line})
    return lines


def strip_mal_program(original):
    """Strip blank lines and comments from program."""
    stripped_lines = {}
    for line in original:
        stripped_line = original[line].replace('\t', '') # Remove tab characters
        stripped_line = stripped_line.strip() # Remove spaces from beginning and end
        if ";" in stripped_line:  # Line contains a comment
            index = stripped_line.find(';')
            if index != 0:  # In-line comment
                # Remove comment from line
                stripped_lines.update({line: stripped_line[:index - 1]})
        elif stripped_line != '':  # Line not blank and has no comments
            stripped_lines.update({line: stripped_line})
    return stripped_lines

#########################################################################################
#                                   Module Classes                                      #
#########################################################################################


class SyntaxChecker:
    """MAL syntax checker"""

    def __init__(self):
        self.__labels = None  # stores all labels in the MAL program
        self.__error_count = None  # stores count of each type of error
        self.__warning_count = None  # stores count of each type of warning

    def __evaluate_program(self, stripped):
        """Evaluate syntax for each line in MAL program."""
        evaluated = dict()
        # Make a dictionary of labels in the mal program
        self.__labels.update({value: [key, 0] for (
            key, value) in find_labels(stripped).items()})
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
                if "error" not in self.__labels[label][0]:
                    new_line = evaluated[self.__labels[label]
                                        [0]] + WARNINGS[warning].format(label)
                    evaluated.update({self.__labels[label][0]: new_line})
        return evaluated

    def __evaluate_instruction(self, instruction):
        """Evaluate if an instruction contains errors."""
        evaluated_line = instruction
        tokens = tokenize(instruction)
        opcode = tokens[0].upper()
        operands = tokens[1:]
        error = None
        trailing_comma = False
        # Check for valid number of operands
        valid_length = len(intersperse(MAL[opcode], ','))
        if len(operands) < valid_length:  # Too few operands
            error = "too few operands"
        elif len(operands) > valid_length:  # Too many operands
            if operands[-1] != ',':
                error = "too many operands"
            else:
                trailing_comma = True
        if error:  # Invalid number of operands
            if valid_length == 1:
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
                    break  # stop after the first error in the line
        if trailing_comma and not error and not operand_errors:
            evaluated_line += ERRORS["misplaced comma"]
        return evaluated_line

    def __evaluate_operands(self, opcode, tokens):
        """Evaluate if an operand is valid"""
        operand_errors = []  # List to store operand errors
        valid_tokens = intersperse(MAL[opcode], ',')  # Valid operands for opcode
        for index, valid_token in enumerate(valid_tokens):
            error = None
            warning = None
            token = tokens[index]
            if token == ',' and valid_token != ',':
                error = "misplaced comma"
            elif valid_token == ',' and token != ',':
                error = "missing comma"
            elif 'R' in valid_token:  # Register
                if token.upper() not in REGISTERS:  # Not R0-R7
                    error = "ill-formed register"
            elif 'V' in valid_token:  # Literal value
                if not is_octal_number(token):
                    error = "ill-formed literal"
            elif 'S' in valid_token or 'D' in valid_token:  # Identifier
                error = self.__evaluate_identifier(token)
                if error:
                    error = "ill-formed identifier" + error
            elif 'LAB' in valid_token:  # Label
                error = self.__evaluate_identifier(token)
                if error:
                    error = "ill-formed label" + error
                if token.casefold() not in [label.casefold() for label in self.__labels]:
                    # Referenced label is not in label reference dictionary
                    warning = "branch to missing label"
                else:
                    # Increase reference count for label
                    for label_index, key in enumerate(self.__labels.keys()):
                        if token.casefold() == key.casefold():
                            keys = [key for key in self.__labels]
                            label_key = keys[label_index]
                            label_reference_list = self.__labels[label_key]
                            label_reference_list[1] += 1
                            self.__labels.update(
                                {label_key: label_reference_list})
            if error:
                # Increment error count
                operand_errors.append(
                    (ERRORS[error]).format(token))
                self.__error_count.update(
                    {error: self.__error_count[error] + 1})
            if warning:
                # Increment warning count
                operand_errors.append(
                    (WARNINGS[warning]).format(token))
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

    def check_file(self, mal_file):
        """Check syntax of MAL program"""
        # Reset label reference dictionary for new mal_file
        self.__labels = {}
        # Copy keys from ERRORS dictionary and set each count to 0
        self.__error_count = {key: 0 for key in ERRORS}
        # Copy keys from WARNINGS dictionary and set each count to 0
        self.__warning_count = {key: 0 for key in WARNINGS}
        # Read MAL program file and generate list of original program lines and list with
        # no blank lines or comments.
        original_lines = open_file(mal_file)
        stripped_lines = strip_mal_program(original_lines)
        # Evaluate the syntax in the stripped program lines
        evaluated_lines = self.__evaluate_program(stripped_lines)

        # Package output
        lines = (original_lines, stripped_lines, evaluated_lines)
        counts = (self.__error_count, self.__warning_count)
        return lines, counts


class SyntaxReport:
    """Generates a report based original, stripped, and evaluated lines
    from SyntaxChecker"""

    def __init__(self, mal_file, checker_output):
        self.__mal_file = mal_file
        self.__report_file = mal_file.replace(".mal".casefold(), ".log")
        self.__sections, self.__counts = checker_output
        self.__report = self.__make_report()

    def __make_report(self):
        """Make report"""
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
        report_lines.append(divider + self.__make_footer())
        report = str()
        for line in report_lines:
            report = report + line
        return report

    def __make_header(self):
        """Generate report file header"""
        now = datetime.datetime.now()
        date = str(now.month) + '/' + str(now.day) + '/' + str(now.year)
        header = self.__mal_file + ' - ' + self.__report_file + ' - ' + \
            date + ' - ' + __author__ + ' - ' + "CS3210\n"
        return header

    def __make_footer(self):
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
                "\nProcessing complete - MAL program is not valid.")
        else:
            footer_lines.append("\nProcessing complete - MAL program is valid.")
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
        print("** ERROR: Missing MAL filename argument **\n" + \
              "Valid format: \n\
            python mal_syntax_checker.py filename")
