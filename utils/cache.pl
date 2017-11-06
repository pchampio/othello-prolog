%% module provide some cache function %%

% "dynamic" means that predicate's definition may change during run time
:- dynamic cache/3.

% the key of the cache is less memory dependent
build_key(Any, Key) :-
  variant_hash(Any,Key).

set_cache(DataType, Key, _) :-
  delete_cache(DataType, Key, _),
  fail.

set_cache(DataType, Key,Data) :-
  assert(cache(DataType, Key, Data)).

delete_cache(DataType, Key,_) :-
  retractall(cache(DataType, Key,_)).

clear_cache :-
  retract(cache(_, _,_)).

get_cache(DataType, Key, Data) :-
  cache(DataType, Key, Data).

% vim:set et sw=2 ts=2 ft=prolog:
