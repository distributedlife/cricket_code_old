requirejs = require('../spec_helper').requirejs

module_mock = require('../stubs/module_mock')
module_mock.reset(requirejs)

ball = {}

can_wire_sync = module_mock.spy_on(requirejs, 'lib/can_wire_sync')
mirror_latest = module_mock.spy_on(requirejs, 'lib/mirror_latest')
notify_after = module_mock.spy_on(requirejs, 'lib/notify_after')

become_mirror_ball = requirejs('cricket/mirror_ball')

describe "a mirror ball", ->
  beforeEach ->
    ball = {}
    become_mirror_ball(ball)

  it 'should synchronise when the server copy updates', ->
    field_map =
      length: 'length'
      play: 'play'
      height: 'height'
      shot: 'shot'
      distance: 'distance'
      bowler_card: 'bowler_card'
      batter_card: 'batter_card'
      result: 'result'
      chancing_arm: 'chancing_arm'
      complete: 'complete'
      boundary: 'boundary'
      stage: 'stage'
    expect(can_wire_sync).toHaveBeenCalledWith(ball, '/cricket', ['ball/update', 'ball/complete'], field_map)

  it 'should always track the most recent ball', ->
    expect(mirror_latest).toHaveBeenCalledWith(ball, '/cricket', 'ball/create')

  it 'should send an updated event when synchronised', -> 
    func_event_map = [
      {after: 'synchronise', emit: 'update'}
    ]
    expect(notify_after).toHaveBeenCalledWith(ball, 'mirror_ball', func_event_map)
