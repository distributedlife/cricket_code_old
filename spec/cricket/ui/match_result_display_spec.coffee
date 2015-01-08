requirejs = require('../../spec_helper').requirejs
cricket = require('../../stubs/cricket')
label = require('../../stubs/lib').label
ui_builder = require('../../stubs/lib').ui_builder

module_mock = require('../../stubs/module_mock')
module_mock.reset(requirejs)

display = null
match = cricket.match()

MatchResultDisplay = requirejs('cricket/ui/match_result_display')

describe "refreshing the label", ->
  beforeEach ->
    module_mock.capture_events_on(match)
    display = new MatchResultDisplay(match, ui_builder)

  describe "when the match completes", ->
    beforeEach ->
      match.test_complete()

    it "should refresh the text using the match winner", ->
      expect(label.update_text).toHaveBeenCalledWith("player a won by 1 wicket")
