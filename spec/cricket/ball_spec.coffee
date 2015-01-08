requirejs = require('../spec_helper').requirejs

module_mock = require('../stubs/module_mock')
module_mock.reset(requirejs)

ball = {}

become_ball = requirejs('cricket/ball')
Terms = requirejs('cricket/terms')

beforeEach ->
  ball = {}
  become_ball(ball)
  
describe 'a ball', ->
  it 'can be complete', ->
    expect(ball.is_complete()).toBeFalsy()
    ball.complete = true
    expect(ball.is_complete()).toBeTruthy()

  it 'can have no shot played', ->
    expect(ball.is_no_shot_being_played()).toBeTruthy()
    ball.batter_card = {}
    expect(ball.is_no_shot_being_played()).toBeFalsy()

  it 'can be must play', ->
    ball.play = Terms.Plays.can_leave
    expect(ball.is_must_play()).toBeFalsy()
    ball.play = Terms.Plays.must_play
    expect(ball.is_must_play()).toBeTruthy()

  it 'can be catchable', ->
    ball.height = Terms.Height.on_the_ground
    expect(ball.is_catchable()).toBeFalsy()
    ball.height = Terms.Height.catchable
    expect(ball.is_catchable()).toBeTruthy()

  it 'can be infield', ->
    ball.distance = Terms.Distance.outfield
    expect(ball.is_infield()).toBeFalsy()
    ball.distance = Terms.Distance.infield
    expect(ball.is_infield()).toBeTruthy()

  it 'can be outfield', ->
    ball.distance = Terms.Distance.infield
    expect(ball.is_outfield()).toBeFalsy()
    ball.distance = Terms.Distance.outfield
    expect(ball.is_outfield()).toBeTruthy()

  it 'can be a wicket', ->
    ball.result = Terms.Balls.dot
    expect(ball.is_wicket()).toBeFalsy()
    ball.result = Terms.Balls.one
    expect(ball.is_wicket()).toBeFalsy()
    ball.result = Terms.Balls.two
    expect(ball.is_wicket()).toBeFalsy()
    ball.result = Terms.Balls.three
    expect(ball.is_wicket()).toBeFalsy()
    ball.result = Terms.Balls.four
    expect(ball.is_wicket()).toBeFalsy()
    ball.result = Terms.Balls.six
    expect(ball.is_wicket()).toBeFalsy()
    ball.result = Terms.Balls.wide
    expect(ball.is_wicket()).toBeFalsy()
    ball.result = Terms.Balls.no_ball
    expect(ball.is_wicket()).toBeFalsy()
    ball.result = Terms.Balls.wicket
    expect(ball.is_wicket()).toBeTruthy()

  it 'can be legal', ->
    ball.result = Terms.Balls.dot
    expect(ball.is_legal()).toBeTruthy()
    ball.result = Terms.Balls.one
    expect(ball.is_legal()).toBeTruthy()
    ball.result = Terms.Balls.two
    expect(ball.is_legal()).toBeTruthy()
    ball.result = Terms.Balls.three
    expect(ball.is_legal()).toBeTruthy()
    ball.result = Terms.Balls.four
    expect(ball.is_legal()).toBeTruthy()
    ball.result = Terms.Balls.six
    expect(ball.is_legal()).toBeTruthy()
    ball.result = Terms.Balls.wicket
    expect(ball.is_legal()).toBeTruthy()

    ball.result = Terms.Balls.wide
    expect(ball.is_legal()).toBeFalsy()
    ball.result = Terms.Balls.noball
    expect(ball.is_legal()).toBeFalsy()

  it 'can be illegal', ->
    ball.result = Terms.Balls.dot
    expect(ball.is_illegal()).toBeFalsy()
    ball.result = Terms.Balls.one
    expect(ball.is_illegal()).toBeFalsy()
    ball.result = Terms.Balls.two
    expect(ball.is_illegal()).toBeFalsy()
    ball.result = Terms.Balls.three
    expect(ball.is_illegal()).toBeFalsy()
    ball.result = Terms.Balls.four
    expect(ball.is_illegal()).toBeFalsy()
    ball.result = Terms.Balls.six
    expect(ball.is_illegal()).toBeFalsy()
    ball.result = Terms.Balls.wicket
    expect(ball.is_illegal()).toBeFalsy()

    ball.result = Terms.Balls.wide
    expect(ball.is_illegal()).toBeTruthy()
    ball.result = Terms.Balls.noball
    expect(ball.is_illegal()).toBeTruthy()

  it 'can be a boundary', ->
    ball.boundary = true
    expect(ball.is_boundary()).toBeTruthy()
    ball.boundary = false
    expect(ball.is_boundary()).toBeFalsy()

describe 'can batter sneak run?', ->
  beforeEach ->
    ball.is_boundary = -> false
    ball.is_wicket = -> false
    ball.is_illegal = -> false
    ball.is_no_shot_being_played = -> false

  it 'should be false if ball is boundary', ->
    ball.is_boundary = -> true
    expect(ball.batter_can_sneak_run()).toBeFalsy()

  it 'should be false if ball is wicket', ->
    ball.is_wicket = -> true
    expect(ball.batter_can_sneak_run()).toBeFalsy()

  it 'should be false if ball is illegal', ->
    ball.is_illegal = -> true
    expect(ball.batter_can_sneak_run()).toBeFalsy()

  it 'should be false if no shot played', ->
    ball.is_no_shot_being_played = -> true
    expect(ball.batter_can_sneak_run()).toBeFalsy()

  it 'should be true otherwise', ->
    expect(ball.batter_can_sneak_run()).toBeTruthy()

describe 'can bowler cutoff run?', ->
  beforeEach ->
    ball.is_boundary = -> false
    ball.is_wicket = -> false
    ball.is_illegal = -> false
    ball.is_no_shot_being_played = -> false
    ball.runs = -> 1

  it 'should be false if ball is boundary', ->
    ball.is_boundary = -> true
    expect(ball.bowler_can_cutoff_run()).toBeFalsy()

  it 'should be false if ball is wicket', ->
    ball.is_wicket = -> true
    expect(ball.bowler_can_cutoff_run()).toBeFalsy()

  it 'should be false if ball is illegal', ->
    ball.is_illegal = -> true
    expect(ball.bowler_can_cutoff_run()).toBeFalsy()

  it 'should be false if no shot played', ->
    ball.is_no_shot_being_played = -> true
    expect(ball.bowler_can_cutoff_run()).toBeFalsy()

  it 'should be false if no runs scored', ->
    ball.runs = -> 0
    expect(ball.bowler_can_cutoff_run()).toBeFalsy()

  it 'should be true otherwise', ->
    expect(ball.bowler_can_cutoff_run()).toBeTruthy()

describe 'runs', ->
  it 'should convert the result into runs', ->
    ball.result = Terms.Balls.dot
    expect(ball.runs()).toBe(0)
    ball.result = Terms.Balls.one
    expect(ball.runs()).toBe(1)
    ball.result = Terms.Balls.two
    expect(ball.runs()).toBe(2)
    ball.result = Terms.Balls.three
    expect(ball.runs()).toBe(3)
    ball.result = Terms.Balls.four
    expect(ball.runs()).toBe(4)
    ball.result = Terms.Balls.six
    expect(ball.runs()).toBe(6)
    ball.result = Terms.Balls.wicket
    expect(ball.runs()).toBe(0)
    ball.result = Terms.Balls.wide
    expect(ball.runs()).toBe(1)
    ball.result = Terms.Balls.noball
    expect(ball.runs()).toBe(1)
