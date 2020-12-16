(load "read.lisp")

(defun parse-c (c)
  (case c
    (#\. 'open)
    (#\# 'tree)))

(defun parse-line (l)
  (map 'vector #'parse-c l))

(defun test (forest x y)
  (let ((xw (mod x (length (elt forest 0)))))
    (case (elt (elt forest y) xw)
      (tree 1)
      (open 0))))

(defun encounter (forest x y dx dy)
  (if (>= y (length forest))
    0
    (+ (test forest x y)
       (encounter forest (+ x dx) (+ y dy) dx dy))))

(defun run-part (slopes)
 (let* ((lines (read-lines-from-file "day3.input"))
        (forest (map 'vector #'parse-line lines)))
   (apply #'*
          (mapcar
           (lambda (slope)
             (let ((dx (car slope))
                   (dy (cdr slope)))
               (encounter forest 0 0 dx dy)))
           slopes))))

(defun part1 ()
  (run-part '((3 . 1))))

(defun part2 ()
  (run-part '((1 . 1)
              (3 . 1)
              (5 . 1)
              (7 . 1)
              (1 . 2))))
