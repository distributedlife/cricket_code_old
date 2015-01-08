define(['cricket/socket', 'cricket/events'], function(Socket, Events) {
  "use strict";

  return function(player, current_over, ui_builder) {
    var trash_cards_control = this;
    var button = ui_builder.build_control("finish_trashing_cards");

    var refresh = function() {
      if (current_over.stage === 'trash_cards') {
        start_trashing();
      } else if (current_over.stage === 'replenish_cards') {
        button.update_text("[" + player.cards_to_replenish + " cards to buy]");
        button.disable();
        button.show();
      } else {
        button.hide();
      }
    };

    var start_trashing = function() {
      button.enable();
      button.update_text("[Finish Trashing Cards]");
      button.show();
    };

    var finish_trashing_cards = function() {
      trash_cards_control.share_remotely(Events.Player.finish_trashing_cards);
    };

    var init = function() {
      Socket.call(trash_cards_control);

      player.on_event('update', refresh);
      current_over.on_event('update', refresh);

      button.on_click(finish_trashing_cards);
      button.hide();
    };

    init();
    return trash_cards_control;
  };
});
