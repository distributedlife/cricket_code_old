define(['cricket/terms', 'cricket/scorer'], function(Terms, Scorer) {
  "use strict";

  return function(ai) {
    var _this = this;

    _this.init = function() {
      _this.batting_ai = 'safe batter with aggression';
    };

    _this.need_outweighs_risk = function(risk) {
      var need = 0;

      if (ai.innings.target) {
        need = ai.innings.required_run_rate() - ai.innings.run_rate();
      } else {
        need = ai.desired_run_rate - ai.innings.run_rate();
      }

      need += ai.risk_appetite;

      return need >= risk;
    };

    _this.chance_your_arm_likelihood = function(field, shot) {
      if (shot === Terms.Shots.block) {
        return 0;
      }

      var infield = field.has_fielder_in_spot(Terms.Distance.infield, shot);
      var outfield = field.has_fielder_in_spot(Terms.Distance.outfield, shot);

      return (infield * 16) + (outfield * 33) / 10.0;
    };

    _this.calculate_value_of_hand = function(ball, field) {
      var value = [];
      var scorer = new Scorer();

      ai.hand.cards.forEach(function(card) {
        ball._batter_card = card;
        ball._height = card.catchable;

        var runs = scorer.score(ball, field);
        var chance = _this.chance_your_arm_likelihood(field, card.shot);
        value.push({card: card, runs: runs, chance: chance});

        ball._batter_card = null;
        ball._height = null;
      });

      return value;
    };

    _this.get_valid_options = function(ball, field) {
      var value = _this.calculate_value_of_hand(ball, field);

      var options = value.filter(function(option) {
        return (option.runs !== Terms.Balls.wicket) || _this.need_outweighs_risk(option.chance);
      });

      return _this.sort_by_value(options);
    };

    _this.sort_by_value = function(set) {
      set.sort(function(a, b) {
        return (Terms.Score[a.runs] >= Terms.Score[b.runs]) ? -1 : 1;
      });

      return set;
    };

    _this.sort_by_risk = function(set) {
      set.sort(function(a, b) {
        return a.chance < b.chance ? -1 : 1;
      });

      return set;
    };

    _this.should_use_momentum = function() {
      return (ai.innings.current_over.balls_remaining() - ai.momentum() <= 0);
    };

    _this.buy_shot_card = function(ball) {
      var card = null;
      if (ball._bowler_card.length === Terms.Length.full) {
        card = ai.supply.full_deck.draw();
      } else if (ball._bowler_card.length === Terms.Length.short) {
        card = ai.supply.short_deck.draw();
      } else if (ball._bowler_card.length === Terms.Length.bouncer) {
        card = ai.supply.bouncer_yorker_deck.draw();
      } else if (ball._bowler_card.length === Terms.Length.yorker) {
        card = ai.supply.bouncer_yorker_deck.draw();
      }
      _this.pay_for_card(card);
      return card;
    };

    _this.pay_for_card = function(card) {
      if (card) {
        ai.use_momentum();
        ai.hand.add(card);
      }
    };

    _this.try_and_buy_yorker = function(ball) {
      var card = ai.supply.bouncer_yorker_deck.draw();
      _this.pay_for_card(card);
      return card;
    };

    _this.buy_defensive_card = function(ball) {
      var card = ai.supply.good_deck.draw();
      _this.pay_for_card(card);

      if (!card) {
        card = _this.buy_shot_card(ball);
        if (!card) {
          card = _this.try_and_buy_yorker(ball);
        }
      }

      return card;
    };

    _this.buy_card = function(ball, field) {
      if (ai.momentum() === 0) {
        return ;
      }

      if (ball.is_must_play()) {
        if (ai.should_use_momentum() && ai.momentum() > 2) {
          _this.buy_shot_card(ball);
        } else {
          _this.buy_defensive_card(ball);
        }
      } else {
        if (ai.should_use_momentum()) {
          _this.buy_shot_card(ball);
        }
      }
    };

    _this.play_shot = function(ball, field) {
      var valid_options = _this.get_valid_options(ball, field);
      if (valid_options.length === 0) {
        _this.buy_card(ball, field);

        valid_options = _this.get_valid_options(ball, field);
        if (valid_options.length === 0) {
          return true;
        }
      }
      if (ai.momentum() === 0) {
        _this.play_card(valid_options[0].card, ball);
        return true;
      }

      var chance = valid_options.filter(function(option) {
        return option.card.length === ball._bowler_card.length && option.card.shot !== Terms.Shots.block;
      });
      if (chance.length === 0) {
        _this.play_card(valid_options[0].card, ball);
        return true;
      }

      _this.chance_arm(ball);
      valid_options = _this.sort_by_risk(valid_options);
      _this.play_card(chance[0].card, ball);

      return true;
    };

    _this.chance_arm = function(ball) {
      if (ai.momentum() > 0) {
        ai.use_momentum();
        ball.chance_arm();
      }
    };

    _this.add_runs_momentum = function(ball) {
      if (_this.should_use_momentum() && ai.momentum() > 0) {
        _this.use_momentum();
        ball.sneak_run();
      }

      return true;
    };

    _this.play_card = function(card, ball) {
      ball.play_batting_card(card);

      ai.hand.remove(card);
      ai.deck.discard(ball._batter_card);
    };

    _this.init();
    return _this;
  };
});
