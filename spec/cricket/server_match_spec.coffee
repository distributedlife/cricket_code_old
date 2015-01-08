requirejs = require('../spec_helper').requirejs
cricket = require('../stubs/cricket')

module_mock = require('../stubs/module_mock')
module_mock.reset(requirejs)

will_wire_push = module_mock.spy_on(requirejs, 'lib/will_wire_push')

server_match = {}
connection = {}
match =
	winner: -> 'winnzor'
become_server_match = requirejs('cricket/server_match')

describe 'a server match', ->
	beforeEach ->
		server_match = {}
		module_mock.capture_events_on(match)
		become_server_match(server_match, connection, match);

	it 'should push updates match the wire', ->
		push_when =
			match_complete: 'match/complete'

		push_fields =
			result: 'result'

		expect(will_wire_push).toHaveBeenCalledWith(server_match, connection, push_when, push_fields)

	it 'should update the result when the match completes', ->
		server_match.result = 'not set'
		match.test_complete(match)
		expect(server_match.result).toBe('winnzor')
