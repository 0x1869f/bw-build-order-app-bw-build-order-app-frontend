type severity = Mui.Alert.severity

type message = {
  severity: severity,
  title: string,
  text: string,
  id: Uuid.t,
}

let errors: Signal.t<array<message>> = Signal.useMake([])

let clean = (id: Uuid.t) => setTimeout(() => {
  errors
  -> Signal.get
  -> Array.filter((m) => m.id !== id)
  -> Signal.set(errors, _)
}, 3000)

let notify = (severity: severity, text: string, ~title: string) => {
  let id = Uuid.make()
  [ ...errors -> Signal.get, { text, title, severity, id} ]
    -> Signal.set(errors, _)

  clean(id) -> ignore
}

type entity =
  | @as("build order") BuildOrder
  | @as("tag") Tag
  | @as("map") Map
  | @as("player") Player
  | @as("replay") Replay
  | @as("password") Password
  | @as("nickname") Nickname

let notifyAppError = (error: AppError.t, entity: entity) => {
  switch error {
    | InvalidData(e) => notify(Error, e, ~title="invalid input")
    | Unauthorized => notify(Error, "Authorization is required", ~title="access error")
    | DocumentDoesNotExist => notify(Error, "This page does not exist", ~title="access error")
    | Conflict => notify(Error, `${entity :> string} already exists`, ~title="conflict")
    | _ => notify(Error, "the application cannot execute this request", ~title="server error")
  }
}

let notifyCreation = (entity: entity) => {
  notify(Success, `${entity :> string} was successfully added`, ~title="success")
}

let notifyUpdate = (entity: entity) => {
  notify(Success, `${entity :> string} was successfully updated`, ~title="success")
}
