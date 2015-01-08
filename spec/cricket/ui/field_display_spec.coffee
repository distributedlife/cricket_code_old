requirejs = require('../../spec_helper').requirejs
cricket = require('../../stubs/cricket')
button = require('../../stubs/lib').control
label = require('../../stubs/lib').label
ui_builder = require('../../stubs/lib').ui_builder

module_mock = require('../../stubs/module_mock')
module_mock.reset(requirejs)

module_mock.stub(requirejs, 'socket.io', require('../../stubs/socket.io').io)
module_mock.stub(requirejs, 'cricket/socket', require('../../stubs/socket.io').cricket_socket)

display = null
field = cricket.field()
field.infield.push({name: "cut", has_fielder: true})
field.outfield.push({name: "cut", has_fielder: false})

FieldDisplay = requirejs('cricket/ui/field_display')

describe "field display", ->
	beforeEach ->
		module_mock.capture_events_on(field)
		ui_builder.build_control.reset()
		button.enable.reset()
		button.disable.reset()
		display = new FieldDisplay(field, ui_builder)

	it "should setup each position", ->
    expect(ui_builder.build_control.callCount).toBe(2)
	
	it "should start with disable links", ->
		expect(button.disable.callCount).toBe(2)

	describe "when the field is being set", ->
		beforeEach ->
			field.is_being_set = -> true

		describe "when the field updates", ->
			beforeEach ->
				field.test_update()

			it "should enable all links", ->
				expect(button.enable.callCount).toBe(2)

	describe "when the field is not being set", ->
		beforeEach ->
			field.is_being_set = -> false

		describe "when the field updates", ->
			beforeEach ->
				button.disable.reset()
				field.test_update()

			it "should disable all links", ->
				expect(button.disable.callCount).toBe(2)

	describe "when the field updates", ->
		beforeEach ->
			field.slips = 3
			button.update_text.reset()
			field.test_update()

		it "should update the slips count", ->
			expect(label.update_text).toHaveBeenCalledWith(3)

		it "should update vacant fielding positions", ->
			expect(button.update_text).toHaveBeenCalledWith("outfield:occupied")

		it "should update occupied fielding positions", ->
			expect(button.update_text).toHaveBeenCalledWith("outfield:vacant")

	describe "toggling an infielder", ->
		beforeEach ->
			module_mock.capture_click_events_on(button)
			field = cricket.field()
			field.infield.push({name: "cut"})
			display = new FieldDisplay(field, ui_builder)
			button.test_click()

		it "should send a toggle fielder event", ->
    	expect(display.share_remotely).toHaveBeenCalledWith('field/toggle_fielder', {distance: 'infield', shot: 'cut'})

	describe "toggling an outfielder", ->
		beforeEach ->
			module_mock.capture_click_events_on(button)
			field = cricket.field()
			field.outfield.push({name: "leg_glance"})
			display = new FieldDisplay(field, ui_builder)
			button.test_click()

		it "should send a toggle fielder event", ->
			expect(display.share_remotely).toHaveBeenCalledWith('field/toggle_fielder', {distance: 'outfield', shot: 'leg_glance'})
