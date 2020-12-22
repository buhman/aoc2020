(ql:quickload "cl-ppcre")

(load "read.lisp")

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

(defun parse-height (s)
  (let* ((l-2 (min (length s) 2))
         (unit (subseq s (- (length s) l-2) (length s)))
         (num (parse-integer s :end (- (length s) l-2) :junk-allowed 't)))
    (cons num unit)))

(defun parse-value (key-sym value)
  (case key-sym
    ((byr)
     (parse-integer value))
    ((iyr)
     (parse-integer value))
    ((eyr)
     (parse-integer value))
    ((hgt)
     (parse-height value))
    (t value)))

(defun parse-fields (entry doc start-ix)
  (let ((field-sep-ix (position #\: entry :start start-ix))
        (next-field-ix (position-if #'space-or-newline? entry :start start-ix)))
    (if (eq field-sep-ix 'nil)
      doc
      (let* ((key (subseq entry start-ix field-sep-ix))
             (key-sym (intern (string-upcase key)))
             (value (subseq entry (+ field-sep-ix 1) (or next-field-ix (length entry)))))
        (funcall (fdefinition (list 'setf key-sym))
                 (parse-value key-sym value)
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
  (let* ((s (read-string-from-file "day4.input"))
         (entries (parse-entries s 0 0)))
    (count-if is-valid? (mapcar #'parse-doc entries))))

(defun part2-valid? (doc)
  (and
   (part1-valid? doc)
   (and (>= (byr doc) 1920)
        (<= (byr doc) 2002))
   (and (>= (iyr doc) 2010)
        (<= (iyr doc) 2020))
   (and (>= (eyr doc) 2020)
        (<= (eyr doc) 2030))
   (destructuring-bind (num . unit) (hgt doc)
     (cond
       ((string= unit "cm")
        (and (>= num 150) (<= num 193)))
       ((string= unit "in")
        (and (>= num 59) (<= num 79)))
       (t 'nil)))
   (cl-ppcre:scan "^#[0-9a-f]{6}$" (hcl doc))
   (some #'identity
         (mapcar (lambda (x) (string= x (ecl doc)))
                 '("amb" "blu" "brn" "gry" "grn" "hzl" "oth")))
   (cl-ppcre:scan "^[0-9]{9}$" (pid doc))))

(defun part1 ()
  (run-part #'part1-valid?))

(defun part2 ()
  (run-part #'part2-valid?))
