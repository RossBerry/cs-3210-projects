;;  Kenneth Berry – CS 3210 – Spring 2019
;;  =====================================
;;  has-duplicates function: receives a list of integers, 
;;  not nested, and returns true if the list contains
;;  duplicates.
;;
;;  parameters:
;;       lst – a list of integers
;;  assumptions:
;;       1. no nested lists
;;       2. all list elements are integers
;;       3. the list order is unknown

(defun has-duplicates (lst)
    (cond
        ((null lst) NIL)
        ((not (equal (sum-counts lst) (length lst))) T)))

;;  test plan for has-duplicates:
;;  category / description           data	      expected result
;;  --------------------------------------------------------
;;  empty list                       ()           NIL
;;  list with 1 element              (5)          NIL
;;  list without duplicates          (-2 1 0 3)   NIL
;;  list with one set of duplicates  (-2 1 -2 0)  T
;;  list with multiple duplicates    (1 0 1 0 1)  T

;;  test variables for has-duplicates
(defvar test_lst_1 '())
(defvar test_lst_2 '(5))
(defvar test_lst_3 '(-2 1 0 3))
(defvar test_lst_4 '(-2 1 -2 0))
(defvar test_lst_5 '(1 0 1 0 1))


;;  Kenneth Berry – CS 3210 – Spring 2019
;;  =====================================
;;  sum-counts function: receives a list of integers,
;;  not nested, and returns the sum of the results from
;;  search-count function called for each number in the 
;;  the list.
;;  
;;  parameters:
;;       lst - a list of integers
;;  assumptions:
;;       1. no nested lists
;;       2. list order is unknown

(defun sum-counts (lst)
    (cond
        ((null lst) 0)
        (t (+ (search-count (car lst) lst) (sum-counts (cdr lst))))))

;;  test plan for sum-counts:
;;  category / description           data	    expected result
;;  -----------------------------------------------------------
;;  empty list                       ()           0
;;  list with 1 element              (5)          1
;;  list without duplicates          (-2 1 0 3)   4 (1+1+1+1)
;;  list with one set of duplicates  (-2 1 -2 0)  5 (2+1+1+1)
;;  list with multiple duplicates    (1 0 1 0 1)  9 (3+2+2+1+1)

;;  test variables for sum-counts:
;;  test_lst_1
;;  test_lst_2
;;  test_lst_3
;;  test_lst_4
;;  test_lst_5


;;  Kenneth Berry – CS 3210 – Spring 2019
;;  =====================================
;;  search-count function: receives an integer and a list, and
;;  returns the count of how many times that integer occurs in
;;  the list.
;;
;;  parameters:
;;       n - an integer
;;     lst - a list of integers
;;  assumptions:
;;       1. no nested lists
;;       2. list order is unknown

(defun search-count (n lst)
    (cond
        ((null lst)
            0)
        ((equal n (car lst))
            (+ 1 (search-count n (cdr lst))))
        (t (search-count n (cdr lst)))))

;;  test plan for search-count:
;;  category / description           data	             expected result
;;  --------------------------------------------------------------------
;;  empty list                       n=5 lst=()            0
;;  singleton, has n                 n=5 lst=(5)           1
;;  singleton, no n                  n=-2 lst=(5)          0
;;  multiples, no n                  n=5 lst=(-2 1 0 3)    0
;;  multiple, 2 n                    n=-2 lst=(-2 1 -2 0)  2
;;  multiple with other duplicates   n=1 (1 0 1 0 1)       3

;;  test variables for search-count:
;;  test_lst_1
;;  test_lst_2
;;  test_lst_3
;;  test_lst_4
;;  test_lst_5
(defvar test_n_1 5)
(defvar test_n_2 -2)
(defvar test_n_3 1)


;;  tests for has-duplicates
;; (print (has-duplicates test_lst_1))
;; (print (has-duplicates test_lst_2))
;; (print (has-duplicates test_lst_3))
;; (print (has-duplicates test_lst_4))
;; (print (has-duplicates test_lst_5))

;;  tests for sum-counts:
;; (print (sum-counts test_lst_1))
;; (print (sum-counts test_lst_2))
;; (print (sum-counts test_lst_3))
;; (print (sum-counts test_lst_4))
;; (print (sum-counts test_lst_5))

;;  tests for search-count:
;; (print (search-count test_n_1 test_lst_1))
;; (print (search-count test_n_1 test_lst_2))
;; (print (search-count test_n_2 test_lst_2))
;; (print (search-count test_n_1 test_lst_3))
;; (print (search-count test_n_2 test_lst_4))
;; (print (search-count test_n_3 test_lst_5))
