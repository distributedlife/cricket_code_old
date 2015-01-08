define(["lib/unique", "ext/asevented"], function(unique, asEvented) {
	"use strict";

	return function(obj, typename, notify_hashes) {
		obj.id = unique.id();
		obj.typename = typename

		notify_hashes.forEach(function(notify_hash) {
			var original = obj[notify_hash.after];

			obj[notify_hash.after] = function() {
				var ret = original.apply(null, arguments);
		      	if (notify_hash.when !== undefined) {
		      		if (!notify_hash.when()) {
		      			return ret;
		      		}
		      	}

		      	obj.share_locally(notify_hash.event, obj);

		      	return ret;
		    };
		});

		var event_name = function(event) {
			return obj.entity_name() + ":" + event;
		};

		obj.share_locally = function(name, params) {
			if (params === undefined) {
		    	return obj.trigger(event_name(name));
		   	} else {
		        return obj.trigger(event_name(name), params);
		    }
		}

		obj.on_event = function(name, func) {
	      return obj.bind(event_name(name), func);
	    }

	    obj.entity_name = function() {
	      return obj.typename + ":" + obj.id;
	    }

		asEvented.call(obj);
  	};
});