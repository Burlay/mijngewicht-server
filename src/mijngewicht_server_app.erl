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
  %% Name, NbAcceptors, TransOpts, ProtoOpts
  cowboy:start_http(my_http_listener, 100,
    [{port, 8080}],
    [{env, [{dispatch, Dispatch}]}]
  ),
  mijngewicht_server_sup:start_link().

stop(_State) ->
  ok.
