% stats: count the number of call to the heuristic
%        eval function depending on the number of piece on the board

increment_stats_heuristic(Grid) :-
  countCell(Grid, NbX, NbO, _),
  TotalCell is NbX + NbO,
  get_cache(heuristic_stats, TotalCell, Total_heuristic_call),!,
  Add_Total_heuristic_call is Total_heuristic_call + 1,
  set_cache(heuristic_stats, TotalCell, Add_Total_heuristic_call).

increment_stats_heuristic(Grid) :-
  countCell(Grid, NbX, NbO, _),
  TotalCell is NbX + NbO,
  set_cache(heuristic_stats, TotalCell, 1).

get_stats(Res) :-
  bagof(When:Count, cache(heuristic_stats,When,Count), Res), write(Res).

% vim:set et sw=2 ts=2 ft=prolog:
