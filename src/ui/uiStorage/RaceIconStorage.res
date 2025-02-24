let items: ref<Map.t<Race.t, string>> = Map.make() -> ref

let init = async () => {
  switch await RaceRepository.getIcons() {
    | Ok(value) => {
      items := value
        -> Array.map(v => (v.name, v.icon))
        -> Map.fromArray
      }
    | _ => ()
  }
}

let getByRace = (race) => {
  items.contents
    -> Map.get(race)
    -> Option.getUnsafe
}

let getList = () => items.contents -> Map.entries
  
