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

CutoffRunControl = requirejs('cricket/ui/cutoff_run_control')

describe "cutoff run control", ->
  beforeEach ->
    module_mock.listen_for_events_on(player)
    module_mock.listen_for_events_on(ball)
    display = new CutoffRunControl(player, ball, ui_builder)

  it "should listen for player and ball updates", ->
    expect(player.on_event).toHaveBeenCalledWith('update', jasmine.any(Function))
    expect(ball.on_event).toHaveBeenCalledWith('update', jasmine.any(Function))

  describe "refreshing", ->
    beforeEach ->
      module_mock.capture_events_on(player)
      module_mock.capture_events_on(ball)
      ball.stage = "cutoff_runs"
      player.is_bowling = -> true
      display = new CutoffRunControl(player, ball, ui_builder)
      control.hide.reset()
      control.show.reset()

    it "should be hidden when the stage is not sneak runs", ->
      ball.stage = "something"
      player.test_update()
      expect(control.hide).toHaveBeenCalled()

      control.hide.reset()
      ball.test_update()
      expect(control.hide).toHaveBeenCalled()

    it "should be hidden when the player is not batting", ->
      player.is_bowling = -> false
      player.test_update()
      expect(control.hide).toHaveBeenCalled()

      control.hide.reset()
      ball.test_update()
      expect(control.hide).toHaveBeenCalled()

    it "should be shown otherwise", ->
      player.test_update()
      expect(control.show).toHaveBeenCalled()

      control.show.reset()
      ball.test_update()
      expect(control.show).toHaveBeenCalled()

  describe "when clicked", ->
    beforeEach ->
      module_mock.capture_click_events_on(control)
      display = new CutoffRunControl(player, ball, ui_builder)

    it "should send a user cutoff run event", ->
      control.test_click()
      expect(display.share_remotely).toHaveBeenCalledWith('player/user_cutoff_run')
