module Form = {
  type t = {
    value: string
  }

  @get external target: ReactEvent.Form.t => t = "target"

  let value = (t: ReactEvent.Form.t) => {
    let v = t -> target

    v.value
  }
}

@react.component
let make = (~isOpened: bool, ~onClose:unit => ()) => {
  Signal.track()

  let nickname = Signal.useSignal("")
  let password = Signal.useSignal("")

  let login = async () => {
    let name = nickname -> Signal.get
    let pass = password -> Signal.get

    if name -> String.length > 0 && pass -> String.length > 0 {
      switch await UserStorage.login(name, pass) {
        | Ok() => onClose()
        | Error(_) => ()
      }
    }
  }

  <Mui.Dialog open_={isOpened} onClose={(_, _) => onClose()}>
    <Mui.DialogTitle>
      {"Login" -> React.string}
    </Mui.DialogTitle>

    <Mui.DialogContent>
      <div>
        <Mui.InputLabel id="name-input">
          {React.string("Nickname")}
        </Mui.InputLabel>
        <Mui.TextField
          value={nickname -> Signal.get}
          onChange={v => nickname -> Signal.set(v -> Form.value)}
        />
      </div>

      <div>
        <Mui.InputLabel id="name-input">
          {React.string("Password")}
        </Mui.InputLabel>
        <Mui.TextField
          value={password -> Signal.get}
          onChange={v => password -> Signal.set(v -> Form.value)}
        />
      </div>

      <Mui.Button
        onClick={(_) => login() -> ignore}
        variant={Outlined}
      >
        {"Login" -> React.string}
      </Mui.Button>
    </Mui.DialogContent>
  </Mui.Dialog>
}
