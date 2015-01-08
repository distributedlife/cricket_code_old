requirejs = require('../../spec_helper').requirejs
cricket = require('../../stubs/cricket')
control = require('../../stubs/lib').control
ui_builder = require('../../stubs/lib').ui_builder

module_mock = require('../../stubs/module_mock')
module_mock.reset(requirejs)

module_mock.stub(requirejs, 'socket.io', require('../../stubs/socket.io').io)
module_mock.stub(requirejs, 'cricket/socket', require('../../stubs/socket.io').cricket_socket)

display = null
ball = cricket.ball()
selected_card = cricket.selected_card()

PlaySelectedCardControl = requirejs('cricket/ui/play_selected_card_control')

describe "the leave ball control", ->
  beforeEach ->
    module_mock.capture_events_on(ball)
    module_mock.capture_events_on(selected_card)
    module_mock.capture_click_events_on(control)
    control.hide.reset()
    control.show.reset()
    display = new PlaySelectedCardControl(ball, selected_card, ui_builder)

  describe "when no card is selected", ->
    beforeEach ->
      selected_card.index = null

    describe "and the selected card is updated", ->
      beforeEach ->
        selected_card.test_update()

      it "should hide the button", ->
        expect(control.hide).toHaveBeenCalled()

    describe "and the current ball is updated", ->
      beforeEach ->
        ball.test_update()

      it "should hide the button", ->
        expect(control.hide).toHaveBeenCalled()

  describe "when a card is selected", ->
    beforeEach ->
      selected_card.index = 0

    describe "and the current ball stage is not 'play_shot' and not 'play_ball'", ->
      beforeEach ->
        ball.stage = 'anything_but'

      describe "and the ball is updated", ->
        beforeEach ->
          ball.test_update()

        it "should hide the button", ->
          expect(control.hide).toHaveBeenCalled()

      describe "and the selected card is updated", ->
        beforeEach ->
          selected_card.test_update()

        it "should hide the button", ->
          expect(control.hide).toHaveBeenCalled()

    describe "when the current ball stage is 'play_shot'", ->
      beforeEach ->
        ball.stage = 'play_shot'

      describe "and the ball is updated", ->
        beforeEach ->
          ball.test_update()

        it "should show the button", ->
          expect(control.show).toHaveBeenCalled()

      describe "and the selected card is updated", ->
        beforeEach ->
          selected_card.test_update()

        it "should show the button", ->
          expect(control.show).toHaveBeenCalled()

    describe "when the current ball stage is 'play_ball'", ->
      beforeEach ->
        ball.stage = 'play_ball'

      describe "and the ball is updated", ->
        beforeEach ->
          ball.test_update()

        it "should show the button", ->
          expect(control.show).toHaveBeenCalled()

      describe "and the selected card is updated", ->
        beforeEach ->
          selected_card.test_update()

        it "should show the button", ->
          expect(control.show).toHaveBeenCalled()

  describe "clicking the button", ->
    beforeEach ->
      display = new PlaySelectedCardControl(ball, selected_card, ui_builder)

    it "should send a user sneak run event", ->
      control.test_click()
      expect(display.share_remotely).toHaveBeenCalledWith('player/user_play_selected_card')

