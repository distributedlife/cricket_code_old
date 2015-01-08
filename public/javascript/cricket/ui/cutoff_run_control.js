define(['cricket/socket', 'cricket/events'], function(Socket, Events) {
  "use strict";

  return function(player, current_ball, ui_builder) {
    var display = this;

    var button = ui_builder.build_control("cutoff_run");

    var refresh = function() {
      if (current_ball.stage === "cutoff_runs" && player.is_bowling()) {
        button.show();
      }

      button.hide();
    };

    var cutoff_run = function() {
      display.share_remotely(Events.Player.user_cutoff_run);
    };

    var init = function() {
      Socket.call(display);

      button.on_click(cutoff_run);

      player.on_event('update', refresh);
      current_ball.on_event('update', refresh);
    };

    init();
    return display;
  };
});
