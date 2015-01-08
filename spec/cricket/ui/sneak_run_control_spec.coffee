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

SneakRunControl = requirejs('cricket/ui/sneak_run_control')

describe "sneak run control", ->
  beforeEach ->
    module_mock.listen_for_events_on(player)
    module_mock.listen_for_events_on(ball)
    display = new SneakRunControl(player, ball, ui_builder)

  it "should listen for player and ball updates", ->
    expect(player.on_event).toHaveBeenCalledWith('update', jasmine.any(Function))
    expect(ball.on_event).toHaveBeenCalledWith('update', jasmine.any(Function))
    
  describe "when the player is batting and the ball stage is 'sneak_runs'", ->
    beforeEach ->
      module_mock.capture_events_on(player)
      module_mock.capture_events_on(ball)
      player.is_batting = -> true
      ball.stage = "sneak_runs"
      display = new SneakRunControl(player, ball, ui_builder)
      control.hide.reset()
      control.show.reset()

    describe "when the player updates", ->
      beforeEach ->
        player.test_update()

      it "should show the control", ->
        expect(control.show).toHaveBeenCalled()

    describe "or when the ball updates", ->
      beforeEach ->
        ball.test_update()

      it "should show the control", ->
        expect(control.show).toHaveBeenCalled()

    describe "when the player is not batting", ->
      beforeEach ->
        player.is_batting = -> false

      describe "when the player updates", ->
        beforeEach ->
          player.test_update()

        it "should hide the control", ->
          expect(control.hide).toHaveBeenCalled()

    describe "when the ball state is not 'sneak runs'", ->
      beforeEach ->
        ball.stage = "something"

      describe "when the ball updates", ->
        beforeEach ->
          ball.test_update()

        it "should hide the control", ->
          expect(control.hide).toHaveBeenCalled()

  describe "when clicked", ->
    beforeEach ->
      module_mock.capture_click_events_on(control)
      display = new SneakRunControl(player, ball, ui_builder)
      control.test_click()

    it "should send a user sneak run event", ->
      expect(display.share_remotely).toHaveBeenCalledWith('player/user_sneak_run')
