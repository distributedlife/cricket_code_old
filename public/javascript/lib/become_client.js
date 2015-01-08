define(['socket.io'], function(io) { 
	"use strict";

	return function(client, channel) {
	 	if (client.socket === undefined) {
	 		client.socket = io.connect(channel);	
	 	}
	 	
	    client.notify_server = function(name, params) {
	      if (params === undefined) {
	        return client.socket.emit(name);
	      } else {
	        return client.socket.emit(name, params);
	      }
	    };

	    client.on_server_event = function(name, func) {
	      client.socket.on(name, func);
	    };
	};
});