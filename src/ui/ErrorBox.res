@react.component
let make = (~message: Signal.t<option<string>>) => {
  switch message -> Signal.get {
    | Some(message) => <div>{message -> React.string}</div>
    | None => <div></div>
  }
}
