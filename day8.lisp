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

(defun console-eval (mem seen ip acc)
  (let* ((ins (elt mem ip))
         (opcode (car ins))
         (operand (cdr ins)))
    (if (or (member ip seen) (>= ip (length mem)))
      acc
      (apply #'console-eval
             mem
             (cons ip seen)
             (case opcode
               ((acc)
                (list (+ ip 1) (+ acc operand)))
               ((jmp)
                (list (+ ip operand) acc))
               ((nop)
                (list (+ ip 1) acc)))))))

(defun part1 ()
  (let ((mem (map 'vector
                  #'parse-line
                  (read-lines-from-file "day8.input"))))
    (console-eval mem '() 0 0)))
