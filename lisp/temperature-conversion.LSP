(defun C-to-F (n)
    (cond
        ((equal n -40) -40)
        (t (* (/ (- n 32) 9)))
    )
)

(defun F-to-C (n)
    (cond
        ((equal n -40) -40)
        (t (/ (* (+ n 32) 5) 9))
    )
)

(defun convert (lst)
    (cond
        ((equal (car (cdr lst)) "C") (C-to-F (car lst)))
        ((equal (car (cdr lst)) "F") (F-to-C (car lst)))
    )
)

(write (convert '(50 "C")))