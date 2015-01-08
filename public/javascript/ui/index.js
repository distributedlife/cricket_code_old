define(["lib/window"], function(window) {
    "use strict";

    window.onblur = function () {
      //$("#game")[0].contentWindow._game.stop();
    };

    window.onfocus = function () {
      //$("#game")[0].contentWindow._game.run();
    };
}());
