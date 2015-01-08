define(["socket.io"], function(io) {
  "use strict";

  var thing = function(slice) {
    function share_remotely(name, params) {
      if (params === undefined) {
        return this.socket.emit(name);
      } else {
        return this.socket.emit(name, params);
      }
    }

    function on_remote_event(name, callback) {
      return this.socket.on(name, callback);
    }

    return function() {
      this.socket = io.connect('/cricket');

      this.share_remotely = share_remotely;
      this.on_remote_event = on_remote_event;

      return this;
    };
  }([].slice);

  return thing;
});

