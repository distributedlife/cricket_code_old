requirejs = require('../spec_helper').requirejs

module_mock = require('../stubs/module_mock')
module_mock.reset(requirejs)

notify_after = module_mock.spy_on(requirejs, 'lib/notify_after')
WaitForAllFactory = requirejs('lib/wait_for_all_factory')

sequence = null
player_funcs = [
  'set_field', 'seed_momentum', 'draw_hand', 'trash_cards', 'replenish_cards', 'discard_hand', 'set_momentum', 'draw_hand'
]
batter = jasmine.createSpyObj('batter', player_funcs)
bowler = jasmine.createSpyObj('bowler', player_funcs)
field = "field"
over = jasmine.createSpyObj('over', ['set_stage', 'complete', 'new_ball'])
game_behaviour = jasmine.createSpyObj('game_behaviour', ['start_setting_field', 'stop_setting_field'])
over_builder =
  build: jasmine.createSpy().andReturn(over)
ball_sequence = jasmine.createSpyObj('ball_sequence', ['play', 'on_event'])
ball = "ball"
ball_sequence.ball = ball
sequence_factory =
  build_ball_sequence: jasmine.createSpy().andReturn(ball_sequence)

OverSequence = requirejs('cricket/over_sequence')

describe 'an over sequence', ->
  beforeEach ->
    module_mock.capture_events_on(batter)
    module_mock.capture_events_on(bowler)
    module_mock.capture_events_on(ball_sequence)
    sequence = new OverSequence(batter, bowler, field, game_behaviour, new WaitForAllFactory(), over_builder, sequence_factory)

  it 'should send a complete event when results are recorded', -> 
    func_event_map = [
      {after: 'complete_over', emit: 'complete'}
    ]
    expect(notify_after).toHaveBeenCalledWith(sequence, 'over_sequence', func_event_map)

  describe 'when play is called', ->
    beforeEach ->
      sequence.play()

    it "should set the over state to 'field'", ->
      expect(over.set_stage).toHaveBeenCalledWith("set_field")

    it "should notify the bowler of the set_field stage", ->
      expect(batter.set_field).not.toHaveBeenCalled()
      expect(bowler.set_field).toHaveBeenCalled()

    it "should invoke the start setting field game logic", ->
      # expect(false).toBeTruthy()

  describe 'when the bowler complete the set_field phase', ->
    beforeEach ->
      bowler['test_over_sequence/set_field/complete']();

    it "should set the over state to 'seed_momentum'", ->
      expect(over.set_stage).toHaveBeenCalledWith("seed_momentum")

    it "should notify the batter and bowler of the seed_momentum stage", ->
      expect(batter.seed_momentum).toHaveBeenCalled()
      expect(bowler.seed_momentum).toHaveBeenCalled()

    it "should invoke the stop setting field game logic", ->
      # expect(false).toBeTruthy()


  describe 'when the batter and bowler complete the seed_momentum phase', ->
    beforeEach ->
      batter['test_over_sequence/seed_momentum/complete']();
      bowler['test_over_sequence/seed_momentum/complete']();

    it "should set the over state to 'draw_hand'", ->
      expect(over.set_stage).toHaveBeenCalledWith("draw_hand")

    it "should notify the batter and bowler of the play_ball stage", ->
      expect(batter.seed_momentum).toHaveBeenCalled()
      expect(bowler.seed_momentum).toHaveBeenCalled()

  describe 'when the batter and bowler complete the draw_hand phase', ->
    beforeEach ->
      over.complete = -> false
      batter['test_over_sequence/draw_hand/complete']();
      bowler['test_over_sequence/draw_hand/complete']();

    it "should set the over state to 'in_progress'", ->
      expect(over.set_stage).toHaveBeenCalledWith("in_progress")



  describe "when the over is not complete", ->
    beforeEach ->
      over.complete = -> false

    describe "when the ball sequence completes", ->
      beforeEach ->
        ball_sequence.test_complete()

      it "should create a new ball sequence", ->
        expect(sequence_factory.build_ball_sequence).toHaveBeenCalled()

      it "should start the ball sequence", ->
        expect(over.new_ball).toHaveBeenCalledWith(ball)

  describe "when the over is complete", ->
    beforeEach ->
      over.complete = -> true

    describe "when the ball sequence completes", ->
      beforeEach ->
        ball_sequence.test_complete()

      it "should set the over state to 'trash_cards'", ->
        expect(over.set_stage).toHaveBeenCalledWith("trash_cards")

      it "should notify the batter and bowler of the trash_cards stage", ->
        expect(batter.trash_cards).toHaveBeenCalled()
        expect(bowler.trash_cards).toHaveBeenCalled()


  describe 'when the batter and bowler complete the trash_cards phase', ->
    beforeEach ->
      batter['test_over_sequence/trash_cards/complete']();
      bowler['test_over_sequence/trash_cards/complete']();

    it "should set the over state to 'replenish_cards'", ->
      expect(over.set_stage).toHaveBeenCalledWith("replenish_cards")

    it "should notify the batter and bowler of the replenish_cards stage", ->
      expect(batter.replenish_cards).toHaveBeenCalled()
      expect(bowler.replenish_cards).toHaveBeenCalled()

  describe 'when the batter and bowler complete the replenish_cards phase', ->
    beforeEach ->
      batter['test_over_sequence/replenish_cards/complete']();
      bowler['test_over_sequence/replenish_cards/complete']();

    it "should set the over state to 'discard_hand'", ->
      expect(over.set_stage).toHaveBeenCalledWith("discard_hand")

    it "should notify the batter and bowler of the discard_hand stage", ->
      expect(batter.discard_hand).toHaveBeenCalled()
      expect(bowler.discard_hand).toHaveBeenCalled()

  describe 'when the batter and bowler complete the discard_hand phase', ->
    beforeEach ->
      batter['test_over_sequence/discard_hand/complete']();
      bowler['test_over_sequence/discard_hand/complete']();

    it "should set the over state to 'complete'", ->
      expect(over.set_stage).toHaveBeenCalledWith("complete")
