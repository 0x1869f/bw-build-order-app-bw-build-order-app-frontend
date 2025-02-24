@react.component
let make = (~onClose:unit => ()) => {
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

  let isDisabled = Signal.computed(() => {
    nickname -> Signal.get -> String.length === 0
    || password -> Signal.get -> String.length === 0
  })

  <Mui.Dialog open_={true} onClose={(_, _) => onClose()}>
    <Mui.DialogTitle>
      {"Login" -> React.string}
    </Mui.DialogTitle>

    <Mui.DialogContent>
      <div className="form__content">
        <div>
          <Mui.TextField
            label={"nickname *" -> React.string}
            value={nickname -> Signal.get}
            onChange={v => nickname -> Signal.set((v -> Form.stringValue).value)}
          />
        </div>

        <div>
          <Mui.TextField
            label={"password *" -> React.string}
            value={password -> Signal.get}
            onChange={v => password -> Signal.set((v -> Form.stringValue).value)}
          />
        </div>

        <div className="form__actions">
          <Mui.Button
            disabled={isDisabled -> Signal.get}
            onClick={(_) => login() -> ignore}
            variant={Contained}
          >
            {"login" -> React.string}
          </Mui.Button>

          <Mui.Button
            onClick={(_) => onClose()}
            variant={Outlined}
          >
            {"cancel" -> React.string}
          </Mui.Button>
        </div>
      </div>
    </Mui.DialogContent>
  </Mui.Dialog>
}
