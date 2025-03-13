let items: Signal.t<array<Tag.t>> = [] -> Signal.useMake

let tagDict = Signal.computed(() => {
  items
    -> Signal.get
    -> Array.map((tag) => (tag.id, tag))
    -> Dict.fromArray
})

let init = async () => {
  switch await TagRepository.getAll() {
    | Ok(value) => items -> Signal.set(value)
    | Error(_) => ()
  }
}

let create = async (tag: Tag.new) => {
  switch await TagRepository.create(tag) {
    | Ok(value) => {
      [...items -> Signal.get, value]
        -> Signal.set(items, _)
      Ok()
    }
    | Error(e) => Error(e)
  }
}

let update = async (id: Id.t, ~name: string) => {
  switch await TagRepository.update(id, ~name=name) {
    | Ok(value) => items
      -> Signal.get
      -> Array.map((tag) => tag.id === value.id ? value : tag)
      -> Signal.set(items, _)
      Ok() 
    | Error(e)=> Error(e)
  }
}

let delete = async (id: Id.t) => {
  switch await TagRepository.delete(id) {
    | Ok() => {
      items
        -> Signal.get
        -> Array.filter((tag) => tag.id !== id)
        -> Signal.set(items, _)
      Ok() 
    }
    | Error(e)=> Error(e)
  }
}
