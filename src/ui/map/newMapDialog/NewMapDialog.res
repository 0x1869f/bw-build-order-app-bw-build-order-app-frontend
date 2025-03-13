@react.component
let make = (~onClose: unit => ()) => {
  Signal.track()

  let name = Signal.useSignal("")
  let image: Signal.t<option<Webapi.File.t>> = Signal.useSignal(None)

  let isDisabled = Signal.computed(() => {
    name
      -> Signal.get
      -> String.length < 5
  })

  let create = async () => {
    if name -> Signal.get -> String.length > 0 {

      switch await MapStorage.create({
        name: name -> Signal.get,
      }, image -> Signal.get) {
        | Ok(_) => {
          MessageStore.notifyOk(~entity=MessageStore.Map, ~operation=Create)
          onClose()      
        }
        | Error(e) => MessageStore.notifyError(e, ~entity=MessageStore.Map, ~operation=Create)
      }
    }
  }

  let onFileChange = (form: FileForm.form) => {
    form.files
      -> Array.get(0)
      -> Signal.set(image, _)
  }

  <Mui.Dialog open_={true} onClose={(_, _) => onClose()}>
    <Mui.DialogTitle>
      {"New map" -> React.string}
    </Mui.DialogTitle>

    <Mui.DialogContent>
      <div className="form__content">
        <div>
          <Mui.TextField
            value={name -> Signal.get}
            onChange={v => name -> Signal.set((v -> Form.stringValue).value)}
            label={"name *" -> React.string}
          />
        </div>

        <div>
          <FileInput
            text="upload image"
            onFileChange={onFileChange}
            accept=".jpg,.jpeg,.png"
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
