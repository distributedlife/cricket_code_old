define(function() {
  "use strict";

  return function(things) {
    var _this = this;

    _this.update = function(dt, input) {
      things.forEach(function(thing) {
        thing.update_if_active(dt, input);
      });
    };

    return _this;
  };
});
