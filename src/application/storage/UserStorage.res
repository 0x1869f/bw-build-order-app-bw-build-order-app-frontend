type payload = {
  token: string
}

external jsonToPayload: JSON.t => payload = "%identity"

let isLoggedIn = Signal.useMake(false)
let admins: Signal.t<Dict.t<User.t>> = Dict.make() -> Signal.useMake
let currentUser: Signal.t<option<User.t>> = None -> Signal.useMake

let logout = () => {
  isLoggedIn -> Signal.set(false)
  currentUser -> Signal.set(None)
  LocalStorage.delete(Token)
}

let login = async (login: string, password: string) => {
  switch await UserRepository.login(login, password) {
    | Ok(value) => {
      let payload = value -> jsonToPayload
      LocalStorage.set(Token, payload.token)

      isLoggedIn -> Signal.set(true)

      switch await UserRepository.getCurrent() {
        | Ok(user) => {
          currentUser -> Signal.set(Some(user))
          Ok()
        }
        | Error(a) => Error(a)
      }
    }
    | Error(a) => Error(a)
  }
}


let init = async () => {
  let login = LocalStorage.get(LocalStorage.Token) -> Option.isSome

  if (login) {
    switch await UserRepository.getCurrent() {
      | Ok(user) => currentUser -> Signal.set(Some(user))
      | Error(_) => ()
    }
  }

  isLoggedIn -> Signal.set(login)

  (await UserRepository.getAdmins())
    -> Result.getOr([])
    -> Array.map((a) => (a.id, a))
    -> Dict.fromArray
    -> Signal.set(admins, _)
}
