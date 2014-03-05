-module(session).

-export([
    create/2,
    check/3
  ]).

create(Username, Password) ->
  case validate_password(Username, Password) of
    {valid, AccountId} ->
      SessionId = ossp_uuid:make(v4, text),
      {ok, 1} = db:query([
          "INSERT INTO sessions (session_guid, account_id) VALUES ('", SessionId, "',", AccountId, ")"
        ]),
      {ok, SessionId};
    {invalid} ->
      unauthorized
  end.

check(Req, State, Fun) ->
  case cowboy_req:cookie(<<"session">>, Req) of
    {undefined, Req2} ->
      {ok, Req3} = cowboy_req:reply(401, [{<<"WWW-Authenticate">>, "FormBased"}], Req2),
      {halt, Req3, State};
    {Session, Req2} ->
      io:format("~n~n~p~n~n", [Session]),
      Sql = [
        "SELECT account_id FROM sessions WHERE session_guid = '", Session, "'"
      ],
      case db:query([Sql]) of
        {ok, _, [{AccountId}]} ->
          Fun(AccountId, Req2, State);
        {ok, _, []} ->
          {ok, Req2} = cowboy_req:reply(401, [{<<"WWW-Authenticate">>, "FormBased"}], Req),
          {halt, Req2, State}
      end
  end.

validate_password(Username, Password) ->
  {ok, _Columns, [{Hash, AccountId}]} = db:query(["SELECT password, account_id FROM accounts WHERE username = '", Username,"'"]),

  case {ok, binary_to_list(Hash)} =:= bcrypt:hashpw(Password, binary_to_list(Hash)) of
    true ->
      {valid, AccountId};
    false ->
      {invalid}
  end.

