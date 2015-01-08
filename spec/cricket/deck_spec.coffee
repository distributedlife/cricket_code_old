requirejs = require('../spec_helper').requirejs

module_mock = require('../stubs/module_mock')
module_mock.reset(requirejs)

deck = {}
a = {a: 'a'}
b = {b: 'b'}
c = {c: 'c'}
cards = [a, b]

become_deck = requirejs('cricket/deck')

describe "a deck", ->
  	beforeEach ->
    	become_deck(deck)


    describe "size", ->
    	it "should return a count of the number of elements in the deck", ->
			become_deck(deck, [])
			expect(deck.size()).toBe(0)

			become_deck(deck, cards)
			expect(deck.size()).toBe(2)
	      	
  	describe "empty", ->
    	it "should return true when the deck is empty", ->
			become_deck(deck, [])
			expect(deck.empty()).toBeTruthy()

			become_deck(deck, cards)
			expect(deck.empty()).toBeFalsy()
