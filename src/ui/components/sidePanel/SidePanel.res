%%raw("import './index.css'")

@react.component
let make = (
) => {
  Signal.track()

  let panelStyle = Signal.computed(() => SidePanelStorage.isShown -> Signal.get
    ? "side-panel side-panel_active"
    : "side-panel"
  )

  let containerStyle = Signal.computed(() => SidePanelStorage.isShown -> Signal.get
    ? "side-panel__container side-panel__container_active"
    : "side-panel__container"
  )

  let content = Signal.computed(() => {
    <div className={containerStyle -> Signal.get}>
      <div className="side-panel__container__title d-flex justify-space-between pa-32">
        <div className="text-h5 text-color-primary">
          {SidePanelStorage.title -> Signal.get -> React.string}
        </div>

        <IconButton onClick={_ => {
          SidePanelStorage.closePanel()
        }}>
          <Lucide.X size={16} />
        </IconButton>
      </div>

      <div className="side-panel__content">
        {SidePanelStorage.content -> Signal.get}
      </div>
    </div>
  })

  <div className={panelStyle -> Signal.get}>
    {content -> Signal.get}
  </div>
}
