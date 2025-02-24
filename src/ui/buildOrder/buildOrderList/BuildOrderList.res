%%raw("import './index.css'")

@react.component
let make = () => {
  Signal.track()

  let playerRace = Signal.useSignal(Race.Protoss)
  let opponentRace = Signal.useSignal(Race.Protoss)
  let selectedTags: Signal.t<dict<Tag.t>> = Dict.make() -> Signal.useSignal
  let name = Signal.useSignal("")

  let clear = () => {
    Dict.make() -> Signal.set(selectedTags, _)
    name -> Signal.set("")
  }

  let boList = Signal.computed(() => {
    let selected = selectedTags -> Signal.get
    let selectedCount = selected -> Dict.keysToArray -> Array.length

    BuildOrderStorage.infoList
      -> Signal.get
      -> Array.filter(
        (bo) => if bo.race === playerRace -> Signal.get && bo.opponentRace === opponentRace -> Signal.get {
          let query = name -> Signal.get 

          switch bo.name -> String.includes(query) {
            | true => {
              let matches = bo.tags -> Array.reduce(0,
                (sum, tag) => sum + switch selected -> Dict.get(tag.id) {
                  | Some(_) => 1
                  | None => 0
                })

              matches === selectedCount
            }
            | false => false
          }
        } else {
          false
        }
    )
    -> Array.map(v => {
      <BuildOrderListItem
        item={v}
        key={v.id}
      />
    })
  })

  let tags = Signal.computed(() => {
    let race1 = playerRace -> Signal.get
    let race2 = opponentRace -> Signal.get

    let tags = race1 -> TagStorage.byRace
    race1 === race2
      ? tags
      : race2
        -> TagStorage.byRace
        -> Array.concat(tags, _)
  })

  let cleanSelectedTags = () => {
    let race1 = playerRace -> Signal.get
    let race2 = opponentRace -> Signal.get

    selectedTags
      -> Signal.get
      -> Dict.toArray
      -> Array.filter((tuple) => {
        let (_, tag) = tuple
        tag.race === race1 || tag.race === race2
      })
      -> Dict.fromArray
      -> Signal.set(selectedTags, _)
  }

  <div>
    <div className="build-order-list__filters">
      <div>
        <Mui.InputLabel>
          {React.string("Player race")}
        </Mui.InputLabel>

        <RacePicker
          value={playerRace -> Signal.get}
          onUpdate={(v) => {
            playerRace -> Signal.set(v)
            cleanSelectedTags()
          }}
        />
      </div>

      <div>
        <Mui.InputLabel>
          {React.string("Opponent race")}
        </Mui.InputLabel>

        <RacePicker
          value={opponentRace -> Signal.get}
          onUpdate={(v) => {
            opponentRace -> Signal.set(v)
            cleanSelectedTags()
          }}
        />
      </div>

      <div>
        <Mui.TextField
          value={name -> Signal.get}
          onChange={v => name -> Signal.set((v -> Form.stringValue).value)}
          label={React.string("name")}
        />
      </div>

      <Mui.Button
        className="build-order-list__filters__clear"
        onClick={(_) => clear()}
        variant={Mui.Button.Outlined}
      >
        <Icon.Close.Filled />
      </Mui.Button>
    </div>

    <TagSelector
      tags={tags -> Signal.get}
      selected={selectedTags -> Signal.get}
      onUpdate={tags => selectedTags -> Signal.set(tags)}
    />

    <div className="build-order-list__items">
      {boList -> Signal.get -> React.array}
    </div>
  </div>

}
