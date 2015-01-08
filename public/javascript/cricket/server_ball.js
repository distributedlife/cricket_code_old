define(['lib/extend', 'lib/will_wire_push', 'lib/notify_after', 'cricket/ball', 'cricket/terms', 'cricket/events'], 
  function(extend, will_wire_push, notify_after, become_ball, Terms, Events) {
  "use strict";

  var become_server_ball = function(server_ball) {
    server_ball.init = function() {
      server_ball.was_run_snuck = false;
      server_ball.was_run_cutoff = false;
    };

    server_ball.has_no_run_snuck_and_cutoff = function() {
      return !server_ball.was_run_snuck && !server_ball.was_run_cutoff;
    };

    server_ball.set_stage = function(stage) {
      server_ball.stage = stage;
    };

    server_ball.play_bowling_card = function(card) {
      server_ball.bowler_card = card;
      server_ball.length = card.length;
      server_ball.play = card.play;
    };

    server_ball.play_batting_card = function(card) {
      server_ball.batter_card = card;
      server_ball.shot = card.shot;
      server_ball.height = card.catchable;
      server_ball.distance = card.distance;
    };

    server_ball.chance_arm = function() {
      server_ball.chancing_arm = true;
      server_ball.height = Terms.Height.catchable;
    };

    server_ball.airborne_shot = function(distance) {
      server_ball.distance = distance;
      server_ball.height = Terms.Height.catchable;
    };

    server_ball.record_intermediate_result = function(result) {
      server_ball.result = result;

      if (server_ball.result === 4 || server_ball.result === 6) {
        server_ball.boundary = true;
      }
    };

    server_ball.sneak_run = function() {
      server_ball.was_run_snuck = true;

      if (server_ball.result === Terms.Balls.dot) {
        server_ball.result = Terms.Balls.one;
      } else if (server_ball.result === Terms.Balls.one) {
        server_ball.result = Terms.Balls.two;
      } else if (server_ball.result === Terms.Balls.two) {
        server_ball.result = Terms.Balls.three;
      } else if (server_ball.result === Terms.Balls.three) {
        server_ball.result = Terms.Balls.four;
      }
    };

    server_ball.cutoff_run = function() {
      server_ball.was_run_cutoff = true;

      if (server_ball.result === Terms.Balls.one) {
        server_ball.result = Terms.Balls.dot;
      } else if (server_ball.result === Terms.Balls.two) {
        server_ball.result = Terms.Balls.one;
      } else if (server_ball.result === Terms.Balls.three) {
        server_ball.result = Terms.Balls.two;
      } else if (server_ball.result === Terms.Balls.four) {
        server_ball.result = Terms.Balls.three;
      }
    };

    server_ball.finish = function() {
      server_ball.set_stage('complete');
      server_ball.complete = true;
    };
  };

  var update_funcs = [
    'set_stage', 'play_bowling_card', 'play_batting_card', 'chance_arm', 'airborne_shot',
    'record_intermediate_result', 'sneak_run', 'cutoff_run'
  ];

  var notify_map = []; 
  update_funcs.forEach(function(func) {
    notify_map.push({after: func, emit: 'update'});
  });
  notify_map.push({after: 'finish', emit: 'complete'});

  var push_fields = {};
  [
    'length', 'play', 'height', 'shot', 'distance', 'bowler_card', 'batter_card', 'result',
    'chancing_arm', 'complete', 'boundary', 'stage'
  ].forEach(function(field) {
    push_fields[field] = field;
  });

  var push_when = {
    init: Events.Ball.create,
    set_stage: Events.Ball.update,
    play_bowling_card: Events.Ball.update,
    play_batting_card: Events.Ball.update,
    chance_arm: Events.Ball.update,
    airborne_shot: Events.Ball.update,
    record_intermediate_result: Events.Ball.update,
    sneak_run: Events.Ball.update,
    cutoff_run: Events.Ball.update,
    finish: Events.Ball.complete
  };
  update_funcs.forEach(function(func) {
    push_when[func] = Events.Ball.update
  });
  push_when.init = Events.Ball.create;
  push_when.finish = Events.Ball.complete;

  return function(server_ball, connection) {
    extend(server_ball).
      using(become_ball).
      using(become_server_ball).
      using(will_wire_push, [connection, push_when, push_fields]).
      using(notify_after, ['server_ball', notify_map]);

    server_ball.init();
  };
});
