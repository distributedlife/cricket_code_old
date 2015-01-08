define(["lib/window", "lib/game", "cricket/game_logic", "lib/scene_renderer"],
  function(window, Game, GameLogic, SceneRenderer)
  {
    "use strict";

    return function(level, element, width, height, sound_manager) {
      var _this = new Game(level);

      _this.init = function() {
        _this.input.bind(_this.input.key.RIGHT_ARROW, "right");

        _this.scene_renderer = new SceneRenderer(element, level.scene, level.camera);
        _this.scene_renderer.resize(width, height);

        _this.input.bind_to_canvas(window.document, window);

        _this.game_logic = new GameLogic(level.things);
      };

      return _this;
    };
});
