(defstruct (doc :conc-name)
  (byr)
  (iyr)
  (eyr)
  (hgt)
  (hcl)
  (ecl)
  (pid)
  (cid))

(defun space-or-newline? (c)
  (or (char= c #\Space) (char= c #\Newline)))

(defun parse-fields (entry doc start-ix)
  (let ((field-sep-ix (position #\: entry :start start-ix))
        (next-field-ix (position-if #'space-or-newline? entry :start start-ix)))
    (if (eq field-sep-ix 'nil)
      doc
      (let* ((key (subseq entry start-ix field-sep-ix))
             (key-sym (intern (string-upcase key)))
             (value (subseq entry (+ field-sep-ix 1) (or next-field-ix (length entry)))))
        (funcall (fdefinition (list 'setf key-sym))
                 value
                 doc)
        (if (eq next-field-ix 'nil)
          doc
          (parse-fields entry doc (+ next-field-ix 1)))))))

(defun parse-doc (entry)
  (let ((doc (make-doc)))
    (parse-fields entry doc 0)))

(defun part1-valid? (doc)
  (let ((required '(byr iyr eyr hgt hcl ecl pid))
        (has? (lambda (s) (funcall (symbol-function s) doc))))
    (every #'identity (mapcar has? required))))

(defun path-as-sequence (path)
  (with-open-file (stream path)
    (let ((s (make-string (file-length stream))))
      (read-sequence s stream)
      s)))

(defun parse-entries (s entry-ix start-ix)
  (let ((nl-ix (position #\Newline s :start start-ix)))
    (cond
      ((or (not nl-ix)
           (>= (+ nl-ix 1) (length s)))
       (list (subseq s entry-ix)))
      ((char= #\Newline (elt s (+ nl-ix 1)))
       (let ((next-entry-ix (+ nl-ix 2)))
         (cons (subseq s entry-ix nl-ix)
               (parse-entries s next-entry-ix next-entry-ix))))
      (t
       (parse-entries s entry-ix (+ nl-ix 1))))))

(defun run-part (is-valid?)
  (let* ((s (path-as-sequence "day4.input"))
         (entries (parse-entries s 0 0)))
    (count-if is-valid? (mapcar #'parse-doc entries))))
