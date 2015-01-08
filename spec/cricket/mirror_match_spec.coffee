requirejs = require('../spec_helper').requirejs

module_mock = require('../stubs/module_mock')
module_mock.reset(requirejs)

can_wire_sync = module_mock.spy_on(requirejs, 'lib/can_wire_sync')
notify_after = module_mock.spy_on(requirejs, 'lib/notify_after')

match = {}
mirror_match = requirejs('cricket/mirror_match')

describe 'a mirror match', ->
	beforeEach ->
		match = {}
		mirror_match(match)

	it 'should sync when the server copy completes', ->
		expect(can_wire_sync).toHaveBeenCalledWith(match, '/cricket', 'match/complete', {result: 'result'})

	it 'should send a completed event when synchronised', ->
		expect(notify_after).toHaveBeenCalledWith(match, 'mirror_match', [{after: 'synchronise', emit: 'complete'}])
