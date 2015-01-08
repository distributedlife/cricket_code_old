requirejs = require('../../spec_helper').requirejs
three = require('../../stubs/three').three
asevented = require('../../stubs/asevented').asevented
io = require('../../stubs/socket.io').io
zepto = require('../../stubs/zepto').zepto

module_mock = require('../../stubs/module_mock')
module_mock.reset(requirejs)
module_mock.stub(requirejs, 'ext/asevented', asevented)
module_mock.stub(requirejs, 'socket.io', io)
text =
  style:
    display: 'banana'
    innerHTML: 'herp'
window =
  get_element_by_id: jasmine.createSpy('window.get_element_by_id').andReturn(text)
module_mock.stub(requirejs, 'lib/window', window)
module_mock.stub(requirejs, 'ext/zepto.min', zepto)

display = null
supply =
  on_event: jasmine.createSpy('supply.on_event')
  full_deck_size: 1
  good_deck_size: 2
  short_deck_size: 3
  bouncer_yorker_size: 4
  chance_your_arm_deck_size: 5
Mirrorsupply = module_mock.spy_and_mock(requirejs, 'cricket/mirror_supply', supply)

label =
  update_text: jasmine.createSpy('label.update_text')
TextView = module_mock.spy_and_mock(requirejs, 'lib/text_view', label)

SupplyDisplay = requirejs('cricket/ui/supply_display')
describe "the supply display", ->
  beforeEach ->
    display = new SupplyDisplay()

  it "should refresh the display when the supply is updated", ->
    expect(supply.on_event).toHaveBeenCalledWith('update', display.refresh)

describe "refreshing", ->
  beforeEach ->
    display = new SupplyDisplay()
    display.refresh(supply)

  it "should update each label with the supply deck size", ->
    expect(display.full_deck.update_text).toHaveBeenCalledWith(supply.full_deck_size)
    expect(display.good_deck.update_text).toHaveBeenCalledWith(supply.good_deck_size)
    expect(display.short_deck.update_text).toHaveBeenCalledWith(supply.short_deck_size)
    expect(display.bouncer_yorker_deck.update_text).toHaveBeenCalledWith(supply.bouncer_yorker_deck_size)
    expect(display.chance_your_arm_deck.update_text).toHaveBeenCalledWith(supply.chance_your_arm_deck_size)
