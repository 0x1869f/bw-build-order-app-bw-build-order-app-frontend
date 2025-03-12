%%raw("import './index.css'")

@react.component
let make = (~replay: Replay.t) => {
  let (player, icon) = switch PlayerStorage.itemsDict -> Signal.get -> Dict.get(replay.player) {
    | Some(p) => (p.nickname, p.avatar -> Option.getOr(replay.race -> RaceIconStorage.getByRace))
    | None => ("Unknown", replay.race -> RaceIconStorage.getByRace)
  }

  let (secondPlayer, secondPlayerIcon) = switch replay.secondPlayer {
    | Some(player) => switch PlayerStorage.itemsDict -> Signal.get -> Dict.get(player) {
      | Some(p) => Some((p.nickname, p.avatar -> Option.getOr(replay.secondRace -> RaceIconStorage.getByRace)))
      | None => None
    }
    | None => None
  } -> Option.getOr(("Unknown", replay.secondRace -> RaceIconStorage.getByRace))


  let gameMap = MapStorage.itemsDict
    -> Signal.get
    -> Dict.getUnsafe(replay.map) 

  let downloadLink = () => {
    switch replay.file {
      | Some(link) => {
        let firstRace = replay.race -> Race.firstLetter
        let secondRace = replay.secondRace -> Race.firstLetter
        let name = `${player}(${firstRace})_vs_${secondPlayer}(${secondRace})_${gameMap.name}.rep`
          <Mui.CardActions className="replay-list-item__actions">
            <Mui.IconButton onClick={(e) => e -> ReactEvent.Mouse.stopPropagation}>
              <a
                href={link}
                download={name}
              >
                <MuiIcon.Download.Filled />
              </a>
            </Mui.IconButton> 
          </Mui.CardActions>
      }
      | None => <div />
    }
  }

  <Mui.Card>
    <Mui.CardActionArea
      onClick={(_) => replay -> Route.Replay -> Route.to}
    >
      <Mui.CardContent className="replay-list-item">
        <div className="replay-list-item__players">
          <div className="replay-list-item__player-info">
            <Mui.Avatar src={icon} />

            <Mui.Typography variant={H6}>
              {player -> React.string}
            </Mui.Typography>
          </div>
          
          <div className="replay-list-item__player-info">
            <Mui.Avatar src={secondPlayerIcon} />

            <Mui.Typography variant={H6}>
             {secondPlayer -> React.string}
            </Mui.Typography>
          </div>
        </div>

        <div className="replay-list-item__map-info">
          {switch gameMap.image {
            | Some(img) => <img src={img} />
            | None => <div />
          }}

          <Mui.Typography variant={H6}>
            {gameMap.name -> React.string}
          </Mui.Typography>
        </div>

        <div className="replay-list-item__build-order-info">
          <Mui.Avatar src={RaceIconStorage.getByRace(replay.race)} />

          <Mui.Typography variant={Mui.Typography.Body1}>
            {switch BuildOrderStorage.infoListDict -> Signal.get -> Dict.get(replay.buildOrder) {
              | Some(bo) => bo.name
              | None => ""
            } -> React.string}
          </Mui.Typography>
        </div>

        <div className="replay-list-item__build-order-info">
          <Mui.Avatar src={RaceIconStorage.getByRace(replay.secondRace)} />

          <Mui.Typography variant={Mui.Typography.Body1}>
            {switch BuildOrderStorage.infoListDict -> Signal.get -> Dict.get(replay.secondBuildOrder -> Option.getOr("")) {
              | Some(bo) => bo.name
              | None => ""
            } -> React.string}
          </Mui.Typography>
        </div>
      </Mui.CardContent>
    </Mui.CardActionArea>

    {downloadLink()}
  </Mui.Card>
}
