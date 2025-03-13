type severity = Error | Warning | Success

type message = {
  severity: severity,
  title: string,
  text: string,
  id: Uuid.t,
}

type operation =
  | @as(0) Create
  | @as(1) Read
  | @as(2) Update
  | @as(3) Delete

type entity =
  | @as("build order") BuildOrder
  | @as("tag") Tag
  | @as("map") Map
  | @as("player") Player
  | @as("replay") Replay
  | @as("password") Password
  | @as("nickname") Nickname

let notify: (string, ~title: string, ~severity: severity) => unit
let errors: Signal.t<array<message>>
let notifyError: (AppError.t, ~operation: operation, ~entity: entity) => unit
let notifyOk: (~entity: entity, ~operation: operation) => unit
