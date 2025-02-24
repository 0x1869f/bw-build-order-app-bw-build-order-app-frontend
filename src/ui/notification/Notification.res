%%raw("import './Notification.css'")

@react.component
let make = () => {
  Signal.track()

  let items = Signal.computed(() => MessageStore.errors
    -> Signal.get
    -> Array.map((message) => {
        <Mui.Alert key={message.id} severity={message.severity}>
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
