let getAll = () => {
  let result: promise<result<array<Tag.t>, AppError.t>> = Url.fromString("tags")
    -> Api.request({method: Get})

  result
}

let create = (tag: Tag.new) => {
  let body = JSON.stringifyAny(tag)
    -> Option.getUnsafe
    -> Http.Body.make
  
  let result: promise<result<Tag.t, AppError.t>> = Url.fromString("admin/tag")
    -> Api.jsonRequestWithAuth({method: Post, body: body})

  result
}

let update = (id: Id.t, ~name: string) => {
  let body = JSON.stringifyAny({
    "name": name,
  })
    -> Option.getUnsafe
    -> Http.Body.make

  let params = Dict.fromArray([("tag", id)])
  let url = ["admin", "tag"]
  
  let result: promise<result<Tag.t, AppError.t>> = Url.make(url, ~params=params)
    -> Api.jsonRequestWithAuth({method: Patch, body: body})

  result
}

let delete = (id: Id.t) => {
  let params = Dict.fromArray([("tag", id)])
  let url = ["admin", "tag"]
  
  let result: promise<result<unit, AppError.t>> = Url.make(url, ~params=params)
    -> Api.jsonRequestWithAuth({method: Delete})

  result
}
