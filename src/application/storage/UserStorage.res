let admins: Signal.t<Dict.t<User.t>> = Dict.make() -> Signal.useMake
let currentUser: Signal.t<option<User.t>> = None -> Signal.useMake
let isLoggedIn = Signal.computed(() => currentUser -> Signal.get -> Option.isSome)

let logout = () => {
  currentUser -> Signal.set(None)
  LocalStorage.delete(Token)
}

let isAdmin = Signal.computed(() => {
  switch currentUser -> Signal.get {
    | Some({role: User.Admin | User.Root}) => true
    | _ => false
  }
})

let login = async (login: string, password: string) => {
  switch await UserRepository.login(login, password) {
    | Ok(payload) => {
      LocalStorage.set(Token, payload.token)

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

let updateNickname = async (nickname: string) => {
  switch await UserRepository.updateNickname(nickname) {
    | Ok(_) => {
      switch currentUser -> Signal.get {
        | Some(user) => currentUser -> Signal.set(Some({...user, nickname}))
        | None => ()
      }
      Ok()
    }
    | Error(e) => Error(e)
  }
}


let init = async () => {
  if LocalStorage.get(LocalStorage.Token) -> Option.isSome {
    switch await UserRepository.getCurrent() {
      | Ok(user) => currentUser -> Signal.set(Some(user))
      | Error(_) => ()
    }
  }

  (await UserRepository.getAdmins())
    -> Result.getOr([])
    -> Array.map((a) => (a.id, a))
    -> Dict.fromArray
    -> Signal.set(admins, _)
}
