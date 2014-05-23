-module(iwg_mgmt).

-export([
        on_request/1,
        on_response/4
        ]).

on_request(Req) ->
  statistics(runtime),
  statistics(wall_clock),
  folsom_metrics:notify({requests, {inc, 1}}),
  {Length, Req2} = cowboy_req:body_length(Req),
  folsom_metrics:notify({request_size, Length}),
  Req2.

on_response(_, _, _, Req) ->
  {_, Runtime} = statistics(runtime),
  {_, WallClock} = statistics(wall_clock),
  folsom_metrics:notify({cpu_runtime, Runtime}),
  folsom_metrics:notify({cpu_wallclock, WallClock}),
  Req.
