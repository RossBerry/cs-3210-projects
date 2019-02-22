(defun search-count (n lst)
    (cond
        ((null lst) 0)
        ((listp (car lst)) (+ (search-count n (car lst)) (search-count n (cdr lst))))
        ((equal n (car lst)) (+ 1 (search-count n (cdr lst))))
        (t (search-count n (cdr lst)))
    )
)


(defvar test '(1 2 3 '(1 2 3) "cat" "dog" 2 3 3 3))

(write (search-count '3 test))