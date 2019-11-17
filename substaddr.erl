-module(substaddr).
-include("salesdata.hrl").
-import(salesdata, [store/2, group/2]).

-export([substaddr/3]).

-spec substaddr(SD :: salesdata:salesdata(), New :: string(), Old :: string()) -> salesdata:salesdata().

substaddr(#store{address = Addr, amounts = Amt}, New, Old) ->
    if Old =:= Addr -> #store{address = New, amounts = Amt};
        true -> #store{address = Addr, amounts = Amt}
    end;

substaddr(#group{gname = GName, members = Members}, New, Old) ->
    #group{gname = GName, members = subordiate(Members, New, Old)}.


-spec subordiate(Members :: [salesdata:salesdata()], New :: string(), Old :: string()) -> [salesdata:salesdata()].

subordiate(Members, New, Old) -> lists:map(fun (Record) -> substaddr(Record, New, Old) end, Members).

