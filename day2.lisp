(ql:quickload "cl-ppcre")

(load "read.lisp")

(defun parse-line (line)
  (destructuring-bind (a b c d) (cl-ppcre:split "(-)|( )|(: )" line)
    (list (parse-integer a) (parse-integer b) (char c 0) d)))

(defun part1-valid? (min max c s)
  (let ((cc (count c s)))
    (and (>= cc min) (<= cc max))))

(defun run-part (f)
  (let* ((lines (read-lines-from-file "input"))
         (specs (mapcar #'parse-line lines)))
    (count-if (lambda (x) (apply f x)) specs)))

(defun part2-valid? (p1 p2 c s)
  (let ((a (char s (- p1 1)))
        (b (char s (- p2 1))))
    (and (char/= a b) (or (char= a c) (char= b c)))))

(defun part1 ()
  (run-part #'part1-valid?))

(defun part2 ()
  (run-part #'part2-valid?))
