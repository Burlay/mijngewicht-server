-module(user_handler).

-export([init/3]).
-export([allowed_methods/2]).
-export([content_types_accepted/2]).
-export([content_types_provided/2]).
-export([hello_to_json/2]).
-export([from_json/2]).

init(_Transport, _Req, []) ->
  {upgrade, protocol, cowboy_rest}.

allowed_methods(Req, State) ->
  {[
      <<"GET">>,
      <<"HEAD">>,
      <<"OPTIONS">>,
      <<"PUT">>,
      <<"POST">>
    ], Req, State}.

content_types_accepted(Req, State) ->
  {[
      {<<"application/json">>, from_json}
    ], Req, State}.

content_types_provided(Req, State) ->
  {[
      {<<"application/json">>, hello_to_json}
    ], Req, State}.

hello_to_json(Req, State) ->
  Body = <<"{\"session\": \"Hello World\"}">>,
  {Body, Req, State}.

from_json(Req, State) ->
  {ok, Body, _} = cowboy_req:body(Req),
  {[{<<"username">>, Username},{<<"password">>, Password}]} = jiffy:decode(Body),
  io:format("username: ~p~npassword: ~p~n", [Username, Password]),

  case account:create(Username, Password) of
    {ok, UserID} ->
      io:format("user id: ~p~n", [UserID]),
      {ok, Hostname} = application:get_env(mijngewicht_server, hostname),
      {ok, _} = cowboy_req:reply(201, [{<<"Location">>, ["http://", Hostname]}], Req)
%%    unauthorized ->
%%      io:format("Unauthorized~n"),
%%      {ok, _} = cowboy_req:reply(403, [], Req)
  end,

  {halt, Req, State}.

