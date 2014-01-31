-module(account).

-export([create/2]).

create(Username, Password) ->
  %  {ok, _Columns, _Rows} = pgsql:squery(_C, ["SELECT * FROM users WHERE user_id = ", "1"]),
  %  io:format("~p~n", [_Rows]),
  {ok, Salt} = bcrypt:gen_salt(),
  {ok, Hash} = bcrypt:hashpw(Password, Salt),
  GUID = ossp_uuid:make(v4, text),

  {ok, DbAddr} = application:get_env(mijngewicht_server, db_addr),
  {ok, DbUser} = application:get_env(mijngewicht_server, db_username),
  {ok, DbPass} = application:get_env(mijngewicht_server, db_password),
  {ok, DB} = application:get_env(mijngewicht_server, db),
  {ok, DbPort} = application:get_env(mijngewicht_server, db_port),
  {ok, C} = pgsql:connect(DbAddr, DbUser, DbPass, [{database, DB}, {port, DbPort}]),
  _Blah = pgsql:squery(C, [
      "INSERT INTO accounts (account_guid, username, password) VALUES ('",
      GUID, "', '",
      Username, "', '",
      Hash, "')"
    ]),
  {ok, GUID}.


