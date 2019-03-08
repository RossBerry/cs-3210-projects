;;  Kenneth Berry – CS 3210 – Spring 2019
;;  =====================================
;;  search-count function: receives an integer and a list, and
;;  returns the count of how many times that integer occurs in
;;  the list.
;;
;;  parameters:
;;       n - an integer
;;     lst - a list
;;  assumptions:
;;       1. may have nested lists
;;       2. list order is unknown
;;       3. list may contain integers and/or words
;;       4. n is an integer

(defun search-count (n lst)
    (cond
        ((null lst) 
            0)
        ((listp (car lst)) 
            (+ (search-count n (car lst)) (search-count n (cdr lst))))
        ((equal n (car lst)) 
            (+ 1 (search-count n (cdr lst))))
        (t (search-count n (cdr lst)))))

;;  test plan for search-count:
;;  category / description           data	                   expected result
;;  --------------------------------------------------------------------------
;;  empty list                       n=5 lst=()                  0
;;  singleton, has n                 n=5 lst=(5)                 1
;;  singleton, no n                  n=-2 lst=(cat)              0
;;  multiples, no n                  n=5 lst=(-2 cat 0 3)        0
;;  multiple, duplicate n            n=-2 lst=(-2 dog -2 0)      2
;;  multiple with other duplicates   n=1 (1 cat 1 cat 1)         3
;;  nested lists                     n=1 ((1) cat (1 (1) 2) 3)   3

;;  test variables for search-count:
(defvar test_lst_1 '())
(defvar test_lst_2 '(5))
(defvar test_lst_3 '("cat"))
(defvar test_lst_4 '(-2 "cat" 0 3))
(defvar test_lst_5 '(-2 "dog" -2 0))
(defvar test_lst_6 '(1 "cat" 1 "cat" 1))
(defvar test_lst_7 '((1) "cat" (1 (1) 2) 3))
(defvar test_n_1 5)
(defvar test_n_2 -2)
(defvar test_n_3 1)

;;  tests for search-count:
;; (print (search-count test_n_1 test_lst_1))
;; (print (search-count test_n_1 test_lst_2))
;; (print (search-count test_n_2 test_lst_3))
;; (print (search-count test_n_1 test_lst_4))
;; (print (search-count test_n_2 test_lst_5))
;; (print (search-count test_n_3 test_lst_6))
;; (print (search-count test_n_3 test_lst_7))