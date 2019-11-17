-module(first).
-import(io, [format/1, format/2]).
-export([add/2, hello/0, greet_and_add_two/1, greet/2]).
-export([head/1, second/1, same/2]).
-export([just_do_it/0, create_set/2]).

%can be evoked from commandline as well
-compile([debug_info]).


add(A,B) ->
    A + B.

hello() ->
    % io:format("Hello, World! ~n"). (If import not called)
    format("Hello, World! ~n").

greet_and_add_two(X) ->
    hello(),
    add(X,2).

greet(male, Name) -> format("Hello, Mr. ~s!~n", [Name]);
greet(female, Name) -> format("Hello, Miss ~s!~n", [Name]);
greet(_, Name) -> format("Hello!, ~s!~n", [Name]).

head([H|_]) -> H.

second([_,S|_]) -> S.

same(X, X) -> true;
same(_, _) -> false.

just_do_it() ->
    if 1 =:= 1 ->
        works
    end,
    if 1=:=2; 1=:=1 ->
        works
    end,
    if 1=:=2, 1=:=1 ->
        fails;
        true -> do_this
    end.

create_set(X, []) ->
    [X];
create_set(X, Set) ->
    case lists:member(X, Set) of
        true -> Set;
        false -> [X|Set]
    end.

