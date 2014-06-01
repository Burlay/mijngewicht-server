-module(iwg_mgmt).

-export([
        on_response/4,
        log_request/4
        ]).

-spec on_response(cowboy:http_status(), cowboy:http_headers(), iodata(), cowboy_req:req()) -> cowboy_req:req().
on_response(Status, _Headers, Data, Req) ->
  lager:info("[response] status=~p size=~p", [Status, byte_size(Data)]),
  {_, Runtime} = statistics(runtime),
  {_, WallClock} = statistics(wall_clock),
  ok = folsom_metrics:notify({cpu_runtime, Runtime}),
  ok = folsom_metrics:notify({cpu_wallclock, WallClock}),
  Req.

-spec log_request(
  binary(),
  binary(),
  non_neg_integer(),
  {inet:ip_address(), inet:port_number()}) -> ok.
log_request(Method, Path, Req_size, Peer) ->
  _ = statistics(runtime),
  _ = statistics(wall_clock),
  ok = folsom_metrics:notify({requests, {inc, 1}}),
  ok = folsom_metrics:notify({request_size, Req_size}),
  {Address, Port} = Peer,
  lager:info("[request] method=~ts path=~ts size=~p address=~s port=~p",
    [Method, Path, Req_size, inet_parse:ntoa(Address), Port]),
  ok.
