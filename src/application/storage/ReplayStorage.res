let items: Signal.t<array<Replay.t>> = [] -> Signal.useMake

let create = async (replay: Replay.new, file: Webapi.File.t) => {
  switch await ReplayRepository.create(replay, file) {
    | Ok(rep) => {
      [...items -> Signal.get, rep] -> Signal.set(items, _)
      Ok()
    }
    | Error(e) => Error(e)
  }
}

let init = async () => {
  switch await ReplayRepository.get() {
    | Ok(value) => items -> Signal.set(value)
    | Error(_) => ()
  }
}
