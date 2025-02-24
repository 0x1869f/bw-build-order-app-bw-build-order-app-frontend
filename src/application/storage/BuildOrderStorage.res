let infoList: Signal.t<array<BuildOrder.Info.t>> = Signal.useMake([])

let infoListDict = Signal.computed(() => {
  infoList
    -> Signal.get
    -> Array.map((i) => (i.id, i))
    -> Dict.fromArray
})

let init = async () => {
  switch await BuildOrderRepository.getInfoList() {
    | Ok(value) => infoList -> Signal.set(value)
    | Error(_) => ()
  }
}

let create = async (bo: BuildOrder.new) => {
  switch await BuildOrderRepository.create(bo) {
    | Ok(v)=> {
      infoList -> Signal.set([v, ...infoList -> Signal.get])
      Ok()
    }
    | Error(e)=> Error(e)
  }
}

let update = async (bo: BuildOrder.new, id: Id.t) => {
  switch await BuildOrderRepository.update(bo, id) {
    | Ok(v)=> {
      let items = infoList -> Signal.get

      switch items -> Array.findIndexOpt((b) => b.id === v.id) {
        | Some(index) => items -> Array.set(index, v)
        | None => items -> Array.push(v)
      }

      infoList -> Signal.set(items)
      Ok()
    }
    | Error(e)=> Error(e)
  }
}
