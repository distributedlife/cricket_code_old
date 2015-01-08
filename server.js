var express = require('express');
var app = express(express.logger());
var server = require('http').createServer(app);
var io = require('socket.io').listen(server);

var fs = require('fs');
var engines = require('consolidate');


require('./routes/shared.js')(app);
require('./routes/invaders.js')(app);
require('./routes/arkanoid.js')(app);
require('./routes/cricket.js')(app);

require('./private/javascript/cricket/cricket.js')(io);


var requirejs = require('requirejs');
requirejs.config({
  baseUrl: __dirname + '/public/javascript',
  nodeRequire: require,
  paths: {
    "socket.io": "/socket.io/socket.io"
  },
  shim: {
    'ext/asevented': {
      init: function() {
        "use strict";
        return this.asEvented;
      }
    },
    'ext/gamepad': {
      init: function() {
        "use strict";
        return this.Gamepad;
      }
    },
    'ext/three': {
      init: function() {
        "use strict";
        return this.THREE;
      }
    },
    'ext/websocket': {
      init: function() {
        "use strict";
        return this.WebSocket;
      }
    },
    'ext/window': {
      init: function() {
        "use strict";
        return this.window;
      }
    },
    'ext/soundmanager2-nodebug-jsmin': {
      deps: ['ext/window'],
      init: function() {
        "use strict";
        return this.SoundManager;
      }
    },
    'ext/zepto.min': {
      init: function() {
        "use strict";
        return this.$;
      }
    }
  }
});
// var HumanPlayer = requirejs('cricket/human_player');
// var human = new HumanPlayer();

app.use('/public', express.static(__dirname + '/public'));
app.set('view options', {layout: false});

app.engine('haml', engines.haml);

var port = process.env.PORT || 3000;
server.listen(port);

