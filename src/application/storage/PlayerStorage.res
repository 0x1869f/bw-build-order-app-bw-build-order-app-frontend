let items: Signal.t<array<Player.t>> = [] -> Signal.useMake

let create = async (newPlayer: Player.New.t) => {
  switch await PlayerRepository.create(newPlayer) {
    | Ok(player) => {
      let players = items -> Signal.get
      players -> Array.push(player)
      Ok()
    }
    | Error(e) => Error(e)
  }
}

let init = async () => {
  (await PlayerRepository.get())
    -> Result.getOr([])
    -> Signal.set(items, _)
}
