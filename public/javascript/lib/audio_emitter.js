define([], function() {
  "use strict";

  return function(sound_manager, id, filename) {
    var _this = this;
    _this.sound = null;
    _this.volume = 100;

    _this.loadSound = function() {
      _this.sound = sound_manager.createSound({
          id: id,
          url: filename
      });
    };

    _this.play = function(options) {
      if (typeof variable === 'undefined') {
        options = {};
      }
      options.volume = _this.volume;

      sound_manager.volume(options);

      _this.sound.play(options);
    };

    _this.stop = function() {
      _this.sound.stop();
    };

    _this.loadSound();
    
    return _this;
  };
});
