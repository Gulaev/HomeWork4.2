%%%-------------------------------------------------------------------
%%% @author denisgulaev
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. Nov 2024 17:09
%%%-------------------------------------------------------------------
-module(lesson3_task3_tests).
-author("denisgulaev").
-include_lib("eunit/include/eunit.hrl").
-import(lesson3_task3, [split/2]).

%% Test for split/2
split_test() ->
  ?assertEqual(split(<<"a,b,c,d">>, <<",">>), [<<"a">>, <<"b">>, <<"c">>, <<"d">>]),
  ?assertEqual(split(<<"apple orange banana">>, <<" ">>), [<<"apple">>, <<"orange">>, <<"banana">>]),
  ?assertEqual(split(<<"x-y-z">>, <<"-">>), [<<"x">>, <<"y">>, <<"z">>]),
  ?assertEqual(split(<<"a,b,,c,d">>, <<",">>), [<<"a">>, <<"b">>, <<>> ,<<"c">>, <<"d">>]).