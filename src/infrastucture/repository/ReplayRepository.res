let get = async () => {
  let result: result<array<Replay.t>, AppError.t> = await Url.fromString("replays")
    -> Api.request({method: Get})

  result

}

let addFile = async (id: Id.t, file: Webapi.File.t) => {
  let data = Webapi.FormData.make()
  data -> FormData.appendFile("file", file)

  let result: result<string, AppError.t> = await Url.make(
    ["admin-static", "replay-file"],
    ~params=Dict.fromArray([("replay-file", id)])
  )
    -> Api.requestWithAuth({method: Patch, body: data -> Http.Body.makeWithFormData})

  result
}

let create = async (replay: Replay.new, file: Webapi.File.t) => {
  let body = replay
    -> JSON.stringifyAny
    -> Option.getUnsafe
    -> Http.Body.make

  let result: result<Replay.t, AppError.t> = await Url.fromString("admin/replay")
    -> Api.jsonRequestWithAuth({method: Post, body})

  switch result {
    | Ok(rep) => {
      switch await addFile(rep.id, file) {
        | Ok(file) => Ok({
          ...rep,
          file: Some(file)
        })
        | Error(e) => Error(e)
      }
    }
    | Error(e) => Error(e)
  }
}
