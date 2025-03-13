type navigationItem = {
  route: Route.t,
  text: string,
}

let routes = [
  {
    route: Route.BuildOrderList,
    text: "Build orders",
  },
  // {
  //   route: Route.ReplayList,
  //   text: "Replays",
  // },
  // {
  //   route: Route.PlayerList,
  //   text: "Players",
  // }
]


@react.component
let make = () => {
  let navigation = routes -> Array.map(r => {
    let isCurrent = Route.currentRoute -> Signal.get === r.route

    <TabButton
      key={r.text}
      onClick={_ => r.route -> Route.to}
      selected={isCurrent}
    >
        {r.text -> React.string}
    </TabButton>
  })

  <div className="d-flex gap-24">{navigation -> React.array}</div>
}
