(defun F-to-C (n)
    (cond
        (
            (equal n -40)
                -40
        )
        (
            t (/ (* (- n 32) 5) 9)
        )
    )
)

(defun C-to-F (n)
    (cond
        (
            (equal n -40)
                -40
        )
        (
            t (+ (/ (* n 9) 5) 32)
        )
    )
)

(defun convert (lst)
    (cond
        (
            (equal (car (cdr lst)) (car '('C))) 
                (C-to-F (car lst))
        )
        (
            (equal (car (cdr lst)) (car '('F)))
                (F-to-C (car lst))
        )
    )
)

(print (convert '(50 'C))) ; 122
(print (convert '(50 'F))) ; 10
