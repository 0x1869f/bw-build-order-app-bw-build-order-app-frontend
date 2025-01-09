type unitType = | @as(0) Worker | @as(1) BattleUnit

type t = {
  race: Race.t,
  type_: unitType,
  name: string,
  image: string,
  supplyCost: int,
  supply: int,
}

