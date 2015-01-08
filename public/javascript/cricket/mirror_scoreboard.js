define(['lib/extend', 'lib/can_wire_sync', 'lib/notify_after', 'cricket/scoreboard', 'cricket/events'], 
  function(extend, can_wire_sync, notify_after, become_scoreboard, Events) {
  "use strict";

  var sync_what = {};
  ['player1', 'player2'].forEach(function(field) {
    sync_what[field] = field;
  });

  var notify_map = [
    {after: 'synchronise', emit: 'update'}
  ];

  return function(mirror_scoreboard) {
    extend(mirror_scoreboard).
      using(become_scoreboard).
      using(can_wire_sync, ['/cricket', [Events.Scoreboard.update], sync_what]).
      using(notify_after, ['mirror_scoreboard', notify_map]);
  };
});
