define(['cricket/terms'], function(Terms) {
  "use strict";

  return function(chance_your_arm_deck) {
    var _this = this;

    _this.beat_the_bat = function(ball) {
      if (ball.is_must_play()) {
        return Terms.Balls.wicket;
      } else {
        return Terms.Balls.dot;
      }
    };

    _this.score = function(ball, field) {
      if (ball.is_no_shot_being_played()) {
        return _this.beat_the_bat(ball);
      }

      if (ball._batter_card.shot === Terms.Shots.block) {
        return Terms.Balls.dot;
      }

			if (ball._bowler_card.length === Terms.Length.yorker) {
				if (ball._batter_card.length !== Terms.Length.yorker && ball._batter_card.length !== Terms.Length.good) {
					return _this.beat_the_bat(ball);
				}
			}
			if (ball._bowler_card.length === Terms.Length.full) {
				if (ball._batter_card.length === Terms.Length.short || ball._batter_card.length === Terms.Length.bouncer) {
					return _this.beat_the_bat(ball);
				}
			}
			if (ball._bowler_card.length === Terms.Length.good) {
				if (ball._batter_card.length === Terms.Length.bouncer) {
					return _this.beat_the_bat(ball);
				}
			}
			if (ball._bowler_card.length === Terms.Length.short) {
				if (ball._batter_card.length === Terms.Length.full || ball._batter_card.length === Terms.Length.bouncer) {
					return _this.beat_the_bat(ball);
				}
			}
			if (ball._bowler_card.length === Terms.Length.bouncer) {
				if (ball._batter_card.length !== Terms.Length.bouncer) {
					return _this.beat_the_bat(ball);
				}
			}

      if (ball._chancing_arm) {
        var result = chance_your_arm_deck.draw();
        chance_your_arm_deck.discard(result);

        if (result === '4') {
          return Terms.Balls.four;
        } else if (result === '6') {
          return Terms.Balls.six;
        } else if (result === 'infield catch') {
          ball.airborne_shot(Terms.Distance.infield);
        } else {
          ball.airborne_shot(Terms.Distance.outfield);
        }
      }

      return _this.playing_a_shot(ball, field);
    };

    _this.playing_a_shot = function(ball, field) {
      if (!field.has_fielder_in_slice(ball._batter_card.shot)) {
        if (ball.is_catchable()) {
          return _this.runs_scored(ball.is_infield(), Terms.Balls.two, Terms.Balls.three);
        } else {
          return _this.runs_scored(ball.is_infield(), Terms.Balls.one, Terms.Balls.two);
        }
      }

      if (!field.has_fielder_in_spot(ball._batter_card.distance, ball._batter_card.shot)) {
        if (ball.is_catchable()) {
          return Terms.Balls.two;
        } else {
          return Terms.Balls.one;
        }
      }

      if (ball.is_catchable()) {
        return Terms.Balls.wicket;
      } else {
        return _this.runs_scored(ball.is_infield(), Terms.Balls.dot, Terms.Balls.one);
      }
    };

    _this.runs_scored = function(is_infield, infield, outfield) {
      return is_infield ? infield : outfield;
    };

    return _this;
  };
});
