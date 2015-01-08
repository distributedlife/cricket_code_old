define(['cricket/terms'], function(Terms) {
  "use strict";

  return function(ball) {
    ball.length = null;
    ball.play = null;
    ball.height = null;
    ball.shot = null;
    ball.distance = null;
    ball.bowler_card = null;
    ball.batter_card = null;
    ball.result = null;
    ball.chancing_arm = false;
    ball.complete = false;
    ball.boundary = false;
    ball.stage = 'not_started';

    ball.batter_can_sneak_run = function() {
      if (ball.is_boundary()) {
        return false;
      }
      if (ball.is_wicket()) {
        return false;
      }
      if (ball.is_illegal()) {
        return false;
      }
      if (ball.is_no_shot_being_played()) {
        return false;
      }

      return true;
    };

    ball.bowler_can_cutoff_run = function() {
      if (ball.is_boundary()) {
        return false;
      }
      if (ball.is_wicket()) {
        return false;
      }
      if (ball.is_illegal()) {
        return false;
      }
      if (ball.is_no_shot_being_played()) {
        return false;
      }
      if (ball.runs() === 0) {
        return false;
      }

      return true;
    };

    ball.runs = function() {
      return Terms.Score[ball.result];
    };

    ball.is_complete = function() {
      return ball.complete;
    };

    ball.is_no_shot_being_played = function() {
      return (ball.batter_card === null);
    };

    ball.is_must_play = function() {
      return (ball.play === Terms.Plays.must_play) ;
    };

    ball.is_catchable = function() {
      return (ball.height === Terms.Height.catchable);
    };

    ball.is_infield = function() {
      return (ball.distance === Terms.Distance.infield);
    };

    ball.is_outfield = function() {
      return (ball.distance === Terms.Distance.outfield);
    };

    ball.is_wicket = function() {
      return ball.result === Terms.Balls.wicket;
    };

    ball.is_legal = function() {
      return !ball.is_illegal();
    };

    ball.is_illegal = function() {
      return ball.result === Terms.Balls.wide || ball.result === Terms.Balls.noball;
    };

    ball.is_boundary = function() {
      return ball.boundary;
    };
  };
});
