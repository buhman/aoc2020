(defmodule day2
  (export (part1 0)
          (part2 0)))

(defun parse-line (bin)
  (let (((list min max `(,c) s)
         (string:tokens (binary_to_list bin) "- :")))
    (tuple (list_to_integer min)
           (list_to_integer max)
           c
           s)))

(defun parse (bin)
  (case (binary:split bin #"\n")
    ((list n t) (cons (parse-line n) (parse t)))
    ((list #"") '())
    ((list n) (list (parse-line n)))))

(defun count (s c)
  (lists:foldl (lambda (x a) (+ a (if (== x c) 1 0))) 0 s))

(defun part1-valid?
  (((tuple min max c s))
   (let ((s-count (count s c)))
     (and (>= s-count min) (=< s-count max)))))

(defun valid-passwords (ps f)
  (lists:foldl (lambda (p a) (+ a (if (funcall f p) 1 0))) 0 ps))

(defun run-part (valid?)
  (let* ((`#(ok ,data) (file:read_file "input/day2.txt"))
         (specs (parse data)))
    (valid-passwords specs valid?)))

(defun part1 ()
  (run-part #'part1-valid?/1))

(defun part2-valid?
  (((tuple i1 i2 c s))
   (let ((a (lists:nth i1 s))
         (b (lists:nth i2 s)))
     (and (!= a b) (or (== a c) (== b c))))))

(defun part2 ()
  (run-part #'part2-valid?/1))
