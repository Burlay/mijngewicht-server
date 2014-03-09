-module(measurement_handler).

-export([
    init/3,
    allowed_methods/2,
    content_types_accepted/2,
    content_types_provided/2,
    hello_to_json/2,
    from_json/2,
    return_measurements/3,
    store_measurement/3,
    parse/2
  ]).

init(_Transport, _Req, []) ->
  {upgrade, protocol, cowboy_rest}.

allowed_methods(Req, State) ->
  {[
      <<"GET">>,
      <<"HEAD">>,
      <<"OPTIONS">>,
      <<"PUT">>,
      <<"POST">>
    ], Req, State}.

content_types_accepted(Req, State) ->
  {[
      {<<"application/json">>, from_json}
    ], Req, State}.

content_types_provided(Req, State) ->
  {[
      {<<"application/json">>, hello_to_json}
    ], Req, State}.

hello_to_json(Req, State) ->
  session:check(Req, State, fun measurement_handler:return_measurements/3).

from_json(Req, State) ->
  session:check(Req, State, fun measurement_handler:store_measurement/3).

return_measurements(AccountId, Req, State) ->
  Qry = [
    "SELECT MAX(updated_at) AT TIME ZONE 'UTC' FROM measurements AS t1 ",
    "WHERE account_id = ", AccountId
  ],

  case db:query([Qry]) of
    {ok, _, [{_LastModified}]} ->
      Sql2 = [
        "SELECT measurement_guid, weight, to_char(date_taken AT TIME ZONE 'UTC', 'YYYY-MM-DD\"T\"HH24:MI\"+0000\"') AS date_taken ",
        "FROM measurements WHERE account_id = ", AccountId
      ],

      {ok, Columns, Rows} = db:query(Sql2),
      Rawr = to_json(Columns, Rows),

      %RFC1123 = parse(LastModified, 'date-time'),
      %{ok, Req2} = cowboy_req:reply(200, [{<<"Last-Modified">>, RFC1123}], Rawr, Req),
      {ok, Req2} = cowboy_req:reply(200, [], Rawr, Req),
      {halt, Req2, State};
    {ok, _, []} ->
      io:format("OPTION@"),
      {ok, Req2} = cowboy_req:reply(204, [], Req),
      {halt, Req2, State}
  end.

store_measurement(AccountId, Req, State) ->
  {ok, Body, _} = cowboy_req:body(Req),
  JSON = jiffy:decode(Body),

  _SQLQuery = build_query(JSON, AccountId),

  {ok, _} = db:query(SQLQuery),

  gcm:send_sync_signal(AccountId),

  {ok, Req3} = cowboy_req:reply(201, [], Req),
  {halt, Req3, State}.

build_query(Rows, AccountId) ->
  build_query(Rows, AccountId, []).

build_query([], _, []) ->
  [];
build_query([], _, Acc) ->
  ["INSERT INTO measurements (measurement_guid, weight, date_taken, updated_at, account_id) VALUES ", Acc];
build_query([Row|Rows], AccountId, Acc) ->
  {[
      {<<"guid">>, GUID},
      {<<"weight">>, Weight},
      {<<"date_taken">>, DateTaken}
    ]} = Row,

  Values = ["('",
    binary_to_list(GUID), "', ",
    float_to_list(Weight), ", '",
    binary_to_list(DateTaken), "', now(), ", AccountId, ")"
  ],

  case Acc of
    [] ->
      build_query(Rows, AccountId, [Values|Acc]);
    _ ->
      build_query(Rows, AccountId, [[Values, ", "]|Acc])
  end.

parse(Source, 'date-time') ->
  String = binary_to_list(Source),
  {ok, [YYYY, MM, DD, HH, Min, SS, _], ""} = io_lib:fread("~4d-~2d-~2d ~2d:~2d:~2d.~6d", String),
  httpd_util:rfc1123_date({{YYYY, MM, DD}, {HH, Min, SS}}).

to_json(Columns, Rows) ->
  to_json(Columns, Rows, []).

to_json(_, [], []) ->
  [];
to_json(_, [], Acc) ->
  ["[", [Acc], "]"];
to_json(Columns, [Row|Rows], Acc) ->
  {GUID, Weight, DateTaken} = Row,
  io:format("~n~n~p~n~n", [DateTaken]),
  JSON = [
    "{\"measurement_guid\":\"", GUID, "\",",
    "\"weight\":", Weight, ",",
    "\"date_taken\":\"", DateTaken, "\"}"
  ],
  case Acc of
    [] ->
      to_json(Columns, Rows, [JSON|Acc]);
    _ ->
      to_json(Columns, Rows, [[JSON, ","]|Acc])
  end.
