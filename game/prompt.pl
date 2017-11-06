%%% Let the user choose a cell (interactive) %%%

userInput(Grille, Alpha_in, Index_in, Alpha_out, Index_out, Player) :-
  afficheGrille(Grille, Alpha_in, Index_in),
  nl,write('  -> arrow to select\n     or type a coord (a4)\n  -> enter/space to validate\n'),
  nl, write('Player:'), afficheCellule(Player), raz(),
  get_single_char(EnterOrArrow), % start of arrow keycode (3bytes) OR enterKey
  userImputSuite(Grille, EnterOrArrow, Alpha_in, Index_in, Alpha_select, Index_select, EndCode),
  \+ enterKey(EndCode), % if no enter then keep the cell selection
  userInput(Grille, Alpha_select, Index_select, Alpha_out, Index_out, Player),!.

% when a user Press enter/space Return the Alpha/Index selected
userInput(_, A, N, A, N,_).

% keycode 13 == ENTER
% keycode 32 == SPACE
enterKey(13).
enterKey(32).

% If ENTER or SPACE
userImputSuite(_, Code, _, _, _, _, Code) :-
    enterKey(Code), !.

% Else If q -> quit
userImputSuite(_, 113, _, _, _, _, _) :- nl,nl,write(' Bye Bye!'),nl, abort.

% Else if parse the arrow key code
  % keycode Start input arrow code == 27 (first of 3 char)
  % (the second is escape code trash)
  % (the third is the keycode)
userImputSuite(Grille, 27, Alpha, Index, Alpha_out, Index_out, 27) :-
    get_single_char(_), get_single_char(ArrowCode), clear(),
    nextCell(Grille, ArrowCode, Alpha, Index, Alpha_out, Index_out).

% Else if start of Alpha coord (a..h)
userImputSuite(_, Code, _, Index_in, Alpha_out, Index_in, noMatch) :-
  CodeValue is -(Code,96), between(1, 8, CodeValue), alphaFromIndex(CodeValue, Alpha_out),
  clear(), write('coord'), writeCoord(Alpha_out, Index_in),nl.

% Else if start of Index coord (1..8)
userImputSuite(_, Code, Alpha_in, _, Alpha_in, Index_out, noMatch) :-
  Index_out is -(Code,48), between(1, 8, Index_out), clear(),
  clear(), write('coord'), writeCoord(Alpha_in, Index_out),nl.

% Else Not a valid input.
userImputSuite(_, Code, Alpha, Index, Alpha, Index, Code) :-
  clear(),  write(' Not a valid input (q to quit)'), nl.

% ArrowCode Match %
  % Up Arrow
nextCell(_, 65, Alpha, Index, Alpha, Prev) :- write('Up'), succNum(Prev, Index), writeCoord(Alpha, Prev), nl.
  % Down Arrow
nextCell(_, 66, Alpha, Index, Alpha, Next) :- write('Down'), succNum(Index, Next), writeCoord(Alpha, Next), nl.
  % Left Arrow
nextCell(_, 68, Alpha, Index, Prev, Index) :- write('Left'), succAlpha(Prev, Alpha), writeCoord(Prev, Index), nl.
  % right Arrow
nextCell(_, 67, Alpha, Index, Next, Index) :- write('Right'), succAlpha(Alpha, Next), writeCoord(Next, Index), nl.
  % Error (wrong input or no succNum(), succAlpha() corresponding (End of grid))
nextCell(_, _, Alpha, Index, Alpha, Index) :- write(' -> Error'), nl.

      % grilleDeDepart(Grille), userInput(Grille, b, 3, Alpha, Index,x). %test Disp/Select cell (start at b3)

writeCoord(A, I) :- write(' -> ['), write(A), write(', '), write(I), write(']').

color(1) :- retract(nocolor).
color(2) :- assert(nocolor).

color(_).

option(color) :-
  repeat,
  clear(),
  nl,write(' -- Color --'),nl,nl,
  write('  1. Yes   '),nl,
  write('  2. No  '),nl,
  write('            '),nl,
  write('enter your choice:'),nl,
  read(Choice), number(Choice), between(1,2, Choice), color(Choice).

      % option(color).

type(1, human).
type(2, random).
type(3, minmax).
type(4, alphabeta).

my_retract(X) :- retract(X),!.
my_retract(_).

setPlayerType(Player, Num) :-
  my_retract(playerType(Player, _)),
  type(Num, Type), assert(playerType(Player, Type)).

option(player, Player) :-
  repeat,
  clear(),
  nl, write(' -- Set the Player '), afficheCellule(Player), raz(), write('to be a --'),nl,nl,
  write('  1. Human   '),nl,
  write('  2. Bot (random)  '),nl,
  write('  3. Bot (minmax)  '),nl,
  write('  4. Bot (alphabeta)  '),nl,
  write('            '),nl,
  write('enter your choice:'),nl,
  read(Choice), number(Choice), between(1,4, Choice), setPlayerType(Player, Choice).

      % option(player, x).

% vim:set et sw=2 ts=2 ft=prolog:
