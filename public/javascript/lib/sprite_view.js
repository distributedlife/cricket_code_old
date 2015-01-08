define(["ext/three", "lib/config"], function(THREE, config) {
  "use strict";

  return function(thing, texture_name) {
    var _this = this;
    _this.mesh = null;

    _this.create_mesh = function() {
      var geometry = new THREE.PlaneGeometry(thing.width, thing.height);
      var texture = THREE.ImageUtils.loadTexture(texture_name);
      var material = new THREE.MeshBasicMaterial({map:texture, wireframe: config.wireframe});

      _this.mesh = new THREE.Mesh(geometry, material);
      _this.mesh.position.x = thing.box.x;
      _this.mesh.position.y = thing.box.y;

      _this.mesh.visible = false;

      _this.mesh.rotation.x = -90;
    };

    _this.show = function() {
      _this.mesh.visible = true;
    };

    _this.hide = function() {
      _this.mesh.visible = false;
    };

    _this.update_position = function(thing) {
      _this.mesh.position.x = thing.box.x;
      _this.mesh.position.y = thing.box.y;
    };


    _this.create_mesh();

    return _this;
  };
});
