%%raw("import './index.css'")

@react.component
let make = (
  ~race: Race.t,
  ~selected: bool,
  ~onClick: () => unit,
  ~children: React.element,
) => {
  let raceStyle = `text-caption-small race-chip__${race :> string}`

  let style = selected
      ? `${raceStyle} ${raceStyle}_selected`
      : raceStyle

  <div className="bg-global radius">
    <button className={`race-chip ${style}`} onClick={(e) => {
      e -> ReactEvent.Mouse.stopPropagation
      onClick()
    }}>
      {children}
    </button>
  </div>
}
