type severity = Error | Warning | Success

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

let notify = (text: string, ~title: string, ~severity: severity) => {
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

type operation =
  | @as(0) Create
  | @as(1) Read
  | @as(2) Update
  | @as(3) Delete

let notifyError = (
  error: AppError.t,
  ~operation: operation,
  ~entity: entity,
) => {
  switch error {
    | InvalidData(e) => notify(e, ~severity=Error, ~title="invalid input")
    | Unauthorized => notify("Authorization is required", ~severity=Error, ~title="access error")
    | DocumentDoesNotExist => notify("This page does not exist", ~severity=Error, ~title="access error")
    | Conflict => {
      switch operation {
        | Delete =>  notify(`some entities depend on this ${entity :> string}`, ~severity=Error, ~title="conflict")
        | _ =>  notify(`${entity :> string} already exists`, ~severity=Error, ~title="conflict")
      }
    }
    | _ => notify("the application cannot execute this request", ~severity=Error, ~title="server error")
  }
}

let notifyOk = (~entity: entity, ~operation: operation) => {
  switch operation {
    | Create => `${entity :> string} was successfully added`
    | Update => `${entity :> string} was successfully updated`
    | Delete => `${entity :> string} was successfully deleted`
    | Read => `${entity :> string} was successfully received`
  }
  -> notify(~severity=Success, ~title="success")
}
