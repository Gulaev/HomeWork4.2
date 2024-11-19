%%%-------------------------------------------------------------------
%%% @author denisgulaev
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. Nov 2024 13:14
%%%-------------------------------------------------------------------
-module(lesson3_task2).
-author("denisgulaev").
-export([words/1]).

words(BinText) ->
  words(BinText, <<>>, []).

words(<<>>, <<>>, Acc) ->
  lists:reverse(Acc);
words(<<>>, Word, Acc) ->
  lists:reverse([Word | Acc]);
words(<<32, Rest/binary>>, <<>>, Acc) ->
  words(Rest, <<>>, Acc);
words(<<32, Rest/binary>>, Word, Acc) ->
  words(Rest, <<>>, [Word | Acc]);
words(<<C, Rest/binary>>, Word, Acc) ->
  words(Rest, <<Word/binary, C>>, Acc).
