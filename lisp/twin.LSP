; Kenneth Berry

; Receives a list, not nested, and doubles all elements.

(defun twin (lst)
    (cond
        (
            (null lst)
                lst
        )
        (
            t (append (append (list (car lst)) (list (car lst))) (twin (cdr lst)))
        )
    )
)

(defvar test '(1 2 3 "four"))

(print (twin test))