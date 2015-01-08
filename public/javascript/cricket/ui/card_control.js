define(["cricket/events", "cricket/terms", "cricket/socket"], function(Events, Terms, Socket) {
  "use strict";

  return function(player, i, ui_builder) {
    var display = ui_builder.build_link_label("#hand #cards", "card", i);

    var card = null;
    var label = "use";

    display.update_link_label = function(new_label) {
      label = new_label;

      display.link.update_text("[" + label + "]");
    };

    display.deselect = function() {
      display.link.update_text("[" + label + "]");
    };

    display.show_link = function() {
      display.show(true);
    };

    display.hide_link = function() {
      display.show(false);
    };

    display.update = function(card_to_display) {
      card = card_to_display;

      stringify_card();

      ["full", "good", "short", "bouncer"].forEach(function(length) {
        display.label.remove_class(length);
      });

      display.label.add_class(card.length);
    };

    var stringify_card = function() {
      var bowler = card.length + " " + card.play;

      var length = "";
      var distance = "";
      var catchable = "";
      if (card.shot !== Terms.Shots.block) {
        length = card.length;
        distance = card.distance;
        catchable = card.catchable === Terms.Height.catchable ? "in the air" : "along the ground";
      }
      var batter = length + " " + Terms.ShotsDisplay[card.shot] + " " + distance + " " + catchable;

      if (player.is_batting()) {
        display.label.update_text(batter + " ");
      } else {
        display.label.update_text(bowler + " ");
      }
    };

    var select_this_card_function = function(i) {
      display.link.update_text("[cancel]");

      return function() {
        display.share_remotely(Events.Player.user_selected_card, {
          card: card,
          index: i
        });
      };
    };

    var init = function() {
      Socket.call(display);
      
      display.link.on_click(select_this_card_function(i));

      player.on_event("update", stringify_card);
    };

    init();
    return display;
  };
});
