requirejs = require('../spec_helper').requirejs

module_mock = require('../stubs/module_mock')
module_mock.reset(requirejs)

can_wire_sync = module_mock.spy_on(requirejs, 'lib/can_wire_sync')
notify_after = module_mock.spy_on(requirejs, 'lib/notify_after')

field = {}
data =
  infield: "infield"
  outfield: "outfield"
  slips: "slips"
  max_fielders: "max fielders"
  max_slips: "max slips"

become_mirror_field = requirejs('cricket/mirror_field')

describe "a mirror field", ->
  beforeEach ->
    field = {}
    become_mirror_field(field)

  it 'should synchronise when the server copy updates', ->
    field_map =
      infield: 'infield',
      outfield: 'outfield',
      slips: 'slips',
      max_fielders: 'max_fielders',
      max_slips: 'max_slips',
      set_mode: 'set_mode'
    expect(can_wire_sync).toHaveBeenCalledWith(field, '/cricket', ['field/update'], field_map)

  it 'should send an updated event when synchronised', -> 
    func_event_map = [
      {after: 'synchronise', emit: 'update'}
    ]
    expect(notify_after).toHaveBeenCalledWith(field, 'mirror_field', func_event_map)
