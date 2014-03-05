%% Feel free to use, reuse and abuse the code in this file.

%% @private
-module(mijngewicht_server_app).
-behaviour(application).

%% API.
-export([start/2]).
-export([stop/1]).

%% API.

start(_Type, _Args) ->
  Dispatch = cowboy_router:compile([
    {'_', [
      {"/sessions", session_handler, []},
      {"/sessions/:guid", session_handler, []},
      {"/users", user_handler, []},
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
  mijngewicht_server_sup:start_link().

stop(_State) ->
  ok.

%-module(mijngewicht_server_app).
%-behavior(application).

%-export([start/2]).
%-export([stop/1]).

%start(_Type, _Args) ->
%  Dispatch = cowboy_router:compile([
%      {'_', [
%             {"/", toppage_handler, []},
%             {"/sessions", session_handler, []},
%             {"/sessions/:guid", session_handler, []},
%             {"/users", user_handler, []},
%             {"/measurements", measurement_handler, []},
%             {"/measurements/:guid", measurement_handler, []}
%             ]}
%    ]),

%  {ok, BindPort} = application:get_env(mijngewicht_server, bind_port),
%  {ok, BindAddr} = application:get_env(mijngewicht_server, bind_addr),
%  {ok, _IP} = inet:parse_address(BindAddr),

%  PrivDir = code:priv_dir(mijngewicht_server),
%  io:format("privdir: ~p~n", [PrivDir]),
%  {ok, PID} = cowboy:start_https(https, 100, [
%      {port, BindPort},
%      {cacertfile, PrivDir ++ "/ssl/cowboy-ca.cert"},
%      {certfile, PrivDir ++ "/ssl/server.crt"},
%      {keyfile, PrivDir ++ "/ssl/server.key"},
%      {ciphers, [{rsa,aes_256_cbc,sha256}]}
%    ], [{env, [{dispatch, Dispatch}]}]),

%  io:format("pid: ~p~n", [PID]),
  %% Name, NbAcceptors, TransOpts, ProtoOpts
  %cowboy:start_http(my_http_listener, 100,
  %  [{ip, IP}, {port, BindPort}],
  %  [{env, [{dispatch, Dispatch}]}]
  %),
%  mijngewicht_server_sup:start_link().

%stop(_State) ->
%  ok.
