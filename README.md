# Photobase
## _Stop Worrying About Image Storage or Cloud Fees_

[![Actions Status](https://github.com/Micahperez2/photobase/actions/workflows/format.yml/badge.svg)](https://github.com/Micahperez2/photobase/actions)

![alt text](https://github.com/Micahperez2/photobase/blob/main/Photobase-Icon-x120.png?raw=true)

Photobase is application that allows users to dynamically take photos on an iOS device and save them to a remote desktop. If the desktop server isn't curently avaibale, Photobase enables its users to store them temporarily and then send them when they're ready. Photobase was created so users can stop worrying about running out of mobile storage and overpaying for cloud fees.

## Features

- Download both the Photobase Desktop and iOS Application
- Take photos via the iOS application
    - If currently connected to Desktop server via passcode, photos will send as they are taken and will not be stored in iOS storage
    - If not connected, photos will be cached in application until connected to a desktop server
- When a photo reaches the server for the first time, a new desktop folder will be created named "Photobase Photos"
- Images will be saved to this folder based off when they were taken on the mobile device


## Tech

Photobase uses a number of tools and technologies to work properly:

- [Node](https://nodejs.org/en/) - evented I/O for the backend using js
- [Express](https://expressjs.com/) - fast Node.js web framework
- [Electron](https://www.electronjs.org/) - js framework built to create desktop apps
- [Swift](https://developer.apple.com/swift/) - programing language for software specific to apple based products
- [Dillinger](https://dillinger.io/) - online markdown editor
- [Github Actions](https://github.com/features/actions) - workflow automation built into github

## Installation

Photobase Desktop requires [Node.js](https://nodejs.org/) v10+ to run.

Clone the repository down to your local machine.

```sh
git clone https://github.com/Micahperez2/photobase.git
```

Install the dependencies and devDependencies and start the server.

```sh
cd photobase/Photobase-Desktop
npm i
npm start
```

Photobase iOS currently requires [Xcode](https://developer.apple.com/xcode/) to download and run. After cloning the repository, open the iOS code in Xcode and install on an iOS device.
