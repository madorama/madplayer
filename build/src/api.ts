import { IpcRenderer } from "./ipcWrapper"
import * as mm from "music-metadata"

interface ApiReqRes<Req, Res> {
  request: Req
  response: Res
}

interface ApiData {
  reload: ApiReqRes<void, void>
  toggleDevTools: ApiReqRes<void, void>
  minimize: ApiReqRes<void, void>
  close: ApiReqRes<void, void>
  loadAudios: ApiReqRes<
    string[],
    {
      path: string
      metadata: mm.IAudioMetadata
    }[]
  >
}

export type ApiRequest = {
  readonly [K in keyof ApiData]: ApiData[K]["request"]
}
export type ApiResponse = {
  readonly [K in keyof ApiData]: ApiData[K]["response"]
}
export type ApiChannel = keyof ApiData

export type ResponseType<K extends keyof ApiData> = ApiResponse[K] extends void ? void : Promise<ApiResponse[K]>

export type Api = {
  [K in keyof ApiData]: (req: ApiRequest[K]) => ResponseType<K>
}

export const api: Api = {
  reload: (req) => {
    IpcRenderer.invoke("reload", req)
  },

  toggleDevTools: (req) => {
    IpcRenderer.invoke("toggleDevTools", req)
  },

  minimize: (req) => {
    IpcRenderer.invoke("minimize", req)
  },

  close: (req) => {
    IpcRenderer.invoke("close", req)
  },

  loadAudios: (paths) => IpcRenderer.invoke("loadAudios", paths),
} as const
