;;  Kenneth Berry – CS 3210 – Spring 2019
;;  ============================
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

(defun checker (lst)
    (cond
        ((and
            (tokens-checker lst)
            (operands-checker lst)
            (operator-checker lst)) T)))

(defun tokens-checker (lst)
    (cond
        ((equal (length lst) 3) T)))

(defun operands-checker (lst)
    (cond
        ((and
            (numberp (car lst))
            (numberp (car (cdr (cdr lst))))) T)))

(defun operator-checker (lst)
    (cond
        ((or
            (equal (car (cdr lst)) (car '('plus)))
            (equal (car (cdr lst)) (car '('minus)))
            (equal (car (cdr lst)) (car '('times)))
            (equal (car (cdr lst)) (car '('dividedby)))) T)))


(defvar test_lst_1 '(5 'plus 6))
(defvar test_lst_2 '(5 'plus 'minus))

(print (checker test_lst_1))
(print (checker test_lst_2))