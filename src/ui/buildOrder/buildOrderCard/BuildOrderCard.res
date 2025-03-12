%%raw("import './index.css'")

@react.component
let make = (~item: BuildOrder.Info.t) => {
  Signal.track()

  let toBuildOrder = async () => {
    switch await BuildOrderRepository.get(item.id) {
      | Ok(bo)=> bo -> Route.BuildOrder -> Route.to
      | Error(e) => e -> MessageStore.notifyAppError(MessageStore.BuildOrder)
    } -> ignore
  }

  let getAdmin = () => {
    switch UserStorage.admins -> Signal.get -> Dict.get(item.creator) {
      | Some(user) => user.nickname
      | None => ""
    }
  }

  <ActionCard onClick={(_) => toBuildOrder() -> ignore}>
    <div className="build-order-card d-flex gap-4 align-center">
      <img src={RaceIconStorage.getByRace(item.race)} />

      <span className="text-caption text-color-secondary">
        {"vs" -> React.string}
      </span>

      <img src={RaceIconStorage.getByRace(item.opponentRace)} />
    </div>

    <div className="build-order-card__build-order-name truncate text-subtitle text-color-primary pt-8">
      {item.name -> React.string}
    </div>

    <div className="text-caption text-color-secondary pt-8">
      {`By ${getAdmin()}` -> React.string}
    </div>
  </ActionCard>
}
