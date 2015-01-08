define([], function() {
  "use strict";

  return function(field, validator, ui_builder) {
    var label = ui_builder.build_label("field_valid");

    var refresh = function() {
      if (validator.validate_field(field)) {
        label.hide();
      } else {
        label.show();
      }
    };

    var init = function() {
      field.on_event('update', refresh);
    };

    init();
  };
});
