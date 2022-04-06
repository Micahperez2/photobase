const { app, BrowserWindow, ipcMain, dialog } = require("electron");
const path = require("path");
const fs = require("fs");
//const server = require("./app");
const server = require("./server");

async function handleFileOpen() {
  const { canceled, filePaths } = await dialog.showOpenDialog();
  if (canceled) {
    return;
  } else {
    return filePaths[0];
  }
}

async function saveFile() {
  let data = "This is a file containing a collection of books.";

  fs.writeFile(
    "/Users/micahperez/Documents/Practice/photobase/desktop/books.txt",
    data,
    (err) => {
      if (err) console.log(err);
      else {
        console.log("File written successfully\n");
        console.log("The written has the following contents:");
        console.log(fs.readFileSync("books.txt", "utf8"));
      }
    }
  );
}

function createWindow() {
  const mainWindow = new BrowserWindow({
    width: 600,
    height: 750,
    icon: path.join(__dirname, "public/test.ico"),
    title: "Photobase",
    webPreferences: {
      nodeIntegration: true,
      contextIsolation: false,
      enableRemoteModule: true,
    },
  });

  if (process.platform === "darwin") {
    app.dock.setIcon(path.join(__dirname, "public/Photobase-Icon.png"));
  }

  setTimeout(() => {
    app.dock.bounce();
  }, 5000);

  mainWindow.loadURL("http://localhost:8080");
}

//app.on("ready", createWindow);
app.whenReady().then(createWindow);

app.on("resize", function (e, x, y) {
  mainWindow.setSize(x, y);
});

app.on("window-all-closed", function () {
  if (process.platform !== "darwin") {
    app.quit();
  }
});
