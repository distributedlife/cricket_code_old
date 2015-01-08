requirejs = require('../spec_helper').requirejs

module_mock = require('../stubs/module_mock')
module_mock.reset(requirejs)

ball = {}
connection = {}

will_wire_push = module_mock.spy_on(requirejs, 'lib/will_wire_push')
notify_after = module_mock.spy_on(requirejs, 'lib/notify_after')

become_server_ball = requirejs('cricket/server_ball')
Terms = requirejs('cricket/terms')

describe 'server ball', ->
  beforeEach ->
    ball = {}
    become_server_ball(ball, connection)

  it 'should push updates over the wire', ->
    push_when =
      init: 'ball/create'
      set_stage: 'ball/update'
      play_bowling_card: 'ball/update'
      play_batting_card: 'ball/update'
      chance_arm: 'ball/update'
      airborne_shot: 'ball/update'
      record_intermediate_result: 'ball/update'
      sneak_run: 'ball/update'
      cutoff_run: 'ball/update'
      finish: 'ball/complete'
    push_fields =
      length: 'length'
      play: 'play'
      height: 'height'
      shot: 'shot'
      distance: 'distance'
      bowler_card: 'bowler_card'
      batter_card: 'batter_card'
      result: 'result'
      chancing_arm: 'chancing_arm'
      complete: 'complete'
      boundary: 'boundary'
      stage: 'stage'
    expect(will_wire_push).toHaveBeenCalledWith(ball, connection, push_when, push_fields)

  it 'should emit events after changes', -> 
    emit_when = [
      {after: 'set_stage', emit: 'update'},
      {after: 'play_bowling_card', emit: 'update'}
      {after: 'play_batting_card', emit: 'update'}
      {after: 'chance_arm', emit: 'update'}
      {after: 'airborne_shot', emit: 'update'}
      {after: 'record_intermediate_result', emit: 'update'}
      {after: 'sneak_run', emit: 'update'}
      {after: 'cutoff_run', emit: 'update'}
      {after: 'finish', emit: 'complete'}
    ]
    expect(notify_after).toHaveBeenCalledWith(ball, 'server_ball', emit_when)



  describe 'applying a bowling card', ->
    it 'should set the length, play and height', ->
      ball.play_bowling_card({length: "a", play: "b"})
      expect(ball.length).toBe("a")
      expect(ball.play).toBe("b")

  describe 'applying a batting card', ->
    it 'should set the shot, height and distance', ->
      ball.play_batting_card({shot: "a", catchable: "b", distance: "c"})
      expect(ball.shot).toBe("a")
      expect(ball.height).toBe("b")
      expect(ball.distance).toBe("c")

  describe 'chance arm', ->
    it 'should set chancing arm to true', ->
      ball.chancing_arm = false
      ball.chance_arm()
      expect(ball.chancing_arm).toBeTruthy()

    it 'should set the height to catchable', ->
      ball.height = Terms.Height.on_the_ground
      ball.chance_arm()
      expect(ball.height).toBe(Terms.Height.catchable)

  describe 'an airborne shot', ->
    it 'should set the distance', ->
      ball.airborne_shot(Terms.Distance.outfield)
      expect(ball.distance).toBe(Terms.Distance.outfield)
      ball.airborne_shot(Terms.Distance.infield)
      expect(ball.distance).toBe(Terms.Distance.infield)

    it 'should make the shot catchable', ->
      expect(ball.height).toBe(null)
      ball.airborne_shot(Terms.Distance.outfield)
      expect(ball.height).toBe(Terms.Height.catchable)

  describe 'record intermediate result', ->
    it 'should set the result', ->
      ball.record_intermediate_result(Terms.Balls.dot)
      expect(ball.result).toBe(Terms.Balls.dot)

    it 'should set the boundary if 4 or 6', ->
      ball.record_intermediate_result(Terms.Balls.dot)
      expect(ball.boundary).toBeFalsy()
      ball.record_intermediate_result(Terms.Balls.one)
      expect(ball.boundary).toBeFalsy()
      ball.record_intermediate_result(Terms.Balls.two)
      expect(ball.boundary).toBeFalsy()
      ball.record_intermediate_result(Terms.Balls.three)
      expect(ball.boundary).toBeFalsy()
      ball.record_intermediate_result(Terms.Balls.wicket)
      expect(ball.boundary).toBeFalsy()
      ball.record_intermediate_result(Terms.Balls.wide)
      expect(ball.boundary).toBeFalsy()
      ball.record_intermediate_result(Terms.Balls.noball)
      expect(ball.boundary).toBeFalsy()

      ball.record_intermediate_result(Terms.Balls.four)
      expect(ball.boundary).toBeTruthy()
      ball.record_intermediate_result(Terms.Balls.six)
      expect(ball.boundary).toBeTruthy()

  describe 'sneak run', ->
    it 'should increase the runs scored by one', ->
      ball.result = Terms.Balls.dot
      ball.sneak_run()
      expect(ball.result).toBe(Terms.Balls.one)
      ball.sneak_run()
      expect(ball.result).toBe(Terms.Balls.two)
      ball.sneak_run()
      expect(ball.result).toBe(Terms.Balls.three)
      ball.sneak_run()
      expect(ball.result).toBe(Terms.Balls.four)
      ball.sneak_run()
      expect(ball.result).toBe(Terms.Balls.four)

  describe 'cutoff run', ->
    it 'should decrease the runs scored by one', ->
      ball.result = Terms.Balls.four
      ball.cutoff_run()
      expect(ball.result).toBe(Terms.Balls.three)
      ball.cutoff_run()
      expect(ball.result).toBe(Terms.Balls.two)
      ball.cutoff_run()
      expect(ball.result).toBe(Terms.Balls.one)
      ball.cutoff_run()
      expect(ball.result).toBe(Terms.Balls.dot)
      ball.cutoff_run()
      expect(ball.result).toBe(Terms.Balls.dot)

  describe 'completed', ->
    it 'should set complete to true', ->
      expect(ball.complete).toBeFalsy()
      ball.finish()
      expect(ball.complete).toBeTruthy()

  describe 'has_no_run_snuck_and_cutff', ->
    it 'should return true if neither run snuck or cutoff', ->
      ball.was_run_snuck = false
      ball.was_run_cutoff = false
      expect(ball.has_no_run_snuck_and_cutoff()).toBeTruthy()

    it 'should return false if either run snuck or cutoff', ->
      ball.was_run_snuck = true
      ball.was_run_cutoff = false
      expect(ball.has_no_run_snuck_and_cutoff()).toBeFalsy()
      ball.was_run_snuck = false
      ball.was_run_cutoff = true
      expect(ball.has_no_run_snuck_and_cutoff()).toBeFalsy()
      
    it 'should return false if both run snuck and cutoff', ->
      ball.was_run_snuck = true
      ball.was_run_cutoff = true
      expect(ball.has_no_run_snuck_and_cutoff()).toBeFalsy()