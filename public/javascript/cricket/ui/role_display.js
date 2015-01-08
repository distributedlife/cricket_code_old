define([], function() {
  "use strict";

  return function(player, ui_builder) {
    var label = ui_builder.build_label("player_role");

    var refresh = function() {
      if (player.is_batting()) {
        label.update_text("You are batting.");
      } else {
        label.update_text("You are bowling.");
      }
    };

    var init = function() {
      player.on_event('update', refresh);
    };

    init();
  };
});
