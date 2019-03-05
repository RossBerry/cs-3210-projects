;;  Kenneth Berry – CS 3210 – Spring 2019
;;  ============================
;;  ____ function: receives a number and returns
;;  its factorial.
;;  parameters:
;;       n - a positive integer
;;  assumptions:
;;       1. n is an integer
;;       2. n is positive

(defun search-count (n lst)
    (cond
        ((null lst) 0)
        ((listp (car lst)) (+ (search-count n (car lst)) (search-count n (cdr lst))))
        ((equal n (car lst)) (+ 1 (search-count n (cdr lst))))
        (t (search-count n (cdr lst)))
    )
)

;;  test plan for ____:
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

(defvar test '(1 2 3 '(1 2 3) "cat" "dog" 2 3 3 3))

(write (search-count '3 test))