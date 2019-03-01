(defun my-remove (str lst)
    (cond
        (
            (null lst)
                lst
        )
        (
            (equal (car lst) str)
                (my-remove str (cdr lst))
        )
        (
            (append (list (car lst)) (my-remove str (cdr lst)))
        )
    )
)

(defun make-recent (str lst)
    (append (list str) (my-remove str lst))
)


;(defvar test_lst '("bee" "cat" "dog" "eagle" "fish"))

;(print (my-remove "cat" '("bee" "cat" "dog" "eagle" "fish")))

(print (make-recent "cat" '("rabbit" "cat" "dog" "bird" "fish")))
(print (make-recent "bird" '("rabbit" "cat" "dog" "fish")))