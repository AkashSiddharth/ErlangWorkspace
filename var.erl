-module(var).
-export([start/1, val_server/1]).

-spec start(State :: integer()) -> pid().
start(State) ->
    spawn(?MODULE, val_server, [State]).

-spec val_server(State :: integer()) -> no_return().
val_server(State) ->
    receive
        { assign, NewVal } ->
           val_server(NewVal);
        
        { Pid, fetch } ->
            Pid!{ value, State },
            val_server(State)
    end.