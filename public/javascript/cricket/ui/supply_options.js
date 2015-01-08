define(['lib/interactive_text_view', 'lib/event_emitter', 'cricket/mirror_supply', 'cricket/socket', 'cricket/mirror_player', "cricket/terms", "cricket/events"], function(InteractiveTextView, EventEmitter, MirrorSupply, Socket, MirrorPlayer, Terms, Events) {
  "use strict";

  /*
   * allows a human player to buy things from the supply via the UI
   */
  return function(player_id) {
    var _this = this;

    _this.init = function() {
      _this.typename = 'supply_options';
      EventEmitter.call(_this);
      Socket.call(_this);

      _this.enabled = true;
      _this.trashing = false;

      _this.buy_full_card_link = new InteractiveTextView("full_deck_card_buy");
      _this.buy_good_card_link = new InteractiveTextView("good_deck_card_buy");
      _this.buy_short_card_link = new InteractiveTextView("short_deck_card_buy");
      _this.buy_bouncer_yorker_card_link = new InteractiveTextView("bouncer_yorker_deck_card_buy");

      _this.buy_full_card_link.on_click(_this.buy_full_card);
      _this.buy_good_card_link.on_click(_this.buy_good_card);
      _this.buy_short_card_link.on_click(_this.buy_short_card);
      _this.buy_bouncer_yorker_card_link.on_click(_this.buy_bouncer_yorker_card);

      _this.player = new MirrorPlayer(player_id);
      _this.player.on_event('update', _this.update_all_decks);

      _this.supply = new MirrorSupply();
      _this.supply.on_event('update', _this.update_all_decks);

      _this.on_remote_event(Events.Field.start_setting_field, _this.disable);
      _this.on_remote_event(Events.Player.start_of_ball, _this.enable);
      _this.on_remote_event(Events.Player.play_shot, _this.enable);
      _this.on_remote_event(Events.Player.play_ball, _this.enable);
      _this.on_remote_event(Events.Player.add_runs_momentum, _this.disable);
      _this.on_remote_event(Events.Player.restrict_runs_momentum, _this.disable);
      _this.on_remote_event(Events.Player.move_to_next_ball, _this.disable);
      _this.on_remote_event(Events.Player.trash_cards, _this.disable);
      _this.on_remote_event(Events.Player.buy_cards, _this.enable);
      _this.on_remote_event(Events.Player.trash_cards, _this.start_trash_cards);
      _this.on_remote_event(Events.Player.stop_trashing_card_phase, _this.stop_trash_cards);
    };

    _this.start_trash_cards = function() {
      _this.trashing = true;
    };

    _this.stop_trash_cards = function() {
      _this.trashing = false;
    };

    _this.enable = function() {
      _this.enabled = true;
      _this.update_all_decks();
    };

    _this.disable = function() {
      _this.enabled = false;
      _this.update_all_decks();
    };

    _this.update_all_decks = function() {
      if (_this.enabled && _this.player.has_momentum() || _this.trashing) {
        if (_this.supply.full_deck_size > 0) {
          _this.buy_full_card_link.show();
        }
        if (_this.supply.good_deck_size > 0) {
          _this.buy_good_card_link.show();
        }
        if (_this.supply.short_deck_size > 0) {
          _this.buy_short_card_link.show();
        }
        if (_this.supply.bouncer_yorker_deck_size > 0) {
          _this.buy_bouncer_yorker_card_link.show();
        }
      } else {
        _this.buy_full_card_link.hide();
        _this.buy_good_card_link.hide();
        _this.buy_short_card_link.hide();
        _this.buy_bouncer_yorker_card_link.hide();
      }
    };

    _this.buy_full_card = function() {
      _this.share_remotely(Events.Supply.buy_card, Terms.Length.full);
    };

    _this.buy_good_card = function() {
      _this.share_remotely(Events.Supply.buy_card, Terms.Length.good);
    };

    _this.buy_short_card = function() {
      _this.share_remotely(Events.Supply.buy_card, Terms.Length.short);
    };

    _this.buy_bouncer_yorker_card = function() {
      _this.share_remotely(Events.Supply.buy_card, Terms.Length.bouncer + Terms.Length.yorker);
    };

    _this.init();
    return _this;
  };
});
