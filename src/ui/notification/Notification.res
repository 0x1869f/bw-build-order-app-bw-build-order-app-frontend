%%raw("import './Notification.css'")

let severityToMuiSeverity = (severity: MessageStore.severity): Mui.Alert.severity => {
  switch severity {
    | MessageStore.Error => Mui.Alert.Error
    | MessageStore.Success => Mui.Alert.Success
    | MessageStore.Warning => Mui.Alert.Warning
  }
}

@react.component
let make = () => {
  Signal.track()

  let items = Signal.computed(() => MessageStore.errors
    -> Signal.get
    -> Array.map((message) => {
        <Mui.Alert key={message.id} severity={message.severity -> severityToMuiSeverity}>
          <Mui.AlertTitle>
            {message.title -> React.string}
          </Mui.AlertTitle>
          {message.text -> React.string}
        </Mui.Alert>
  }))

  <div className="notification">
    {items -> Signal.get -> React.array}
  </div>
}
