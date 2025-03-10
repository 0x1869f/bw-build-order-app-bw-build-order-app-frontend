let getInfoList = async () => {
  let result: result<array<ApiBuildOrder.Info.t>, AppError.t> = await Url.fromString("build-orders")
    -> Api.request({method: Get})

  switch result {
    | Ok(value) => value
      -> Array.map(ApiBuildOrder.Info.toBuildOrderInfo)
      -> Ok
    | Error(e) => Error(e)
  }
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

  let result: result<ApiBuildOrder.t, AppError.t> = await Url.fromString("admin/build-order")
    -> Api.jsonRequestWithAuth({
      method: Post,
      body: apiBo
        -> JSON.stringifyAny
        -> Option.getUnsafe
        -> Http.Body.make,
    })

  switch result {
    | Ok(bo)=> Ok(bo -> ApiBuildOrder.toBuildOrderInfo)
    | Error(e) => Error(e)
  }
}

let update = async (bo: BuildOrder.new, id: string) => {
  let params = [("build-order", id)] -> Dict.fromArray
  let url = ["admin", "build-order"] -> Url.make(~params=params)

  let result: result<ApiBuildOrder.t, AppError.t> = await url -> Api.jsonRequestWithAuth({
    method: Put,
    body: bo
      -> ApiBuildOrder.fromNewBuildOrder
      -> JSON.stringifyAny
      -> Option.getUnsafe
      -> Http.Body.make,
  })

  switch result {
    | Ok(bo)=> Ok(bo -> ApiBuildOrder.toBuildOrderInfo)
    | Error(e) => Error(e)
  }
}
