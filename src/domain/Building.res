type t = {
  race: Race.t,
  name: string,
  image: string,
  requiredBuilding: array<Id.t>,
  workerCost: int,
  supply: int,
}
