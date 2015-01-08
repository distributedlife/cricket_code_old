requirejs = require('../spec_helper').requirejs

module_mock = require('../stubs/module_mock')
module_mock.reset(requirejs)

player = {}

become_player = requirejs('cricket/player')

Player = requirejs('cricket/player')
describe 'a player', ->
  beforeEach ->
    player = {}
    become_player(player)

  it 'should not be human by default', ->
    expect(player.is_human()).toBeFalsy()

  it 'should be an AI by default', ->
    expect(player.is_ai()).toBeTruthy()

  describe 'momentum', ->
    it 'should return the momentum count', ->
      player.momentum_card_count = 1
      expect(player.momentum()).toBe(1)

  describe 'has momentum', ->
    it 'should return true if the player has more than zero momentum', ->
      player.momentum_card_count = 1
      expect(player.has_momentum()).toBeTruthy()

    it 'should return false otherwise', ->
      player.momentum_card_count = 0
      expect(player.has_momentum()).toBeFalsy()
      player.momentum_card_count = -1
      expect(player.has_momentum()).toBeFalsy()

  it "can be batting", ->
    player.batting = true
    expect(player.is_batting()).toBeTruthy()
    expect(player.is_bowling()).toBeFalsy()

  it "can be bowling", ->
    player.batting = false
    expect(player.is_batting()).toBeFalsy()
    expect(player.is_bowling()).toBeTruthy()

  it "is possible to check if not cards are to be replenished", ->
    player.cards_to_replenish = 0
    expect(player.no_cards_to_be_replenished()).toBeTruthy()
    player.cards_to_replenish = 1
    expect(player.no_cards_to_be_replenished()).toBeFalsy()
