;;  Kenneth Berry – CS 3210 – Spring 2019
;;  =====================================
;;  twin function: receives a list, not nested, and
;;  and returns a list with each element doubled.
;;
;;  parameters:
;;       lst - a list
;;  assumptions:
;;       1. list not nested
;;       2. list may contain numbers and/or words

(defun twin (lst)
    (cond
        ((null lst) lst)
        (t (append (append (list (car lst)) (list (car lst))) (twin (cdr lst))))))

;;  test plan for twin:
;;  category / description     data             expected result
;;  -----------------------------------------------------------
;;  empty list                  ()              NIL
;;  singleton                   (5)             (5 5)
;;  multiple numbers            (3 1 6)         (3 3 1 1 6 6)
;;  multiple numbers with group (3 1 1 6)       (3 3 1 1 1 1 6 6)
;;  numbers and words           (1 two 3)       (1 1 two two 3 3)

;;  test variables for twin:
(setf test_lst_1 '())
(defvar test_lst_2 '(5))
(defvar test_lst_3 '(3 1 6))
(defvar test_lst_4 '(3 1 1 6))
(defvar test_lst_5 '(1 "two" 3))


;;  tests for twin:
;; (print (twin test_lst_1))
;; (print (twin test_lst_2))
;; (print (twin test_lst_3))
;; (print (twin test_lst_4))
;; (print (twin test_lst_5))