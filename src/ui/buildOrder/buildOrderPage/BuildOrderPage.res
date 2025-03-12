%%raw("import './index.css'")

@react.component
let make = (~bo: BuildOrder.t) => {
  Signal.track()

  let creator = Signal.computed(() => {
    switch UserStorage.admins -> Signal.get -> Dict.get(bo.creator) {
      | Some(admin) => <div className="build-order-page__info__creator">
          <Mui.Typography variant={Subtitle1}>{"By " -> React.string}</Mui.Typography>
          <Mui.Typography variant={H6} color={PrimaryMain}>{admin.nickname -> React.string}</Mui.Typography>
        </div>
      | None => <div />
    }
  })

  <div>
    <div className="build-order-page__info">
      <Mui.Typography variant={H2}>{bo.name -> React.string}</Mui.Typography>

      <div className="build-order-page__info__race">
        <Mui.Avatar variant={Square} src={bo.race -> RaceIconStorage.getByRace} />
        <span>{"vs" -> React.string}</span>
        <Mui.Avatar variant={Square} src={bo.opponentRace -> RaceIconStorage.getByRace} />
      </div>

      {creator -> Signal.get}

      <Mui.Typography variant={Body1} className="build-order-page__description">
        {bo.description -> Option.getOr("") -> React.string}
      </Mui.Typography>

      <TagList tags={bo.tags} />
    </div>

    <BuildOrderRenderer
      race={Signal.useSignal(bo.race)}
      steps={bo.steps -> Array.map(UiBuildOrderStep.fromStep) -> Signal.useSignal}
    />
  </div>
}
