% >>>>>QUESTION 1 xreverse (1 mark)
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

% >>>>>QUESTION 2 xunique (2 marks)
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

% STUDENT COMMENTS:
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

% >>>>>QUESTION 3 xdiff (1 mark)
% Define the predicate xdiff(+L1, +L2, -L) where L1 and L2 are given lists of atoms,
% and L contains the elements that are contained in L1 but not L2 (set difference of L1 and L2). 
% Examples: 
% xdiff([a,b,f,c,d],[e,b,a,c],L). should return L=[f,d], 
% xdiff([p,u,e,r,k,l,o,a,g],[n,k,e,a,b,u,t],L). should return L = [p,r,l,o,g], 
% xdiff([],[e,b,a,c],L). should return L = [].
% Your program should generate only one solution, so if the user presses ";" the next answer should be "false".


% STUDENT COMMENTS:
% pretty much reused the code from xunique, found items in List A that are not members of List B, put them in 
% accumulator list and unify to difference variable/list then exit

xdiff(ListA,ListB,Diff):- xdiff(ListA,ListB,Diff,[]).
xdiff([Ahead|Atail],ListB,Diff,AccmL):- notmember(Ahead,ListB), 
	append(AccmL,[Ahead],OutList), xdiff(Atail,ListB,Diff,OutList).
xdiff([Ahead|Atail],ListB,Diff,AccmL):- member(Ahead,ListB),xdiff(Atail,ListB,Diff,AccmL).
xdiff([],_,AccmL,AccmL).

% >>>>>QUESTION 4 removeLast (1 mark)
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

% STUDENT COMMENTS:
% simplest base case handled: if there is only one element in the list passed in the predicate (ignoring possiblity
% of empty list being passed in), the rest of the list would be empty, and the last item would be head of the list
% Otherwise concatenate the list head with the returning list, and recurse.

removeLast([Ahead|Atail],[Ahead|ListB],Last) :- removeLast(Atail,ListB,Last).
removeLast([Ahead|Atail],ListB,Last) :- Atail==[], ListB=[], Last=Ahead.


% the description of question 5 is too long so Im not copying all of it here (lol)

node(a).
node(b).
node(c).
node(d).
node(e).
edge(a,b).
edge(b,c).
edge(c,a).
edge(d,a).
edge(a,e).

clique(L) :- findall(X,node(X),Nodes), xsubset(L,Nodes), allConnected(L).
xsubset([], _).
xsubset([X|Xs],Set):-xappend(_,[X|Set1],Set), xsubset(Xs,Set1).
xappend([], L, L).
xappend([H|T],L,[H|R]):- xappend(T,L,R).

% >>>>>QUESTION 5.1 allConnected (2 marks)
%Use the predicates clique, xsubset and xappend above.
% Your job is to define the predicate allConnected(L) to test if each node in L is connected to each other node in L.
% A node A is connected to another node B if either edge(A,B) or edge(B,A) is true.
% This is a simple (and very slow) "generate and test" approach to solving the clique problem.
% Upon backtracking, the subset predicate in your program will generate all the subsets,
% and each subset will be tested by your allConnected predicate.
% allConnected(L) is true for an empty list, L= []. The recursive case is: 
% allConnected([A|L]) if A is connected to every node in L and allConnected(L).
% Thus, you need to define a predicate, say connect(A,L), to test if A is connected to every node in L.

% STUDENT COMMENTS: 
% Simple recursion check each item in list passed in until empty, where it will return true, otherwise passed into 
% connect predicate to check if item is on an edge with another item (item edge order does not matter), ends when
% all list items exhausted

allConnected([]).
allConnected([Lhead|Ltail]):- connect(Lhead,Ltail), allConnected(Ltail).
connect(A,[Lhead|Ltail]):- edge(A,Lhead);edge(Lhead,A), connect(A,Ltail).
connect(_,[]).

% >>>>>QUESTION 5.2  maxclique (3 marks)
% Write a predicate maxclique(+N, -Cliques) to compute all the maximal cliques of size N that are contained
% in a given graph. N is the given input, Cliques is the output you compute: a list of cliques.
% A clique is maximal if there is no larger clique that contains it. In the example above,
% cliques [a,b,c] and [a,d] are maximal, but [a,b] is not, since it is contained in [a,b,c].
% Examples (using the graph above): 
% maxclique(2,Cliques). returns Cliques = [[a,d],[a,e]] 
% maxclique(3,Cliques). returns Cliques = [[a,b,c]] 
% maxclique(1,Cliques). returns Cliques = [] 
% maxclique(0,Cliques). returns Cliques = []
% Your program should generate only one solution (the list Cliques). If the user presses ";" the next answer should be "false".
% Different sets of facts about node and edge will be provided by us for testing your code. 
% Do not include any facts about node and edge in your program! Keep them in a separate file that 
% you load into Prolog for your testing only, and experiment with different graphs.

maxclique(Len,Cliques):- findall(X, getCliqueSizeN(X,Len), Y), B is Len+1, 
	findall(W, getCliqueSizeN(W,B), Z),returnMax(Y,Z,Cliques).

getCliqueSizeN(X,N):- clique(X),length(X,N).

returnMax(NSize,BSize,Cliques):- returnMax(NSize,BSize,Cliques,[]).

returnMax([NHead|NTail],BSize,Cliques,AccmL):- 
	BSize\==[], 
	( (subsetCheck(NHead,BSize)) -> 
		append(AccmL,[],OutList), 
		returnMax(NTail,BSize,Cliques,OutList)
		; 
		append(AccmL,[NHead],OutList),
		returnMax(NTail,BSize,Cliques,OutList)
		) .


returnMax([],BSize,AccmL,AccmL).

returnMax(NSize,[],NSize,_).

subsetCheck(NClique,[BHead|BTail]):- (
	(subset(NClique,BHead)) -> true ; subsetCheck(NClique,BTail)
	).
subsetCheck(_,[]):- fail.
