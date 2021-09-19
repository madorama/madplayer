export namespace Elm {
  export type Music = {
    readonly path: string,
    readonly duration: number,
    readonly rawMetadata: RawMetadata
  }

  export type RawMetadata = {
    readonly tagType: string,
    readonly metadata: Metadata,
    readonly rawData: RawData[]
  }

  export type Metadata = {
    readonly title: string | null,
    readonly artist: string | null,
    readonly genres: string[],
    readonly comment: string | null,
    readonly bpm: number | null,
  }

  export type RawData = {
    readonly id: string,
    readonly value: string
  }

  namespace Main {
    interface Flags {
    }

    export function init(options: {
      node?: HTMLElement | null;
      flags: Flags
    }): App;

    interface Subscribe<T> {
      subscribe(callback: (value: T) => any): void;
    }

    interface Send<T> {
      send(value: T): void
    }

    interface App {
      ports: Ports;
    }

    interface Ports {
      minimize: Subscribe<void>,
      close: Subscribe<void>,
      loadMusic: Send<Music>,
      playMusic: Subscribe<string>,
      resumeMusic: Subscribe<void>
      pauseMusic: Subscribe<void>,
    }
  }
}