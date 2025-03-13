%%raw("import './index.css'")

@react.component
let make = (~onClose: unit => ()) => {
  Signal.track()

  let newTagRace = Signal.useSignal(Race.Protoss)
  let newTagName = Signal.useSignal("")

  let tagListRace = Signal.useSignal(Race.Protoss)

  let create = async () => {
    switch await TagStorage.create({
      name: newTagName -> Signal.get,
      race: newTagRace -> Signal.get,
    }) {
      | Ok(_) => {
        MessageStore.notifyCreation(MessageStore.Tag)
        onClose()
      }
      | Error(e)=> MessageStore.notifyAppError(e, MessageStore.Tag)
    }
  }

  let isDisabled = Signal.computed(() => {
    newTagName
      -> Signal.get
      -> String.length === 0
  })

  let itemList = Signal.computed(() => {
    let tags = TagStorage.items
      -> Signal.get
      -> Map.values
      -> Iterator.toArray
      -> Array.filter((t) => t.race === tagListRace -> Signal.get)
      -> Array.map((i) => <TagListItem key={i.id} tag={i} />)

    if tags -> Array.length > 0 {
      <div className="bg-global mt-20 radius py-8">
        <div className="scrollable-container">
        {tags -> React.array}
        </div>
      </div>
    } else {
      <div />
    }
  })

  <div>
    <div className="px-32 pb-32">
      <div className="d-flex justify-space-between">
        <RaceButtonGroup
          label="Select race"
          selected={newTagRace -> Signal.get}
          onSelect={(v) => {
            newTagRace -> Signal.set(v)
          }}
        />

        <div className="tag-dialogue__new-tag-input">
          <TextField
            value={newTagName -> Signal.get}
            onChange={v => newTagName -> Signal.set(v)}
            label="Tag name"
          />
        </div>
      </div>


      <div className="d-flex gap-16 pt-32">
        <PrimaryButton
          disabled={isDisabled -> Signal.get}
          onClick={(_) => create() -> ignore}
        >
          {"Save" -> React.string}
        </PrimaryButton>

        <SecondaryButton
          disabled={newTagName -> Signal.get -> String.length === 0}
          onClick={(_) => newTagName -> Signal.set("")}
        >
          {"Cancel" -> React.string}
        </SecondaryButton>
      </div>
    </div>

    <div className="border-secondary-bottom w-full" />

    <div className="pa-32">
      <div className="d-flex justify-space-between align-center">
        <div className="text-h2 text-color-primary">
          {"Edit tags" -> React.string}
        </div>

        <RaceButtonGroup
          selected={tagListRace -> Signal.get}
          onSelect={r => tagListRace -> Signal.set(r)}
        />
      </div>

      {itemList -> Signal.get}
    </div>
  </div>
}
