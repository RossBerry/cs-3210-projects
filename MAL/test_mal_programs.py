"""
Tests MAL Syntax Checker
"""
import os
from mal import SyntaxChecker, SyntaxReport

FILES = os.listdir()
CHECKER = SyntaxChecker()

count = 0
problems = 0
problem_files = []
for file in FILES:
    if file[-4:] == ".mal":
        count += 1
        #ry:
        report = SyntaxReport(file, CHECKER.check(file))
            # report.print_to_console()
            #print("\n" + "############################################################################\n"*2 + "\n")
        report.write_to_file()
        # except:
        #     problems += 1
        #     problem_files.append(file)

print(problems, "of", count)
for file in problem_files:
        print(file)
