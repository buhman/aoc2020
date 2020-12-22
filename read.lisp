(defun read-lines (in l)
  (let ((line (read-line in nil)))
    (if line
      (read-lines in (cons line l))
      (reverse l))))

(defun read-lines-from-file (path)
  (with-open-file (stream path)
    (read-lines stream '())))

(defun compose (&rest funs)
  (lambda (arg)
    (reduce
     (lambda (f arg) (funcall f arg))
     funs
     :from-end t
     :initial-value arg)))

(defun read-string-from-file (path)
  (with-open-file (stream path)
    (let ((s (make-string (file-length stream))))
      (read-sequence s stream)
      s)))
