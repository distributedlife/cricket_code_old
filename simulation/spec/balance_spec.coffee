requirejs = require('../spec_helper').requirejs
three = require('../stubs/three').three

module_mock = require('../stubs/module_mock')
module_mock.reset(requirejs)
Three = module_mock.stub(requirejs, 'ext/three', three)

game = null
fielding = []
bowling = []
batting = []

log_results = (p1, p2, simulator) ->
  results = ['"result"']
  results.push(new Date().getTime())
  results.push("\"#{p1.fielding_ai}\"")
  results.push("\"#{p1.bowling_ai}\"")
  results.push("\"#{p1.batting_ai}\"")
  results.push("\"#{p2.fielding_ai}\"")
  results.push("\"#{p2.bowling_ai}\"")
  results.push("\"#{p2.batting_ai}\"")
  results.push(simulator.results().p1.wickets)
  results.push(simulator.results().p1.runs)
  results.push(simulator.results().p1.overs_bowled)
  results.push(simulator.results().p2.wickets)
  results.push(simulator.results().p2.runs)
  results.push(simulator.results().p2.overs_bowled)
  results.push(simulator.results().p1.runs_off_delivery['.'])
  results.push(simulator.results().p1.runs_off_delivery['1'])
  results.push(simulator.results().p1.runs_off_delivery['2'])
  results.push(simulator.results().p1.runs_off_delivery['3'])
  results.push(simulator.results().p1.runs_off_delivery['4'])
  results.push(simulator.results().p1.runs_off_delivery['5'])
  results.push(simulator.results().p1.runs_off_delivery['6'])
  results.push(simulator.results().p1.runs_off_delivery['w'])
  results.push(simulator.results().p1.runs_off_delivery['nb'])
  results.push(simulator.results().p1.run_rate)
  results.push(simulator.results().p2.runs_off_delivery['.'])
  results.push(simulator.results().p2.runs_off_delivery['1'])
  results.push(simulator.results().p2.runs_off_delivery['2'])
  results.push(simulator.results().p2.runs_off_delivery['3'])
  results.push(simulator.results().p2.runs_off_delivery['4'])
  results.push(simulator.results().p2.runs_off_delivery['5'])
  results.push(simulator.results().p2.runs_off_delivery['6'])
  results.push(simulator.results().p2.runs_off_delivery['w'])
  results.push(simulator.results().p2.runs_off_delivery['nb'])
  results.push(simulator.results().p2.run_rate)
  console.log(results.join(','))

requirejs ["cricket/t20_match", "cricket/field", "cricket/ai/runner", "cricket/ai/ai", "cricket/ai/basic_field", "cricket/ai/random_bowler", "cricket/ai/must_play_at_end_bowler", "cricket/ai/random_batter", "cricket/ai/safe_batter", "cricket/ai/safe_batter_with_aggression", "cricket/ai/safe_batter_with_aggression_1", "cricket/ai/safe_batter_with_aggression_2"], (T20Match, Field, AIRunner, AI, BasicField, RandomBowler, MustPlayAtEndBowler, RandomBatter, SafeBatter, SafeBatterWithAggression, SafeBatterWithAggression1, SafeBatterWithAggression2) ->
  describe "twenty20 games", ->
    beforeEach ->
      fielding = [BasicField]
      bowling = [MustPlayAtEndBowler]
      batting = [SafeBatterWithAggression]

    describe "game balance tests", ->
      describe "when batting first", ->
        it "random bat vs. random ball", ->
          for p1_fielding_ai in fielding
            for p2_fielding_ai in fielding
              for p1_bowling_ai in bowling
                for p2_bowling_ai in bowling
                  for p1_batting_ai in batting
                    for p2_batting_ai in batting
                      match = new T20Match()
                      field = new Field()
                      p1 = new AI(p1_fielding_ai, p1_bowling_ai, p1_batting_ai)
                      p2 = new AI(p2_fielding_ai, p2_bowling_ai, p2_batting_ai)
                      simulator = new AIRunner(match, field, [p1, p2])
                      simulator.run()
                      log_results(p1, p2, simulator)

module_mock.reset(requirejs)
