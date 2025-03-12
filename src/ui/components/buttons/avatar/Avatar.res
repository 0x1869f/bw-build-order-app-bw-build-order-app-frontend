%%raw("import './index.css'")

@react.component
let make = (
  ~name: string,
  ~onClick: unit => unit,
) => {
  <button
    className="avatar border-secondary text-h6 radius-full"
    onClick={_ => onClick()}
  >
    {name
      -> String.slice(~start=0, ~end=1)
      -> String.toUpperCase
      -> React.string
    }
  </button>
}
