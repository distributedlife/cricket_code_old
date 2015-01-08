requirejs = require('../spec_helper').requirejs

module_mock = require('../stubs/module_mock')
module_mock.reset(requirejs)

supply = {}
data =
  full_deck_size: "full deck size"
  good_deck_size: "good deck size"
  short_deck_size: "short deck size"
  bouncer_yorker_deck_size: "bouncer yorker deck size"
  chance_your_arm_deck_size: "chance your arm deck size"

can_wire_sync = module_mock.spy_on(requirejs, 'lib/can_wire_sync')
notify_after = module_mock.spy_on(requirejs, 'lib/notify_after')

become_mirror_supply = requirejs('cricket/mirror_supply')

describe 'a mirror supply', ->
  beforeEach ->
    supply = {}
    become_mirror_supply(supply)

  it 'should synchronise when the server copy updates', ->
    field_map =
      full_deck_size: 'full_deck_size'
      good_deck_size: 'good_deck_size'
      short_deck_size: 'short_deck_size'
      bouncer_yorker_deck_size: 'bouncer_yorker_deck_size'
      chance_your_arm_deck_size: 'chance_your_arm_deck_size'
    expect(can_wire_sync).toHaveBeenCalledWith(supply, '/cricket', ['supply/update'], field_map)

  it 'should send an updated event when synchronised', -> 
    func_event_map = [
      {after: 'synchronise', emit: 'update'}
    ]
    expect(notify_after).toHaveBeenCalledWith(supply, 'mirror_supply', func_event_map)
