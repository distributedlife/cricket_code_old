define([ 'cricket/terms', 'cricket/socket', 'cricket/events'],
       function(Terms, Socket, Events) {
  "use strict";

  return function(field, ui_builder) {
    var display = this;

    var slips = ui_builder.build_label("slips");

    var infield = [];
    var outfield = [];

    var refresh = function() {
      if (field.is_being_set()) {
        enable_links();
      } else {
        disable_links();
      }

			update_field(field.infield);
			update_field(field.outfield);

			slips.update_text(field.slips);
		};

		var update_field = function(field_array) {
      field_array.forEach(function(spot) {
				var by_position = function(position) { return position.name === spot.name; };

        var position = outfield.filter(by_position)[0];
        if (spot.has_fielder) {
					show_as_occupied(position);
        } else {
					show_as_vacant(position);
        }
      });
		};

		var show_as_occupied = function(position) {
			position.display.update_text(position.distance + ":occupied");
			position.display.add_class("green");
		};

		var show_as_vacant = function(position) {
			position.display.update_text(position.distance + ":vacant");
			position.display.remove_class("green");
		};

    var toggle_infielder = function(shot) {
      return function() {
        display.share_remotely(Events.Field.toggle_fielder, {distance: Terms.Distance.infield, shot: shot});
      };
    };

    var toggle_outfielder = function(shot) {
      return function() {
        display.share_remotely(Events.Field.toggle_fielder, {distance: Terms.Distance.outfield, shot: shot});
      };
    };

    var enable_links = function() {
			var enable = function(link) { link.display.enable(); };

      infield.forEach(enable);
      outfield.forEach(enable);
    };

    var disable_links = function() {
			var disable = function(link) { link.display.disable(); };

      infield.forEach(disable);
      outfield.forEach(disable);
    };

    var init = function() {
      Socket.call(display);

      field.on_event('update', refresh);

      field.infield.forEach(function(spot) {
				var infield_button = ui_builder.build_control("infield_" + spot.name);
				infield_button.update_text("infield:vacant");
				infield_button.on_click(toggle_infielder(spot.name));
				infield_button.disable();

				infield.push({name: spot.name, distance: "infield", display: infield_button});
			});

			field.outfield.forEach(function(spot) {
				var outfield_button = ui_builder.build_control("outfield_" + spot.name);
				outfield_button.update_text("outfield:vacant");
				outfield_button.on_click(toggle_outfielder(spot.name));
				outfield_button.disable();

				outfield.push({name: spot.name, distance: "outfield", display: outfield_button});
			});
    };

    init();
    return display;
  };
});
