% =====QUESTION 1===== xreverse (1 mark)
% Define the predicate xreverse(+L, ?R) to reverse a list, 
% where L is a given list and R is either a variable or another given list.
% Examples: 
% xreverse([7,3,4],[4,3,7]). should return true,
% xreverse([7,3,4],[4,3,5]). should return false,
% xreverse([7,3,4], R). should return R = [4,3,7].
% Your program should generate only one solution, so if the user presses ";" the next answer should be "false".

% student comments:
% First pass from xreverse/2 to xreverse/3 where a accumulator a setup to take values of List A until empty
% then unify accumulator to List B to generate solution

xreverse(ListA,ListB):- xreverse(ListA,[],ListB).
xreverse([Ahead|Atail],AccmL,ListB) :- xreverse(Atail,[Ahead|AccmL],ListB).
xreverse([],AccmL,AccmL).

% ======QUESTION 2====== xunique (2 marks)
% Define the predicate xunique(+L, ?O) 
% where L is a given list of atoms and O is a copy of L where all the duplicates have been removed. 
% O can be either a variable or a given list. The elements of O should be in the order in which they first appear in L.
% Examples: 
% xunique([a,c,a,d], O). should return O = [a,c,d], 
% xunique([a,c,a,d], [a,c,d]). should return true, 
% xunique([a,c,a,d], [c,a,d]). should return false (because of wrong order), 
% xunique([a,a,a,a,a,b,b,b,b,b,c,c,c,c,b,a], O). should return O = [a,b,c], 
% xunique([], O). should return O = [].
% Your program should generate only one solution, so if the user presses ";" the next answer should be "false".

% student comments;
% similar code structure to xreverse, putting unique items from List A to accumulator, unifying accumulator
% with List B then exit calls. With predicates asisting in checking is an atom is or is not a member of accumulator 
% list before appending.

xunique(ListA,ListB):- xunique(ListA,[],ListB).
xunique([Ahead|Atail],AccmL,ListB):- notmember(Ahead,AccmL),append(AccmL,[Ahead],OutList),xunique(Atail,OutList,ListB).
xunique([Ahead|Atail],AccmL,ListB):- member(Ahead,AccmL),xunique(Atail,AccmL,ListB).
xunique([],AccmL,AccmL).

notmember(_,[]).
notmember(X,[Head|Tail]):- X\==Head,notmember(X,Tail).

member(X,[X|_]). 
member(X,[_|Tail]):-  member(X,Tail).

% 3 xdiff (1 mark)
% Define the predicate xdiff(+L1, +L2, -L) where L1 and L2 are given lists of atoms,
% and L contains the elements that are contained in L1 but not L2 (set difference of L1 and L2). 
% Examples: 
% xdiff([a,b,f,c,d],[e,b,a,c],L). should return L=[f,d], 
% xdiff([p,u,e,r,k,l,o,a,g],[n,k,e,a,b,u,t],L). should return L = [p,r,l,o,g], 
% xdiff([],[e,b,a,c],L). should return L = [].
% Your program should generate only one solution, so if the user presses ";" the next answer should be "false".


% student comments:
% pretty much reused the code from xunique, found items in List A that are not members of List B, put them in 
% accumulator list and unify to difference variable/list then exit

xdiff(ListA,ListB,Diff):- xdiff(ListA,ListB,Diff,[]).
xdiff([Ahead|Atail],ListB,Diff,AccmL):- notmember(Ahead,ListB), 
	append(AccmL,[Ahead],OutList), xdiff(Atail,ListB,Diff,OutList).
xdiff([Ahead|Atail],ListB,Diff,AccmL):- member(Ahead,ListB),xdiff(Atail,ListB,Diff,AccmL).
xdiff([],ListB,AccmL,AccmL).

% 4 removeLast (1 mark)
% Define the predicate removeLast(+L, ?L1, ?Last) where L is a given non-empty list,
% L1 is the result of removing the last element from L, and Last is that last element.
% L1 and Last can be either variables or given values.
% Examples: 
% removeLast([a,c,a,d], L1, Last). should return L1 = [a,c,a], Last = d, 
% removeLast([a,c,a,d], L1, d). should return L1 = [a,c,a], 
% removeLast([a,c,a,d], L1, [d]). should return false (why?), 
% removeLast([a], L1, Last). should return L1 = [], Last = a, 
% removeLast([[a,b,c]], L1, Last). should return L1 = [], Last = [a,b,c].
% Your program should generate only one solution, so if the user presses ";" the next answer should be "false".

% student comments
removeLast([Ahead|Atail],[Ahead|ListB],Last) :- removeLast(Atail,ListB,Last).
removeLast([Ahead|Atail],ListB,Last) :- Atail==[], ListB=[], Last=Ahead.