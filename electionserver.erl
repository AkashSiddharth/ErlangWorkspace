-module(electionserver).
-export([start/0, init/0, electionserver/1, results/1, vote/2]).


-spec start() -> pid().
start() ->
    spawn(?MODULE, init, []).

-spec init() -> no_return().
init() ->
    Vote_Data = orddict:new(),
    electionserver({start, Vote_Data}).

-spec electionserver({start, Vote_Data :: {atom(), non_neg_integer()}}) -> no_return().
electionserver({start, Vote_Data}) ->
    receive
        {Pid, res} ->
            Pid ! {Vote_Data},
            electionserver({start, Vote_Data});

        {Pid, Name} ->
            Pid ! {done},
            case orddict:take(Name,Vote_Data) of
                error -> New_Data=orddict:store(Name, 1, Vote_Data),
                         electionserver({start, New_Data});
                {Value, Dict} -> New_Data=orddict:store(Name, (Value + 1), Dict),
                                 electionserver({start, New_Data})
      end
  end.



-spec vote(ES::pid(), Candidate::atom()) -> ok.
vote(ES, Candidate) ->
    ES! {self(), Candidate},
    receive
        {done} -> ok
    end.

-spec results(ES::pid()) -> [{atom(), non_neg_integer()}].
results(ES) ->
    ES ! {self(), res},
    receive
        {Vote_Data} -> Vote_Data
    end.

