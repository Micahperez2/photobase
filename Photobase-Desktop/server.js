var randomWords = require("random-words");
var localtunnel = require("localtunnel");
var express = require("express");
var multer = require("multer");
const path = require("path");
const fs = require("fs");
const os = require("os");
var app = express();

// Require static assets from public folder
app.use(express.static(path.join(__dirname, "public")));
app.use(express.urlencoded({ extended: true }));

// Set view engine as EJS
app.engine("ejs", require("ejs").renderFile);
app.set("view engine", "ejs");
app.set("views", path.join(__dirname, "views"));


var photos = [];
var online_url = "";
var most_recent_photo = "";
var most_recent_photo_name = "";

//Get desktop path and use it for photos directory path
const homeDir = require("os").homedir();
const photobaseDir = `${homeDir}/Desktop/Photobase-Photos`;

// On default path
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
    cb(null, `${file.originalname}.jpg`);
    most_recent_photo_name = `${file.originalname}.jpg`;
  },
});

//Possible Multer Filter below
// Multer Filter
// const multerFilter = (req, file, cb) => {
//   if (file.mimetype.split("/")[1] === "jpg") {
//     cb(null, true);
//   } else {
//     cb(new Error("Not a JPG File!!"), false);
//   }
// };

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
    console.log(most_recent_photo);
    most_recent_photo = "";
    most_recent_photo = "atom://"+`${homeDir}/Desktop/Photobase-Photos/`+ `${most_recent_photo_name}`;
    console.log(most_recent_photo);

    //Redirect back home
    res.redirect('/');
  }
);


// about page
app.get("/about", function (req, res) {
  res.render("pages/about");
});

app.listen(8080, "0.0.0.0");
//  console.log('Server is listening on port 8080')

(async () => {
  var rwlist = randomWords({ exactly: 2, maxLength: 4 });
  //Example with Custom Subdomain
  const tunnel = await localtunnel({
    port: 8080,
    subdomain: `${rwlist[0]}-${rwlist[1]}`,
  });
  console.log(tunnel.url);
  online_url = tunnel.url.replace("https://", "");
  online_url = online_url.replace(".loca.lt", "");
  tunnel.on("close", () => {});
  
})();

