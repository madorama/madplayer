import { BrowserWindow, app, App } from "electron"
import * as path from "path"
import * as url from "url"
import { IpcMain } from "./ipcWrapper"

class Main {
  private window: BrowserWindow | null = null
  private app: App
  private readonly mainUrl = url.format({
    pathname: path.join(__dirname, "index.html"),
    protocol: "file:"
  })

  constructor(app: App) {
    this.app = app
    this.app.on("window-all-closed", () => this.app.quit())
    this.app.on("ready", () => this.ready())
    this.app.on("activate", () => {
      if(this.window === null) this.ready()
    })
  }

  private createWindow(): BrowserWindow {
    const win = new BrowserWindow({
      width: 800,
      height: 600,
      minWidth: 640,
      minHeight: 360,
      acceptFirstMouse: true,
      titleBarStyle: "hidden",
      frame: false,
      maximizable: false,
      webPreferences: {
        nodeIntegration: false,
        nodeIntegrationInWorker: false,
        contextIsolation: true,
        nativeWindowOpen: true,
        preload: path.join(__dirname, "preload.js")
      }
    })

    win.loadURL(this.mainUrl)
    return win
  }

  private ready() {
    const win = this.createWindow()
    win.on("closed", () => {
      this.window = null;
    })

    win.setMenu(null)
    this.window = win

    IpcMain.handle("toggleDevTools", () => {
      win.webContents.isDevToolsOpened()
        ? win.webContents.closeDevTools()
        : win.webContents.openDevTools()
    })

    IpcMain.handle("reload", () => {
      win.webContents.reloadIgnoringCache()
    })

    IpcMain.handle("minimize", () => {
      win.minimize()
    })

    IpcMain.handle("close", () => {
      app.exit()
    })
  }
}

new Main(app)