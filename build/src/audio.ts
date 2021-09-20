const audioPlayer = new Audio()
audioPlayer.volume = 0.5

export const play = (src: string) => {
  audioPlayer.src = src
  audioPlayer.play()
}

export const resume = () => {
  audioPlayer.play()
}

export const pause = () => {
  audioPlayer.pause()
}

export const stop = () => {
  audioPlayer.pause()
  audioPlayer.currentTime = 0
}

export const reset = () => {
  stop()
  audioPlayer.src = ""
}
