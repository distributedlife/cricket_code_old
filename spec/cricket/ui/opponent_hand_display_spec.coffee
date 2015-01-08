requirejs = require('../../spec_helper').requirejs
cricket = require('../../stubs/cricket')
label = require('../../stubs/lib').label
ui_builder = require('../../stubs/lib').ui_builder

module_mock = require('../../stubs/module_mock')
module_mock.reset(requirejs)

module_mock.stub(requirejs, 'ext/asevented', require('../../stubs/asevented').asevented)
module_mock.stub(requirejs, 'socket.io', require('../../stubs/socket.io').io)
module_mock.stub(requirejs, 'cricket/socket', require('../../stubs/socket.io').cricket_socket)

display = null
hand = cricket.deck()

OpponentHandDisplay = requirejs('cricket/ui/opponent_hand_display')

describe "the opponent hand display", ->
  beforeEach ->
    module_mock.capture_events_on(hand)
    display = new OpponentHandDisplay(hand, ui_builder)

  describe "when the hand updates", ->
    beforeEach ->
      hand.size = -> 2
      hand.test_update()

    it "should update the label text to the hand size", ->
      expect(label.update_text).toHaveBeenCalledWith(2)
