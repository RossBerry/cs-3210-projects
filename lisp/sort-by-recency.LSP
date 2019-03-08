;;  Kenneth Berry – CS 3210 – Spring 2019
;;  =====================================
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
;;  category / description    data                         expected result
;;  ----------------------------------------------------------------------
;;  empty list                str=cat lst=()               (cat)
;;  singleton, is str         str=cat lst=(cat)            (cat)
;;  singleton, not str        str=cat lst=(dog)            (cat dog)
;;  multiple words, with str  str=dog lst=(fish dog bird)  (dog fish bird)
;;  multiple words, no str    str=dog lst=(cat fish bird)  (dog cat fish bird)

;;  test variables for make-recent:
(defvar test_lst_1 '())
(defvar test_lst_2 '("cat"))
(defvar test_lst_3 '("dog"))
(defvar test_lst_4 '("fish" "dog" "bird"))
(defvar test_lst_5 '("cat" "fish" "bird"))
(defvar test_str_1 "cat")
(defvar test_str_2 "dog")


;;  Kenneth Berry – CS 3210 – Spring 2019
;;  =====================================
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
        ((null lst)
            NIL)
        ((equal (car lst) str)
            (my-remove str (cdr lst)))
        ((append (list (car lst)) (my-remove str (cdr lst))))))

;;  test plan for my-remove:
;;  category / description    data                         expected result
;;  ----------------------------------------------------------------------
;;  empty list                str=cat lst=()               NIL
;;  singleton, is str         str=cat lst=(cat)            NIL
;;  singleton, not str        str=cat lst=(dog)            (dog)
;;  multiple words, with str  str=dog lst=(fish dog bird)  (fish bird)
;;  multiple words, no str    str=dog lst=(cat fish bird)  (cat fish bird)

;;  test variables for my-remove:
;;  test_lst_1
;;  test_lst_2
;;  test_lst_3
;;  test_lst_1
;;  test_lst_1
;;  test_str_1
;;  test_str_2


;;  tests for make-recent:
;; (print (make-recent test_str_1 test_lst_1))
;; (print (make-recent test_str_1 test_lst_2))
;; (print (make-recent test_str_1 test_lst_3))
;; (print (make-recent test_str_2 test_lst_4))
;; (print (make-recent test_str_2 test_lst_5))

;;  tests for my-remove:
;; (print (my-remove test_str_1 test_lst_1))
;; (print (my-remove test_str_1 test_lst_2))
;; (print (my-remove test_str_1 test_lst_3))
;; (print (my-remove test_str_2 test_lst_4))
;; (print (my-remove test_str_2 test_lst_5))