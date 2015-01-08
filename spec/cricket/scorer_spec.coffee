requirejs = require('../spec_helper').requirejs
module_mock = require('../stubs/module_mock')
module_mock.reset(requirejs)

scorer = null
ball =
  _bowler_card:
    length: null
  _batter_card:
    shot: null
    length: null
  is_no_shot_being_played: -> false
  is_must_play: -> false
  airborne_shot: (distance) ->
    this._distance = distance
    this._height = 'catchable'
  is_catchable: -> false
field =
  has_fielder_in_spot: ->
  has_fielder_in_slice: ->
chance_your_arm_deck =
  draw: jasmine.createSpy('chance_your_arm_deck.draw')
  discard: jasmine.createSpy('chance_your_arm_deck.discard')

Scorer = requirejs('cricket/scorer')
Terms = requirejs('cricket/Terms')
describe "the scorerer", ->
  beforeEach ->
    scorer = new Scorer(chance_your_arm_deck)
    scorer.beat_the_bat = jasmine.createSpy('scorer.beat_the_bat')
    scorer.playing_a_shot = jasmine.createSpy('scorer.playing_a_shot')
    ball._bowler_card.length = Terms.Length.full
    ball._batter_card.length = Terms.Length.full

  describe "calculating the score", ->
    describe "when no shot is played", ->
      beforeEach ->
        ball.is_no_shot_being_played = -> true

      it "should beat the bat", ->
        scorer.score(ball, field)
        expect(scorer.beat_the_bat).toHaveBeenCalled()

    describe "when a block is played", ->
      beforeEach ->
        ball.is_no_shot_being_played = -> false
        ball._batter_card =
          shot: Terms.Shots.block

      it "should be a dot ball", ->
       expect(scorer.score(ball, field)).toBe(Terms.Balls.dot)

    describe "when an invalid length is played", ->
      describe "when a yorker is played", ->
        beforeEach ->
          ball._bowler_card = {length: Terms.Length.yorker}

        describe "it should not beat the bat", ->
          it "if a yorker is played", ->
            ball._batter_card = {length: Terms.Length.yorker}
            scorer.score(ball, field)
            expect(scorer.beat_the_bat).not.toHaveBeenCalled()

          it "if a good ball is played", ->
            ball._batter_card = {length: Terms.Length.good}
            scorer.score(ball, field)
            expect(scorer.beat_the_bat).not.toHaveBeenCalled()

        describe "it should beat the bat", ->
          it "if a full ball is played", ->
            ball._batter_card = {length: Terms.Length.full}
            scorer.score(ball, field)
            expect(scorer.beat_the_bat).toHaveBeenCalled()

          it "if a short ball is played", ->
            ball._batter_card = {length: Terms.Length.short}
            scorer.score(ball, field)
            expect(scorer.beat_the_bat).toHaveBeenCalled()

          it "if a bouncer is played", ->
            ball._batter_card = {length: Terms.Length.bouncer}
            scorer.score(ball, field)
            expect(scorer.beat_the_bat).toHaveBeenCalled()

      describe "when a full ball is played", ->
        beforeEach ->
          ball._bowler_card = {length: Terms.Length.full}

        describe "it should not beat the bat", ->
          it "if a yorker is played", ->
            ball._batter_card = {length: Terms.Length.yorker}
            scorer.score(ball, field)
            expect(scorer.beat_the_bat).not.toHaveBeenCalled()

          it "if a full ball is played", ->
            ball._batter_card = {length: Terms.Length.full}
            scorer.score(ball, field)
            expect(scorer.beat_the_bat).not.toHaveBeenCalled()

          it "if a good ball is played", ->
            ball._batter_card = {length: Terms.Length.good}
            scorer.score(ball, field)
            expect(scorer.beat_the_bat).not.toHaveBeenCalled()

        describe "it should beat the bat", ->
          it "if a short ball is played", ->
            ball._batter_card = {length: Terms.Length.short}
            scorer.score(ball, field)
            expect(scorer.beat_the_bat).toHaveBeenCalled()

          it "if a bouncer is played", ->
            ball._batter_card = {length: Terms.Length.bouncer}
            scorer.score(ball, field)
            expect(scorer.beat_the_bat).toHaveBeenCalled()


      describe "when a good ball is played", ->
        beforeEach ->
          ball._bowler_card = {length: Terms.Length.good}

        describe "it should not beat the bat", ->
          it "if a yorker is played", ->
            ball._batter_card = {length: Terms.Length.yorker}
            scorer.score(ball, field)
            expect(scorer.beat_the_bat).not.toHaveBeenCalled()

          it "if a full ball is played", ->
            ball._batter_card = {length: Terms.Length.full}
            scorer.score(ball, field)
            expect(scorer.beat_the_bat).not.toHaveBeenCalled()

          it "if a good ball is played", ->
            ball._batter_card = {length: Terms.Length.good}
            scorer.score(ball, field)
            expect(scorer.beat_the_bat).not.toHaveBeenCalled()

          it "if a short ball is played", ->
            ball._batter_card = {length: Terms.Length.short}
            scorer.score(ball, field)
            expect(scorer.beat_the_bat).not.toHaveBeenCalled()

        describe "it should beat the bat", ->
          it "if a bouncer is played", ->
            ball._batter_card = {length: Terms.Length.bouncer}
            scorer.score(ball, field)
            expect(scorer.beat_the_bat).toHaveBeenCalled()


      describe "when a short ball is played", ->
        beforeEach ->
          ball._bowler_card = {length: Terms.Length.short}

        describe "it should not beat the bat", ->
          it "if a yorker is played", ->
            ball._batter_card = {length: Terms.Length.yorker}
            scorer.score(ball, field)
            expect(scorer.beat_the_bat).not.toHaveBeenCalled()

          it "if a good ball is played", ->
            ball._batter_card = {length: Terms.Length.good}
            scorer.score(ball, field)
            expect(scorer.beat_the_bat).not.toHaveBeenCalled()

          it "if a short ball is played", ->
            ball._batter_card = {length: Terms.Length.short}
            scorer.score(ball, field)
            expect(scorer.beat_the_bat).not.toHaveBeenCalled()

        describe "it should beat the bat", ->
          it "if a full ball is played", ->
            ball._batter_card = {length: Terms.Length.full}
            scorer.score(ball, field)
            expect(scorer.beat_the_bat).toHaveBeenCalled()

          it "if a bouncer is played", ->
            ball._batter_card = {length: Terms.Length.bouncer}
            scorer.score(ball, field)
            expect(scorer.beat_the_bat).toHaveBeenCalled()

      describe "when a bouncer is played", ->
        beforeEach ->
          ball._bowler_card = {length: Terms.Length.bouncer}

        describe "it should not beat the bat", ->
          it "if a bouncer is played", ->
            ball._batter_card = {length: Terms.Length.bouncer}
            scorer.score(ball, field)
            expect(scorer.beat_the_bat).not.toHaveBeenCalled()

        describe "it should beat the bat", ->
          it "if a yorker is played", ->
            ball._batter_card = {length: Terms.Length.yorker}
            scorer.score(ball, field)
            expect(scorer.beat_the_bat).toHaveBeenCalled()

          it "if a full ball is played", ->
            ball._batter_card = {length: Terms.Length.full}
            scorer.score(ball, field)
            expect(scorer.beat_the_bat).toHaveBeenCalled()

          it "if a good ball is played", ->
            ball._batter_card = {length: Terms.Length.good}
            scorer.score(ball, field)
            expect(scorer.beat_the_bat).toHaveBeenCalled()

          it "if a short ball is played", ->
            ball._batter_card = {length: Terms.Length.short}
            scorer.score(ball, field)
            expect(scorer.beat_the_bat).toHaveBeenCalled()

    describe "when chancing your arm", ->
      beforeEach ->
        ball.is_no_shot_being_played = -> false
        ball._chancing_arm = true

      it "should draw from the chance arm deck", ->
        scorer.score(ball, field)
        expect(chance_your_arm_deck.draw).toHaveBeenCalled()

      describe "when a 4 or 6 is returned", ->
        it "should score that amount", ->
          chance_your_arm_deck.draw = -> "4"
          expect(scorer.score(ball, field)).toBe(Terms.Balls.four)
          chance_your_arm_deck.draw = -> "6"
          expect(scorer.score(ball, field)).toBe(Terms.Balls.six)

      describe "when hit into the outfield", ->
        beforeEach ->
          chance_your_arm_deck.draw = -> "outfield catch"
          ball._distance = null
          ball._height = null
          scorer.score(ball, field)

        it "is marked as an outfield catchable shot", ->
          expect(ball._distance).toBe(Terms.Distance.outfield)
          expect(ball._height).toBe(Terms.Height.catchable)

        it "is scored as a played shot", ->
          expect(scorer.playing_a_shot).toHaveBeenCalled()

      describe "when hit into the infield", ->
        beforeEach ->
          chance_your_arm_deck.draw = -> "infield catch"
          ball._distance = null
          ball._height = null
          scorer.score(ball, field)

        it "is marked as an infield catchable shot", ->
          expect(ball._distance).toBe(Terms.Distance.infield)
          expect(ball._height).toBe(Terms.Height.catchable)

        it "is scored as a played shot", ->
          expect(scorer.playing_a_shot).toHaveBeenCalled()

   describe "when a shot is played", ->
     beforeEach ->
       scorer.score(ball, field)

     it "is scored as a played shot", ->
       expect(scorer.playing_a_shot).toHaveBeenCalled()

 describe "when playing a shot", ->
   beforeEach ->
     scorer = new Scorer(chance_your_arm_deck)
     ball._batter_card.shot = Terms.Shots.cut

   describe "when no fielders are in the slice", ->
     beforeEach ->
       field.has_fielder_in_slice = -> return false

     describe "when hit into the outfield", ->
       beforeEach ->
         ball.is_infield = -> false

       it "should score 3 runs if catchable", ->
         ball.is_catchable = -> true
         expect(scorer.playing_a_shot(ball, field)).toBe(Terms.Balls.three)

       it "should score 2 runs if hit along the ground", ->
         ball.is_catchable = -> false
         expect(scorer.playing_a_shot(ball, field)).toBe(Terms.Balls.two)

     describe "when hit into the infield", ->
       beforeEach ->
         ball.is_infield = -> true

       it "should score 2 runs if hit into the air", ->
         ball.is_catchable = -> true
         expect(scorer.playing_a_shot(ball, field)).toBe(Terms.Balls.two)

       it "should score 1 runs if hit along the ground", ->
         ball.is_catchable = -> false
         expect(scorer.playing_a_shot(ball, field)).toBe(Terms.Balls.one)

   describe "when fielder in slice", ->
     beforeEach ->
       field.has_fielder_in_slice = -> return true

     describe "when fielder not in spot", ->
       beforeEach ->
         field.has_fielder_in_spot = -> return false

       describe "when hit into the outfield", ->
         beforeEach ->
           ball.is_infield = -> false

         it "should score 1 runs when hit into the air", ->
           ball.is_catchable = -> true
           expect(scorer.playing_a_shot(ball, field)).toBe(Terms.Balls.two)

         it "should score 1 runs when hit along the ground", ->
           ball.is_catchable = -> false
           expect(scorer.playing_a_shot(ball, field)).toBe(Terms.Balls.one)

       describe "when hit into the infield", ->
         beforeEach ->
           ball.is_infield = -> true

         it "should score 1 runs when hit into the air", ->
           ball.is_catchable = -> true
           expect(scorer.playing_a_shot(ball, field)).toBe(Terms.Balls.two)

         it "should score 1 runs when hit along the ground", ->
           ball.is_catchable = -> false
           expect(scorer.playing_a_shot(ball, field)).toBe(Terms.Balls.one)

     describe "when field in spot", ->
       beforeEach ->
         field.has_fielder_in_spot = -> return true

       describe "when catchable", ->
         beforeEach ->
           ball.is_catchable = -> true

         it "should be out", ->
           expect(scorer.playing_a_shot(ball, field)).toBe(Terms.Balls.wicket)

       describe "when hit along the ground", ->
         beforeEach ->
           ball.is_catchable = -> false

         describe "when hit into the outfield", ->
           beforeEach ->
             ball.is_infield = -> false

           it "should score 1 run", ->
             expect(scorer.playing_a_shot(ball, field)).toBe(Terms.Balls.one)

         describe "when hit into the infield", ->
           beforeEach ->
             ball.is_infield = -> true

           it "should be a dot ball", ->
             expect(scorer.playing_a_shot(ball, field)).toBe(Terms.Balls.dot)

  describe "beating the bat", ->
    beforeEach ->
      scorer = new Scorer(chance_your_arm_deck)

    describe "when the ball must be played", ->
      beforeEach ->
        ball.is_must_play = -> true

      it "should be out", ->
        expect(scorer.beat_the_bat(ball)).toBe(Terms.Balls.wicket)

    describe "when the ball can be left", ->
      beforeEach ->
        ball.is_must_play = -> false

      it "should be a dot ball", ->
        expect(scorer.beat_the_bat(ball)).toBe(Terms.Balls.dot)
