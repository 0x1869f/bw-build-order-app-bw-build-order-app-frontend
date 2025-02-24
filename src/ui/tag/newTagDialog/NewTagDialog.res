@react.component
let make = (~onClose: unit => ()) => {
  Signal.track()

  let race = Signal.useSignal(Race.Protoss)
  let name = Signal.useSignal("")

  let create = async () => {
    switch await TagStorage.create({
      name: name -> Signal.get,
      race: race -> Signal.get,
    }) {
      | Ok(_) => {
        MessageStore.notifyCreation(MessageStore.Tag)
        onClose()
      }
      | Error(e)=> MessageStore.notifyAppError(e, MessageStore.Tag)
    }
  }

  let isDisabled = Signal.computed(() => {
    name
      -> Signal.get
      -> String.length === 0
  })

  <Mui.Dialog open_={true} onClose={(_, _) => onClose()}>
    <Mui.DialogTitle>
      {"New tag" -> React.string}
    </Mui.DialogTitle>

    <Mui.DialogContent>
      <div className="form__content">
        <RacePicker value={race -> Signal.get} onUpdate={(v) => race -> Signal.set(v)} />

        <div>
          <Mui.TextField
            value={name -> Signal.get}
            onChange={v => name -> Signal.set((v -> Form.stringValue).value)}
            label={"name *" -> React.string}
          />
        </div>

        <div className="form__actions">
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
