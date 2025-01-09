let items: Signal.t<Dict.t<Tag.t>> = Dict.make() -> Signal.useMake

external jsonToTagList: JSON.t => array<Tag.t> = "%identity"

let init = async () => {
  let tags: result<array<Tag.t>, AppError.t> = await TagRepository.getAll()

  switch tags {
    | Ok(value) => {
      let dict = value
        -> Array.map((item) => (item.name, item))
        -> Dict.fromArray
      items -> Signal.set(dict)
    }
    | Error(_) => ()
  }
}

let getItems = Signal.computed(() => items -> Signal.get -> Dict.valuesToArray)

let create = async (tag: Tag.t) => {
  switch await TagRepository.create(tag) {
    | Ok(_) => {
      items -> Signal.set(
        items -> Signal.get -> Dict.assign(Dict.fromArray([(tag.name, tag)]))
      )
      Ok()
    }
    | Error(e) => Error(e)
  }
}
