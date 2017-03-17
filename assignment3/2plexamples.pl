
/*1. xreverse
Define the predicate xreverse(L, R) to reverse a list, where L is a given list and R is either a variable or another given list.

Examples: 
xreverse([7,3,4],[4,3,7]) should return yes, 
xreverse([7,3,4],[4,3,5]) should return no, 
xreverse([7,3,4], R) should return R = [4,3,7].
*/

% check if R is the reverse list of L
% if true, return true.
% else return false.
% if given L and ungiven R, return R which is the reverse list of L.
xreverse([],[]).
xreverse([A|L], R) :- xreverse(L, N), append(N, [A], R).



/*
2. xunique
Define the predicate xunique(L, Lu) where L is a given list of atoms and Lu is a copy of L where aL1 the duplicates have been removed. Lu can be either a variable, or a given list. The elements of Lu should be in the order in which they first appear in L.

Examples: 
xunique([a,c,a,d], L) should return L = [a,c,d], 
xunique([a,c,a,d], [a,c,d]) should return yes, 
xunique([a,c,a,d], [c,a,d]) should return no (because of wrong order), 
xunique([a,a,a,a,a,b,b,b,b,b,c,c,c,c,b,a], L) should return L = [a,b,c], 
xunique([], L) should return L = [].
*/

% check if Lu is the unique list of L
% if true, return true.
% else return false.
% if the order is wrong, return false.
% if given a list and ungiven L, return L which is the unique list of the given list.

xunique(L,Lu) :- xunique(L,[],Lu).
xunique([L1|L2], Lu, A) :- notMember(L1, Lu), append(Lu, [L1], R), xunique(L2, R, A).
xunique([L1|L2], Lu, A) :- member(L1, Lu), xunique(L2, Lu, A).
xunique([],A,A).

% if A is not an atom of F, return true
% false otherwise
notMember(_, []).
notMember(A, [F|R]) :- A \== F, notMember(A, R).



/*
3. xunion
Define the predicate xunion(L1, L2, L) where L1 and L2 are given lists of atoms, and L contains the unique elements that are contained in both L1 and L2. L should contain the unique elements of L1 (in the same order as in L1) foL1owed by the unique elements of L2 that are not contained in L1 (in the same order as in L2). There should be no redundancy in L. The predicate should work both if L is a variable and if L is a given list. 
Hint: you can use xunique.

Examples: 
xunion([a,c,a,d], [b,a,c], L) should return L = [a,c,d,b], 
xunion([a,c,d], [b,a,c], [a,c,d,b]) should return yes, 
xunion([a,c,d], [b,a,c], [a,c,d,b,a]) should return no.
*/

% append two lists together
% then get rid of duplicates
xunion(L1, L2, L) :- append(L1, L2, X), xunique(X, L).




/*
4. removeLast
Define the predicate removeLast(L, L1, Last) where L is a given nonempty list, L1 is the result of removing the last element from L, and Last is that last element. L1 and Last can be either variables, or given values.

Examples: 
removeLast([a,c,a,d], L1, Last) should return L1 = [a,c,a], Last = d, 
removeLast([a,c,a,d], L1, d) should return L1 = [a,c,a], 
removeLast([a,c,a,d], L1, [d]) should return no (why?), 
removeLast([a], L1, Last) should return L1 = [], Last = a, 
removeLast([[a,b,c]], L1, Last) should return L1 = [], Last = [a,b,c].
*/

% remove the last element in the list
% return the rest list and the removed item
removeLast([F|L], L, F) :- L = [].
removeLast([F|L], [F|L1], Last) :- removeLast(L, L1, Last).




/*
5 clique
*/


% given code in the assignment page
clique(L) :- findall(X,node(X),Nodes),
             subset(L,Nodes), allConnected(L).

subset([], _).
subset([X|Xs], Set) :-
  append(_, [X|Set1], Set),
  subset(Xs, Set1).

append([], L, L).
append([H|T], L, [H|R]) :-
  append(T, L, R).

/*
% create the graph
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
*/


/*
5.1 allConnected
Use the predicates clique, subset and append above. Your job is to define the predicate aL1Connected(L) to test if each node in L is connected to each other node in L. A node A is connected to another node B if either edge(A,B) or edge(B,A) is true.
*/

allConnected([A|L]) :- connect(A,L), allConnected(L).
allConnected([]).

% connected to every node
connect(_,[]).
connect(A,[L1|L2]) :- edge(A,L1), connect(A,L2).
connect(A,[L1|L2]) :- edge(L1,A), connect(A,L2).



/*
5.2 
Write a predicate maxclique(N, Cliques) to compute all the maximal cliques of size N that are contained in a given graph. N is the given input, Cliques is the output you compute: a list of cliques. A clique is maximal if there is no larger clique that contains it. In the example above, cliques [a,b,c] and [a,d] are maximal, but [a,b] is not, since it is contained in [a,b,c].

Examples (using the graph above): 
maxclique(2,Cliques) returns Cliques = [[a,d],[a,e]] 
maxclique(3,Cliques) returns Cliques = [[a,b,c]] 
maxclique(1,Cliques) returns Cliques = [] 
maxclique(0,Cliques) returns Cliques = []
*/

% find max cliques which size is N
% then add 1 to N
% compare clique size of N and size of N+1
% ignore size of N which are not max
maxclique(N, Cliques) :- findall(X, clique(X), T), getSize(N, T, S), N1 is N+1, getSize(N1, T, L), findMax(S, L, Cliques).

% get the size of cliques for each node
% if the length is N
% append into the list
getSize(N, R, Cliques) :- getSize(N, R, [], Cliques).
getSize(N, [Rl|Rr], L, A) :- length(Rl, X), X == N, append(L, [Rl], B), getSize(N, Rr, B, A).
getSize(N, [Rl|Rr], L, A) :- length(Rl, X), X \== N, getSize(N, Rr, L, A).
getSize(_, [], A, A).

% find the max cliques of size in S
findMax(S, L, X) :- findMax(S, L, [], X).
findMax([S1|S2], L, T, X) :- length(L, Y), checkMax(S1, L, 0, Y), append(T, [S1], A), findMax(S2, L, A, X).
findMax([S1|S2], L, T, X) :- notMax(S1, L), findMax(S2, L, T, X).
findMax([], _, X, X).

% not the max cliques of size
% return true if S is a subset of L1
% return false if S is not a subset of S1
notMax(S, [L1|_]) :- subset(S, L1).
notMax(S, [L1|L2]) :- notSubset(S, L1), notMax(S, L2).

% check the max cliques of size
checkMax(_, [], Y, Y).
checkMax(S, [L1|L2], X, Y) :- subset(S, L1), checkMax(S, L2, X, Y).
checkMax(S, [L1|L2], X, Y) :- notSubset(S, L1), X1 is X+1, checkMax(S, L2, X1, Y).

% not the subset
% returns true if S1 is not a subset of S2
% return false if S1 is a subset of S2
notSubset([S1|_], L) :- notMember(S1, L).
notSubset([S1|S2], L) :- member(S1, L), notSubset(S2, L).


