%%%-------------------------------------------------------------------
%%% @author denisgulaev
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. Nov 2024 17:09
%%%-------------------------------------------------------------------
-module(lesson3_task4_tests).
-author("denisgulaev").
-include_lib("eunit/include/eunit.hrl").

-import(lesson3_task4, [decode/2]).


decode_test() ->
  Json = <<"{\"key\":\"value\", \"number\":123, \"is_active\":true, \"nested\":{\"inner\":\"value\"} }">>,
  ExpectedProplist = [{<<"key">>, <<"value">>}, {<<"number">>, 123}, {<<"is_active">>, true}, {<<"nested">>, [{<<"inner">>, <<"value">>}]}],
  ?assertEqual(decode(Json, proplist), ExpectedProplist),

  ExpectedMap = maps:from_list(ExpectedProplist),
  ?assertEqual(decode(Json, map), ExpectedMap).