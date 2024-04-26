%%% Global values %%%
tab(' '). % default spacer

% "dynamic" means that predicate's definition may change during run time
:- dynamic nocolor/0.

nocolor.

raz('') :- nocolor,!.
raz('\x1B[0m'). %FG

red('') :- nocolor,!.
red('\x1B[31m').

green('') :- nocolor,!.
green('\x1B[36m').

clear('') :- nocolor,!.
clear('\e[1;1H\e[2J').

highLight('') :- nocolor,!.
highLight('\e[1;37m\e[43m'). %GB

%%%% colors/terminal helper %%%%

% Either add colorization or not (Side effect Silent predicate)
colorize(X,X) :- highLight(Color), write(Color), !.
colorize(_,_).
colorize(X,X, Y,Y) :- highLight(Color), write(Color), !.
colorize(_,_,_,_).

raz() :-  raz(Color), write(Color).
clear() :-  clear(Code), write(Code).


%%% print a Cell Helper \w colorization %%%
afficheCellule(Cellule) :-
  Cellule = x , red(Color), write(Color), afficheCellule("x"),!. %"red" cell

afficheCellule(Cellule) :-
  Cellule = o , green(Color), write(Color), afficheCellule("o"),!. %"green" cell

afficheCellule(Cellule) :-
  write(Cellule), raz(), tab(Spaces), write(Spaces). % default cell

%%% Display a entire line (with highlight or not) %%%
afficheLigne(Ligne) :- % no color
  afficheLigne(Ligne, 1, nope, nope),!.

% generic color or not
afficheLigne([], _, _, _).

afficheLigne([Cell | Tail], Index_current, Index_color, Alpha_color) :-
  alphaFromList([Cell|Tail], Alpha_current),
  colorize(Alpha_current, Alpha_color, Index_current, Index_color), afficheCellule(Cell),
  afficheLigne(Tail, Index_current, Index_color, Alpha_color).

      % grilleDeDepart([Ligne1 | _]), afficheLigne(Ligne1). %test Disp

      % grilleDeDepart([Ligne1 | _]), afficheLigne(Ligne1, 2, 2, a). %test Disp highlight line 2 and row a

%%% Display the header line (alphas values)
afficheHeader() :-
  afficheCellule(' '),
  afficheLigne([a,b,c,d,e,f,g,h]).

afficheHeader(Alpha_color) :-
  afficheCellule(' '),
  afficheLigne([a,b,c,d,e,f,g,h], sameLine, sameLine, Alpha_color).

      % afficheHeader(). %test Disp

      % afficheHeader(b). %test Disp highlight alpha b

%%% Display entire Grid %%%
afficheGrille(Grille) :- % no color
  afficheGrille(Grille, nope, nope).

% generic color or not
afficheGrille(Grille, AlphaCurr, NumCurr) :-
  afficheHeader(AlphaCurr), nl, afficheGrilleCB(Grille, AlphaCurr, NumCurr).

afficheGrilleCB([], _, _).
afficheGrilleCB([Line | Tail], Alpha_color, Index_color) :-
  currentIndex([Line |Tail], Index), colorize(Index, Index_color), afficheCellule(Index), % Left Info Index (1..8)
  afficheLigne(Line, Index, Index_color, Alpha_color), nl,
  afficheGrilleCB(Tail, Alpha_color, Index_color), !.

      % grilleDeDepart(Grille), afficheGrille(Grille, b, 1). %test Disp highlight line 2 row b

      % grilleDeDepart(Grille), afficheGrille(Grille). %test Disp


dispEndResult(X, O) :-
  X > O, write('   -- Player x WON --').

dispEndResult(X, O) :-
  X < O, write('   -- Player o WON --').

dispEndResult(X, O) :-
  O == X, write('     -- Draw --').

minutes(Millis, Seconds) :-
  Seconds is truncate((Millis / 1000)  / 60).

      % minutes(62003, M).

second(Millis, Minutes) :-
  Minutes is mod(round((Millis / 1000)), 60).

      % second(62003, S).

% force the end of the game (Players stucks)
endOfGame(Grid, force):-
  countCell(Grid, NbX, NbO, _),
  nl,afficheGrille(Grid),
  red(ColorRed), green(ColorGreen),
  nl,write(ColorRed), write('  Player x -- Score:'), write(NbX),
  nl,write(ColorGreen), write('  Player o -- Score:'), write(NbO),
  raz,
  nl,nl,
  displayRunTime('Execution took: '),
  dispEndResult(NbX, NbO),nl,
  abort.

% display the run time since the start

displayRunTime(Msg) :-
  get_cache(time, time, OldTime),
  statistics(walltime, [_ , TimeSinceLastCall]),
  ExecutionTime is OldTime + TimeSinceLastCall,
  set_cache(time, time, ExecutionTime),
  second(ExecutionTime, Seconds), minutes(ExecutionTime, Minutes),
  write(Msg), write(Minutes), write('min '), write(Seconds), write('s'),

  second(TimeSinceLastCall, SecondsSinceLastCall),
  ( SecondsSinceLastCall > 1
  -> write(' +'), write(SecondsSinceLastCall), write('s'), nl
  ; nl).


displayRunTime(Msg) :-
  statistics(walltime, [_ , ExecutionTime]),
  set_cache(time, time, ExecutionTime),
  second(ExecutionTime, Seconds), minutes(ExecutionTime, Minutes),
  write(Msg), write(Minutes), write('min '), write(Seconds), write('s'), nl,!.


displayHeuristic(Grid, Player) :-
  opposite(Player, Player2),
  dynamic_heuristic_evaluation(Grid, Player, Player2, Heuristic),
  write(' - Heuristic: '), format('~2f', Heuristic),nl.


% if end of game by no more cell Empty
endOfGame(Grid):-
  countCell(Grid, _, _, 0),
  endOfGame(Grid, force).

% always match but do nothing
endOfGame(_).

% simple alert
alert(Text) :-
  red(Color),
  write(Color), write(Text),
  raz().

% vim:set et sw=2 ts=2 ft=prolog:
