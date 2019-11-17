-module(noter).
-export([start/0, init/0, log_server/1]).

-spec start() -> pid().
start() ->
    spawn(?MODULE, init, []).

-spec init() -> no_return().
init() ->
    log_server({state, []}).

-spec log_server({state, Logs :: list()}) -> no_return().
log_server({state, Logs}) ->
    receive
        {Pid, log, Entry} ->
            Pid!{ self(), logged },
            log_server({state, Logs ++ [Entry]});
        {Pid, fetch} ->
            Pid!{ self(), log_is, Logs},
            log_server({state, Logs})
    end.