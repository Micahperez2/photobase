var express = require("express");
var app = express();
//const ngrok = require('ngrok');
var localtunnel = require("localtunnel");

app.use(express.urlencoded({ extended: true }));

//Used to look for static files (css) in public folder
app.use(express.static("public"));

// set the view engine to ejs
app.set("view engine", "ejs");
var photos = [];
var online_url = "";

// use res.render to load up an ejs view file
// index page

app.get("/", (req, res) => {
  //   var photos = [
  //     { name: 'Sammy', organization: "DigitalOcean", birth_year: 2012},
  //     { name: 'Tux', organization: "Linux", birth_year: 1996},
  //     { name: 'Moby Dock', organization: "Docker", birth_year: 2013}
  //   ];
  //var feed = {name: 'Sammy', organization: "DigitalOcean", birth_year: 2012}
  //photos.push(feed);

  var tagline = "Photos";

  res.render("pages/index", {
    photos: photos,
    tagline: tagline,
    online_url: online_url,
  });
});

app.post("/post-test", (req, res) => {
  console.log("Got body:", req.body);
  //res.sendStatus(200);
  //var feeds = req.body;
  photos.push(req.body);
  res.sendStatus(200);
});

// about page
app.get("/about", function (req, res) {
  res.render("pages/about");
});

//app.listen(8080);
//console.log('Server is listening on port 8080');

app.listen(8080, "0.0.0.0");
//  console.log('Server is listening on port 8080')

(async () => {
  const tunnel = await localtunnel({ port: 8080 });
  //With Custom Subdomain
  //const tunnel = await localtunnel({ port: 8080, subdomain: "heyworld" });
  console.log(tunnel.url);
  online_url = tunnel.url.replace("https://","");;
  online_url = online_url.replace(".loca.lt", "")
  tunnel.on("close", () => {});
})();
