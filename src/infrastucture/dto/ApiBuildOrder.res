module Step = {
  type item = Building(Id.t) | Unit(Id.t) | Upgrade(Id.t)

  type t = {
    element: item,
    isRemovable: bool,
    isCanceled: bool,
    supplyLimitUpBy: int,
    comment: option<string>,
  }

  let toBuildOrderStep = (step: t, race: Race.t): BuildOrder.Step.t => {
    {
      element: switch step.element {
        | Unit(v) => UnitStorage.getByName(race, v)
          -> Option.getUnsafe
          -> BuildOrder.Step.Unit
        | Building(v)=> BuildingStorage.getByName(race, v)
          -> Option.getUnsafe
          -> BuildOrder.Step.Building
        | Upgrade(v) => UpgradeStorage.getByName(race, v)
          -> Option.getUnsafe
          -> BuildOrder.Step.Upgrade
      },
      isRemovable: step.isRemovable,
      isCanceled: step.isCanceled,
      supplyLimitUpBy: step.supplyLimitUpBy,
      comment: step.comment,
    }
  }

  let fromStep = (step: BuildOrder.Step.t): t => {
    element: switch step.element {
      | Unit(v) => Unit(v.name)
      | Building(v) => Building(v.name)
      | Upgrade(v) => Upgrade(v.name)
    },
    isRemovable: step.isRemovable,
    isCanceled: step.isCanceled,
    supplyLimitUpBy: step.supplyLimitUpBy,
    comment: step.comment,
  }
}

type new = {
  name: string,
  description: option<string>,
  steps: array<Step.t>,
  race: Race.t,
  opponentRace: Race.t,
  links: array<string>,
  tags: array<Id.t>
}

type t = {
  ...new,
  id: Id.t,
  creator: Id.t,
}

let toBuildOrder = (bo: t): BuildOrder.t => {
  id: bo.id,
  name: bo.name,
  description: bo.description,
  creator: bo.creator,
  steps: bo.steps -> Array.map(v => Step.toBuildOrderStep(v, bo.race)),
  race: bo.race,
  opponentRace: bo.opponentRace,
  links: bo.links,
  tags: bo.tags,
}

let toBuildOrderInfo = (bo: t): BuildOrder.Info.t => {
  id: bo.id,
  name: bo.name,
  race: bo.race,
  opponentRace: bo.opponentRace,
}

let fromNewBuildOrder = (bo: BuildOrder.new): new => {
  name: bo.name,
  description: bo.description,
  steps: bo.steps -> Array.map(Step.fromStep),
  race: bo.race,
  opponentRace: bo.opponentRace,
  links: bo.links,
  tags: bo.tags
}
