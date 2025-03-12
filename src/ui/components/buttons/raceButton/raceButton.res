%%raw("import './index.css'")

@react.component
let make = (
  ~race: Race.t,
  ~selected: bool,
  ~onClick: () => unit,
) => {
  let icon = race -> RaceIconStorage.getByRace
  let raceStyle = `race-button__${race :> string}`

  let style = selected
      ? `${raceStyle} ${raceStyle}_selected`
      : raceStyle

  <div className="bg-global radius">
    <button className={`race-button ${style}`} onClick={(_) => onClick()}>
      <img className="icon" src={icon}/>
    </button>
  </div>
}
