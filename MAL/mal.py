"""
MAL Syntax Checker
"""
__author__ = "Kenneth Berry"

import datetime

#########################################################################################
#                                   Module Constants                                    #
#########################################################################################

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

# Registers R0-R7
REGISTERS = ['R' + str(n) for n in range(8)]

# Error messages
ERRORS = {"invalid opcode":
          "\n    ** error: invalid opcode {} **",
          "ill-formed literal":
          "    ** error: ill-formed literal {} (not an octal number) **",
          "ill-formed identifier (too long)":
          "    ** error: ill-formed identifier {} (too long) **",
          "ill-formed identifier (contains non-letter)":
          "    ** error: ill-formed identifier {} (contains non-letter character) **",
          "ill-formed register":
          "    ** error: invalid register {} (not R0-R7) **",
          "ill-formed label (too long)":
          "\n    ** error: ill-formed label {} (too long) **",
          "ill-formed label (contains non-letter)":
          "\n    ** error: ill-formed label {} (contains non-letter character) **",
          "too few operands":
          "\n    ** error: too few operands ({} operands expected for {}) **",
          "too many operands":
          "\n    ** error: too many operands ({} operand expected for {}) **"}

# Warning messages
WARNINGS = {"branch to missing label":
            "    ** warning: branch to missing label {} **",
            "label not branched to":
            "\n    ** warning: label {} is not branched to **"}

#########################################################################################
#                                   Module Functions                                    #
#########################################################################################


def main(arg):
    """
    Main function.  Takes mal file argument, checks mal program syntax, and makes
    a detailed report.
        Input: str(arg)
    """
    if ".mal" not in arg.lower():
        # ADD .mal suffix to ARG
        arg += ".mal"
    syntax_checker = SyntaxChecker()
    report = SyntaxReport(arg, syntax_checker.check(arg))
    report.write_to_file()
    # report.print_to_console()


def find_labels(lines):
    """
    Find all labels in a dictionary of lines from a mal program
        Input: dict({str(line_num): str(line)})
        Output: dict({str(line_num): str(label_name)})
    """
    # Look for labels in program
    labels = dict()
    for line_num in lines:
        first_token = lines[line_num].split()[0]
        # Check if first token is a label
        if ':' in first_token:
            # Remove colon from label
            first_token = first_token.replace(':', '')
            # Add label to labels dictionary
            labels.update({line_num: first_token})
    return labels


def is_octal_number(number):
    """
    Checks if a number is a valid octal number.
        Input: number
        Output: True if octal number, else False
    """
    # Make a list of numbers 0-7 (valid octal numbers)
    valid_octal = [str(n) for n in range(8)]
    is_octal = True
    # Check if each character in number is valid octal number
    for num in str(number):
        if num not in valid_octal:
            is_octal = False
    return is_octal


def read_file(mal_file):
    """
    Opens and reads MAL program file into a dictionary.
        Input: str(mal_file)
        Output: dict({str(line_num): str(line)})
    """
    lines = dict()
    with open(mal_file, 'r') as file:
        # Add lines to dictionary: {line_num: line}
        for index, line in enumerate(file):
            # Remove newline characters
            line = line.replace('\n', '')
            # Remove return characters
            line = line.replace('\r', '')
            lines.update(
                {str(index + 1): line})
    return lines


def strip_program(original_lines):
    """
    Strip blank lines, tabs, and comments from MAL program lines.
        Input: dict({str(line_num): str(original_line)})
        Output: dict({str(line_num): str(stripped_line)})
    """
    stripped_lines = dict()
    for line in original_lines:
        stripped_line = original_lines[line].replace('\t', '')  # Remove tab characters
        # Check if line contains a comment
        if ";" in stripped_line:
            index = stripped_line.find(';')
            # Check if comment takes up entire line or is in-line comment
            if index == 0:
                stripped_line = ''
            else:
                stripped_line = stripped_line[:index - 1]
        # Remove spaces from ends of line
        stripped_line = stripped_line.strip()
        # Add line to stripped lines dictionary if not blank
        if stripped_line != '':
            stripped_lines.update({line: stripped_line})
    return stripped_lines

#########################################################################################
#                                   Module Classes                                      #
#########################################################################################


class SyntaxChecker:
    """
    Syntax Checker that evaluates a MAL program file for syntax errors and warnings.
    """

    def __init__(self):
        self.__labels = dict()  # Stores labels in the MAL program
        self.__error_count = dict()  # Stores count of each type of error
        self.__warning_count = dict()  # Stores count of each type of warning

    def __evaluate_program(self, stripped):
        """
        Evaluate a stripped MAL program line by line and make new dictionary of
        evaluated program lines, which include errors below the original lines.
            Input: dict({str(line_num): str(strippled_line)})
            Output: dict({str(line_num): str(evaluated_line)})
        """
        evaluated = dict() # Stores evaluated lines, {str(line_num): str(line)}

        # Check each line in program
        for line in stripped:
            error = None

            # Add stripped program line to evaluated lines dictionary
            evaluated.update({line: stripped[line]})

            # Check the first item in the stripped program line
            first_token = stripped[line].split()[0]
            if ':' in first_token:
                # First item in line is a label
                label = first_token.replace(':', '')

                # Check for errors in label
                error = self.__evaluate_identifier(label)
                if error:
                    error = "ill-formed label" + error
                    error_line = stripped[line] + ERRORS[error].format(label)
                    evaluated.update({line: error_line})

                # Check if there is an instruction on same line as label
                elif len(stripped[line].split()) > 1 \
                    and stripped[line].split()[1].upper() in MAL:
                    instruction = stripped[line].replace(first_token, '')
                    evaluated_line = self.__evaluate_instruction(instruction)
                    evaluated.update({line: first_token + evaluated_line})

            # Check if first item is a valid opcode
            elif first_token.upper() in MAL:
                evaluated_line = self.__evaluate_instruction(stripped[line])
                evaluated.update({line: evaluated_line})
            
            # First item is not a label or valid opcode
            else:
                error = "invalid opcode"
                error_line = stripped[line] + \
                    (ERRORS[error]).format(first_token)
                evaluated.update({line: error_line})
            if error:
                self.__increment_count(self.__error_count, error)

        # Check if any labels were not branched to
        evaluated = self.__evaluate_label_references(evaluated)

        return evaluated

    def __evaluate_instruction(self, instruction):
        """
        Evaluate an instruction for errors.
            Input: str(instruction)
            Output: str(evaluated_line)
        """
        error = None
        evaluated_line = instruction

        # Separate opcode from instruction as a string
        opcode = instruction.split()[0].upper()

        # Separate operands into a list
        operands = instruction.replace(',', '').split()[1:]

        # Check for valid number of operands
        valid_length = len(MAL[opcode])
        if len(operands) < valid_length:
            error = "too few operands"
        elif len(operands) > valid_length:
            error = "too many operands"
        if error:
            self.__increment_count(self.__error_count, error)
            if valid_length == 1:
                # Replace "operands" with "operand" in error message if there should
                # only be a single operand for this opcode
                evaluated_line += (ERRORS[error].replace(
                    "operands", "operand", 2).replace(
                        "operand", "operands", 1)).format(valid_length, opcode)
            else:
                evaluated_line += (ERRORS[error]).format(valid_length, opcode)

        # Check for other operand errors or warnings
        else:
            operand_errors, operand_warnings = self.__evaluate_operands(opcode, operands)

            # If there were operand errors, add them to the evaluated line
            if len(operand_errors) > 0:
                for operand_error in operand_errors:
                    evaluated_line += '\n' + operand_error

            # If there were operand warnings, but no errors, add to evaluated line
            elif len(operand_warnings) > 0:
                for operand_warning in operand_warnings:
                    evaluated_line += '\n' + operand_warning

        return evaluated_line

    def __evaluate_operands(self, opcode, operands):
        """
        Evaluate an operand for valid syntax.
            Input: str(opcode), list(operands)
            Output: list(operand_errors), list(operand_warnings)
        """
        operand_errors = list()
        operand_warnings = list()

        # Get list of valid operands from MAL dictionary
        valid_operands = MAL[opcode]

        # Evaluate each operand in the list of operands
        for index, valid_operand in enumerate(valid_operands):
            operand = operands[index]
            error, warning = self.__evaluate_operand(valid_operand, operand)
            if error:
                operand_errors.append((ERRORS[error]).format(operand))
                self.__increment_count(self.__error_count, error)
                # Only increment and include first error in the instruction
                break
            elif warning:
                operand_warnings.append((WARNINGS[warning]).format(operand))
                self.__increment_count(self.__warning_count, warning)
                # Only increment and include first warning in the instruction
                break
        return operand_errors, operand_warnings

    def __evaluate_operand(self, valid_operand, operand):
        """
        Evaluate an operand for valid syntax.
            Input: str(valid_operand), str(operand)
            Output: str(error), str(warning)
        """
        operand_error = None
        operand_warning = None

        # Register
        if 'R' in valid_operand:
            if operand.upper() not in REGISTERS:
                operand_error = "ill-formed register"

        # Literal value
        elif 'V' in valid_operand:
            if not is_octal_number(operand):
                operand_error = "ill-formed literal"

        # Identifier
        elif 'S' in valid_operand or 'D' in valid_operand:
            identifier_error = self.__evaluate_identifier(operand)
            if identifier_error:
                operand_error = "ill-formed identifier" + identifier_error

        # Label
        elif 'LAB' in valid_operand:
            identifier_error = self.__evaluate_identifier(operand)
            if identifier_error:
                operand_error = "ill-formed label" + identifier_error

            # Check if label is not in label reference dictionary
            if operand.casefold() not in [label.casefold() for label in self.__labels]:
                operand_warning = "branch to missing label"
            else:
                self.__increment_reference_count(operand)

        return operand_error, operand_warning

    def __evaluate_identifier(self, identifier):
        """
        Evaluates an identifier for valid syntax.
            Input: string(identifier)
            Output: str(error) or None
        """
        # Check if identifier is longer than 5 characters
        if len(identifier) > 5:
            return " (too long)"
        # Check if identifier contains non-letter characters
        elif not identifier.isalpha():
            return " (contains non-letter)"
        else:
            return None

    def __evaluate_label_references(self, evaluated_lines):
        """
        Checks if there are labels that are not branched to by checking the 
        number of times they were referenced throughout the program.None
            Input: str(label)
            Output: str(error) or None
        """
        # Check each label in the label reference dictionary
        for label in self.__labels:
            warning = None

            # Add warning to evaluated line if the label is not branched to and
            # if the evaluated line does not already contain an error
            label_reference_count = self.__labels[label][1] + 1
            if label_reference_count == 0 \
                and "error" not in evaluated_lines[self.__labels[label][0]]:
                warning = "label not branched to"
                new_line = evaluated_lines[self.__labels[label]
                                           [0]] + WARNINGS[warning].format(label)
                evaluated_lines.update({self.__labels[label][0]: new_line})
                self.__increment_count(self.__warning_count, warning)

        return evaluated_lines


    def __increment_count(self, count_dict, key):
        """
        Increment the count in the error or warning count dictionaries.
            Input: dict({key: count}), str(key)
        """
        count = count_dict[key]
        count_dict.update({key: count + 1})

    def __increment_reference_count(self, label):
        """
        Increment the reference count for a label in the label reference dictionary.
            Input: str(label)
        """
        # Look for the label in the labels reference dictionary
        for label_index, key in enumerate(self.__labels.keys()):

            # Check if the label name and dictionary key are equal (case insensitive)
            # and increment reference count if they are
            if label.casefold() == key.casefold():
                keys = [key for key in self.__labels]
                label_key = keys[label_index]

                # Get label reference info, list(line_num, reference count)
                label_reference_list = self.__labels[label_key]

                # Increment reference count
                label_reference_list[1] += 1
                self.__labels.update(
                    {label_key: label_reference_list})

    def check(self, mal_file):
        """
        Check syntax of MAL program and output results.
            Input: str(mal_file)
            Output: tuple(lines), tuple(counts)
        """
        # Copy keys from ERRORS dictionary and set each count to 0
        self.__error_count = {key: 0 for key in ERRORS}

        # Copy keys from WARNINGS dictionary and set each count to 0
        self.__warning_count = {key: 0 for key in WARNINGS}

        # Read MAL program file and generate list of original program
        # lines and list with no blank lines or comments.
        original_lines = read_file(mal_file)
        stripped_lines = strip_program(original_lines)

        # Make a new dictionary of labels for this mal program
        self.__labels = dict()
        self.__labels.update({value: [key, 0] \
            for (key, value) in find_labels(stripped_lines).items()})

        # Evaluate the syntax in the stripped program lines
        evaluated_lines = self.__evaluate_program(stripped_lines)

        # Package output into tuples
        lines = (original_lines, stripped_lines, evaluated_lines)
        counts = (self.__error_count, self.__warning_count)

        return lines, counts


class SyntaxReport:
    """
    Generates a syntax report from output of SyntaxChecker, which can
    be written to a .log file or printed to the console.
    """

    def __init__(self, mal_file, checker_output):
        self.__mal_file = mal_file
        self.__report_file = mal_file.replace(".mal".casefold(), ".log")
        self.__sections, self.__counts = checker_output
        self.__report = self.__make_report()

    def __make_report(self):
        """
        Makes syntax report.
            Output: str(report)
        """
        report = str()
        divider = "\n-------------\n\n"
        # Make header section and add to
        report += self.__make_header()
        # Add original, stripped, and error report sections to report
        section_names = ["original MAL program listing:",
                         "stripped MAL program listing:",
                         "error report listing:"]
        for index, section in enumerate(self.__sections):
            report += divider + section_names[index] + "\n\n"
            for line in section:
                report += line
                if int(line) < 10:
                    report += '.  ' + section[line] + '\n'
                else:
                    report += '. ' + section[line] + '\n'
        report += divider + self.__make_footer()

        return report

    def __make_header(self):
        """
        Makes report file header using MAL filename and datetime module.
            Output: str(header)
        """
        now = datetime.datetime.now()
        date = str(now.month) + '/' + str(now.day) + '/' + str(now.year)
        header = self.__mal_file + ' - ' + self.__report_file + ' - ' + \
            date + ' - ' + __author__ + ' - ' + "CS3210\n"
        return header

    def __make_footer(self):
        """
        Makes report file footer using error and warning count dictionaries.
            Output: str(footer)
        """
        footer = str()
        error_counts, warning_counts = self.__counts

        # Calculate line count from stripped_lines section
        line_count = len(self.__sections[1])
        footer += ("line count = {}\n\n").format(line_count)

        # Calculate total errors and warnings
        total_errors = sum([value for value in error_counts.values()])
        total_warnings = sum([value for value in warning_counts.values()])

        # Add list of errors to footer
        footer += ("total errors = {}\n").format(total_errors)
        valid_program = True
        if total_errors > 0:
            valid_program = False
            for error in error_counts:
                error_count = error_counts[error]
                if error_count > 0:
                    footer += ("   {} {}\n").format(error_count, error)
            footer += "\n"

        # Add list of warnings to footer
        footer += ("total warnings = {}\n").format(total_warnings)
        if total_warnings > 0:
            for warning in warning_counts:
                warning_count = warning_counts[warning]
                if warning_count > 0:
                    footer += ("   {} {}\n").format(warning_count, warning)

        if valid_program:
            footer += "\nProcessing complete - MAL program is valid."
        else:
            footer += "\nProcessing complete - MAL program is not valid."

        return footer

    def write_to_file(self):
        """
        Write syntax report to .log file.
        """
        with open(self.__report_file, 'w') as file:
            file.write(self.__report)

    def print_to_console(self):
        """
        Print syntax report to console.
        """
        print(self.__report)


#########################################################################################
#                                   Main Entry Point                                    #
#########################################################################################

if __name__ == "__main__":
    # sys only needed when this module is the main entry point, and not
    # when it is imported and used in another python program.
    import sys

    if len(sys.argv) > 1:
        main(sys.argv[1])
    else:
        print("** error: Missing MAL filename argument **")
