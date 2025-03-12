@react.component
let make = (
  ~onClose: unit => unit,
) => {
  Signal.track()
  let oldPassword = Signal.useSignal("")
  let newPassword = Signal.useSignal("")

  let nickname = switch UserStorage.currentUser -> Signal.get {
    | Some(user) => user.nickname
    | None => ""
  } -> Signal.useSignal

  let clearPassword = () => {
    oldPassword -> Signal.set("")
    newPassword -> Signal.set("")
  }

  let isPasswordUpdateDisabled = Signal.computed(() => {
    [oldPassword, newPassword]
      -> Array.some(s => s -> Signal.get -> String.length === 0)
  })

  let isNicknameUpdateDisabled = Signal.computed(() => {
    let name = nickname -> Signal.get
    name -> String.length === 0 || switch UserStorage.currentUser -> Signal.get {
      | Some(user) => user.nickname === name
      | None => false
    }
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

  <div>
    <div>
      <div className="text-h6 text-color-primary">{"Edit your nickname" -> React.string}</div>

      <div className="mt-24">
        <TextField
          value={nickname -> Signal.get}
          onChange={v => nickname -> Signal.set(v)}
          label="Name"
        />
      </div>

      <div className="d-flex gap-16 mt-32">
        <PrimaryButton
          disabled={isNicknameUpdateDisabled -> Signal.get}
          onClick={(_) => updateNickanme() -> ignore}
        >
          {"Save" -> React.string}
        </PrimaryButton>

        <SecondaryButton
          onClick={(_) => nickname -> Signal.set("")}
        >
          {"Cancel" -> React.string}
        </SecondaryButton>
      </div>
    </div>

    <div className="w-full border-secondary-bottom mt-44" />

    <div className="mt-44">
      <div className="text-h6 text-color-primary">{"Edit your password" -> React.string}</div>

      <div className="mt-24">
        <TextField
          value={oldPassword -> Signal.get}
          onChange={v => oldPassword -> Signal.set(v)}
          label="Old password"
          type_="password"
        />

        <div className="mt-24">
          <TextField
            value={newPassword -> Signal.get}
            onChange={v => newPassword -> Signal.set(v)}
            label="New password"
            type_="password"
          />
        </div>
      </div>

      <div className="d-flex gap-16 pt-32">
        <PrimaryButton
          disabled={isPasswordUpdateDisabled -> Signal.get}
          onClick={(_) => updatePassword() -> ignore}
        >
          {"Save" -> React.string}
        </PrimaryButton>

        <SecondaryButton
          onClick={(_) => clearPassword()}
        >
          {"Cancel" -> React.string}
        </SecondaryButton>
      </div>
    </div>

  </div>
}
