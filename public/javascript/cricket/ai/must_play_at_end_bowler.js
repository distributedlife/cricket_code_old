define(['cricket/terms'], function(Terms) {
  "use strict";

  return function() {
    var _this = this;

    _this.init = function() {
      this.bowling_ai = 'must_play_at_end';
    };

    _this.sort_hand = function(cards) {
      cards.sort(function(a,b) {
        if (a.play === Terms.Plays.must_play) {
          return 1;
        }
        if (b.play === Terms.Plays.must_play) {
          return -1;
        }

        return 0;
      });
    };

    _this.put_top_card_on_bottom_of_deck = function() {
      var card = this.hand.top_card();
      this.hand.add(card);
    };

    _this.buy_must_play = function(ball) {
      if (ball.play === Terms.Plays.can_leave) {
        if (this.momentum() > 0) {
          ball.play = Terms.Play.must_play;
          this.use_momentum();
        }
      }
    };

    _this.play_ball = function(ball) {
      this.sort_hand(this.hand.cards);

      this.put_top_card_on_bottom_of_deck();

      var card = this.hand.top_card();
      ball.play_bowling_card(card);

      this.buy_must_play(ball);

      this.deck.discard(card);
    };

    _this.restrict_runs_momentum = function(ball) {
    };

    _this.init();
    return _this;
  };
});

