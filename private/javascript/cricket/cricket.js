module.exports = function(io) {
  var bounce_event = function(socket, event) {
    socket.on(event, function(data) {
      socket.emit(event, data);
    });
  };

	io.of('/cricket').on('connection', function(socket) {
    var player_events = {};
    [
      'start_of_ball', 'play_shot', 'play_ball', 'update', 'user_buy_cards', 'buy_cards', 'user_sneak_run', 'user_cutoff_run', 'user_chance_arm', 'can_chance_arm', 'can_not_chance_arm', 'stop_trashing_card_phase', 'user_finish_buying_cards', 'user_finish_trashing_cards', 'user_start_buying', 'buy_card_update', 'trashed_card_replaced', 'card_trashed', 'add_runs_momentum', 'restrict_runs_momentum', 'move_to_next_ball', 'trash_cards', 'user_wants_to_end_delivery', 'reset_selected_card', 'user_selected_card', 'user_leave_ball', 'user_play_selected_card'
    ].forEach(function(event) {
      var namespaced_event = "player/" + event;
      player_events[event] = namespaced_event;
      bounce_event(socket, namespaced_event);
    });

    var field_events = {};
		[
			'update', 'toggle_fielder', 'start_setting_field', 'user_has_finished_setting_field', 'finish_setting_field'
		].forEach(function(event) {
      var namespaced_event = "field/" + event;
      field_events[event] = namespaced_event;
      bounce_event(socket, namespaced_event);
    });

    var scoreboard_events = ['update'];
    scoreboard_events.forEach(function(message) {
      socket.on("scoreboard/" + message, function(data) {
        socket.emit("scoreboard/" + message, data);
      });
    });

    var supply_events = ['update', 'card_bought_by_player', 'buy_card'];
    supply_events.forEach(function(message) {
      socket.on("supply/" + message, function(data) {
        socket.emit("supply/" + message, data);
      });
    });

    var deck_events = ['update'];
    deck_events.forEach(function(message) {
      socket.on("deck/" + message, function(data) {
        socket.emit("deck/" + message, data);
      });
    });

    var hand_events = ['play_card', 'trash_card'];
    hand_events.forEach(function(message) {
      socket.on("hand/" + message, function(data) {
        socket.emit("hand/" + message, data);
      });
    });

    var ball_events = ['update', 'complete', 'create'];
		ball_events.forEach(function(message) {
			socket.on("ball/" + message, function(data) {
				socket.emit("ball/" + message, data);
			});
		});

		var game_events = ['setup'];
		game_events.forEach(function(message) {
			socket.on("game/" + message, function(data) {
				socket.emit("game/" + message, data);
			});
		});
	});
};
