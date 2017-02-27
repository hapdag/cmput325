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
; mixes the elements of L1 and L2 into a single list,
; by choosing elements from L1 and L2 alternatingly. 
; If one list is shorter than the other, then append all elements from the longer list at the end.
(defun mix (L1 L2)
	(if (equal L2 nil) ; if list s empty, just concatenate the two lists
		(append L1 L2)
	(if (equal L1 nil)
		(append L1 L2) ; if list s empty, just concatenate the two lists
		(if (cdr L2) ; if there is more than one atom left in the list
			(cons (car L2) (mix (cdr L2) L1)) ; recurse on lists in different orders
			(cons (car L2)  L1) ; or simply concatenate
		)
	)
	)
)

; Question 4
; splits the elements of L into a list of two sublists (L1 L2),
; by putting elements from L into L1 and L2 alternatingly.
(defun odds(L)
	(if (null L)
		nil
		(cons (car L) (odds(cddr L)))
	)
)

(defun evens(L)
	(if (null(cdr L))
		nil
		(cons (cadr L) (evens(cddr L)))
	)
)

(defun split(L)
	(list (odds L) (evens L))
)

; Question 5
; Question 5.1	Let L1 and L2 be lists. Is it always true that (split (mix L2 L1)) returns the list (L1 L2)? 
; If yes, give a proof. If no, describe exactly for which pairs of lists L1, L2 the result is different from (L1 L2).
; Answer:
; No, it is not always true that (split (mix L2 L1)) returns the list (L1 L2). An exmaple of inputing L1 and L2 and
; the result is different from (L1 L2) is if you use the pair (1 2 3) and (4 5), 
; (split (mix '(1 2 3) '(4 5))) would result in the output pair of (4 2 3) and (1 5)
; since the mix function combines the pair together first, alternating between atoms, the resulting would look like
; (4 1 5 2 3) since L2 is always evaluated first. Then the list is passed in to the split function to break it into
; 2 sub lists, again alternating between atoms, therefore resulting in (4 5 3) and (1 2).
; Therefore it is not always true for (split(mix (L2)(L1))) to return (L1 L2)
; If there is a difference in size between L1 and L2, with exception to edge cases such as L1 is exactly one atom larger
; then most likely the resulting list pair will be different.

; Question 5.2	Let L be a list. Is it always true that (mix(cadr(split L))(car(split L))) returns L? If yes, give a proof.
; describe exactly for which lists L the result is different from L.
; Answer:
; Yes, it is always true that (mix(cadr(split L))(car(split L))) returns L. 
; Trace of (mix(cadr(split L))(car(split L))) with (1 2 3 4 5) as L
; (mix(cadr(split '(1 2 3 4 5)))(car(split '(1 2 3 4 5))))
; (mix(cadr((1 3 5)(2 4)))(car((1 3 5)(2 4))))
; (mix'(2 4)'(1 3 5))
; (1 2 3 4 5)
; The current algorithm forces specific order when using the mix function, it negates the problem in the function call
; in 5.1, by enforcing an order of operations such that the list returned from (cadr(split L)) is always smaller in size 
; than the list returned by (car(split L)) by 1, therefore removing the problem of bad inputs for the mix function call.
; Proving that (mix(cadr(split L))(car(split L))) always returns L.


; Question 6 subset sum
; given a list of numbers L and a sum S, find a subset of the numbers in L that sums up to S. 
; Each number in L can only be used once.
; First the input list is sorted, and then checked to remove all veriables bigger than Sum input since there are no
; need for them, then the sorted list in passed ino findsubsets to find the appropriate subset which sums up to the
; input Sum

; reorder function, after findsubset is done a ordered list is returned, reorder rearrange the list order to
; match the ordering of the original input list
(defun reorder (L Q)
	(if (null L)
		L
		(if (xmember Q (car L))
			(cons (car L) (reorder (cdr L) Q))
			(reorder (cdr L) Q)
		)
	)
)

; clear list goes through the sorted list and clears all atoms that are greater than the input sum
(defun clearlist (S L)
	(if (null L)
		L
		(if (<= (car L) S)
			(cons (car L) (clearlist S (cdr L)))
			(clearlist S (cdr L))
		)
	)
)	

; find subset returns the set of numbers that adds up to the total input Sum, returns nil if there are no applicable
; set. It will check for values equals or greater, finding an element equal meaning the end of of recursion, cons 
; the element in a list and end. Finding an element greater means it can stop checking further down the list, since
; the list is sorted in ascending order all other elements must be also greater than S, therefore we return nil.
; If the element is smaller than S, which mean potential member of the subset, findsubset calls itself with (S-L1)
; and the rest of list L, finding whether or not L1 is actually part of the subset recursively. If L1 is a part of
; the subset, then we construct the list, otherwise we remove that element and recall finsubset with the original 
; Sum value and the rest of the list L
(defun findsubset(S L)
	(cond

		((null L) nil)

		((= (car L) S)
			(cons (car L) ()))
		
		((> (car L) S)
			nil)
		
		((< (car L) S)
			(let ((Q (findsubset (- S (car L)) (cdr L)))) 
				(if (null Q) (findsubset S (cdr L))
					(cons (car L) Q) 
				)
			)
		)
	)
)


(defun subsetsum (S L)
	(let ((Q (sort (copy-list L) #'<))) 
		(reorder L (findsubset S (clearlist S Q))))
)
