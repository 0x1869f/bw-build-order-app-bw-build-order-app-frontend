module Step = {
  type item = | @as(1) Building | @as(2) Unit | @as(3) Upgrade

  type t = {
    elementType: item,
    elementId: Id.t,
    isRemovable: bool,
    isCanceled: bool,
    supplyLimitUpBy: int,
    comment: option<string>,
  }

  let toBuildOrderStep = (step: t, race: Race.t): BuildOrder.Step.t => {
    {
      element: switch step.elementType {
        | Unit => UnitStorage.getByName(race, step.elementId)
          -> Option.getUnsafe
          -> BuildOrder.Step.Unit
        | Building=> BuildingStorage.getByName(race, step.elementId)
          -> Option.getUnsafe
          -> BuildOrder.Step.Building
        | Upgrade => UpgradeStorage.getByName(race, step.elementId)
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
    let (elementType, elementId) = switch step.element {
      | BuildOrder.Step.Unit(v) => (Unit, v.name)
      | BuildOrder.Step.Building(v) => (Building, v.name)
      | BuildOrder.Step.Upgrade(v) => (Upgrade, v.name)
    }

    {
      elementType,
      elementId,
      isRemovable: step.isRemovable,
      isCanceled: step.isCanceled,
      supplyLimitUpBy: step.supplyLimitUpBy,
      comment: step.comment,
    }
  }
}

module Info = {
  type t = {
    id: Id.t,
    name: string,
    race: Race.t,
    opponentRace: Race.t,
    tags: array<Id.t>,
    creator: Id.t,
  }

  let toBuildOrderInfo = (info: t): BuildOrder.Info.t => {
    id: info.id,
    name: info.name,
    race: info.race,
    opponentRace: info.opponentRace,
    tags: info.tags -> Array.map(t => t -> TagStorage.byId -> Option.getUnsafe),
    creator: info.creator,
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
  tags: bo.tags -> Array.map(t => t -> TagStorage.byId -> Option.getUnsafe),
}

let toBuildOrderInfo = (bo: t): BuildOrder.Info.t => {
  id: bo.id,
  name: bo.name,
  race: bo.race,
  opponentRace: bo.opponentRace,
  tags: bo.tags -> Array.map(t => t -> TagStorage.byId -> Option.getUnsafe),
  creator: bo.creator,
}

let fromNewBuildOrder = (bo: BuildOrder.new): new => {
  name: bo.name,
  description: bo.description,
  steps: bo.steps -> Array.map(Step.fromStep),
  race: bo.race,
  opponentRace: bo.opponentRace,
  links: bo.links,
  tags: bo.tags -> Array.map(t => t.id)
}
