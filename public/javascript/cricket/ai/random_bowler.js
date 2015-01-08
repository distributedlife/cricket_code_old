define([], function() {
  "use strict";

  return function() {
    var _this = this;

    _this.init = function() {
      this.bowling_ai = 'random';
    };

    _this.play_ball = function(ball, ai) {
      var card = ai.hand.top_card();

      ball.play_bowling_card(card);

      ai.deck.discard(card);
    };

    _this.restrict_runs_momentum = function(ball, ai) {
    };

    _this.init();
    return _this;
  };
});
