define([], function() {
	"use strict";

  	var extend = function(obj) {
  		return {
	    	using: function (func, args) {
        		if (args === undefined) {
        			args = [obj];
        		} else {
          			args.unshift(obj);        			
        		}

          		func.apply(null, args);

          		return extend(obj);
        	}
        };
	};

	return extend;
});
