define(['lib/extend', 'lib/can_wire_sync', 'lib/notify_after', 'cricket/supply', 'cricket/events'], 
  function(extend, can_wire_sync, notify_after, become_supply, Events) {

  "use strict";

  var sync_what = {};
  [
    'full_deck_size', 'good_deck_size', 'short_deck_size', 'bouncer_yorker_deck_size',
    'chance_your_arm_deck_size'
  ].forEach(function(field) {
    sync_what[field] = field;
  });

  var notify_when = [
    {after: 'synchronise', emit: 'update'}
  ]

  return function(mirror_supply) {
    extend(mirror_supply).
      using(become_supply).
      using(can_wire_sync, ['/cricket', [Events.Supply.update], sync_what]).
      using(notify_after, ['mirror_supply', notify_when]);

    var init = function(mirror_supply) {
      mirror_supply.full_deck_size = 0;
      mirror_supply.good_deck_size = 0;
      mirror_supply.short_deck_size = 0;
      mirror_supply.bouncer_yorker_deck_size = 0;
      mirror_supply.chance_your_arm_deck_size = 0;
    };

		init(mirror_supply);
  };
});
