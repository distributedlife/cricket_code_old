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

LeaveBallControl = requirejs('cricket/ui/leave_ball_control')

describe "the leave ball control", ->
  beforeEach ->
    module_mock.capture_events_on(player)
    module_mock.capture_events_on(ball)
    module_mock.capture_click_events_on(control)
    control.hide.reset()
    control.show.reset()
    display = new LeaveBallControl(player, ball, ui_builder)

  describe "when the player is batting", ->
    beforeEach ->
      player.is_batting = () -> true

    describe "and the current ball stage is 'play_shot'", ->
      beforeEach ->
        ball.stage = 'play_shot'

      describe "and the player is updated", ->
        beforeEach ->
          player.test_update()

        it "should be shown", ->
          expect(control.show).toHaveBeenCalled()

  describe "and the current ball stage is not 'play_shot'", ->
    beforeEach ->
      ball.stage = 'anything_but'

    describe "and the ball is updated", ->
      beforeEach ->
        ball.test_update()

      it "should be hidden", ->
        expect(control.hide).toHaveBeenCalled()

  describe "when the player is bowling", ->
    beforeEach ->
      player.is_batting = () -> false

    describe "and the ball is updated", ->
      beforeEach ->
        player.test_update()

      it "should be hidden", ->
        expect(control.hide).toHaveBeenCalled()

  describe "clicking the button", ->
    beforeEach ->
      display = new LeaveBallControl(player, ball, ui_builder)

    it "should send a user sneak run event", ->
      control.test_click()
      expect(display.share_remotely).toHaveBeenCalledWith('player/user_leave_ball')
