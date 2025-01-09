%%raw("import './BuildOrderList.css'")

module TagForm = {
  type t = {
    value: array<Tag.t>
  }

  @get external target: ReactEvent.Form.t => t = "target"
}

module NameForm = {
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
let make = () => {
  Signal.track()

  let playerRace = Signal.useSignal(Race.Protoss)
  let opponentRace = Signal.useSignal(Race.Protoss)
  let selectedTags = Signal.useSignal([])
  let name = Signal.useSignal("")

  let clear = () => {
    selectedTags -> Signal.set([])
    name -> Signal.set("")
  }

  let list = Signal.computed(() => {
    BuildOrderStorage.infoList -> Signal.get -> Array.map(v => {
      <BuildOrderInfoItem item={v} />
    })
  })

  let setTags = (target: TagForm.t) => selectedTags -> Signal.set(target.value)
  

  let getItemStyle = (tag: Tag.t) => selectedTags -> Signal.get -> Array.find((v) => v.name === tag.name) -> Option.isSome
    ? "build-order-list__filters__tag-selector__item_selected"
    : ""

  let tagSelector = Signal.computed(() => {
    <div>
      <Mui.InputLabel id="tag-selector">
        {React.string("Tag")}
      </Mui.InputLabel>

      <Mui.Select
        className="build-order-list__filters__tag-selector"
        labelId="tag-selector"
        id="demo-multiple-name"
        multiple={true}
        value={selectedTags -> Signal.get}
        onChange={(t, _) => setTags(t -> TagForm.target)}
      >
        {TagStorage.getItems -> Signal.get -> Array.map((tag) => (
          <Mui.MenuItem
            key={tag.name}
            value={tag}
            className={getItemStyle(tag)}
          >
            {React.string(tag.name)}
          </Mui.MenuItem>
        )) -> React.array}
      </Mui.Select>
    </div>
  })

  let searchQuery = Signal.computed(() => {
    <div>
      <Mui.InputLabel id="name-input">
        {React.string("Name")}
      </Mui.InputLabel>
      <Mui.TextField
        value={name -> Signal.get}
        onChange={v => name -> Signal.set(v -> NameForm.value)}
      />
    </div>
  })

  <div className="build-order-list__filters">
    <div>
      <Mui.InputLabel>
        {React.string("Player race")}
      </Mui.InputLabel>

      <RacePicker value={playerRace} onUpdate={(v) => playerRace -> Signal.set(v)}/>
    </div>

    <div>
      <Mui.InputLabel>
        {React.string("Opponent race")}
      </Mui.InputLabel>

      <RacePicker value={opponentRace} onUpdate={(v) => opponentRace -> Signal.set(v)}/>
    </div>

    <div>{tagSelector -> Signal.get}</div>

    <div>{searchQuery -> Signal.get}</div>

    <Mui.Button
      className="build-order-list__filters__clear"
      onClick={(_) => clear()}
      variant={Mui.Button.Outlined}
    >
      <Lucide.X />
    </Mui.Button>

    <div>{list -> Signal.get -> React.array}</div>
  </div>
}
