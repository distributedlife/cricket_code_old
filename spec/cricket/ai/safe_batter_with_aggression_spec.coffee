requirejs = require('../../spec_helper').requirejs

innings =
  target: null
  required_run_rate: -> 7.0
  run_rate: -> 4.0
  current_over:
    balls_remaining: -> 2.0
batter =
  desired_run_rate: 6.0
  risk_appetite: 0
  innings: innings
  momentum: -> 0
field =
  has_fielder_in_spot: -> false
ball = null
option = null
ai =

SafeBatterWithAggression = requirejs("cricket/ai/safe_batter_with_aggression")
Terms = requirejs("cricket/terms")

describe "batter behaviour", ->
  beforeEach ->
    ai = new SafeBatterWithAggression(batter)

  describe "need outweighs risk", ->
    describe "when batting first", ->
      it "should calculate risk as run rate behind desired run rate", ->
        batter.risk_appetite = 0.0
        expect(ai.need_outweighs_risk(2.0)).toBeTruthy()
        expect(ai.need_outweighs_risk(2.1)).toBeFalsy()

      it "should add appetite for risk to result", ->
        batter.risk_appetite = 1.0
        expect(ai.need_outweighs_risk(3.0)).toBeTruthy()
        expect(ai.need_outweighs_risk(3.1)).toBeFalsy()

    describe "when batting second", ->
      beforeEach ->
        innings.target = 100

      it "should calculate risk as run rate behind required run rate", ->
        batter.risk_appetite = 0.0
        expect(ai.need_outweighs_risk(3.0)).toBeTruthy()
        expect(ai.need_outweighs_risk(3.1)).toBeFalsy()

      it "should add appetite for risk to result", ->
        batter.risk_appetite = 1.0
        expect(ai.need_outweighs_risk(4.0)).toBeTruthy()
        expect(ai.need_outweighs_risk(4.1)).toBeFalsy()

  describe "get_valid_options", ->
    beforeEach ->
      option = {runs: Terms.Balls.wicket, chance: 0.0}
      ai.calculate_value_of_hand = -> [option]

    it "should ignore risky wickets", ->
      ai.need_outweighs_risk = -> false
      expect(ai.get_valid_options(ball, field)).toEqual([])

    it "should include risky wickets", ->
      ai.need_outweighs_risk = -> true
      expect(ai.get_valid_options(ball, field)).toEqual([option])

    it "should always includes runs", ->
      ai.need_outweighs_risk = -> false
      option.runs = Terms.Balls.three
      expect(ai.get_valid_options(ball, field)).toEqual([option])

  describe "sort by value", ->
    it "should sort the set by runs", ->
      set = [{runs: Terms.Balls.wicket}, {runs: Terms.Balls.one}, {runs: Terms.Balls.two}]
      expect(ai.sort_by_value(set)).toEqual([{runs: Terms.Balls.two}, {runs: Terms.Balls.one}, {runs: Terms.Balls.wicket}])

  describe "sort by risk", ->
    it "should sort the set by risk", ->
      set = [{chance: 0.0}, {chance: 1.1}, {chance: 0.6}]
      expect(ai.sort_by_risk(set)).toEqual([{chance: 0.0}, {chance: 0.6}, {chance: 1.1}])

  describe "should use momentum", ->
    it "should return true when the momenutm count is equal to or greater than balls remaining", ->
      batter.momentum = -> 2
      innings.current_over.balls_remaining = -> 2.0
      expect(ai.should_use_momentum()).toBeTruthy()

      batter.momentum = -> 1
      innings.current_over.balls_remaining = -> 2.0
      expect(ai.should_use_momentum()).toBeFalsy()

      batter.momentum = -> 2
      innings.current_over.balls_remaining = -> 6.0
      expect(ai.should_use_momentum()).toBeFalsy()
