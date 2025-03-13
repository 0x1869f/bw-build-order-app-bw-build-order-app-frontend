@react.component
let make = (
  ~onClose:unit => ()
) => {
  Signal.track()

  let name = Signal.useSignal("")
  let password = Signal.useSignal("")

  let login = async () => {
    let name = name -> Signal.get
    let pass = password -> Signal.get

    if name -> String.length > 0 && pass -> String.length > 0 {
      switch await UserStorage.login(name, pass) {
        | Ok() => onClose()
        | Error(_) => ()
      }
    }
  }

  let isDisabled = Signal.computed(() => {
    name -> Signal.get -> String.length === 0
    || password -> Signal.get -> String.length === 0
  })

  <div className="px-32">
      <TextField
        label="Account name"
        value={name -> Signal.get}
        onChange={v => name -> Signal.set(v)}
      />

    <div className="pt-32">
      <TextField
        label="Password"
        value={password -> Signal.get}
        onChange={v => password -> Signal.set(v)}
        type_="password"
      />
    </div>

    <div className="pt-32">
      <PrimaryButton
        disabled={isDisabled -> Signal.get}
        onClick={(_) => login() -> ignore}
      >
        {"Log in" -> React.string}
      </PrimaryButton>
    </div>
  </div>
}
