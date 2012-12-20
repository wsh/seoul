-module(object).
-export([new/0, object/1]).

object(Dict) ->
  object(receive
      {add, {Key, Value}} -> dict:store(Key, Value, Dict);
      {remove, Key} -> dict:erase(Key, Dict);
      {Receiver, Args} -> obj_process(Receiver, Args, Dict), Dict
    end).

obj_process(R, A, D) ->
  [Name|Args] = A,
  Func = dict:fetch(Name, D),
  R ! Func,
  io:format("~s ~n", [Func]).

new() ->
  spawn(object, object, [dict:new()]).
