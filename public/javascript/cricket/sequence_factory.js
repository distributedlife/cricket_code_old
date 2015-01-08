define(['cricket/over_sequence', 'cricket/ball_sequence'], function(OverSequence, BallSequence) {
	"use strict";

	return function(over_builder, ball_factory, wait_for_all_factory, game_behaviour, field) {
		var factory = this;

		factory.build_over_sequence = function(batter, bowler) {
			new OverSequence(batter, bowler, field, game_behaviour, wait_for_all_factory, over_builder, sequence_factory);
		};

		factory.build_ball_sequence = function(batter, bowler) {
			new BallSequence(ball_factory, wait_for_all_factory, game_behaviour, batter, bowler, field);
		};

		return factory;
	};
});