:- use_module(library(clpfd)). 

fourSquares(N, [S1,S2,S3,S4]):-
	N #> 0,
	Vars = [S1,S2,S3,S4],
	Vars ins 0..N,
	N #= S1*S1 + S2*S2 + S3*S3 + S4*S4,	
	S1 #=< S2, S2 #=< S3, S3 #=< S4,
	label(Vars).

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

