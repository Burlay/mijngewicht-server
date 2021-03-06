%% Feel free to use, reuse and abuse the code in this file.

%% @private
-module(mijngewicht_server_sup).
-behaviour(supervisor).

%% api.
-export([start_link/0]).

%% supervisor.
-export([init/1]).

%% api.

-spec start_link() -> {ok, pid()}.
start_link() ->
	supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% supervisor

init([]) ->
	{ok, {{one_for_one, 10, 10}, []}}.

