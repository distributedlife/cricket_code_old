define(['cricket/innings_sequence', 'cricket/terms'], function(InningsRunner, Terms) {
  "use strict";

  return function(match, field, players) {
    var _this = this;
    _this.innings_runner = null;

    _this.run = function() {
      match.on_event('new_innings', _this.play_innings);
      match.toss_coin(players[0], players[1]);
      match.play();
    };

    _this.play_innings = function(innings) {
      _this.innings_runner = new InningsRunner(innings, field);

      while(innings.in_progress()) {
        _this.innings_runner.play();
      }
    };

    /*
     * Simulator result display functions
     */
    _this.results = function() {
      var results = {};

      results.p1 = _this.innings_results(match.player1_innings);
      results.p2 = _this.innings_results(match.player2_innings);
			
      return results;
    };

    _this.innings_results = function(innings) {
			var results = {};

      results.runs = innings.runs();
      results.wickets = innings.wickets_lost();
      results.overs = [];
      results.runs_off_delivery = {};
      for (var score in Terms.Score) {
        if (Terms.Score.hasOwnProperty(score)) {
          results.runs_off_delivery[score] = 0;
        }
      }
      innings.overs.forEach(function(over) {
        var balls = "";
        over.balls.forEach(function(ball) {
          balls += ball._result;
          results.runs_off_delivery[ball._result] += 1;
        });
        results.overs.push(balls);
      });
      results.overs_bowled = innings.overs_bowled();
      results.run_rate = innings.run_rate();

      return results;
    };

    return _this;
  };
});
