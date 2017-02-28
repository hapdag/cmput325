; Andrea McIntosh
; 1346224
; CMPUT 325, Section B1
; Assignment 2
; Consulted with Jenna Hatchard and Dylan Ashley

#|
 Interpreter for the language "FL" implemented in lisp.
 The Interpreter takes an expression in FL (E), and a program (P) which is a list that
 defines any user functions called in the expression.  The interpreter returns
 the result of evaluating the expression with respect to the program.  If the
 expression only calls built-in primitive functions, then the program may be
 empty.  User-defined functions are identified by both their name and arity, so
 functions with the same name but different arity are treated as different functions.
 All user functions called in the expression must be defined in the program, and
 functions (same name, same arity) should not be re-defined in the program.  Expressions
 are evaluated in applicative order, so some evaluations may not terminate.

 The evaluation of the expression and program is done using a helper function,
 fl_interp_eval, which includes a context in the interpretation.  At the start of
 interpretation the context is empty.

 Test Cases:
    (fl-interp '(+ 1 2) nil) => 3
    (fl-interp '(if (< 1 2) 3 4) nil) => 3
    (fl-interp '(f 1 2) '((f x y = (* x y)))) => 2
    (fl-interp '(f (f 1 2)) '((f x = (+ x x)) (f x y = (* x y)))) => 4
    (fl-interp '(h (g 5)) '((g X = (g (g X))) (h X = a))) => NON-TERMINATING! (will result in error)
|#
(defun fl-interp (E P)
    (fl_interp_eval E P NIL)
)

#|
 Function that performs the actual evaluaiton of the expression in the program.
 This funciton takes an expression in FL (E), a program (P) which defines any
 user functions called in the expression, and a context (C) for the variables in
 the expression to be evaulated in.

 If the expression being evaluated is an atom, first the program tests if the atom
 is name of a function or variable, in which case its value is returned.  If the name
 is not found in the program or context, then the atom is a constant and its value is
 returned.
 If the expression is not an atom, it is split into a function name and an argument
 list.  First, it is checked if the function is a built-in function of FL; in this
 case the arguments of the function are evaluated in applicative order and used to
 evaluate the built-in function.  If the function is not a built-in, then it must be
 user-defined.  In this case the arguments are evaluated and the function is retrieved
 from the program.  In the case that a function definition for the current function name
 is not found in the program, the entire expression is return as this means that
 the program is trying to interpret a non-atomic constant (e.g. a list like (1 2),
 or (a b c)).  If a function matching the function name is found in the program, the
 context is extended with the arguments to the function and the evaluated arguments,
 and the body of the function is evaluated in the extended context.
|#
(defun fl_interp_eval (E P C)
    (cond
        ((atom E) (find_func_in_program E P C))
        (t
            (let ((f (car E)) (arg (cdr E)))
                (cond
                    ; handle built-in functions
                    ((eq f 'if) (if (fl_interp_eval (car arg) P C) (fl_interp_eval (cadr arg) P C) (fl_interp_eval (caddr arg) P C)))
                    ((eq f 'null)  (null (fl_interp_eval (car arg) P C)))
                    ((eq f 'atom)  (atom (fl_interp_eval (car arg) P C)))
                    ((eq f 'eq)  (eq (fl_interp_eval (car arg) P C) (fl_interp_eval (cadr arg) P C)))
                    ((eq f 'first)  (car (fl_interp_eval (car arg) P C)))
                    ((eq f 'rest)  (cdr (fl_interp_eval (car arg) P C)))
                    ((eq f 'cons) (cons (fl_interp_eval (car arg) P C) (fl_interp_eval (cadr arg) P C)))
                    ((eq f 'equal)  (equal (fl_interp_eval (car arg) P C) (fl_interp_eval (cadr arg) P C)))
                    ((eq f 'number)  (numberp (fl_interp_eval (car arg) P C)))
                    ((eq f '+)  (+ (fl_interp_eval (car arg) P C) (fl_interp_eval (cadr arg) P C)))
                    ((eq f '-)  (- (fl_interp_eval (car arg) P C) (fl_interp_eval (cadr arg) P C)))
                    ((eq f '*)  (* (fl_interp_eval (car arg) P C) (fl_interp_eval (cadr arg) P C)))
                    ((eq f '>)  (> (fl_interp_eval (car arg) P C) (fl_interp_eval (cadr arg) P C)))
                    ((eq f '<)  (< (fl_interp_eval (car arg) P C) (fl_interp_eval (cadr arg) P C)))
                    ((eq f '=)  (= (fl_interp_eval (car arg) P C) (fl_interp_eval (cadr arg) P C)))
                    ((eq f 'and)  (not (null (and (fl_interp_eval (car arg) P C) (fl_interp_eval (cadr arg) P C)))))
                    ((eq f 'or)  (not (null (or (fl_interp_eval (car arg) P C) (fl_interp_eval (cadr arg) P C)))))
                    ((eq f 'not)  (not (fl_interp_eval (car arg) P C)))

                    (t
                        (let
                            ((ev_args (eval_args arg P C))
                                (function_def (get_func f (get_arity arg) P)))
                            (if function_def
                                (let
                                    ((new_context (extend_context (car function_def) ev_args C))
                                        (body (cadr function_def)))
                                    (fl_interp_eval body P new_context)
                                )
                                E
                            )
                        )
                    )
                )
            )
        )
    )
)

#|
 Given a variable name (E), search for it in the given program (P) and return the
 first function in the program the name corresponds with.  The function also takes
 a context (C), as if the name is not found in the program, the name is then
 assumed to be a variable name and is searched for in the conext using the
 find_var_in_context function.  If the name does match a function in the program
 the funciton is returned as it as a nested list with a list of the function arguments
 as its first element, and a list containing the function body as its second.
|#
(defun find_func_in_program (E P C)
    (cond
        ((null P) (find_var_in_context E C))
        ((equal (caar P) E) (list (get_fnargs (cdar P)) (get_fnbody (car P))))
        (t (find_func_in_program E (cdr P) C))
    )
)

#|
 Given a variable name (E), search for it in the given context (C) and return the
 first value in the context the name corresponds with.  If the name cannot be found
 in the context, return the name.

 Example:
    (find_var_in_context 'y '((x . 1) (y . 2))) => 2
|#
(defun find_var_in_context (E C)
    (cond
        ((null C) E)
        ((equal E (caar C)) (cdar C))
        (t (find_var_in_context E (cdr C)))
    )
)

#|
 Given a function definition in a list (L), return a list containing the body
 of the function.  In FL this will be the part of the function definition following
 the '='.

 Example:
    (get_fnbody '(f x = (* x x))) => (* x x)
|#
(defun get_fnbody (L)
    (cond
        ((eq (car L) '=) (cadr L))
        (t (get_fnbody (cdr L)))
    )
)

#|
 Given a function definition in a list (L), return a list of the function's
 arguments. In FL this will be the part of the function definition following the
 name but preceding the '='.

 Example:
    (get_fnargs '(x y = (< x y))) => (x y)
 |#
(defun get_fnargs (L)
    (cond
        ((eq (car L) '=) nil)
        (t (cons (car L) (get_fnargs (cdr L))))
    )
)

#|
 Given a list of arguments (args), a program (P), and a context (C), evaluate the
 arguments using applicative order reduction and return the evaluted arguments.
|#
(defun eval_args (args P C)
    (cond
        ((null args) nil)
        (t (cons (fl_interp_eval (car args) P C) (eval_args (cdr args) P C)))
    )
)

#|
 Given a function's name (f) and its arity (arity), find the function in the
 program (P), and return it as a nested list with a list of the function arguments
 as its first element, and a list containing the function body as its second.

 Example:
    (get_func 'f '2 '((f x = (+ x x)) (f x y = (* x y)))) => ((x y) (* x y))
|#
(defun get_func (f arity P)
    (cond
        ((null P) nil)
        ((and (equal (caar P) f) (equal arity (get_arity (get_fnargs (cdar P))))) (list (get_fnargs (cdar P)) (get_fnbody (car P))))
        (t (get_func f arity (cdr P)))
    )
)

#|
 This function is a basic counting function that, given the list of arguments (args)
 to a function, return the 'arity' of that function.

 Example, to find the arity of (f 2 3) call:
    (get_arity '(2 3)) => 2
|#
(defun get_arity (args)
    (cond
        ((null args) 0)
        (t (+ 1 (get_arity (cdr args))))
    )
)

#|
 Given an exisiting context (C), use an ordered list of variable names (vars) and
 an ordered list of values (nums), extend the context.  The extension is done by
 associating a variable name with the value in the corresponding position in the
 values list, and prepending them to the current context.  Thus, the names list and
 values list must be ordered such that each variable name is in the same position
 position in its list as its corresponding value in the values list.

 Example:
    (extend_context '(x y) '(1 2) nil) => ((x . 1) (y . 2))
|#
(defun extend_context (vars nums C)
    (cond
        ((null nums) C)
        (t (cons (cons (car vars) (car nums)) (extend_context (cdr vars) (cdr nums) C)))
    )
)
