define(['cricket/socket', 'cricket/events'], function(Socket, Events) {
  "use strict";

  return function(current_ball, selected_card, ui_builder) {
    var display = this;

    var button = ui_builder.build_control("play_shot");

    var refresh = function() {
      if (selected_card.index === null) {
        button.hide();
        return;
      }
      if (current_ball.stage !== "play_shot" && current_ball.stage !== "play_ball") {
        button.hide();
        return;
      }

      button.show();
    };

    var play_selected_card = function() {
      display.share_remotely(Events.Player.user_play_selected_card);
    };

    var init = function() {
      Socket.call(display);

      button.on_click(play_selected_card);

      selected_card.on_event('update', refresh);
      current_ball.on_event('update', refresh);
    };

    init();
    return display;
  };
});

