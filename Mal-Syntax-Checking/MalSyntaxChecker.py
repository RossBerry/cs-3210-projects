"""
MalSyntaxChecker.py
"""
__author__ = "Kenneth Berry"

import sys


def read_mal_program(file):
    """Opens and reads MAL program file."""
    for line in file:
        process_line(line)


def start_report(filename):
    """Creates report file and writes original MAL program listing
       and stripped MAL program listing.
    """
    pass


def finalize_report():
    """Generate MAL program error listing section of report, finish up
       report and close report file.
    """
    pass


def process_line(line):
    """Process a line read in from the MAL program."""
    print(line)
    evaluate_instruction(line)


def evaluate_instruction(instruction):
    """Evaluate if an instruction contains errors."""
    process_error()
    process_warning()


def process_error():
    """Writes appropriate error messages to report file."""
    print("test-error")


def process_warning():
    """Writes appropriate warning messages to report file."""
    print("test-warning")


if __name__ == "__main__":
    MAL_FILE = "C:\Git\cs-3210-projects\Mal-Syntax-Checking\error-test-sum.mal"
    REPORT_FILE = "report.txt"
    start_report(REPORT_FILE)
    with open(MAL_FILE, 'r') as file:
        read_mal_program(file)
    finalize_report()
