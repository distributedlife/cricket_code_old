define([], function() {
  "use strict";

  return function(hand, ui_builder) {
    var display = this;

    var label = ui_builder.build_label("opponent_hand_cards");

    var refresh = function() {
      label.update_text(hand.size());
    };

    var init = function() {
      hand.on_event('update', refresh);
    };

    init();
    return display;
  };
});
