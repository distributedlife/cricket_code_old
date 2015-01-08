module.exports = function(app) {
  app.get('/cricket', function(request, response) {
    response.render('cricket/t20.haml');
  });
};
