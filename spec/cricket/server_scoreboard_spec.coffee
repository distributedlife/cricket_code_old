requirejs = require('../spec_helper').requirejs

module_mock = require('../stubs/module_mock')
module_mock.reset(requirejs)

scoreboard = {}
connection = {}
p1_innings = {}
p2_innings = {}
innings =
  runs: -> "5"
  wickets_lost: -> "10"
  overs_bowled: -> "3.2"
  record: -> "0.2.1.5"
  run_rate: -> "3.23"
  required_run_rate: -> "1.44"

will_wire_push = module_mock.spy_on(requirejs, 'lib/will_wire_push')

become_server_scoreboard = requirejs('cricket/server_scoreboard')

describe "a server scoreboard", ->
  beforeEach ->
    scoreboard = {}
    module_mock.capture_events_on(p1_innings)
    module_mock.capture_events_on(p2_innings)
    become_server_scoreboard(scoreboard, connection, p1_innings, p2_innings);

  it 'should push updates scoreboard the wire', ->
    push_when =
      update_innings: 'scoreboard/update'

    push_fields =
      player1: 'player1'
      player2: 'player2'

    expect(will_wire_push).toHaveBeenCalledWith(scoreboard, connection, push_when, push_fields)

describe "when p1 innings is updated", ->
  beforeEach ->
    p1_innings.test_update(innings)

  it "should set the runs", ->
    expect(scoreboard.player1.runs).toBe("5")

  it "should set the wickets lost", ->
    expect(scoreboard.player1.wickets).toBe("10")

  it "should set the overs bowled", ->
    expect(scoreboard.player1.overs).toBe("3.2")

  it "should set the innings record", ->
    expect(scoreboard.player1.record).toBe("0.2.1.5")

  it "should set the run rate", ->
    expect(scoreboard.player1.run_rate).toBe("3.23")

  it "should set the required run rate", ->
    expect(scoreboard.player1.required_run_rate).toBe("1.44")

describe "when p2 innings is updated", ->
  beforeEach ->
    p2_innings.test_update(innings)

  it "should set the runs", ->
    expect(scoreboard.player2.runs).toBe("5")

  it "should set the wickets lost", ->
    expect(scoreboard.player2.wickets).toBe("10")

  it "should set the overs bowled", ->
    expect(scoreboard.player2.overs).toBe("3.2")

  it "should set the innings record", ->
    expect(scoreboard.player2.record).toBe("0.2.1.5")

  it "should set the run rate", ->
    expect(scoreboard.player2.run_rate).toBe("3.23")

  it "should set the required run rate", ->
    expect(scoreboard.player2.required_run_rate).toBe("1.44")
