define(['cricket/server_ball'], function(become_server_ball) {
	"use strict";

	return function() {
		var factory = this;

		factory.create_ball = function() {
			var ball = {}
			become_server_ball(ball);

			return ball;
		}

		return factory;
	};
});