define([], function() {
	"use strict";

	return function(obj, connection, event_map, field_map) {
		Object.keys(event_map).forEach(function(to_wrap) {
	       	var original_function = obj[to_wrap]

	       	obj[to_wrap] = function() {
	        	var return_val = original_function.apply(null, arguments);

	        	connection.send_message_to_clients(event_map[to_wrap], obj.to_wire());

	        	return return_val;
	       	};
		});

	    obj.to_wire = function() {
	    	var wire_obj = {
	    		//TODO: add a test for this
	    		id: obj.id
	    	};

			Object.keys(field_map).forEach(function(field) {
	        	wire_obj[field] = obj[field_map[field]];
	       	});

	       	return wire_obj;
	    }
   	};
});