define(["cricket/terms"], function(Terms) {
	"use strict";

	return function(field) {
		field.has_fielder_in_spot = function(distance, position_name) {
			var fielding_ring = (distance === Terms.Distance.infield) ? field.infield : field.outfield;
			var spot = field.filter_by_position_name(fielding_ring, position_name);
			return spot[0].has_fielder;
		};

		field.has_fielder_in_slice = function(position_name) {
			return (
				field.has_fielder_in_spot(Terms.Distance.infield, position_name) ||
				field.has_fielder_in_spot(Terms.Distance.outfield, position_name)
			);
		};

		field.filter_by_position_name = function(fielding_ring, position_name) {
			return fielding_ring.filter(function(fielding_position) {
				return (fielding_position.name === position_name);
			});
		};

		field.position_has_fielder = function(position) {
			return position.has_fielder;
		};

		field.infielders = function() {
			return field.infield.filter(field.position_has_fielder);
		};

		field.outfielders = function() {
			return field.outfield.filter(field.position_has_fielder);
		};

		field.is_being_set = function() {
			return field.set_mode;
		};

		var init = function(field) {
			field.infield = [];
			field.outfield = [];
			field.slips = 0;
			field.max_fielders = 9;
			field.max_slips = 3;
			field.set_mode = false;

			for(var shot in Terms.Shots) {
				if (Terms.Shots.hasOwnProperty(shot)) {
        		 	if (shot !== Terms.Shots.block) {
        		    	field.infield.push({name: shot, has_fielder: false});
         		   		field.outfield.push({name: shot, has_fielder: false});
        		  	}
				}
      		}
    	};

		init(field);
	};
});
