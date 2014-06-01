-module(measurement_handler).

-compile([{parse_transform, lager_transform}]).

-export([
    init/3,
    allowed_methods/2,
    content_types_accepted/2,
    content_types_provided/2,
    hello_to_json/2,
    from_json/2,
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

-spec hello_to_json(cowboy_req:req(), _) -> any().
hello_to_json(Req, State) ->
  {{IP, Port}, _} = cowboy_req:peer(Req),
  {HeaderVal, _} = cowboy_req:header(<<"user-agent">>, Req),
  _ = lager:info("Received request from IP: ~p Port: ~p Agent: ~p", [IP, Port, HeaderVal]),

  {ok, Accountid} = session:check(Req, State),
  return_measurements(Accountid, Req, State).

from_json(Req, State) ->
  session:check(Req, State, fun measurement_handler:store_measurement/3).

return_measurements(AccountId, Req, State) ->
  Sql = [
    "SELECT measurement_guid, weight, to_char(date_taken AT TIME ZONE 'UTC', 'YYYY-MM-DD\"T\"HH24:MI\"+0000\"') AS date_taken ",
    "FROM measurements WHERE account_id = ", AccountId
  ],

  case db:query(Sql) of
    {ok, _, []} ->
      _ = lager:info("Found no measurements for AccountId: ~p", [AccountId]),
      {ok, Req2} = cowboy_req:reply(204, [], Req),
      {halt, Req2, State};
    {ok, Columns, Rows} ->
      _ = lager:info("Found ~p measurements for AccountId: ~p", [length(Rows), AccountId]),
      JSON = to_json(Columns, Rows),

      %RFC1123 = parse(LastModified, 'date-time'),
      %{ok, Req2} = cowboy_req:reply(200, [{<<"Last-Modified">>, RFC1123}], Rawr, Req),
      {ok, Req2} = cowboy_req:reply(200, [], JSON, Req),
      {halt, Req2, State}
  end.

store_measurement(AccountId, Req, State) ->
  {ok, Body, _} = cowboy_req:body(Req),
  {Hash, _} = cowboy_req:header(<<"content-md5">>, Req),
  _ = check_body_hash(Body, Hash),

  case jiffy:decode(Body) of
    {[{<<"guid">>,GUID},{<<"weight">>, Weight}, {<<"date_taken">>, DateTaken}]} ->
      {ok, Count} = db:query([
                              "INSERT INTO measurements (measurement_guid, weight, date_taken, updated_at, account_id) VALUES ('",
                              binary_to_list(GUID), "', ",
                              float_to_list(Weight), ", '",
                              binary_to_list(DateTaken), "', now(), ", AccountId,")"
                             ]),

      _ = lager:info("[measurement] action=create count=~p", [Count]),
      _ = folsom_metrics:notify(measurements_created, {inc, Count}),
      case Count > 0 of
        true ->
          gcm:send_sync_signal(AccountId);
        false ->
          ok
      end;
    JSON ->
      {ok, Count} = merge_measurements(JSON, AccountId),
      _ = lager:info("[measurement] action=create count=~p", [Count]),
      _ = folsom_metrics:notify(measurements_created, {inc, Count}),

      case Count > 0 of
        true ->
          gcm:send_sync_signal(AccountId);
        false ->
          ok
      end
  end,

  {ok, Req3} = cowboy_req:reply(201, [], Req),
  {halt, Req3, State}.

check_body_hash(Body, ClientHash) ->
  _ = lager:debug("Hash received from client ~p", [ClientHash]),
  BodyHash = erlang:md5(Body),
  _ = lager:debug("Hash calculated from Body ~p", [lists:flatten([io_lib:format("~2.16.0b", [B]) || <<B>> <=BodyHash])]).

merge_measurements([], _) ->
  {error, "No records to save"};
merge_measurements(Rows, AccountId) ->
  merge_measurements(Rows, AccountId, 0).

merge_measurements([], _, Count) ->
  {ok, Count};
merge_measurements([Row|Rows], AccountId, Count) ->
  {[
      {<<"guid">>, GUID},
      {<<"weight">>, Weight},
      {<<"date_taken">>, DateTaken},
      {<<"last_modified">>, _LastModified}
    ]} = Row,

  UpdateQuery = lists:concat(["UPDATE measurements SET ",
    "weight = ",      float_to_list(Weight),     ", ",
    "date_taken = '", binary_to_list(DateTaken), "', ",
    "updated_at = '", binary_to_list(_LastModified), "', ",
    "account_id = ",  binary_to_list(AccountId), " ",
    "WHERE measurement_guid = '", binary_to_list(GUID), "' ",
    "AND updated_at < '", binary_to_list(_LastModified), "'"
  ]),
  {ok, Rawr} = db:query(UpdateQuery),
  case Rawr of
    1 ->
      merge_measurements(Rows, AccountId, Count + Rawr);
    0 ->
      InsertQuery = lists:concat([
          "INSERT INTO measurements (measurement_guid, weight, date_taken, updated_at, account_id) VALUES ( ",
          "'", binary_to_list(GUID), "', ",
          float_to_list(Weight), ", ",
          "'", binary_to_list(DateTaken), "', ",
          "'", binary_to_list(_LastModified), "', ",
          binary_to_list(AccountId),
          ")"
        ]),
      case db:query(InsertQuery) of
        {ok, Rawr2} ->
          merge_measurements(Rows, AccountId, Count + Rawr2);
        {error, _Error} ->
          merge_measurements(Rows, AccountId, Count)
      end
  end.

parse(Source, 'date-time') ->
  String = binary_to_list(Source),
  {ok, [YYYY, MM, DD, HH, Min, SS, _], ""} = io_lib:fread("~4d-~2d-~2d ~2d:~2d:~2d.~6d", String),
  httpd_util:rfc1123_date({{YYYY, MM, DD}, {HH, Min, SS}}).

%%-spec to_json(number(), number()) -> number().
to_json(Columns, Rows) ->
  to_json(Columns, Rows, []).

to_json(_, [], []) ->
  [];
to_json(_, [], Acc) ->
  ["[", [Acc], "]"];
to_json(Columns, [Row|Rows], Acc) ->
  {GUID, Weight, DateTaken} = Row,
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
