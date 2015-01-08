define([], function() {
  "use strict";

  return function(deck, cards) {
    deck.size = function() {
      return deck.cards.length;
    };

    deck.empty = function() {
      return deck.size() === 0;
    };

    var init = function(deck, cards) {
      deck.cards = cards;
      deck.discards = [];
    };

    init(deck, cards);
  };
});
