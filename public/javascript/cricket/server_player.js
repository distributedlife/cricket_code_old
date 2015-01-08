define(['lib/extend', 'lib/will_wire_push', 'lib/notify_after', 'cricket/player', 'cricket/server_deck', 'cricket/terms', 'cricket/events'],
  function(extend, will_wire_push, notify_after, become_player, become_server_deck, Terms, Events) {
  "use strict";

  var become_server_player = function(server_player, connection) {
    server_player.use_momentum = function() {
      server_player.momentum_card_count -= 1;
    };

    server_player.add_momentum = function() {
      server_player.momentum_card_count += 1;
    };

    server_player.set_momentum = function(momentum) {
      server_player.momentum_card_count = momentum;
    };

    server_player.increment_replenish_count = function() {
      server_player.cards_to_replenish += 1;
    };

    server_player.decrement_replenish_count = function() {
      server_player.cards_to_replenish -= 1;
    };

    server_player.setup_hand = function(supply) {
      server_player.supply = supply;

      server_player.deck.add(supply.full_deck.draw());
      server_player.deck.add(supply.full_deck.draw());
      server_player.deck.add(supply.full_deck.draw());
      server_player.deck.add(supply.full_deck.draw());
      server_player.deck.add(supply.full_deck.draw());

      server_player.deck.add(supply.short_deck.draw());
      server_player.deck.add(supply.short_deck.draw());
      server_player.deck.add(supply.short_deck.draw());
      server_player.deck.add(supply.short_deck.draw());
      server_player.deck.add(supply.short_deck.draw());

      server_player.deck.add(supply.good_deck.draw());
      server_player.deck.add(supply.good_deck.draw());
      server_player.deck.add(supply.good_deck.draw());
      server_player.deck.add(supply.good_deck.draw());

      server_player.deck.shuffle();
    };

    server_player.start_new_innings = function(innings) {
      server_player.innings = innings;
      server_player.supply = innings.supply;
      server_player.setup_hand(innings.supply);
    };

    server_player.seed_momentum = function(field) {
      if (server_player.is_batting()) {
        server_player.set_momentum(2);
      } else {
        server_player.set_momentum(field.slips);
      }
    };

    server_player.draw_hand = function() {
      while(server_player.hand.size() < server_player.max_hand_size) {
        var card = server_player.deck.draw();
        server_player.hand.add(card);
      }
    };

    server_player.discard_hand = function() {
      while(!server_player.hand.empty()) {
        var card = server_player.hand.top_card();
        server_player.deck.discard(card);
      }
    };

    server_player.sneaking_runs_is_not_allowed = function(ball) {
      if (!ball.can_sneak_run()) {
        return true;
      }
      if (server_player.momentum() === 0) {
        return true;
      }

      return false;
    }

    server_player.cutting_off_runs_is_not_allowed = function(ball) {
      if (!ball.can_cutoff_run()) {
        return true;
      }
      if (server_player.momentum() === 0) {
        return true;
      }

      return false;
    }

    server_player.sneak_runs = function(ball) {
      if (server_player.sneaking_runs_is_not_allowed(ball)) {
        return;
      }

      server_player.add_runs_momentum(ball);
    };

    server_player.cutoff_runs = function(ball) {
      if (server_player.cutting_off_runs_is_not_allowed(ball)) {
        return;
      }

      server_player.restrict_runs_momentum(ball);
    };

    server_player.trash_card = function(card) {
      server_player.supply.trash_card(card);
    };

    server_player.start_batting = function() {
      server_player.batting = true;
    };

    server_player.start_bowling = function() {
      server_player.batting = false;
    };    

    server_player.sync_deck_properties = function(wire_data) {
      wire_data[deck_id] = server_player.deck.id;
      wire_data[hand_id] = server_player.hand.id;
    }

    var add_callbacks_that_need_to_exist = function(server_player) {
      server_player.start_of_ball = function(ball, field) {};
      server_player.add_runs_momentum = function(ball) {};
      server_player.restrict_runs_momentum = function(ball) {};
      server_player.move_to_next_ball = function() {};
      server_player.trash_cards = function() {};
      server_player.replenish_cards = function() {};
    }

    var init = function() {
      server_player.deck = {};
      server_player.hand = {};

      extend(server_player.deck).
        using(become_server_deck, [connection, [] ]);
      extend(server_player.hand).
        using(become_server_deck, [connection, [] ]);
    };

    init(server_player);
    add_callbacks_that_need_to_exist(server_player);
  }

  var sync_fields = {};
  [
    'momentum_card_count', 'max_hand_size', 'batting', 'cards_to_replenish'
  ].forEach(function(field) {
    sync_fields[field] = field;
  });

  var sync_when = {
    'push_momentum_change': Events.Player.update,
    'increment_replenish_count': Events.Player.update,
    'decrement_replenish_count': Events.Player.update,
    'start_batting': Events.Player.update,
    'start_bowling': Events.Player.update
  };

  return function(server_player, connection) {
    extend(server_player).
      using(become_player).
      using(become_server_player, [connection]);

    var notify_map = [
      {after: 'push_momentum_change', emit: 'momentum'},
      {after: 'use_momentum', emit: 'momentum'},
      {after: 'add_momentum', emit: 'momentum'},
      {after: 'set_momentum', emit: 'momentum'},

      {after: 'start_new_innings', emit: 'player/innings/setup_complete'},
      {after: 'seed_momentum', emit: 'player/over/seed_momentum/complete'},
      {after: 'draw_hand', emit: 'player/over/draw_hand/complete'},
      {after: 'start_of_ball', emit: 'player/ball/start_of_ball/complete'},
      {after: 'move_to_next_ball', emit: 'player/ball/move_to_next_ball/complete'},
      {after: 'trash_cards', emit: 'player/over/trash_cards/complete'},
      {after: 'discard_hand', emit: 'player/over/discard_hand/complete'},

      {after: 'sneak_runs', emit: 'player/ball/sneak_runs/complete'},
      {after: 'cutoff_runs', emit: 'player/ball/cutoff_runs/complete'},

      {after: 'decrement_replenish_count', when: server_player.no_cards_to_be_replenished, emit: 'player/over/replenish_cards/complete'},
      {after: 'replenish_cards', when: server_player.no_cards_to_be_replenished, emit: 'player/over/replenish_cards/complete'}
    ];

    extend(server_player).
      using(will_wire_push, [connection, sync_when, sync_fields, server_player.sync_deck_properties]).
      using(notify_after, ['server_player', notify_map]);
  };
});
