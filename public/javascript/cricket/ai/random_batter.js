define([], function() {

  var batting_ai = function(slice) {
    function play_shot(ball) {
      var card = this.hand.top_card();

      ball.play_batting_card(card);

      this.deck.discard(card);

      return true;
    }

    function add_runs_momentum(ball) {
      return true;
    }

    return function() {
      this.batting_ai = 'random';
      this.play_shot = play_shot;
      this.add_runs_momentum = add_runs_momentum;

      return this;
    };
  }([].slice);

  return batting_ai;
});
