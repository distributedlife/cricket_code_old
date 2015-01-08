define(['lib/become_client'], function(become_client) {
  "use strict";

  return function(obj, channel, on_events, field_map, callback) {
    become_client(obj, channel)

    obj.synchronise = function(data) {
      if (data.id !== undefined) {
        if (data.id !== obj.source_id) {
          return;
        }
      }

      Object.keys(field_map).forEach(function(field) {
        obj[field] = data[field_map[field]];
      });

      if (callback !== undefined) {
        callback(data);
      }
    }

    on_events.forEach(function(on_event) {
      obj.on_server_event(on_event, obj.synchronise);  
    });
  };
});
