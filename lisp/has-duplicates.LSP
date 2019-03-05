;;  Kenneth Berry – CS 3210 – Spring 2019
;;  ============================
;;  has-duplicates function: reports whether a list has
;;  duplicates (true) or not (false)
;;  parameters:
;;       lst – a list of integers
;;  assumptions:
;;       1. no nested lists
;;       2. all list elements are integers
;;       3. the list order is unknown

(defun has-duplicates (lst)
    (cond
        ((null lst)
            NIL)
        ((not (equal (sum-counts lst) (length lst)))
            T)))

;;  test plan for has-duplicates:
;;  category / description           data	      expected result
;;  --------------------------------------------------------
;;  empty list                       ()           NIL
;;  list with 1 element              (5)          NIL
;;  list without duplicates          (-2 1 0 3)   NIL
;;  list with one set of duplicates  (-2 1 -2 0)  T
;;  list with multiple duplicates    (1 0 1 0 1)  T


;;  ============================
;;  ____ function: receives a number and returns
;;  its factorial.
;;  parameters:
;;       n - a positive integer
;;  assumptions:
;;       1. n is an integer
;;       2. n is positive

(defun sum-counts (lst)
    (cond
        ((null lst)
            0)
        (t (+ (search-count (car lst) lst) (sum-counts (cdr lst))))))

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

(defun search-count (n lst)
    (cond
        ((null lst)
            0)
        ((equal n (car lst))
            (+ 1 (search-count n (cdr lst))))
        (t (search-count n (cdr lst)))))

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

;; Run Tests
;;
;; has-duplicates
(defvar test1 '())
(defvar test2 '(5))
(defvar test3 '(-2 1 0 3))
(defvar test4 '(-2 1 -2 0))
(defvar test5 '(1 0 1 0 1))

(print (has-duplicates test1))
(print (has-duplicates test2))
(print (has-duplicates test3))
(print (has-duplicates test4))
(print (has-duplicates test5))
