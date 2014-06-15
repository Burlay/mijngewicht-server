-module(session).

-compile([{parse_transform, lager_transform}]).

-export([
    create/2,
    check/2,
    check/3,
    get_accountid/1
  ]).

create(Username, Password) ->
  case validate_password(Username, Password) of
    {valid, AccountId} ->
      SessionId = ossp_uuid:make(v4, text),
      Query = ["INSERT INTO sessions (session_guid, account_id) VALUES ('", SessionId, "',", AccountId, ")"],
      _ = lager:debug("[SQL] query=~s", [Query]),
      {ok, 1} = db:query(Query),
      {ok, SessionId};
    {invalid} ->
      unauthorized
  end.

-spec check(cowboy_req:req(), _) -> {ok, any()} | {halt, cowboy_req:req(), any()}.
check(Req, State) ->
  case cowboy_req:cookie(<<"session">>, Req) of
    {undefined, _} ->
      {ok, Req2} = cowboy_req:reply(401, [{<<"WWW-Authenticate">>, "FormBased"}], Req),
      {halt, Req2, State};
    {Sessionid, _} ->
      case get_accountid(Sessionid) of
        not_found ->
          {ok, Req2} = cowboy_req:reply(401, [{<<"WWW-Authenticate">>, "FormBased"}], Req),
          {halt, Req2, State};
        Accountid ->
          {ok, Accountid}
      end
  end.

-spec check(cowboy_req:req(), _, fun()) -> any().
check(Req, State, Fun) ->
  {{IP, Port}, Req2} = cowboy_req:peer(Req),
  case cowboy_req:cookie(<<"session">>, Req2) of
    {undefined, Req3} ->
      _ = lager:debug("No Session cookie present in request from IP: ~p Port: ~p", [IP, Port]),
      {ok, Req4} = cowboy_req:reply(401, [{<<"WWW-Authenticate">>, "FormBased"}], Req3),
      {halt, Req4, State};
    {Session, Req3} ->
      _ = lager:debug("Session cookie with ID: ~p found request from IP: ~p Port: ~p", [Session, IP, Port]),
      Sql = [
        "SELECT account_id FROM sessions WHERE session_guid = '", Session, "'"
      ],
      case db:query([Sql]) of
        {ok, _, [{AccountId}]} ->
      		_ = lager:debug("Found AccountID: ~p for sessionID: ~p", [AccountId, Session]),
          Fun(AccountId, Req3, State);
        {ok, _, []} ->
      		_ = lager:debug("Found no associated account for Session: ~p", [Session]),
          {ok, Req4} = cowboy_req:reply(401, [{<<"WWW-Authenticate">>, "Woot realm=\"insert realm\""}], Req3),
          {halt, Req4, State}
      end
  end.

validate_password(Username, Password) ->
  Query = ["SELECT password, account_id FROM accounts WHERE username = '", Username,"'"],
  {ok, _, Rows} = db:query(Query),
  _ = lager:debug("[SQL] query=~s count=~p", [Query, length(Rows)]),
  case length(Rows) of
    0 ->
      {invalid};
    1 ->
      [{Hash, AccountId}] = Rows,
      case {ok, binary_to_list(Hash)} =:= bcrypt:hashpw(Password, binary_to_list(Hash)) of
        true ->
          {valid, AccountId};
        false ->
          {invalid}
      end
  end.

-spec get_accountid(binary()) -> binary() | not_found.
get_accountid(Sessionid) ->
  Sql = ["SELECT account_id FROM sessions WHERE session_guid = '", Sessionid, "'"],
  case db:query([Sql]) of
    {ok, _, [{AccountId}]} ->
      AccountId;
    {ok, _, []} ->
      not_found
  end.

