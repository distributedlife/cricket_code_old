requirejs = require('../../spec_helper').requirejs
cricket = require('../../stubs/cricket')
link_label = require('../../stubs/lib').link_label
ui_builder = require('../../stubs/lib').ui_builder

module_mock = require('../../stubs/module_mock')
module_mock.reset(requirejs)

module_mock.stub(requirejs, 'ext/asevented', require('../../stubs/asevented').asevented)
module_mock.stub(requirejs, 'socket.io', require('../../stubs/socket.io').io)
module_mock.stub(requirejs, 'cricket/socket', require('../../stubs/socket.io').cricket_socket)

display = null
player = cricket.player()
index = 0
new_card = null

CardControl = requirejs('cricket/ui/card_control')

describe "the card control", ->
  beforeEach ->
    module_mock.capture_events_on(player)
    module_mock.capture_click_events_on(link_label.link)

    display = new CardControl(player, index, ui_builder)

  describe "when the link label is updated", ->
    beforeEach ->
      display.update_link_label("derp")

    it "should wrap the new label in brackets", ->
      expect(link_label.link.update_text).toHaveBeenCalledWith("[derp]")

  describe "when the card is deselected", ->
    beforeEach ->
      display.update_link_label("derp")
      display.deselect()

    it "should set the label to the previous label", ->
      expect(link_label.link.update_text).toHaveBeenCalledWith("[derp]")

  describe "when the link is shown", ->
    beforeEach ->
      display.show_link()

    it "should show the link", ->
      expect(link_label.show).toHaveBeenCalledWith(true)

  describe "when the link is hidden", ->
    beforeEach ->
      display.hide_link()

    it "should show the link", ->
      expect(link_label.show).toHaveBeenCalledWith(false)

  describe "when the card is updated", ->
    beforeEach ->
      new_card =
        length: "full"
        play: "must play"
        distance: "outfield"
        catchable: "catchable"
        shot: "leg_glance"

    describe "when the player is batting", ->
      beforeEach ->
        player.is_batting = -> true
        display.update(new_card)

      it "should set the label to length, shot, distance, catchable", ->
        expect(link_label.label.update_text).toHaveBeenCalledWith("full leg glance outfield in the air ")

    describe "when the player is bowling", ->
      beforeEach ->
        player.is_batting = -> false
        display.update(new_card)

      it "should set the label to length, play", ->
        expect(link_label.label.update_text).toHaveBeenCalledWith("full must play ")

    it "should remove the class styles", ->
      expect(link_label.label.remove_class).toHaveBeenCalledWith('full')
      expect(link_label.label.remove_class).toHaveBeenCalledWith('good')
      expect(link_label.label.remove_class).toHaveBeenCalledWith('short')
      expect(link_label.label.remove_class).toHaveBeenCalledWith('bouncer')

    it "should add the class based on the length", ->
      expect(link_label.label.add_class).toHaveBeenCalledWith('full')

  describe "when the player updates", ->    
    beforeEach ->
      new_card =
        length: "full"
        play: "must play"
        distance: "outfield"
        catchable: "catchable"
        shot: "leg_glance"
      display.update(new_card)

    describe "when the player is batting", ->
      beforeEach ->
        player.is_batting = -> true
        player.test_update()

      it "should set the label to length, shot, distance, catchable", ->
        expect(link_label.label.update_text).toHaveBeenCalledWith("full leg glance outfield in the air ")

    describe "when the player is bowling", ->
      beforeEach ->
        player.is_batting = -> false
        player.test_update()

      it "should set the label to length, play", ->
        expect(link_label.label.update_text).toHaveBeenCalledWith("full must play ")

  describe "when the card is selected", ->
    beforeEach ->
      module_mock.capture_click_events_on(link_label.link)
      display = new CardControl(player, index, ui_builder)
      display.update({a: 'b'})
      link_label.link.test_click()

    it "send an user has selected card event with the card and index", ->
      expect(display.share_remotely).toHaveBeenCalledWith('player/user_selected_card', {card: {a: 'b'}, index: 0})
