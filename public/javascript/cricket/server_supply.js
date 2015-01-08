define(['lib/extend', 'lib/will_wire_push', 'cricket/supply', 'cricket/terms', 'cricket/events'], 
  function(extend, will_wire_push, become_supply, Terms, Events) {
  "use strict";

  var become_server_suppply = function(server_supply) {
    var get_size_field = function(deck) {
      return deck + "_size";
    }

    var decks = [
      "full_deck",
      "good_deck",
      "short_deck", 
      'bouncer_yorker_deck',
      'chance_your_arm_deck'
    ];

    server_supply.update_counts = function() {
      decks.forEach(function(deck) {
        server_supply[get_size_field(deck)] = server_supply[deck].size();
      });
    }

    server_supply.populate_decks = function(cards, server_deck_builder) {
      server_supply.full_deck = server_deck_builder.build(cards.full_length());
      server_supply.good_deck = server_deck_builder.build(cards.good_length());
      server_supply.short_deck = server_deck_builder.build(cards.short_length());
      server_supply.bouncer_yorker_deck = server_deck_builder.build(cards.bouncers().concat(cards.yorkers()));
      server_supply.chance_your_arm_deck = server_deck_builder.build(cards.chance_arm());
    };

    server_supply.shuffle_decks = function() {
      decks.forEach(function(deck) {
        server_supply[deck].shuffle();
      });
    };

    server_supply.trash_card = function(card) {
      if (card.length === Terms.Length.full) {
        server_supply.full_deck.discard(card);
      }
      if (card.length === Terms.Length.good) {
        server_supply.good_deck.discard(card);
      }
      if (card.length === Terms.Length.short) {
        server_supply.short_deck.discard(card);
      }
      if (card.length === Terms.Length.bouncer) {
        server_supply.bouncer_yorker_deck.discard(card);
      }
      if (card.length === Terms.Length.yorker) {
        server_supply.bouncer_yorker_deck.discard(card);
      }
    };  

    server_supply.init = function(cards, server_deck_builder) {
      server_supply.populate_decks(cards, server_deck_builder);
      server_supply.shuffle_decks();
      server_supply.update_counts();

      decks.forEach(function(deck) {
        server_supply[deck].on_event('update', server_supply.update_counts);
      });
    };
  }

  var sync_when = {
    update_counts: Events.Supply.update
  };
  var sync_fields = {};
  [
    'full_deck_size', 'good_deck_size', 'short_deck_size', 'bouncer_yorker_deck_size', 
    'chance_your_arm_deck_size'
  ].forEach(function(field) {
    sync_fields[field] = field;
  });
  

  return function(server_supply, connection, cards, server_deck_builder) {
    extend(server_supply).
      using(become_supply).
      using(become_server_suppply, [cards]).
      using(will_wire_push, [connection, sync_when, sync_fields]);

    server_supply.init(cards, server_deck_builder)
  };
});
