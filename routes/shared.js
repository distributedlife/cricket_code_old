module.exports = function(app) {
  app.get('/lose', function(request, response) {
    response.render('lose.haml');
  });

  app.get('/win', function(request, response) {
    response.render('win.haml');
  });
};
