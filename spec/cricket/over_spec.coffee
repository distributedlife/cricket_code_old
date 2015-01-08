requirejs = require('../spec_helper').requirejs

module_mock = require('../stubs/module_mock')
module_mock.reset(requirejs)

become_over = requirejs('cricket/over')
Terms = requirejs('cricket/terms')

over = {}

describe 'an over', ->
  beforeEach ->
    over = {}
    become_over(over)

  describe 'complete', ->
    it 'should return true if there are no more balls to bowl in an over', ->
      over.balls_remaining = -> 0
      expect(over.complete()).toBeTruthy()
      over.balls_remaining = -> 1
      expect(over.complete()).toBeFalsy()

  describe 'in progress', ->
    it 'should be the opposite of complete', ->
      over.complete = -> false
      expect(over.in_progress()).toBeTruthy()
      over.complete = -> true
      expect(over.in_progress()).toBeFalsy()

  describe 'runs', ->
    new_ball = (result) ->
      is_complete: -> true
      runs: -> Terms.Score[result]

    it 'should return the number of runs scored in the over', ->
      over.balls.push(new_ball(Terms.Balls.one))
      expect(over.runs()).toBe(1)
      over.balls.push(new_ball(Terms.Balls.two))
      expect(over.runs()).toBe(3)
      over.balls.push(new_ball(Terms.Balls.three))
      expect(over.runs()).toBe(6)
      over.balls.push(new_ball(Terms.Balls.four))
      expect(over.runs()).toBe(10)
      over.balls.push(new_ball(Terms.Balls.five))
      expect(over.runs()).toBe(15)
      over.balls.push(new_ball(Terms.Balls.six))
      expect(over.runs()).toBe(21)
      over.balls.push(new_ball(Terms.Balls.wicket))
      expect(over.runs()).toBe(21)
      over.balls.push(new_ball(Terms.Balls.noball))
      expect(over.runs()).toBe(22)
      over.balls.push(new_ball(Terms.Balls.wide))
      expect(over.runs()).toBe(23)
      over.balls.push(new_ball(Terms.Balls.dot))
      expect(over.runs()).toBe(23)

  describe 'total_balls', ->
    it 'should return the number of balls bowled in the over', ->
      for own ball of Terms.Balls
        over.balls.push({})
      expect(over.total_balls()).toBe(10)

  describe 'balls_remaining', ->
    legal_complete_ball = ->
      is_complete: -> true
      is_legal: -> true
    illegal = ->
      is_complete: -> true
      is_legal: -> false
    incomplete = ->
      is_complete: -> false
      is_legal: -> true

    it 'should return the number of balls remaining in the over', ->
      over.balls = []
      expect(over.balls_remaining()).toBe(6)
      over.balls.push(legal_complete_ball())
      expect(over.balls_remaining()).toBe(5)
      over.balls.push(legal_complete_ball())
      expect(over.balls_remaining()).toBe(4)

    it 'should ignore illegal balls', ->
      over.balls.push(illegal())
      expect(over.balls_remaining()).toBe(6)

    it 'should ignore incomplete balls', ->
      over.balls.push(incomplete())
      expect(over.balls_remaining()).toBe(6)

  describe "wickets", ->
    it "should return the count of wickets in the over", ->
      over.balls.push({is_wicket: -> false})
      expect(over.wickets()).toBe(0)
      over.balls.push({is_wicket: -> true})
      expect(over.wickets()).toBe(1)

  describe "record", ->
    it "should return the result for each ball in the over", ->
      over.balls = [{_result: Terms.Balls.dot}, {_result: Terms.Balls.wicket}]
      expect(over.record()).toBe(".x")

  describe "balls bowled", ->
    it "should return the number of legimate balls bowled", ->
      over.balls_remaining = -> 6
      expect(over.balls_bowled()).toBe(0)
      over.balls_remaining = -> 3
      expect(over.balls_bowled()).toBe(3)
      over.balls_remaining = -> 0
      expect(over.balls_bowled()).toBe(6)
      