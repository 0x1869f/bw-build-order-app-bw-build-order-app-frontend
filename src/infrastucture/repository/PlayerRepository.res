let create = (player: Player.New.t) => {
  let body = JSON.stringifyAny(player)
    -> Option.getUnsafe
    -> Http.Body.make

  let result: promise<result<Player.t, AppError.t>> = Url.fromString("user/player")
    -> Api.jsonRequest({method: Post, body: body})

  result
}

let get = () => {
  let result: promise<result<array<Player.t>, AppError.t>> = Url.fromString("players")
    -> Api.jsonRequest({method: Get})

  result
}
