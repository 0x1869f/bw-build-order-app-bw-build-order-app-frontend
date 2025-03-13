%%raw("import './index.css'")

@send external clickInput: Dom.element => unit = "click"

@react.component
let make = (~onClose: unit => ()) => {
  Signal.track()

  let avatar: Signal.t<option<Webapi.File.t>> = Signal.useSignal(None)
  let race = Signal.useSignal(Race.Protoss)
  let nickname = Signal.useSignal("")
  let twitch = Signal.useSignal("")
  let soop = Signal.useSignal("")
  let liquipedia = Signal.useSignal("")
  let youtube = Signal.useSignal("")

  let isDisabled = Signal.computed(() => {
    nickname
      -> Signal.get
      -> String.length === 0
  })

  let create = async () => {
    if nickname -> Signal.get -> String.length > 0 {
      let twitch = twitch -> Signal.get
      let soop = soop -> Signal.get
      let liquipedia = liquipedia -> Signal.get
      let youtube = youtube -> Signal.get

      switch await PlayerStorage.create({
        nickname: nickname -> Signal.get,
        race: race -> Signal.get,
        twitch: twitch -> String.length > 0
          ? Some(twitch)
          : None,
        soop: soop -> String.length > 0
          ? Some(soop)
          : None,
        liquipedia: liquipedia -> String.length > 0
          ? Some(liquipedia)
          : None,
        youtube: youtube -> String.length > 0
          ? Some(youtube)
          : None,
      }, avatar -> Signal.get) {
        | Ok() => {
          MessageStore.notifyOk(~entity=MessageStore.Player, ~operation=Create)
          onClose()
        }
        | Error(e) => MessageStore.notifyError(e, ~entity=MessageStore.Player, ~operation=Create)
      }
    }
  }

  let onFileChange = (form: FileForm.form) => {
    form.files
      -> Array.get(0)
      -> Signal.set(avatar, _)
  }

  <Mui.Dialog open_={true} onClose={(_, _) => onClose()}>
    <Mui.DialogTitle>
      {"New player" -> React.string}
    </Mui.DialogTitle>

    <Mui.DialogContent>
      <div className="new-player-dialog__form">
        <RacePicker value={race -> Signal.get} onUpdate={(v) => race -> Signal.set(v)} />

        <Mui.TextField
          value={nickname -> Signal.get}
          onChange={v => nickname -> Signal.set((v -> Form.stringValue).value)}
          label={"nickname *" -> React.string}
        />

        <Mui.TextField
          value={twitch -> Signal.get}
          onChange={v => twitch -> Signal.set((v -> Form.stringValue).value)}
          label={"twitch" -> React.string}
        />

        <Mui.TextField
          value={soop -> Signal.get}
          onChange={v => soop -> Signal.set((v -> Form.stringValue).value)}
          label={"soop" -> React.string}
        />

        <Mui.TextField
          value={youtube -> Signal.get}
          onChange={v => youtube -> Signal.set((v -> Form.stringValue).value)}
          label={"youtube" -> React.string}
        />

        <Mui.TextField
          value={liquipedia -> Signal.get}
          onChange={v => liquipedia -> Signal.set((v -> Form.stringValue).value)}
          label={"liquipedia" -> React.string}
        />

        <div>
          <FileInput
            text="upload avatar"
            accept=".jpg,.jpeg,.png"
            onFileChange={onFileChange}
          />
        </div>

        <div className="new-player-dialog__actions">
          <Mui.Button
            disabled={isDisabled -> Signal.get}
            onClick={(_) => create() -> ignore}
            variant={Contained}
          >
            {"create" -> React.string}
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
