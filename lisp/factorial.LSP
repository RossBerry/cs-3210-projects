;;  Kenneth Berry – CS 3210 – Spring 2019
;;  =====================================
;;  factorial function: receives a number and returns
;;  its factorial.
;;  parameters:
;;       n - a number
;;  assumptions:
;;       1. n is an integer
;;       2. n is positive

(defun factorial (n)
    (cond 
        ((= n 0) 1)
        (t (* n (factorial(- n 1))))))

;;  test plan for enforce-limit:
;;  category / description     data        expected result
;;  ------------------------------------------------------
;;  base case                   0           1
;;  low number                  5           120
;;  higher number               12          479001600 

;;  test variables for factorial:
(defvar test_n_1 0)
(defvar test_n_2 5)
(defvar test_n_3 12)

;;  tests for factorial:
;; (print (factorial test_n_1))
;; (print (factorial test_n_2))
;; (print (factorial test_n_3))
