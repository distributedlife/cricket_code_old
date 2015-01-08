define(['lib/extend', 'lib/will_wire_push', 'cricket/scoreboard', 'cricket/events'], 
  function(extend, will_wire_push, become_scoreboard, Events) {
  "use strict";

  var become_server_scoreboard = function(server_scoreboard, player1_innings, player2_innings) {
    server_scoreboard.update_p1_innings = function(innings) {
      server_scoreboard.update_innings(server_scoreboard.player1, innings);
    };

    server_scoreboard.update_p2_innings = function(innings) {
      server_scoreboard.update_innings(server_scoreboard.player2, innings);
    };

    server_scoreboard.update_innings = function(scoreboard_innings, innings) {
      scoreboard_innings.runs = innings.runs();
      scoreboard_innings.wickets = innings.wickets_lost();
      scoreboard_innings.overs = innings.overs_bowled();
      scoreboard_innings.record = innings.record();
      scoreboard_innings.run_rate = innings.run_rate();
      scoreboard_innings.required_run_rate = innings.required_run_rate();
    };

    var init = function() {
      player1_innings.on_event('update', server_scoreboard.update_p1_innings);
      player2_innings.on_event('update', server_scoreboard.update_p2_innings);
    };
    init(server_scoreboard, player1_innings, player2_innings)
  };

  var push_when = {
    update_innings: Events.Scoreboard.update
  };

  var push_what = {};
  ['player1', 'player2'].forEach(function(field) {
    push_what[field] = field;
  });


  return function(server_scoreboard, connection, player1_innings, player2_innings) {
    extend(server_scoreboard).
      using(become_scoreboard).
      using(become_server_scoreboard, [player1_innings, player2_innings]).
      using(will_wire_push, [connection, push_when, push_what]);
    
    
  };
});
