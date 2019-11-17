-module(power).
-export([start/0, power_server/0]).
-import(math,[pow/2]).

-spec start() -> pid().
start() ->
    spawn(fun power_server/0).

-spec power_server() -> none().
power_server() ->
    receive
        { Pid, power, N, M } ->
            Pid!{ answer, pow(N, M) }
        end,
    power_server().
