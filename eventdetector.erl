-module(eventdetector).
-export([start/2, init/2, event_detector/1]).

-spec start(InitialState :: S, TransitionFun :: fun((S,atom()) -> {S,atom()})) -> pid().
start(InitialState, TransitionFun) ->
    spawn(?MODULE, init, [InitialState, TransitionFun]).

-spec init(InitialState :: S, TransitionFun :: fun((S,atom()) -> {S,atom()})) -> no_return().
init(InitialState, TransitionFun) ->
    Observers = [],
    event_detector({start, InitialState, TransitionFun, Observers}).

-spec event_detector({start, InitialState :: S, TransitionFun :: fun((S,atom()) -> {S,atom()}), Observers :: list()}) -> no_return().
event_detector({start, InitialState, TransitionFun, Observers}) ->
    receive
        {Pid, add_me} ->
            Pid! {added},
            event_detector({start, InitialState, TransitionFun, (Observers ++ [Pid])});

        {Pid, add_yourself_to, EDPid} ->
            EDPid! {self(), add_me},
            receive
                {added} ->
                    Pid! {added}
            end,
            event_detector({start, InitialState, TransitionFun, Observers});
        {Pid, state_value} ->
            Pid! {value_is, InitialState},
            event_detector({start, InitialState, TransitionFun, Observers});
        Atom -> 
            {NewState, Event} = TransitionFun(InitialState, Atom),
            case Event of
                none -> do_nothing;
                _ -> send_event_all(Observers, Event)
            end,
            event_detector({start, NewState, TransitionFun, Observers})
    end.

-spec send_event_all(Observers :: list(), Event :: atom()) -> no_return().
send_event_all([Last|[]], Event) -> Last! Event;
send_event_all([Last|Rest], Event) -> 
    Last! Event,
    send_event_all(Rest, Event).