define(['lib/extend', 'lib/can_wire_sync', 'lib/notify_after', 'cricket/deck', "cricket/events"], function(extend, can_wire_sync, notify_after, become_deck, Events) {
  "use strict";

  var wire_fields = {
    cards: 'cards',
    discards: 'discards'
  };
  var notify_map = [
    {after: 'synchronise', emit: 'update'}
  ];

  var init = function(mirror_deck, id) {
    mirror_deck.source_id = id;
  };

  return function(mirror_deck, id) {
    extend(mirror_deck).
      using(become_deck).
      using(can_wire_sync, ['/cricket', [Events.Deck.update], wire_fields]).
      using(notify_after, ['mirror_deck', notify_map]);

    init(mirror_deck, id)
  };
});
