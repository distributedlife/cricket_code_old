define(['cricket/terms', 'cricket/server_player', 'lib/event_emitter'], function(Terms, ServerPlayer, EventEmitter) {
  "use strict";

  return function(fielding_ai, bowling_ai, batting_ai) {
    var _this = new ServerPlayer();

		_this.init = function() {
			_this.risk_appetite = 0;
			_this.desired_run_rate = 6.0;

			_this.typename = "ai";
			EventEmitter.call(_this);
		};

    _this.set_field = function(field) {
      fielding_ai.set_field(field, _this);
			_this.share_locally('player/over/set_field/complete');
    };


    _this.play_ball = function(ball) {
      bowling_ai.play_ball(ball, _this);
			_this.share_locally('player/ball/play_ball/complete');
    };

    _this.restrict_runs_momentum = function(ball) {
      bowling_ai.restrict_runs.momentum(ball, _this);
			_this.share_locally('player/ball/restrict_runs_momentum/complete');
    };


    _this.play_shot = function(ball, field) {
      batting_ai.play_shot(ball, field, _this);
			_this.share_locally('player/ball/play_shot/complete');
    };

    _this.add_runs_momentum = function(ball) {
      batting_ai.add_runs_momentum(ball, _this);
			_this.share_locally('player/ball/add_runs_momentum/complete');
    };


    _this.trash_cards = function() {
      //very basic trash left over cards
      while(!_this.hand.empty()) {
        var card = _this.hand.top_card();
        if (card.length === Terms.Length.full) {
          _this.supply.full_deck.discard(card);
          card = _this.supply.full_deck.draw();
        }
        if (card.length === Terms.Length.good) {
          _this.supply.good_deck.discard(card);
          card = _this.supply.good_deck.draw();
        }
        if (card.length === Terms.Length.short) {
          _this.supply.short_deck.discard(card);
          card = _this.supply.short_deck.draw();
        }
        if (card.length === Terms.Length.bouncer) {
          _this.supply.bouncer_yorker_deck.discard(card);
          card = _this.supply.bouncer_yorker_deck.draw();
        }
        if (card.length === Terms.Length.yorker) {
          _this.supply.bouncer_yorker_deck.discard(card);
          card = _this.supply.bouncer_yorker_deck.draw();
        }
        _this.deck.discard(card);
      }

			_this.share_locally('player/over/trash_cards/complete');
    };

    _this.init();
    return _this;
  };
});
