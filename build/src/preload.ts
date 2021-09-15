import { contextBridge } from "electron"
import { Api, api } from "./api"
import { Elm } from "./Main.elm"

contextBridge.exposeInMainWorld("api", api)

declare global {
  interface Window {
    api: Api
    ports: (app: Elm.Main.App) => void
  }
}