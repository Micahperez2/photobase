var randomWords = require('random-words');
var localtunnel = require("localtunnel");
var express = require("express");
var multer = require("multer");
const path = require("path");
const fs = require('fs');
const os = require('os');
var app = express();

app.use(express.urlencoded({ extended: true }));

//Used to look for static files (css) in public folder
app.use(express.static("public"));

// set the view engine to ejs
app.set("view engine", "ejs");
var photos = [];
var online_url = "";
var most_recent_photo = "";

//Get desktop path and use it for photos directory path
const homeDir = require('os').homedir();
const photobaseDir = `${homeDir}/Desktop/Photobase Photos`;

// use res.render to load up an ejs view file
app.get("/", (req, res) => {

  //Render the most recent photo to the current screen
  var tagline = "Photos";
  res.render("pages/index", {
    photos: photos,
    tagline: tagline,
    online_url: online_url,
    most_recent_photo: most_recent_photo,
  });
});

const handleError = (err, res) => {
  res.status(500).contentType("text/plain").end("Oops! Something went wrong!");
};

//Configuration for Multer - unused
const multerStorage = multer.diskStorage({
  destination: (req, file, cb) => {

    try {
      if (!fs.existsSync(photobaseDir)) {
        fs.mkdirSync(photobaseDir);
      }
    } catch (err) {
      console.error(err);
    }
    cb(null, photobaseDir);
  },
  filename: (req, file, cb) => {
    cb(null, `most_recent.jpg`);
    cb(null, `${file.originalname}.jpg`);
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

    fs.copyFile(`${homeDir}/Desktop/Photobase Photos/most_recent.jpg`, 'public/most_recent.jpg', (err) => {
      if (err) throw err;
      console.log('source.txt was copied to destination.txt');
    });

    //const tempPath = req.file.path;
    console.log(req.file.filename);
    most_recent_photo = "most_recent.jpg";
    
    //most_recent_photo = path.join(`${homeDir}/Desktop/Photobase%20Photos`, req.file.filename);
    //console.log(most_recent_photo);
  }
);

// about page
app.get("/about", function (req, res) {
  res.render("pages/about");
});

app.listen(8080, "0.0.0.0");
//  console.log('Server is listening on port 8080')

(async () => {
  var rwlist = randomWords({exactly: 2, maxLength: 4})
  //Example with Custom Subdomain
  const tunnel = await localtunnel({ port: 8080, subdomain: `${rwlist[0]}-${rwlist[1]}` });
  console.log(tunnel.url);
  online_url = tunnel.url.replace("https://", "");
  online_url = online_url.replace(".loca.lt", "");
  tunnel.on("close", () => {});
})();
