let items: Signal.t<dict<GameMap.t>> = Dict.make() -> Signal.useMake

let init = async () => {
  (await MapRepository.getMaps())
    -> Result.getOr([])
    -> Array.map((m) => (m.name, m))
    -> Dict.fromArray
    -> Signal.set(items, _)
}
