;;  Kenneth Berry – CS 3210 – Spring 2019
;;  ==========================================================
;;  divide-by-3 function: receives a list of numbers, possibly
;;  nested, and returns a count of how many are divisible by 3.
;;
;;  parameters:
;;       lst - a list of numbers
;;  assumptions:
;;       1. list may be nested

(defun divide-by-3 (lst)
    (cond
        ((null lst) 0)
        ((listp (car lst))
            (+ (divide-by-3 (car lst)) (divide-by-3 (cdr lst))))
        ((divisible-by-3 (car lst))
            (+ 1 (divide-by-3 (cdr lst))))
        (t (divide-by-3 (cdr lst)))))

;;  test plan for divide-by-3:
;;  category / description     data                    expected result
;;  ------------------------------------------------------------------
;;  empty list                  ()                        0
;;  singleton, not divisible    (5)                       0
;;  singleton, one divisible    (6)                       1
;;  single nested list          ((6))                     1
;;  multiple divisible          (3 1 6 2)                 2
;;  multiple nested             ((9) 12 7 (3 (24) 18))    5
;;  integers and floats         (9 10 12.0 1.9)           2
;;  negative and positive       (-9 10 12)                2
(defvar test_lst_1 '())
(defvar test_lst_2 '(5))
(defvar test_lst_3 '(6))
(defvar test_lst_4 '((6)))
(defvar test_lst_5 '(3 1 6 2))
(defvar test_lst_6 '((9) 12 7 (3 (24) 18)))
(defvar test_lst_7 '(9 10 12.0 1.9))
(defvar test_lst_8 '(-9 10 12))

;;  ==========================================================
;;  divisible-by-3 function: receives a number and returns true
;;  if the number is divisible by 3.
;;
;;  parameters:
;;       n - a number

(defun divisible-by-3 (n)
    (cond
        ((equal (mod n 3) 0) T)
        ((equal (mod n 3) 0.0) T)))

;;  test plan for divisible-by-3:
;;  category / description       data       expected result
;;  ------------------------------------------------------
;;  zero                           0          T
;;  negative, not divisible int   -5          NIL
;;  positive, not divisible int    10         NIL
;;  negative, divisible int       -9          T
;;  positive, divisible int        12         T
;;  negative, not divisible float -1.5        NIL
;;  positive, not divisible float  4.5        NIL
;;  negative, divisible float      -9.0       T
;;  positive, divisible float      18.0       T
(defvar test_n_1 0)
(defvar test_n_2 -5)
(defvar test_n_3 10)
(defvar test_n_4 -9)
(defvar test_n_5 12)
(defvar test_n_6 -1.5)
(defvar test_n_7 4.5)
(defvar test_n_8 -9.0)
(defvar test_n_9 18.0)

(print "divide-by-3 Tests:")
(print (divide-by-3 test_lst_1))
(print (divide-by-3 test_lst_2))
(print (divide-by-3 test_lst_3))
(print (divide-by-3 test_lst_4))
(print (divide-by-3 test_lst_5))
(print (divide-by-3 test_lst_6))
(print (divide-by-3 test_lst_7))
(print (divide-by-3 test_lst_8))

(print "divisible-by-3 Tests:")
(print (divisible-by-3 test_n_1))
(print (divisible-by-3 test_n_2))
(print (divisible-by-3 test_n_3))
(print (divisible-by-3 test_n_4))
(print (divisible-by-3 test_n_5))
(print (divisible-by-3 test_n_6))
(print (divisible-by-3 test_n_7))
(print (divisible-by-3 test_n_8))
(print (divisible-by-3 test_n_9))