type new = {
  description: option<string>,
  map: Id.t,
  player: Id.t,
  race: Race.t,
  buildOrder: Id.t,
  secondPlayer: option<Id.t>,
  secondRace: Race.t,
  secondBuildOrder: option<Id.t>,
}

type t = {
  file: option<string>,
  id: Id.t,
  creator: Id.t,
  ...new,
}
