requirejs = require('../spec_helper').requirejs
three = require('../stubs/three').three
asevented = require('../stubs/asevented').asevented
io = require('../stubs/socket.io').io
zepto = require('../stubs/zepto').zepto

module_mock = require('../stubs/module_mock')
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
Three = module_mock.stub(requirejs, 'ext/three', three)
ServerField = module_mock.spy_on(requirejs, 'cricket/server_field')
HumanPlayer = module_mock.spy_on(requirejs, 'cricket/human_player')
AI = module_mock.spy_on(requirejs, 'cricket/ai/ai')
t20_match =
  on_event: jasmine.createSpy('t20_match.on_event')
  player1_innings:
    on_event: jasmine.createSpy('player1_innings.on_event')
  player2_innings:
    on_event: jasmine.createSpy('player1_innings.on_event')
  toss_coin: -> true
  play: ->
T20Match = module_mock.spy_and_mock(requirejs, 'cricket/t20_match').andReturn(t20_match)

FieldDisplay = module_mock.spy_on(requirejs, 'cricket/ui/field_display')
FieldIsValidDisplay = module_mock.spy_on(requirejs, 'cricket/ui/field_is_valid_display')
FieldControl = module_mock.spy_on(requirejs, 'cricket/ui/field_control')
ScoreboardDisplay = module_mock.spy_on(requirejs, 'cricket/ui/scoreboard_display')
SupplyDisplay = module_mock.spy_on(requirejs, 'cricket/ui/supply_display')
BallDisplay = module_mock.spy_on(requirejs, 'cricket/ui/ball_display')
MatchResultDisplay = module_mock.spy_on(requirejs, 'cricket/ui/match_result_display')
OpponentHandDisplay = module_mock.spy_on(requirejs, 'cricket/ui/opponent_hand_display')
HandDisplay = module_mock.spy_on(requirejs, 'cricket/ui/hand_display')
MomentumDisplay = module_mock.spy_on(requirejs, 'cricket/ui/momentum_display')
RoleDisplay = module_mock.spy_on(requirejs, 'cricket/ui/role_display')

SupplyOptions = module_mock.spy_on(requirejs, 'cricket/ui/supply_options')
ChangeFieldControl = module_mock.spy_on(requirejs, 'cricket/ui/change_field_control')
NextBallControl = module_mock.spy_on(requirejs, 'cricket/ui/next_ball_control')
SneakCutoffRunControls = module_mock.spy_on(requirejs, 'cricket/ui/sneak_cutoff_run_controls')
ChanceArmControl = module_mock.spy_on(requirejs, 'cricket/ui/chance_arm_control')
TrashCardsControl = module_mock.spy_on(requirejs, 'cricket/ui/trash_cards_control')

buy_card_logic =
BuyCardLogic = module_mock.spy_and_mock(requirejs, 'cricket/buy_card_logic', buy_card_logic)
PlayCardLogic = module_mock.spy_on(requirejs, 'cricket/play_card_logic')
TrashCardLogic = module_mock.spy_on(requirejs, 'cricket/trash_card_logic')

ServerScoreboard = module_mock.spy_on(requirejs, 'cricket/server_scoreboard')
single_player_runner = {}
SinglePlayerRunner = module_mock.spy_and_mock(requirejs, 'cricket/single_player_runner', single_player_runner)

module_mock.stub(requirejs, 'ext/zepto.min', zepto)

t20_game = null
innings =
  supply: "supply"

T20Game = requirejs('cricket/t20_game')
describe 'setting up a game', ->
  beforeEach ->
    t20_game = new T20Game()

  it 'should setup the field', ->
    expect(ServerField).toHaveBeenCalled()

  it "Should create a human and ai player", ->
    expect(HumanPlayer).toHaveBeenCalled()
    expect(AI).toHaveBeenCalled()

  it "should create a match", ->
    expect(T20Match).toHaveBeenCalled()

  it "should create the buy card logic", ->
    expect(BuyCardLogic).toHaveBeenCalled()

  it "should create the play card logic", ->
    expect(PlayCardLogic).toHaveBeenCalled()

  it "should create the trash card logic", ->
    expect(TrashCardLogic).toHaveBeenCalled()

  it "should create a scoreboard", ->
    expect(ServerScoreboard).toHaveBeenCalled()

  it "should create a single player runner", ->
    expect(SinglePlayerRunner).toHaveBeenCalled()

  it "should update the buy card logic at the start of each innings", ->
    expect(t20_game.match.on_event).toHaveBeenCalledWith('new_innings', t20_game.configure_buy_card_logic)

describe "finish ui setup", ->
  beforeEach ->
    t20_game.finish_ui_setup({p1_id: t20_game.human.id, p2_id: t20_game.ai.id})

  it "should create a field control", ->
    expect(FieldControl).toHaveBeenCalled()
  it "should create a field is valid display", ->
    expect(FieldIsValidDisplay).toHaveBeenCalled()
  it "should create a field control", ->
    expect(FieldControl).toHaveBeenCalled()
  it "should create a scoreboard display", ->
    expect(ScoreboardDisplay).toHaveBeenCalled()
  it "should create a supply display", ->
    expect(SupplyDisplay).toHaveBeenCalled()
  it "should create a ball display", ->
    expect(BallDisplay).toHaveBeenCalled()
  it "should create a match result display", ->
    expect(MatchResultDisplay).toHaveBeenCalled()
  it "should create a opponent hand display", ->
    expect(OpponentHandDisplay).toHaveBeenCalled()
  it "should create a supply options control", ->
    expect(SupplyOptions).toHaveBeenCalled()
  it "should create a change field control", ->
    expect(ChangeFieldControl).toHaveBeenCalled()
  it "should create a next ball control", ->
    expect(NextBallControl).toHaveBeenCalled()
  it "should create a chance arm control", ->
    expect(ChanceArmControl).toHaveBeenCalled()
  it "should create a role display contorl", ->
    expect(RoleDisplay).toHaveBeenCalled()
  it "should create a sneak and cut off run control", ->
    expect(SneakCutoffRunControls).toHaveBeenCalled()
  it "should create a trash cards control", ->
    expect(TrashCardsControl).toHaveBeenCalled()
  it "should create a hand display", ->
    expect(HandDisplay).toHaveBeenCalled()

  it "should create a my momentum display", ->
    expect(MomentumDisplay).toHaveBeenCalledWith("player_momentum", t20_game.human.id)

  it "should create an opponent momentum display", ->
    expect(MomentumDisplay).toHaveBeenCalledWith("opponent_momentum", t20_game.ai.id)

describe "at the start of a new innings", ->
  beforeEach ->
    t20_game = new T20Game()
    t20_game.buy_card_logic.configure = jasmine.createSpy('buy_card_logic.setup')
    t20_game.human.hand = "human hand!"
    t20_game.configure_buy_card_logic(innings)

  it "should configure the buy card logic to use the new innings supply", ->
    expect(t20_game.buy_card_logic.configure).toHaveBeenCalledWith(t20_game.human.hand, innings.supply)
