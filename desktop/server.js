var express = require('express');
var app = express();
app.use(express.urlencoded({extended: true}));

// set the view engine to ejs
app.set('view engine', 'ejs');
var mascots = []

// use res.render to load up an ejs view file
// index page

app.get('/', (req, res) => {
    //   var mascots = [
    //     { name: 'Sammy', organization: "DigitalOcean", birth_year: 2012},
    //     { name: 'Tux', organization: "Linux", birth_year: 1996},
    //     { name: 'Moby Dock', organization: "Docker", birth_year: 2013}
    //   ];
         //var feed = {name: 'Sammy', organization: "DigitalOcean", birth_year: 2012}
         //mascots.push(feed);
    
        var tagline = "No programming concept is complete without a cute animal mascot.";
    
      res.render('pages/index', {
        mascots: mascots,
        tagline: tagline
      });
});

app.post('/post-test', (req, res) => {
    console.log('Got body:', req.body);
    //res.sendStatus(200);
    //var feeds = req.body;
    mascots.push(req.body);
    res.sendStatus(200);
});

// about page
app.get('/about', function(req, res) {
  res.render('pages/about');
});

app.listen(8080);
console.log('Server is listening on port 8080');

