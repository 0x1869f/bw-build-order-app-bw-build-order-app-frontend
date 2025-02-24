let items: Signal.t<Map.t<Id.t, Tag.t>> = Map.make() -> Signal.useMake

module Arr = {
  type t<'a> = array<'a>

  @send
  external findLastIndex: (t<'a>, ('a) => bool) => int = "findLastIndex" 
}

let init = async () => {
  switch await TagRepository.getAll() {
    | Ok(value) => value
      -> Array.map(t => (t.id, t))
      -> Map.fromArray
      -> Signal.set(items, _)
    | Error(_) => ()
  }
}

let create = async (tag: Tag.new) => {
  switch await TagRepository.create(tag) {
    | Ok(value) => {
      let arr = items
        -> Signal.get
        -> Map.entries
        -> Iterator.toArray

      let index = arr
        -> Arr.findLastIndex((t) => {
          let (_, tag) = t
          tag.race === value.race}
      )

      arr
        -> Array.toSpliced(~start=index + 1, ~remove=0, ~insert=[(value.id, value)])
        -> Map.fromArray
        -> Signal.set(items, _)

      Ok()
    }
    | Error(e) => Error(e)
  }
}

let byRace = (race: Race.t) => items
  -> Signal.get
  -> Map.values
  -> Iterator.toArray
  -> Array.filter(tag => tag.race === race)

let byId = (id: Id.t) => items
  -> Signal.get
  -> Map.get(id)
