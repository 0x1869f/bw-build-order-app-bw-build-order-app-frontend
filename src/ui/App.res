%%raw("import './global.css'")
%%raw("import './app.css'")

@react.component
let make = () => {
  Signal.track()

  let isLoading = Signal.useSignal(false)

  React.useEffect0(() => {
    isLoading -> Signal.set(true)

    Promise.all([
      RaceIconStorage.init(),
      UserStorage.init(),
      TagStorage.init(),
      BuildingStorage.init(),
      UnitStorage.init(),
      UpgradeStorage.init(),
      MapStorage.init(),
      BuildOrderStorage.init(),
      PlayerStorage.init(),
      ReplayStorage.init(),
      ExternalServiceIcon.init(),
    ])
      -> Promise.then((_) => {
        isLoading -> Signal.set(false)
        Promise.resolve()
     }) -> ignore

    None
  })

  let child = Signal.useComputed(() => 
    switch Route.currentRoute -> Signal.get {
      | Route.NewBuildOrder => <BuildOrderEditor variant={BuildOrderEditor.New} />
      | Route.BuildOrder(bo) => <BuildOrderPage bo={bo} />
      | Route.PlayerList => <PlayerList />
      | Route.ReplayList => <ReplayList />
      | Route.BuildOrderEditor(bo) => <BuildOrderEditor variant={BuildOrderEditor.Edit(bo)} />
      | Route.BuildOrderList => <BuildOrderList />
      | _ => <BuildOrderList />
    }
  )

  isLoading -> Signal.get
    // ? <Mui.LinearProgress />
    ? <Loader />

    : <Mui.StyledEngineProvider injectFirst=true>
      <div className="app">
        <Header />

        <Notification />

        <div className="pa-16">
          {child -> Signal.get}
          <SidePanel />
        </div>

        <Footer />
      </div>
    </Mui.StyledEngineProvider>
}
