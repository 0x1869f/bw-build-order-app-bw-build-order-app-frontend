%%raw("import './Header.css'")

@react.component
let make = () => {
  Signal.track()

  let dialogIsOpened = Signal.useSignal(false)

  let goToEditor = () => RescriptReactRouter.push(Route.NewBuildOrder -> Route.url)

  let makeUnauthorizedContols = () => {
    <div className="header_controls">
      <Mui.Button
        size={Mui.Button.Large}
        variant={Mui.Button.Outlined}
        onClick={(_) => dialogIsOpened -> Signal.set(true)}
      >
        {"Login" -> React.string}
      </Mui.Button>
    </div>
  }

  let makeAdminContols = () => {
    <div className="header_controls">
      <Mui.Button
        size={Mui.Button.Large}
        variant={Mui.Button.Outlined}
        onClick={(_) => goToEditor()}
      >
        {"Create build order" -> React.string}
      </Mui.Button>
    </div>
  }


  let controls = Signal.computed(() => if UserStorage.isLoggedIn -> Signal.get {
    switch UserStorage.currentUser -> Signal.get {
      | Some(user) => switch user.role {
        | Admin => makeAdminContols()
        | Root => makeAdminContols()
        | _ => <div></div>
      }
      | None => makeUnauthorizedContols()
    }
  } else {
    makeUnauthorizedContols()
  })

  <div className="header">
    {controls -> Signal.get}
    <LoginDialog
      onClose={() => dialogIsOpened -> Signal.set(false)}
      isOpened={dialogIsOpened -> Signal.get}
    />
  </div>
}
