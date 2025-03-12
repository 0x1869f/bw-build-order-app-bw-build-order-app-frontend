%%raw("import './index.css'")

@react.component
let make = () => {
  Signal.track()

  let playerRace = Signal.useSignal(Race.Protoss)
  let opponentRace = Signal.useSignal(Race.Protoss)
  let selectedTags: Signal.t<dict<Tag.t>> = Dict.make() -> Signal.useSignal
  let name = Signal.useSignal("")

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
      <BuildOrderCard
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

  <div className="build-order-list position-relative">
    <div className="position-absolute top-0 left-0 w-full">
      <div className="bg-primary radius d-flex gap-8 align-end">
        <div className="d-flex gap-20 border-on-light-right px-16 pt-12 pb-16">
          <RaceButtonGroup
            label="Player race"
            selected={playerRace -> Signal.get}
            onSelect={(v) => {
              playerRace -> Signal.set(v)
              cleanSelectedTags()
            }}
          />

          <RaceButtonGroup
            label="Opponent race"
            selected={opponentRace -> Signal.get}
            onSelect={(v) => {
              opponentRace -> Signal.set(v)
              cleanSelectedTags()
            }}
          />
        </div>

        <div className="px-16 pt-12 pb-16">
          <TextField
            value={name -> Signal.get}
            onChange={v => name -> Signal.set(v)}
            placeholder="Search by name"
            label="Build order"
            icon={<Lucide.Search size={20} />}
          />
        </div>
      </div>
    </div>

    <TagSelector
      tags={tags -> Signal.get}
      selected={selectedTags -> Signal.get}
      onUpdate={tags => selectedTags -> Signal.set(tags)}
    />

    <div className="pt-40">
      <div className="text-h6 text-color-primary pb-16">
        {"Build orders" -> React.string}
      </div>

      <div className="d-flex flex-wrap gap-16">
        {boList -> Signal.get -> React.array}
      </div>
    </div>
  </div>
}
