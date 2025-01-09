%%raw("import './App.css'")

@react.component
let make = () => {
  Signal.track()

  UserStorage.init() -> ignore
  TagStorage.init() -> ignore
  BuildingStorage.init() -> ignore
  UnitStorage.init() -> ignore
  UpgradeStorage.init() -> ignore
  MapStorage.init() -> ignore


  let route = Signal.useSignal(Route.BuildOrderList)

  let watcherId = RescriptReactRouter.watchUrl((url) => {
    route -> Signal.set(switch url.path {
      | list{"new-build-order"} => Route.NewBuildOrder
      | _ => Route.BuildOrderList
    })
  })

  React.useEffect(() => {
    Some(() => RescriptReactRouter.unwatchUrl(watcherId))
  }, [])

  let page = Signal.useComputed(() => {
    let child = switch route -> Signal.get {
      | Route.NewBuildOrder => <Editor />
      | Route.BuildOrderList => <BuildOrderList />
    }

    <div>
      <Header />
      child
    </div>
  })

      

  page -> Signal.get
}
