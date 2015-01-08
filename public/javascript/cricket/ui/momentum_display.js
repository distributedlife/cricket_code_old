define([], function() {
  "use strict";

  return function(id, player, ui_builder) {
    var label = new ui_builder.build_label(id);

    var refresh = function() {
      label.update_text(player.momentum());
    };

    var init = function() {
      player.on_event('update', refresh);
    };

    init();
  };
});
