define(["lib/window"], function (window) {
  "use strict";

  return function(config) {
    var assembly = this;

    assembly.succeeded = function() {
      window.load_page(config.succeeded);
    };

    assembly.failed = function() {
      window.load_page(config.failed);
    };

    var sound_manager = new SoundManager();
    assembly.level = new config.level(config.width, config.height, sound_manager);
    assembly.level.on_event("failure", assembly.failed);
    assembly.level.on_event("complete", assembly.succeeded);

    assembly.element = window.get_element_by_id(config.canvas);

    assembly.game = new config.game(assembly.level, assembly.element, config.width, config.height, sound_manager);
    assembly.game.start();

    return assembly;
  };
});
