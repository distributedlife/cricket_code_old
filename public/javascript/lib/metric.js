define(["ext/websocket", "lib/config"], function(WebSocket, config) {
  "use strict";

  return function() {
    var SocketOpen = 1;
    var ws = new WebSocket(config.metric_server);
  
    this.post = function(name, json) {
      if (ws.readyState !== SocketOpen) {
        return;
      }

      var packet = {type: name, time: new Date(), data: json};
    
      ws.send(JSON.stringify(packet));
    };
  };
});
