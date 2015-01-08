define(['cricket/server_deck', 'cricket/cards', 'cricket/terms'], function (ServerDeck, Cards, Terms) {
  "use strict";

  return function() {
    var _this = this;

    _this.full_deck = null;
    _this.good_deck = null;
    _this.short_deck = null;
    _this.bouncer_yorker_deck = null;
    _this.chance_your_arm_deck = null;

    _this.init = function() {
      _this.populate_decks();
      _this.shuffle_decks();
    };

    _this.populate_decks = function() {
      var cards = new Cards();

      _this.full_deck = new ServerDeck(cards.full_length());
      _this.good_deck = new ServerDeck(cards.good_length());
      _this.short_deck = new ServerDeck(cards.short_length());
      _this.bouncer_yorker_deck = new ServerDeck(cards.bouncers().concat(cards.yorkers()));
      _this.chance_your_arm_deck = new ServerDeck(cards.chance_arm());
    };

    _this.shuffle_decks = function() {
      _this.full_deck.shuffle();
      _this.good_deck.shuffle();
      _this.short_deck.shuffle();
      _this.bouncer_yorker_deck.shuffle();
      _this.chance_your_arm_deck.shuffle();
    };

    _this.trash_card = function(card) {
      if (card.length === Terms.Length.full) {
        _this.full_deck.discard(card);
      }
      if (card.length === Terms.Length.good) {
        _this.good_deck.discard(card);
      }
      if (card.length === Terms.Length.short) {
        _this.short_deck.discard(card);
      }
      if (card.length === Terms.Length.bouncer) {
        _this.bouncer_yorker_deck.discard(card);
      }
      if (card.length === Terms.Length.yorker) {
        _this.bouncer_yorker_deck.discard(card);
      }
    };

    _this.init();

    return _this;
  };
});
