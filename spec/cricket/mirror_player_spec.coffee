requirejs = require('../spec_helper').requirejs

module_mock = require('../stubs/module_mock')
module_mock.reset(requirejs)

can_wire_sync = module_mock.spy_on(requirejs, 'lib/can_wire_sync')
mirror_latest = module_mock.spy_on(requirejs, 'lib/mirror_latest')
notify_after = module_mock.spy_on(requirejs, 'lib/notify_after')
become_mirror_deck = module_mock.spy_on(requirejs, 'cricket/mirror_deck')

player =
  id: 1
mirror_player = requirejs('cricket/mirror_player')

describe 'a mirror player', ->
  beforeEach ->
    player =
      id: 1
    become_mirror_deck.reset()
    mirror_player(player)

  it 'should synchronise when the server copy updates', ->
    field_map =
      momentum_card_count: 'momentum_card_count'
      max_hand_size: 'max_hand_size'
      batting: 'batting'
      cards_to_replenish: 'cards_to_replenish'
    expect(can_wire_sync).toHaveBeenCalledWith(player, '/cricket', ['player/update'], field_map, player.sync_deck_ids)

  it 'should send an updated event when synchronised', -> 
    func_event_map = [
      {after: 'synchronise', emit: 'update'}
    ]
    expect(notify_after).toHaveBeenCalledWith(player, 'mirror_player', func_event_map)

  it "should create a mirror deck for it's deck and hand", ->
    expect(player.deck).not.toBe(null)
    expect(player.hand).not.toBe(null)
    expect(become_mirror_deck.callCount).toEqual(2)

  describe 'custom sync', ->
    it 'should map the deck and hand id to the respective mirror decks', ->
      wire_data =
        deck_id: 3
        hand_id: 7
      player.sync_deck_ids(wire_data)
      expect(player.deck.source_id).toBe(3)
      expect(player.hand.source_id).toBe(7)