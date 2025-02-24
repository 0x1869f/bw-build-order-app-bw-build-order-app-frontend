%%raw("import './RacePicker.css'")

@react.component
let make = (
  ~value: Race.t,
  ~onUpdate: (Race.t) => unit,
  ~disabled: bool = false,
) => {
Signal.track()

let buildRaceOptions = () => RaceIconStorage.getList() -> Iterator.toArrayWithMapper((race) => {
    let (name, icon) = race

    let color = name === value
      ? Mui.Button.Primary
      : Mui.Button.Inherit

    let isDisabled = disabled && name !== value

    <Mui.Button
      className="race-picker__button"
      color={color}
      disabled={isDisabled}
      onClick={(_) => onUpdate(name)}
      variant={Mui.Button.Contained}
      key={name :> string}
    >
      <img
        className="race-picker__icon"
        src={icon}
      />
    </Mui.Button>
  })

<div>
  <Mui.ButtonGroup>
    {buildRaceOptions() -> React.array}
  </Mui.ButtonGroup>
</div>
}
