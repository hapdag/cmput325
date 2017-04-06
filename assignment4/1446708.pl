:- use_module(library(clpfd)). 
fourSquares(N, [S1,S2,S3,S4]):-
	Vars = [S1,S2,S3,S4],
	Vars ins 0..9,
	all_different(Vars),
	N #= -S1 * -S1.

	%-S1 #=< -S2 #=< -S3 #=< -S4.