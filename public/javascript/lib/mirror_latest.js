define(['lib/become_client'], function(become_client) {
	"use strict";

	return function(obj, channel, on_event) {
		become_client(obj, channel);

    	obj.change_source_id = function(id) {
      		obj.source_id = id;
    	}

    	obj.source_id = null;
    	obj.on_server_event(on_event, obj.change_source_id);
  	};
});