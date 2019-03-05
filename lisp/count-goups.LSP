;;  Kenneth Berry – CS 3210 – Spring 2019
;;  ============================
;;  count-groups function: receives a list of words and/or numbers,
;;  not nested, and counts the number of groups. A group is two or 
;;  more identical, adjecent items.
;;
;;  parameters:
;;       lst - a list of numbers and/or words
;;  assumptions:
;;       1. numbers can be integers or floats
;;       2. numbers can be positive or negative

(defun count-groups (lst)
    (cond
        ((null lst) 0)
        ((and 
            (equal (car lst) (car (cdr lst)))
            (not (equal (car (cdr lst)) (car (cdr (cdr lst))))))
                (+ 1 (count-groups (cdr lst))))
        (t (count-groups (cdr lst)))))

;;  test plan for count-groups:
;;  category / description     data                          expected result
;;  ------------------------------------------------------------------
;;  empty list                  ()                            0
;;  singleton                   (5)                           0
;;  one pair                    (6 6)                         1
;;  no pairs                    (6 5 4 3 2 "one")             0
;;  pair and same not adjacent  (1 1 6 1)                     1
;;  multiple groups             (1 1 2 2 "three" "three" 4 4) 4
;;  one large group             (5 5 5 5 5)                   1
;;  negative numbers and floats (-9 -9 12.0 12.0)             2

(defvar test_lst_1 '())
(defvar test_lst_2 '(5))
(defvar test_lst_3 '(6 6))
(defvar test_lst_4 '(6 5 4 3 2 "one"))
(defvar test_lst_5 '(1 1 6 1))
(defvar test_lst_6 '(1 1 2 2 "three" "three" 4 4))
(defvar test_lst_7 '(5 5 5 5 5))
(defvar test_lst_8 '(-9 -9 12.0 12.0))

(print (count-groups test_lst_1))
(print (count-groups test_lst_2))
(print (count-groups test_lst_3))
(print (count-groups test_lst_4))
(print (count-groups test_lst_5))
(print (count-groups test_lst_6))
(print (count-groups test_lst_7))
(print (count-groups test_lst_8))