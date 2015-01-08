define(['lib/extend', 'lib/can_wire_sync', 'lib/notify_after', "cricket/events"], function(extend, can_wire_sync, notify_after, Events) {
  "use strict";

  var wire_fields = {
    result: 'result'
  };
  var notify_map = [
    {after: 'synchronise', emit: 'complete'}
  ];

  return function(mirror_match) {
    mirror_match.result = null;

    extend(mirror_match).
      using(can_wire_sync, ['/cricket', Events.Match.complete, wire_fields]).
      using(notify_after, ['mirror_match', notify_map]);
  };
});
