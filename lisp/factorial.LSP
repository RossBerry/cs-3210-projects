(defun factorial (n)
    (cond 
        (
            (= n 0)
                1
        )
        (
            t (* n (factorial(- n 1)))
        )
    )
)

(print (factorial 1))
(print (factorial 2))
(print (factorial 3))
(print (factorial 4))
(print (factorial 5))
(print (factorial 6))
(print (factorial 7))
(print (factorial 8))
(print (factorial 9))
(print (factorial 10))