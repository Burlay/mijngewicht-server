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
  lager:debug("~p:check/3", [?MODULE]),
  {{IP, Port}, Req2} = cowboy_req:peer(Req),
  case cowboy_req:cookie(<<"session">>, Req2) of
    {undefined, Req3} ->
      lager:debug("No Session cookie present in request from IP: ~p Port: ~p", [IP, Port]),
      {ok, Req4} = cowboy_req:reply(401, [{<<"WWW-Authenticate">>, "FormBased"}], Req3),
      {halt, Req4, State};
    {Session, Req3} ->
      lager:debug("Session cookie with ID: ~p found request from IP: ~p Port: ~p", [Session, IP, Port]),
      Sql = [
        "SELECT account_id FROM sessions WHERE session_guid = '", Session, "'"
      ],
      case db:query([Sql]) of
        {ok, _, [{AccountId}]} ->
      		lager:debug("Found AccountID: ~p for sessionID: ~p", [AccountId, Session]),
          Fun(AccountId, Req3, State);
        {ok, _, []} ->
      		lager:debug("Found no associated account for Session: ~p", [Session]),
          {ok, Req4} = cowboy_req:reply(401, [{<<"WWW-Authenticate">>, "FormBased"}], Req3),
          {halt, Req4, State}
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

