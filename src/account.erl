-module(account).

-compile([{parse_transform, lager_transform}]).

-export([create/2]).

-spec create(binary(), binary()) -> {ok, binary()} | {error, binary()}.
create(Username, Password) ->
  %% Create database connection
  {ok, DbAddr} = application:get_env(mijngewicht_server, db_addr),
  {ok, DbUser} = application:get_env(mijngewicht_server, db_username),
  {ok, DbPass} = application:get_env(mijngewicht_server, db_password),
  {ok, DB} = application:get_env(mijngewicht_server, db),
  {ok, DbPort} = application:get_env(mijngewicht_server, db_port),
  {ok, C} = pgsql:connect(DbAddr, DbUser, DbPass, [{database, DB}, {port, DbPort}]),

  {ok, Salt} = bcrypt:gen_salt(),
  {ok, Hash} = bcrypt:hashpw(Password, Salt),
  GUID = ossp_uuid:make(v4, text),

  Query = [
           "INSERT INTO accounts (account_guid, username, password) VALUES ('",
           GUID, "', '",
           Username, "', '",
           Hash, "')"
          ],
  case pgsql:squery(C, Query) of
    {ok, Result} ->
      _ = lager:debug("[SQL] query=~s count=~p", [Query, Result]),
      {ok, GUID};
    {error, {error, error, <<"23505">>, <<"duplicate key value violates unique constraint \"u_account_username\"">>, _}} ->
      {error, "username exists"}
  end.

