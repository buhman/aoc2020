(defmodule day1
  (export (part1 0)))

(defun check-inner
  ((n ()) 'nil)
  ((n (cons h t))
   (if (== 2020 (+ n h))
     (tuple n h)
     (check-inner n t))))

(defun check
  ((()) 'nil)
  (((cons h t))
   (case (check-inner h t)
     ('nil (check t))
     ((tuple a b) (* a b)))))

(defun parse (bin)
  (case (binary:split bin #"\n")
    ((list n t) (cons (binary_to_integer n) (parse t)))
    ((list #"") '())
    ((list n) (list (binary_to_integer n)))))

(defun part1 ()
  (let ((`#(ok ,data) (file:read_file "input/day1.txt")))
    (check (parse data))))

;; does not implement part2
