let items: Signal.t<array<GameMap.t>> = Signal.useMake([])

let itemsDict = Signal.computed(() => items
  -> Signal.get
  -> Array.map(m => (m.id, m))
  -> Dict.fromArray
)

let init = async () => {
  (await MapRepository.getMaps())
    -> Result.getOr([])
    -> Signal.set(items, _)
}

let create = async (gameMap: GameMap.new, image: option<Webapi.File.t>) => {
  switch await MapRepository.create(gameMap, image) {
    | Ok(value)=> {
      items -> Signal.set([...items -> Signal.get, value]) 
      Ok() 
    }
    | Error(e)=> Error(e)
  }
}
