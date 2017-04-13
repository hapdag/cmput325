:- use_module(library(clpfd)). 


% QUESTION 1, Four squares
% Solution was pretty simple, made sure the sum of squares is a positive integer, make the list of variables
% and set them to the appropriate domain, (lowest being 0, highest being N itself though not likely), 
% setup the comparison/constrains for the expressions, and label the variables at the end

fourSquares(N, [S1,S2,S3,S4]):-
	N #> 0,
	Vars = [S1,S2,S3,S4],
	Vars ins 0..N,
	N #= S1*S1 + S2*S2 + S3*S3 + S4*S4,	
	S1 #=< S2, S2 #=< S3, S3 #=< S4,
	label(Vars).


% QUESTION 2, Disarm
% This one is a little more tricky, I did not use anything from the CLPFD library to solve this question (at least 
% I think), so pure prolog. 
% First I passed disarm into itself with an accumulator,then break the number lists into subsets of length 2,
% then the sum of the subset is compared against every member of the other list, append the subset with the matching
% sum, and recurse.

disarm(Adiv,Bdiv,Solution):- disarm(Adiv,Bdiv,Solution,[]).

disarm(Adiv,Bdiv,Solution,Accml):-
	splitSet(Adiv,_,SubList),
	length(SubList,2),
	select(B,Bdiv,NBdiv),
	sumlist(SubList,B),
	select(S1,SubList,SSub),select(S2,SSub,_),
	select(S1,Adiv,NAdiv),select(S2,NAdiv,NNAdiv),
	append(Accml,[[[S1,S2],[B]]],Out),
	disarm(NNAdiv,NBdiv,Solution,Out).

disarm(Adiv,Bdiv,Solution,Accml):-
	splitSet(Bdiv,_,SubList),
	length(SubList,2),
	select(A,Adiv,NAdiv),
	sumlist(SubList,A),
	select(S1,SubList,SSub),select(S2,SSub,_),
	select(S1,Bdiv,NBdiv),select(S2,NBdiv,NNBdiv),
	append(Accml,[[[S1,S2],[A]]],Out),
	disarm(NNBdiv,NAdiv,Solution,Out).

disarm([],[],Accml,Accml).

splitSet([],[],[]).
splitSet([H|T],[H|L],R):- splitSet(T,L,R).
splitSet([H|T],L,[H|R]):- splitSet(T,L,R).

