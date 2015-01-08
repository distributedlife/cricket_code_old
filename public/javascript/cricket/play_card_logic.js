define([], function() {
  "use strict";

  return function(player_action) {
    player_action.play_card = function(index, player) {
      var card = player.hand.remove_by_index(index);
      player.deck.discard(card[0]);
    };
  };
});
