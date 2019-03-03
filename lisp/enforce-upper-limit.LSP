; Kenneth Berry

; A function that receives a number (an upper limit) and a
; list of words and / or numbers, possibly nested.  The function
; produces a new list in which all values originally over the
; limit are replaced by the limit.  Assumption: the limit will be a number.

(defun enforce-limit (n lst)
    (cond
        (
            (null lst)
                '()
        )
        (
            (null (car lst))
                (append (list '(())) (enforce-limit n (cdr lst)))
        )
        (
            (listp (car lst))
                (append (list (enforce-limit n (car lst))) (enforce-limit n (cdr lst)))
        )
        (
            (and
                (numberp (car lst))
                (> (car lst) n)
            )
                (append (list n) (enforce-limit n (cdr lst)))
        )
        (
            (append (list (car lst)) (enforce-limit n (cdr lst)))
        )
    )
)

(defvar test '(33 (20 (35 9) 7 100 2 () 2)))

(print (enforce-limit 5 test))