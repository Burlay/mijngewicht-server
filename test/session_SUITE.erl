-module(session_SUITE).

-include_lib("common_test/include/ct.hrl").

-export([all/0]).
-export([
         can_create_new_user/1
       , init_per_suite/1
       , end_per_suite/1
        ]).

all() -> [
          can_create_new_user
         ].

init_per_suite(Config) ->
  inets:start(),
  ssl:start(),
  Config.

end_per_suite(Config) ->
  inets:stop(),
  ssl:stop(),
  Config.

can_create_new_user(_Config) ->
  URL = "https://localhost:3448/users/",
  Body = "{\"username\":\"test\",\"password\":\"test\"}",
  {ok, Result} = httpc:request(post, {URL, [], "application/json", Body}, [], []),

  %% Check that we can create a user.
  {{"HTTP/1.1", 201, "Created"}, Headers, []} = Result,

  %% Check that we can not use the same e-mail again
  {ok, Result2} = httpc:request(post, {URL, [], "application/json", Body}, [], []),
  {{"HTTP/1.1",409,"Conflict"}, _, _} = Result2,

  Location = proplists:get_value("location", Headers),

  %% Check that we can delete a user.
  {ok, Result} = httpc:request(delete, {Location, [], "application/json", []}, [], []).

