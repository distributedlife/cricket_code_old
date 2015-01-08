define(['lib/extend', 'lib/will_wire_push', 'cricket/events'], function(extend, will_wire_push, Events) {
  "use strict";

  var push_when = {
    match_complete: Events.Match.complete
  };
  var push_fields = {
    result: 'result'
  };

  var become_server_match = function(server_match) {
    server_match.result = null;

    server_match.match_complete = function(match) {
      server_match.result = match.winner();
    };
  };

  return function (server_match, connection, match) {
    extend(server_match).
      using(become_server_match).
      using(will_wire_push, [connection, push_when, push_fields]);

    match.on_event('complete', server_match.match_complete);
  };
});
