let get = async () => {
  let result: result<array<Unit.t>, AppError.t> = await Url.fromString("units")
    -> Api.request({method: Get})

  result
}
