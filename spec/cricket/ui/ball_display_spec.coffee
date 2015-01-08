requirejs = require('../../spec_helper').requirejs
cricket = require('../../stubs/cricket')
label = require('../../stubs/lib').label
ui_builder = require('../../stubs/lib').ui_builder

module_mock = require('../../stubs/module_mock')
module_mock.reset(requirejs)

display = null
ball = null
ball_with_props_not_set =
  _length: null
  _play: null
  _shot: null
  _height: null
  _distance: null
  _chancing_arm: false
  _result: null
ball_with_props_set =
  _length: 'full'
  _play: 'play'
  _shot: 'shot'
  _height: 'height'
  _distance: 'a million miles'
  _chancing_arm: true
  _result: 'unknown'

BallDisplay = requirejs('cricket/ui/ball_display')

describe "the ball display", ->
  beforeEach ->
    ball = cricket.ball()
    module_mock.listen_for_events_on(ball)
    display = new BallDisplay(ball, ui_builder)

  it "should refresh the display when the ball is update", ->
    expect(ball.on_event).toHaveBeenCalledWith('update', jasmine.any(Function))

describe "refreshing the display", ->
  it "should set the display property to not set if the ball value is not set", ->
    ball = cricket.ball(ball_with_props_not_set)
    module_mock.capture_events_on(ball)
    display = new BallDisplay(ball, ui_builder)
    ball.test_update()
    expect(label.update_text).toHaveBeenCalledWith('not set')
    expect(label.update_text).toHaveBeenCalledWith('not set')
    expect(label.update_text).toHaveBeenCalledWith('not set')
    expect(label.update_text).toHaveBeenCalledWith('not set')
    expect(label.update_text).toHaveBeenCalledWith('not set')
    expect(label.update_text).toHaveBeenCalledWith('no')
    expect(label.update_text).toHaveBeenCalledWith('not set')

  it "should colour the length text based on the ball length", ->
    ball = cricket.ball(ball_with_props_not_set)
    module_mock.capture_events_on(ball)
    display = new BallDisplay(ball, ui_builder)
    ball.test_update()
    expect(label.add_class).toHaveBeenCalledWith('not set')

    ball = cricket.ball(ball_with_props_set)
    module_mock.capture_events_on(ball)
    display = new BallDisplay(ball, ui_builder)
    ball.test_update()
    expect(label.add_class).toHaveBeenCalledWith('full')

  it "should set the display properies to the ball properties", ->
    ball = cricket.ball(ball_with_props_set)
    module_mock.capture_events_on(ball)
    display = new BallDisplay(ball, ui_builder)
    ball.test_update()
    expect(label.update_text).toHaveBeenCalledWith('full')
    expect(label.update_text).toHaveBeenCalledWith('play')
    expect(label.update_text).toHaveBeenCalledWith('shot')
    expect(label.update_text).toHaveBeenCalledWith('height')
    expect(label.update_text).toHaveBeenCalledWith('a million miles')
    expect(label.update_text).toHaveBeenCalledWith('yes')
    expect(label.update_text).toHaveBeenCalledWith('unknown')