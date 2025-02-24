%%raw("import './Header.css'")

@react.component
let make = () => {
  Signal.track()

  let loginDialogIsOpened = Signal.useSignal(false)
  let tagDialogIsOpened = Signal.useSignal(false)
  let playerDialogIsOpened = Signal.useSignal(false)
  let mapDialogIsOpened = Signal.useSignal(false)
  let replayDialogIsOpened = Signal.useSignal(false)

  let goToEditor = () => Route.NewBuildOrder -> Route.to

  let makeUnauthorizedContols = () => {
    <div className="header__controls">
      <Mui.Button
        variant={Mui.Button.Outlined}
        onClick={(_) => loginDialogIsOpened -> Signal.set(true)}
      >
        {"Login" -> React.string}
      </Mui.Button>
    </div>
  }

  let makeIconWithText = (text) => {
    <div className="header__control-icon">
      <Lucide.Plus />
      {text -> React.string}
    </div>
  }

  let makeAdminContols = () => {
    <div className="header__controls">
      <div>
        <Mui.Button
          variant={Mui.Button.Outlined}
          onClick={(_) => mapDialogIsOpened -> Signal.set(true)}
        >
          {"map" -> makeIconWithText}
        </Mui.Button>
      </div>

      <div>
        <Mui.Button
          variant={Mui.Button.Outlined}
          onClick={(_) => playerDialogIsOpened -> Signal.set(true)}
        >
          {"player" -> makeIconWithText}
        </Mui.Button>
      </div>

      <div>
        <Mui.Button
          variant={Mui.Button.Outlined}
          onClick={(_) => tagDialogIsOpened -> Signal.set(true)}
        >
          {"tag" -> makeIconWithText}
        </Mui.Button>
      </div>
        
      <div>
        <Mui.Button
          variant={Mui.Button.Outlined}
          onClick={(_) => replayDialogIsOpened -> Signal.set(true)}
        >
          {"replay" -> makeIconWithText}
        </Mui.Button>
      </div>


      <div>
        <Mui.Button
          variant={Mui.Button.Outlined}
          onClick={(_) => goToEditor()}
        >
          {"build order" -> makeIconWithText}
        </Mui.Button>
      </div>

      <ProfileMenu />
    </div>
  }

  let controls = Signal.computed(() => {
    switch UserStorage.currentUser -> Signal.get {
      | Some(user) => switch user.role {
        | Admin => makeAdminContols()
        | Root => makeAdminContols()
        | _ => <div></div>
      }
      | None => makeUnauthorizedContols()
    }
  })

  let actions = Signal.computed(() =>  {
    switch UserStorage.currentUser -> Signal.get {
      | Some(user) => switch user.role {
        | Admin | Root => if mapDialogIsOpened -> Signal.get {
            <NewMapDialog
              onClose={() => mapDialogIsOpened -> Signal.set(false)}
            />
          } else {
            if playerDialogIsOpened -> Signal.get {
              <NewPlayerDialog
                onClose={() => playerDialogIsOpened -> Signal.set(false)}
              />
            } else {
              if tagDialogIsOpened -> Signal.get {
                <NewTagDialog
                  onClose={() => tagDialogIsOpened -> Signal.set(false)}
                />
              } else {
                if replayDialogIsOpened -> Signal.get {
                  <NewReplayDialog
                    onClose={() => replayDialogIsOpened -> Signal.set(false)}
                  />
                } else {
                  <div />
                }
              }
            }
          }
        | _ => <div></div>
      }
      | None => loginDialogIsOpened -> Signal.get
        ? <LoginDialog onClose={() => loginDialogIsOpened -> Signal.set(false)} />
        : <div />
    }
  })

  <div className="header">
    {controls -> Signal.get}
    {actions -> Signal.get}
  </div>
}
