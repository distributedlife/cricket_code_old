define(function() {
  "use strict";

  return function(centre_x, centre_y, width, height) {
    this.x = centre_x;
    this.y = centre_y;
    this.half_width = width / 2;
    this.half_height = height / 2;

    this.left = function() { return this.x - this.half_width; };
    this.right = function() { return this.x + this.half_width; };
    this.top = function() { return this.y - this.half_height; };
    this.bottom = function() {return this.y + this.half_height; };

    this.is_colliding_with = function(other_box) {
      if (this === other_box) { return false; }
      if (this.bottom() < other_box.top()) { return false; }
      if (this.top() > other_box.bottom()) { return false; }
      if (this.right() < other_box.left()) { return false; }
      if (this.left() > other_box.right()) { return false; }

      return true;
    };

    return this;
  };
});
