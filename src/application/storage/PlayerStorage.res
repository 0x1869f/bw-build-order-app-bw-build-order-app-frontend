let items: Signal.t<array<Player.t>> = [] -> Signal.useMake

let itemsDict = Signal.computed(() => items
  -> Signal.get
  -> Array.map(i => (i.id, i))
  -> Dict.fromArray
)

let init = async () => {
  (await PlayerRepository.get())
    -> Result.getOr([])
    -> Signal.set(items, _)
}

let create = async (newPlayer: Player.New.t, avatar: option<Webapi.File.t>) => {
  switch await PlayerRepository.create(newPlayer, avatar) {
    | Ok(value) => {
      items -> Signal.set([...items -> Signal.get, value])
      Ok()
    }
    | Error(e) => Error(e)
  }
}
