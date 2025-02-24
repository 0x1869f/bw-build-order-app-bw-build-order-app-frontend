let boToBoItem = (bo: BuildOrder.Info.t) => 
  <Mui.MenuItem key={bo.id}
    value={bo.id}
  >
    {bo.name -> React.string}
  </Mui.MenuItem>

let playerToPlayerItem = (player: Player.t) => 
  <Mui.MenuItem
    key={player.id}
    value={player.id}
  >
    {player.nickname -> React.string}
  </Mui.MenuItem>

@react.component
let make = (~onClose: unit => ()) => {
  Signal.track()

  let description = Signal.useSignal("")

  let race = Signal.useSignal(Race.Protoss)
  let secondRace = Signal.useSignal(Race.Protoss)

  let buildOrder: Signal.t<option<Id.t>> = Signal.useSignal(None)
  let secondBuildOrder: Signal.t<option<Id.t>> = Signal.useSignal(None)

  let player: Signal.t<option<Id.t>> = Signal.useSignal(None)
  let secondPlayer: Signal.t<option<Id.t>> = Signal.useSignal(None)

  let map: Signal.t<option<Id.t>> = Signal.useSignal(None)
  let replay: Signal.t<option<Webapi.File.t>> = Signal.useSignal(None)

  let buildOrderItems = Signal.computed(() => {
    BuildOrderStorage.infoList
      -> Signal.get
      -> Array.filter(bo => bo.race === race -> Signal.get && bo.opponentRace === secondRace -> Signal.get)
      -> Array.map(boToBoItem)
  })

  let secondBuildOrderItems = Signal.computed(() => {
    BuildOrderStorage.infoList
      -> Signal.get
      -> Array.filter(bo => bo.race === secondRace -> Signal.get && bo.opponentRace === race -> Signal.get)
      -> Array.map(boToBoItem)
  })

  let playerItems = Signal.computed(() => {
    PlayerStorage.items
      -> Signal.get
      -> Array.filter(p => race -> Signal.get === p.race)
      -> Array.map(playerToPlayerItem)
  })

  let secondPlayerItems = Signal.computed(() => {
    PlayerStorage.items
      -> Signal.get
      -> Array.filter(p => secondRace -> Signal.get === p.race)
      -> Array.map(playerToPlayerItem)
  })

  let mapItems = Signal.computed(() => {
    MapStorage.items
      -> Signal.get
      -> Array.map(map => 
        <Mui.MenuItem
          key={map.id}
          value={map.id}
        >
          {map.name -> React.string}
        </Mui.MenuItem>)
  })

  let isDisabled = Signal.computed(() => {
    [player, buildOrder, map]
      -> Array.some(e => e -> Signal.get -> Option.isNone)
      || replay -> Signal.get -> Option.isNone
  })

  let onRaceChange = (r: Race.t) => {
    race -> Signal.set(r)
    player -> Signal.set(None)
    buildOrder -> Signal.set(None)
  }

  let onSecondRaceChange = (r: Race.t) => {
    secondRace -> Signal.set(r)
    secondPlayer -> Signal.set(None)
    secondBuildOrder -> Signal.set(None)
  }

  let onFileChange = (form: FileForm.form) => {
    form.files
      -> Array.get(0) 
      -> Signal.set(replay, _)
  }

  let create = async () => {
    let desc = description -> Signal.get
    switch await ReplayRepository.create({
      description: desc -> String.length > 0
        ? Some(desc)
        : None
      ,
      map: map -> Signal.get -> Option.getUnsafe,
      player: player -> Signal.get -> Option.getUnsafe, 
      race: race -> Signal.get,
      buildOrder: buildOrder -> Signal.get -> Option.getUnsafe,
      secondPlayer: secondPlayer -> Signal.get,
      secondRace: secondRace -> Signal.get,
      secondBuildOrder: secondBuildOrder -> Signal.get,
    },
      replay -> Signal.get -> Option.getUnsafe
    ) {
      | Ok(_)=> {
        MessageStore.notifyCreation(MessageStore.Replay)
        onClose()
      }
      | Error(e)=> MessageStore.notifyAppError(e, MessageStore.Replay)
    }
  }

  <Mui.Dialog open_={true} onClose={(_, _) => onClose()}>
    <Mui.DialogTitle>
      {"New replay" -> React.string}
    </Mui.DialogTitle>

    <Mui.DialogContent>
      <div className="form__content">
        <RacePicker
          value={race -> Signal.get}
          onUpdate={onRaceChange}
        />

        <RacePicker
          value={secondRace -> Signal.get}
          onUpdate={onSecondRaceChange}
        />

        <div>
          <Mui.TextField
            value={description -> Signal.get}
            multiline={true}
            minRows={3}
            maxRows={3}
            onChange={v => description -> Signal.set((v -> Form.stringValue).value)}
            label={"description" -> React.string}
          />
        </div>

        <div className="form__item">
          <Mui.InputLabel id="new-replay-dialog-player">
            {"player *" -> React.string}
          </Mui.InputLabel>

          <Mui.Select
            style={ReactDOM.Style.make(~width="100%", ())}
            labelId="new-replay-dialog-player"
            value={player -> Signal.get -> Option.getOr("")}
            onChange={(event, _) => {(event -> Form.stringValue).value -> Some -> Signal.set(player, _)}}
          >
            {playerItems -> Signal.get -> React.array}
          </Mui.Select>
        </div>

        <div>
          <Mui.InputLabel id="new-replay-dialog-build-order">
            {"build order *" -> React.string}
          </Mui.InputLabel>
          <Mui.Select
            style={ReactDOM.Style.make(~width="100%", ())}
            labelId="new-replay-dialog-build-order"
            value={buildOrder -> Signal.get -> Option.getOr("")}
            onChange={(event, _) => {(event -> Form.stringValue).value -> Some -> Signal.set(buildOrder, _)}}
          >
            {buildOrderItems -> Signal.get -> React.array}
          </Mui.Select>
        </div>

        <div>
          <Mui.InputLabel id="new-replay-dialog-second-player">
            {"second player" -> React.string}
          </Mui.InputLabel>
          <Mui.Select
            style={ReactDOM.Style.make(~width="100%", ())}
            labelId="new-replay-dialog-second-player"
            value={secondPlayer -> Signal.get -> Option.getOr("")}
            onChange={(event, _) => {(event -> Form.stringValue).value -> Some -> Signal.set(secondPlayer, _)}}
          >
            {secondPlayerItems -> Signal.get -> React.array}
          </Mui.Select>
        </div>

        <div>
          <Mui.InputLabel id="new-replay-dialog-second-build-order">
            {"second build order" -> React.string}
          </Mui.InputLabel>
          <Mui.Select
            style={ReactDOM.Style.make(~width="100%", ())}
            labelId="new-replay-dialog-second-build-order"
            value={secondBuildOrder -> Signal.get -> Option.getOr("")}
            onChange={(event, _) => {(event -> Form.stringValue).value -> Some -> Signal.set(secondBuildOrder, _)}}
          >
            {secondBuildOrderItems -> Signal.get -> React.array}
          </Mui.Select>
        </div>

        <div>
          <Mui.InputLabel id="new-replay-dialog-map">
            {"map *" -> React.string}
          </Mui.InputLabel>
          <Mui.Select
            style={ReactDOM.Style.make(~width="100%", ())}
            labelId="new-replay-dialog-map"
            value={map -> Signal.get -> Option.getOr("")}
            onChange={(event, _) => {(event -> Form.stringValue).value -> Some -> Signal.set(map, _)}}
          >
            {mapItems -> Signal.get -> React.array}
          </Mui.Select>
        </div>

        <div>
          <FileInput
            onFileChange={onFileChange}
            text="upload replay *"
            accept=".rep"
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
