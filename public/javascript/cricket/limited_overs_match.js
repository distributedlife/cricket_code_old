define(['lib/event_emitter'], function(EventEmitter) {
  "use strict";

  return function() {
    var _this = this;

    _this.player1_innings = null;
    _this.player2_innings = null;
    _this.batted_first = null;
    _this.wicket_per_innings = 0;
    _this.overs_per_innings = 0;
    _this.typename = 'match';

    EventEmitter.call(_this);

    _this.simulate_coin_flip = function() {
      return 'heads';
    };

    _this.toss_coin = function(p1, p2) {
      _this.batted_first = _this.simulate_coin_flip() === 'heads' ? 1 : 2;

      _this.player1_innings.batter = p1;
      _this.player1_innings.bowler = p2;

      _this.player2_innings.batter = p2;
      _this.player2_innings.bowler = p1;
    };

     _this.play = function() {
      if (_this.batted_first === 1) {
         _this.player1_innings.batter.batting = true;
         _this.player1_innings.bowler.batting = false;

         _this.share_locally('new_innings', _this.player1_innings);
       } else {
         _this.player2_innings.batter.batting = true;
         _this.player2_innings.bowler.batting = false;

         _this.share_locally('new_innings', _this.player2_innings);
       }
     };

    _this.complete = function() {
      return (_this.player1_innings.complete() && _this.player2_innings.complete());
    };

    _this.innings_complete = function(innings) {
      if (_this.complete()) {
        _this.share_locally('complete', _this);
        return;
      }

      var target = innings.runs() + 1;
      if (innings === _this.player1_innings) {
        _this.player2_innings.target = target;
        _this.player2_innings.batter.batting = true;
        _this.player2_innings.bowler.batting = false;

       _this.share_locally('new_innings', _this.player2_innings);
      } else {
        _this.player1_innings.target = target;
        _this.player1_innings.batter.batting = true;
        _this.player1_innings.bowler.batting = false;

        _this.share_locally('new_innings', _this.player1_innings);
      }
    };

    _this.new_ball = function(ball) {
      _this.share_locally('new_ball', ball);
    };

    _this.winner = function() {
      var p1 = {
        runs: _this.player1_innings.runs(),
        wickets_lost: _this.player1_innings.wickets_lost()
      };
      var p2 = {
        runs: _this.player2_innings.runs(),
        wickets_lost: _this.player2_innings.wickets_lost()
      };

      _this.determine_first_batter(p1, p2);

      return _this.determine_result(p1, p2);
    };

    _this.determine_first_batter = function(p1, p2) {
      p1.batted_first = (_this.batted_first === 1);
      p2.batted_first = !p1.batted_first;
    };

    _this.determine_result = function(p1, p2) {
      var result = null;
      if (p1.runs === p2.runs) {
        result = _this.tied_result();
      } else if (p1.runs > p2.runs) {
        result = _this.determine_margin(p1, p2);
        result.winner = 1;
      } else {
        result = _this.determine_margin(p2, p1);
        result.winner = 2;
      }

      return result;
    };

    _this.tied_result = function() {
      return {winner: 'tie'};
    };

    _this.determine_margin = function(winner, loser) {
      var margin = 0;
      var factor = '';
      if (winner.batted_first) {
        margin = winner.runs - loser.runs;
        factor = 'runs';
      } else {
        margin = _this.wickets_per_innings - winner.wickets_lost;
        factor = 'wickets';
      }

      return {margin: margin, factor: factor};
    };

    return _this;
  };
});
