-module(concat).
-export([concat/1]).

-spec concat(Lists :: [[T]]) -> [T].

-compile([debug_info]).

concat([]) -> [];

concat([Head|Tail]) -> Head ++ concat(Tail).