(defun my-search (n lst)
    (cond
        ((null lst) 0)
        ((equal n (car lst)) (+ 1 (my-search n (cdr lst))))
        (t (my-search n (cdr lst)))
    )
)


(defvar test '(1 2 3 "cat" "dog" 2 3 3 3))
(write (my-search '3 test))