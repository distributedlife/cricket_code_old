define(["lib/event_emitter", "ext/three", "lib/grid_view"],
  function(event_emitter, THREE, GridView)
  {
    "use strict";

    return function(width, height) {
      var _this = this;
      _this.typename = "level";
      _this.things = [];
      _this.camera = null;
      _this.scene = new THREE.Scene();

      event_emitter.call(_this);

      _this.level_failed = function() {
        _this.share_locally('failure');
      };

      _this.level_completed = function() {
        _this.share_locally('complete');
      };

      _this.setup_camera = function(width, height) {
        _this.camera = new THREE.OrthographicCamera(0, width, 0, height, -2000, 1000);
        _this.camera.position.z = 1;
      };

      _this.add_grid = function(width, height) {
        var grid = new GridView(width, height);
        _this.scene.add(grid.line);
      };

      _this.add_to_scene_and_things = function(model, view) {
        _this.scene.add(view.mesh);
        _this.things.push(model);
      };


      _this.setup_camera(width, height);
      _this.add_grid(width, height);

      return _this;
    };
});
