requirejs = require('../spec_helper').requirejs

module_mock = require('../stubs/module_mock')
module_mock.reset(requirejs)

WaitForAllFactory = requirejs('lib/wait_for_all_factory')
notify_after = module_mock.spy_on(requirejs, 'lib/notify_after')

asevented = require('../stubs/asevented').asevented

sequence = null
batter = jasmine.createSpyObj('batter', ['start_new_innings'])
bowler = jasmine.createSpyObj('bowler', ['start_new_innings'])
innings = jasmine.createSpyObj('innings', ['new_over'])
innings.batter = batter
innings.bowler = bowler
field = "field"
over = "over"
over_sequence = jasmine.createSpyObj('over_sequence', ['play'])
over_sequence.over = over
sequence_factory =
  build_over_sequence: jasmine.createSpy().andReturn(over_sequence)

module_mock.stub(requirejs, 'ext/asevented', asevented)
# WaitForAll = module_mock.spy_and_mock(requirejs, 'lib/wait_for_all', wait_for_all)

InningsSequence = requirejs('cricket/innings_sequence')

describe "the innings sequence", ->
  beforeEach ->
    module_mock.capture_events_on(batter)
    module_mock.capture_events_on(bowler)
    module_mock.capture_events_on(over_sequence)
    sequence = new InningsSequence(innings, field, sequence_factory, new WaitForAllFactory())

  it 'should send a complete event when results are recorded', -> 
    func_event_map = [
      {after: 'complete', emit: 'complete'}
    ]
    expect(notify_after).toHaveBeenCalledWith(sequence, 'innings_sequence', func_event_map)

  describe 'when play is called', ->
    beforeEach ->
      sequence.play()

    it "should notify the batter and bowler of the start_new_innings", ->
      expect(batter.start_new_innings).toHaveBeenCalled()
      expect(bowler.start_new_innings).toHaveBeenCalled()

  describe 'when both batter and bowler complete the start_new_innings phase', ->
    beforeEach ->
      innings.complete = -> false
      batter['test_innings_sequence/start_new_innings/complete']();
      bowler['test_innings_sequence/start_new_innings/complete']();

    it "should build a new over sequence", ->
      expect(sequence_factory.build_over_sequence).toHaveBeenCalled()

    it "should add the new over to the innings", ->
      expect(innings.new_over).toHaveBeenCalledWith(over)

  describe "when the innings is incomplete", ->
    beforeEach ->
      innings.complete = -> false

    describe "when the ball sequence completes", ->
      beforeEach ->
        ball_sequence.test_complete()

    it "should build a new over sequence", ->
      expect(sequence_factory.build_over_sequence).toHaveBeenCalled()

    it "should add the new over to the innings", ->
      expect(innings.new_over).toHaveBeenCalledWith(over)

  describe "when the innings is complete", ->
    beforeEach ->
      sequence_factory.build_over_sequence.reset()
      innings.complete = -> true
      
    describe "when the ball sequence completes", ->
      beforeEach ->
        ball_sequence.test_complete()

    it "should not build a new over sequence", ->
      expect(sequence_factory.build_over_sequence).not.toHaveBeenCalled()
