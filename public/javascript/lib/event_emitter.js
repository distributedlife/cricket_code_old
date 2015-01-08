define(["lib/unique", "ext/asevented"], function(unique, asEvented) {
  "use strict";

  var thing = function(slice) {
    function event_name(event) {
      return this.typename +  ":" + this.id + ":" + event;
    }

    function share_locally(name, params) {
      if (params === undefined) {
        return this.trigger(this.event_name(name));
      } else {
        return this.trigger(this.event_name(name), params);
      }
    }

    function on_event(name, callback) {
      return this.bind(this.event_name(name), callback);
    }

    function entity_name() {
      return this.typename + ":" + this.id;
    }

    return function() {
      this.id = unique.id();
      this.entity_name = entity_name;
      this.event_name = event_name;
      this.share_locally = share_locally;
      this.on_event = on_event;

      asEvented.call(this);

      return this;
    };
  }([].slice);

  return thing;
});
