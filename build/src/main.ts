import { BrowserWindow, app, App } from "electron"
import * as path from "path"
import * as url from "url"
import { IpcMain } from "./ipcWrapper"
import * as mm from "music-metadata"
import * as filetype from "file-type"
import * as readdirp from "readdirp"
import * as fs from "fs"

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

    IpcMain.handle("loadAudios", async (_, paths) => {
      const test = async (filePath: string) => {
        const ft = await filetype.fromFile(filePath)
        return ft !== undefined && ft.mime.startsWith("audio")
      }

      const files = (await Promise.all(paths.map(async p => {
        const stat = fs.statSync(p)
        if(stat.isDirectory()) {
          const files = await readdirp.promise(p)
          return await Promise.all(files.map(f => test(f.fullPath))).then(res => files.filter((_, i) => res[i]).map(f => f.fullPath))
        }
        return (await test(p)) ? [p] : []
      }))).flat()

      return Promise.all(
        files
        .map(async filePath => {
          const metadata = await mm.parseFile(filePath)
          return {
            path: filePath,
            metadata,
          }
        })
      )
    })
  }
}

new Main(app)