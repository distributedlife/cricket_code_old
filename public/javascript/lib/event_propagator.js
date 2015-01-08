define([], function() {
	"use strict";

	return function(event_propagator) {
		event_propagator.propagate = function() {};
	}
});