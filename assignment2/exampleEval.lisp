; Note:
; To make sense of this, it is important to understand what is evaluated by Lisp vs what is evaluated by our interpreter.
; The general format should be:
; (starteval 'e)
; where e is the expression to be evaluated by our interpreter.
; The quote is needed here, otherwise Lisp will already evaluate the argument e before handing it to starteval.

; Another important restriction is that our interpreter has no notion of a built-in list data type. All lists must be constructed using cons. If you give it a list such as (1 2), it will treat it as a function application of function 1 to argument 2, and fail.

; To understand more about how the interpreter works, try:
; (trace xeval)

; Examples:

; (starteval 5)
; (starteval (+ 5 2)) # it works, but lisp already reduced the (+5 2) to 7 before handing it to our interpreter

; (starteval '(+ 5 2))
; 7 # the right way to call it. Our interpreter handles the + function application. One way to see that is to redefine what our + function computes.

; (starteval t)
; (starteval nil)
; (starteval '(xquote (1 2)))
; (starteval '(atom x))
; (starteval '(atom (1 2)))    # ERROR
; (starteval '(atom (cons 1 (cons 2 nil))))    # CORRECT
; (starteval '(car (cons 1 nil)))
; (starteval '(car (cons 1 (cons 2 nil))))
; (starteval '(cdr (cons 1 (cons 2 nil))))    # note it returns a Lisp list, since calling the Lisp cdr in our interpreter
; (starteval '((lambda (x) (+ x 1)) 5))
; (starteval '(((lambda (x y) (lambda (x) (+ x y))) 2 3) 4))
; (starteval '((lambda (x) (x 2))  (lambda (x) (+ x 1))))
; (starteval '((lambda (x y) (+ x y))  ((lambda (y z) (+ y z)) 2 3) 4))
; (starteval '(lambda (x y) (lambda ())))

; (print(fl-interp '(+ 10 5) nil) ); > '15
; (print(fl-interp '(- 12 8) nil) ); > '4
; (print(fl-interp '(* 5 9) nil) ); > '45
; (print(fl-interp '(> 2 3) nil) ); > 'nil
; (print(fl-interp '(< 1 131) nil) ); > 't
; (print(fl-interp '(= 88 88) nil) ); > 't
; (print(fl-interp '(and nil t) nil) ); > 'nil
; (print(fl-interp '(or t nil) nil) ); > 't
; (print(fl-interp '(not t) nil) ); > 'nil
; (print(fl-interp '(isnumber 354) nil) ); > 't
; (print(fl-interp '(equal (3 4 1) (3 4 1)) nil) ); > 't
; (print(fl-interp '(if nil 2 3) nil) ); > '3
; (print(fl-interp '(null ()) nil) ); > 't
; (print(fl-interp '(atom (3)) nil) ); > 'nil
; (print(fl-interp '(eq x x) nil) ); > 't
; (print(fl-interp '(first (8 5 16)) nil) ); > '8
; (print(fl-interp '(rest (8 5 16)) nil) ); > '(5 16)
; (print(fl-interp '(cons 6 3) nil) ); > '(6 . 3)

; (print(fl-interp '(+ (* 2 2) (* 2 (- (+ 2 (+ 1 (- 7 4))) 2))) nil)) ; > '12
; (print(fl-interp '(and (> (+ 3 2) (- 4 2)) (or (< 3 (* 2 2))) (not (= 3 2))) nil)) ; > 't
; (print(fl-interp '(or (= 5 (- 4 2)) (and (not (> 2 2)) (< 3 2))) nil)) ; > 'nil
; (print(fl-interp '(if (not (null (first (a c e)))) (if (isnumber (first (a c e))) (first (a c e)) (cons (a c e) d)) (rest (a c e))) nil)) ; > '((a c e) . d)

(print(fl-interp '(greater 3 5) '((greater x y = (if (> x y) x (if (< x y) y nil))))) ); > '5
(print(fl-interp '(square 4) '((square x = (* x x)))) ); > '16
(print(fl-interp '(simpleinterest 4 2 5) '((simpleinterest x y z = (* x (* y z))))) ); > '40
(print(fl-interp '(xor t nil) '((xor x y = (if (equal x y) nil t)))) ); > 't

; ; ; complex user defined cases

; (print(fl-interp '(last (s u p)) '((last x = (if (null (rest x)) (first x) (last (rest x)))))) ); > 'p
; (print(fl-interp '(push (1 2 3) 4) '((push x y = (if (null x) (cons y nil) (cons (first x) (push (rest x) y)))))) ); > '(1 2 3 4)
; (print(fl-interp '(pop (1 2 3)) '((pop x = (if (atom (rest (rest x))) (cons (first x) nil) (cons (first x)(pop (rest x))))))) ); > '(1 2)
; (print(fl-interp '(power 4 2) '((power x y = (if (= y 1) x (power (* x x) (- y 1)))))) ); > '16
; (print(fl-interp '(factorial 4) '((factorial x = (if (= x 1) 1 (* x (factorial (- x 1))))))) ); > '24
; (print(fl-interp '(divide 24 4) '((divide x y = (div x y 0)) (div x y z = (if (> (* y z) x) (- z 1) (div x y (+ z 1)))))) ); > '6 
; (print (fl-interp '(h (g 5)) '((g X = (g (g X)))(h X = a )))) ; > a

;     (print (fl-interp '(a (+ 1 2)) 
;             '( (a X = (+ X 1)) )
;     ) )
; ; => 4

;     (print(fl-interp '(b (+ 1 2)) 
;             '( (b X = (+ X 1)) )
;     ))
; ; => 4

;     (print(fl-interp '(f (f 2)) 
;             '( (f X =  (* X X)) )
;     ))
; ; => 16