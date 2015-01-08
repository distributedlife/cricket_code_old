requirejs = require('../../spec_helper').requirejs
three = require('../../stubs/three').three
asevented = require('../../stubs/asevented').asevented
io = require('../../stubs/socket.io').io
cricket_socket = require('../../stubs/socket.io').cricket_socket
zepto = require('../../stubs/zepto').zepto

module_mock = require('../../stubs/module_mock')
module_mock.reset(requirejs)
module_mock.stub(requirejs, 'ext/asevented', asevented)
module_mock.stub(requirejs, 'socket.io', io)
module_mock.stub(requirejs, 'cricket/socket', cricket_socket)
text =
  style:
    display: 'banana'
    innerHTML: 'herp'
window =
  get_element_by_id: jasmine.createSpy('window.get_element_by_id').andReturn(text)
module_mock.stub(requirejs, 'lib/window', window)
module_mock.stub(requirejs, 'ext/zepto.min', zepto)

display = null
player =
  id: 1
  on_event: jasmine.createSpy('player.on_event')
MirrorPlayer = module_mock.spy_and_mock(requirejs, 'cricket/mirror_player', player)
supply =
  on_event: jasmine.createSpy('supply.on_event')
Mirrorsupply = module_mock.spy_and_mock(requirejs, 'cricket/mirror_supply', supply)
button =
  on_click: jasmine.createSpy('button.on_click')
  hide: jasmine.createSpy('button.hide')
  show: jasmine.createSpy('button.show')
InteractiveTextView = module_mock.spy_and_mock(requirejs, 'lib/interactive_text_view', button)

SupplyOptions = requirejs('cricket/ui/supply_options')
describe "the supply options", ->
  beforeEach ->
    display = new SupplyOptions(player)

  it "should default to enabled", ->
    expect(display.enabled).toBeTruthy()

  it "should start not trashing", ->
    expect(display.trashing).toBeFalsy()

  it "should buy a full card when link is clicked", ->
    expect(display.buy_full_card_link.on_click).toHaveBeenCalledWith(display.buy_full_card)
  it "should buy a good card when link is clicked", ->
    expect(display.buy_good_card_link.on_click).toHaveBeenCalledWith(display.buy_good_card)
  it "should buy a short card when link is clicked", ->
    expect(display.buy_short_card_link.on_click).toHaveBeenCalledWith(display.buy_short_card)
  it "should buy a bouncer/yorker card when link is clicked", ->
    expect(display.buy_bouncer_yorker_card_link.on_click).toHaveBeenCalledWith(display.buy_bouncer_yorker_card)

  it "should update all decks when the player is updated", ->
    expect(display.player.on_event).toHaveBeenCalledWith('update', display.update_all_decks)
  it "should update all decks when the supply is updated", ->
    expect(display.supply.on_event).toHaveBeenCalledWith('update', display.update_all_decks)

  describe "it should be enabled when", ->
    it "the 'start of ball' event is received", ->
      expect(display.on_remote_event).toHaveBeenCalledWith('player/start_of_ball', display.enable)
    it "the 'play shot' event is received", ->
      expect(display.on_remote_event).toHaveBeenCalledWith('player/play_shot', display.enable)
    it "the 'play ball' event is received", ->
      expect(display.on_remote_event).toHaveBeenCalledWith('player/play_ball', display.enable)
    it "the 'buy cards' event is received", ->
      expect(display.on_remote_event).toHaveBeenCalledWith('player/buy_cards', display.enable)

  describe "it should be disabled when", ->
    it "the 'start setting field' event is received", ->
      expect(display.on_remote_event).toHaveBeenCalledWith('field/start_setting_field', display.disable)
    it "the 'add runs momentum' event is received", ->
      expect(display.on_remote_event).toHaveBeenCalledWith('player/add_runs_momentum', display.disable)
    it "the 'restrict runs momentum' event is received", ->
      expect(display.on_remote_event).toHaveBeenCalledWith('player/restrict_runs_momentum', display.disable)
    it "the 'move to next ball' event is received", ->
      expect(display.on_remote_event).toHaveBeenCalledWith('player/move_to_next_ball', display.disable)
    it "the 'trash cards' event is received", ->
      expect(display.on_remote_event).toHaveBeenCalledWith('player/trash_cards', display.disable)

  it "should start trashing cards when the 'trash cards' event is receieved", ->
      expect(display.on_remote_event).toHaveBeenCalledWith('player/trash_cards', display.start_trash_cards)
  it "should stop trashing cards when the 'stop trashing cards phase' event is receieved", ->
      expect(display.on_remote_event).toHaveBeenCalledWith('player/stop_trashing_card_phase', display.stop_trash_cards)

describe "start trashing cards", ->
  beforeEach ->
    display = new SupplyOptions(player)
    display.start_trash_cards()

  it "should set trashing to true", ->
    expect(display.trashing).toBeTruthy()

describe "stop trashing cards", ->
  beforeEach ->
    display = new SupplyOptions(player)
    display.trashing = true
    display.stop_trash_cards()

  it "should set trashing to false", ->
    expect(display.trashing).toBeFalsy()

describe "enable", ->
  beforeEach ->
    display = new SupplyOptions(player)
    display.enabled = false
    display.update_all_decks = jasmine.createSpy('display.update_all_decks')
    display.enable()

  it "should set enabled to true", ->
    expect(display.enabled).toBeTruthy()

  it "should update all decks", ->
    expect(display.update_all_decks).toHaveBeenCalled()

describe "disable", ->
  beforeEach ->
    display = new SupplyOptions(player)
    display.update_all_decks = jasmine.createSpy('display.update_all_decks')
    display.disable()

  it "should set enabled to false", ->
    expect(display.enabled).toBeFalsy()

  it "should update all decks", ->
    expect(display.update_all_decks).toHaveBeenCalled()

describe "updating all the decks", ->
  beforeEach ->
    display = new SupplyOptions(player)

  describe "when enabled and the player has momentum", ->
    beforeEach ->
      display.enabled = true
      display.player.has_momentum = -> true
      display.trashing = false

    describe "when the decks have cards to be bought", ->
      beforeEach ->
        display.supply.full_deck_size = 1
        display.supply.good_deck_size = 1
        display.supply.short_deck_size = 1
        display.supply.bouncer_yorker_deck_size = 1
        display.update_all_decks()

      it "should show the four buy card links", ->
        expect(display.buy_full_card_link.show).toHaveBeenCalled()
        expect(display.buy_good_card_link.show).toHaveBeenCalled()
        expect(display.buy_short_card_link.show).toHaveBeenCalled()
        expect(display.buy_bouncer_yorker_card_link.show).toHaveBeenCalled()

  describe "when trashing", ->
    beforeEach ->
      display.enabled = false
      display.player.has_momentum = -> false
      display.trashing = true

    describe "when the decks have cards to be bought", ->
      beforeEach ->
        display.supply.full_deck_size = 1
        display.supply.good_deck_size = 1
        display.supply.short_deck_size = 1
        display.supply.bouncer_yorker_deck_size = 1
        display.update_all_decks()

      it "should show the four buy card links", ->
        expect(display.buy_full_card_link.show).toHaveBeenCalled()
        expect(display.buy_good_card_link.show).toHaveBeenCalled()
        expect(display.buy_short_card_link.show).toHaveBeenCalled()
        expect(display.buy_bouncer_yorker_card_link.show).toHaveBeenCalled()

  describe "when not trashing, enabled or if the player has no momentum", ->
    beforeEach ->
      display.enabled = false
      display.player.has_momentum = -> false
      display.trashing = false
      display.update_all_decks()

    it "should not show the four buy card links", ->
      expect(display.buy_full_card_link.hide).toHaveBeenCalled()
      expect(display.buy_good_card_link.hide).toHaveBeenCalled()
      expect(display.buy_short_card_link.hide).toHaveBeenCalled()
      expect(display.buy_bouncer_yorker_card_link.hide).toHaveBeenCalled()

describe "buy full card", ->
  beforeEach ->
    display = new SupplyOptions(player)
    display.buy_full_card()

  it "should emit a buy card event for the full length", ->
    expect(display.share_remotely).toHaveBeenCalledWith('supply/buy_card', 'full')

describe "buy good card", ->
  beforeEach ->
    display = new SupplyOptions(player)
    display.buy_good_card()

  it "should emit a buy card event for the good length", ->
    expect(display.share_remotely).toHaveBeenCalledWith('supply/buy_card', 'good')

describe "buy short card", ->
  beforeEach ->
    display = new SupplyOptions(player)
    display.buy_short_card()

  it "should emit a buy card event for the short length", ->
    expect(display.share_remotely).toHaveBeenCalledWith('supply/buy_card', 'short')

describe "buy bouncer/yorker card", ->
  beforeEach ->
    display = new SupplyOptions(player)
    display.buy_bouncer_yorker_card()

  it "should emit a buy card event for the bouncer and yorker length", ->
    expect(display.share_remotely).toHaveBeenCalledWith('supply/buy_card', 'bounceryorker')
