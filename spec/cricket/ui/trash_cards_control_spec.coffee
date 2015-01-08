requirejs = require('../../spec_helper').requirejs
cricket = require('../../stubs/cricket')
control = require('../../stubs/lib').control
ui_builder = require('../../stubs/lib').ui_builder

module_mock = require('../../stubs/module_mock')
module_mock.reset(requirejs)

module_mock.stub(requirejs, 'ext/asevented', require('../../stubs/asevented').asevented)
module_mock.stub(requirejs, 'socket.io', require('../../stubs/socket.io').io)
module_mock.stub(requirejs, 'cricket/socket', require('../../stubs/socket.io').cricket_socket)

display = null
player = cricket.player()
current_over = cricket.over()

TrashCardsControl = requirejs('cricket/ui/trash_cards_control')

describe "the trash cards control", ->
  beforeEach ->
    module_mock.capture_events_on(player)
    module_mock.capture_events_on(current_over)
    display = new TrashCardsControl(player, current_over, ui_builder)

  it "should start hidden", ->
    expect(control.hide).toHaveBeenCalled()

  describe "when the current over stage is 'trash cards'", ->
    beforeEach ->
      current_over.stage = "trash_cards"

    describe "when the current over updates", ->
      beforeEach ->
        console.log(current_over)
        current_over.test_update()

      it "should enable the button", ->
        expect(control.enable).toHaveBeenCalled()

      it "should update the button text", ->
        expect(control.update_text).toHaveBeenCalled()

      it "should show the button", ->
        expect(control.show).toHaveBeenCalled()

  describe "when the current over stage is 'replenish cards'", ->
    beforeEach ->
      current_over.stage = "replenish_cards"

    describe "when the current over updates" ,->
      beforeEach ->
        current_over.test_update()

      it "should update the button text", ->
        expect(control.update_text).toHaveBeenCalled()

      it "should disable the button", ->
        expect(control.disable).toHaveBeenCalled()

      it "Should show the button", ->
        expect(control.show).toHaveBeenCalled()

    describe "when the player updates", ->
      beforeEach ->
        player.test_update()

      it "should update the button text", ->
        expect(control.update_text).toHaveBeenCalled()

      it "should disable the button", ->
        expect(control.disable).toHaveBeenCalled()

      it "Should show the button", ->
        expect(control.show).toHaveBeenCalled()

  describe "when the current over stage is anything else", ->
    beforeEach ->
      current_over.stage = "derp"

    describe "when the current over updates", ->
      beforeEach ->
        current_over.test_update()

      it "should hide the button", ->
        expect(control.hide).toHaveBeenCalled()

  describe "when the control is clicked", ->
    beforeEach ->
      control.test_click()

    it "should send a finish trashing cards event", ->
      expect(display.share_remotely).toHaveBeenCalledWith('player/finish_trashing_cards')
