%%raw("import './RacePicker.css'")

type raceInfo = {
  name: Race.t,
  image: string,
}

 @react.component
 let make = (
   ~value: Signal.t<Race.t>,
   ~onUpdate: (Race.t) => unit) => {
  let races = [
    {
      name: Race.Protoss,
      image: "",
    },
    {
      name: Race.Terran,
      image: "",
    },
    {
      name: Race.Zerg,
      image: "",
    },
  ]

  let buildRaceOptions = Signal.computed(() => {
    races -> Array.map((race) => {
      let color = race.name === value -> Signal.get
        ? Mui.Button.Primary
        : Mui.Button.Inherit

      <Mui.Button
        className="race-picker__button"
        color={color}
        onClick={(_) => onUpdate(race.name)}
        variant={Mui.Button.Contained}
        key={race.image}
      >
        <img
          className="race-picker__icon"
          src={race.image}
        />
      </Mui.Button>
    })
  })

  <div>
    <Mui.ButtonGroup>
      {buildRaceOptions -> Signal.get -> React.array}
    </Mui.ButtonGroup>
  </div>
}
