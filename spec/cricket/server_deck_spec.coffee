requirejs = require('../spec_helper').requirejs
asevented = require('../stubs/asevented').asevented

module_mock = require('../stubs/module_mock')
module_mock.reset(requirejs)

will_wire_push = module_mock.spy_on(requirejs, 'lib/will_wire_push')
notify_after = module_mock.spy_on(requirejs, 'lib/notify_after')
become_deck = module_mock.spy_on(requirejs, 'cricket/deck')

deck = {}
connection = {}
a = {a: 'a'}
b = {b: 'b'}
c = {c: 'c'}
cards = [a, b]

become_server_deck = requirejs('cricket/server_deck')

describe "a server deck", ->
  beforeEach ->
    deck = {}
    become_server_deck(deck, connection);

  it 'should push updates deck the wire', ->
    push_when =
      add: 'deck/update'
      remove: 'deck/update'
      remove_by_index: 'deck/update'
      draw: 'deck/update'
      top_card: 'deck/update'
      discard: 'deck/update'
      shuffle: 'deck/update'

    push_fields =
      cards: 'cards'
      discards: 'discards'

    expect(will_wire_push).toHaveBeenCalledWith(deck, connection, push_when, push_fields)

  it 'should emit events after changes', -> 
    emit_when = [
      {after: 'add', emit: 'update'},
      {after: 'remove', emit: 'update'},
      {after: 'remove_by_index', emit: 'update'},
      {after: 'draw', emit: 'update'},
      {after: 'top_card', emit: 'update'},
      {after: 'discard', emit: 'update'},
      {after: 'shuffle', emit: 'update'}
    ]

    expect(notify_after).toHaveBeenCalledWith(deck, 'server_deck', emit_when)

  it "should become a deck", ->
    deck = {}
    become_deck.reset()
    become_server_deck(deck, connection, []);
    expect(become_deck).toHaveBeenCalledWith(deck, [])

    deck = {}
    become_deck.reset()
    become_server_deck(deck, connection, cards);
    expect(become_deck).toHaveBeenCalledWith(deck, cards)

  describe "server deck behaviour", ->
    beforeEach ->
      deck =
        cards: []
        discards: []
      become_server_deck(deck, [])

    describe "shuffle", ->
      xit "should shuffle all the cards", ->
        #We use the Fisher–Yates shuffle... which is based on pseudo random
        #numbers and is therefore flawed; but this is good enough for us.

    describe "add", ->
      it "adds a card to the deck", ->
        deck.add(a)
        expect(deck.cards.length).toEqual(1)

    describe "remove", ->
      beforeEach ->
        deck.cards = [a, b, c]

      it "removes a specific card from the deck", ->
        deck.remove(b)
        expect(deck.cards.length).toEqual(2)
        expect(deck.cards[0]).toBe(a)
        expect(deck.cards[1]).toBe(c)

    describe "remove by index", ->
      beforeEach ->
        deck.cards = [a, b, c]

      it "removes a specific index from the deck", ->
        deck.remove_by_index(1)
        expect(deck.cards.length).toEqual(2)
        expect(deck.cards[0]).toBe(a)
        expect(deck.cards[1]).toBe(c)

    describe "discard", ->
      it "should add the card to the discards of the deck", ->
        expect(deck.discards.length).toEqual(0)
        deck.discard(a)
        expect(deck.discards.length).toEqual(1)

    describe "draw", ->
      describe "when empty", ->
        beforeEach ->
          deck.empty = -> return true
          deck.discard(a)
          deck.discard(b)
          deck.top_card = jasmine.createSpy('deck.top_card')
          deck.shuffle = jasmine.createSpy('deck.shuffle')
          deck.draw()

        it "should shuffle the discarded cards into the deck", ->
          expect(deck.cards.length).toBe(2)
          expect(deck.discards.length).toBe(0)
          expect(deck.shuffle).toHaveBeenCalled

        it "should return the top card in the deck", ->
          expect(deck.top_card).toHaveBeenCalled

      describe "when not empty", ->
        beforeEach ->
          deck.empty = -> return false
          deck.cards = cards
          deck.top_card = jasmine.createSpy('deck.top_card')

        it "should return the top card in the deck", ->
          deck.draw()
          expect(deck.top_card).toHaveBeenCalled

    describe "returning the top card", ->
      card = null

      beforeEach ->
        deck.cards = [a, b]
        card = deck.top_card()

      it "should remove the card from the deck", ->
        expect(deck.cards).toEqual([a])

      it "should return the card", ->
        expect(card).toEqual(b)
