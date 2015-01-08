define(['cricket/over', 'cricket/server_supply', 'lib/event_emitter', 'cricket/scorer'], function(Over, ServerSupply, EventEmitter, Scorer) {
  "use strict";

  return function(over_limit, wickets) {
    var _this = this;

    _this.over_limit = over_limit;
    _this.wickets = wickets;
    _this.current_over = null;
    _this.overs = [];
    _this.balls_per_over = 6;
    _this.typename = 'innings';
    _this.target = null;
    _this.batter = null;
    _this.bowler = null;
    _this.supply = new ServerSupply();
    _this.scorer = new Scorer(_this.supply.chance_your_arm_deck);

    EventEmitter.call(_this);

    _this.runs = function() {
      return _this.overs.map(function(over) {
        return over.runs();
      }).reduce(function(total, over) {
        return total + over;
      }, 0);
    };

    _this.wickets_lost = function() {
      return _this.overs.map(function(over) {
        return over.wickets();
      }).reduce(function(total, over) {
        return total + over;
      }, 0);
    };

		_this.record = function() {
			return _this.overs.map(function(over) {
				return over.record();
			}).join(' ');
		};

    _this.run_rate = function() {
      return (_this.runs() / _this.legitimate_balls_faced() * _this.balls_per_over).toFixed(2);
    };

    _this.required_run_rate = function(balls_faced) {
      var remaining_runs = _this.target - _this.runs();
      var balls_in_innings = _this.over_limit * _this.balls_per_over;
      var balls_remaining = balls_in_innings - _this.legitimate_balls_faced();
      return (remaining_runs / balls_remaining * _this.balls_per_over).toFixed(2);
    };

    _this.overs_bowled = function() {
      var complete = _this.overs.filter(function(over) { return over.complete(); });
      var incomplete = _this.overs.filter(function(over) {return over.in_progress(); });

      return complete.length + (incomplete.map(function(over) { return over.balls_bowled(); }) / 10);
    };

    _this.legitimate_balls_faced = function() {
      var complete = _this.overs.filter(function(over) {
        return over.complete();
      }).reduce(function(total, over) {
        return total + _this.balls_per_over;
      }, 0);

      var incomplete = _this.overs.filter(function(over) {
        return !over.complete();
      }).reduce(function(total, over) {
        return total + over.balls_bowled();
      }, 0);

      return complete + incomplete;
    };

    _this.in_progress = function() {
      return !_this.complete();
    };

    _this.complete = function() {
      if (_this.target !== null) {
        if (_this.runs() >= _this.target) {
          return true;
        }
      }

      if (_this.wickets_lost() === _this.wickets) {
        return true;
      }

      return (_this.overs_bowled() === _this.over_limit);
    };

    _this.has_updated = function() {
      _this.share_locally('update', _this);

      if (_this.complete()) {
        _this.share_locally('complete', _this);
      }
    };

    _this.new_over = function(over) {
      over.on_event('update', _this.has_updated) ;
      over.on_event('complete', _this.has_updated) ;

      _this.current_over = over;
      _this.overs.push(over);

      _this.share_locally('new_over', over);
    };

    return this;
  };
});
