define(["lib/extend", "lib/will_wire_push", "cricket/field", "cricket/terms", "cricket/events"], function(extend, will_wire_push, become_field, Terms, Events) {
  "use strict";

  var become_server_field = function(server_field) {
    server_field.update_slips_count = function() {
      server_field.slips = server_field.max_fielders - server_field.infielders().length - server_field.outfielders().length;
      server_field.slips = (server_field.slips < 0) ? 0 : server_field.slips;
    };

    server_field.toggle_infielder = function(shot) {
      if (server_field.has_fielder_in_spot(Terms.Distance.infield, shot)) {
        server_field.clear_infielder(shot);
      } else {
        server_field.set_infielder(shot);
      }

      server_field.update_slips_count();
    };

    server_field.toggle_outfielder = function(shot) {
      if (server_field.has_fielder_in_spot(Terms.Distance.outfield, shot)) {
        server_field.clear_outfielder(shot);
      } else {
        server_field.set_outfielder(shot);
      }

      server_field.update_slips_count();
    };

    server_field.reset = function() {
      server_field.infield.forEach(function(position) {
        position.has_fielder = false;
      });

      server_field.outfield.forEach(function(position) {
        position.has_fielder = false;
      });

      server_field.update_slips_count();
    };

    server_field.set_fielder = function(fielding_ring, position_name) {
      var field = server_field.filter_by_position_name(fielding_ring, position_name);
      field[0].has_fielder = true;

      server_field.update_slips_count();
    };

    server_field.clear_fielder = function(fielding_ring, position_name) {
      var field = server_field.filter_by_position_name(fielding_ring, position_name);
      field[0].has_fielder = false;

      server_field.update_slips_count();
    };

    server_field.set_infielder = function(position_name) {
      server_field.set_fielder(server_field.infield, position_name);
      server_field.update_slips_count();
    };

    server_field.clear_infielder = function(position_name) {
      server_field.clear_fielder(server_field.infield, position_name);
      server_field.update_slips_count();
    };

    server_field.set_outfielder = function(position_name) {
      server_field.set_fielder(server_field.outfield, position_name);
      server_field.update_slips_count();
    };

    server_field.clear_outfielder = function(position_name) {
      server_field.clear_fielder(server_field.outfield, position_name);
      server_field.update_slips_count();
    };

    server_field.start_setting = function() {
      server_field.set_mode = true;
    };

    server_field.stop_setting = function() {
      server_field.set_mode = false;
    };
  }

  var push_when = {
    update_slips_count: Events.Field.update,
    start_setting: Events.Field.update,
    stop_setting: Events.Field.update
  };
  var push_what = {
    infield: 'infield',
    outfield: 'outfield',
    slips: 'slips',
    max_fielders: 'max_fielders',
    max_slips: 'max_slips',
    set_mode: 'set_mode'
  };

  return function(server_field, connection) {
    extend(server_field).
      using(become_field).
      using(become_server_field).
      using(will_wire_push, [connection, push_when, push_what]);
  };
});
