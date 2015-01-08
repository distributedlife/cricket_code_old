define(['lib/extend', 'lib/notify_after'], function(extend, notify_after) {
  "use strict";

  return function(ball_factory, wait_for_all_factory, game_behaviour, batter, bowler, field) {
    var ball_sequence = this;
    
    var steps = {};
    var ball = ball_factory.create_ball();

    ball_sequence.play = function() {
      start_of_ball();
    };

    var start_of_ball = function() {
      //TODO: get this out of here!
      ball.set_stage('start');
			steps.start_of_ball.start(ball, field);
    };

    var play_ball = function() {
      ball.set_stage('play_ball');
			steps.play_ball.start(ball, field);
    };

    var play_shot = function() {
      ball.set_stage('play_shot');
			steps.play_shot.start(ball, field);
    };

    var score_runs = function() {
      game_behaviour.score_ball(ball, field);
      sneak_runs();
    };

    var sneak_runs = function() {
      ball.set_stage('sneak_runs');
			steps.sneak_runs.start(ball);
    };

    var cutoff_runs = function() {
      ball.set_stage('cutoff_runs');
			steps.cutoff_runs.start(ball);
    };

    var move_to_next_ball = function() {
      ball.set_stage('move_to_next_ball');
			steps.move_to_next_ball.start(ball);
    };

    var record_results = function() {
      game_behaviour.complete_delivery(ball, batter, bowler);
    };

    var notify_map = [
      {after: 'record_results', emit: 'complete'}
    ];

    var init = function() {
      extend(ball_sequence).
        using(notify_after, ['ball_sequence', notify_map]);

      steps.start_of_ball = wait_for_all_factory.build("start_of_ball", [batter, bowler], "ball_sequence/start_of_ball/complete", play_ball);
      steps.play_ball = wait_for_all_factory.build("play_ball", [bowler], "ball_sequence/play_ball/complete", play_shot);
      steps.play_shot = wait_for_all_factory.build("play_shot", [batter], "ball_sequence/play_shot/complete", score_runs);
      steps.sneak_runs = wait_for_all_factory.build("sneak_runs", [batter], "ball_sequence/sneak_runs/complete", cutoff_runs);
      steps.cutoff_runs = wait_for_all_factory.build("cutoff_runs", [bowler], "ball_sequence/cutoff_runs/complete", move_to_next_ball);
      steps.move_to_next_ball = wait_for_all_factory.build("move_to_next_ball", [batter, bowler], "ball_sequence/move_to_next_ball/complete", record_results);
    };

		init();
    return ball_sequence;
  };
});
