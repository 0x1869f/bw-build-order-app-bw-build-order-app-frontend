%%raw("import './index.css'")

type variant = New | Edit(BuildOrder.t)

@react.component
let make = (~variant: variant) => {
  Signal.track()
  let racePickerIsDisabled = switch variant {
    | Edit(_) => true
    | New => false
  }
  
  let name = Signal.useSignal("")
  let playerRace = Signal.useSignal(Race.Protoss)
  let opponentRace = Signal.useSignal(Race.Protoss)
  let description: Signal.t<string> = Signal.useSignal("")
  let selectedTags: Signal.t<Dict.t<Tag.t>> = Dict.make() -> Signal.useSignal

  let buildOrderSteps: Signal.t<array<UiBuildOrderStep.t>> = Signal.useSignal([])

  let units: Signal.t<array<Unit.t>> = Signal.useSignal([])
  let buildings: Signal.t<array<Building.t>> = Signal.useSignal([])
  let upgrades: Signal.t<array<Upgrade.t>> = Signal.useSignal([])

  let tags = Signal.computed(() => {
    let race1 = playerRace -> Signal.get
    let race2 = opponentRace -> Signal.get

    let tags = race1 -> TagStorage.byRace
    race1 === race2
      ? tags
      : race2
        -> TagStorage.byRace
        -> Array.concat(tags, _)
  })


  let addStep = (element: BuildOrder.Step.item) => {
    let steps = buildOrderSteps -> Signal.get

    buildOrderSteps -> Signal.set([
      ...steps,
      UiBuildOrderStep.make(element)
    ])
  }

  let setSteps = (bo: BuildOrder.t) => {
    bo.steps
      -> Array.map(UiBuildOrderStep.fromStep)
      -> Signal.set(buildOrderSteps, _)
  }

  let setDefaultSteps = (race) => {
    let main = BuildingStorage.getMain(race) -> Option.getUnsafe
    let worker = UnitStorage.getWorker(race) -> Option.getUnsafe

    let steps = [
      UiBuildOrderStep.makeDefault(Building(main)),
      UiBuildOrderStep.makeDefault(Unit(worker)),
      UiBuildOrderStep.makeDefault(Unit(worker)),
      UiBuildOrderStep.makeDefault(Unit(worker)),
      UiBuildOrderStep.makeDefault(Unit(worker)),
    ]

    switch UnitStorage.getSupplyUnit(race) {
      | Some(value)  => Unit(value)
        -> UiBuildOrderStep.makeDefault
        -> Array.push(steps, _)
      | None => ()
    }

    buildOrderSteps -> Signal.set(steps)
  }

  let changePlayerRace = (race: Race.t) => {
    playerRace -> Signal.set(race)

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
  }

  React.useEffect0(() => {
    switch variant {
      | New => changePlayerRace(Race.Protoss)
      | Edit(bo) => {
        changePlayerRace(bo.race)
        setSteps(bo)
        name -> Signal.set(bo.name)
        opponentRace -> Signal.set(bo.opponentRace)
        name -> Signal.set(bo.name)
        bo.description -> Option.getOr("") -> Signal.set(description, _)
        bo.tags
          -> Array.map(tag => (tag.id, tag))
          -> Dict.fromArray
          -> Signal.set(selectedTags, _) 
      }
    }

    None
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

  let showOrHideComment = (step: UiBuildOrderStep.t, ~state: bool) => {
    buildOrderSteps -> Signal.set(
      buildOrderSteps -> Signal.get -> Array.map((s) => {
        if s.id === step.id {
          {
            ...s,
            comment: "",
            showComment: state,
          }
        } else {
          s
        }
      })
    )
  }

  let updateComment = (step: UiBuildOrderStep.t, comment: string) => {
    buildOrderSteps -> Signal.set(
      buildOrderSteps -> Signal.get -> Array.map((s) => {
        if s.id === step.id {
          {
            ...s,
            comment,
          }
        } else {
          s
        }
      })
    )
  }

  let stepCancelation = (step: UiBuildOrderStep.t) => {
    buildOrderSteps -> Signal.set(
      buildOrderSteps -> Signal.get -> Array.map((s) => {
        if s.id === step.id {
          {...s, isCanceled: !step.isCanceled}
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
    let actions = [
      <div key="comment">
        <Mui.Button
          onClick={(_) => showOrHideComment(step, ~state=!step.showComment)}
          variant={Mui.Button.Outlined}
        >
          {step.showComment
            ? <Lucide.MessageCircleOff />
            : <Lucide.MessageCircle />
          }
        </Mui.Button>
      </div>,
      <div key="cancel">
        <Mui.Button
          onClick={(_) => stepCancelation(step)}
          variant={Mui.Button.Outlined}
        >
          <Lucide.Ban color={step.isCanceled ? "red" : "currentColor"}/>
        </Mui.Button>
      </div>
    ]

    if step.supplyLimitUpBy > 0 {
      actions -> Array.push(
        <div key="delete-supply">
          <Mui.Button
            onClick={(_) => removeSupply(step)}
            variant={Mui.Button.Outlined}
          >
            {React.string(step.supplyLimitUpBy -> Int.toString)} <Icon.Close.Filled />
          </Mui.Button>
        </div>
    )} else {
      actions -> Array.push(increaseSupplyButtons(step))
    }

    if step.isRemovable {
      actions -> Array.push(
        <div key="delete">
          <Mui.Button
            onClick={(_) => removeStep(step)}
            variant={Mui.Button.Outlined}
          >
            <Icon.Close.Filled />
          </Mui.Button>
        </div>
      )
    }

    <div className="editor__build-order__item__action-buttons">{React.array(actions)}</div>
  }

  let save = async () => {
    let desc = description -> Signal.get

    let newBo: BuildOrder.new = {
      name: name -> Signal.get,
      description: desc -> String.length > 0
        ? Some(desc)
        : None,
      steps: buildOrderSteps -> Signal.get -> Array.map(UiBuildOrderStep.toStep),
      race: playerRace -> Signal.get,
      opponentRace: opponentRace -> Signal.get,
      links: [],
      tags: selectedTags -> Signal.get -> Dict.valuesToArray,
    }

    switch variant {
      | New => switch await BuildOrderStorage.create(newBo) {
        | Ok(_) => {
          MessageStore.notifyCreation(MessageStore.BuildOrder)
          Route.BuildOrderList -> Route.to
        }
        | Error(e) => MessageStore.notifyAppError(e, MessageStore.BuildOrder)
      }
      | Edit(bo) => switch await BuildOrderStorage.update(newBo, bo.id) {
        | Ok(_) => {
          MessageStore.notifyUpdate(MessageStore.BuildOrder)
          Route.BuildOrderList -> Route.to
        }
        | Error(e) => MessageStore.notifyAppError(e, MessageStore.BuildOrder)
      }
    }
  }

  let controls = Signal.useComputed(() => {
    <div className="form__actions">
      <Mui.Button
        size={Mui.Button.Small}
        onClick={(_) => save() -> ignore}
        variant={Mui.Button.Contained}
      >
      {"save" -> React.string}
      </Mui.Button>

      <Mui.Button
        size={Mui.Button.Small}
        onClick={(_) => Route.BuildOrderList -> Route.to}
        variant={Mui.Button.Outlined}
      >
      {"cancel" -> React.string}
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

    <div key={step.id} className="editor__build-order__item">
      <div className="editor__build-order__item-info">
        <img className="editor__panel__element-button__image" src={image} />
        <div className="editor__build-order__item__name">
          {React.string(name)}
        </div>
        {actions}
      </div>

      <div className="editor__build-order__item__comment">
        {step.showComment
          ? <Mui.TextField
            value={step.comment}
            multiline={true}
            minRows={3}
            maxRows={3}
            onChange={v => (v -> Form.stringValue).value -> updateComment(step, _)}
          />
          : <div />
        }
      </div>
    </div>
  }

  let buildOrder = Signal.computed(() => {
    buildOrderSteps
      -> Signal.get
      -> Array.map(makeBuildOrderElement)
  })

  <div>
    <div className="form__content">
      <div>
        <Mui.InputLabel>
          {React.string("Player race")}
        </Mui.InputLabel>

        <RacePicker
          value={playerRace -> Signal.get}
          onUpdate={(v) => changePlayerRace(v)}
          disabled={racePickerIsDisabled}
        />
      </div>

      <div>
        <Mui.InputLabel>
          {React.string("Opponent race")}
        </Mui.InputLabel>
        <RacePicker
          value={opponentRace -> Signal.get}
          onUpdate={(v) => opponentRace -> Signal.set(v)}
          disabled={racePickerIsDisabled}
        />
      </div>

      <TagSelector
        tags={tags -> Signal.get}
        selected={selectedTags -> Signal.get}
        onUpdate={v => selectedTags -> Signal.set(v)}
      />

      <div>
        <Mui.TextField
          value={name -> Signal.get}
          onChange={v => name -> Signal.set((v -> Form.stringValue).value)}
          label={"name *" -> React.string}
          />
      </div>

      <div>
        <Mui.TextField
          value={description -> Signal.get}
          multiline={true}
          minRows={3}
          maxRows={3}
          onChange={v => description -> Signal.set((v -> Form.stringValue).value)}
          label={"description" -> React.string}
        />
      </div>
    </div>

    <div className="editor__panel">
      <div>
        <Mui.Typography variant={H5}>
          {"Buildings" ->React.string}
        </Mui.Typography>
        <div className="editor__panel__button-group">
          {buildBuildingButtons -> Signal.get -> React.array}
        </div>
      </div>

      <div>
        <Mui.Typography variant={H5}>
          {"Units" ->React.string}
        </Mui.Typography>
        <div className="editor__panel__button-group">
          {buildUnitButtons -> Signal.get -> React.array}
        </div>
      </div>

      <div>
        <Mui.Typography variant={H5}>
          {"Upgrades" ->React.string}
        </Mui.Typography>
        <div className="editor__panel__button-group">
          {buildUpgradeButtons -> Signal.get -> React.array}
        </div>
      </div>
    </div>

    <div className="editor__build-order">
      <div className="editor__build-order__steps">
        <div>{buildOrder -> Signal.get -> React.array}</div>
      </div>
      <BuildOrderRenderer race={playerRace} steps={buildOrderSteps} hideWorkers={false} />
    </div>

    <div className="editor__controls">
      {controls -> Signal.get}
    </div>
  </div>
}
