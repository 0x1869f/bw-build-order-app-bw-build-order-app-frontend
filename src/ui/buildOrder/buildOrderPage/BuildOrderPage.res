%%raw("import './index.css'")

@react.component
let make = (~bo: BuildOrder.t) => {
  let creator = Signal.computed(() => {
    switch UserStorage.admins -> Signal.get -> Dict.get(bo.creator) {
      | Some(admin) => `By ${admin.nickname}`
      | None => ""
    }
  })

  <div>
    <div className="build-order-page__info">
      <div>{bo.name -> React.string}</div>

      <div className="build-order-page__info__race">
        <Mui.Avatar src={bo.race -> RaceIconStorage.getByRace} />
        <span>{"vs" -> React.string}</span>
        <Mui.Avatar src={bo.opponentRace -> RaceIconStorage.getByRace} />
      </div>

      <div>{creator -> Signal.get -> React.string}</div>
      <div>{bo.description -> Option.getOr("") -> React.string}</div>

      <TagList tags={bo.tags} />
    </div>

    <BuildOrderRenderer
      race={Signal.useSignal(bo.race)}
      steps={bo.steps -> Array.map(UiBuildOrderStep.fromStep) -> Signal.useSignal}
    />
  </div>
}
