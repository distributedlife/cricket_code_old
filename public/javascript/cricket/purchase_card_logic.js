define(["cricket/terms", "cricket/events"], function(Terms, Events) {
  "use strict";

  return function(player_action, match) {
    player_action.purchase_card = function(ball_length, player) {
      var card = null;

      switch(ball_length) {
        case Terms.Length.full: card = player_action.supply.full_deck.draw(); break;
        case Terms.Length.good: card = player_action.supply.good_deck.draw(); break;
        case Terms.Length.short: card = player_action.supply.short_deck.draw(); break;
        case Terms.Length.bouncer+Terms.Length.yorker: card = player_action.supply.bouncer_yorker_deck.draw(); break;
      };

      player.hand.add(card);
      player.use_momentum();
    };

    var set_supply = function(innings) {
      player_action.supply = innings.supply;
    };

    var init = function(player_action, match) {
      player_action.supply = null;
      match.on_event('new_innings', set_supply);
    };
    init(player_action, match);
  };
});
