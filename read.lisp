(defun read-lines (in l)
  (let ((line (read-line in nil)))
    (if line
      (read-lines in (cons line l))
      (nreverse l))))

(defun read-lines-from-file (path)
 (let ((in (open path)))
   (let ((lines (read-lines in '())))
     (close in)
     lines)))

(defun compose (&rest funs)
  (lambda (arg)
    (reduce
     (lambda (f arg) (funcall f arg))
     funs
     :from-end t
     :initial-value arg)))
