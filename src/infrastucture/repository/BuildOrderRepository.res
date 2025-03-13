let getInfoList = async () => {
  let result: result<array<BuildOrder.Info.t>, AppError.t> = await Url.fromString("build-orders")
    -> Api.request({method: Get})

  result
}

let get = async (id: Id.t) => {
  let params = Dict.fromArray([("build-order", id)])
  let url = ["build-order"]

  let result: result<ApiBuildOrder.t, AppError.t> = await Url.make(url, ~params=params)
    -> Api.request({method: Get})

  switch result {
    | Ok(bo)=> Ok(bo -> ApiBuildOrder.toBuildOrder)
    | Error(e) => Error(e)
  }
}

let create = async (bo: BuildOrder.new) => {
  let apiBo = bo -> ApiBuildOrder.fromNewBuildOrder

  let result: result<BuildOrder.Info.t, AppError.t> = await Url.fromString("admin/build-order")
    -> Api.jsonRequestWithAuth({
      method: Post,
      body: apiBo
        -> JSON.stringifyAny
        -> Option.getUnsafe
        -> Http.Body.make,
    })

  result
}

let update = async (bo: BuildOrder.new, id: string) => {
  let params = [("build-order", id)] -> Dict.fromArray
  let url = ["admin", "build-order"] -> Url.make(~params=params)

  let result: result<BuildOrder.Info.t, AppError.t> = await url -> Api.jsonRequestWithAuth({
    method: Put,
    body: bo
      -> ApiBuildOrder.fromNewBuildOrder
      -> JSON.stringifyAny
      -> Option.getUnsafe
      -> Http.Body.make,
  })

  result
}
