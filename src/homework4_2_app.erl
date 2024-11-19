%%%-------------------------------------------------------------------
%% @doc homework4_2 public API
%% @end
%%%-------------------------------------------------------------------

-module(homework4_2_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    homework4_2_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
