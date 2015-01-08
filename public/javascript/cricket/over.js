define(['cricket/terms'], function(Terms) {
  "use strict";

  return function(over) {
    over.in_progress = function() {
      return !over.complete();
    };

    over.complete = function() {
      return over.balls_remaining() === 0;
    };

    over.runs = function() {
      return over.balls.filter(function(ball) {
				return ball.is_complete();
			}).map(function(ball) {
        return ball.runs();
      }).reduce(function(total, ball) {
        return total + ball;
      }, 0);
    };

		over.record = function() {
			return over.balls.map(function(ball) {
				return ball._result;
			}).join('');
		};

    over.total_balls = function() {
      return over.balls.length;
    };

    over.balls_remaining = function() {
      var legitimate_balls = over.balls.filter(function(ball) { return ball.is_legal(); });
			var complete_balls = legitimate_balls.filter(function(ball) { return ball.is_complete(); });

      return over.balls_in_over - complete_balls.length;
    };

    over.balls_bowled = function() {
      return over.balls_in_over - over.balls_remaining();
    };

    over.wickets = function() {
      return over.balls.filter(function(ball) { return ball.is_wicket();}).length;
    };

    var init = function() {
      over.balls = [];
      over.balls_in_over = 6;
      over.stage = 'not_started';
    };

    init();
  };
});
