exports.player = (player) ->
  player = {} unless player?
  player

exports.ball = (ball) ->
  if not ball?
    ball =
      is_legal: jasmine.createSpy('is_legal')
  ball

exports.over = (over) ->
  over = {} unless over?
  over

exports.field = (field) ->
  if not field?
    field =
      on_event: jasmine.createSpy('on_event')
      infield: []
      outfield: []
  field

exports.validator = (validator) ->
  if not validator?
    validator =
      validate_field: (field) -> true
  validator

exports.match = (match) ->
  if not match?
    match =
      result:
        winner: "a"
        margin: "1"
        factor: "wicket"
  match

exports.scoreboard = (scoreboard) ->
  scoreboard = {} unless scoreboard?
  scoreboard

exports.selected_card = (selected_card) ->
  selected_card = {} unless selected_card?
  selected_card

exports.deck = (deck) ->
  if not deck?
    deck =
      cards: []
      discards: []
  deck

exports.card_display_builder = (card_display_builder) ->
  if not card_display_builder?
    card_display_builder =
      build_card_display: jasmine.createSpy('build_card_display').andReturn(exports.card_display())
  card_display_builder

exports.card_display = (card_display) ->
  if not card_display?
    card_display =
      update_link_label: jasmine.createSpy('update_link_label')
      hide_link: jasmine.createSpy('hide_link')
      show_link: jasmine.createSpy('show_link')
      deselect: jasmine.createSpy('deselect')
      update: jasmine.createSpy('update')
      hide: jasmine.createSpy('hide')
  card_display
