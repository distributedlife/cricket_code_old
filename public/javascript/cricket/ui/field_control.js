define(["cricket/socket", "cricket/events"], function(Socket, Events) {
	"use strict";

	return function(field, validator, ui_builder) {
		var _this = this;

		var button = ui_builder.build_control("finish_setting_field");

		var share_user_has_finished_setting_field = function() {
			_this.share_remotely(Events.Field.user_has_finished_setting_field);
		};

		var refresh = function() {
			if (!field.is_being_set()) {
				button.hide();
				return;
			}

			if (field_is_invalid(field)) {
				button.update_text("Please Correct Field to Complete Stage");
				button.disable();
			} else {
				button.update_text("[Finished Setting Field]");
				button.enable();
			}

			button.show();
		};

		var field_is_invalid = function() {
			return (!validator.validate_field(field));
		};

		var init = function() {
			Socket.call(_this);

			button.on_click(share_user_has_finished_setting_field);
			button.hide();

			field.on_event('update', refresh);
		};

		init();
		return _this;
	};
});
