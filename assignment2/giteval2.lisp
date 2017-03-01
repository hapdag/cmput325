;Check the length of 2 argument to see if they match
;A is #arg in function
;B is #arg in user defined function
(defun checkArgLen (A B)
	(cond
		((and (or (null A) (null B) ) (not (and (null A) (null B)))) nil	) 
		((and (null A) (null B)) T						)
		(t (checkArgLen (cdr A) (cdr B))					)	
	)
)

;Return null if null or T if not null
(defun returnBool (X)
	(if (equal X nil)
		nil
		T
	)
)

;Strips the values up to the "="
;P is user defined function, assumed that the function name is not taken in
(defun getVar (P)
	(cond 
		((equal (car P) '=) nil  		)
		(t (cons (car P) (getVar (cdr P)))  	)	    
	)
)

;Returns the body of the user define function
;P is user define function
(defun getBody (P)
	(cond
		((equal (car P) '=) (cadr P)     	)
		(t (getBody (cdr P))			)	
	)
)

;Determinds when to swap input values with variables 
;Test to see if L is just an atom then we can replace, if not go into list and check
;I element is a input value 
;V element is a variable of user defined function
;L element list is body of user defined function

;TESTCASES
;(isMember 1 'x '(+ 2 x)) => (+ 2 1)
;(isMember 1 'x '(+ (+ 2 x) x)) => (+ (+ 2 1) 
(defun isMember (I V L)
	(cond 
		((null L) nil	)
		((and (atom L) (equal L V))  I 												)
		((and (atom L) (not (equal L V)))  L											)
		((and (atom (car L)) (equal V (car L)) (cons I (isMember I V (cdr L)))	  ) 						)
		((and (atom (car L)) (not (equal V (car L)) ) (cons (car L) (isMember I V (cdr L))))					)
		(t (cons (isMember I V (car L)) (isMember I V (cdr L))  )								) 
	)
)


;Switch interates through I,V and isMember to determind when to swap out variables in body for input values
;I element list is input value
;V element list is variable of user defined function
;L element list is body of user defined function

;TESTCASES
;(switch '(1 2) '(x y) '(+ (+ x y) y)) => (+ (+ 1 2) 2)
(defun switch (I V L)
	(cond
		((or (null V) (null I)) L									)	
		(t ( switch (cdr I) (cdr V) (isMember (car I) (car V) L))					)

	)
)

;This helper functino evaluates the user define function. This is done by checking that first the function is equal to the parameter in question as well as meet the 
;amount of arguments that user define function requires. Then after it found the match it parse in the input argument, variables of the user define function
;followed by the body of the user define function. 
;F is the function name
;P is the list of user defined function names (to be interated through)
;G is the list of user deined function name (always constant)
;A is the list of inputs
(defun evaUserDef (F A P G)
	(cond
		((null P) (cons F A)																		)			
		((and (equal F (caar P)) (checkArgLen A (getVar (cdar P)))     )   ( fl-interp   (switch A (getVar (cdar P)) (getBody (cdar P)) )  G	)      			)
		(t (evaUserDef F A (cdr P) G)																	)
	)
)


;A program P in FL is a list of function definitions. The FL interpreter takes such a program, together with a function application, and returns the result of evaluating the application. 
;This evaluation is based on the principle of "replacing equals by equals".
;If the 't' condition is met then there is a user define function that needs to be evaluated. 

;TESTCASES
;(fl-interp '(+ 10 5) nil) => 15
;(fl-interp '(greater 3 5) '((greater x y = (if (> x y) x (if (< x y) y nil))))) => 5
;(fl-interp '(factorial 4) '((factorial x = (if (= x 1) 1 (* x (factorial (- x 1))))))) => 24
(defun fl-interp (E P)
	(cond 
		((atom E) E)   
        	(t
           		(let ( (f (car E))  (arg (cdr E)) )
	      			(cond 
					((eq f 'if)     (if     (fl-interp 	(car arg) P) (fl-interp  (cadr arg) P)	(fl-interp  (caddr arg) P))	)
					((eq f 'null)   (null   (fl-interp 	(car arg) P))								)
					((eq f 'atom)   (atom   (fl-interp 	(car arg) P)) 								) 
					((eq f 'eq) 	(eq     (fl-interp      (car arg) P) (fl-interp  (cadr arg) P))					)
               		((eq f 'first)  (car    (fl-interp 	(car arg) P))								)
					((eq f 'rest)   (cdr    (fl-interp 	(car arg) P))								)
					((eq f 'cons)   (cons   (fl-interp      (car arg) P) (fl-interp  (cadr arg) P))					)
					((eq f 'equal) 	(equal  (fl-interp      (car arg) P) (fl-interp  (cadr arg) P))					)
					((eq f 'number) (numberp(fl-interp 	(car arg) P))								)
					((eq f '+) 	(+      (fl-interp      (car arg) P) (fl-interp  (cadr arg) P))					)
					((eq f '-) 	(-      (fl-interp      (car arg) P) (fl-interp  (cadr arg) P))					)
					((eq f '*) 	(*      (fl-interp      (car arg) P) (fl-interp  (cadr arg) P))					)
					((eq f '>) 	(>      (fl-interp      (car arg) P) (fl-interp  (cadr arg) P))					)
					((eq f '<) 	(<      (fl-interp      (car arg) P) (fl-interp  (cadr arg) P))					)
					((eq f '=) 	(=      (fl-interp      (car arg) P) (fl-interp  (cadr arg) P))					)
					((eq f 'and) 	(returnBool (and    (fl-interp      (car arg) P) (fl-interp  (cadr arg) P)))			)
					((eq f 'or) 	(returnBool (or     (fl-interp      (car arg) P) (fl-interp  (cadr arg) P)))			)
					((eq f 'not)    (returnBool (not    (fl-interp 	(car arg) P)))							)	 		
					((null P)	E												)					
					(t 	(evaUserDef f arg P P)

						
					)
				)
			)
		)	
	)
)




