;;  Kenneth Berry – CS 3210 – Spring 2019
;;  =====================================
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
;;       2. letter is an atom (C or F)

(defun convert (lst)
    (cond
        ((equal (car (cdr lst)) (car '('C))) 
            (C-to-F (car lst)))
        ((equal (car (cdr lst)) (car '('F)))
            (F-to-C (car lst)))))

;;  test plan for convert:
;;  category / description      data        expected result
;;  -------------------------------------------------------
;;  c to f, integer result       (50 C)      122
;;  f to c, integer result       (50 F)      10
;;  c to f, fraction result      (32 C)      448/5 (89.6)
;;  f to c, fraction result      (0 F)      -160/9 (-17.77778)

;;  test variables for convert:
(defvar test_lst_1 '(50 'C))
(defvar test_lst_2 '(50 'F))
(defvar test_lst_3 '(32 'C))
(defvar test_lst_4 '(0 'F))


;;  Kenneth Berry – CS 3210 – Spring 2019
;;  =====================================
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
;;  category / description     data      expected result
;;  ----------------------------------------------------
;;  -40 (same for c and f)      -40      -40
;;  positive result              30       86
;;  negative result             -30      -22
;;  fraction result              13       277/5 (55.4)

;;  test variables for C-to-F:
(defvar test_n_1 -40)
(defvar test_n_2 30)
(defvar test_n_3 -30)
(defvar test_n_4 13)


;;  Kenneth Berry – CS 3210 – Spring 2019
;;  =====================================
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
;;  category / description     data      expected result
;;  ----------------------------------------------------
;;  -40 (same for c and f)      -40      -40
;;  positive result              50       10
;;  negative result             -31      -35
;;  fraction result              0       -160/9 (-17.77778)

;;  test variables for C-to-F:
;; (defvar test_n_1 -40)
(defvar test_n_5 50)
(defvar test_n_6 -31)
(defvar test_n_7 0)


;;  tests for convert:
;; (print (convert test_lst_1))
;; (print (convert test_lst_2))
;; (print (convert test_lst_3))
;; (print (convert test_lst_4))

;;  tests for C-to-F:
;; (print (C-to-F test_n_1))
;; (print (C-to-F test_n_2))
;; (print (C-to-F test_n_3))
;; (print (C-to-F test_n_4))

;;  tests for F-to-C:
;; (print (F-to-C test_n_1))
;; (print (F-to-C test_n_5))
;; (print (F-to-C test_n_6))
;; (print (F-to-C test_n_7))
