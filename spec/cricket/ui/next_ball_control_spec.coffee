requirejs = require('../../spec_helper').requirejs
cricket = require('../../stubs/cricket')
button = require('../../stubs/lib').control
ui_builder = require('../../stubs/lib').ui_builder

module_mock = require('../../stubs/module_mock')
module_mock.reset(requirejs)

module_mock.stub(requirejs, 'ext/asevented', require('../../stubs/asevented').asevented)
module_mock.stub(requirejs, 'socket.io', require('../../stubs/socket.io').io)
module_mock.stub(requirejs, 'cricket/socket', require('../../stubs/socket.io').cricket_socket)

display = null
ball = cricket.ball()

NextBallControl = requirejs('cricket/ui/next_ball_control')

describe "the next ball control", ->
  beforeEach ->
    module_mock.capture_events_on(ball)
    module_mock.capture_click_events_on(button)
    display = new NextBallControl(ball, ui_builder)

  describe "when the ball stage is 'sneak_runs'", ->
    beforeEach ->
      ball.stage = 'sneak_runs'

    describe "when the ball updates", ->
      beforeEach ->
        ball.test_update()

      it "should show the button", ->
        expect(button.show).toHaveBeenCalled()

  describe "when the ball stage is 'cutoff_runs'", ->
    beforeEach ->
      ball.stage = 'cutoff_runs'

    describe "when the ball updates", ->
      beforeEach ->
        ball.test_update()

      it "should show the button", ->
        expect(button.show).toHaveBeenCalled()

  describe "when the ball stage is 'move_to_next_ball'", ->
    beforeEach ->
      ball.stage = 'move_to_next_ball'

    describe "when the ball updates", ->
      beforeEach ->
        ball.test_update()

      it "should show the button", ->
        expect(button.show).toHaveBeenCalled()

  describe "when the ball stage is not one of the above", ->
    beforeEach ->
      ball.stage = 'something_else'

    describe "when the ball updates", ->
      beforeEach ->
        ball.test_update()

      it "should show the button", ->
        expect(button.hide).toHaveBeenCalled()

  describe "when the button is clicked", ->
    beforeEach ->
      button.test_click()

    it "should emit a 'user wants to end delivery' message", ->
      expect(display.share_remotely).toHaveBeenCalledWith('player/user_wants_to_end_delivery')
