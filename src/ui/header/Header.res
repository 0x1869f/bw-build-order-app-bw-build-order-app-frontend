%%raw("import './Header.css'")

@react.component
let make = () => {
  Signal.track()
  let openLoginDialog = () =>  {
    SidePanelStorage.openPanel(
      <LoginDialogue
        onClose={() => {
          SidePanelStorage.closePanel()
        }}
      />,
      ~newTitle="Log in"
    )
  }

  let openProfileSettings = () => {
    SidePanelStorage.openPanel(
      <ProfileSettings
        onClose={() => {
          SidePanelStorage.closePanel()
        }}
      />,
      ~newTitle="My profile"
    )
  }

  <div className="header w-full border-bottom bg-global">
    <div className="d-flex h-64 px-16 justify-space-between">
      <Navigation />

      <div className="d-flex align-center gap-16">
        {switch UserStorage.currentUser -> Signal.get {
          | Some(user) => <Avatar
            onClick={openProfileSettings}
            name={user.nickname}
          />
          | None => <div />
        }}
        {switch UserStorage.currentUser -> Signal.get {
          | Some(_) => <PrimaryButton onClick={_ => UserStorage.logout()}>
              {"Log out" -> React.string}
            </PrimaryButton>
          | None => <PrimaryButton onClick={_ => openLoginDialog()}>
          {"Log in" -> React.string}
        </PrimaryButton>}}
      </div>
    </div>
  </div>
}
