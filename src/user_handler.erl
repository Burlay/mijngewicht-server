-module(user_handler).

-compile([{parse_transform, lager_transform}]).

-define(FUNCTION,
  element(2, element(2, process_info(self(), current_function)))).

-export([init/3]).
-export([allowed_methods/2]).
-export([content_types_accepted/2]).
-export([content_types_provided/2]).
-export([hello_to_json/2]).
-export([from_json/2]).
-export([delete_resource/2]).

init(_Transport, _Req, []) ->
  {upgrade, protocol, cowboy_rest}.

allowed_methods(Req, State) ->
  {[
      <<"GET">>,
      <<"HEAD">>,
      <<"OPTIONS">>,
      <<"PUT">>,
      <<"POST">>,
      <<"DELETE">>
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
  _ = lager:debug("~p:~p/2", [?MODULE, ?FUNCTION]),
  Body = <<"{\"session\": \"Hello World\"}">>,
  {Body, Req, State}.

from_json(Req, State) ->
  _ = lager:debug("~p:~p/2", [?MODULE, ?FUNCTION]),
  {ok, Body, _} = cowboy_req:body(Req),
  {Json} = jiffy:decode(Body),
  Username = proplists:get_value(<<"username">>, Json),
  Password = proplists:get_value(<<"password">>, Json),

  _ = lager:info("Creating new user account ~p", [Username]),
  case account:create(Username, Password) of
    {ok, UserId} ->
      {ok, Hostname} = application:get_env(mijngewicht_server, hostname),
      {ok, Req2} = cowboy_req:reply(201, [{<<"Location">>, "https://" ++ Hostname ++ "/users/" ++ UserId}], Req),
      {halt, Req2, State};
    {error, "username exists"} ->
      {ok, Req2} = cowboy_req:reply(409, [], Req),
      {halt, Req2, State}
  end.

delete_resource(Req, State) ->
  _ = lager:debug("~p:~p/2", [?MODULE, ?FUNCTION]),
  {true, Req, State}.
