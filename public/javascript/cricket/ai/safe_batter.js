define(['cricket/terms', 'cricket/scorer'], function(Terms, Scorer) {
  "use strict";

  return function() {
    var _this = this;

    _this.init = function() {
      this.batting_ai = 'safe batter';
    };

    _this.play_shot = function(ball, field, ai) {
      var value = [];
      var scorer = new Scorer();

      ai.hand.cards.forEach(function(card) {
        ball.play_batter_card(card);
        var runs = scorer.score(ball, field);
        value.push({card: card, runs: runs});
        ball._batter_card = null;
        ball._height = null;
      });


      var not_out = value.filter(function(option) {
        return (option.runs !== Terms.Balls.wicket);
      });

      not_out.sort(function(a, b) {
        return (Terms.Score[a.runs] > Terms.Score[b.runs]) ? -1 : 1;
      });

      if (not_out.length > 0) {
        _this.play_card(not_out[0].card, ball, ai);
      }
    };

    _this.add_runs_momentum = function(ball, ai) {
    };

    _this.play_card = function(card, ball, ai) {
      ball.play_batting_card(card);
      ai.hand.remove(card);
      ai.deck.discard(ball.batter_card);
    };

    _this.init();
    return _this;
  };
});
