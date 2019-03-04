;;  Kenneth Berry – CS 3210 – Spring 2019
;;  ============================
;;  enforce-limit function: adds all elements of a given list
;;  parameters:
;;       lst – a list of numbers
;;  assumptions:
;;       1. no nested lists
;;       2. all list elements are integers
;;       3. list sum will not exceed maxint

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

;;  test plan for enforce-limit:
;;  category / description		data		expected result
               	;;  ----------------------------------------------------------------------------------------------------
		;;  empty list				( )	   	       0
		;;  list with 1 element		(6)		       6
		;;  list sums to zero & duplicates	(-2 1 0 1)	       0

; A function that receives a number (an upper limit) and a
; list of words and / or numbers, possibly nested.  The function
; produces a new list in which all values originally over the
; limit are replaced by the limit.  Assumption: the limit will be a number.



(defvar test '(33 (20 (35 9) 7 100 2 () 2)))

(print (enforce-limit 5 test))