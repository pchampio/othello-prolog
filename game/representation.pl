%%% Initialization Grid  %%%
grilleDeDepart([
["-", "-", "-", "-", "-", "-", "-", "-"],
["-", "-", "-", "-", "-", "-", "-", "-"],
["-", "-", "-", "-", "-", "-", "-", "-"],
["-", "-", "-", o,   x,   "-", "-", "-"],
["-", "-", "-", x,   o,   "-", "-", "-"],
["-", "-", "-", "-", "-", "-", "-", "-"],
["-", "-", "-", "-", "-", "-", "-", "-"],
["-", "-", "-", "-", "-", "-", "-", "-"]
]).

      % grilleDeDepart(Grille). %test

opposite(o,x).
opposite(x,o).

%%% Next row or Next Col %%%
succAlpha(a,b).
succAlpha(b,c).
succAlpha(c,d).
succAlpha(d,e).
succAlpha(e,f).
succAlpha(f,g).
succAlpha(g,h).

%% allow a simpler recusive case (generic stop / List empty)
succAlphaError(h,i) :-!.
succAlphaError(A,B) :- succAlpha(A,B).

succNum(1,2).
succNum(2,3).
succNum(3,4).
succNum(4,5).
succNum(5,6).
succNum(6,7).
succNum(7,8).

%% allow a simpler recusive case (generic stop / List empty)
succNumError(8,9) :-!.
succNumError(A,B) :- succNum(A,B).

%%%  from a index get a Alpha i.e.(2 ->b) %%%

%%%% Fast
alphaFromIndex(1,a).
alphaFromIndex(2,b).
alphaFromIndex(3,c).
alphaFromIndex(4,d).
alphaFromIndex(5,e).
alphaFromIndex(6,f).
alphaFromIndex(7,g).
alphaFromIndex(8,h).
alphaFromIndex(9,i).

%%% Slow
% alphaFromIndex(NumAsk, Res) :-
  % alphaFromIndex(NumAsk, a, Res).

% alphaFromIndex(1, Alpha, Alpha) :- !.

% alphaFromIndex(Index, Alpha, AlphaRes) :-
  % IndexNext is -(Index, 1), succAlphaError(Alpha, AlphaNext),
  % alphaFromIndex(IndexNext, AlphaNext, AlphaRes), !.

      % alphaFromIndex(3, Res). %test Res = c.

      % alphaFromIndex(8, Res). %test Res = h.

      % alphaFromIndex(Res, f). %test Res = 6.

      % alphaFromIndex(9, Res). %test Res = i. % no fail

%% get the current position given the Tail of the List.
currentIndex(List, Index) :-
  length(List, Len), Index is -(9, Len).

    % currentIndex([a,n,n,n], Res). %test Res = 5 / 'a' fifth position.

alphaFromList(List, Alpha_current) :-
   currentIndex(List, Index), alphaFromIndex(Index, Alpha_current).

      % alphaFromList([n,n,n,n], Res). %test Res = e.

      % alphaFromList([n], Res). %test Res = h.

%%% True if line matche the index of that line %%%
ligneDansGrille(NumLigne, Grille, Ligne):-
	ligneDansGrille(NumLigne, Grille, Ligne, 1).

ligneDansGrille(NumLigne, [Ligne|_], Ligne, NumLigne).

ligneDansGrille(NumLigne, [_|T], Ligne, NumCourant):-
	succNum(NumCourant, NumSuivant),
	ligneDansGrille(NumLigne, T, Ligne, NumSuivant).

      % grilleDeDepart(Grille),
      % ligneDansGrille(4, Grille, ["-", "-", "-", o, x, "-", "-", "-"]). %test Match

      % grilleDeDepart(Grille),
      % ligneDansGrille(8, Grille, ["-", "-", "-", "-", "-", "-", "-", "-"]). %test Match

      % grilleDeDepart(Grille),
      % ligneDansGrille(8, Grille, [o, "-", "-", "-", "-", "-", "-", "-"]). %test not Match

%%% True if Value at a NumCol match %%%
caseDansLigne(AlphaCol, Ligne, Valeur):-
	caseDansLigne(AlphaCol, Ligne, Valeur, a).

caseDansLigne(AlphaCol, [Valeur|_], Valeur, AlphaCol).

caseDansLigne(AlphaCol, [_|T], Valeur, ColCourante):-
	succAlpha(ColCourante, ColSuivante),
	caseDansLigne(AlphaCol, T, Valeur, ColSuivante).

      % grilleDeDepart([_,_,_,Ligne|_]), caseDansLigne(d, Ligne, X), !. %test X == o

      % grilleDeDepart([_,_,_,Ligne|_]), caseDansLigne(a, Ligne, X), !. %test X == -

%%% Get a value from col/row %%%
donneValeurDeCase_SLOW(Grille, NumColonne, NumLigne, Valeur) :-
	ligneDansGrille(NumLigne, Grille, Ligne),
	caseDansLigne(NumColonne, Ligne, Valeur).

% MORE speed
donneValeurDeCase(Grille, Alpha, Index, Valeur) :-
  nth1(Index, Grille, Line),
  alphaFromIndex(Alpha_index, Alpha),
  nth1(Alpha_index, Line, Valeur).

      % grilleDeDepart(Grille), donneValeurDeCase(Grille, d, 4, A). %test A == o

      % grilleDeDepart(Grille), donneValeurDeCase(Grille, e, 4, A). %test A == x

      % grilleDeDepart(Grille), donneValeurDeCase(Grille, e, 1, A). %test A == "-"

      % grilleDeDepart(Grille), donneValeurDeCase(Grille, D, 1, A).

%%% check if case at a coord is empty (== -) %%%
caseVide(Grille, NumColonne, NumLigne):-
  donneValeurDeCase(Grille, NumColonne, NumLigne, Value), Value == "-".

      % grilleDeDepart(Grille), caseVide(Grille, d, 4). %test NoMatch

      % grilleDeDepart(Grille), caseVide(Grille, b, 4). %test Match

% encapsulate
gridToLine(Grid, Res) :-
  gridToLine(Grid, [], Res).

% from a list of list get one list
gridToLine([], Res, Res).
gridToLine([Line|Grid], Line_tmp, Line_out) :-
  append(Line, Line_tmp, New_line),
  gridToLine(Grid, New_line, Line_out).

      % grilleDeDepart(Grille), gridToLine(Grille, [], R). %test

% from a grid get a List a the 4 corners
getAllCorners(Grid, [A,B,C,D]) :-
  donneValeurDeCase(Grid, a, 1, A),
  donneValeurDeCase(Grid, a, 8, B),
  donneValeurDeCase(Grid, h, 1, C),
  donneValeurDeCase(Grid, h, 8, D).

% count the numbers of 'x'/'o'/'-' in a Grid
countCell([], 0, 0, 0).

countCell([Line|Tail], PlayerX, PlayerO, Empty) :-
  nb_elem(Line, Nb_PlayerX, x),
  nb_elem(Line, Nb_PlayerO, o),
  nb_elem(Line, Nb_Empty, "-"),
  countCell(Tail, Nb_PlayerX_Old, Nb_PlayerO_Old, Nb_Empty_old),!,
  PlayerX is Nb_PlayerX_Old + Nb_PlayerX,
  PlayerO is Nb_PlayerO_Old + Nb_PlayerO,
  Empty is Nb_Empty_old + Nb_Empty.

      % grilleDeDepart(Grid), countCell(Grid, NbX, NbO, NbEmpty), NbX = 2, Nbo = 2, NbEmpty = 60. %test Match

      % countCell([], 0, 0, 0). %test Match



% vim:set et sw=2 ts=2 ft=prolog:
