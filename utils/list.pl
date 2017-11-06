
replace_second_elem(_,[],[]) :- !.
replace_second_elem(NewSecond, [[First, _Second]|Tail], [[First, NewSecond]|List]) :-
  replace_second_elem(NewSecond, Tail, List).

      % A = [[test, replace],[test, replace],[test, replace],[test, replace]],
      % replace_second_elem(new, A, NewA).

%% Count nb elem of Elm in Liste L
nb_elem([], X, X, _).
nb_elem([Elm|T], K, R, Elm) :-
  K1 is +(K,1),
  nb_elem(T,K1,R,Elm).

nb_elem([CmpNot|T], K, R, Elm) :-
  CmpNot \= Elm,
  nb_elem(T,K,R,Elm).

nb_elem(L, R, Elm):- nb_elem(L, 0 ,R, Elm).

    % nb_elem([-, x, -, -, x, -, -, -], 2, x),!. %test match

% vim:set et sw=2 ts=2 ft=prolog:
