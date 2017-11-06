inputPickRandomCoord(Grid, Alpha, Index, Player) :-
  allValidMove(Player, Grid, Moves), random_member([Alpha, Index], Moves).

% vim:set et sw=2 ts=2 ft=prolog:
