requirejs = require('../../spec_helper').requirejs
cricket = require('../../stubs/cricket')
control = require('../../stubs/lib').control
ui_builder = require('../../stubs/lib').ui_builder

module_mock = require('../../stubs/module_mock')
module_mock.reset(requirejs)

module_mock.stub(requirejs, 'socket.io', require('../../stubs/socket.io').io)
module_mock.stub(requirejs, 'cricket/socket', require('../../stubs/socket.io').cricket_socket)

display = null
player = cricket.player()
ball = cricket.ball()
field = cricket.field()

ChangeFieldControl = requirejs('cricket/ui/change_field_control')

describe "a change field control", ->
	beforeEach ->
		module_mock.capture_events_on(player)
		module_mock.capture_events_on(ball)
		module_mock.capture_events_on(field)
		display = new ChangeFieldControl(player, ball, field, ui_builder)
		ball.stage = 'play_ball'
		player.has_momentum = -> true
		player.is_batting = -> false
		field.is_being_set= -> false

	describe "when the player updates", ->
		beforeEach ->
			player.test_update()

		it "should be shown", ->
			expect(control.show).toHaveBeenCalled()

	describe "when the field updates", ->
		beforeEach ->
			field.test_update()

		it "should be shown", ->
			expect(control.show).toHaveBeenCalled()

	describe "when the ball updates", ->
		beforeEach ->
			ball.test_update()

		it "should be shown", ->
			expect(control.show).toHaveBeenCalled()

	describe "when the stage is not 'play_ball'", ->
		beforeEach ->
			ball.stage = 'something'
			ball.test_update()

		it "should be hidden", ->
			expect(control.hide).toHaveBeenCalled()

	describe "when the player has no momentum", ->
		beforeEach ->
			player.has_momentum = -> false
			player.test_update()

		it "should be hidden", ->
			expect(control.hide).toHaveBeenCalled()

	describe "when the player is batting", ->
		beforeEach ->
			player.has_momentum = -> true
			player.test_update()

	describe "when the field is being set", ->
		beforeEach ->
			field.is_being_set= -> true
			field.test_update()

		it "should be hidden", ->
			expect(control.hide).toHaveBeenCalled()


	describe "emitting a change field using momentum event", ->
		beforeEach ->
			module_mock.capture_click_events_on(control)
			display = new ChangeFieldControl(player, ball, field, ui_builder)
			control.test_click()

		it "should emit the event", ->
			expect(display.share_remotely).toHaveBeenCalledWith('field/start_setting_field')
