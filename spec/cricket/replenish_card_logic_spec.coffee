requirejs = require('../spec_helper').requirejs

module_mock = require('../stubs/module_mock')
module_mock.reset(requirejs)

player_action = {}
player =
  hand:
    add: jasmine.createSpy('hand.add')
  decrement_replenish_count: jasmine.createSpy('player.decrement_replenish_count')
match = {}

become_replenish_card_player_action = requirejs('cricket/replenish_card_logic')

Terms = requirejs('cricket/terms')
describe "the replenish card player action", ->
  beforeEach ->
    module_mock.capture_events_on(match)
    become_replenish_card_player_action(player_action, match);
    player_action.supply = 
      full_deck:
        draw: jasmine.createSpy("full_deck.draw").andReturn("card a")
      good_deck:
        draw: jasmine.createSpy("good_deck.draw").andReturn("card b")
      short_deck:
        draw: jasmine.createSpy("short_deck.draw").andReturn("card c")
      bouncer_yorker_deck:
        draw: jasmine.createSpy("bouncer_yorker_deck.draw").andReturn("card d")

  describe "when the player acquire a card from the supply", ->
    beforeEach ->
      player_action.replenish_card(Terms.Length.full, player)

    it "should draw a card from the appropriate deck", ->
      expect(player_action.supply.full_deck.draw).toHaveBeenCalled()

      player_action.replenish_card(Terms.Length.good, player)
      expect(player_action.supply.good_deck.draw).toHaveBeenCalled()

      player_action.replenish_card(Terms.Length.short, player)
      expect(player_action.supply.short_deck.draw).toHaveBeenCalled()

      player_action.replenish_card(Terms.Length.bouncer+Terms.Length.yorker, player)
      expect(player_action.supply.bouncer_yorker_deck.draw).toHaveBeenCalled()

    it "should add the card to the players hand", ->
      expect(player.hand.add).toHaveBeenCalledWith("card a")

    it "should decrement the players replenish count", ->
      expect(player.decrement_replenish_count).toHaveBeenCalled()

  describe "when a new innings occurs", ->
    innings =
      supply: 'supply'

    beforeEach ->
      match.test_new_innings(innings)

    it "should update the supply", ->
      expect(player_action.supply).toBe(innings.supply)

