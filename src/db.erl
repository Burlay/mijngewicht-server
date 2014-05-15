-module(db).
-export([query/1]).

query(Qry) ->
  {ok, DbAddr} = application:get_env(mijngewicht_server, db_addr),
  {ok, DbUser} = application:get_env(mijngewicht_server, db_username),
  {ok, DbPass} = application:get_env(mijngewicht_server, db_password),
  {ok, DB} = application:get_env(mijngewicht_server, db),
  {ok, DbPort} = application:get_env(mijngewicht_server, db_port),
  {ok, C} = pgsql:connect(DbAddr, DbUser, DbPass, [{database, DB}, {port, DbPort}]),

  pgsql:squery(C, [Qry]).
