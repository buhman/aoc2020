(defun divide (range half)
  (let* ((l (car range))
         (h (cdr range))
         (mid (/ (+ (- h l) 1) 2)))
    (case half
      ((lower) (cons l (- h mid)))
      ((upper) (cons (+ l mid) h)))))

(defun parse-bfrl (s)
  (let ((f (lambda (c)
             (case c
               (#\F 'lower)
               (#\B 'upper)
               (#\R 'upper)
               (#\L 'lower)))))
    (map 'list f s)))

(defun divide-lu (lu range)
  (reduce #'divide lu :initial-value range))

(defconstant row-range '(0 . 127))
(defconstant col-range '(0 . 7))

(defun eval-bfrl2 (s)
  (let ((row-lu (parse-bfrl (subseq s 0 7)))
        (col-lu (parse-bfrl (subseq s 7 10))))
    (let ((row (divide-lu row-lu row-range))
          (col (divide-lu col-lu col-range)))
      (cons (car row) (car col)))))

(defun seat-id (row-col)
  (+ (* 8 (car row-col))
     (cdr row-col)))

(defun reduce-part1 (xs)
  (reduce #'max xs :initial-value 0))

(load "read.lisp")

(defun run-part (f)
  (let ((bfrls (read-lines-from-file "day5.input")))
    (funcall f (mapcar (compose #'seat-id #'eval-bfrl2) bfrls))))

(defun part1 ()
  (run-part #'reduce-part1))

(defun missing-id (xs last-x)
  (let ((x (car xs))
        (rest (cdr xs)))
    (if (/= (+ last-x 1) x)
      (+ last-x 1)
      (missing-id rest x))))

(defun reduce-part2 (xs)
  (let ((last-x (car xs))
        (xs (cdr xs)))
    (missing-id xs last-x)))

(defun part2 ()
  (run-part (lambda (x) (reduce-part2 (sort x #'<)))))
