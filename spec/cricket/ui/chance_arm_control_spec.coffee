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
ball = cricket.ball()
selected_card = cricket.selected_card()

ChanceArmControl = requirejs('cricket/ui/chance_arm_control')

describe "the chance arm control", ->
  beforeEach ->
    module_mock.listen_for_events_on(player)
    module_mock.listen_for_events_on(ball)
    module_mock.listen_for_events_on(selected_card)
    display = new ChanceArmControl(player, ball, selected_card, ui_builder)

  describe "in general", ->
    it "should refresh on updates from the player, current_ball and selected_card", ->
      expect(player.on_event).toHaveBeenCalledWith('update', jasmine.any(Function))
      expect(ball.on_event).toHaveBeenCalledWith('update', jasmine.any(Function))
      expect(selected_card.on_event).toHaveBeenCalledWith('update', jasmine.any(Function))

  describe "refreshing", ->
    beforeEach ->
      module_mock.capture_events_on(player)
      module_mock.capture_events_on(ball)
      module_mock.capture_events_on(selected_card)
      ball.stage = "play_shot"
      player.is_bowling = -> false
      player.momentum = -> 1
      selected_card.index = 'something'
      selected_card.card = {}
      selected_card.card.shot = 'sookie'
      display = new ChanceArmControl(player, ball, selected_card, ui_builder)

    it "should show the control", ->
      control.show.reset()
      player.test_update()
      expect(control.show).toHaveBeenCalled()

      control.show.reset()
      ball.test_update()
      expect(control.show).toHaveBeenCalled()

      control.show.reset()
      selected_card.test_update()
      expect(control.show).toHaveBeenCalled()

    it "should hide the control when the ball stage is not play_shot", ->
      ball.stage = "banana"

      control.hide.reset()
      player.test_update()
      expect(control.hide).toHaveBeenCalled()

      control.hide.reset()
      ball.test_update()
      expect(control.hide).toHaveBeenCalled()

      control.hide.reset()
      selected_card.test_update()
      expect(control.hide).toHaveBeenCalled()

    it "should hide the control when the player is bowling", ->
      player.is_bowling = -> true

      control.hide.reset()
      player.test_update()
      expect(control.hide).toHaveBeenCalled()

      control.hide.reset()
      ball.test_update()
      expect(control.hide).toHaveBeenCalled()

      control.hide.reset()
      selected_card.test_update()
      expect(control.hide).toHaveBeenCalled()

    it "should hide the control when the selected_card index is null", ->
      player.momentum = -> 0

      control.hide.reset()
      player.test_update()
      expect(control.hide).toHaveBeenCalled()

      control.hide.reset()
      ball.test_update()
      expect(control.hide).toHaveBeenCalled()

      control.hide.reset()
      selected_card.test_update()
      expect(control.hide).toHaveBeenCalled()

    it "should hide the control when the player has no momentum", ->
      selected_card.index = null

      control.hide.reset()
      player.test_update()
      expect(control.hide).toHaveBeenCalled()

      control.hide.reset()
      ball.test_update()
      expect(control.hide).toHaveBeenCalled()

      control.hide.reset()
      selected_card.test_update()
      expect(control.hide).toHaveBeenCalled()

    it "should hide the control when the selected_card card is null", ->
      selected_card.card = null

      control.hide.reset()
      player.test_update()
      expect(control.hide).toHaveBeenCalled()

      control.hide.reset()
      ball.test_update()
      expect(control.hide).toHaveBeenCalled()

      control.hide.reset()
      selected_card.test_update()
      expect(control.hide).toHaveBeenCalled()

    it "should hide the control when the selected_card card shot is a block", ->
      selected_card.card.shot = 'block'

      control.hide.reset()
      player.test_update()
      expect(control.hide).toHaveBeenCalled()

      control.hide.reset()
      ball.test_update()
      expect(control.hide).toHaveBeenCalled()

      control.hide.reset()
      selected_card.test_update()
      expect(control.hide).toHaveBeenCalled()

  describe 'sending a chance arm event', ->
    beforeEach ->
      module_mock.capture_click_events_on(control)
      display = new ChanceArmControl(player, ball, selected_card, ui_builder)

    it "should send the event when clicked", ->      
      control.test_click()
      expect(display.share_remotely).toHaveBeenCalledWith('player/user_chance_arm')
