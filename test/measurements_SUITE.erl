-module(measurements_SUITE).

-include_lib("common_test/include/ct.hrl").

-export([all/0]).
-export([
         can_create_measurements/1,
         can_create_measurements_v2/1,
         init_per_suite/1,
         end_per_suite/1
        ]).

all() -> [
          can_create_measurements,
          can_create_measurements_v2
         ].

init_per_suite(Config) ->
  inets:start(),
  ssl:start(),
  Body = "{\"username\":\"test\",\"password\":\"test\"}",

  {ok, {{"HTTP/1.1", 201, "Created"}, _Headers, []}} =
      httpc:request(post, {"https://localhost:3448/users/", [], "application/json", Body}, [], []),
  {ok, {{"HTTP/1.1", 201, "Created"}, Headers, _}} =
      httpc:request(post, {"https://localhost:3448/sessions/", [], "application/json", Body}, [], []),
  Location = proplists:get_value("location", _Headers),
  Cookie = proplists:get_value("set-cookie", Headers),
  Config2 = [{cookie, Cookie}|Config],
  [{location, Location}|Config2].

end_per_suite(Config) ->
  {ok, {{"HTTP/1.1",204,"No Content"}, _, _}} =
      httpc:request(delete, {proplists:get_value(location, Config), [], "application/json", []}, [], []),
  inets:stop(),
  ssl:stop(),
  Config.

can_create_measurements(Config) ->
  URL = "https://localhost:3448/measurements/",
  Body = lists:concat(["{\"guid\":\"f568d04f-dbc6-4813-8054-67464930365d\", \"weight\":100.00, \"date_taken\":\"2014-05-17T10:54+0200\"}"]),

  {ok, {{"HTTP/1.1", 201, "Created"}, _, _}} =
      httpc:request(post, {URL, [{"cookie", proplists:get_value(cookie, Config)}], "application/json", Body}, [], []).

can_create_measurements_v2(Config) ->
  URL = "https://localhost:3448/measurements/",
  Body = lists:concat(["[{\"guid\":\"1fbd3637-2fcd-4866-bbd0-7ed25a6b3864\", \"weight\":100.00, \"date_taken\":\"2014-05-17T10:54+0200\", \"last_modified\":\"2014-05-17T10:54+0200\"},",
          "{\"guid\":\"4ed17060-e86c-4cc8-8f11-3a7a7a7139fe\", \"weight\":100.00, \"date_taken\":\"2014-05-17T10:54+0200\", \"last_modified\":\"2014-05-17T10:54+0200\"}]"]),

  {ok, {{"HTTP/1.1", 201, "Created"}, _, _}} =
      httpc:request(post, {URL, [{"cookie", proplists:get_value(cookie, Config)}], "application/json", Body}, [], []).

