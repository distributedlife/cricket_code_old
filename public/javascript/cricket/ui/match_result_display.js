define([], function() {
  "use strict";

  return function(match, ui_builder) {
    var label = ui_builder.build_label("match_result");

    var refresh = function() {
      var result = match.result;
      var text = "player " + result.winner + " won by " + result.margin + " " + result.factor;

      label.update_text(text);
    };

    var init = function() {
      match.on_event('complete', refresh);
    };

    init();
  };
});
