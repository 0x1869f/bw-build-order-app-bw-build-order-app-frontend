@react.component
let make = (
  ~selected: Race.t,
  ~onSelect: (Race.t) => unit,
  ~label: option<string>=?,
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
    {switch label {
      | Some(value) => <div className="text-caption text-color-primary_selected pl-4 no-select mb-8">
        {value -> React.string}
      </div>
      | None => <div />
    }}

    <div className="d-flex gap-4">
      {buttons() -> React.array}
    </div>
  </div>
}
