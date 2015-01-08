requirejs = require('../spec_helper').requirejs
asevented = require('../stubs/asevented').asevented
io = require('../stubs/socket.io').io
module_mock = require('../stubs/module_mock')
module_mock.reset(requirejs)

innings = null
over_limit = 20
wickets = 10
over = null

module_mock.stub(requirejs, 'ext/asevented', asevented)
module_mock.stub(requirejs, 'socket.io', io)

Innings = requirejs('cricket/innings')
describe "an innings", ->
  beforeEach ->
    innings = new Innings(over_limit, wickets)

  describe "creating an innings", ->
    it "should take an over limit", ->
      expect(innings.over_limit).toBe(over_limit)

    it "should take a wicket limit", ->
      expect(innings.wickets).toBe(wickets)

  describe "runs", ->
    beforeEach ->
      over1 =
        runs: -> 15
      over2 =
        runs: -> 1
      innings.overs = [over1, over2]

    it "should return the number of runs scored in the innings so far", ->
        expect(innings.runs()).toBe(16)

  describe "wickets_lost", ->
    beforeEach ->
      over1 =
        wickets: -> 0
      over2 =
        wickets: -> 1
      innings.overs = [over1, over2]

    it "should return the number of wickets lost in the innings so far", ->
      expect(innings.wickets_lost()).toBe(1)

  describe "record", ->
    it "should return a record of the outcome of each over", ->
      over1 = {record: -> "x134.nb"}
      over2 = {record: -> "..2.4."}
      innings.overs = [over1, over2]

      expect(innings.record()).toBe("x134.nb ..2.4.")

  describe "overs_bowled", ->
    beforeEach ->
      over1 =
        balls_bowled: -> 6
        complete: -> true
        in_progress: -> false
      over2 =
        complete: -> false
        in_progress: -> true
        balls_bowled: -> 3
      innings.overs = [over1, over2]

    it "should return the current over in decimal form i.e 18.3", ->
      expect(innings.overs_bowled()).toBe(1.3)

  describe "complete", ->
    it "returns true if wickets lost equals the limit", ->
      innings.wickets_lost = -> 10
      expect(innings.complete()).toBeTruthy()
      innings.wickets_lost = -> 9
      expect(innings.complete()).toBeFalsy()

    it "returns true if overs completed equals the limit", ->
      innings.overs_bowled= -> 20.0
      expect(innings.complete()).toBeTruthy()
      innings.overs_bowled = -> 19.5
      expect(innings.complete()).toBeFalsy()

    it "returns true if the innings total exceeds the target", ->
      expect(innings.complete()).toBeFalsy()
      innings.target = 1
      innings.runs = -> 2
      expect(innings.complete()).toBeTruthy()

    it "ignores the target when target is not set", ->
      expect(innings.complete()).toBeFalsy()
      innings.target = null
      innings.runs = -> 2
      expect(innings.complete()).toBeFalsy()

  describe "new over", ->
    beforeEach ->
      over =
        on_event: jasmine.createSpy('over.on_event')

    it "should add the over to the innings", ->
      innings.new_over(over)
      expect(innings.overs.length).toBe(1)
      innings.new_over(over)
      expect(innings.overs.length).toBe(2)

    it "listen for over update and complete events", ->
      innings.new_over(over)
      expect(over.on_event).toHaveBeenCalledWith('update', jasmine.any(Function))
      expect(over.on_event).toHaveBeenCalledWith('complete', jasmine.any(Function))

    it "should emit a new over event", ->
      innings.share_locally = jasmine.createSpy('innings.share_locally')
      innings.new_over(over)
      expect(innings.share_locally).toHaveBeenCalledWith('new_over', over)

  describe "run rate", ->
    it "should calculate the run rate for the innings", ->
      innings.runs = -> 10
      innings.legitimate_balls_faced = -> 6
      expect(innings.run_rate()).toBe('10.00')
      innings.runs = -> 10
      innings.legitimate_balls_faced = -> 12
      expect(innings.run_rate()).toBe('5.00')
      innings.runs = -> 10
      innings.legitimate_balls_faced = -> 3
      expect(innings.run_rate()).toBe('20.00')

  describe "required run rate", ->
    it "should calculate the required run rate for the innings", ->
      innings.target = 20
      innings.runs = -> 0
      innings.legitimate_balls_faced = -> 0
      expect(innings.required_run_rate()).toEqual('1.00')
      innings.target = 40
      expect(innings.required_run_rate()).toEqual('2.00')
      innings.runs = -> 20
      expect(innings.required_run_rate()).toEqual('1.00')
      innings.runs = -> 30
      innings.legitimate_balls_faced -> 60
      expect(innings.required_run_rate()).toEqual('0.50')

  describe "legitimate balls faced", ->
    it "should return the number of legal balls in the over that are complete", ->
      over1 = {complete: -> true}
      over2 =
        complete: -> false
        balls_bowled: -> 3
      innings.overs = [over1, over2]
      expect(innings.legitimate_balls_faced()).toBe(9)

  describe "in progress", ->
    it "should return false if the innings is not complete", ->
      innings.complete = -> false
      expect(innings.in_progress()).toBeTruthy()
      innings.complete = -> true
      expect(innings.in_progress()).toBeFalsy()

  describe "has updated", ->
    it "should notify listeners of changes", ->
      innings.share_locally = jasmine.createSpy('innings.share_locally')
      innings.has_updated()
      expect(innings.share_locally).toHaveBeenCalledWith('update', innings)

    it "when complete it should notify listeners of complete", ->
      innings.share_locally = jasmine.createSpy('innings.share_locally')
      innings.has_updated()
      expect(innings.share_locally).not.toHaveBeenCalledWith('complete', innings)
      innings.complete = -> true
      innings.has_updated()
      expect(innings.share_locally).toHaveBeenCalledWith('complete', innings)
