type navigationItem = {
  route: Route.t,
  text: string,
}

let routes = [{
  route: Route.BuildOrderList,
  text: "build orders",
},
{
  route: Route.ReplayList,
  text: "replays",
},
{
  route: Route.PlayerList,
  text: "players",
}]


@react.component
let make = () => {
  let navigation = routes -> Array.map(r => {
    let color = Route.currentRoute -> Signal.get === r.route ? Mui.Button.Secondary : Mui.Button.Primary

    <Mui.Button
      key={r.text}
      onClick={_ => r.route -> Route.to}
      size={Large}
      color={color}
      variant={Text}>
        {r.text -> React.string}
    </Mui.Button>
  })

  <div>{navigation -> React.array}</div>
}
