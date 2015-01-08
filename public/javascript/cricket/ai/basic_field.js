define(['cricket/terms'], function(Terms) {
  "use strict";

  return function() {
    var _this = this;

    _this.init = function() {
      _this.fielding_ai = "basic";
    };

    _this.set_field = function(field, ai) {
      field.reset();
      field.slips = 0;
      field.set_infielder(Terms.Shots.late_cut);
      field.set_infielder(Terms.Shots.square_drive);
      field.set_infielder(Terms.Shots.cover_drive);
      field.set_infielder(Terms.Shots.off_drive);
      field.set_infielder(Terms.Shots.straight_drive);
      field.set_infielder(Terms.Shots.on_drive);
      field.set_infielder(Terms.Shots.leg_glance);

      field.set_outfielder(Terms.Shots.cut);
      field.set_outfielder(Terms.Shots.pull);
    };

    _this.init();
    return _this;
  };
});
