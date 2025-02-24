type t = 
  | BuildOrderList 
  | NewBuildOrder 
  | ReplayList 
  | Replay(Replay.t)
  | ReplayEditor(Replay.t)
  | BuildOrderEditor(BuildOrder.t)
  | BuildOrder(BuildOrder.t) 
  | PlayerList
  | ProfileSettings

let currentRoute = Signal.useMake(BuildOrderList)

let to = (route: t) => {
  currentRoute -> Signal.set(route)
}

