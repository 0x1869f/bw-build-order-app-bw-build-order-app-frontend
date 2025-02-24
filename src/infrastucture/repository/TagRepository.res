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
