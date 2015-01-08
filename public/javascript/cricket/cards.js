define(['cricket/terms'], function(Terms) {
  return function() {
    var _this = this;

    _this.card = function(length, play, shot, distance, catchable) {
      return { length: length, play: play, shot: shot, distance: distance, catchable: catchable };
    };

    _this.combination = function(play, distance, catchable) {
      return {play: play, distance: distance, catchable: catchable};
    };

    _this.cards = function(length, shots, combinations) {
      var cards = [];

      shots.forEach(function(shot) {
        combinations.forEach(function(combo) {
          cards.push(_this.card(length, combo.play, shot, combo.distance, combo.catchable));
        });
      });

      return cards;
    };

    _this.full_length = function() {
      var length = Terms.Length.full;
      var shots = [Terms.Shots.square_drive, Terms.Shots.cover_drive, Terms.Shots.off_drive, Terms.Shots.straight_drive, Terms.Shots.on_drive, Terms.Shots.leg_glance];
      var combinations = [
        _this.combination(Terms.Plays.must_play, Terms.Distance.infield, Terms.Height.on_the_ground),
        _this.combination(Terms.Plays.must_play, Terms.Distance.infield, Terms.Height.on_the_ground),
        _this.combination(Terms.Plays.must_play, Terms.Distance.infield, Terms.Height.on_the_ground),

        _this.combination(Terms.Plays.must_play, Terms.Distance.infield, Terms.Height.catchable),

        _this.combination(Terms.Plays.must_play, Terms.Distance.outfield, Terms.Height.on_the_ground),
        _this.combination(Terms.Plays.must_play, Terms.Distance.outfield, Terms.Height.on_the_ground),

        _this.combination(Terms.Plays.must_play, Terms.Distance.outfield, Terms.Height.catchable),

        _this.combination(Terms.Plays.can_leave, Terms.Distance.infield, Terms.Height.on_the_ground),
        _this.combination(Terms.Plays.can_leave, Terms.Distance.infield, Terms.Height.catchable),
        _this.combination(Terms.Plays.can_leave, Terms.Distance.outfield, Terms.Height.on_the_ground),
        _this.combination(Terms.Plays.can_leave, Terms.Distance.outfield, Terms.Height.catchable)
      ];

      return _this.cards(length, shots, combinations);
    };

    _this.good_length = function() {
      var length = Terms.Length.good;
      var shots = [Terms.Shots.block];
      var combinations = [
        _this.combination(Terms.Plays.must_play, Terms.Distance.none, Terms.Height.on_the_ground),
        _this.combination(Terms.Plays.must_play, Terms.Distance.none, Terms.Height.on_the_ground),
        _this.combination(Terms.Plays.must_play, Terms.Distance.none, Terms.Height.on_the_ground),
        _this.combination(Terms.Plays.must_play, Terms.Distance.none, Terms.Height.on_the_ground),

        _this.combination(Terms.Plays.must_play, Terms.Distance.none, Terms.Height.on_the_ground),
        _this.combination(Terms.Plays.must_play, Terms.Distance.none, Terms.Height.on_the_ground),
        _this.combination(Terms.Plays.must_play, Terms.Distance.none, Terms.Height.on_the_ground),
        _this.combination(Terms.Plays.must_play, Terms.Distance.none, Terms.Height.on_the_ground),

        _this.combination(Terms.Plays.must_play, Terms.Distance.none, Terms.Height.on_the_ground),
        _this.combination(Terms.Plays.must_play, Terms.Distance.none, Terms.Height.on_the_ground),
        _this.combination(Terms.Plays.must_play, Terms.Distance.none, Terms.Height.on_the_ground),
        _this.combination(Terms.Plays.must_play, Terms.Distance.none, Terms.Height.on_the_ground),

        _this.combination(Terms.Plays.can_leave, Terms.Distance.none, Terms.Height.on_the_ground),
        _this.combination(Terms.Plays.can_leave, Terms.Distance.none, Terms.Height.on_the_ground),
        _this.combination(Terms.Plays.can_leave, Terms.Distance.none, Terms.Height.on_the_ground),
        _this.combination(Terms.Plays.can_leave, Terms.Distance.none, Terms.Height.on_the_ground)
      ];

      return _this.cards(length, shots, combinations);
    };

    _this.short_length = function() {
      var length = Terms.Length.short;
      var shots = [Terms.Shots.pull, Terms.Shots.hook, Terms.Shots.leg_glance, Terms.Shots.late_cut, Terms.Shots.cut, Terms.Shots.square_cut];
      var combinations = [
        _this.combination(Terms.Plays.must_play, Terms.Distance.infield, Terms.Height.on_the_ground),
        _this.combination(Terms.Plays.must_play, Terms.Distance.infield, Terms.Height.catchable),
        _this.combination(Terms.Plays.must_play, Terms.Distance.outfield, Terms.Height.on_the_ground),
        _this.combination(Terms.Plays.must_play, Terms.Distance.outfield, Terms.Height.catchable),

        _this.combination(Terms.Plays.can_leave, Terms.Distance.infield, Terms.Height.on_the_ground),

        _this.combination(Terms.Plays.can_leave, Terms.Distance.infield, Terms.Height.catchable),
        _this.combination(Terms.Plays.can_leave, Terms.Distance.infield, Terms.Height.catchable),

        _this.combination(Terms.Plays.can_leave, Terms.Distance.outfield, Terms.Height.on_the_ground),

        _this.combination(Terms.Plays.can_leave, Terms.Distance.outfield, Terms.Height.catchable),
        _this.combination(Terms.Plays.can_leave, Terms.Distance.outfield, Terms.Height.catchable),
        _this.combination(Terms.Plays.can_leave, Terms.Distance.outfield, Terms.Height.catchable)
      ];

      return _this.cards(length, shots, combinations);
     };

    _this.bouncers = function() {
      var length = Terms.Length.bouncer;
      var shots = [Terms.Shots.hook, Terms.Shots.late_cut, Terms.Shots.cut];
      var combinations = [
        _this.combination(Terms.Plays.can_leave, Terms.Distance.infield, Terms.Height.on_the_ground),
        _this.combination(Terms.Plays.can_leave, Terms.Distance.infield, Terms.Height.on_the_ground),

        _this.combination(Terms.Plays.can_leave, Terms.Distance.infield, Terms.Height.catchable),
        _this.combination(Terms.Plays.can_leave, Terms.Distance.infield, Terms.Height.catchable),
        _this.combination(Terms.Plays.can_leave, Terms.Distance.infield, Terms.Height.catchable),
        _this.combination(Terms.Plays.can_leave, Terms.Distance.infield, Terms.Height.catchable),

        _this.combination(Terms.Plays.can_leave, Terms.Distance.outfield, Terms.Height.on_the_ground),

        _this.combination(Terms.Plays.can_leave, Terms.Distance.outfield, Terms.Height.catchable),
        _this.combination(Terms.Plays.can_leave, Terms.Distance.outfield, Terms.Height.catchable),
        _this.combination(Terms.Plays.can_leave, Terms.Distance.outfield, Terms.Height.catchable),
        _this.combination(Terms.Plays.can_leave, Terms.Distance.outfield, Terms.Height.catchable)
      ];

      return _this.cards(length, shots, combinations);
     };

    _this.yorkers = function() {
      var length = Terms.Length.yorker;
      var shots = [Terms.Shots.block];
      var combinations = [
        _this.combination(Terms.Plays.must_play, Terms.Distance.none, Terms.Height.on_the_ground),
        _this.combination(Terms.Plays.must_play, Terms.Distance.none, Terms.Height.on_the_ground),
        _this.combination(Terms.Plays.must_play, Terms.Distance.none, Terms.Height.on_the_ground),
        _this.combination(Terms.Plays.must_play, Terms.Distance.none, Terms.Height.on_the_ground),

        _this.combination(Terms.Plays.must_play, Terms.Distance.none, Terms.Height.on_the_ground),
        _this.combination(Terms.Plays.must_play, Terms.Distance.none, Terms.Height.on_the_ground),
        _this.combination(Terms.Plays.must_play, Terms.Distance.none, Terms.Height.on_the_ground),
        _this.combination(Terms.Plays.must_play, Terms.Distance.none, Terms.Height.on_the_ground),

        _this.combination(Terms.Plays.must_play, Terms.Distance.none, Terms.Height.on_the_ground),
        _this.combination(Terms.Plays.must_play, Terms.Distance.none, Terms.Height.on_the_ground),
        _this.combination(Terms.Plays.must_play, Terms.Distance.none, Terms.Height.on_the_ground)
      ];

      return _this.cards(length, shots, combinations);
     };

    _this.chance_arm = function() {
      var cards = [];
      var i = 0;

      for(i = 0; i < 8; i++) {
        cards.push('4');
        cards.push('outfield catch');
      }

      for(i = 0; i < 4; i++) {
        cards.push('6');
        cards.push('infield catch');
      }

      return cards;
    };

    return _this;
  };
});
