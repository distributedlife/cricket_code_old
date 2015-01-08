define(["ext/three"], function(THREE) {
  "use strict";

  return function(element, scene, camera) {
    var _this = this;

    _this.init = function() {
      _this.scene = scene;
      _this.camera = camera;
      _this.renderer = new THREE.WebGLRenderer({ antialias: true, preserveDrawingBuffer: true });
      element.appendChild(_this.renderer.domElement);
    };

    _this.resize = function(width, height) {
      _this.renderer.setSize(width, height);
    };

    _this.animate = function() {
      _this.renderer.render(_this.scene, _this.camera);
    };

    _this.change_scene = function(scene, camera) {
      _this.scene = scene;
      _this.camera = camera;
    };

    _this.init();
    return _this;
  };
});
