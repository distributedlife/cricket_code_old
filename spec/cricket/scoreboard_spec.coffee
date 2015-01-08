requirejs = require('../spec_helper').requirejs

scoreboard = {}
expected_scoreboard =
	player1:
		runs: 0
		wickets: 0
		overs: 0
		record: 0
		run_rate: 0
		required_run_rate: 0
	player2:
		runs: 0
		wickets: 0
		overs: 0
		record: 0
		run_rate: 0
		required_run_rate: 0

become_scoreboard = requirejs('cricket/scoreboard')

describe 'becoming a scoreboard', ->
	beforeEach ->
		scoreboard = {}
		become_scoreboard(scoreboard)

	it 'should add necessary display properties for both player 1 and player 2', ->
		expect(scoreboard).toEqual(expected_scoreboard)