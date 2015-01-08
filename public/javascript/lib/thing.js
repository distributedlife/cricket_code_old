define([], function() {
  "use strict";

  var thing = function(slice) {
    var active = false;

    function update(delta) {
    }

    function update_if_active(delta, input) {
      if (!this.active) {
        return;
      }

      this.update(delta, input);
    }

    return function() {
      this.update_if_active = update_if_active;
      this.update = update;

      return this;
    };
  }([].slice);

  return thing;
});
