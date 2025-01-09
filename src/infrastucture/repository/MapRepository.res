let getMaps = async () => {
  let result: result<array<GameMap.t>, AppError.t> = await Url.fromString("maps")
    -> Api.request({method: Get})

  result
}
