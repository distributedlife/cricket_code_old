requirejs = require('../spec_helper').requirejs

module_mock = require('../stubs/module_mock')
module_mock.reset(requirejs)

can_wire_sync = module_mock.spy_on(requirejs, 'lib/can_wire_sync')
notify_after = module_mock.spy_on(requirejs, 'lib/notify_after')

deck = null
data =
  cards: "cards"
  discards: "discards"

become_mirror_deck = requirejs('cricket/mirror_deck')

describe 'a mirror deck', ->
  beforeEach ->
    deck = {}
    become_mirror_deck(deck)

  it 'should synchronise when the server copy updates', ->
    field_map =
      cards: 'cards'
      discards: 'discards'
    expect(can_wire_sync).toHaveBeenCalledWith(deck, '/cricket', 'deck/update', field_map)

  it 'should send an updated event when synchronised', -> 
    func_event_map = [
      {after: 'synchronise', emit: 'update'}
    ]
    expect(notify_after).toHaveBeenCalledWith(deck, 'mirror_deck', func_event_map)