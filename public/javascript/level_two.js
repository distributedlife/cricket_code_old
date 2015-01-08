require(["lib/assembly", "invaders/game", "invaders/level/two"], function (Assembly, Game, LevelTwo) {
  "use strict";

  return function() {
    var config = {
      width: 900,
      height: 600,
      canvas: "game_screen",
      succeeded: "/win",
      failed: "/lose",
      game: Game,
      level: LevelTwo
    };

    return new Assembly(config);
  }();
});
