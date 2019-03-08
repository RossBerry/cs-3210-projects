;;  Kenneth Berry – CS 3210 – Spring 2019
;;  =====================================
;;  checker function: receives a list of expressions, possibly
;;  nested, with numeric operands and binary infix operators.
;;  Operators include words (plus, minus, times, dividedby).
;;  Returns NIL for following conditions, true otherwise:
;;       1. wrong number of tokens in expression
;;       2. operands not numeric
;;       3. invalid operator
;;
;;  parameters:
;;       lst - list containing expressions
;;  assumptions:
;;       1. list possibly nested
;;       3. operators are strings (plus, minus, times, dividedby)
;;       4. operands are numbers or expression in nested list

(defun checker (lst)
    (cond
        ((and
            (tokens-checker lst)
            (operands-checker lst)
            (operator-checker lst)) T)))

;;  test plan for convert:
;;  category / description      data                      expected result
;;  ---------------------------------------------------------------------
;;  empty list                  ()                         NIL
;;  singleton                   (0)                        NIL
;;  simple valid expression     (1 plus 1)                 T
;;  simple invalid expression   (plus 1 1)                 NIL
;;  valid nested expression     (1 plus (1 dividedby 1))   T
;;  invalid nested expression   (1 (1 dividedby 1) 1)      NIL

;;  test variables for convert:
(defvar test_lst_1 '())
(defvar test_lst_2 '(0))
(defvar test_lst_3 '(1 "plus" 1))
(defvar test_lst_4 '("plus" 1 1))
(defvar test_lst_5 '(1 "plus" (1 "dividedby" 1)))
(defvar test_lst_6 '(1 (1 "dividedby" 1) 1))


;;  Kenneth Berry – CS 3210 – Spring 2019
;;  =====================================
;;  tokens-checker function: receives an expression in a list, and
;;  returns true if the expression has 3 tokens or false if not.
;;
;;  parameters:
;;       lst - list containing expression
;;  assumptions:
;;       1. tokens can be numbers and/or words and/or lists

(defun tokens-checker (lst)
    (cond
        ((equal (length lst) 3) T)))

;;  test plan for convert:
;;  category / description      data                      expected result
;;  ---------------------------------------------------------------------
;;  empty list                  ()                         NIL
;;  invalid singleton           (0)                        NIL
;;  simple valid expression     (1 plus 1)                 T
;;  valid expression with list  (1 minus (1 times 2))      T

;;  test variables for tokens-checker:
;; (defvar test_lst_1 '())
;; (defvar test_lst_2 '(0))
;; (defvar test_lst_3 '(1 "plus" 1))
(defvar test_lst_7 '(1 "minus" (1 "times" 2)))



;;  Kenneth Berry – CS 3210 – Spring 2019
;;  =====================================
;;  operands-checker function: receives a list containing an expression,
;;  calls checker function on operands that are lists, or returns true 
;;  if both operands are numbers.
;;
;;  parameters:
;;       lst - list containing expression
;;  assumptions:
;;       1. list possibly nested

(defun operands-checker (lst)
    (cond
        ((and
            (listp (car lst))
            (listp (car (cdr (cdr lst))))
                (and
                    (checker (car lst))
                    (checker (car (cdr (cdr lst)))))))
        ((listp (car lst))
                (and
                    (checker (car lst))
                    (numberp (car (cdr (cdr lst))))))
        ((listp (car (cdr (cdr lst))))
                (and
                (numberp (car lst))
                (checker (car (cdr (cdr lst))))))
        ((and
            (numberp (car lst))
            (numberp (car (cdr (cdr lst))))) T)))

;;  test plan for convert:
;;  category / description      data                      expected result
;;  ---------------------------------------------------------------------
;;  empty list                  ()                         NIL
;;  invalid singleton           (0)                        NIL
;;  simple valid expression     (1 plus 1)                 T
;;  valid expression with list  (1 minus (1 times 2))      T

;;  test variables for tokens-checker:
;; (defvar test_lst_1 '())
;; (defvar test_lst_2 '(0))
;; (defvar test_lst_3 '(1 "plus" 1))
;; (defvar test_lst_7 '(1 "minus" (1 "times" 2)))


;;  Kenneth Berry – CS 3210 – Spring 2019
;;  =====================================
;;  operator-checker function: receives a list containing an 
;;  expression, and returns true if the operator is plus, minus, times, or
;;  dividedby.
;;
;;  parameters:
;;       lst - list containing expression
;;  assumptions:
;;       1. list possibly nested

(defun operator-checker (lst)
    (cond
        ((or
            (equal (car (cdr lst)) "plus")
            (equal (car (cdr lst)) "minus")
            (equal (car (cdr lst)) "times")
            (equal (car (cdr lst)) "dividedby")) T)))

;;  test plan for convert:
;;  category / description      data                      expected result
;;  ---------------------------------------------------------------------
;;  empty list                  ()                         NIL
;;  invalid singleton           (0)                        NIL
;;  valid expression            (1 plus 1)                 T
;;  invalid expression          (1 add 1)                  NIL

;;  test variables for operator-checker:
;; (defvar test_lst_1 '())
;; (defvar test_lst_2 '(0))
;; (defvar test_lst_3 '(1 "plus" 1))
(defvar test_lst_8 '(1 "add" 1))


;;  tests for checker:
;; (print (checker test_lst_1))
;; (print (checker test_lst_2))
;; (print (checker test_lst_3))
;; (print (checker test_lst_4))
;; (print (checker test_lst_5))
;; (print (checker test_lst_6))

;;  tests for tokens-checker:
;; (print (tokens-checker test_lst_1))
;; (print (tokens-checker test_lst_2))
;; (print (tokens-checker test_lst_3))
;; (print (tokens-checker test_lst_7))

;;  tests for operands-checker:
;; (print (operands-checker test_lst_1))
;; (print (operands-checker test_lst_2))
;; (print (operands-checker test_lst_3))
;; (print (operands-checker test_lst_7))

;;  tests for operator-checker:
;; (print (operator-checker test_lst_1))
;; (print (operator-checker test_lst_2))
;; (print (operator-checker test_lst_3))
;; (print (operator-checker test_lst_8))