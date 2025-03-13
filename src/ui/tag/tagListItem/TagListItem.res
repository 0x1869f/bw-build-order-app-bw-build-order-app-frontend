%%raw("import './index.css'")

@send external focus: Dom.element => unit = "focus"

@react.component
let make = (
  ~tag: Tag.t
) => {
  Signal.track()

  let isChange = Signal.useSignal(false)
  let updatedName = Signal.useSignal(tag.name)

  let raceIcon = tag.race -> RaceIconStorage.getByRace

  let dropEdition = () => {
    isChange -> Signal.set(false)
    updatedName -> Signal.set(tag.name)
  }

  let update = async () => {
    switch await TagStorage.update(tag.id, ~name=updatedName -> Signal.get) {
      | Ok() => {
        MessageStore.notifyOk(~entity=MessageStore.Tag, ~operation=Update)
        isChange -> Signal.set(false)
      }
      | Error(e) => MessageStore.notifyError(e, ~entity=MessageStore.Tag, ~operation=Update)
    }
  }

  let delete = async () => {
    switch await TagStorage.delete(tag.id) {
      | Ok() => MessageStore.notifyOk(~entity=MessageStore.Tag, ~operation=Delete)
      | Error(e) => MessageStore.notifyError(e, ~entity=MessageStore.Tag, ~operation=Delete)
    }
  }

  let actions = Signal.computed(() => {
    switch isChange -> Signal.get {
      | true => {
        <div>
          <IconButton
            disabled={updatedName -> Signal.get === tag.name}
            onClick={_ => update() -> ignore}
          >
            <Lucide.Check size={16} />
          </IconButton>

          <IconButton onClick={_ => dropEdition()}>
            <Lucide.X size={16} />
          </IconButton>
        </div>
      }
      | false => {
        <div className="tag-list-item__icons d-flex">
          <IconButton onClick={_ => isChange -> Signal.set(true)}>
            <Lucide.Pencil size={16} />
          </IconButton>

          <IconButton onClick={_ => delete() -> ignore}>
            <Lucide.Trash size={16} />
          </IconButton>
        </div>
      }
    }
  })

  let nameToDisplay = Signal.computed(() => {
    switch isChange -> Signal.get {
      | true => <input
        className="tag-list-item__input text-body-small text-color-primary"
        value={updatedName -> Signal.get}
        onChange={v => (v -> Form.stringValue).value -> Signal.set(updatedName, _)}
        autoFocus={true}
      />
      | false => tag.name -> React.string
    }
  })

  <div className="tag-list-item d-flex align-center pa-4 h-40 border-box">
    <div className="pa-8">
      <img src={raceIcon} className="h-16 w-16" />
    </div>

    <div className="text-body-small text-color-primary flex-grow-1">
      {nameToDisplay -> Signal.get}
    </div>

    <div className="tag-list-item__actions flex-grow-0">
      {actions -> Signal.get}
    </div>
  </div>
}
