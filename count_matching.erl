-module(count_matching).
-export([count_matching/2]).


-spec count_matching(Pred :: fun((T) -> boolean()), Lst :: list(T)) -> non_neg_integer().

count_matching(Pred, List) ->
    counter(Pred, List, 0).

-spec counter(Pred :: fun((T) -> boolean()), Lst :: list(T), Acc :: non_neg_integer()) -> non_neg_integer().

counter(_, [], Acc) ->
    Acc;

counter(Pred, [Head|Tail], Acc) ->
    case Pred(Head) of
        true -> counter(Pred, Tail, (Acc+1));
        false -> counter(Pred, Tail, Acc)
    end.
