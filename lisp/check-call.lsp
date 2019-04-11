;;  Kenneth Berry – CS 3210 – Spring 2019
;;  =====================================
;;  check-call function: receives a list a list that is supposed
;;  to be a lisp-like function call, checks that the first 
;;  item in the list is a valid function name, and checks if it
;;  has the correct number of arguments.  Returns true if the
;;  call is valid, or NIL if invalid.
;;
;;  parameters:
;;       lst - list of valid functions and valid number of parameters
;;       call - the function call to be checked
;;  assumptions:
;;       1. lst is guaranteed to be non-empty
;;       2. lst will contain of sub-lists of format:
;;          ("function_name" #), where # is number of arguments
;;       3. number of arguments will be an non-negative integer

(defun check-call (lst call)
    (cond
        ((null lst) NIL)
        ((equal (car (car lst)) (car call))
            (equal (car (cdr (car lst))) (length (cdr call))))
        ((check-call (cdr lst) call))))

;;  test plan for check-call:
;;  category / description     data                           expected result
;;  -------------------------------------------------------------------------
;;  invalid, singleton          ("write")                      NIL
;;  invalid, single argument    ("thing" "thingie")            NIL
;;  invalid, multiple arguments ("f" 5 5)                      NIL
;;  valid, singleton            ("print")                      T
;;  valid, single argument      ("cat" 10)                     T
;;  valid, multiple arguments   ("test" 1 (4 5 4) "cat" B)     T


;;  test variables for check-call:
(defvar test_lst '(("print" 0)
                   ("test" 4)
                   ("cat" 1)
                   ("flapdoodle" 3)
                   ("thingie" 1)
                   ("junk" 3)
                   ("func" 2)
                   ("f" 0)
                   ("calc" 4)
                   ("play" 2)))
(defvar test_call1 '("write"))
(defvar test_call2 '("thing" "thingie"))
(defvar test_call3 '("f" 5 5))
(defvar test_call4 '("print"))
(defvar test_call5 '("cat" 10))
(defvar test_call6 '("test" 1 '(4 5 4) "cat" 'B))

;;  tests for check-call:
;; (print (check-call test_lst test_call1))
;; (print (check-call test_lst test_call2))
;; (print (check-call test_lst test_call3))
;; (print (check-call test_lst test_call4))
;; (print (check-call test_lst test_call5))
;; (print (check-call test_lst test_call6))
