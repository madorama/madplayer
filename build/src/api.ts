import { IpcRenderer } from "./ipcWrapper"

interface ApiReqRes<Req, Res> {
  request: Req,
  response: Res,
}

interface ApiData {
  reload: ApiReqRes<void, void>
  toggleDevTools: ApiReqRes<void, void>
  minimize: ApiReqRes<void, void>
  close: ApiReqRes<void, void>
}

export type ApiRequest = { readonly [K in keyof ApiData]: ApiData[K]["request"] }
export type ApiResponse = { readonly [K in keyof ApiData]: ApiData[K]["response"] }
export type ApiChannel = keyof ApiData

export type Api = { [K in keyof ApiData]: (req: ApiRequest[K]) => void }

export const api: Api = {
  reload: req => {
    IpcRenderer.invoke("reload", req)
  },

  toggleDevTools: req => {
    IpcRenderer.invoke("toggleDevTools", req)
  },

  minimize: req => {
    IpcRenderer.invoke("minimize", req)
  },

  close: req => {
    IpcRenderer.invoke("close", req)
  },
} as const