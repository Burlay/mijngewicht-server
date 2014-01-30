-module(mijngewicht_server_app).
-behavior(application).

-export([start/2]).
-export([stop/1]).

start(_Type, _Args) ->
  Dispatch = cowboy_router:compile([
      %% {URIHost, list({URIPath, Handler, Opts})}
      {'_', [
             {"/session", session_handler, []},
             {"/session/:guid", session_handler, []},
             {"/user", user_handler, []}
             ]}
    ]),

  {ok, BindPort} = application:get_env(mijngewicht_server, bind_port),
  {ok, BindAddr} = application:get_env(mijngewicht_server, bind_addr),
  {ok, IP} = inet:parse_address(BindAddr),
  %% Name, NbAcceptors, TransOpts, ProtoOpts
  cowboy:start_http(my_http_listener, 100,
    [{ip, IP}, {port, BindPort}],
    [{env, [{dispatch, Dispatch}]}]
  ),
  mijngewicht_server_sup:start_link().

stop(_State) ->
  ok.
