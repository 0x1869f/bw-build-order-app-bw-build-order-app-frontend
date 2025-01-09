%%raw("import './Editor.css'")

module NameForm = {
  type t = {
    value: string
  }

  @get external target: ReactEvent.Form.t => t = "target"

  let value = (t: ReactEvent.Form.t) => {
    let v = t -> target

    v.value
  }
}

@react.component
let make = () => {
  Signal.track()
  
  let playerRace = Signal.useSignal(Race.Protoss)
  let opponentRace = Signal.useSignal(Race.Protoss)
  let units: Signal.t<array<Unit.t>> = Signal.useSignal([])
  let buildings: Signal.t<array<Building.t>> = Signal.useSignal([])
  let upgrades: Signal.t<array<Upgrade.t>> = Signal.useSignal([])
  let buildOrderName: Signal.t<string> = Signal.useSignal("")
  let description: Signal.t<string> = Signal.useSignal("")

  let buildOrderSteps: Signal.t<array<UiBuildOrderStep.t>> = Signal.useSignal([])

  let addStep = (element: BuildOrder.Step.item) => {
    let steps = buildOrderSteps -> Signal.get

    buildOrderSteps -> Signal.set([
      ...steps,
      { 
        id: Uuid.make(),
        comment: None,
        element,
        supplyLimitUpBy: 0,
        isRemovable: true,
        isCanceled: false,
      }
    ])
  }

  let buildDefaultStep = (element: BuildOrder.Step.item): UiBuildOrderStep.t => {
    let supplyLimitUpBy = switch element {
      | Building(v) => v.supply
      | Unit(v) => v.supply
      | Upgrade(_) => 0
    }

    {
      id: Uuid.make(),
      comment: None,
      element,
      isRemovable: false,
      isCanceled: false,
      supplyLimitUpBy,
    }
  }

  let setDefaultSteps = (race) => {
    let main = BuildingStorage.getMain(race) -> Option.getUnsafe
    let worker = UnitStorage.getWorker(race) -> Option.getUnsafe

    let steps = [
      buildDefaultStep(Building(main)),
      buildDefaultStep(Unit(worker)),
      buildDefaultStep(Unit(worker)),
      buildDefaultStep(Unit(worker)),
      buildDefaultStep(Unit(worker)),
    ]

    switch UnitStorage.getSupplyUnit(race) {
      | Some(value)  => Unit(value)
        -> buildDefaultStep
        -> Array.push(steps, _)
      | None => ()
    }

    buildOrderSteps -> Signal.set(steps)
  }

  Signal.useEffect(() => {
    let race = playerRace -> Signal.get

    race
      -> UnitStorage.getList
      -> Signal.set(units, _)
    race
      -> BuildingStorage.getList
      -> Signal.set(buildings, _)
    race
      -> UpgradeStorage.getList
      -> Signal.set(upgrades, _)
    race -> setDefaultSteps
  })

  let buildBuildingButtons = Signal.computed(() => {
    buildings -> Signal.get -> Array.map((building) => {
      <Mui.Button
        size={Mui.Button.Small}
        onClick={(_) => addStep(Building(building))}
        key={building.name}
      >
        <img className="editor__panel__element-button__image" src={building.image} />
      </Mui.Button>
    }
  )})

  let buildUnitButtons = Signal.computed(() => {
    units -> Signal.get -> Array.map((unit) => {
      <Mui.Button
        size={Mui.Button.Small}
        onClick={(_) => addStep(Unit(unit))}
        key={unit.name}
      >
        <img className="editor__panel__element-button__image" src={unit.image} />
      </Mui.Button>
    }
  )})

  let buildUpgradeButtons = Signal.computed(() => {
    upgrades -> Signal.get -> Array.map((upgrade) => {
      <Mui.Button
        size={Mui.Button.Small}
        onClick={(_) => addStep(Upgrade(upgrade))}
        key={upgrade.name}
      >
        <img className="editor__panel__element-button__image" src={upgrade.image} />
      </Mui.Button>
    }
  )})

  let removeStep = (step: UiBuildOrderStep.t) => {
    buildOrderSteps -> Signal.set(
      buildOrderSteps -> Signal.get -> Array.filter((v) => v.id !== step.id)
    )
  }

  let cancelStep = (step: UiBuildOrderStep.t) => {
    buildOrderSteps -> Signal.set(
      buildOrderSteps -> Signal.get -> Array.map((s) => {
        if s.id === step.id {
          {...s, isCanceled: true}
        } else {
          s
        }
      })
    )
  }

  let removeSupply = (step: UiBuildOrderStep.t) => {
    buildOrderSteps -> Signal.set(
      buildOrderSteps -> Signal.get -> Array.map((s) => {
        if s.id === step.id {
          {...s, supplyLimitUpBy: 0}
        } else {
          s
        }
      })
    )
  }

  let increaseSupply = (step: UiBuildOrderStep.t, size: int) => {
    buildOrderSteps -> Signal.set(
      buildOrderSteps -> Signal.get -> Array.map((s) => {
        if s.id === step.id {
          {...s, supplyLimitUpBy: size}
        } else {
          s
        }
      })
    )
  }

  let increaseSupplyButtons = (step) => {
    let race = playerRace -> Signal.get
    let main = BuildingStorage.getMain(race) -> Option.getUnsafe
    let supplyBuilding = BuildingStorage.getSupply(race)
    let supplyUnit = UnitStorage.getSupplyUnit(race)

    let (secondImage, secondSize) = {
      if supplyBuilding -> Option.isSome { 
        let supply = supplyBuilding -> Option.getUnsafe
        (supply.image, supply.supply)
      } else {
        let supply = supplyUnit -> Option.getUnsafe
        (supply.image, supply.supply)
      }
    }

    <div key="up-supply">
      <Mui.Button
        variant={Mui.Button.Outlined}
        onClick={(_) => increaseSupply(step, main.supply)}
      >
        <img className="editor__panel__element-button__image" src={main.image} />
      </Mui.Button>

      <Mui.Button
        variant={Mui.Button.Outlined}
        onClick={(_) => increaseSupply(step, secondSize)}
      >
        <img className="editor__panel__element-button__image" src={secondImage} />
      </Mui.Button>
    </div>
  }

  let buildElementActions = (step: UiBuildOrderStep.t) => {
    let actions = []

    if step.supplyLimitUpBy > 0 {
      actions -> Array.push(
        <div key="delete-supply">
          <Mui.Button
            onClick={(_) => removeSupply(step)}
            variant={Mui.Button.Outlined}
          >
            {React.string(step.supplyLimitUpBy -> Int.toString)} <Lucide.X />
          </Mui.Button>
        </div>
    )} else {
      actions -> Array.push(increaseSupplyButtons(step))
    }

    if !step.isCanceled {
      actions -> Array.push(
        <div key="cancel">
          <Mui.Button
            onClick={(_) => cancelStep(step)}
            variant={Mui.Button.Outlined}
          >
            <Lucide.Ban />
          </Mui.Button>
        </div>
      )
    }

    if step.isRemovable {
      actions -> Array.push(
        <div key="delete">
          <Mui.Button
            onClick={(_) => removeStep(step)}
            variant={Mui.Button.Outlined}
          >
            <Lucide.X />
          </Mui.Button>
        </div>
      )
    }

    <div className="editor__build-odrder__item__action-buttons">{React.array(actions)}</div>
  }

  let save = async () => {
    let desc = description -> Signal.get

    let newBo: BuildOrder.new = {
      name: buildOrderName -> Signal.get,
      description: desc -> String.length > 0
        ? Some(desc)
        : None,
      steps: buildOrderSteps -> Signal.get -> Array.map(UiBuildOrderStep.toStep),
      race: playerRace -> Signal.get,
      opponentRace: opponentRace -> Signal.get,
      links: [],
      tags: [],
    }

    switch await BuildOrderStorage.create(newBo) {
      | Ok(_) => ()
      | Error(e) => ErrorHandler.inform(e)
    }
  }

  let controls = Signal.useComputed(() => {
    <div>
      <Mui.Button
        size={Mui.Button.Small}
        onClick={(_) => save() -> ignore}
        variant={Mui.Button.Outlined}
      >
      {"save" -> React.string}
      </Mui.Button>
    </div>
  })

  let makeBuildOrderElement = (step: UiBuildOrderStep.t) => {
    let (name, image) = switch step.element {
      | Building(value) => (value.name, value.image)
      | Unit(value) => (value.name, value.image)
      | Upgrade(value) => (value.name, value.image)
    }

    let actions = step.isRemovable
      ? buildElementActions(step)
      : <div />

    <div key={step.id} className="editor__build-odrder__item">
      <img className="editor__panel__element-button__image" src={image} />
      <div className="editor__build-odrder__item__name">
        {React.string(name)}
      </div>
      {actions}
    </div>
  }

  let buildOrder = Signal.computed(() => {
    buildOrderSteps -> Signal.get -> Array.map((step) => {
      makeBuildOrderElement(step)
    })
  })

  <div>
    <div>
      <RacePicker value={playerRace} onUpdate={(v) => playerRace -> Signal.set(v)}/>
      <Mui.Divider orientation={Mui.Divider.Vertical} variant={Mui.Divider.Middle} flexItem={true} />
      <RacePicker value={opponentRace} onUpdate={(v) => opponentRace -> Signal.set(v)}/>
    </div>

    <div className="editor__panel">
      <div>
        <span>{React.string("Buildings")}</span>
        <div className="editor__panel__button-group">
          {buildBuildingButtons -> Signal.get -> React.array}
        </div>
      </div>

      <div>
        <span>{React.string("Units")}</span>
        <div className="editor__panel__button-group">
          {buildUnitButtons -> Signal.get -> React.array}
        </div>
      </div>

      <div>
        <span>{React.string("Upgrades")}</span>
        <div className="editor__panel__button-group">
          {buildUpgradeButtons -> Signal.get -> React.array}
        </div>
      </div>
    </div>

    <div className="editor__build-order">
      <div className="editor__build-order__steps">
        <div>{React.array(buildOrder -> Signal.get)}</div>
      </div>
      <Renderer race={playerRace} steps={buildOrderSteps} />
    </div>

    <div className="editor__controls">
      {controls -> Signal.get}
    </div>
  </div>
}
