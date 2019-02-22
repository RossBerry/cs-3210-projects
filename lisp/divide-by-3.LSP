(defun divisible-by-3 (n)
    (cond
        ((equal (mod n 3) 0) T)
        (NIL)
    )
)

(defun divide-by-3 (lst)
    (cond
        ((null lst) 0)
        ((listp (car lst)) (+ (divide-by-3 (car lst)) (divide-by-3 (cdr lst))))
        ((divisible-by-3 (car lst)) (+ 1 (divide-by-3 (cdr lst))))
        (t (divide-by-3 (cdr lst)))
    )
)

(write (divide-by-3 '(3 15 78 100 4 12)))