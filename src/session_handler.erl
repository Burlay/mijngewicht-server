-module(session_handler).

-compile([{parse_transform, lager_transform}]).

-export([init/3]).
-export([allowed_methods/2]).
-export([content_types_accepted/2]).
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

from_json(Req, State) ->
  {ok, Body, _} = cowboy_req:body(Req),
  {[{<<"username">>, Username},{<<"password">>, Password}]} = jiffy:decode(Body),

  case session:create(Username, Password) of
    {ok, SessionID} ->
      _ = lager:info("[auth] result=succes session=~ts account=~ts",[SessionID, Username]),
      _ = folsom_metrics:notify({login_succes, {inc, 1}}),
      {ok, Hostname} = application:get_env(mijngewicht_server, hostname),
      Req2 = cowboy_req:set_resp_cookie("session", SessionID, [], Req),
      {ok, Req3} = cowboy_req:reply(201, [{<<"Location">>, ["http://", Hostname, "/session/", SessionID]}], Req2),
      {halt, Req3, State};
    unauthorized ->
      _ = lager:info("[auth] result=failed account=~ts",[Username]),
      _ = folsom_metrics:notify({login_failed, {inc, 1}}),
      {ok, Req2} = cowboy_req:reply(401, [{<<"WWW-Authenticate">>, "Woot realm=\"insert realm\""}], Req),
      {halt, Req2, State}
  end.

