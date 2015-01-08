requirejs = require('../spec_helper').requirejs
asevented = require('../stubs/asevented').asevented

module_mock = require('../stubs/module_mock')
module_mock.reset(requirejs)
module_mock.stub(requirejs, 'ext/asevented', asevented)

runner = null
match =
  on_event: jasmine.createSpy('match.on_event')
  toss_coin: jasmine.createSpy('match.toss_coin')
  play: jasmine.createSpy('match.play')
field =
players =
innings =
  batter:
    on_event: jasmine.createSpy('innings.batter.on_event')
    start_new_innings: ->
  bowler:
    on_event: jasmine.createSpy('innings.bowler.on_event')
    start_new_innings: ->

SinglePlayerRunner = requirejs('cricket/single_player_runner')
describe "a single player runner", ->
  beforeEach ->
    runner = new SinglePlayerRunner(match, field, players)

  it "should start active", ->
    expect(runner.active).toBeTruthy()

  it "should play an innings when each innings in the match is created", ->
    expect(match.on_event).toHaveBeenCalledWith('new_innings', runner.play_innings)

  it "should toss the coin", ->
    expect(match.toss_coin).toHaveBeenCalled()

  it "should start the match", ->
    expect(match.play).toHaveBeenCalled()

describe "play innings", ->
  it "should create an innings sequence for the new innings", ->
    runner.play_innings(innings)
    expect(runner.innings_runner).not.toBeNull()
