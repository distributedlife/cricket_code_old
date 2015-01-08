define(["cricket/terms", "cricket/events"], function(Terms, Events) {
  "use strict";

  return function(logic, match) {
    logic.replenish_card = function(ball_length, player) {
      var card = null;

      switch(ball_length) {
        case Terms.Length.full: card = logic.supply.full_deck.draw(); break;
        case Terms.Length.good: card = logic.supply.good_deck.draw(); break;
        case Terms.Length.short: card = logic.supply.short_deck.draw(); break;
        case Terms.Length.bouncer+Terms.Length.yorker: card = logic.supply.bouncer_yorker_deck.draw(); break;
      };

      player.hand.add(card);
      player.decrement_replenish_count();
    };

    var set_supply = function(innings) {
      logic.supply = innings.supply;
    };

    var init = function(logic, match) {
      logic.supply = null;
      match.on_event('new_innings', set_supply);
    };
    init(logic, match);
  };










  // var purchase_card_behaviour = function(card, player) {
  //   player.hand.add(card);
  //   player.use_momentum();
  // }
});
