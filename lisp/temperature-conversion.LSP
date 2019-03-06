;;  Kenneth Berry – CS 3210 – Spring 2019
;;  ============================
;;  convert function: receives a list containing a number
;;  and a leter (C or F).  If the letter is C, the number
;;  is converted from celcius to fahrenheit, and if the
;;  letter is F, the number is converted from fahrenheit
;;  to celcius.  Then the converted number is returned.
;;
;;  parameters:
;;       lst - a list containing a number and letter
;;  assumptions:
;;       1. number is an integer
;;       2. letter is C or F

(defun convert (lst)
    (cond
        ((equal (car (cdr lst)) (car '('C))) 
            (C-to-F (car lst)))
        ((equal (car (cdr lst)) (car '('F)))
            (F-to-C (car lst)))))

;;  test plan for convert:
;;  category / description     data                    expected result
;;  ------------------------------------------------------------------
;;  empty list                  ()                        0
;;  singleton, not divisible    (5)                       0
;;  singleton, one divisible    (6)                       1
;;  single nested list          ((6))                     1
;;  multiple divisible          (3 1 6 2)                 2
;;  multiple nested             ((9) 12 7 (3 (24) 18))    5
;;  integers and floats         (9 10 12.0 1.9)           2
;;  negative and positive       (-9 10 12)                2

;;  ============================
;;  C-to-F function: receives a number and converts the 
;;  number from celcious to fahrenheit, and returns the new
;;  number.
;;
;;  parameters:
;;       n - a number
;;  assumptions:
;;       1. n is an integer

(defun C-to-F (n)
    (cond
        ((equal n -40) -40)
        (t (+ (/ (* n 9) 5) 32))))

;;  test plan for C-to-F:
;;  category / description     data                    expected result
;;  ------------------------------------------------------------------
;;  empty list                  ()                        0
;;  singleton, not divisible    (5)                       0
;;  singleton, one divisible    (6)                       1
;;  single nested list          ((6))                     1
;;  multiple divisible          (3 1 6 2)                 2
;;  multiple nested             ((9) 12 7 (3 (24) 18))    5
;;  integers and floats         (9 10 12.0 1.9)           2
;;  negative and positive       (-9 10 12)                2

;;  ============================
;;  F-to-C function: receives a number and converts the 
;;  number from fahrenheit to celcius, and returns the new
;;  number.
;;
;;  parameters:
;;       n - a number
;;  assumptions:
;;       1. n is an integer

(defun F-to-C (n)
    (cond
        ((equal n -40) -40)
        (t (/ (* (- n 32) 5) 9))))

;;  test plan for F-to-C:
;;  category / description     data                    expected result
;;  ------------------------------------------------------------------
;;  empty list                  ()                        0
;;  singleton, not divisible    (5)                       0
;;  singleton, one divisible    (6)                       1
;;  single nested list          ((6))                     1
;;  multiple divisible          (3 1 6 2)                 2
;;  multiple nested             ((9) 12 7 (3 (24) 18))    5
;;  integers and floats         (9 10 12.0 1.9)           2
;;  negative and positive       (-9 10 12)                2

(print (convert '(50 'C))) ; 122
(print (convert '(50 'F))) ; 10
(print (convert '(32 'C))) ; 
