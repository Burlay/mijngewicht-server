-module(iwg_req).

-export([
        on_request/1
        ]).

on_request(Req) ->
  {Length, Req2} = cowboy_req:body_length(Req),
  {Path, Req3} = cowboy_req:path(Req2),
  {Method, Req4} = cowboy_req:method(Req3),
  {Peer, Req5} = cowboy_req:peer(Req4),
  _ = iwg_mgmt:log_request(Method, Path, Length, Peer),
  Req5.

