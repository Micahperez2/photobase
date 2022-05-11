var randomWords = require("random-words");
var localtunnel = require("localtunnel");
var express = require("express");
var multer = require("multer");
const path = require("path");
const fs = require("fs");
const os = require("os");
var app = express();

app.use(express.urlencoded({ extended: true }));

//Used to look for static files (css) in public folder
//app.use(express.static("public"));
// Require static assets from public folder
app.use(express.static(path.join(__dirname, "public")));

//var mostRecentDir = path.join(__dirname, '../mostRecentDir')
//var most_recent_photo = "atom://"+`${mostRecentDir}/most_recent.jpg`;

// try {
//   if (!fs.existsSync(mostRecentDir)) {
//     fs.mkdirSync(mostRecentDir);
//   }
// } catch (err) {
//   console.error(err);
// }

// set the view engine to ejs
//app.set("view engine", "ejs");
//app.set("views", __dirname);

/* Test */

// Set view engine as EJS
app.engine("ejs", require("ejs").renderFile);
app.set("view engine", "ejs");
// Set 'views' directory for any views
// being rendered res.render()
app.set("views", path.join(__dirname, "views"));

/* End of test */

var photos = [];
var online_url = "";

//Get desktop path and use it for photos directory path
const homeDir = require("os").homedir();
const photobaseDir = `${homeDir}/Desktop/Photobase-Photos`;

//const mostRecentDir = path.join(__dirname, '../mostRecentDir');
most_recent_photo = "";
var most_recent_photo_name = "";

// use res.render to load up an ejs view file
app.get("/", (req, res) => {
  //const mostRecentDir = path.join(__dirname, '../mostRecentDir');
  //most_recent_photo = "";
  //most_recent_photo = "atom://"+`${mostRecentDir}/most_recent.jpg`;

  // try {
  //   if (!fs.existsSync(mostRecentDir)) {
  //     fs.mkdirSync(mostRecentDir);
  //   }
  // } catch (err) {
  //   console.error(err);
  // }

  console.log("rerender");
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
    //cb(null, `most_recent.jpg`);
    cb(null, `${file.originalname}.jpg`);
    most_recent_photo_name = `${file.originalname}.jpg`;
  },
});

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
    //If image copy was successful than delete image saved in desktop directory
    // fs.unlink(
    //   `${mostRecentDir}/most_recent.jpg`,
    //     (err) => {
    //     if (err) {
    //         console.log("failed to delete local image:"+err);
    //     } else {
    //         console.log('successfully deleted local image');
    //     }
    //   });

    // fs.copyFile(
    //   `${homeDir}/Desktop/Photobase Photos/most_recent.jpg`,
    //   `${mostRecentDir}/most_recent.jpg`,
    //   (err) => {
    //     if (err) throw err;
    //     console.log("source.txt was copied to destination.txt");

    //     //If image copy was successful than delete image saved in desktop directory
    //     fs.unlink(
    //       `${homeDir}/Desktop/Photobase Photos/most_recent.jpg`,
    //        (err) => {
    //        if (err) {
    //            console.log("failed to delete local image:"+err);
    //        } else {
    //            console.log('successfully deleted local image');
    //        }
    //      });
    //   }
    // );
    most_recent_photo = "";
    most_recent_photo =
      "atom://" +
      `${homeDir}/Desktop/Photobase-Photos/` +
      `${most_recent_photo_name}`;
    console.log(most_recent_photo);

    res.redirect("/");
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
