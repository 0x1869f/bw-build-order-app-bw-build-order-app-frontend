type severity = Mui.Alert.severity

type message = {
  severity: severity,
  title: string,
  text: string,
  id: Uuid.t,
}

type entity =
  | @as("build order") BuildOrder
  | @as("tag") Tag
  | @as("map") Map
  | @as("player") Player
  | @as("replay") Replay
  | @as("password") Password
  | @as("nickname") Nickname

let notify: (severity, string, ~title: string) => unit
let errors: Signal.t<array<message>>
let notifyAppError: (AppError.t, entity) => unit
let notifyCreation: (entity) => unit
let notifyUpdate: (entity) => unit
