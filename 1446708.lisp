; Question 1 xmember
; Check first element of x list against y
; if not a match
; call xmember again with the rest of x against y
(defun xmember(x y)
	(if (null x)
		x
		(if (equal (car x) y)
			(equal (car x) y)
			(xmember(cdr x) y)
			)
	)
)


; Question 2 flatten
; check if first list item is atom
; if it's not, unpack nested list and recurse
; if it is, put atom in new list and recurse
(defun flatten (x)
	(if (null x)
		x
		(if (null(atom(car x))) ;if item is not an atom
			(append (flatten (car x)) (flatten (cdr x))) ;call flatten on first item then concatenate	
			(cons (car x) (flatten (cdr x))) ;otherwise take atom and concatenate
		)
	)
)

; Question 3
; that mixes the elements of L1 and L2 into a single list,
; by choosing elements from L1 and L2 alternatingly. 
; If one list is shorter than the other, then append all elements from the longer list at the end.
(defun mix (L1 L2)
	(if (null L1)
		(append L1 L2)
	)
)

 (print(mix '() '(a b c)))