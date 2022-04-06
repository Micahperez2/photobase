var express = require("express");
var multer = require("multer");
const path = require("path");
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
var most_recent_photo = "";

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
    most_recent_photo: most_recent_photo,
  });
});

// app.post("/post-test", (req, res) => {
//   console.log("Got body:", req.body);
//   //res.sendStatus(200);
//   //var feeds = req.body;
//   photos.push(req.body);
//   res.sendStatus(200);
// });

const handleError = (err, res) => {
  res.status(500).contentType("text/plain").end("Oops! Something went wrong!");
};

//Configuration for Multer
const multerStorage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, "/Users/micah/Desktop/photobase/Photobase-Desktop/public");
  },
  filename: (req, file, cb) => {
    const ext = file.mimetype.split("/")[1];
    //cb(null, `admin-${file.fieldname}-${Date.now()}.${ext}`);
    cb(null, `most_recent.${ext}`);
  },
});

// Multer Filter
const multerFilter = (req, file, cb) => {
  if (file.mimetype.split("/")[1] === "jpg") {
    cb(null, true);
  } else {
    cb(new Error("Not a JPG File!!"), false);
  }
};

const upload = multer({
  storage: multerStorage,
  //fileFilter: multerFilter,
});

app.post(
  "/post-test",
  upload.single(
    "photodata" /* name attribute of <file> element in your form */
  ),
  (req, res) => {
    //const tempPath = req.file.path;
    console.log(req.file.filename);
    most_recent_photo = req.file.filename;
    //const targetPath = path.join(__dirname, "/Users/micah/Desktop/photobase/Photobase-Desktop/uploads");
    //const targetPath = path.join("/Users/micah/Desktop/photobase/Photobase-Desktop/uploads", req.file.originalname);

    // if (path.extname(req.file.originalname).toLowerCase() === ".png") {
    // fs.rename(tempPath, targetPath, err => {
    //   if (err) return handleError(err, res);

    //   res
    //     .status(200)
    //     .contentType("text/plain")
    //     .end("File uploaded!");
    // });
    // } else {
    //   fs.unlink(tempPath, err => {
    //     if (err) return handleError(err, res);

    //     res
    //       .status(403)
    //       .contentType("text/plain")
    //       .end("Only .png files are allowed!");
    //   });
    // }
  }
);

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
  online_url = tunnel.url.replace("https://", "");
  online_url = online_url.replace(".loca.lt", "");
  tunnel.on("close", () => {});
})();
