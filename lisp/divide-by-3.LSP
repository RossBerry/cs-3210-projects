;; CS 3210 Project 2-3: Divide by 3
;;
;; divide-by-3 function recieves a list of numbers,
;; possibly nested, and returns a count of how many
;; are divisible by 3.
;;
;; author: Kenneth Berry


; returns true if n is divisible by 3
(defun divisible-by-3 (n)
    (cond
        (
            (equal (mod n 3) 0) 
                T
        )
    )
)

; returns count of numbers in list that are divisible by 3
(defun divide-by-3 (lst)
    (cond
        (
            (null lst) 
                0
        )
        (
            (listp (car lst))
                (+ (divide-by-3 (car lst)) (divide-by-3 (cdr lst)))
        )
        (
            (divisible-by-3 (car lst))
                (+ 1 (divide-by-3 (cdr lst)))
        )
        (
            t (divide-by-3 (cdr lst))
        )
    )
)

(write (divide-by-3 '(3 15 78 100 4 12)))