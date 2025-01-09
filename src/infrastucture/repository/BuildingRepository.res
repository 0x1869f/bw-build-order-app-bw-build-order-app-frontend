let get = async () => {
  let result: result<array<Building.t>, AppError.t> = await Url.fromString("building")
    -> Api.request({method: Get})

  result
}
