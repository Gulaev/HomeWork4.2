%%%-------------------------------------------------------------------
%%% @author denisgulaev
%%% @doc
%%%
%%% JSON Decoder
%%%
%%% @end
%%% Created : 04. Nov 2024 13:18
%%%-------------------------------------------------------------------
-module(lesson3_task4).
-author("denisgulaev").
-export([decode/2]).

decode(Json, Format) ->
  % Remove whitespace and convert to string
  TrimmedJson = string:trim(Json),
  case Format of
    proplist -> decode_to_proplist(TrimmedJson);
    map -> decode_to_map(TrimmedJson)
  end.

decode_to_proplist(<<"{", Rest/binary>>) ->
  {Result, _} = parse_object_proplist(Rest),
  Result.

decode_to_map(<<"{", Rest/binary>>) ->
  {Result, _} = parse_object_proplist(Rest),
  maps:from_list(Result).

% Parse object for proplist format
parse_object_proplist(Binary) ->
  parse_object_proplist(string:trim(Binary), []).

parse_object_proplist(<<"}", Rest/binary>>, Acc) ->
  {lists:reverse(Acc), Rest};
parse_object_proplist(<<"\"", Rest/binary>>, Acc) ->
  {Key, Rest1} = parse_string(Rest),
  {_, Rest3} = skip_whitespace_and_colon(Rest1),
  {Value, Rest4} = parse_value_proplist(string:trim(Rest3)),
  Rest5 = skip_comma(Rest4),
  parse_object_proplist(string:trim(Rest5), [{Key, Value} | Acc]).

skip_whitespace_and_colon(Binary) ->
  Trimmed = string:trim(Binary),
  case Trimmed of
    <<":", Rest/binary>> -> {<<"">>, Rest};
    Other -> split_on_colon(Other)
  end.

split_on_colon(Binary) ->
  case binary:split(Binary, <<":">>) of
    [Before, After] -> {Before, After};
    _ -> {Binary, <<"">>}
  end.

skip_comma(Binary) ->
  Trimmed = string:trim(Binary),
  case Trimmed of
    <<",", Rest/binary>> -> Rest;
    Other -> Other
  end.

% Parse string value
parse_string(Binary) ->
  parse_string(Binary, <<>>).

parse_string(<<"\"", Rest/binary>>, Acc) ->
  {Acc, Rest};
parse_string(<<C/utf8, Rest/binary>>, Acc) ->
  parse_string(Rest, <<Acc/binary, C/utf8>>).

% Parse various value types for proplist format
parse_value_proplist(<<"true", Rest/binary>>) ->
  {true, Rest};
parse_value_proplist(<<"false", Rest/binary>>) ->
  {false, Rest};
parse_value_proplist(<<"null", Rest/binary>>) ->
  {null, Rest};
parse_value_proplist(<<"\"", Rest/binary>>) ->
  parse_string(Rest);
parse_value_proplist(<<"[", Rest/binary>>) ->
  parse_array(Rest);
parse_value_proplist(<<"{", Rest/binary>>) ->
  parse_object_proplist(Rest);
parse_value_proplist(Binary) ->
  case binary:first(Binary) of
    C when C >= $0, C =< $9; C =:= $- ->
      parse_number(Binary);
    _ ->
      {null, Binary}
  end.

% Parse array
parse_array(Binary) ->
  parse_array(string:trim(Binary), []).

parse_array(<<"]", Rest/binary>>, Acc) ->
  {lists:reverse(Acc), Rest};
parse_array(<<"\"", Rest/binary>>, Acc) ->
  {Value, Rest1} = parse_string(Rest),
  Rest2 = skip_comma(Rest1),
  parse_array(string:trim(Rest2), [Value | Acc]);
parse_array(Binary, Acc) ->
  {Value, Rest1} = parse_value_proplist(Binary),
  Rest2 = skip_comma(Rest1),
  parse_array(string:trim(Rest2), [Value | Acc]).

% Parse number
parse_number(Binary) ->
  parse_number(Binary, <<>>).

parse_number(<<C/utf8, Rest/binary>>, Acc) when C >= $0, C =< $9; C =:= $-; C =:= $. ->
  parse_number(Rest, <<Acc/binary, C/utf8>>);
parse_number(Rest, Acc) ->
  try
    case binary:match(Acc, <<".">>) of
      nomatch -> {binary_to_integer(Acc), Rest};
      _ -> {binary_to_float(Acc), Rest}
    end
  catch
    _:_ -> {0, Rest}
  end.