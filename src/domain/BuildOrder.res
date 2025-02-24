module Step = {
  type item = Building(Building.t) | Unit(Unit.t) | Upgrade(Upgrade.t)

  type t = {
    element: item,
    isRemovable: bool,
    isCanceled: bool,
    supplyLimitUpBy: int,
    comment: option<string>,
  }

  let supplyIsUp = (step: t) => step.supplyLimitUpBy > 0
}

module Info = {
  type t = {
    id: Id.t,
    name: string,
    race: Race.t,
    opponentRace: Race.t,
    tags: array<Tag.t>,
    creator: Id.t,
  }
}

type new = {
  name: string,
  description: option<string>,
  steps: array<Step.t>,
  race: Race.t,
  opponentRace: Race.t,
  links: array<string>,
  tags: array<Tag.t>
}

type t = {
  id: Id.t,
  creator: Id.t,
  name: string,
  description: option<string>,
  steps: array<Step.t>,
  race: Race.t,
  opponentRace: Race.t,
  links: array<string>,
  tags: array<Tag.t>
}

