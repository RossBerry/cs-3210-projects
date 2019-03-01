; Kenneth Berry

; Given a list of words and / or numbers, not nested, count the
; number of groups (a group is two or more identical adjacent items).

(defun count-groups (lst)
    (cond
        (
            (null lst)
                0
        )
        (
            (and 
            (equal (car lst) (car (cdr lst)))
            (not (equal (car (cdr lst)) (car (cdr (cdr lst))))))
                (+ 1 (count-groups (cdr lst)))
        )
        (
            t (count-groups (cdr lst))
        )
    )
)

(defvar test1 '(1 1 2 3 4 "cat" "cat" 5 6 6)) ; 3
(defvar test2 '(1 2 3 4))                     ; 0
(defvar test3 '(1 2 2 3 4 4))                 ; 2
(defvar test4 '(1 1 2 1))                     ; 1
(defvar test5 '(5 5 5 5 5))                   ; 1
(defvar test6 '(0))                           ; 0

(print (count-groups test1))
(print (count-groups test2))
(print (count-groups test3))
(print (count-groups test4))
(print (count-groups test5))
(print (count-groups test6))