define([], function() {
  "use strict";

  return function(scoreboard) {
    scoreboard.player1 = {
      runs: 0,
      wickets: 0,
      overs: 0,
      record: 0,
      run_rate: 0,
      required_run_rate: 0
    };

    scoreboard.player2 = {
      runs: 0,
      wickets: 0,
      overs: 0,
      record: 0,
      run_rate: 0,
      required_run_rate: 0
    };
  };
});
