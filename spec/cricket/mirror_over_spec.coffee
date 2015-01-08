requirejs = require('../spec_helper').requirejs

module_mock = require('../stubs/module_mock')
module_mock.reset(requirejs)

can_wire_sync = module_mock.spy_on(requirejs, 'lib/can_wire_sync')
mirror_latest = module_mock.spy_on(requirejs, 'lib/mirror_latest')
notify_after = module_mock.spy_on(requirejs, 'lib/notify_after')

over = {}
mirror_over = requirejs('cricket/mirror_over')

describe 'a mirror over', ->
	beforeEach ->
		over = {}
		mirror_over(over)

	it 'should synchronise when the server copy updates', ->
		field_map =
			balls: 'balls',
			balls_in_over: 'balls_in_over',
			stage: 'stage'
		expect(can_wire_sync).toHaveBeenCalledWith(over, '/cricket', ['over/update'], field_map)

	it 'should always track the most recent over', ->
		expect(mirror_latest).toHaveBeenCalledWith(over, '/cricket', 'over/create')

	it 'should send an updated event when synchronised', ->	
		func_event_map = [
			{after: 'synchronise', emit: 'update'}
		]
		expect(notify_after).toHaveBeenCalledWith(over, 'mirror_over', func_event_map)