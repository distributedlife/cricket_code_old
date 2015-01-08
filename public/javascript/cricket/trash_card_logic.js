define([], function() {
  "use strict";

  return function(player_action) {
    player_action.trash_card = function(index, player) {
      player.hand.remove_by_index(index);
      player.increment_replenish_count();
    };
  };
});
