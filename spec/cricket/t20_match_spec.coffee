requirejs = require('../spec_helper').requirejs
asevented = require('../stubs/asevented').asevented
io = require('../stubs/socket.io').io
module_mock = require('../stubs/module_mock')
module_mock.reset(requirejs)
module_mock.stub(requirejs, 'ext/asevented', asevented)
module_mock.stub(requirejs, 'socket.io', io)

LimitedOversMatch = module_mock.spy_on(requirejs, 'cricket/limited_overs_match')

t20_match = null

T20Match = requirejs('cricket/t20_match')
describe 'a twenty20 match', ->
  beforeEach ->
    t20_match = new T20Match()

  it 'should be a limited overs match', ->
    expect(LimitedOversMatch).toHaveBeenCalled()

  it 'should limit the overs to 20', ->
    expect(t20_match.overs_per_innings).toBe(20)

  it 'should limit the wickets to 10', ->
    expect(t20_match.wickets_per_innings).toBe(10)

  it 'should have one innings', ->
    expect(t20_match.player1_innings.length).not.toBe(null)
    expect(t20_match.player2_innings.length).not.toBe(null)

    expect(t20_match.player1_innings instanceof Array).toBeFalsy()
    expect(t20_match.player2_innings instanceof Array).toBeFalsy()
