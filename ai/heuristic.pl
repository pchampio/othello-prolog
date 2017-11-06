% FROM :
% https://courses.cs.washington.edu/courses/cse573/04au/Project/mini1/RUSSIA/Final_Paper.pdf


% This heuristic function is actually a collection of several heuristics
% and calculates the utility value of a board position by assigning
% different weights to those heuristics. These heuristics take into account:
    % - the mobility,
    % - coin parity,
    % - stability,
    % - corners-captured,
% aspects of a board configuration.

% Each heuristic scales its return value from -100 to 100.
% These values are weighed appropriately to play an optimal game.

% The various heuristics include:

  % !! use of if else to reduce processing (and it's more readable)


  %% 1. Coin Parity %%
  % This component of the utility function captures the difference in coins
  % between the max player and the min player.
  % The return value is determined as follows :

coinParityHeuristic(Grid, MaxPlayer, MinPlayer, Res) :-
  gridToLine(Grid, AsLine),
  nb_elem(AsLine, Nb_MaxCoins, MaxPlayer),
  nb_elem(AsLine, Nb_MinCoins, MinPlayer),
  Res is 100 * (Nb_MaxCoins - Nb_MinCoins) / (Nb_MaxCoins + Nb_MinCoins).


      % grilleDeDepart(Grille), coinParityHeuristic(Grille, x, o, 0). % test Match (start of game == even == 0)


  %% 2. Mobility %%
  % It attempts to capture the relative difference between
  % the number of possible moves for the max and the min players,
  % with the intent of restricting the opponent’s mobility
  % and increasing one’s own mobility.
  % This value is calculated as follows :

mobilityHeuristic(Grid, MaxPlayer, MinPlayer, Res) :-
  allValidMove(MaxPlayer, Grid, MovesMax), length(MovesMax, Nb_MaxMoves),
  allValidMove(MinPlayer, Grid, MovesMin), length(MovesMin, Nb_MinMoves),

  Nb_AllMoves is Nb_MaxMoves + Nb_MinMoves,

                                           % @drakirus tweak:
  ( Nb_MinMoves =:= 0, Nb_AllMoves =\= 1   % check if not end of game and
    /* Then */ ->  Res = 999999            % if you can make the other player skip his turn bonus points

      /* Else */
    ;( Nb_MaxMoves =:= 0, Nb_AllMoves =\= 1
        /* Then */ -> Res = -999999

      /* Else */ ;
      ( /* If */  Nb_AllMoves =:= 0
        /* Then */ ->  Res = 0
        /* Else */ ; Res is 100 * (Nb_MaxMoves - Nb_MinMoves) / (Nb_MaxMoves + Nb_MinMoves)
      )

    )

  ).

      % grilleDeDepart(Grille), mobilityHeuristic(Grille, x, o, 0). % test Match

      % grilleDeDepart([L1|Rest]), Block = ["-", "-", "-", "-", "-", o, o, x],  GrilleBlock= [L1, L1, L1, L1, L1, Block, Block, Block],
      % afficheGrille(GrilleBlock),
      % mobilityHeuristic(GrilleBlock, x, o, X),!. %test Trun Blocked heuristic




  %% 3. Corners Captured %%
  % Corners hold special importance because once captured,
  % they cannot be flanked by the opponent.
  % They also allow a player to build coins around them
  % and provide stability to the player’s coins.
  % This value is captured as follows :

cornersCapturedHeuristic(Grid, MaxPlayer, MinPlayer, Res) :-
  getAllCorners(Grid, AsLine),
  nb_elem(AsLine, Nb_MaxCoins, MaxPlayer),
  nb_elem(AsLine, Nb_MinCoins, MinPlayer),
  Nb_AllCorners is Nb_MaxCoins + Nb_MinCoins,
    ( /* If */  Nb_AllCorners =:= 0
      /* Then */ ->  Res = 0
      /* Else */ ; Res is 100 * (Nb_MaxCoins - Nb_MinCoins) / (Nb_MaxCoins + Nb_MinCoins)
     ).

     % grilleDeDepart(Grille), cornersCapturedHeuristic(Grille, x, o, 0). % test Match




  %% 4. Stability %%
  % The stability measure of a coin is a quantitative representation
  % of how vulnerable it is to being flanked.
  % Coins can be classified as belonging to one of three categories:
  % (i) stable, (ii) semi-stable and (iii) unstable.

  % Stable coins are coins which cannot be flanked at
  % any point of time in the game from the given state.
  % Unstable coins are those that could be flanked in the very next move.
  % Semi-stable coins are those that could potentially be flanked at some point in the future,
  % but they do not face the danger of being flanked immediately in the next move.
  % Corners are always stable in nature, and by building upon corners,
  % more coins become stable in the region.

  % The stability value is calculated as follows :

stability_weights([4,  -3,  2,  2,  2,  2, -3,  4,
                   -3, -4, -1, -1, -1, -1, -4, -3,
                   2,  -1,  1,  0,  0,  1, -1,  2,
                   2,  -1,  0,  1,  1,  0, -1,  2,
                   2,  -1,  0,  1,  1,  0, -1,  2,
                   2,  -1,  1,  0,  0,  1, -1,  2,
                   -3, -4, -1, -1, -1, -1, -4, -3,
                   4,  -3,  2,  2,  2,  2, -3,  4]).

% encapsulate
stabilityHeuristic(Grid, MaxPlayer, MinPlayer, Res) :-
  gridToLine(Grid, AsLine),
  stability_weights(Stability_line),
  stabilityHeuristic_CB(AsLine, Stability_line,
                        MaxPlayer, MinPlayer,
                        Res_PlayerMax, Res_PlayerMin),

  Res is Res_PlayerMax - Res_PlayerMin.

stabilityHeuristic_CB([], [], _, _, 0, 0).

stabilityHeuristic_CB([Head_grid|Tail_grid], [Head_weights|Tail_weights],
                      /* MaxPlayer = */ Head_grid, MinPlayer,
                      Res_PlayerMax, Res_PlayerMin) :-

  stabilityHeuristic_CB(Tail_grid, Tail_weights,
                     Head_grid, MinPlayer,
                     Tmp_ResPlayerMax, Res_PlayerMin),!,

  Res_PlayerMax is Tmp_ResPlayerMax + Head_weights.

stabilityHeuristic_CB([Head_grid|Tail_grid], [Head_weights|Tail_weights],
                      MaxPlayer, /* MinPlayer = */ Head_grid,
                      Res_PlayerMax, Res_PlayerMin) :-

  stabilityHeuristic_CB(Tail_grid, Tail_weights,
                     MaxPlayer, Head_grid,
                     Res_PlayerMax, Tmp_ResPlayerMin),!,

  Res_PlayerMin is Tmp_ResPlayerMin + Head_weights.

stabilityHeuristic_CB([_|TG], [_|TW], MaxPlayer, MinPlayer, ResMax, ResMin) :-
  stabilityHeuristic_CB(TG, TW, MaxPlayer, MinPlayer, ResMax, ResMin).

      % grilleDeDepart(Grid),
      % stabilityHeuristic(Grid, x, o, 0). % test Match



  %% Sum of all previous heuristic with their respective weights %%

dynamic_heuristic_evaluation(Grid, MaxPlayer, MinPlayer, Res) :-
  stabilityHeuristic(Grid, MaxPlayer, MinPlayer, Res_stability),
  coinParityHeuristic(Grid, MaxPlayer, MinPlayer, Res_coinParity),
  cornersCapturedHeuristic(Grid, MaxPlayer, MinPlayer, Res_corners),

  mobilityHeuristic(Grid, MaxPlayer, MinPlayer, Res_mobility),
  Res is 100 * Res_corners + 5 * Res_mobility + 25 * Res_coinParity + 25 * Res_stability.

% Res is 100 * Res_corners + 5 * Res_coinParity + 25 * Res_stability.

      % grilleDeDepart(Grid),
      % dynamic_heuristic_evaluation(Grid, x, o, 0). % test Match

      % use_module(library(statistics)).
      % grilleDeDepart([L1|Rest]), Block = ["-", "-", "-", "-", "-", o, o, x],  GrilleBlock= [L1, L1, L1, L1, L1, Block, Block, Block],
      % profile(dynamic_heuristic_evaluation(GrilleBlock, x, o, R)).

% *optimisation* since the dynamic_heuristic_evaluation is run on every move
% (even if we have already compute the SAME grid before)
% caching the Heuristic of a specific board can improve performance

% get existing key
get_or_compute_heuristic(Grid, MaxPlayer, MinPlayer, Res) :-
  increment_stats_heuristic(Grid),
  build_key([Grid, MaxPlayer, MinPlayer], Key),
  get_cache(heuristic, Key, Res),
  !.

% check if the Heuristic has not been process for the other player
get_or_compute_heuristic(Grid, MaxPlayer, MinPlayer, Res) :-
  build_key([Grid, MinPlayer, MaxPlayer], Key),
  get_cache(heuristic, Key, ResTMP),
  Res is ResTMP * -1,!. % invert the result (since the Heuristic evaluation give the opposite)

% compute Heuristic and store it
get_or_compute_heuristic(Grid, MaxPlayer, MinPlayer, Res) :-
  build_key([Grid, MaxPlayer, MinPlayer], Key),
  dynamic_heuristic_evaluation(Grid, MaxPlayer, MinPlayer, Res),
  set_cache(heuristic, Key, Res).

% vim:set et sw=2 ts=2 ft=prolog:
