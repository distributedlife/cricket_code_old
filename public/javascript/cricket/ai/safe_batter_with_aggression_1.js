define(['cricket/ai/safe_batter_with_aggression'], function(SafeBatterWithAggression) {

  var batting_ai = function(slice) {

    return function() {
      SafeBatterWithAggression.call(this);
      this.batting_ai = 'safe batter with aggression 1';
      this.risk_appetite = 2.0;

      return this;
    };
  }([].slice);

  return batting_ai;
});

