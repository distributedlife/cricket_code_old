define([], function() {
  "use strict";

  return function(ball, ui_builder) {
    var length = ui_builder.build_label("length");
    var play = ui_builder.build_label("play");
    var shot = ui_builder.build_label("shot");
    var height = ui_builder.build_label("height");
    var distance = ui_builder.build_label("distance");
    var chancing_arm = ui_builder.build_label("chancing_arm");
    var result = ui_builder.build_label("result");

    var refresh = function() {
      var not_set = 'not set';
      var text = not_set;

      text = ball._length ? ball._length : not_set;
      length.update_text(text);
      length.remove_class('full');
      length.remove_class('good');
      length.remove_class('short');
      length.remove_class('bouncer');
      length.add_class(text);

      text = ball._play ? ball._play : not_set;
      play.update_text(text);

      text = ball._shot ? ball._shot : not_set;
      shot.update_text(text);

      text = ball._height ? ball._height : not_set;
      height.update_text(text);

      text = ball._distance ? ball._distance : not_set;
      distance.update_text(text);

      text = ball._chancing_arm ? 'yes' : 'no' ;
      chancing_arm.update_text(text);

      text = ball._result ? ball._result: not_set;
      result.update_text(text);
    };

    var init = function() {
      ball.on_event('update', refresh);
    };

    init();
  };
});

