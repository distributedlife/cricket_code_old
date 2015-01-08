define(['lib/extend', 'lib/notify_after', 'lib/will_wire_push', 'lib/event_propagator', 'cricket/over', 'cricket/events'], function(extend, notify_after, will_wire_push, event_propagator, become_over, Events) {
  "use strict";

  var push_when = {
    'init': Events.Over.create,
    'new_ball': Events.Over.update,
    'set_stage': Events.Over.update,
    'propagate': Events.Over.update
  };
  var push_fields = {
    'id': 'id',
    'balls': 'balls',
    'balls_in_over': 'balls_in_over',
    'stage': 'stage'
  };
  var notify_map = [
    {after: 'init', emit: 'create'},
    {after: 'new_ball', emit: 'update'},
    {after: 'set_stage', emit: 'update'},
    {after: 'propagate', emit: 'update'},
    {after: 'check_for_complete', when: server_over.check_for_complete, emit: 'complete'}
  ];

  var become_server_over = function(server_over) {
    server_over.new_ball = function(ball) {
      ball.on_event('update', server_over.propagate);
      ball.on_event('complete', server_over.check_for_complete);

      server_over.balls.push(ball);
    };

    server_over.set_stage = function(stage) {
      server_over.stage = stage;
    };

    server_over.check_for_complete = function() {
      return server_over.complete();
    };

    server_over.init = function() {
      //This function has to exist so that the event triggers after init is complete
    };
  };

  return function (server_over, connection) {
    extend(server_over).
      using(become_over).
      using(become_server_over).
      using(event_propagator).
      using(notify_after, ['server_over', notify_map]).
      using(will_wire_push, [connection, push_when, push_fields]);

    server_over.init();
  };
});
