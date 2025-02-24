let addAvatar = async (id: Id.t, image: Webapi.File.t) => {
  let data = Webapi.FormData.make()
  data -> FormData.appendFile("file", image)

  let result: result<string, AppError.t> = await Url.make(
    ["admin-static", "map-image"],
    ~params=Dict.fromArray([("map-image", id)])
  )
    -> Api.requestWithAuth({method: Patch, body: data -> Http.Body.makeWithFormData})

  result
}

let getMaps = async () => {
  let result: result<array<GameMap.t>, AppError.t> = await Url.fromString("maps")
    -> Api.request({method: Get})

  result
}

let create = async (gameMap: GameMap.new, image: option<Webapi.File.t>) => {
  let body = gameMap
    -> JSON.stringifyAny
    -> Option.getUnsafe
    -> Http.Body.make

  let result: result<GameMap.t, AppError.t> = await Url.fromString("admin/map")
    -> Api.jsonRequestWithAuth({body, method: Post})

  switch image {
    | Some(file) => switch result {
      | Ok(gameMap) => switch await addAvatar(gameMap.id, file) {
        | Ok(path) => Ok({
          ...gameMap,
          image: Some(path)
        })
        | Error(e) => Error(e)
      }
      | Error(e) => Error(e)
    }
    | None => result
  }
}
