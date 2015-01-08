define([], function() {
  "use strict";

  return function(player, player_hand, current_over, current_ball, card_display_builder) {
    var display = this;

    var card_displays = [];

    var update_cards_link_label = function(label) {
      card_displays.forEach(function(card_display) {
        card_display.update_link_label(label);
        card_display.show_link();
      });
    };

    var configure = function() {
      if (current_over.stage === 'trash_cards') {
        update_cards_link_label("trash");
        return;
      }
      if (current_ball.stage === 'play_ball') {
        if (player.is_bowling()) {
          update_cards_link_label("use");
          return;
        }
      }
      if (current_ball.stage === 'play_shot') {
        if (player.is_batting()) {
          update_cards_link_label("use");
          return;
        }
      }

      card_displays.forEach(function(card_display) {
        card_display.hide_link();
      });

      return;
    };

    var resize_hand = function() {
      for(var i = 0; i < player_hand.size(); i++) {
        if (!card_displays[i]) {
          var card_display = card_display_builder.build_card_display(i);
          card_displays.push(card_display);
        }
      }

      for (i = player_hand.size(); i < card_displays.length; i++) {
        card_displays[i].hide();
      }

      update_hand();
    };

    var update_hand = function() {
      for(var i = 0; i < player_hand.size(); i++) {
        var card = player_hand.cards[i];
        if (card) {
          if (player_hand.selected_card !== i) {
            card_displays[i].deselect();
          }

          card_displays[i].update(card);
        }
      }
    };

    var init = function() {
      player_hand.on_event('update', resize_hand);

      current_over.on_event('update', configure);
      current_ball.on_event('update', configure);
    };

    init();
    return display;
  };
});
