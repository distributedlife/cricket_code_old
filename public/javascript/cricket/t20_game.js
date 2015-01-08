define(['lib/level', 'cricket/server_field', 'cricket/ai/ai', 'cricket/ui/supply_display', 'cricket/t20_match', 'cricket/ui/scoreboard_display', 'cricket/ui/ball_display', 'cricket/ai/basic_field', 'cricket/ai/random_bowler', 'cricket/ai/safe_batter_with_aggression', 'cricket/single_player_runner', 'cricket/human_player', 'cricket/ui/field_display', 'cricket/ui/momentum_display', 'cricket/ui/opponent_hand_display', 'cricket/ui/field_is_valid_display', 'lib/text_view', 'cricket/ui/field_control', 'cricket/server_scoreboard', 'cricket/buy_card_logic', 'cricket/play_card_logic', 'cricket/trash_card_logic', 'cricket/ui/match_result_display', 'cricket/ui/supply_options', 'cricket/ui/change_field_control', 'cricket/ui/next_ball_control', 'cricket/ui/role_display', 'cricket/ui/sneak_cutoff_run_controls', 'cricket/ui/chance_arm_control', 'cricket/ui/trash_cards_control', 'cricket/ui/hand_display', 'cricket/server_match', 'cricket/socket', 'cricket/events'],
       function(Level, ServerField, AI, SupplyDisplay, T20Match, ScoreboardDisplay, BallDisplay, BasicField, RandomBowler, SafeBatterWithAggression, SinglePlayerRunner, HumanPlayer, FieldDisplay, MomentumDisplay, OpponentHandDisplay, FieldIsValidDisplay, TextView, FieldControl, ServerScoreboard, BuyCardLogic, PlayCardLogic, TrashCardLogic, MatchResultDisplay, SupplyOptions, ChangeFieldControl, NextBallControl, RoleDisplay, SneakCutoffRunControls, ChanceArmControl, TrashCardsControl, HandDisplay, ServerMatch, Socket, Events) {

  "use strict";

  return function(width, height) {
    var _this = new Level(width, height);

    _this.init = function() {
      Socket.call(_this);
			_this.on_remote_event(Events.Game.setup, _this.finish_ui_setup);

      //Server Side Setup
      _this.human = new HumanPlayer();
      _this.ai = new AI(new BasicField(), new RandomBowler(), new SafeBatterWithAggression());
      _this.players = [_this.human, _this.ai];
      _this.match = new T20Match();
      _this.match.on_event('new_innings', _this.configure_buy_card_logic);
      _this.server_match = new ServerMatch(_this.match);
      _this.scoreboard = new ServerScoreboard(_this.match.player1_innings, _this.match.player2_innings);

      _this.buy_card_logic = new BuyCardLogic(_this.human);
      _this.play_card_logic = new PlayCardLogic(_this.human);
      _this.trash_card_logic = new TrashCardLogic(_this.human);

			//tell client to setup
			var data = {
				p1_id: _this.human.id,
				p2_id: _this.ai.id
			};
			_this.share_remotely(Events.Game.setup, data);

      _this.single_player_runner = new SinglePlayerRunner(_this.match, new ServerField(), _this.players);
    };

		_this.finish_ui_setup = function(data) {
			var p1_id = data.p1_id;
			var p2_id = data.p2_id;

			//Client Side Setup, relies on mirrors
			_this.field_display = new FieldDisplay();
			_this.field_is_valid_display = new FieldIsValidDisplay();
			_this.scoreboard_display = new ScoreboardDisplay();
			_this.supply_display = new SupplyDisplay();
			_this.ball_display = new BallDisplay();
			_this.field_control = new FieldControl();
			_this.next_ball_control = new NextBallControl();
			_this.trash_cards_control = new TrashCardsControl();
			_this.sneak_cutoff_run_controls = new SneakCutoffRunControls();
			_this.match_result = new MatchResultDisplay();

			//needs info from the server to setup; some decoupling to go
			_this.hand_display = new HandDisplay(p1_id);
			_this.my_momentum_display = new MomentumDisplay("player_momentum", p1_id);
			_this.role_display = new RoleDisplay(p1_id);
			_this.supply_options = new SupplyOptions(p1_id);
			_this.change_field_control = new ChangeFieldControl(p1_id);
			_this.chance_arm_control = new ChanceArmControl(p1_id);

			_this.opponent_hand_display = new OpponentHandDisplay(p2_id);
			_this.opponent_momentum_display = new MomentumDisplay("opponent_momentum", p2_id);
		};

    _this.configure_buy_card_logic = function(innings) {
      _this.buy_card_logic.configure(_this.human.hand, innings.supply);
    };

    _this.init();
    return _this;
  };
});
