let getAll = () => {
  Url.fromString("tags") -> Api.request({method: Get})
}

let create = (tag: Tag.t) => {
  let body = JSON.stringifyAny(tag)
    -> Option.getUnsafe
    -> Http.Body.make

  Url.fromString("tag")
    -> Api.jsonRequest({method: Post, body: body})
}
