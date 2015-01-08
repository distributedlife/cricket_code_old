requirejs = require('../spec_helper').requirejs

module_mock = require('../stubs/module_mock')
module_mock.reset(requirejs)

player_action = {}
player =
  hand:
    remove_by_index: jasmine.createSpy('hand.remove_by_index')
  increment_replenish_count: jasmine.createSpy('player.increment_replenish_count')

become_trash_card_player_action = requirejs('cricket/trash_card_logic')

describe "the trash card player action", ->
  player_action = null

  beforeEach ->
    player_action = {}
    become_trash_card_player_action(player_action)

  describe "when the player trashes a card", ->
    index = 2;

    beforeEach ->
      player_action.trash_card(index, player)

    it "should remove the card from the hand", ->
      expect(player.hand.remove_by_index).toHaveBeenCalledWith(2)

    it "should increment the replenish count ", ->
      expect(player.increment_replenish_count).toHaveBeenCalled()
