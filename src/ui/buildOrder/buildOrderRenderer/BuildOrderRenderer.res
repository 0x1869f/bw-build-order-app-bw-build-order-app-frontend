%%raw("import './index.css'")

let firstStepsByRace = (race: Race.t) => {
  switch race {
    | Race.Protoss => 5
    | Race.Terran => 5
    | Race.Zerg => 6
  }
}

@react.component
let make = (
  ~race: Signal.t<Race.t>,
  ~steps: Signal.t<array<UiBuildOrderStep.t>>,
  ~hideWorkers: bool = true,
) => {
  Signal.track()
  let makeBuildOrderElement = (step: UiBuildOrderStep.t, supply: int, supplyLimit: int) => {
    let (name, image) = switch step.element {
      | Building(value) => (value.name, value.image)
      | Unit(value) => (value.name, value.image)
      | Upgrade(value) => (value.name, value.image)
    }

    let cancellationStatus = step.isCanceled ? "renderer__build-order__item__card_canceled" : ""

    <div key={step.id} className="renderer__build-order__item">
      <div className={`renderer__build-order__item__card ${cancellationStatus}`}>
        <div className="renderer__build-order__item__element">
          <img className="renderer__build-order__item__image" src={image} />
          <div>{React.string(name)}</div>
        </div>
        <div className="renderer__build-order__item__supply">
          <span>{React.string(`${supply -> Int.toString}/${supplyLimit -> Int.toString}`)}</span>
        </div>
      </div>

      {step.comment -> String.length > 0
        ? <Mui.Typography variant={Body1}>{step.comment -> React.string}</Mui.Typography>
        : <div />
      }
    </div>
  }

  let buildOrder = Signal.computed(() => {
    let supply = ref(0)
    let supplyLimit = ref(0)
    let nodes = []
    let stepsToSkip = firstStepsByRace(race -> Signal.get)

    steps -> Signal.get -> Array.forEachWithIndex((step: UiBuildOrderStep.t, index) => {
      if step.supplyLimitUpBy > 0 {
        supplyLimit := supplyLimit.contents + step.supplyLimitUpBy
      }

      if step.isCanceled {
        switch step.element {
          | Unit(v)=> supply := supply.contents - v.supplyCost
          | Building(v) => {
              v.workerCost > 0 ? supply := supply.contents + v.workerCost : ()
          }
          | Upgrade(_)=> ()
        }
      } else {
        switch step.element {
          | Unit(v)=> supply := supply.contents + v.supplyCost
          | Building(v) => {
            if index >= stepsToSkip {
              v.workerCost > 0 ? supply := supply.contents - v.workerCost : ()
            }
          }
          | Upgrade(_)=> ()
        }
      }

      if index > stepsToSkip - 1 {
        if hideWorkers {
          let skip = switch step.element {
            | Unit(v) => v.type_ === Unit.Worker
            | _ => false
          }

          if !skip {
            nodes -> Array.push(makeBuildOrderElement(step, supply.contents, supplyLimit.contents))
          }
        } else {
          nodes -> Array.push(makeBuildOrderElement(step, supply.contents, supplyLimit.contents))
        }
      }
    })

    nodes
  })

  <div>
    <div>
      {buildOrder -> Signal.get -> React.array}
    </div>  
  </div>
}
