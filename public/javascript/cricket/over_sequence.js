define(['lib/extend', 'lib/notify_after'], function(extend, notify_after) {
  "use strict";

  return function(batter, bowler, field, game_behaviour, wait_for_all_factory, over_builder, sequence_factory) {
    var over_sequence = this;

    var steps = {};
    var over = over_builder.build();
    var ball_sequence = null;

		over_sequence.play = function() {
			set_field();
		};

    var set_field = function() {
      game_behaviour.start_setting_field();
      
      over.set_stage('set_field');
      //TODO: remove this field reference (don't give it to the player, but what the player interacts with. see)
			steps.set_field.start(field);
    };

    var seed_momentum = function() {
      game_behaviour.stop_setting_field();

      over.set_stage('seed_momentum');
      //TODO: remove this field reference
			steps.seed_momentum.start(field);
    };

    var draw_hand = function() {
      over.set_stage('draw_hand');
			steps.draw_hand.start();
    };

    var play_each_ball = function() {
      over.set_stage('in_progress');

  		if (over.complete()) {
				trash_cards();
				return;
			}

			new_ball();
			play_ball();
    };

    var new_ball = function() {
      ball_sequence = sequence_factory.build_ball_sequence();
			ball_sequence.on_event('complete', play_each_ball);
      over.new_ball(ball_sequence.ball);
    };

    var play_ball = function() {
      ball_sequence.play();
    };

    var trash_cards = function() {
      over.set_stage('trash_cards');
			steps.trash_cards.start();
    };

    var replenish_cards = function() {
      over.set_stage('replenish_cards');
			steps.replenish_cards.start();
    };

    var discard_hand = function() {
      over.set_stage('discard_hand');
			steps.discard_hand.start();
    };

		var complete_over = function() {
      over.set_stage('complete');
		};

    var notify_map = [
      {after: 'complete_over', emit: 'complete'}
    ];

    var init = function() {
      extend(over_sequence).
        using(notify_after, ['over_sequence', notify_map]);

      steps = {};
      steps.set_field = wait_for_all_factory.build("set_field", [bowler], "over_sequence/set_field/complete", seed_momentum);
      steps.seed_momentum = wait_for_all_factory.build("seed_momentum", [batter, bowler], "over_sequence/seed_momentum/complete", draw_hand);
        steps.draw_hand = wait_for_all_factory.build("draw_hand", [batter, bowler], "over_sequence/draw_hand/complete", play_each_ball);
      steps.trash_cards = wait_for_all_factory.build("trash_cards", [batter, bowler], "over_sequence/trash_cards/complete", replenish_cards);
      steps.replenish_cards = wait_for_all_factory.build("replenish_cards", [batter, bowler], "over_sequence/replenish_cards/complete", discard_hand);
      steps.discard_hand = wait_for_all_factory.build("discard_hand", [batter, bowler], "over_sequence/discard_hand/complete", complete_over);
    };

		init();
    return over_sequence;
  };
});
