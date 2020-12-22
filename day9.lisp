(load "read.lisp")

(defun sums-to-a (x a terms)
  (let ((b (car terms))
        (rest (cdr terms)))
    (cond
      ((eq 'nil b) 'nil)
      ((= (+ a b) x) b)
      (t
       (sums-to-a x a rest)))))

(defun sums-to (x terms)
  (let ((a (car terms))
        (rest (cdr terms)))
    (cond
      ((eq 'nil a) 'nil)
      ((> a x)
       (sums-to x rest))
      (t
       (let ((b (sums-to-a x a rest)))
         (if (not (eq b 'nil))
           (cons a b)
           (sums-to x rest)))))))

(defun read-input ()
  (mapcar #'parse-integer
          (read-lines-from-file "day9.input")))

(defun find-nil (preamble addends)
  (let ((x (car addends))
        (terms (cdr addends)))
   (cond
     ((eq 'nil x) 'nil)
     ((eq 'nil (sums-to x preamble))
      (print preamble)
      x)
     (t
      (find-nil (append preamble (list x))
                terms)))))

(defun part1 ()
  (let* ((nums (read-input))
         (preamble (subseq nums 0 25))
         (addends (subseq nums 25)))
    (find-nil preamble addends)))
