requirejs = require('../spec_helper').requirejs
cricket = require('../stubs/cricket')

module_mock = require('../stubs/module_mock')
module_mock.reset(requirejs)

notify_after = module_mock.spy_on(requirejs, 'lib/notify_after')
will_wire_push = module_mock.spy_on(requirejs, 'lib/will_wire_push')

over = {}
connection = {}
ball = cricket.ball()
become_server_over = requirejs('cricket/server_over')

describe 'a server over', ->
	beforeEach ->
		over = {}
		become_server_over(over, connection);

	it 'should push updates over the wire', ->
		push_when =
			init: 'over/create'
			new_ball: 'over/update'
			set_stage: 'over/update'
			propagate: 'over/update'

		push_fields =
			id: 'id'
			balls: 'balls'
			balls_in_over: 'balls_in_over'
			stage: 'stage'

		expect(will_wire_push).toHaveBeenCalledWith(over, connection, push_when, push_fields)

	it 'should emit events after changes', ->	
		emit_when = [
			{after: 'init', emit: 'create'},
			{after: 'new_ball', emit: 'update'},
			{after: 'set_stage', emit: 'update'}
			{after: 'propagate', emit: 'update'}
			{after: 'check_for_complete', when: server.check_for_complete, emit: 'complete'}
		]

		expect(notify_after).toHaveBeenCalledWith(over, 'server_over', emit_when)

	describe "adding a new ball", ->
		beforeEach ->
			module_mock.listen_for_events_on(ball)
			over.new_ball(ball)

		it "should add the ball to the over balls", ->
			expect(over.balls).toEqual([ball])

	describe "when an added ball updates", ->
		beforeEach ->
			module_mock.capture_events_on(ball)
			over.propagate = jasmine.createSpy('propagate')
			over.new_ball(ball)
			ball.test_update()

		it "should propagate the event", ->
			expect(over.propagate).toHaveBeenCalled()

	describe "when an added ball completes", ->
		beforeEach ->
			module_mock.capture_events_on(ball)
			over.check_for_complete = jasmine.createSpy('check_for_complete')
			over.new_ball(ball)
			ball.test_complete()

		it "should check if the over is complete", ->
			expect(over.check_for_complete).toHaveBeenCalled()

	describe "check for complete", ->
		it "should return true if the over is complete", ->
			over.complete = -> true
			expect(over.check_for_complete()).toBeTruthy()
			over.complete = -> false
			expect(over.check_for_complete()).toBeFalsy()
