%% @private
-module(mijngewicht_server_app).
-behaviour(application).

-compile([{parse_transform, lager_transform}]).

%% API.
-export([start/2,
         stop/1]).

%% API.

start(_Type, _Args) ->
  _ = lager:start(),
  _ = lager:info("Starting Mijn Gewicht Synchronization server"),
  folsom:start(),
  otp_mib:load(snmp_master_agent),
  os_mon_mib:load(snmp_master_agent),
  Dispatch = cowboy_router:compile([
    {'_', [
      {"/sessions", session_handler, []},
      {"/sessions/:guid", session_handler, []},
      {"/users", user_handler, []},
      {"/users/:guid", user_handler, []},
      {"/measurements", measurement_handler, []},
      {"/measurements/:guid", measurement_handler, []}
    ]}
  ]),

  {ok, BindPort} = application:get_env(mijngewicht_server, bind_port),
  {ok, BindAddr} = application:get_env(mijngewicht_server, bind_addr),
  {ok, IP} = inet:parse_address(BindAddr),

  PrivDir = code:priv_dir(mijngewicht_server),
  {ok, _} = cowboy:start_https(https, 100, [
    {ip, IP},
    {port, BindPort},
    {certfile, PrivDir ++ "/ssl/server.crt"},
    {keyfile, PrivDir ++ "/ssl/server.key"}
  ], [{env, [{dispatch, Dispatch}]}]),
  _ = lager:info("Servers listening on IP: ~p Port: ~p", [BindAddr,BindPort]),
  mijngewicht_server_sup:start_link().

stop(_State) ->
  ok.

