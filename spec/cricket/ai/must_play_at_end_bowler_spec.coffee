requirejs = require('../../spec_helper').requirejs

ai =

MustPlayAtEndBowler = requirejs('cricket/ai/must_play_at_end_bowler')
Terms = requirejs('cricket/terms')
describe "bowling behaviour", ->
  beforeEach ->
    ai  = new MustPlayAtEndBowler()

  describe "sort hand", ->
    it "should sort the must play cards to the end", ->
      a =
        play: Terms.Plays.must_play
      b =
        play: Terms.Plays.can_leave
      cards = [a,b]
      ai.sort_hand(cards)
      expect(cards).toEqual([b,a])
