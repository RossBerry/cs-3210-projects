;;  Kenneth Berry – CS 3210 – Spring 2019
;;  ============================
;;  ____ function: receives a number and returns
;;  its factorial.
;;  parameters:
;;       n - a positive integer
;;  assumptions:
;;       1. n is an integer
;;       2. n is positive

(defun my-remove (str lst)
    (cond
        (
            (null lst)
                lst
        )
        (
            (equal (car lst) str)
                (my-remove str (cdr lst))
        )
        (
            (append (list (car lst)) (my-remove str (cdr lst)))
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

(defun make-recent (str lst)
    (append (list str) (my-remove str lst))
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

;(defvar test_lst '("bee" "cat" "dog" "eagle" "fish"))

;(print (my-remove "cat" '("bee" "cat" "dog" "eagle" "fish")))

(print (make-recent "cat" '("rabbit" "cat" "dog" "bird" "fish")))
(print (make-recent "bird" '("rabbit" "cat" "dog" "fish")))