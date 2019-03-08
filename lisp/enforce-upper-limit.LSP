;;  Kenneth Berry – CS 3210 – Spring 2019
;;  =====================================
;;  enforce-limit function: receives a number (upper limit)
;;  and a list of words and/or numbers, possibly nested, then 
;;  returns a new list in which all values originally over the
;;  limit are replaced by the limit.
;;  parameters:
;;         n - the upper limit
;;       lst - a list of number and/or words
;;  assumptions:
;;       1. lst could be nested
;;       2. the upper-limit is a number

(defun enforce-limit (n lst)
    (cond
        ((null lst) NIL)
        ((null (car lst))
            (append (list '(())) (enforce-limit n (cdr lst))))
        ((listp (car lst))
            (append (list (enforce-limit n (car lst))) (enforce-limit n (cdr lst))))
        ((and
            (numberp (car lst))
            (> (car lst) n))
                (append (list n) (enforce-limit n (cdr lst))))
        ((append (list (car lst)) (enforce-limit n (cdr lst))))))

;;  test plan for enforce-limit:
;;  category / description           data                  expected result
;;  ----------------------------------------------------------------------
;;  empty list                       n=5 lst=()            NIL
;;  list with 1 element              n=5 lst=(0)           (0)
;;  non-nested w/ number over limit  n=5 lst=(5 10 5)      (5 5 5)
;;  nested w/ numbers over limit     n=10 lst=((12) -5 12) ((10) -5 10)
;;  contains ints and floats         n=2 lst=(3 3.2 2)     (2 2 2)
;;  contains numbers and strings     n=4 lst=(2 5 "cat")   (2 4 "cat")

;;  test variables for enforce-limit:
(defvar test_n_1 5)
(defvar test_lst_1 '())
(defvar test_n_2 5)
(defvar test_lst_2 '(0))
(defvar test_n_3 5)
(defvar test_lst_3 '(5 10 5))
(defvar test_n_4 10)
(defvar test_lst_4 '((12) -5 12))
(defvar test_n_5 2)
(defvar test_lst_5 '(3 3.2 2))
(defvar test_n_6 4)
(defvar test_lst_6 '(2 5 "cat"))

;;  tests for enforce-limit:
;; (print (enforce-limit test_n_1 test_lst_1))
;; (print (enforce-limit test_n_2 test_lst_2))
;; (print (enforce-limit test_n_3 test_lst_3))
;; (print (enforce-limit test_n_4 test_lst_4))
;; (print (enforce-limit test_n_5 test_lst_5))
;; (print (enforce-limit test_n_6 test_lst_6))