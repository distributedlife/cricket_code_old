requirejs = require('../../spec_helper').requirejs
cricket = require('../../stubs/cricket')
button = require('../../stubs/lib').control
ui_builder = require('../../stubs/lib').ui_builder

module_mock = require('../../stubs/module_mock')
module_mock.reset(requirejs)

module_mock.stub(requirejs, 'socket.io', require('../../stubs/socket.io').io)
module_mock.stub(requirejs, 'cricket/socket', require('../../stubs/socket.io').cricket_socket)

display = null
field = cricket.field()
validator = cricket.validator()

Fieldbutton = requirejs('cricket/ui/field_control')

describe "the field button", ->
	beforeEach ->
		module_mock.capture_events_on(field)
		display = new Fieldbutton(field, validator, ui_builder)
		field.is_being_set = -> true

	describe "when the field updates", ->
		beforeEach ->
			field.test_update()

		it "should show the button", ->
			expect(button.show).toHaveBeenCalled()

		describe "when the field is invalid", ->
			beforeEach ->
				validator.validate_field = (field) -> false

			it "should update the text", ->
				expect(button.update_text).toHaveBeenCalled()

			it "should disable the button", ->
				expect(button.disable).toHaveBeenCalled()

		describe "when the field is valid" ,->
			beforeEach ->
				validator.validate_field = (field) -> true

			it "should update the test", ->
				expect(button.update_text).toHaveBeenCalled()

			it "should enable the button", ->
				expect(button.enable).toHaveBeenCalled()

		describe "when the field is not being set", ->
			beforeEach ->
				field.is_being_set = -> true

			it "should hide the button", ->
				expect(button.hide).toHaveBeenCalled()

	describe "share user has finished setting field", ->
  	beforeEach ->
			module_mock.capture_click_events_on(button)
			display = new Fieldbutton(field, validator, ui_builder)

		it "should emit a 'user has finished setting field' event", ->
			button.test_click()
			expect(display.share_remotely).toHaveBeenCalledWith('field/user_has_finished_setting_field')
