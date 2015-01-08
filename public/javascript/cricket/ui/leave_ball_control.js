define(['cricket/socket', 'cricket/events'], function(Socket, Events) {
  "use strict";

  return function(player, current_ball, ui_builder) {
    var display = this;

    var button = ui_builder.build_control("leave_ball");

    var refresh = function() {
      if (player.is_batting() && current_ball.stage === "play_shot") {
        button.show();
      } else {
        button.hide();
      }
    };

    var leave_ball = function() {
      display.share_remotely(Events.Player.user_leave_ball);
    };

    var init = function() {
      Socket.call(display);

      button.on_click(leave_ball);

      player.on_event('update', refresh);
      current_ball.on_event('update', refresh);
    };

    init();
    return display;
  };
});
