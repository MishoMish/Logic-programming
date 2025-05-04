% Define the operations.
operation(1, A, B, C):- C is A + B.
operation(2, A, B, C):- C is A * B.
operation(3, A, B, C):- B =\= 0, C is A mod B. % prevent division by zero
operation(4, A, B, C):- C is A - B.

% Entry point: check if there exists a path in graph X that evaluates to K.
p(K, X) :- 
    member([Start, Next, Op], X),
    operation(Op, Start, Next, Accum),
    pathK(X, Next, Accum, K, [Start, Next]).

% Base case: reached target K.
pathK(_, _, K, K, _).

% Recursive case: follow another edge.
pathK(X, CurrentNode, Accum, K, Visited) :- 
    member([CurrentNode, NextNode, Op], X),
    \+ member(NextNode, Visited), % prevent cycles
    operation(Op, Accum, NextNode, NewAccum),
    pathK(X, NextNode, NewAccum, K, [NextNode | Visited]).

:-use_module(library(clpfd)).
ro([], [], S):- S #= 0.
ro([AI|AR], [BI|BR], S):- 
	ro(AR, BR, SR), 
	S #= SR + abs(AI - BI).

d(D, K, V):- 
	member(X, D), length(X, N), !, 
	length(V, N), 
	V ins 0..1,
	label(V),
	findall(X, (member(X, D), ro(V, X, S), S mod 2 #= 0, label([S])), L), 
	length(L, K1), 
	K1 #< K.
