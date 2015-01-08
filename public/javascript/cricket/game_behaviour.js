define([], function() {
	"use strict";

	return function(logic, scorer, field) {
		logic.start_setting_field = function() {
			field.start_setting();
		}

		logic.stop_setting_field = function() {
			field.stop_setting();
		}

		logic.sneak_runs = function(ball, field) {
			var result = scorer.score(ball, field);
            
            ball.record_intermediate_result(result);
		}
		logic.complete_delivery = function(ball, batter, bowler) {
			if (ball.is_boundary()) {
            	batter.add_momentum();
            }
            if (ball.is_wicket()) {
            	bowler.add_momentum();
            }
      
            ball.complete();
		}
	};
});