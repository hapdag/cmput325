;Question 1 xmember
;Check first element of x list against y
;if not a match
;call xmember again with the rest of x against y
(defun xmember(x y)
	(if (null x)
		(print nil)
		(if (equal (car x) y)
			(print "T")
			(xmember(cdr x) y)
			)
	)
)

;Question 2 unpack any possible nested lists in list X
;as atoms in a "flatten"ed list as output assume no
;nil or empty list inputs

;grab first element in list x, check if atom


; (defun flatten(x)
; 	(if (null x)
; 		x
; 		(if (null(cdr x))
; 			;simplest form, only one item in list
; 			;need to check if item is an atom, or if item is a nested list
; 			(if (atom (car x))
; 				; if it is an atom, return the atom
; 				; (cons (car x) (flatten (cdr x)))
; 				(cons (car x) ())
; 				; it it's not an atom, continue unpack
; 				(flatten (car x))
; 			)
; 			(if (atom (car x))
; 				; if it is an atom, return the atom
; 				(cons (car x) (flatten (cdr x)))
; 				; it it's not an atom, continue unpack
; 				(flatten (car x))
; 			)
						
; 		)
; 	)
; )

(defun flatten (x)
	(if (null x)
		x
		(if (null(atom(car x)))
			(append (flatten (car x)) (flatten (cdr x)))		
			(cons (car x) (flatten (cdr x)))
			)
		)
	)
(write(flatten '(a (b c) d)))
