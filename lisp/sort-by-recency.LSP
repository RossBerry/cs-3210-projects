;;  Kenneth Berry – CS 3210 – Spring 2019
;;  ======================================================
;;  make-recent function: receives a word and list of words,
;;  not nested, and without duplicates.  If the word exists
;;  in the list of words, the word is moved to the front, and
;;  if the word does not exist in the list, it is added to the
;;  front of the list.
;;
;;  parameters:
;;        str - a string
;;        lst - a list of strings
;;  assumptions:
;;       1. the list has no duplicates
;;       2. no nested lists
;;       3. list order is unknown

(defun make-recent (str lst)
    (append (list str) (my-remove str lst)))

;;  test plan for make-recent:
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


;;  =====================================================
;;  my-remove function: receives a word and list of words,
;;  and returns the list with all occurances of the word
;;  removed.
;;
;;  parameters:
;;       str - a string
;;       lst - a list of strings
;;  assumptions:
;;       1. list order is unknown

(defun my-remove (str lst)
    (cond
        ((null lst) lst)
        ((equal (car lst) str)
            (my-remove str (cdr lst)))
        ((append (list (car lst)) (my-remove str (cdr lst))))))

;;  test plan for my-remove:
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