define(['lib/extend', 'lib/notify_after'], function(extend, notify_after) {
  "use strict";

  return function(innings, field, sequence_factory, wait_for_all_factory) {
    var innings_sequence = this;
    var over_sequence = null;
    var steps = {};

		innings_sequence.play = function() {
      start_new_innings();
		};

    var start_new_innings = function() {
			steps.start_new_innings.start(innings);
    };

    var play_each_over = function() {
			if (innings.complete()) {
				complete();
				return;
			}

			new_over();
			play_over();
    };

    var new_over = function() {
      over_sequence = sequence_factory.build_over_sequence(innings.batter, innings.bowler);
			over_sequence.on_event('complete', play_each_over);
      innings.new_over(over_sequence.over);
    };

    var play_over = function() {
      over_sequence.play();
    };

    var complete = function() {};

    var notify_map = [
    	{after: 'complete', emit: 'complete'}
    ];

		var init = function() {
			extend(innings_sequence).
				using(notify_after, ['innings_sequence', notify_map])

			steps.start_new_innings = wait_for_all_factory.build("start_new_innings", [innings.batter, innings.bowler], "innings_sequence/start_new_innings/complete", play_each_over);
		};

		init();
    return innings_sequence;
  };
});
