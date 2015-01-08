require(["lib/assembly", "invaders/game", "invaders/level/one"], function (Assembly, Game, LevelOne) {
  "use strict";

  return function() {
    var config = {
      width: 900,
      height: 600,
      canvas: "game_screen",
      succeeded: "/invaders/level/two",
      failed: "/lose",
      game: Game,
      level: LevelOne
    };

    return new Assembly(config);
  }();
});
