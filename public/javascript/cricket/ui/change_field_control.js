define(['cricket/socket', 'cricket/events'], function(Socket, Events) {
  "use strict";

  return function(player, current_ball, field, ui_builder) {
    var _this = this;

    var button = ui_builder.build_control("change_field");

    var init = function() {
      Socket.call(_this);

      player.on_event('update', refresh);
      current_ball.on_event('update', refresh);
      field.on_event('update', refresh);

      button.on_click(change_field_using_momentum);
    };

    var change_field_using_momentum = function() {
      _this.share_remotely(Events.Field.start_setting_field);
    };

    var refresh = function() {
      if (current_ball.stage !== "play_ball") {
        button.hide();
        return;
      }
      if (!player.has_momentum()) {
        button.hide();
        return;
      }
      if (player.is_batting()) {
        button.hide();
        return;
      }
      if (field.is_being_set()) {
        button.hide();
        return;
      }

      button.show();
    };

    init();
    return _this;
  };
});
