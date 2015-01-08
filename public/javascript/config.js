require.config({
    paths: {
      "socket.io": "../../socket.io/socket.io"
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
