%%raw("import './index.css'")

@react.component
let make = (~item: BuildOrder.Info.t) => {
  let toBuildOrderEditor = async () => {
    switch await BuildOrderRepository.get(item.id) {
      | Ok(bo) => Route.BuildOrderEditor(bo) -> Route.to
      | Error(e) => MessageStore.notifyAppError(e, MessageStore.BuildOrder)
    }
  }

  let toBuildOrder = async () => {
    switch await BuildOrderRepository.get(item.id) {
      | Ok(bo)=> bo -> Route.BuildOrder -> Route.to
      | Error(e) => e -> MessageStore.notifyAppError(MessageStore.BuildOrder)
    } -> ignore
  }

  let actions = Signal.computed(() => switch UserStorage.isAdmin -> Signal.get {
    | true => <Mui.CardActions className="build-order-list-item__actions">
        <Mui.IconButton
          onClick={(e) => {
            e -> ReactEvent.Mouse.stopPropagation
            toBuildOrderEditor() -> ignore
          }}
        >
          <Lucide.Pencil />
        </Mui.IconButton>
      </Mui.CardActions>
    | false => <div />
  })

  let getAdmin = () => {
    let name = switch UserStorage.admins -> Signal.get -> Dict.get(item.creator) {
      | Some(user) => user.nickname
      | None => ""
    }

    <Mui.Typography variant={Mui.Typography.H6}>
      {`by ${name}` -> React.string}
    </Mui.Typography>
  }

  <Mui.Card className="build-order-list-item" >
    <Mui.CardActionArea onClick={(_) => toBuildOrder() -> ignore}>
      <Mui.CardContent>
      <Mui.Typography variant={Mui.Typography.H5}>
        {item.name -> React.string}
      </Mui.Typography>

      {getAdmin()}

      <div className="build-order-list-item__tags">
        <TagList tags={item.tags} />
      </div>
    </Mui.CardContent>
    </Mui.CardActionArea>

    {actions -> Signal.get}
  </Mui.Card>
}
