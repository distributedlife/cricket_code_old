requirejs = require('../spec_helper').requirejs

module_mock = require('../stubs/module_mock')
module_mock.reset(requirejs)

WaitForAllFactory = requirejs('lib/wait_for_all_factory')
notify_after = module_mock.spy_on(requirejs, 'lib/notify_after')

sequence = null
player_funcs = [
  'on_event', 'start_of_ball', 'play_ball', 'play_shot', 'sneak_runs', 'cutoff_runs',
  'move_to_next_ball'
]
batter = jasmine.createSpyObj('batter', player_funcs)
bowler = jasmine.createSpyObj('bowler', player_funcs)
field = "field"
ball = jasmine.createSpyObj('ball', ['set_stage'])
ball_factory = 
  create_ball: jasmine.createSpy().andReturn(ball) 
game_logic = jasmine.createSpyObj('game_logic', ['complete_delivery', 'score_ball'])

BallSequence = requirejs('cricket/ball_sequence')

describe 'a ball sequence', ->
  beforeEach ->
    module_mock.capture_events_on(batter)
    module_mock.capture_events_on(bowler)
    sequence = new BallSequence(ball_factory, new WaitForAllFactory(), game_logic, batter, bowler, field)

  it 'should send a complete event when results are recorded', -> 
    func_event_map = [
      {after: 'record_results', emit: 'complete'}
    ]
    expect(notify_after).toHaveBeenCalledWith(sequence, 'ball_sequence', func_event_map)

  describe 'when play is called', ->
    beforeEach ->
      sequence.play()

    it "should set the ball state to 'start'", ->
      expect(ball.set_stage).toHaveBeenCalledWith("start")

    it "should notify the batter and bowler of the start_of_ball stage", ->
      expect(batter.start_of_ball).toHaveBeenCalled()
      expect(bowler.start_of_ball).toHaveBeenCalled()

  describe 'when both batter and bowler complete the start_of_ball phase', ->
    beforeEach ->
      batter['test_ball_sequence/start_of_ball/complete']();
      bowler['test_ball_sequence/start_of_ball/complete']();

    it "should set the ball state to 'play ball'", ->
      expect(ball.set_stage).toHaveBeenCalledWith("play_ball")

    it "should notify the bowler of the play_ball stage", ->
      expect(batter.play_ball).not.toHaveBeenCalled()
      expect(bowler.play_ball).toHaveBeenCalled()

  describe "when the bowler completes the 'play ball' phase", ->
    beforeEach ->
      bowler['test_ball_sequence/play_ball/complete']();

    it "should set the ball state to 'play shot'", ->
      expect(ball.set_stage).toHaveBeenCalledWith("play_shot")

  describe "when the batter completes the 'play shot' phase", ->
    beforeEach ->
      batter['test_ball_sequence/play_shot/complete']();

    it "should set the ball state to 'sneak_runs'", ->
      expect(ball.set_stage).toHaveBeenCalledWith("sneak_runs")

    it "should calculate the current ball score", ->
      expect(game_logic.score_ball).toHaveBeenCalledWith(ball, field);

  describe "when the batter completes the 'sneak runs' phase", ->
    beforeEach ->
      batter['test_ball_sequence/sneak_runs/complete']();

    it "should set the ball state to 'cutoff_runs'", ->
      expect(ball.set_stage).toHaveBeenCalledWith("cutoff_runs")

  describe "when the bowler completes the 'cutoff runs' phase", ->
    beforeEach ->
      bowler['test_ball_sequence/cutoff_runs/complete']();

    it "should set the ball state to 'move_to_next_ball'", ->
      expect(ball.set_stage).toHaveBeenCalledWith("move_to_next_ball")

  describe "when both batter and bowler complete the 'move to next ball' phase", ->
    beforeEach ->
      batter['test_ball_sequence/move_to_next_ball/complete']();
      bowler['test_ball_sequence/move_to_next_ball/complete']();

    it "should perform the complete the delivery logic", ->
      expect(game_logic.complete_delivery).toHaveBeenCalledWith(ball, batter, bowler);
