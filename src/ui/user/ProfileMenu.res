@react.component
let make = () => {
  Signal.track()

  let isShown = Signal.useSignal(false)
  let buttonRef = React.useRef(Nullable.null)

  let logOut = () => {
    isShown -> Signal.set(false)
    UserStorage.logout()
    Route.BuildOrderList -> Route.to
  }

  let goToSettings = () => {
    isShown -> Signal.set(false)
    Route.ProfileSettings -> Route.to
  }

  <div>
    <Mui.Button
      ref={ReactDOM.Ref.domRef(buttonRef)}
      onClick={(_) => isShown -> Signal.set(true)}
    >
      <Mui.Avatar sx={Mui.Sx.obj({bgcolor: Mui.System.Value.PrimaryMain})}>
        {switch UserStorage.currentUser -> Signal.get {
          | Some(u) => u.nickname -> String.slice(~start=0, ~end=1)
          | None => ""
        } -> React.string}
      </Mui.Avatar>
    </Mui.Button>

    <Mui.Menu
      anchorOrigin={vertical: Bottom, horizontal: Left}
      open_={isShown -> Signal.get}
      anchorEl={Mui.Popover.Element(() => buttonRef.current)}
      onClose={(_, _) => isShown -> Signal.set(false)}
    >
      <Mui.MenuItem onClick={(_) => goToSettings()}>
        <Mui.ListItemIcon>
          <Mui.Icon>
            <Icon.ManageAccounts.Filled />
          </Mui.Icon>
        </Mui.ListItemIcon>

        {"Profile" -> React.string}
      </Mui.MenuItem>

      <Mui.MenuItem onClick={(_) => logOut()}>
        <Mui.ListItemIcon>
          <Mui.Icon>
            <Icon.Logout.Filled />
          </Mui.Icon>
        </Mui.ListItemIcon>

        {"Logout" -> React.string}
      </Mui.MenuItem>
    </Mui.Menu>
  </div>
}
