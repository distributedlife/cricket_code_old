define(['cricket/innings_sequence'], function(InningsRunner) {
  "use strict";

  return function(match, field, players) {
    var _this = this;

		_this.init = function() {
			_this.active = true;
			_this.innings_runner = null;

      match.on_event('new_innings', _this.play_innings);
      match.toss_coin(players[0], players[1]);
      match.play();
    };

    _this.play_innings = function(innings) {
      _this.innings_runner = new InningsRunner(innings, field);
			_this.innings_runner.play();
    };

    _this.init();
    return _this;
  };
});
