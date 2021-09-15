import * as Mousetrap from "mousetrap"

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
}