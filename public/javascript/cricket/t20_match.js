define(["cricket/limited_overs_match", "cricket/innings"], function(LimitedOversMatch, Innings) {
  "use strict";

  return function() {
    var _this = new LimitedOversMatch();

    _this.overs_per_innings = 20;
    _this.wickets_per_innings = 10;

    _this.player1_innings = new Innings(_this.overs_per_innings, _this.wickets_per_innings);
    _this.player1_innings.on_event('new_ball', _this.new_ball);
    _this.player1_innings.on_event('complete', _this.innings_complete);

    _this.player2_innings = new Innings(_this.overs_per_innings, _this.wickets_per_innings);
    _this.player2_innings.on_event('new_ball', _this.new_ball);
    _this.player2_innings.on_event('complete', _this.innings_complete);

    return _this;
  };
});
