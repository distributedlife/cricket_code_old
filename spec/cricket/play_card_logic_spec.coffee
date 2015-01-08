requirejs = require('../spec_helper').requirejs

module_mock = require('../stubs/module_mock')
module_mock.reset(requirejs)

card = "card"
player =
  hand:
    remove_by_index: jasmine.createSpy('player.hand.remove_by_index').andReturn([card])
  deck:
    discard: jasmine.createSpy('player.deck.discard')

become_play_card_logic = requirejs('cricket/play_card_logic')

describe "the play card player_action", ->
  player_action = null
  
  beforeEach ->
    player_action = {}
    become_play_card_logic(player_action)

  describe "when the player plays a card", ->
    index = 3

    beforeEach ->
      player_action.play_card(index, player)

    it "should remove the card from the player's hand", ->
      expect(player.hand.remove_by_index).toHaveBeenCalledWith(3)

    it "should add the card to the player's discard pile", ->
      expect(player.deck.discard).toHaveBeenCalledWith("card")
