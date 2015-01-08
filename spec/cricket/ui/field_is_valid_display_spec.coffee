requirejs = require('../../spec_helper').requirejs
cricket = require('../../stubs/cricket')
label = require('../../stubs/lib').label
ui_builder = require('../../stubs/lib').ui_builder

module_mock = require('../../stubs/module_mock')
module_mock.reset(requirejs)

display = null
field = cricket.field()
validator = cricket.validator()

FieldIsValidDisplay = requirejs('cricket/ui/field_is_valid_display')

describe "the field is valid display", ->
	beforeEach ->
		module_mock.capture_events_on(field)
		display = new FieldIsValidDisplay(field, validator, ui_builder)

	it "should be hidden if the field is valid", ->
		validator.validate_field = () -> true
		field.test_update()
		expect(label.hide).toHaveBeenCalled()

	it "should be shown if the field is invalid", ->
		validator.validate_field = () -> false
		field.test_update()
		expect(label.show).toHaveBeenCalled()
