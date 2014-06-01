-module(iwg_mgmt).

-export([
        on_response/4,
        log_request/1
        ]).

-spec on_response(cowboy:http_status(), cowboy:http_headers(), iodata(), cowboy_req:req()) -> cowboy_req:req().
on_response(Status, Headers, Data, Req) ->
  lager:debug("~p ~p ~p", [Status, Headers, byte_size(Data)]),
  {_, Runtime} = statistics(runtime),
  {_, WallClock} = statistics(wall_clock),
  ok = folsom_metrics:notify({cpu_runtime, Runtime}),
  ok = folsom_metrics:notify({cpu_wallclock, WallClock}),
  Req.

-spec log_request(non_neg_integer()) -> ok.
log_request(Req_size) ->
  _ = statistics(runtime),
  _ = statistics(wall_clock),
  ok = folsom_metrics:notify({requests, {inc, 1}}),
  ok = folsom_metrics:notify({request_size, Req_size}),
  ok.
