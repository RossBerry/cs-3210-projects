; Kenneth Berry

; Given a list of integers (order unknown, not nested), report whether
; the list has any duplicates (true) or not (false).


(defun search-count (n lst)
    (cond
        (
            (null lst)
                0
        )
        (
            (equal n (car lst))
                (+ 1 (search-count n (cdr lst)))
        )
        (
            t (search-count n (cdr lst))
        )
    )
)

(defun sum-of-counts (lst)
    (cond
        (
            (null lst)
                0
        )
        (
            t (+ (search-count (car lst) lst) (sum-of-counts (cdr lst)))
        )
    )
)

(defun has-duplicates (lst)
    (cond
        (
            (null lst)
                NIL
        )
        (
            (not (equal (sum-of-counts lst) (length lst)))
                T
        )
    )
)

(defvar test1 '(1 2 3 4 5 6 7))
(defvar test2 '(1 2 3 2 4 5 6))


(print (has-duplicates test1))
(print (has-duplicates test2))
