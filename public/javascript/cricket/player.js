define([], function() {
  "use strict";

  return function(player) {
    var init = function() {
      player.deck = null;
      player.hand = null;
      player.supply = null;
      player.momentum_card_count = 0;
      player.max_hand_size = 7;
      player.batting = false;
      player.cards_to_replenish = 0;
    };

    player.is_ai = function() {
			return true;
		};

    player.is_human = function() {
      return false;
    };

    player.momentum = function() {
      return player.momentum_card_count;
    };

    player.has_momentum = function() {
      return player.momentum_card_count > 0;
    };

    player.is_batting = function() {
      return player.batting;
    };

    player.is_bowling = function() {
      return !player.batting;
    };

    player.no_cards_to_be_replenished = function() {
      return (player.cards_to_replenish === 0);
    };

    init(player);
  };
});
