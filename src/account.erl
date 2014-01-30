-module(account).

-export([create/2]).

create(_Username, Password) ->
  %  {ok, _C} = pgsql:connect("127.0.0.1", "postgres", "postgres", [{database, "test"}, {port, 6432}]),
  %  {ok, _Columns, _Rows} = pgsql:squery(_C, ["SELECT * FROM users WHERE user_id = ", "1"]),
  %  io:format("~p~n", [_Rows]),
  {ok, Salt} = bcrypt:gen_salt(),
  {ok, Hash} = bcrypt:hashpw(Password, Salt),
  io:format("~p~n", [Hash]),

  {ok, ossp_uuid:make(v4, text)}.

