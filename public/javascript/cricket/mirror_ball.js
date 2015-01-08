define(['lib/extend', 'lib/can_wire_sync', 'lib/mirror_latest', 'lib/notify_after', 'cricket/ball', 'cricket/events'], 
  function(extend, can_wire_sync, mirror_latest, notify_after, become_ball, Events) {

  "use strict";

  var sync_fields = {};
  [
    'length', 'play', 'height', 'shot', 'distance', 'bowler_card', 'batter_card', 'result',
    'chancing_arm', 'complete', 'boundary', 'stage'
  ].forEach(function(field) {
    sync_fields[field] = field;
  });
  
  var notify_map = [
    {after: 'synchronise', emit: 'update'}
  ];

  return function(mirror_ball) {
    extend(mirror_ball).
      using(become_ball).
      using(can_wire_sync, ['/cricket', [Events.Ball.update, Events.Ball.complete], sync_fields]).
      using(mirror_latest, ['/cricket', Events.Ball.create]).
      using(notify_after, ['mirror_ball', notify_map]);
  };
});
