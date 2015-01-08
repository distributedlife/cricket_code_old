define(['cricket/socket', 'cricket/events', 'cricket/terms' ], function(Socket, Events, Terms) {
  "use strict";

  return function(player, current_ball, selected_card, ui_builder) {
    var display = this;

    var link = ui_builder.build_control("chance_arm");

    var init = function() {
      Socket.call(display);

      player.on_event('update', refresh);
      current_ball.on_event('update', refresh);
      selected_card.on_event('update', refresh);

      link.on_click(send_chance_arm_event);
    };

    var refresh = function() {
      if (current_ball.stage !== 'play_shot') {
        link.hide();
        return;
      }
      if (player.is_bowling()) {
        link.hide();
        return;
      }
      if (player.momentum() === 0) {
        link.hide();
        return;
      }
      if (selected_card.index === null) {
        link.hide();
        return;
      }
      if (selected_card.card === null) {
        link.hide();
        return;
      }
      if (selected_card.card.shot === Terms.Shots.block) {
        link.hide();
        return;
      }

      link.show();
    };

    var send_chance_arm_event = function() {
      display.share_remotely(Events.Player.user_chance_arm);
    };

    init();
    return display;
  };
});

