define([], function() {
  return function() {
    var events = this;

    var add_events_to_enum = function(category, prefix, events) {
      events.forEach(function(event) {
        category[event] = prefix + event;
      })
    }

    events.Player = {};
    add_events_to_enum(events.Player, "player/", 
      [
        'start_of_ball', 'play_shot', 'play_ball', 'update', 'user_buy_cards',
        'buy_cards', 'user_sneak_run', 'user_cutoff_run', 'user_chance_arm',
        'can_chance_arm', 'can_not_chance_arm', 'stop_trashing_card_phase',
        'user_finish_buying_cards', 'user_finish_trashing_cards', 'finish_trashing_cards',
        'buy_card_update', 'trashed_card_replaced', 'card_trashed', 'add_runs_momentum',
        'restrict_runs_momentum', 'move_to_next_ball', 'trash_cards',
        'user_wants_to_end_delivery', 'reset_selected_card', 'user_selected_card',
        'user_leave_ball', 'user_play_selected_card'
      ]
    );

    events.Field = {};
    add_events_to_enum(events.Field, "field/", 
      [
        'update', 'toggle_fielder', 'start_setting_field',
        'user_has_finished_setting_field', 'finish_setting_field'
      ]
    );

    events.Scoreboard = {};
    add_events_to_enum(events.Scoreboard, "scoreboard/",
      [
        'update'
      ]
    );

    events.Supply = {};
    add_events_to_enum(events.Supply, "supply/",
      [
        'update', 'card_bought_by_player', 'buy_card'
      ]
    );

    events.Deck = {};
    add_events_to_enum(events.Deck, "deck/",
      [
        'update'
      ]
    );

    events.Hand = {};
    add_events_to_enum(events.Hand, "hand/",
      [
        'play_card', 'trash_card'
      ]
    );

    events.Ball = {};
    add_events_to_enum(events.Ball, "ball/",
      [
        'update', 'complete', 'create'
      ]
    );

    events.Over = {};
    add_events_to_enum(events.Over, "over/",
      [
        'update', 'create'
      ]
    );

    events.Game = {};
    add_events_to_enum(events.Game, "game/",
      [
        'setup'
      ]
    );

    events.Match = {};
    add_events_to_enum(events.Match, "match/",
      [
        'complete'
      ]
    );

    events.Client = {};
    add_events_to_enum(events.Client, "client/",
      [
        'ready'
      ]
    );

    events.SelectedCard = {};
    add_events_to_enum(events.SelectedCard, "selected_card/",
      [
        'update'
      ]
    );

    return events;
  }();
});
