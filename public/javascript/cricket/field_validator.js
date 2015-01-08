define(["cricket/terms"], function(Terms) {
  "use strict";

  return function() {
    var _this = this;

    _this.max_slips = 3;

    _this.conditions_not_met = function(condition) {
      return !condition;
    };

    _this.validate_field = function(field) {
      var conditions = [];

      conditions.push(_this.has_correct_number_of_fielders(field));
      conditions.push(_this.has_no_more_than_3_slips(field));
      conditions.push(_this.has_no_more_than_2_backward_of_square(field));
      conditions.push(_this.does_not_violate_fielding_restrictions(field));

      return conditions.filter(_this.conditions_not_met).length === 0;
    };


    _this.does_not_violate_fielding_restrictions = function(field) {
      var max_allowed = field.restrictions_in_place ? 2 : 5;

      return (field.outfielders().length <= max_allowed);
    };


    _this.is_backward_of_square = function(position) {
      return (position.name === Terms.Shots.leg_glance || position.name === Terms.Shots.hook) && position.has_fielder;
    };

    _this.has_fielder = function(position) {
      return position.has_fielder;
    };

    _this.has_no_more_than_2_backward_of_square = function(field) {
      var infield = field.infield.filter(_this.is_backward_of_square).filter(_this.has_fielder);
      var outfield = field.outfield.filter(_this.is_backward_of_square).filter(_this.has_fielder);

      return infield.length + outfield.length <= 2;
    };


    _this.has_no_more_than_3_slips = function(field) {
      return field.slips <= _this.max_slips;
    };


    _this.has_correct_number_of_fielders = function(field) {
      var total = field.slips + field.infielders().length + field.outfielders().length;
      return total === field.max_fielders;
    };

    return _this;
  };
});
