const audioPlayer = new Audio()
audioPlayer.volume = 0.5

const audioContext = new AudioContext()
const analyser = audioContext.createAnalyser()
analyser.fftSize = 64
analyser.smoothingTimeConstant = 0.25
const audioSource = audioContext.createMediaElementSource(audioPlayer)
audioSource.connect(analyser)
analyser.connect(audioContext.destination)
const spectrum = new Uint8Array(analyser.frequencyBinCount)

let animId: number | null = null

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

export const visualize = (canvas: HTMLCanvasElement) => {
  const ctx = canvas.getContext("2d")

  if (ctx === null) return

  if (animId === null) {
    animId = setInterval((_) => {
      analyser.getByteFrequencyData(spectrum)
      const barNum = 32
      const barWidth = Math.round(canvas.width / barNum)
      ctx.clearRect(0, 0, canvas.width, canvas.height)
      ctx.fillStyle = "#FF8080"
      for (let i = 0; i < barNum; i += 1) {
        const avgNum = Math.round(analyser.frequencyBinCount / barNum)
        const values = spectrum.slice(i * avgNum, i * avgNum + avgNum)
        const avg = values.reduce((acc, i) => acc + i, 0) / avgNum
        const percent = avg / 255
        ctx.fillRect(barWidth * i, canvas.height, barWidth - 1, -percent * 30)
      }
    }, 1000 / 60)
  }
}
