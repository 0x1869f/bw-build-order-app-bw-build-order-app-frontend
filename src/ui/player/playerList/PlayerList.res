%%raw("import './index.css'")

@react.component
let make = () => {
  Signal.track()

  let race = Signal.useSignal(Race.Protoss)
  let name = Signal.useSignal("")

  let filteredPlayers = Signal.computed(() => {
    PlayerStorage.items
      -> Signal.get
      -> Array.filter(p => {
        let playerName = name
          -> Signal.get
          -> String.toLowerCase

        switch playerName -> String.length > 0 {
          | true => p.nickname
            -> String.toLowerCase
            -> String.includes(playerName)
          | false => true
        }
        && p.race === race -> Signal.get
      })
  })

  let items = Signal.computed(() => {
    filteredPlayers
      -> Signal.get
      -> Array.map(player => <PlayerCard key={player.id} player={player} />)
  })

  <div>
    <div className="player-list__filters">
      <div>
        <Mui.InputLabel>
          {React.string("Player race")}
        </Mui.InputLabel>

        <RacePicker value={race -> Signal.get} onUpdate={r => race -> Signal.set(r)}/>
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
        onClick={(_) => name -> Signal.set("")}
        variant={Mui.Button.Outlined}
      >
        <Icon.Close.Filled />
      </Mui.Button>
    </div>

    <div className="player-list__items">
      {items -> Signal.get -> React.array}
    </div>
  </div>
}
