;;  Kenneth Berry – CS 3210 – Spring 2019
;;  ============================
;;  ____ function: receives a number and returns
;;  its factorial.
;;  parameters:
;;       n - a positive integer
;;  assumptions:
;;       1. n is an integer
;;       2. n is positive

(defun F-to-C (n)
    (cond
        (
            (equal n -40)
                -40
        )
        (
            t (/ (* (- n 32) 5) 9)
        )
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

;;  ============================
;;  ____ function: receives a number and returns
;;  its factorial.
;;  parameters:
;;       n - a positive integer
;;  assumptions:
;;       1. n is an integer
;;       2. n is positive

(defun C-to-F (n)
    (cond
        (
            (equal n -40)
                -40
        )
        (
            t (+ (/ (* n 9) 5) 32)
        )
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

;;  ============================
;;  ____ function: receives a number and returns
;;  its factorial.
;;  parameters:
;;       n - a positive integer
;;  assumptions:
;;       1. n is an integer
;;       2. n is positive

(defun convert (lst)
    (cond
        (
            (equal (car (cdr lst)) (car '('C))) 
                (C-to-F (car lst))
        )
        (
            (equal (car (cdr lst)) (car '('F)))
                (F-to-C (car lst))
        )
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

(print (convert '(50 'C))) ; 122
(print (convert '(50 'F))) ; 10
(print (convert '(32 'C))) ; 
