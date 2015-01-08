define(['cricket/socket', 'cricket/events'], function(Socket, Events) {
  "use strict";

  return function(current_ball, ui_builder) {
    var display = this;

    var button = ui_builder.build_control("next_ball");

    var refresh = function() {
      if (current_ball.stage === "sneak_runs") {
        button.show();
        return;
      }
      if (current_ball.stage === "cutoff_runs") {
        button.show();
        return;
      }
      if (current_ball.stage === "move_to_next_ball") {
        button.show();
        return;
      }

      button.hide();
    };

    var complete_this_delivery = function() {
      display.share_remotely(Events.Player.user_wants_to_end_delivery);
    };

    var init = function() {
      Socket.call(display);

      button.on_click(complete_this_delivery);
      current_ball.on_event('update', refresh);
    };

    init();
    return display;
  };
});
