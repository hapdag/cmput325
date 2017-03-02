; where ori is an atom, rep is some expression,
; and expr is a (possibly nested) list. The function sub does the job of substitution, i.e., it replaces
; every occurrence of ori in expr with rep. 
(defun sub (ori rep expr)
  (cond
    ((null expr) nil)
  ; (if (null ori) ori 
  ;   (if (and (car ori) (atom expr) (if (eq expr (car ori)) (car rep) expr)  )  
  ;     (cons (sub ori rep (car expr)) (sub (cdr ori) (cdr rep) (cdr expr)) )
  ;     )
    ((atom expr) (if (eq expr ori) rep expr))
    ((and (atom (car expr)) (equal ori (car expr)) (cons rep (sub rep ori (cdr expr)))))
    ((and (atom (car expr)) (not (equal ori (car expr)) ) (cons (car expr) (sub rep ori (cdr expr)))))
    (t (cons (sub ori rep (car expr)) (sub ori rep (cdr expr)) ) )
  )
)

(defun searcharg (n v)
  (if (null n) n
    (cons (car v) (searcharg (cdr n) (cdr v)))
  )
)

(defun replacer (x v e)
  (cond
    ((null x) e)
    (t (replacer (cdr x) (cdr v) (sub (car x) (car v) e) ) )
  )
)

; (defun assoc (n v x)
;   (if (null n) n
;     (if (not (null n)) (locate (car n) (car v) x)
;       (assoc)
;     )
;   )
; )

; (defun locate(l m x)
; )

(defun usreval (funname arg funbody P)
  (cond
    ; if empty function body, return arguments
    ((null funbody)  "debug0")
    ; create context lists
    ((equal funname (caar funbody))  (replacer (searcharg arg (cdar funbody)) arg funbody)  ) 
    ((not (equal funname (caar funbody))) "debug2" )
    ; (t (usreval funname arg (cdr funbody) P))
  )
)

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