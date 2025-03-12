%%raw("import './index.css'")

@react.component
let make = () => {
  Signal.track()

  let race = Signal.useSignal(Race.Protoss)
  let opponentRace = Signal.useSignal(Race.Protoss)

  let items = Signal.computed(() => {
    ReplayStorage.items
      -> Signal.get
      -> Array.filter(rep => {
        let race = race -> Signal.get
        let secondRace = opponentRace -> Signal.get
          (rep.race === race && rep.secondRace === secondRace)
          || (rep.race === secondRace && rep.secondRace === race)
      })
      -> Array.map(rep => 
        <ReplayListItem
          key={rep.id}
          replay={rep}
      />)
  })

  <div className="replay-list">
    <div className="replay-list__filters">
      <div>
        <Mui.InputLabel>
          {React.string("Player race")}
        </Mui.InputLabel>

        <RacePicker
          value={race -> Signal.get}
          onUpdate={(v) => race -> Signal.set(v)}
        />
      </div>

      <div>
        <Mui.InputLabel>
          {React.string("Opponent race")}
        </Mui.InputLabel>

        <RacePicker
          value={opponentRace -> Signal.get}
          onUpdate={(v) => opponentRace -> Signal.set(v)}
        />
      </div>
    </div>

    <div className="replay-list__items">
      {items -> Signal.get -> React.array}
    </div>
  </div>
}
