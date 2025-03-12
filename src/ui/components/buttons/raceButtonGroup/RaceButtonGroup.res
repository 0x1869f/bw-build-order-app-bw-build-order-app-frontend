@react.component
let make = (
  ~selected: Race.t,
  ~onSelect: (Race.t) => unit,
  ~label: string,
) => {
    let races = [Race.Protoss, Race.Terran, Race.Zerg]

    let buttons = () => races -> Array.map((race) => {
      <RaceButton
        key={race :> string}
        onClick={(_) => onSelect(race)}
        selected={selected == race}
        race={race}
      /> })

  <div>
    <div className="text-caption text-color-primary_selected pl-4 no-select">
      {label -> React.string}
    </div>

    <div className="d-flex gap-4 mt-8">
      {buttons() -> React.array}
    </div>
  </div>
}
