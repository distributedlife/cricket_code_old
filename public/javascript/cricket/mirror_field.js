define(['lib/extend', 'lib/can_wire_sync', 'lib/notify_after', "cricket/field", "cricket/terms", "cricket/events"], function(extend, can_wire_sync, notify_after, become_field, Terms, Events) {
	"use strict";

  var field_map = {
    infield: 'infield',
    outfield: 'outfield',
    slips: 'slips',
    max_fielders: 'max_fielders',
    max_slips: 'max_slips',
    set_mode: 'set_mode'
  };

  var notify_map = [
    {after: 'synchronise', emit: 'update'}
  ];

	return function(field) {
    extend(field).
      using(can_wire_sync, ['/cricket', [Events.Field.update], field_map]).
      using(notify_after, ['mirror_field', notify_map]);
	};
});
