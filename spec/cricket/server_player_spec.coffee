
requirejs = require('../spec_helper').requirejs
cricket = require('../stubs/cricket')

module_mock = require('../stubs/module_mock')
module_mock.reset(requirejs)

notify_after = module_mock.spy_on(requirejs, 'lib/notify_after')
will_wire_push = module_mock.spy_on(requirejs, 'lib/will_wire_push')

player = {}
connection = {}
become_server_player = requirejs('cricket/server_player')

describe 'a server player', ->
  beforeEach ->
    player = {}
    notify_after.reset()
    become_server_player(player, connection)

  it 'should push updates player the wire', ->
    push_when =
      push_momentum_change: 'player/update'
      increment_replenish_count: 'player/update'
      decrement_replenish_count: 'player/update'
      start_batting: 'player/update'
      start_bowling: 'player/update'

    push_fields =
      momentum_card_count: 'momentum_card_count'
      max_hand_size: 'max_hand_size'
      batting: 'batting'
      cards_to_replenish: 'cards_to_replenish'

    expect(will_wire_push).toHaveBeenCalledWith(player, connection, push_when, push_fields, player.sync_deck_properties)

  it 'should emit events after changes', -> 
    emit_when = [
      {after: 'push_momentum_change', emit: 'momentum'},
      {after: 'use_momentum', emit: 'momentum'},
      {after: 'add_momentum', emit: 'momentum'},
      {after: 'set_momentum', emit: 'momentum'},

      {after: 'start_new_innings', emit: 'player/innings/setup_complete'},
      {after: 'seed_momentum', emit: 'player/over/seed_momentum/complete'},
      {after: 'draw_hand', emit: 'player/over/draw_hand/complete'},
      {after: 'start_of_ball', emit: 'player/ball/start_of_ball/complete'},
      {after: 'move_to_next_ball', emit: 'player/ball/move_to_next_ball/complete'},
      {after: 'trash_cards', emit: 'player/over/trash_cards/complete'},
      {after: 'discard_hand', emit: 'player/over/discard_hand/complete'},

      {after: 'sneak_runs', emit: 'player/ball/sneak_runs/complete'},
      {after: 'cutoff_runs', emit: 'player/ball/cutoff_runs/complete'},

      {after: 'decrement_replenish_count', when: player.no_cards_to_be_replenished, emit: 'player/over/replenish_cards/complete'},
      {after: 'replenish_cards', when: player.no_cards_to_be_replenished, emit: 'player/over/replenish_cards/complete'}
    ]

    expect(notify_after).toHaveBeenCalledWith(player, 'server_player', emit_when)

  it 'should have callbacks that need to exist', ->
    expect(player.start_of_ball).not.toBe(undefined)
    expect(player.add_runs_momentum).not.toBe(undefined)
    expect(player.restrict_runs_momentum).not.toBe(undefined)
    expect(player.move_to_next_ball).not.toBe(undefined)
    expect(player.trash_cards).not.toBe(undefined)
    expect(player.replenish_cards).not.toBe(undefined)

  describe 'use momentum', ->
    it 'should deduct momentum by 1', ->
      player.momentum_card_count = 2
      player.use_momentum()
      expect(player.momentum_card_count).toBe(1)

  describe 'add momentum', ->
    it 'should increase momentum by 1', ->
      player.momentum_card_count = 2
      player.add_momentum()
      expect(player.momentum_card_count).toBe(3)

  describe 'set momentum', ->
    it 'should set the momentum', ->
      player.set_momentum(2)
      expect(player.momentum_card_count).toBe(2)

  describe 'increment_replenish_count', ->
    it 'should increment the cards to replenish', ->
      expect(player.cards_to_replenish).toBe(0)
      player.increment_replenish_count()
      expect(player.cards_to_replenish).toBe(1)

  describe 'decrement_replenish_count', ->
    it 'should decrement the cards to replenish', ->
      player.cards_to_replenish = 1
      player.decrement_replenish_count()
      expect(player.cards_to_replenish).toBe(0)      

  describe 'setting up a player hand', ->
    beforeEach ->
      supply =
        full_deck:
          draw: jasmine.createSpy()
        short_deck:
          draw: jasmine.createSpy()
        good_deck:
          draw: jasmine.createSpy()
      player.setup_hand(supply)

    it 'should have 14 cards in the deck', ->
      expect(player.deck.size()).toBe(14)

    it 'should create an empty hand for the player', ->
      expect(player.hand).not.toBe(null)

  describe "start_new_innings", ->
    innings = {}

    it 'should setup the hand', ->
      player.setup_hand = jasmine.createSpy('player.setup_hand')
      player.start_new_innings(innings)
      expect(player.setup_hand).toHaveBeenCalled()

  describe "seed_momentum", ->
    beforeEach ->
      player.momentum_card_count

    it "should give 2 momentum when the player is batting", ->
      player.is_batting = () -> true
      player.seed_momentum({slips: 47});
      expect(player.momentum_card_count).toBe(2)

    it "Should set the momentum to the slips count if the player is bowling", ->
      player.is_batting = () -> false
      player.seed_momentum({slips: 47});
      expect(player.momentum_card_count).toBe(47)

  describe "draw_hand", ->
    it 'should add cards to the hand size', ->
      player.max_hand_size = 3
      player.deck.draw = jasmine.createSpy('deck.draw')
      expect(player.hand.size()).toBe(0)
      player.draw_hand()

      expect(player.deck.draw.callCount).toBe(3)
      expect(player.hand.size()).toBe(player.max_hand_size)

  describe 'discard_hand', ->
    it 'should put all cards in the hand into the discard pile', ->
      player.max_hand_size = 3
      player.draw_hand()
      expect(player.hand.size()).toBe(player.max_hand_size)
      player.discard_hand()
      expect(player.hand.size()).toBe(0)

  describe 'trashing a card', ->
    it 'should put the card back into the supply', ->
      player.supply =
        trash_card: jasmine.createSpy('supply.trash_card')
      player.trash_card({a: 'a'})
      expect(player.supply.trash_card).toHaveBeenCalledWith({a: 'a'})

  describe "sneaking_runs_is_not_allowed", ->
    ball = {}

    beforeEach ->
      player.momentum = () -> 1
      ball.can_sneak_run = () -> true

    it "should return true if the ball says we can't", ->
      ball.can_sneak_run = () -> false
      expect(player.sneaking_runs_is_not_allowed(ball)).toBeTruthy()

    it "should return true if player momentum is zero", ->
      player.momentum = () -> 0
      expect(player.sneaking_runs_is_not_allowed(ball)).toBeTruthy()

    it "should return false otherwise", ->
      expect(player.sneaking_runs_is_not_allowed(ball)).toBeFalsy()

  describe "cutting_off_runs_is_not_allowed", ->
    ball = {}

    beforeEach ->
      player.momentum = () -> 1
      ball.can_cutoff_run = () -> true

    it "should return true if the ball says we can't", ->
      ball.can_cutoff_run = () -> false
      expect(player.cutting_off_runs_is_not_allowed(ball)).toBeTruthy()

    it "should return true if player momentum is zero", ->
      player.momentum = () -> 0
      expect(player.cutting_off_runs_is_not_allowed(ball)).toBeTruthy()

    it "should return false otherwise", ->
      expect(player.cutting_off_runs_is_not_allowed(ball)).toBeFalsy()

  describe "sneak_runs", ->
    beforeEach ->
      player.add_runs_momentum = jasmine.createSpy()

    it "should do nothing if player is not allowed to cutoff runs", ->
      player.sneaking_runs_is_not_allowed = () -> true      
      player.sneak_runs();
      expect(player.add_runs_momentum).not.toHaveBeenCalled();

    it "should delegate to restrict_runs_momentum", ->
      player.sneaking_runs_is_not_allowed = () -> false      
      player.sneak_runs();
      expect(player.add_runs_momentum).toHaveBeenCalled();

  describe "cutoff_runs", ->
    beforeEach ->
      player.restrict_runs_momentum = jasmine.createSpy()

    it "should do nothing if player is not allowed to cutoff runs", ->
      player.cutting_off_runs_is_not_allowed = () -> true      
      player.cutoff_runs();
      expect(player.restrict_runs_momentum).not.toHaveBeenCalled();

    it "should delegate to restrict_runs_momentum", ->
      player.cutting_off_runs_is_not_allowed = () -> false      
      player.cutoff_runs();
      expect(player.restrict_runs_momentum).toHaveBeenCalled();

  describe "start_batting", ->
    it "should set the player to batting", ->
      expect(player.is_batting()).toBeFalsy()
      player.start_batting();
      expect(player.is_batting()).toBeTruthy()

  describe "start_bowling", ->
    it "should set the player to batting", ->
      player.batting = true;
      player.start_bowling();
      expect(player.is_batting()).toBeFalsy()

  describe 'sync_deck_properties', ->
