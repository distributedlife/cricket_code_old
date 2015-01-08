define(['cricket/socket', 'cricket/events'], function(Socket, Events) {
  "use strict";

  return function(player, current_ball, ui_builder) {
    var display = this;
    var button = ui_builder.build_control("sneak_run");

    var refresh = function() {
      if (current_ball.stage === "sneak_runs" && player.is_batting()) {
        button.show();
        return;
      }

      button.hide();
    };

    var sneak_run = function() {
      display.share_remotely(Events.Player.user_sneak_run);
    };

    var init = function() {
      Socket.call(display);

      button.on_click(sneak_run);

      player.on_event('update', refresh);
      current_ball.on_event('update', refresh);
    };

    init();
    return display;
  };
});
