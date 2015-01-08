define([], function() {
  return function() {
    var _this = this;

    _this.Plays = {
      must_play: 'must play',
      can_leave: 'can leave'
    };

    _this.Distance = {
      none: 'none',
      infield: 'infield',
      outfield: 'outfield'
    };

    _this.Height = {
      on_the_ground: 'on the ground',
      catchable: 'catchable'
    };


    _this.Shots = {};
    _this.ShotsDisplay = {};
    [
      'square_drive', 'cover_drive', 'off_drive', 'straight_drive',
      'on_drive', 'pull', 'hook', 'leg_glance', 'late_cut', 'cut', 'square_cut',
      'block'
    ].forEach(function(shot) {
      _this.Shots[shot] = shot;
      _this.ShotsDisplay[shot] = shot.replace(/_/, " ");
    });

    _this.Length = {};
    [
      'yorker',
      'full',
      'good',
      'short',
      'bouncer'
    ].forEach(function(length) {
      _this.Length[length] = length;
    });

    _this.Balls = {
      wicket: 'x',
      wide: 'w',
      noball: 'nb',
      dot: '.',
      one: 1,
      two: 2,
      three: 3,
      four: 4,
      five: 5,
      six: 6
    };

    _this.Score = {
      'x': 0,
      'w': 1,
      'nb': 1,
      '.': 0,
      '1': 1,
      '2': 2,
      '3': 3,
      '4': 4,
      '5': 5,
      '6': 6
    };

    return _this;
  }();
});
