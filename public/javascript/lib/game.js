define(["lib/window", "ext/atom", "lib/config", "lib/metric", "lib/sound_manager2", "ext/gamepad"],
  function(window, Atom, config, Metric, SoundManager, Gamepad) {
  "use strict";

  return function(sound_manager) {
    var _this = this;

    _this.input = new Atom();
    var metric = new Metric();
    _this.gamepad = Gamepad;
    _this.game_logic = null;
    _this.sound_manager = sound_manager;
    _this.last_step = Date.now();
    _this.scene_renderer = null;
    _this.running = false;

    _this.start = function() {
      _this.running = true;
      _this.loop();
    };

    _this.loop = function() {
      if (!_this.running) {
        return;
      }

      _this.step();
      _this.input.clearPressed();
      _this.scene_renderer.animate();
      window.request_animation_frame(_this.loop);
    };

    _this.stop = function() {
      _this.running = false;
    };

    _this.step = function() {
      var now = Date.now();
      var dt = (now - _this.last_step) / 1000;
      _this.last_step = now;
      _this.update(dt * config.global_time_dilation);
    };

    _this.update = function(dt) {
      _this.input.pads = _this.gamepad.getStates();
      _this.game_logic.update(dt, _this.input);
    };

    return _this;
  };
});
