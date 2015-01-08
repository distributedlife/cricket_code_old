define(function() {
  return function() {
    var _this = this;

    _this.image_path = "/public/img/";
    _this.audio_path = "/public/audio/";
    _this.swf_path = "/public/swf/";

    _this.metric_server = "ws://localhost:1080/1.0/event/put";

    _this.nodamage = true;
    _this.global_volume = 0.0;
    _this.global_time_dilation = 1;
    _this.wireframe = false;

    _this.grid = {
      enabled: false,
      size: 50,
      colour: 0x00FF00
    };

    return _this;
  }();
});
