requirejs = require('../spec_helper').requirejs

module_mock = require('../stubs/module_mock')
module_mock.reset(requirejs)

scoreboard = {}

can_wire_sync = module_mock.spy_on(requirejs, 'lib/can_wire_sync')
notify_after = module_mock.spy_on(requirejs, 'lib/notify_after')

become_mirror_scoreboard = requirejs('cricket/mirror_scoreboard')

describe "a mirror scoreboard", ->
  beforeEach ->
    scoreboard = {}
    become_mirror_scoreboard(scoreboard)

  it 'should synchronise when the server copy updates', ->
    field_map =
      player1: 'player1'
      player2: 'player2'
    expect(can_wire_sync).toHaveBeenCalledWith(scoreboard, '/cricket', ['scoreboard/update'], field_map)

  it 'should send an updated event when synchronised', -> 
    func_event_map = [
      {after: 'synchronise', emit: 'update'}
    ]
    expect(notify_after).toHaveBeenCalledWith(scoreboard, 'mirror_scoreboard', func_event_map)
