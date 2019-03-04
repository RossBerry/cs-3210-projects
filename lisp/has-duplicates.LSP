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

(defun sum-counts (lst)
    (cond
        ((null lst)
            0)
        (t (+ (search-count (car lst) lst) (sum-counts (cdr lst))))))

(defun search-count (n lst)
    (cond
        ((null lst)
            0)
        ((equal n (car lst))
            (+ 1 (search-count n (cdr lst))))
        (t (search-count n (cdr lst)))))

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
