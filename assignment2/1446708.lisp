
(defun fl-interp (E P)
  (cond 
    ((atom E) E)   ;this includes the case where expr is nil
    (t
      (let ( (f (car E))  (arg (cdr E)) )
        (cond 

          ; handle built-in functions
          ((eq f '+)  (+ (fl-interp (car arg) P) (fl-interp (cadr arg) P)))
          ((eq f '-)  (- (fl-interp (car arg) P) (fl-interp (cadr arg) P)))
          ((eq f '*)  (* (fl-interp (car arg) P) (fl-interp (cadr arg) P)))
          ((eq f '>)  (> (fl-interp (car arg) P) (fl-interp (cadr arg) P)))
          ((eq f '<)  (< (fl-interp (car arg) P) (fl-interp (cadr arg) P)))
          ((eq f '=)  (= (fl-interp (car arg) P) (fl-interp (cadr arg) P)))
          ((eq f 'equal)  (equal (fl-interp (car arg) P) (fl-interp (cadr arg) P)))
          ((eq f 'eq)  (eq (fl-interp (car arg) P) (fl-interp (cadr arg) P)))
          ((eq f 'and)  (and (fl-interp (car arg) P) (fl-interp (cadr arg) P)))
          ((eq f 'or)  (or (fl-interp (car arg) P) (fl-interp (cadr arg) P)))
        
          ((eq f 'not)  (not (fl-interp (car arg) P) ))
          ((eq f 'isnumber)  (numberp (fl-interp (car arg) P) ))
          ((eq f 'null)  (null (fl-interp (car arg) P) ))
          ((eq f 'atom)  (atom (fl-interp (car arg) P) ))

          ((eq f 'first)  (car (fl-interp (car arg) P) ))
          ((eq f 'rest)  (cdr (fl-interp (car arg) P) ))
          ((eq f 'cons)  (cons (fl-interp (car arg) P) (fl-interp (cadr arg) P)))

          ((eq f 'if)  (if (fl-interp (car arg) P) (fl-interp (cadr arg) P) (fl-interp (caddr arg) P) ))

          ((null P) E)         

	      ; if f is a user-defined function,
          ;    then evaluate the arguments 
          ;         and apply f to the evaluated arguments 
          ;             (applicative order reduction)
          ; Passing info into user-defined function handler
          ; function name, function arguments
          (t (usreval f arg P P))

          ; otherwise f is undefined; in this case,
          ; E is returned as if it is quoted in lisp
        )
      )
    )
  )
)

; returns user defined functions without identifiers the fl-interp interpreter cannot handle
(defun clearf (P)
  (if (equal (car P) '=) (cadr P)
    (clearf (cdr P)) 
  )
)

; where ori is an atom, rep is some expression,
; and expr is a (possibly nested) list. The function sub does the job of substitution, i.e., it replaces
; every occurrence of ori in expr with rep. 
(defun sub (ori rep expr)
  (cond
    ((null expr) nil)
    ((atom expr) (if (eq expr ori) rep expr))
    (t (cons (sub ori rep (car expr)) (sub ori rep (cdr expr)) ) )
  )
)

; using passed in parameters to find function arguments from user defined functions
(defun searcharg (n v)
  (if (null n) n
    (cons (car v) (searcharg (cdr n) (cdr v)))
  )
)

; iterate over both argument list and parameter list and substitute in expression
(defun replacer (x v e)
  (cond
    ((null x) e)
    (t (replacer (cdr x) (cdr v) (sub (car x) (car v) e) ) )
  )
)

; main aux function for handling user defined functions
(defun usreval (funname arg funbody P)
  (cond
    ; return the now evaluated function application with user input parameters binded with function arguments
    ((null funbody) (cons funname arg ) )
    ; find appropriate function, substitue function arguments with input parameters and hand evaluated founction to interpreter
    ((equal funname (caar funbody)) (fl-interp (replacer (searcharg arg (cdar funbody)) arg  (clearf (cdar funbody)))  P ) )
    
    (t (usreval funname arg (cdr funbody) P))
  )
)