;;  Kenneth Berry – CS 3210 – Spring 2019
;;  ============================
;;  remove-negatives function: receives a list of integers,
;;  not nested, and returns a list with all negative values
;;  removed.
;;
;;  parameters:
;;       lst - a list of integers
;;  assumptions:
;;       1. numbers will be integers
;;       2. numbers can be positive or negative

(defun remove-negatives (lst)
    (cond
        ((null lst) lst)
        ((< (car lst) 0)
            (remove-negatives (cdr lst)))
        ((append (list (car lst))
            (remove-negatives (cdr lst))))))

;;  test plan for remove-negatives:
;;  category / description     data                    expected result
;;  ------------------------------------------------------------------
;;  empty list                  ()                        ()
;;  singleton, not negative     (5)                       (5)
;;  singleton, one negative     (-6)                      ()
;;  multiple negatives          (-6 -3 -2)                ()
;;  positive and negatives      (5 -6 0 -2)               (5 0)

(defvar test_lst_1 '())
(defvar test_lst_2 '(5))
(defvar test_lst_3 '(-6))
(defvar test_lst_4 '(-6 -3 -2))
(defvar test_lst_5 '(5 -6 0 -2))

;; remove-negatives tests:
(print (remove-negatives test_lst_1))
(print (remove-negatives test_lst_2))
(print (remove-negatives test_lst_3))
(print (remove-negatives test_lst_4))
(print (remove-negatives test_lst_5))