let addAvatar = async (id: Id.t, avatar: Webapi.File.t) => {
  let data = Webapi.FormData.make()
  data -> FormData.appendFile("file", avatar)

  let result: result<string, AppError.t> = await Url.make(
    ["admin-static", "player-avatar"],
    ~params=Dict.fromArray([("player-avatar", id)])
  )
    -> Api.requestWithAuth({method: Patch, body: data -> Http.Body.makeWithFormData})

  result
}

let create = async (player: Player.New.t, avatar: option<Webapi.File.t>) => {
  let body = JSON.stringifyAny(player)
    -> Option.getUnsafe
    -> Http.Body.make

  let result: result<Player.t, AppError.t> = await Url.fromString("admin/player")
    -> Api.jsonRequestWithAuth({method: Post, body: body})

  switch avatar {
    | Some(file) => switch result {
      | Ok(player) => switch await addAvatar(player.id, file) {
        | Ok(path) => Ok({
          ...player,
          avatar: Some(path)
        })
        | Error(e) => Error(e)
      }
      | Error(e) => Error(e)
    }
    | None => result
  }
}

let get = () => {
  let result: promise<result<array<Player.t>, AppError.t>> = Url.fromString("players")
    -> Api.jsonRequest({method: Get})

  result
}
