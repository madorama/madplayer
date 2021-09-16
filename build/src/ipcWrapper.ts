import * as Electron from "electron"
import { ApiRequest, ApiResponse, ApiChannel, ResponseType } from "./api"

export class IpcMain {
  public static handle<T extends ApiChannel>(channel: T, listener: (event: Electron.IpcMainInvokeEvent, req: ApiRequest[T]) => ResponseType<T> ) {
    Electron.ipcMain.handle(channel, listener)
  }
}

export class IpcRenderer {
  public static invoke<T extends ApiChannel>(channel: T, req: ApiRequest[T]): Promise<ApiResponse[T]>
  {
    return Electron.ipcRenderer.invoke(channel, req)
  }
}