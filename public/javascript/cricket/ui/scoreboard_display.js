define([], function() {
  "use strict";

  return function(scoreboard, ui_builder) {
    var team_a_runs = ui_builder.build_label("innings1_team_a_runs");
    var team_a_wickets = ui_builder.build_label("innings1_team_a_wickets");
    var team_a_overs = ui_builder.build_label("innings1_team_a_overs");
    var team_a_record = ui_builder.build_label("innings1_team_a_record");
    var team_a_run_rate = ui_builder.build_label("innings1_team_a_run_rate");

    var team_b_runs = ui_builder.build_label("innings1_team_b_runs");
    var team_b_wickets = ui_builder.build_label("innings1_team_b_wickets");
    var team_b_overs = ui_builder.build_label("innings1_team_b_overs");
    var team_b_record = ui_builder.build_label("innings1_team_b_record");
    var team_b_run_rate = ui_builder.build_label("innings1_team_b_run_rate");
    var team_b_required_run_rate = ui_builder.build_label("innings1_team_b_required_run_rate");

    var init = function() {
      scoreboard.on_event('update', refresh);
    };

    var refresh = function() {
      team_a_runs.update_text(scoreboard.player1.runs);
      team_a_wickets.update_text(scoreboard.player1.wickets);
      team_a_overs.update_text(scoreboard.player1.overs);
      team_a_record.update_text(scoreboard.player1.record);
      team_a_run_rate.update_text(scoreboard.player1.run_rate);

      team_b_runs.update_text(scoreboard.player2.runs);
      team_b_wickets.update_text(scoreboard.player2.wickets);
      team_b_overs.update_text(scoreboard.player2.overs);
      team_b_record.update_text(scoreboard.player2.record);
      team_b_run_rate.update_text(scoreboard.player2.run_rate);
      team_b_required_run_rate.update_text(scoreboard.player2.required_run_rate);
    };

    init();
  };
});

