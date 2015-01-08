define(['lib/extend', 'lib/will_wire_push', 'lib/notify_after', 'cricket/deck', 'cricket/events'], function(extend, will_wire_push, notify_after, become_deck, Events) {
  "use strict";

  var push_when = {
    add: Events.Deck.update,
    remove: Events.Deck.update,
    remove_by_index: Events.Deck.update,
    draw: Events.Deck.update,
    top_card: Events.Deck.update,
    discard: Events.Deck.update,
    shuffle: Events.Deck.update 
  };
  var push_fields = {
    cards: 'cards',
    discards: 'discards'
  };

  var emit_when = [
    {after: 'add', emit: 'update'},
    {after: 'remove', emit: 'update'},
    {after: 'remove_by_index', emit: 'update'},
    {after: 'draw', emit: 'update'},
    {after: 'top_card', emit: 'update'},
    {after: 'discard', emit: 'update'},
    {after: 'shuffle', emit: 'update'}
  ];

  var become_server_deck = function(server_deck) {
    server_deck.add = function(card) {
      server_deck.cards.push(card);
    };

    server_deck.remove = function(card) {
       var i = server_deck.cards.indexOf(card);
       server_deck.cards.splice(i, 1);
    };

    server_deck.remove_by_index = function(index) {
      return server_deck.cards.splice(index, 1);
    };

    server_deck.draw = function() {
      if (server_deck.empty()) {
        server_deck.cards = server_deck.discards;
        server_deck.discards = [];
        server_deck.shuffle();
      }

      return server_deck.top_card();
    };

    server_deck.top_card = function() {
      return server_deck.cards.pop();
    };

    server_deck.discard = function(card) {
      server_deck.discards.push(card);
    };

    server_deck.shuffle = function() {
      var length = server_deck.cards.length;
      if (length < 2) {
        return;
      }

      while (length) {
        var k = Math.floor(Math.random() * length--);
        var t = server_deck.cards[k];

        while (k < length) {
          server_deck.cards[k] = server_deck.cards[++k];
        }

        server_deck.cards[k] = t;
      }
    };
  };

  return function(server_deck, connection, cards) {
    extend(server_deck).
      using(become_deck, [cards]).
      using(become_server_deck).
      using(will_wire_push, [connection, push_when, push_fields]).
      using(notify_after, ['server_deck', emit_when]);
  };
});
