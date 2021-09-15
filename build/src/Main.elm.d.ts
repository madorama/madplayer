export namespace Elm {
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
    }
  }
}