requirejs = require('../../spec_helper').requirejs
cricket = require('../../stubs/cricket')
button = require('../../stubs/lib').control
ui_builder = require('../../stubs/lib').ui_builder

module_mock = require('../../stubs/module_mock')
module_mock.reset(requirejs)

display = null
player = cricket.player()
over = cricket.over()
ball = cricket.ball()
player_hand = cricket.deck()
card_display_builder = cricket.card_display_builder()
card_display = card_display_builder.build_card_display()

HandControl = requirejs('cricket/ui/hand_control')

describe "the hand display", ->
  beforeEach ->
    module_mock.capture_events_on(player_hand)
    module_mock.capture_events_on(over)
    module_mock.capture_events_on(ball)

    display = new HandControl(player, player_hand, over, ball, card_display_builder)

    player_hand.cards.push({a:'a'})
    player_hand.size = () -> 1
    player_hand.test_update()

    over.stage = "something"

    card_display.update_link_label.reset()
    card_display.show_link.reset()
    card_display.hide_link.reset()
    card_display.hide.reset()

  describe "when the over stage is trash_cards'", ->
    beforeEach ->
      over.stage = "trash_cards"

    describe "when the over updates", ->
      beforeEach ->
        over.test_update()

      it "should set the links to 'trash'", ->
        expect(card_display.update_link_label).toHaveBeenCalledWith("trash")

      it "should show the links", ->
        expect(card_display.show_link).toHaveBeenCalled()

  describe "when the ball stage is play_ball", ->
    beforeEach ->
      ball.stage = "play_ball"

    describe "and the player is bowling", ->
      beforeEach ->
        player.is_bowling = () -> true

      describe "when the ball updates", ->
        beforeEach ->
          ball.test_update()

        it "should set the links to 'use'", ->
          expect(card_display.update_link_label).toHaveBeenCalledWith("use")

        it "should show the links", ->
          expect(card_display.show_link).toHaveBeenCalled()

    describe "and the player is not bowling", ->
      beforeEach ->
        player.is_bowling = () -> false

      describe "when the ball updates", ->
        beforeEach ->
          ball.test_update()

        it "should hide the link", ->
          expect(card_display.hide_link).toHaveBeenCalled()

  describe "when the ball stage is play_shot", ->
    beforeEach ->
      ball.stage = "play_shot"

    describe "and the player is batting", ->
      beforeEach ->
        player.is_batting = () -> true

      describe "when the ball updates", ->
        beforeEach ->
          ball.test_update()

        it "should set the links to 'use'", ->
          expect(card_display.update_link_label).toHaveBeenCalledWith("use")

        it "should show the links", ->
          expect(card_display.show_link).toHaveBeenCalled()

    describe "and the player is not batting", ->
      beforeEach ->
        player.is_batting = () -> false

      describe "when the ball updates", ->
        beforeEach ->
          ball.test_update()

        it "should hide the links", ->
          expect(card_display.hide_link).toHaveBeenCalled()

   describe "when the over stage is not trash_cards and the ball state is not play_ball or play_shot", ->
    beforeEach ->
      over.stage = "something"
      ball.stage = "something"

    describe "when the over updates", ->
      beforeEach ->
        over.test_update()

      it "should hide the link", ->
        expect(card_display.hide_link).toHaveBeenCalled()

    describe "when the ball updates", ->
      beforeEach ->
        ball.test_update()

      it "should hide the link", ->
        expect(card_display.hide_link).toHaveBeenCalled()

  describe "and the hand size is smaller than previous", ->
    beforeEach ->
      player_hand.size = () -> 0

    describe "when the player hand refreshes", ->
      beforeEach ->
        player_hand.test_update()

      it "should hide the extra card displays", ->
        expect(card_display.hide).toHaveBeenCalled()

  describe "and the hand size is larger than previous", ->
    beforeEach ->
      player_hand.size = () -> 2

    describe "when the player hand refreshes", ->
      beforeEach ->
        card_display_builder.build_card_display.reset()
        player_hand.test_update()

      it "should create extra card displays", ->
        expect(card_display_builder.build_card_display).toHaveBeenCalled()

      it "should not hide any card displays", ->
        expect(card_display.hide).not.toHaveBeenCalled()

  describe "when the player hand updates", ->
    beforeEach ->
      player_hand.size = -> 1
      player_hand.selected_card = null
      card_display.update.reset()
      player_hand.test_update()

    it "should update each card", ->
      expect(card_display.update.callCount).toBe(1)

    it "should deselect all cards that are not selected", ->
      expect(card_display.deselect).toHaveBeenCalled()

    it "should not deselect the selected card", ->
      player_hand.selected_card = 0
      card_display.deselect.reset()
      player_hand.test_update()

      expect(card_display.deselect).not.toHaveBeenCalled()
