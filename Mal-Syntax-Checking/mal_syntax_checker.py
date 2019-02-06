"""
mal_syntax_checker.py
"""
__author__ = "Kenneth Berry"

import sys


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

ERRORS = {"label": "** error: ill-formed label **",
          "opcode": "** error: invalid opcode **"}


class SyntaxChecker():
    """MAL syntax checker"""

    def __init__(self):
        pass

    def __read_program(self, mal_file):
        """Opens and reads MAL program file."""
        mal_program_lines = {}
        with open(mal_file, 'r') as file:
            line_number = 1
            for line in file:
                mal_program_lines.update(
                    {str(line_number): line.replace("\n"or"\r", "")})
                line_number += 1
        return mal_program_lines

    def __strip_program(self, original):
        """Strips blank lines and comments from program lines"""
        stripped = {}
        for line in original:
            if ";" in original[line]:
                index = original[line].find(';')
                if index != 0:
                    stripped.update(
                        {line: original[line][:index - 1]})
            elif original[line] != "":
                stripped.update({line: original[line]})
        return stripped

    def __write_report(self, original, stripped, evaluated):
        """Generate MAL program error listing section of report, finish up
        report and close report file.
        """
        divider = "\n-------------\n"
        print("HEADER")
        print(divider)
        for key in original:
            print(key, original[key])
        print(divider)
        for key in stripped:
            print(key, stripped[key])
        print(divider)
        for key in evaluated:
            print(key, evaluated[key])

    def __evaluate_program(self, stripped):
        """Process a line read in from the MAL program."""
        evaluated = {}
        for line in stripped:
            evaluated.update({line: stripped[line]})
            first_item = stripped[line].split()[0]
            if ":" in first_item and len(first_item) > 6:
                error = stripped[line] + "\n" + ERRORS["label"]
                evaluated.update({line: error})
            elif stripped[line].split()[0] in MAL.keys():
                self.__evaluate_instruction(line)
            else:
                error = stripped[line] + "\n" + ERRORS["opcode"]
                evaluated.update({line: error})
        return evaluated

    def __evaluate_instruction(self, instruction):
        """Evaluate if an instruction contains errors."""
        self.__process_error()
        self.__process_warning()

    def __process_error(self):
        """Writes appropriate error messages to report file."""
        # print("test-error")

    def __process_warning(self):
        """Writes appropriate warning messages to report file."""
        # print("test-warning")

    def check(self, mal_file):
        """Check syntax of MAL program"""
        original = self.__read_program(mal_file)
        stripped = self.__strip_program(original)
        evaluated = self.__evaluate_program(stripped)
        self.__write_report(original, stripped, evaluated)


if __name__ == "__main__":
    MAL_FILE = "C:\Git\cs-3210-projects\Mal-Syntax-Checking\error-test-sum.mal"
    SYNTAX_CHECKER = SyntaxChecker()
    SYNTAX_CHECKER.check(MAL_FILE)
