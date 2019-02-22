(defun search-count (n lst)
    (cond
        (
            (null lst) 
                0
        )
        (
            (listp (car lst))
                (+ (search-count n (car lst)) (search-count n (cdr lst)))
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

(defun remove (n lst)
    (cond
        (
            (null lst)
                lst
        )
        (
            (equal (car lst) n)
                (remove n (cdr lst))
        )
        (
            (append (list (car lst)) (remove n (cdr lst)))
        )
    )
)

(defun make-recent (str lst)
    (append (list str) lst)
    (cond
        (
            (null (cdr lst)) 
                lst
        )
        (
            (equal (search-count str lst) str)
                (cdr lst)
        )
        (
            (equal (car (cdr lst)) str)
                (append (car lst) (cdr (cdr lst)))
        )
        (
            (append (list (car lst)) (make-recent str (cdr lst)))
        )
    )
)


(defvar count_test1 '("bee" "cat" "dog" "eagle" "fish"))
(defvar count_test2 '("bee" "dog" "eagle" "fish"))
(defvar test '("bee" "cat" "dog" "eagle" "fish"))

;(write (search-count "cat" count_test1)) ; expected result = 1
;(write (search-count "cat" count_test2)) ; expected result = 0

(write (remove "cat" count_test1))

;(write (make-recent "cat" test))