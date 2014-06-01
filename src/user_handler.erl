-module(user_handler).

-compile([{parse_transform, lager_transform}]).

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
  Body = <<"{\"session\": \"Hello World\"}">>,
  {Body, Req, State}.

from_json(Req, State) ->
  {ok, Body, _} = cowboy_req:body(Req),
  {Json} = jiffy:decode(Body),
  Username = proplists:get_value(<<"username">>, Json),
  Password = proplists:get_value(<<"password">>, Json),

  case account:create(Username, Password) of
    {ok, UserId} ->
      _ = lager:info("[account] action=create account=~ts", [UserId]),
      _ = folsom_metrics:notify({accounts_created, {inc, 1}}),
      {ok, Hostname} = application:get_env(mijngewicht_server, hostname),
      {ok, Req2} = cowboy_req:reply(201, [{<<"Location">>, "https://" ++ Hostname ++ "/users/" ++ UserId}], Req),
      {halt, Req2, State};
    {error, "username exists"} ->
      {ok, Req2} = cowboy_req:reply(409, [], Req),
      {halt, Req2, State}
  end.

delete_resource(Req, State) ->
  {GUID, _} = cowboy_req:binding(guid, Req),
  SQL = ["DELETE FROM accounts WHERE account_guid = '", GUID, "'"],
  {ok, _} = db:query(SQL),
  _ = folsom_metrics:notify({accounts_deleted, {inc, 1}}),
  _ = lager:info("[account] action=delete account=~ts",[GUID]),
  {true, Req, State}.
