define(['lib/text_view', "cricket/mirror_supply"], function(TextView, MirrorSupply) {
  "use strict";

  return function() {
    var _this = this;

    _this.init = function() {
      _this.full_deck = new TextView("full_deck_card_count");
      _this.good_deck = new TextView("good_deck_card_count");
      _this.short_deck = new TextView("short_deck_card_count");
      _this.bouncer_yorker_deck = new TextView("bouncer_yorker_deck_card_count");
      _this.chance_your_arm_deck = new TextView("chance_your_arm_deck_card_count");

      _this.supply = new MirrorSupply();
      _this.supply.on_event('update', _this.refresh);
    };

    _this.refresh = function(supply) {
      _this.full_deck.update_text(supply.full_deck_size);
      _this.good_deck.update_text(supply.good_deck_size);
      _this.short_deck.update_text(supply.short_deck_size);
      _this.bouncer_yorker_deck.update_text(supply.bouncer_yorker_deck_size);
      _this.chance_your_arm_deck.update_text(supply.chance_your_arm_deck_size);
    };

    _this.init();
    return _this;
  };
});

