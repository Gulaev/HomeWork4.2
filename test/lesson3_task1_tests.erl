%%%-------------------------------------------------------------------
%%% @author denisgulaev
%%% @copyright (C) 2024, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. Nov 2024 17:08
%%%-------------------------------------------------------------------
-module(lesson3_task1_tests).
-author("denisgulaev").
-include_lib("eunit/include/eunit.hrl").
-import(lesson3_task1, [first_word/1]).  % Change this import

first_word_test() ->
  ?assertEqual(first_word(<<"Hello World">>), <<"Hello">>),
  ?assertEqual(first_word(<<"   Hello World">>), <<"Hello">>),
  ?assertEqual(first_word(<<"  ">>), <<>>),
  ?assertEqual(first_word(<<"Hello">>), <<"Hello">>).