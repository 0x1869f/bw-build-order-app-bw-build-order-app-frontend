type payload = {
  token: string
}

let login = async (login: string, password: string) => {
  let url = Url.fromString("login")

  let body = {"login": login, "password": password}
    -> JSON.stringifyAny
    -> Option.getUnsafe
    -> Http.Body.make

  let result: result<payload, AppError.t> = await url
    -> Api.jsonRequest({method: Post, body: body})

  result
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

let updatePassword = async (oldPassword: string, newPassword: string) => {
  let body = {"oldPassword": oldPassword, "newPassword": newPassword}
    -> JSON.stringifyAny
    -> Option.getUnsafe
    -> Http.Body.make

  let result: result<unit, AppError.t> = await Url.fromString("user/change-password")
    -> Api.jsonRequestWithAuth({method: Patch, body})

  result
}

let updateNickname = async (nickname: string) => {
  let body = {"nickname": nickname}
    -> JSON.stringifyAny
    -> Option.getUnsafe
    -> Http.Body.make

  let result: result<unit, AppError.t> = await Url.fromString("user/change-nickname")
    -> Api.jsonRequestWithAuth({method: Patch, body})

  result
}
