import * as Mousetrap from "mousetrap"
import { Elm } from "./Main.elm"

Mousetrap.bind("ctrl+r", function() {
  window.api.reload()
})

Mousetrap.bind("ctrl+shift+i", function() {
  window.api.toggleDevTools()
})

window.ports = elm => {
  elm.ports.minimize.subscribe(() => {
    window.api.minimize()
  })

  elm.ports.close.subscribe(() => {
    window.api.close()
  })

  document.ondrop = document.ondragover = e => {
    e.preventDefault()
    return false
  }

  document.body.ondrop = e => {
    if(e.dataTransfer === null) return

    const paths =
      Array
      .from(e.dataTransfer.files)
      .map(file => file.path)

    window.api.loadAudios(paths).then(xs => {
      for(const data of xs) {
        const metadata = data.metadata
        const tagType = metadata.format.tagTypes![0]
        let rawData: Elm.RawData[] = []

        if(tagType === "exif") {
          rawData = metadata.native.exif
        } else if(tagType === "vorbis") {
          rawData = metadata.native.vorbis
        }

        const rawMetadata: Elm.RawMetadata = {
          tagType,
          metadata: {
            title: metadata.common?.title || null,
            artist: metadata.common?.artist || null,
            genres: metadata.common.genre || [],
            comment: metadata.common.comment?.shift() || null,
            bpm: Number(metadata.common.bpm) || null
          },
          rawData,
        }

        const music = {
          path: data.path,
          duration: metadata.format.duration!,
          rawMetadata
        }

        elm.ports.loadMusic.send(music)
      }
    })
  }
}