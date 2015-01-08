requirejs = require('../../spec_helper').requirejs
cricket = require('../../stubs/cricket')
label = require('../../stubs/lib').label
ui_builder = require('../../stubs/lib').ui_builder

module_mock = require('../../stubs/module_mock')
module_mock.reset(requirejs)

display = null

scoreboard =
  player1:
    runs: "runs"
    wickets: "w"
    overs: "o"
    record: "r"
    run_rate: "rr"
  player2:
    runs: "runs2"
    wickets: "w2"
    overs: "o2"
    record: "r2"
    run_rate: "rr2"
    required_run_date: "rrr2"

ScoreboardDisplay = requirejs('cricket/ui/scoreboard_display')

describe "the scoreboard display", ->
  beforeEach ->
    module_mock.listen_for_events_on(scoreboard)
    display = new ScoreboardDisplay(scoreboard, ui_builder)

  it "should refresh the display when the scoreboard is updated", ->
    expect(scoreboard.on_event).toHaveBeenCalledWith('update', jasmine.any(Function))

describe "being refreshed", ->
  beforeEach ->
    module_mock.capture_events_on(scoreboard)
    display = new ScoreboardDisplay(scoreboard, ui_builder)
    scoreboard.test_update()

  it "should update the runs for both players", ->
    expect(label.update_text).toHaveBeenCalledWith(scoreboard.player1.runs)
    expect(label.update_text).toHaveBeenCalledWith(scoreboard.player2.runs)

  it "should update the wickets for both players", ->
    expect(label.update_text).toHaveBeenCalledWith(scoreboard.player1.wickets)
    expect(label.update_text).toHaveBeenCalledWith(scoreboard.player2.wickets)

  it "should update the overs for both players", ->
    expect(label.update_text).toHaveBeenCalledWith(scoreboard.player1.overs)
    expect(label.update_text).toHaveBeenCalledWith(scoreboard.player2.overs)

  it "should update the record for both players", ->
    expect(label.update_text).toHaveBeenCalledWith(scoreboard.player1.record)
    expect(label.update_text).toHaveBeenCalledWith(scoreboard.player2.record)

  it "should update the run rate for both players", ->
    expect(label.update_text).toHaveBeenCalledWith(scoreboard.player1.run_rate)
    expect(label.update_text).toHaveBeenCalledWith(scoreboard.player2.run_rate)

  it "should update the required run rate for both players", ->
    expect(label.update_text).toHaveBeenCalledWith(scoreboard.player2.required_run_rate)
