let content: Signal.t<React.element> = Signal.useMake(<div />)
let title = Signal.useMake("")
let isShown = Signal.useMake(false)

let closePanel = () => {
  isShown -> Signal.set(false)
  content -> Signal.set(<div />)
  title -> Signal.set("")
}

let openPanel = (newContent: React.element, ~newTitle = "") => {
  content -> Signal.set(newContent)
  title -> Signal.set(newTitle)
  isShown -> Signal.set(true)
}
