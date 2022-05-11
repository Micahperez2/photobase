const { app, BrowserWindow, ipcMain, dialog, protocol, webContents } = require("electron");
const path = require("path");
const fs = require("fs");
const server = require("./server");

/* Creating custom File://-like protocol */
app.whenReady ().then(() => {
  protocol.registerFileProtocol('atom', (request, callback) => {
    const url = request.url.substr(7)
    callback({ path: path.normalize(`${url}`) })
  })
})

protocol.registerSchemesAsPrivileged([
  { scheme: 'atom', privileges: { bypassCSP: true } }
])

//Create app window with min/max size
function createWindow() {
  const mainWindow = new BrowserWindow({
    width: 600,
    height: 750,
    maxWidth: 875,
    maxHeight: 875,
    minHeight: 600,
    minWidth: 350,
    icon: path.join(__dirname, "public/test.ico"),
    title: "Photobase",
    webPreferences: {
      nodeIntegration: true,
      contextIsolation: false,
      enableRemoteModule: true,
    },
  });

  if (process.platform === "darwin") {
    app.dock.setIcon(path.join(__dirname, "public/Photobase-Icon-512.jpg"));
  }

  //Have application icon bounce on click
  setTimeout(() => {
    app.dock.bounce();
  }, 5000);

  //Load express server
  mainWindow.loadURL("http://localhost:8080");
}

//Run function above when ready
app.whenReady().then(createWindow);

app.on("resize", function (e, x, y) {
  mainWindow.setSize(x, y);
});

//If not on mac, close the window on x
app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit()
  }
})

app.on('activate', () => {
  if (BrowserWindow.getAllWindows().length === 0) {
    createWindow()
  }
})
