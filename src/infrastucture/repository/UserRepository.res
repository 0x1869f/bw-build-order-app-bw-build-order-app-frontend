let login = (login: string, password: string) => {
  let url = Url.fromString("login")

  let body = {"login": login, "password": password}
    -> JSON.stringifyAny
    -> Option.getUnsafe
    -> Http.Body.make

  Api.jsonRequest(url, {method: Post, body: body})
}

let getCurrent = async () => {
  let result: result<User.t, AppError.t> = await Url.fromString("user/get-info")
    -> Api.requestWithAuth({method: Get})

  result
}

let getAdmins = async () => {
  let result: result<array<User.t>, AppError.t> = await Url.fromString("admins")
    -> Api.request({method: Get})

  result
}
