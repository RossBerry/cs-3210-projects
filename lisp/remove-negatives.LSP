(defun remove-negatives (lst)
    (cond
        ((null lst) lst)
        ((< (car lst) 0) (remove-negatives (cdr lst)))
        ((append (list (car lst)) (remove-negatives (cdr lst))))
    )
)

(defvar test '(1 -2 3 2 -3 3 3))
(write (remove-negatives test))