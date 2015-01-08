requirejs = require('../../spec_helper').requirejs
cricket = require('../../stubs/cricket')
label = require('../../stubs/lib').label
ui_builder = require('../../stubs/lib').ui_builder

module_mock = require('../../stubs/module_mock')
module_mock.reset(requirejs)

display = null
player = null

MomentumDisplay = requirejs('cricket/ui/momentum_display')

describe "the momentum display", ->
  beforeEach ->
    player = cricket.player()
    module_mock.listen_for_events_on(player)
    display = new MomentumDisplay("div", player, ui_builder)

  it "should refresh when the player changes", ->
    expect(player.on_event).toHaveBeenCalledWith('update', jasmine.any(Function))

describe "when refreshing", ->
  beforeEach ->
    player = cricket.player()
    player.momentum = -> 2
    module_mock.capture_events_on(player)
    display = new MomentumDisplay("div", player, ui_builder)
    player.test_update()

  it "should set the text to the momentum", ->
    expect(label.update_text).toHaveBeenCalledWith(2)
