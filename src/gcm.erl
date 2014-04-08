-module(gcm).

-export([
    send_sync_signal/1
  ]).

send_sync_signal(AccountId) ->
  Qry = ["SELECT gcm_registration_id FROM registered_devices WHERE account_id=", AccountId],
  {ok, _Columns, Rows} = db:query(Qry),
  send_sync_to_devices(Rows).

send_sync_to_devices([]) ->
  ok;
send_sync_to_devices([{RegistrationId}|RegistrationIds]) ->
  Method = post,
  URL = "https://android.googleapis.com/gcm/send",
  Header = [
    {"Content-Type", "application/json"},
    {"Authorization", "key=AIzaSyDjurxEdUtgpZBbq_gaM9wbGB2PIgD1dvU"}
  ],
  Type = "application/json",
  Body = lists:concat(["{\"registration_ids\": [\"", binary_to_list(RegistrationId), "\"]}"]),
  HTTPOptions = [],
  Options = [],

  _ = httpc:request(Method, {URL, Header, Type, Body}, HTTPOptions, Options),

  send_sync_to_devices(RegistrationIds).
