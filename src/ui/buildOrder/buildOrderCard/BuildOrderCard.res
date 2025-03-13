%%raw("import './index.css'")

@react.component
let make = (
  ~selectedTags: dict<Tag.t>,
  ~onTagUpdate: dict<Tag.t> => unit,
  ~item: BuildOrder.Info.t
) => {
  Signal.track()

  let toBuildOrder = async () => {
    switch await BuildOrderRepository.get(item.id) {
      | Ok(bo)=> bo -> Route.BuildOrder -> Route.to
      | Error(e) => e -> MessageStore.notifyError(~entity=MessageStore.BuildOrder, ~operation=Read)
    } -> ignore
  }

  let getAdmin = () => {
    switch UserStorage.admins -> Signal.get -> Dict.get(item.creator) {
      | Some(user) => user.nickname
      | None => ""
    }
  }

  let tags = Signal.computed(() => {
    item.tags
      -> Array.map((t) => TagStorage.tagDict -> Signal.get -> Dict.getUnsafe(t))
  })

  <ActionCard onClick={(_) => toBuildOrder() -> ignore}>
    <div className="build-order-card__build-order-name truncate text-subtitle text-color-primary pt-8">
      {item.name -> React.string}
    </div>

    <div className="text-caption text-color-secondary pt-8">
      {`By ${getAdmin()}` -> React.string}
    </div>

    <div className="build-order-card__tags mt-12">
      <TagSelector 
        onUpdate={onTagUpdate}
        selected={selectedTags}
        tags={tags -> Signal.get}
      />
    </div>
  </ActionCard>
}
