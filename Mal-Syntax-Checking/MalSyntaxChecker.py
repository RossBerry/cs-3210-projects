"""
MalSyntaxChecker.py
"""
__author__ = "Kenneth Berry"

import sys


class SyntaxChecker():
    """MAL syntax checker"""
    def __init__(self):
        self.report_divider = "\n-------------\n"

    def __read_program(self, mal_file):
        """Opens and reads MAL program file."""
        mal_program_lines = {}
        with open(mal_file, 'r') as file:
            line_number = 1
            for line in file:
                mal_program_lines.update({str(line_number): line.replace("\n"or"\r", "")})
                line_number += 1
        return mal_program_lines
    
    def __strip_program(self, lines):
        """Strips blank lines and comments from program lines"""
        stripped_lines = {}
        for line in lines:
            if ";" in lines[line]:
                if lines[line].find(';') != 0:
                    stripped_lines.update({line: lines[line][lines[line].find(';')-1]})
            elif line != "":
                stripped_lines.update({line: lines[line]})
        return stripped_lines


    def __write_report(self, original, stripped, evaluated):
        """Generate MAL program error listing section of report, finish up
        report and close report file.
        """
        pass

    def __evaluate_program(self, program):
        """Process a line read in from the MAL program."""
        for line in program:
            self.__evaluate_instruction(line)

    def __evaluate_instruction(self, instruction):
        """Evaluate if an instruction contains errors."""
        self.__process_error()
        self.__process_warning()

    def __process_error(self):
        """Writes appropriate error messages to report file."""
        #print("test-error")

    def __process_warning(self):
        """Writes appropriate warning messages to report file."""
        #print("test-warning")

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
