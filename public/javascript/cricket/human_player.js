define(['cricket/server_player', 'cricket/terms', 'cricket/socket', 'lib/event_emitter'],
       function(ServerPlayer, Terms, Socket, EventEmitter) {
  "use strict";

  return function() {
    var _this = new ServerPlayer();

		_this.typename = "player";
		EventEmitter.call(_this);

    _this.is_human = function() {
      return true;
    };

    /*
     * UI Callbacks
     */
    _this.play_selected_card = function(card, index) {
      _this.card_played = true;

      if (card === "leave ball") {
        _this.reset_selected_card();
        _this.share_locally('player/ball/play_shot/complete');
        return;
      }

      if (_this.batting) {
        _this.ball.play_batting_card(card);
        _this.share_locally('player/ball/play_shot/complete');
      } else{
        _this.ball.play_bowling_card(card);
      }

      _this.share_remotely('hand/play_card', index);

      _this.reset_selected_card();
    };

    _this.reset_selected_card = function() {
      _this.card = null;
      _this.selected_index = null;

      _this.share_remotely('player/can_not_chance_arm');
      _this.share_remotely('player/reset_selected_card');
    };

    _this.chance_arm = function() {
      _this.share_remotely('player/can_not_chance_arm');

      _this.use_momentum();
      //TODO: the card, index here needs to come from the hand_display; consider merging chance arm button
      // and hand display
      _this.play_selected_card(_this.card, _this.selected_index);
      _this.ball.chance_arm();
    };

    _this.sneak_run = function() {
      _this.use_momentum();
      _this.ball.sneak_run();

			_this.share_locally("player/ball/sneak_runs/complete");
    };

    _this.cutoff_run = function() {
      _this.use_momentum();
      _this.ball.cutoff_run();

			_this.share_locally("player/ball/cutoff_runs/complete");
    };

    _this.complete_this_delivery = function() {
			_this.share_locally("player/ball/move_to_next_ball/complete");
    };

    _this.pay_for_card_from_supply = function() {
      if (_this.trash_card_state === "buying") {
        _this.share_remotely('player/trashed_card_replaced');
      } else {
        _this.use_momentum();
      }
    };

    /*
     * Stuff
     */
    _this.card_played = false;
    _this.ball = null;
    _this.end_of_ball = false;//to delete

    _this.index = null;

    _this.trash_card_state = "pending";

    _this.init = function() {
      Socket.call(_this);

      _this.on_remote_event('field/start_setting_field', function() {
        _this.use_momentum();
				_this.paid_for = true;
      });
      _this.on_remote_event('field/user_has_finished_setting_field', function() {
        _this.share_remotely('field/finish_setting_field');
			
				if (_this.paid_for) {
					_this.share_locally('player/interupt/set_field/complete');
				} else {
					_this.share_locally('player/over/set_field/complete');
				}
      });

      _this.on_remote_event('supply/card_bought_by_player', _this.pay_for_card_from_supply);

      _this.on_remote_event('player/user_wants_to_end_delivery', _this.complete_this_delivery);
      _this.on_remote_event('player/user_sneak_run', _this.sneak_run);
      _this.on_remote_event('player/user_cutoff_run', _this.cutoff_run);
      _this.on_remote_event('player/user_chance_arm', _this.chance_arm);

      _this.on_remote_event('player/user_start_buying', function(data) {
        _this.trash_card_state = "buying";
        _this.share_remotely('player/buy_cards');
      });
      _this.on_remote_event('player/user_finish_buying_cards', function(data) {
        _this.trash_card_state = "pending";
        _this.share_remotely('player/stop_trashing_card_phase');
        _this.share_locally('player/over/trash_cards/complete');
      });

      _this.on_remote_event('player/user_selected_card', function(data) {
        _this.card = data.card;
        _this.selected_index = data.index;

        _this.show_selected_card(data.card, data.index);
      });
      _this.on_remote_event('player/user_play_selected_card', function(data) {
        _this.play_selected_card(data.card, data.index);
      });
      _this.on_remote_event('player/user_leave_ball', function(data) {
        _this.play_selected_card("leave ball");
      });
    };

    _this.is_delivery_complete = function() {
      return _this.end_of_ball;
    };

    /*
     * Show card selected by user
     */
    _this.show_selected_card = function(card, index) {
      if (_this.trash_card_state === "trashing") {
        if (card) {
          var last_card = (_this.hand.size() === 1);

          _this.share_remotely('hand/trash_card', index);
          _this.share_remotely('player/card_trashed');
          _this.reset_selected_card();

          if (last_card) {
            _this.trash_card_state = "buying";
            _this.share_remotely('player/buy_cards');
          }
        }

        return;
      }

      if (card) {
        if (card.shot !== Terms.Shots.block) {
          _this.share_remotely('player/can_chance_arm');
        }
      } else {
        _this.share_remotely('player/can_not_chance_arm');
      }
    };

    /*
     * Sequence Callbacks
     */
    _this.set_field = function(field) {
			_this.paid_for = false;
			_this.share_remotely('field/start_setting_field');
    };


    _this.start_of_ball = function(ball, field) {
      _this.ball = ball;

      _this.reset_selected_card();
      _this.share_remotely('player/start_of_ball');

      _this.card_played = false;

      _this.trash_card_state = "pending";

			_this.share_locally("player/ball/start_of_ball/complete");
    };


    _this.play_shot = function(ball, field) {
      _this.ball = ball;
      _this.share_remotely('player/play_shot');
    };


    _this.play_ball = function(ball, field) {
      _this.ball = ball;
      _this.share_remotely('player/play_ball');

      if (_this.finished_setting_field === true) {
        _this.finished_setting_field = null;
      }
      if (_this.finished_setting_field === false) {
        return false;
      }

      return _this.card_played;
    };


    _this.add_runs_momentum = function(ball) {
      _this.ball = ball;

      _this.share_remotely('player/add_runs_momentum');
    };


    _this.restrict_runs_momentum = function(ball) {
      _this.ball = ball;

      _this.share_remotely('player/restrict_runs_momentum');
    };


    _this.move_to_next_ball = function(ball) {
      _this.ball = ball;

      _this.share_remotely('player/move_to_next_ball');

      if (ball.is_no_shot_being_played()) {
        _this.share_locally('player/ball/move_to_next_ball/complete');
      }
    };


    _this.trash_cards = function() {
      //if (_this.trash_card_state === "pending") {
      _this.trash_card_state = "trashing";
      _this.share_remotely('player/trash_cards');
      //}
      //if (_this.hand.empty()) {
      //  _this.trash_card_state = "buying";
      //  _this.share_remotely('player/buy_cards');
      //}
      //if (_this.trash_card_state === "buying") {
      //  _this.share_remotely('player/buy_card_update');
      //}
      //if (_this.trash_card_state === "stopped") {
      //  _this.trash_card_state = "pending";
      //  _this.share_remotely('player/stop_trashing_card_phase');
      //  return true;
      //}

      //return false;
    };

    _this.init();
    return _this;
  };
});
