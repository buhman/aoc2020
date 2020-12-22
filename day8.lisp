(load "read.lisp")

(defun parse-line (s)
  (let* ((space (position #\Space s))
         (opcode (subseq s 0 space))
         (operand (subseq s (+ space 1))))
    (cons
     (cond
       ((string= opcode "acc") 'acc)
       ((string= opcode "jmp") 'jmp)
       ((string= opcode "nop") 'nop))
     (parse-integer operand))))

(defun console-eval (mem acc ip seen)
  (if (or (member ip seen) (= ip (length mem)))
    (values acc ip seen)
    (let* ((ins (elt mem ip))
           (opcode (car ins))
           (operand (cdr ins)))
      (console-eval
       mem
       (case opcode
         ((acc) (+ acc operand))
         ((jmp nop) acc))
       (case opcode
         ((acc nop) (+ ip 1))
         ((jmp) (+ ip operand)))
       (cons ip seen)))))

(defun read-input ()
  (map 'vector
       #'parse-line
       (read-lines-from-file "day8.input")))

(defun part1 ()
  (let ((mem (read-input)))
    (multiple-value-bind (ip) (console-eval mem 0 0 '())
      ip)))

(defun flip-opcode (mem i)
  (let* ((ins (elt mem i))
         (opcode (car ins))
         (operand (cdr ins)))
    (setf (elt mem i)
          (cons
           (case opcode
             ((jmp) 'nop)
             ((nop) 'jmp))
           operand))))

(defun non-acc-addrs (mem addrs)
  (remove-if (lambda (i) (eq (car (elt mem i)) 'acc)) addrs))

(defun find-terminating (mem addrs)
  (let ((i (car addrs)))
    (flip-opcode mem i)
    (multiple-value-bind (acc ip) (console-eval mem 0 0 '())
      (if (= ip (length mem))
        acc
        (progn
         (flip-opcode mem i)
         (find-terminating mem (cdr addrs)))))))

(defun part2 ()
  (let ((mem (read-input)))
    (multiple-value-bind (acc ip seen) (console-eval mem 0 0 '())
      (declare (ignore acc ip))
      (let ((addrs (non-acc-addrs mem seen)))
        (find-terminating mem addrs)))))
