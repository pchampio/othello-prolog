%%% direction coord relative from a cell num/alpha %%%
direction(haut, Index, Alpha, Index_out, Alpha) :- succNum(Index_out, Index).
direction(bas,  Index, Alpha, Index_out, Alpha) :- succNum(Index,    Index_out).

direction(gauche,     Index, Alpha, Index,     Alpha_out) :- succAlpha(Alpha_out, Alpha).
direction(droit,      Index, Alpha, Index,     Alpha_out) :- succAlpha(Alpha,     Alpha_out).

direction(hautGauche, Index, Alpha, Index_out, Alpha_out) :- succNum(Index_out,   Index),     succAlpha(Alpha_out, Alpha).
direction(hautDroit,  Index, Alpha, Index_out, Alpha_out) :- succNum(Index_out,   Index),     succAlpha(Alpha,     Alpha_out).
direction(basGauche,  Index, Alpha, Index_out, Alpha_out) :- succNum(Index,       Index_out), succAlpha(Alpha_out, Alpha).
direction(basDroit,   Index, Alpha, Index_out, Alpha_out) :- succNum(Index,       Index_out), succAlpha( Alpha,    Alpha_out).

%% create result if no more cell in same direction %%
donneListeCasesDansDirection(Dir,_, Index, Alpha, []) :-
  \+ direction(Dir, Index, Alpha , _, _).

donneListeCasesDansDirection(Dir, Grid, Index, Alpha, [Value|Res]) :-
  direction(Dir, Index, Alpha , Index_next, Alpha_next),
  donneValeurDeCase(Grid, Alpha_next, Index_next, Value),
  donneListeCasesDansDirection(Dir, Grid, Index_next, Alpha_next, Res).

      % grilleDeDepart(Grid), donneListeCasesDansDirection(bas, Grid, 8, a, []). %test Match

      % grilleDeDepart(Grid), donneListeCasesDansDirection(basDroit, Grid, 5, a, ["-", "-", "-"]). %test Match

      % grilleDeDepart(Grid), donneListeCasesDansDirection(gauche, Grid, I, A, List). %test Match

      % grilleDeDepart(Grid), donneListeCasesDansDirection(droit, Grid, I, A, List). %test Match

      % grilleDeDepart(Grid), donneListeCasesDansDirection(bas, Grid, I, A, List). %test Match



%% faitPrise :- if Player can flip cells of Enemy that are "landlocked" %%
faitPrise(Player, [_ | ListeCases]) :-
  faitPrise(Player, ListeCases).

faitPrise(Player, [Player,Player2 | ListeCases]) :-
  opposite(Player, Player2),
  faitPriseCB(Player, [Player2|ListeCases]).

faitPriseCB(Player, [Player2,Player | _]) :-
  % write('found ->'),write(Player2), write(Player),
  opposite(Player, Player2).

faitPriseCB(Player, [Player2 | ListeCases]) :-
  % write('->'), write(Player2),write(ListeCases),nl,
  opposite(Player, Player2),
  faitPriseCB(Player, ListeCases).

      % faitPrise(x, [-, x, -, -, x, -, -, -]). %test no Match

      % faitPrise(x, [o, x, -, -, x, o, -, -]). %test no Match

      % faitPrise(o, [-, -, -, -, x, o, -, -]). %test no Match

      % faitPrise(o, [-, x, -, o, x, o, -, -]). %test Match

      % faitPrise(o, [-, x, -, o, x, x, o, -]). %test Match

      % faitPrise(o, [o, x, x, x, x, x, x, o]). %test Match

      % faitPrise(o, [o, o, x, x, x, x, x, o]). %test Match


%% can('t) place a point at a coord ? %%
leCoupEstValide(Grid, Camp, Index, Alpha, Dir) :-
  caseVide(Grid, Alpha, Index), opposite(Camp, Adverse),
  donneListeCasesDansDirection(Dir, Grid, Index, Alpha, [Adverse|ListeCases]), % check if a adverse is adjacent here(faster)
  % nl,write([Adverse|ListeCases]), write(Dir),
  faitPrise(Camp, [Camp,Adverse|ListeCases]).


      % grilleDeDepart(Grid), leCoupEstValide(Grid, x, 4, d, Dir). %test 4 d == o fail

      % grilleDeDepart(Grid), leCoupEstValide(Grid, x, 3, f, Dir). %test diagonal after init -> fail

      % grilleDeDepart(Grid), leCoupEstValide(Grid, x, 3, d, Dir), Dir = bas. %test Match

      % grilleDeDepart(Grid), leCoupEstValide(Grid, x, 4, c, Dir), Dir = droit. %test Match

      % grilleDeDepart(Grid), leCoupEstValide(Grid, x, 5, f, Dir), Dir = gauche. %test Match

      % grilleDeDepart(Grid), leCoupEstValide(Grid, x, 6, e, Dir), Dir = haut. %test Match


% same as above but pass the ListeCases as param
% (faster if already compute earlier (validMove case))
leCoupEstValide(Grid, Camp, Index, Alpha, _, [Adverse|ListeCases]) :-
  caseVide(Grid, Alpha, Index), opposite(Camp, Adverse),
  faitPrise(Camp, [Camp,Adverse|ListeCases]).


%% Edit a line (replace value at Alpha) %%
% encapsulate first
editLine(Value, Line, Alpha, Line_out) :- editLine(Value, Line, a, Alpha, Line_out).

%% create result if Alpha has no successor
%(succAlphaError -> (this way h has a successor, but not i))
editLine(_, [], Alpha, _, []) :- \+ succAlphaError(Alpha, _).

editLine(Value, [_|Tail], Alpha, Alpha, [Value | Line_out]) :- % Alpha == Column found
  succAlphaError(Alpha, NumLigneNext),
  editLine(Value, Tail, NumLigneNext, Alpha, Line_out),!.% cut needed to cancel next predicate

editLine(Value, [Head|Tail], Alpha_current, Index, [Head|Line_out]) :- % create same line
  succAlphaError(Alpha_current, Alpha_next),
  editLine(Value, Tail, Alpha_next, Index, Line_out).

      % grilleDeDepart([InLLine|_]),
      % editLine(x, InLLine, d, ["-", "-", "-", x, "-", "-", "-", "-"]). %test Match


      % grilleDeDepart([InLLine|_]),
      % editLine(x, InLLine, h, ["-", "-", "-", "-", "-", "-", "-", x]). %test Match

      % grilleDeDepart([InLLine|_]),
      % editLine(x, InLLine, a, [x, "-", "-", "-", "-", "-", "-", "-"]). %test Match


%% Edit a Grid (repace value at Index/Alpha) %%
% encapsulate first
editGrid(Value, Grid_in, Index, Alpha, Grid_out) :-
  editGrid(Value, Grid_in, 1, Index, Alpha, Grid_out),!.

%% create result if Index has no successor
%(succNumError -> (this way 8 has a successor, but not 9))
editGrid(_, _, Index_current, _, _, []) :- \+ succNumError(Index_current, _).

editGrid(Value, Grid_in, Index, Index, Alpha, [Line_out | Grid_out]) :- % Index == line found
  ligneDansGrille(Index, Grid_in, Line),
  editLine(Value, Line, Alpha, Line_out),
  succNumError(Index, Index_next),
  editGrid(Value, Grid_in, Index_next, Index, Alpha, Grid_out),!. % cut needed to cancel next predicate

editGrid(Value, Grid_in, Index_current, Index, Alpha, [Line | Grid_out]) :- % loop through the grid and create new one
  ligneDansGrille(Index_current, Grid_in, Line),
  succNumError(Index_current, Index_next),
  editGrid(Value, Grid_in, Index_next, Index, Alpha, Grid_out).

      % grilleDeDepart(Grid), editGrid(x, Grid, 1, f, GridEnd), afficheGrille(GridEnd). %test Disp

      % grilleDeDepart(Grid), editGrid(x, Grid, 8, a, GridEnd), afficheGrille(GridEnd). %test Disp

      % grilleDeDepart(Grid), editGrid(x, Grid, 3, h, GridEnd), afficheGrille(GridEnd). %test Disp

      % grilleDeDepart(Grid), editGrid(x, Grid, 8, h, GridEnd), afficheGrille(GridEnd). %test Disp


%% Flip cell in a Dir (except the current Index/Alpha) %%
% encapsulate
flipCells(Dir, Grid, Player, Index, Alpha, Grid_out) :-
  direction(Dir, Index, Alpha, Index_next, Alpha_next), % get next for a direction
  flipCellsCB(Dir, Grid, Player, Index_next, Alpha_next, Grid_out),!. % rotate all the other

% Stop when found a Player cell
flipCellsCB(_, Grid, Player, Index, Alpha, Grid) :-
  donneValeurDeCase(Grid, Alpha, Index, Player).

% Stop when found a Empty cell
flipCellsCB(_, Grid, _, Index, Alpha, Grid) :-
  donneValeurDeCase(Grid, Alpha, Index, "-").

% Replace cell at Index/Alpha and go replace the next one in the same Dir
flipCellsCB(Dir, Grid, Player, Index, Alpha, Grid_out) :-
  editGrid(Player, Grid, Index, Alpha, Grid_tmp),
  direction(Dir, Index, Alpha, Index_next, Alpha_next),
  flipCellsCB(Dir, Grid_tmp, Player, Index_next, Alpha_next, Grid_out).

      % grilleDeDepart(Grid), flipCells(bas, Grid, x, 3, d, GridEnd),  afficheGrille(GridEnd). %test Disp x in [d, 4]



% If the Coup is valid in a Dir then flip the cell in the same Dir %%
runCoup(GrilleDep, Camp, Index, Alpha, GrilleArr, Dir) :-
  leCoupEstValide(GrilleDep, Camp, Index, Alpha, Dir), flipCells(Dir, GrilleDep, Camp, Index, Alpha, GrilleArr),!.

% if the Coup is not valid return the SAME Grid!
runCoup(Grid, _, _, _, Grid, _).


%% new grid after a player played a valid Coup / or return the same Grid! %%
coupJoueDansGrille(Grille_in, Camp, Index, Alpha, Grille_out) :-
  runCoup(Grille_in,  Camp, Index, Alpha, GrilleArr1, bas),
  runCoup(GrilleArr1, Camp, Index, Alpha, GrilleArr2, haut),
  runCoup(GrilleArr2, Camp, Index, Alpha, GrilleArr3, gauche),
  runCoup(GrilleArr3, Camp, Index, Alpha, GrilleArr4, droit),
  runCoup(GrilleArr4, Camp, Index, Alpha, GrilleArr5, hautDroit),
  runCoup(GrilleArr5, Camp, Index, Alpha, GrilleArr6, hautGauche),
  runCoup(GrilleArr6, Camp, Index, Alpha, GrilleArr7, basDroit),
  runCoup(GrilleArr7, Camp, Index, Alpha, Grille_out, basGauche).

      % grilleDeDepart(Grid),
      % coupJoueDansGrille(Grid, x, 3, d, GridEnd),
      % afficheGrille(GridEnd), Grid \= GridEnd. %test match Grid \= GridEnd

      % grilleDeDepart(Grid),
      % coupJoueDansGrille(Grid, x, 4, d, GridEnd),
      % afficheGrille(Grid). %test match Grid = Grid


%% found a valid Match Coup in coordinate(s)
validMove(Player, Grid, [A,I]):-
  donneListeCasesDansDirection(D, Grid, I, A, ListeCases),
  leCoupEstValide(Grid, Player, I, A, D, ListeCases). % pass the previous ListeCases
                                                      % (one 'donneListeCasesDansDirection' call)

      % grilleDeDepart(Grid), validMove(x, Grid, [e,6]). % test Match

      % grilleDeDepart(Grid), validMove(x, Grid, [d,3]). % test Match

      % grilleDeDepart(Grid), validMove(x, Grid, [f,5]). % test Match

      % grilleDeDepart(Grid), validMove(x, Grid, [c,4]). % test Match

      % grilleDeDepart(Grid), validMove(x, Grid, [A,L]). % test Match get all the 4 above

      % grilleDeDepart(Grid), validMove(x, Grid, [d,4]). % test No Match


%% return all the valid Moves for a player
allValidMove(Player, Grid, Moves) :-
  bagof(D, validMove(Player,Grid, D),Moves), !. % the global case if true

allValidMove(_, _, []). % if no validMove == empty list

      % grilleDeDepart(Grid), allValidMove(x, Grid, Moves), Moves = [[e, 6], [d, 3], [f, 5], [c, 4]]. % test Match


%% Check if a Player is stuck or not %%
% (if no valid Moves is possible (have to let the other player play twice))
canMakeAMove(Grid, Player) :-
  validMove(Player, Grid, [_,_]),!. % cut when find one validMove stop backtraking

      % grilleDeDepart(Grid), canMakeAMove(Grid, x). % test Match


%% create a possible grid after a player played %%
nextGrid(Grid, Player, [Grid_out, [Alpha, Index]]) :-
  validMove(Player, Grid, [Alpha,Index]),
  coupJoueDansGrille(Grid, Player, Index, Alpha, Grid_move),
  editGrid(Player, Grid_move, Index, Alpha, Grid_out).

      % grilleDeDepart(Grid), nextGrid(Grid, x, [Grid_out, [A, I]]), afficheGrille(Grid_out). % test Match


allnextGrid(Grid, Player, Grids) :-
  bagof(Coords, nextGrid(Grid, Player, Coords),Grids),!. % the global case if true

allnextGrid(_, _, []). % if no validMove == empty list

      % grilleDeDepart(Grid), allnextGrid(Grid, x, [[First,[A,I]]|Grids_out]), afficheGrille(First). % test Match

      % use_module(library(statistics)).
      % grilleDeDepart(Grid), profile(allnextGrid(Grid, x, [[First,[A,I]]|Grids_out])), afficheGrille(First). % test Match


% since every move - 2, has been compute on the last minmax/alphabeta tree,
% caching the building of valid move can lead to major speed improvement
get_or_compute_allnextGrid(Grid, Player, Grids) :-
  build_key([Grid, Player], Key),
  get_cache(allnextGrid, Key, Grids),
  !.

get_or_compute_allnextGrid(Grid, Player, Grids) :-
  build_key([Grid, Player], Key),
  allnextGrid(Grid, Player, Grids)
  % .
  ,set_cache(allnextGrid, Key, Grids).


%% create a possible grid after a player played (store custom data in second elm of list) %%
allnextGrid_data(Grid, Player, Grid_result, Coords) :-
  get_or_compute_allnextGrid(Grid, Player, Grid_out), % use the caching defined above
  replace_second_elem(Coords, Grid_out, Grid_result).


      % grilleDeDepart(Grid), allnextGrid_data(Grid, x, [[First,[A,I]]|Grids_out], [a,1]), afficheGrille(First). % test Match

      % grilleDeDepart([L1|Rest]), Block = ["-", "-", "-", "-", "-", o, o, x],  GrilleBlock= [L1, L1, L1, L1, L1, Block, Block, Block],
      % allnextGrid_data(GrilleBlock, x, R,  [a,a]), length(R, Len).


% vim:set et sw=2 ts=2 ft=prolog:
