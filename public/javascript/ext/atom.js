define(function() {
  "use strict";

  return function() {
    var _this = this;

    _this.__indexOf = [].indexOf || function(item) {
      for (var i = 0, l = this.length; i < l; i++) {
        if (i in this && this[i] === item) {
          return i;
        }
      }
      return -1;
    };

    _this._bindings = {};
    _this._down = {};
    _this._pressed = {};
    _this._released = [];
    _this.mouse = {
      x: 0,
      y: 0
    };
    _this.bind = function(key, action) {
      return _this._bindings[key] = action;
    };
    _this.onkeydown = function(e) {
      var action;
      action = _this._bindings[_this.eventCode(e)];
      if (!action) {
        return;
      }
      if (!_this._down[action]) {
        _this._pressed[action] = true;
      }
      _this._down[action] = true;
      e.stopPropagation();
      return e.preventDefault();
    };
    _this.onkeyup = function(e) {
      var action;
      action = _this._bindings[_this.eventCode(e)];
      if (!action) {
        return;
      }
      _this._released.push(action);
      e.stopPropagation();
      return e.preventDefault();
    };
    _this.clearPressed = function() {
      var action, _i, _len, _ref;
      _ref = _this._released;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        action = _ref[_i];
        _this._down[action] = false;
      }
      _this._released = [];
      return _this._pressed = {};
    };
    _this.pressed = function(action) {
      return _this._pressed[action];
    };
    _this.down = function(action) {
      return _this._down[action];
    };
    _this.released = function(action) {
      return _this.__indexOf.call(_this._released, action) >= 0;
    };
    _this.onmousemove = function(e) {
      _this.mouse.x = e.pageX;
      return _this.mouse.y = e.pageY;
    };
    _this.onmousedown = function(e) {
      return _this.onkeydown(e);
    };
    _this.onmouseup = function(e) {
      return _this.onkeyup(e);
    };
    _this.onmousewheel = function(e) {
      _this.onkeydown(e);
      return _this.onkeyup(e);
    };
    _this.oncontextmenu = function(e) {
      if (_this._bindings[_this.button.RIGHT]) {
        e.stopPropagation();
        return e.preventDefault();
      }
    };

    _this.button = {
      LEFT: -1,
      MIDDLE: -2,
      RIGHT: -3,
      WHEELDOWN: -4,
      WHEELUP: -5
    };

    _this.key = {
      TAB: 9,
      ENTER: 13,
      ESC: 27,
      SPACE: 32,
      LEFT_ARROW: 37,
      UP_ARROW: 38,
      RIGHT_ARROW: 39,
      DOWN_ARROW: 40
    };

    var _i = 65;
    for (var c = _i; _i <= 90; c = ++_i) {
      _this.key[String.fromCharCode(c)] = c;
    }

    _this.eventCode = function(e) {
      if (e.type === 'keydown' || e.type === 'keyup') {
        return e.keyCode;
      } else if (e.type === 'mousedown' || e.type === 'mouseup') {
        switch (e.button) {
        case 0:
          return _this.button.LEFT;
        case 1:
          return _this.button.MIDDLE;
        case 2:
          return _this.button.RIGHT;
        }
      } else if (e.type === 'mousewheel') {
        if (e.wheel > 0) {
          return _this.button.WHEELUP;
        } else {
          return _this.button.WHEELDOWN;
        }
      }
    };

    _this.bind_to_canvas = function(document, window) {
      document.onkeydown = _this.onkeydown.bind(_this);
      document.onkeyup = _this.onkeyup.bind(_this);
      document.onmouseup = _this.onmouseup.bind(_this);

      _this.canvas = document.getElementsByTagName('canvas')[0];
      _this.canvas.onmousemove = _this.onmousemove.bind(_this);
      _this.canvas.onmousedown = _this.onmousedown.bind(_this);
      _this.canvas.onmouseup = _this.onmouseup.bind(_this);
      _this.canvas.onmousewheel = _this.onmousewheel.bind(_this);
      _this.canvas.oncontextmenu = _this.oncontextmenu.bind(_this);
    };

    return _this;
  };
});
