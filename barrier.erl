-module(barrier).
-export([start/1, init/1, barrier_sync/1]).

-spec start(Running :: integer()) -> pid().
start(Running) ->
    spawn(?MODULE, init, [Running]).

-spec init(Proc_running :: integer()) -> no_return().
init(Proc_running) ->
    Done = [],
    barrier_sync({state, Proc_running, Done}).

-spec barrier_sync({state, Proc_running :: integer(), Done :: list()}) -> no_return().
barrier_sync({state, Proc_running, Done}) ->
    receive
        {Pid, done} ->
            Pid ! {self(), ok},
            if (Proc_running == 1) ->
                send_continue(Done ++ [Pid]),
                barrier_sync({state, (Proc_running - 1), (Done ++ [Pid])});

                true -> barrier_sync({state, (Proc_running - 1), (Done ++ [Pid])})
            end;
        {Pid, how_many_running} ->
            Pid ! {self(), number_running_is, Proc_running},
            barrier_sync({state, Proc_running, Done})
    end.

-spec send_continue(Done :: list()) -> no_return().
send_continue([Proc|[]]) -> Proc! {self(), continue};
send_continue([Proc|Remaining]) -> 
    Proc! {self(), continue},
    send_continue(Remaining).