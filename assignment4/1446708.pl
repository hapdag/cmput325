:- use_module(library(clpfd)). 
fourSquares(+N, [-S1,-S2,-S3,-S4]):-
	vars = [S1,S2,S3,S4],
	vars ins 0..9.
