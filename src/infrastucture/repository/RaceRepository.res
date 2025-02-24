let getIcons = () => {
  let result: promise<result<array<ApiRace.t>, AppError.t>> = Url.fromString("races")
    -> Api.jsonRequest({method: Get})

  result
}
