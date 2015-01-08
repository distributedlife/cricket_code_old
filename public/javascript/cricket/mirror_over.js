define(['lib/extend', 'lib/can_wire_sync', 'lib/mirror_latest', 'lib/notify_after', 'cricket/over', 'cricket/events'],  function(extend, can_wire_sync, mirror_latest, notify_after, become_over, Events) {
  "use strict";

  var wire_fields = {}
  [
    'balls', 'balls_in_over', 'stage'
  ].forEach(function(field) {
    wire_fields.[field] = field;
  })

  var notify_map = [
    {after: 'synchronise', emit: 'update'}
  ];

  return function(mirror_over) {
    extend(mirror_over).
      using(become_over).
      using(can_wire_sync, ['/cricket', [Events.Over.update], wire_fields]).
      using(mirror_latest, ['/cricket', Events.Over.create]).
      using(notify_after, ['mirror_over', notify_map]);
  };
});
