requirejs = require('../spec_helper').requirejs

module_mock = require('../stubs/module_mock')
module_mock.reset(requirejs)

supply = {}
card = {}
full_length_cards = ['a']
good_length_cards = ['b', 'c']
short_length_cards = ['d', 'e', 'f']
bouncer_length_cards = ['g', 'h',]
yorker_length_cards = ['i', 'j',]
chance_your_arm_length_cards = ['k', 'l', 'm', 'n', 'o']
bouncer_yorker_length_cards = ['g', 'h', 'i', 'j']

fake_deck = (size) ->
  new_deck =
    shuffle: jasmine.createSpy('deck.shuffle')
    discard: jasmine.createSpy('deck.discard')
    size: -> size
    on_event: jasmine.createSpy('deck.on_event')
  module_mock.capture_events_on(new_deck)
  new_deck

server_deck_builder =
  build: jasmine.createSpy('server_deck_builder.build').andCallFake (cards) ->
    fake_deck(cards.length)
    
cards =
  full_length: -> full_length_cards
  good_length: -> good_length_cards
  short_length: -> short_length_cards
  bouncers: -> bouncer_length_cards
  yorkers: -> yorker_length_cards
  chance_arm: -> chance_your_arm_length_cards

connection = {}

will_wire_push = module_mock.spy_on(requirejs, 'lib/will_wire_push');

become_server_supply = requirejs('cricket/server_supply')
Terms = requirejs('cricket/terms')

describe "a server supply", ->
  beforeEach ->
    supply = {}
    become_server_supply(supply, connection, cards, server_deck_builder);
    
  it 'should push updates over the wire', ->
    push_when =
      update_counts: 'supply/update'

    push_fields =
      full_deck_size: 'full_deck_size'
      good_deck_size: 'good_deck_size'
      short_deck_size: 'short_deck_size'
      bouncer_yorker_deck_size: 'bouncer_yorker_deck_size'
      chance_your_arm_deck_size: 'chance_your_arm_deck_size'

    expect(will_wire_push).toHaveBeenCalledWith(supply, connection, push_when, push_fields)

  describe 'when created', ->
    it "should make each of the four basic decks", ->
      expect(server_deck_builder.build).toHaveBeenCalledWith(full_length_cards);
      expect(server_deck_builder.build).toHaveBeenCalledWith(good_length_cards);
      expect(server_deck_builder.build).toHaveBeenCalledWith(short_length_cards);
      expect(server_deck_builder.build).toHaveBeenCalledWith(chance_your_arm_length_cards);

    it "should make the bouncer yorker deck as the concatenation of two decks", ->
      expect(server_deck_builder.build).toHaveBeenCalledWith(bouncer_yorker_length_cards);

    it "should shuffly each of the decks", ->
      expect(supply.full_deck.shuffle).toHaveBeenCalled();
      expect(supply.good_deck.shuffle).toHaveBeenCalled();
      expect(supply.short_deck.shuffle).toHaveBeenCalled();
      expect(supply.bouncer_yorker_deck.shuffle).toHaveBeenCalled();
      expect(supply.chance_your_arm_deck.shuffle).toHaveBeenCalled();

    it "should store the size of each of the decks", ->
      expect(supply.full_deck_size).toBe(1)
      expect(supply.good_deck_size).toBe(2)
      expect(supply.short_deck_size).toBe(3)
      expect(supply.bouncer_yorker_deck_size).toBe(4)
      expect(supply.chance_your_arm_deck_size).toBe(5)

  describe "when a deck updates", ->
    beforeEach ->
      supply.full_deck.size = -> 20
      supply.full_deck.test_update()

    it "should update the size fields", ->
      expect(supply.full_deck_size).toBe(20)
      expect(supply.good_deck_size).toBe(2)
      expect(supply.short_deck_size).toBe(3)
      expect(supply.bouncer_yorker_deck_size).toBe(4)
      expect(supply.chance_your_arm_deck_size).toBe(5)

  describe 'when trashing a card', ->
    beforeEach ->
      supply.full_deck.discard = jasmine.createSpy('full_deck.discard')
      supply.good_deck.discard = jasmine.createSpy('good_deck.discard')
      supply.short_deck.discard = jasmine.createSpy('short_deck.discard')
      supply.bouncer_yorker_deck.discard = jasmine.createSpy('bouncer_yorker.discard')

    it 'should be discarded into the correct deck', ->
      card.length = Terms.Length.yorker
      supply.trash_card(card)
      expect(supply.bouncer_yorker_deck.discard).toHaveBeenCalledWith(card)

      card.length = Terms.Length.full
      supply.trash_card(card)
      expect(supply.full_deck.discard).toHaveBeenCalledWith(card)

      card.length = Terms.Length.good
      supply.trash_card(card)
      expect(supply.good_deck.discard).toHaveBeenCalledWith(card)

      card.length = Terms.Length.short
      supply.trash_card(card)
      expect(supply.short_deck.discard).toHaveBeenCalledWith(card)

      card.length = Terms.Length.bouncer
      supply.trash_card(card)
      expect(supply.bouncer_yorker_deck.discard).toHaveBeenCalledWith(card)