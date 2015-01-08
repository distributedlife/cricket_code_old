requirejs = require('../../spec_helper').requirejs
player = require('../../stubs/cricket').player
label = require('../../stubs/lib').label
ui_builder = require('../../stubs/lib').ui_builder

module_mock = require('../../stubs/module_mock')
module_mock.reset(requirejs)

RoleDisplay = requirejs('cricket/ui/role_display')

describe "role display", ->
  describe "init", ->
    beforeEach ->
      module_mock.listen_for_events_on(player)
      display = new RoleDisplay(player, ui_builder)

    it "should refresh when the player is updates", ->
      expect(player.on_event).toHaveBeenCalledWith('update', jasmine.any(Function))

  describe "refreshing", ->
    beforeEach ->
      module_mock.capture_events_on(player)
      label.update_text.reset()
      display = new RoleDisplay(player, ui_builder)

    it "should update the label if the player is batting", ->
      player.is_batting = -> true
      player.test_update()
      expect(label.update_text).toHaveBeenCalled()

    it "should update the label if the player is bowling", ->
      player.is_batting = -> false
      player.test_update()
      expect(label.update_text).toHaveBeenCalled()
