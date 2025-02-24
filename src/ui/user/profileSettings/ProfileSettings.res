%%raw("import './index.css'")

@react.component
let make = () => {
  Signal.track()
  let oldPassword = Signal.useSignal("")
  let newPassword = Signal.useSignal("")

  let nickname = Signal.useSignal("")

  let clearPassword = () => {
    oldPassword -> Signal.set("")
    newPassword -> Signal.set("")
  }

  let isPasswordUpdateDisabled = Signal.computed(() => {
    [oldPassword, newPassword]
      -> Array.some(s => s -> Signal.get -> String.length === 0)
  })

  let updatePassword = async () => {
    switch await UserRepository.updatePassword(oldPassword -> Signal.get, newPassword -> Signal.get) {
      | Ok(_) => {
        MessageStore.notifyUpdate(MessageStore.Password)
        clearPassword()
      }
      | Error(e) => MessageStore.notifyAppError(e, MessageStore.Password)
    }
  }
  let updateNickanme = async () => {
    switch await UserRepository.updateNickname(nickname -> Signal.get) {
      | Ok(_) => {
        MessageStore.notifyUpdate(MessageStore.Nickname)
        nickname -> Signal.set("")
      }
      | Error(e) => MessageStore.notifyAppError(e, MessageStore.Nickname)
    }
  }

  <div className="profile-settings">
    <Mui.Card elevation={4} className="profile-settings__card">
      <Mui.CardHeader title={"Change password" -> React.string}/>

      <Mui.CardContent>
        <div className="form__content">
          <div>
            <Mui.TextField
              value={oldPassword -> Signal.get}
              onChange={v => oldPassword -> Signal.set((v -> Form.stringValue).value)}
              label={"old password *" -> React.string}
              type_="password"
            />
          </div>

          <div> <Mui.TextField
              value={newPassword -> Signal.get}
              onChange={v => newPassword -> Signal.set((v -> Form.stringValue).value)}
              label={"new password *" -> React.string}
              type_="password"
            />
          </div>
        </div>
      </Mui.CardContent>

      <Mui.CardActions>
        <Mui.Button
          disabled={isPasswordUpdateDisabled -> Signal.get}
          onClick={(_) => updatePassword() -> ignore}
          variant={Contained}
        >
          {"save" -> React.string}
        </Mui.Button>

        <Mui.Button
          onClick={(_) => clearPassword()}
          variant={Outlined}
        >
          {"cancel" -> React.string}
        </Mui.Button>
      </Mui.CardActions>
    </Mui.Card>

    <Mui.Card elevation={4} className="profile-settings__card">
      <Mui.CardHeader title={"Change nickname" -> React.string}/>

      <Mui.CardContent>
        <div className="form__content">
          <Mui.TextField
            value={nickname -> Signal.get}
            onChange={v => nickname -> Signal.set((v -> Form.stringValue).value)}
            label={"nickname *" -> React.string}
          />
        </div>
      </Mui.CardContent>

      <Mui.CardActions>
        <Mui.Button
          disabled={nickname -> Signal.get -> String.length === 0}
          onClick={(_) => updateNickanme() -> ignore}
          variant={Contained}
        >
          {"save" -> React.string}
        </Mui.Button>

        <Mui.Button
          onClick={(_) => nickname -> Signal.set("")}
          variant={Outlined}
        >
          {"cancel" -> React.string}
        </Mui.Button>
      </Mui.CardActions>
    </Mui.Card>
  </div>
}
