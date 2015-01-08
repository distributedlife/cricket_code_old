requirejs = require('../spec_helper').requirejs

match = null
p1 =
p2 =
innings1 =
  batter: null
  bowler: null
innings2 =
  batter: null
  bowler: null

LimitedOversMatch = requirejs('cricket/limited_overs_match')
describe 'a limited overs match', ->
  beforeEach ->
    match = new LimitedOversMatch()
    match.wickets_per_innings = 10
    match.player1_innings = innings1
    match.player2_innings = innings2

  describe 'the winner', ->
    beforeEach ->
      match.player1_innings =
        runs: jasmine.createSpy('player1.runs')
        wickets_lost: jasmine.createSpy('player1.runs')
      match.player2_innings =
        runs: jasmine.createSpy('player2.runs')
        wickets_lost: jasmine.createSpy('player2.runs')
      match.determine_first_batter = jasmine.createSpy('match.determine_first_batter')
      match.determine_result = jasmine.createSpy('match.determine_result')
      match.winner()

    it 'should get the runs and wickets for each player', ->
      expect(match.player1_innings.runs).toHaveBeenCalled()
      expect(match.player2_innings.runs).toHaveBeenCalled()
      expect(match.player1_innings.wickets_lost).toHaveBeenCalled()
      expect(match.player2_innings.wickets_lost).toHaveBeenCalled()

    it 'should determine the first batter', ->
      expect(match.determine_first_batter).toHaveBeenCalled()

    it 'should determine the result', ->
      expect(match.determine_result).toHaveBeenCalled()

  describe 'determining who batted first', ->
    it 'should set the batted_first property', ->
      p1 = {}
      p2 = {}
      match.batted_first = 1
      match.determine_first_batter(p1, p2)
      expect(p1.batted_first).toBeTruthy()
      expect(p2.batted_first).toBeFalsy()

      p1 = {}
      p2 = {}
      match.batted_first = 2
      match.determine_first_batter(p1, p2)
      expect(p1.batted_first).toBeFalsy()
      expect(p2.batted_first).toBeTruthy()


  describe 'determining the result', ->
    it 'should return a tied result if scores are equal', ->
      p1 = {runs: 1}
      p2 = {runs: 1}
      expect(match.determine_result(p1,p2).winner).toEqual('tie')

    it 'should return p1 the winner if p1 has a higher score', ->
      p1 = {runs: 10}
      p2 = {runs: 0}
      expect(match.determine_result(p1,p2).winner).toEqual(1)

    it 'should return p2 the winner if p2 has a higher score', ->
      p1 = {runs: 0}
      p2 = {runs: 10}
      expect(match.determine_result(p1,p2).winner).toEqual(2)

    it 'should determine the margin', ->
      match.determine_margin = jasmine.createSpy('match.determine_margin').andReturn({})
      p1 = {runs: 10}
      p2 = {runs: 0}
      match.determine_result(p1,p2)
      expect(match.determine_margin).toHaveBeenCalledWith(p1, p2)

      p1 = {runs: 0}
      p2 = {runs: 10}
      match.determine_result(p1,p2)
      expect(match.determine_margin).toHaveBeenCalledWith(p2, p1)

  describe 'determining the margin', ->
    it 'has the margin in runs if winner batted first', ->
      winner = {runs: 220, wickets_lost: 0, batted_first: true}
      loser = {runs: 187, wickets_lost: 0}
      expect(match.determine_margin(winner,loser).factor).toBe('runs')

    it 'has the margin in wickets if winner bowled first', ->
      winner = {runs: 188, wickets_lost: 0, batted_first: false}
      loser = {runs: 187, wickets_lost: 0}
      expect(match.determine_margin(winner,loser).factor).toBe('wickets')

    it 'calculates the run margin correctly', ->
      winner = {runs: 220, wickets_lost: 0, batted_first: true}
      loser = {runs: 187, wickets_lost: 0}
      expect(match.determine_margin(winner,loser).margin).toBe(33)

    it 'calculates the wickets win correctly', ->
      winner = {runs: 188, wickets_lost: 7, batted_first: false}
      loser = {runs: 187, wickets_lost: 0}
      expect(match.determine_margin(winner,loser).margin).toBe(3)

      winner = {runs: 188, wickets_lost: 0, batted_first: false}
      loser = {runs: 187, wickets_lost: 0}
      expect(match.determine_margin(winner,loser).margin).toBe(10)

  describe 'the coin toss', ->
    it 'should flip a coin', ->
      match.simulate_coin_flip = jasmine.createSpy('match.simulate_coin_flip').andReturn('heads')
      match.toss_coin(p1, p2)
      expect(match.simulate_coin_flip).toHaveBeenCalled()

    it 'should setup the innings batters and bowlers', ->
      match.simulate_coin_flip = jasmine.createSpy('match.simulate_coin_flip').andReturn('heads')
      match.toss_coin(p1, p2)
      expect(match.player1_innings.batter).toBe(p1)
      expect(match.player1_innings.bowler).toBe(p2)
      expect(match.player2_innings.batter).toBe(p2)
      expect(match.player2_innings.bowler).toBe(p1)

  describe 'play', ->
    it 'should setting up the batter and bowler', ->
      match.toss_coin(p1, p2)
      match.batted_first = 1
      match.play()
      expect(match.player1_innings.batter.batting).toBeTruthy()
      expect(match.player1_innings.bowler.batting).toBeFalsy()

      match.toss_coin(p1, p2)
      match.batted_first = 2
      match.play()
      expect(match.player2_innings.batter.batting).toBeTruthy()
      expect(match.player2_innings.bowler.batting).toBeFalsy()

    it 'should notify listeners of the new innings', ->
      match.toss_coin(p1, p2)
      match.batted_first = 1
      match.share_locally = jasmine.createSpy('match.share_locally')
      match.play()
      expect(match.share_locally).toHaveBeenCalledWith('new_innings', match.player1_innings)

      match.toss_coin(p1, p2)
      match.batted_first = 2
      match.share_locally = jasmine.createSpy('match.share_locally')
      match.play()
      expect(match.share_locally).toHaveBeenCalledWith('new_innings', match.player2_innings)

  describe 'complete', ->
    it 'should return true if both innings are complete', ->
      match.player1_innings.complete = -> false
      match.player2_innings.complete = -> true
      expect(match.complete()).toBeFalsy()
      match.player1_innings.complete = -> true
      match.player2_innings.complete = -> false
      expect(match.complete()).toBeFalsy()
      match.player1_innings.complete = -> true
      match.player2_innings.complete = -> true
      expect(match.complete()).toBeTruthy()

  describe 'innings_complete', ->
    describe 'when match complete', ->
      it 'should notify the match is complete', ->
        innings1.complete = -> true
        innings2.complete = -> true
        match.share_locally = jasmine.createSpy('match.share_locally')
        match.innings_complete(innings1)
        expect(match.share_locally).toHaveBeenCalledWith('complete', match)

    describe 'when match not complete', ->
      it 'should set the target for the second innings', ->
        innings1.complete = -> true
        innings1.runs = -> 100
        innings2.complete = -> false
        match.innings_complete(innings1)
        expect(innings2.target).toBe(innings1.runs() + 1)

      it 'should configure the next innings batter and bowler', ->
        innings1.complete = -> true
        innings1.runs = -> 100
        innings2.complete = -> false
        match.innings_complete(innings1)
        expect(innings2.batter.batting).toBeTruthy()
        expect(innings2.bowler.batting).toBeFalsy()

        innings2.complete = -> true
        innings2.runs = -> 100
        innings1.complete = -> false
        match.innings_complete(innings2)
        expect(innings1.batter.batting).toBeTruthy()
        expect(innings1.bowler.batting).toBeFalsy()

      it 'should notify the start of the second innings', ->
        innings1.complete = -> true
        innings1.runs = -> 100
        innings2.complete = -> false
        match.share_locally = jasmine.createSpy('match.share_locally')
        match.innings_complete(innings1)
        expect(match.share_locally).toHaveBeenCalledWith('new_innings', innings2)

        innings1.complete = -> false
        innings2.complete = -> true
        innings2.runs = -> 100
        match.share_locally = jasmine.createSpy('match.share_locally')
        match.innings_complete(innings2)
        expect(match.share_locally).toHaveBeenCalledWith('new_innings', innings1)

  describe 'new ball', ->
    it 'should bubble the new ball event', ->
      ball = {'a': 'a'}
      match.share_locally = jasmine.createSpy('match.share_locally')
      match.new_ball(ball)
      expect(match.share_locally).toHaveBeenCalledWith('new_ball', ball)
