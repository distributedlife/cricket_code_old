define(['lib/extend', 'lib/can_wire_sync', 'lib/notify_after', 'cricket/player', 'cricket/mirror_deck', 'cricket/events'],
  function(extend, can_wire_sync, notify_after, become_player, become_mirror_deck, Events) {
  "use strict";

  var wire_fields = {};
  [
    'momentum_card_count', 'max_hand_size', 'batting', 'cards_to_replenish'
  ].forEach(function(field) {
    wire_fields[field] = field;
  })

  var notify_map = [
    {after: 'synchronise', emit: 'update'}
  ];

  var become_mirror_player = function(mirror_player) {
    mirror_player.sync_deck_ids = function(wire_data) {
      mirror_player.deck.source_id = wire_data.deck_id;
      mirror_player.hand.source_id = wire_data.hand_id;
    }

    var init = function(mirror_player) {
      mirror_player.deck = {};
      mirror_player.hand = {};

      extend(mirror_player.deck).
        using(become_mirror_deck);
      extend(mirror_player.hand).
        using(become_mirror_deck);
    };

    init(mirror_player);
  };

  return function(mirror_player) {
    //TODO: assert that mirror_player based in has an id property

    extend(mirror_player).
      using(become_player).
      using(become_mirror_player).
      using(can_wire_sync, ['/cricket', [Events.Player.update], wire_fields, mirror_player.sync_deck_ids]).
      using(notify_after, ['mirror_player', notify_map]);
  };
});
