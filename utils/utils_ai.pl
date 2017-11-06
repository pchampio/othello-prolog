% depending on the Depth of the search
% set the first min value to +inf
% and the first max value to -inf
init_value_minOrMax(Depth, [-inf, [_,_]]) :-
  even(Depth),!.

init_value_minOrMax(_, [+inf, [_,_]]).


% find the max between the 2 of those data structure
%  [ Value , [Some_data, Some_data2] ], compare on the *Value* field
my_max( [X, [_,_]], [Y,[A,I]], [Z,[A,I]]) :- X =< Y,!, Y = Z.
my_max(X,_,X).

    % my_max([1,[a,b]], [2,[c,d]], R), R = [2, [c, d]]. % test Match

my_min( [X,[_,_]], [Y,[A,I]], [Z,[A,I]]) :- X > Y,!, Y = Z.
my_min(X,_,X).

    % my_min([1,[a,b]], [2,[c,d]], R), R = [1, [a, b]]. % test Match


% check if a number is even or odd
even(0).
even(X) :- X > 0, X1 is X - 1, odd(X1).
even(X) :- X < 0, X1 is X + 1, odd(X1).

odd(1).
odd(X) :- X > 0, X1 is X - 1, even(X1).
odd(X) :- X < 0, X1 is X + 1, even(X1).


% vim:set et sw=2 ts=2 ft=prolog:
