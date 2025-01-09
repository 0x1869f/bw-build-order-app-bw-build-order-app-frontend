let items: Map.t<Race.t, dict<Building.t>> = Map.make()

let init = async () => {
  switch await BuildingRepository.get() {
    | Ok(value) => {
      let protoss = Dict.make()
      let terran = Dict.make()
      let zerg = Dict.make()

      value -> Array.forEach((b) => {
        switch b.race {
          | Race.Protoss => protoss
          | Race.Terran => terran
          | Race.Zerg => zerg
        } -> Dict.set((b.name), b)
      })

      items -> Map.set(Race.Protoss, protoss)
      items -> Map.set(Race.Terran, terran)
      items -> Map.set(Race.Zerg, zerg)
    } 
  | Error(_) => ()
  }
}

let getByRace = (race: Race.t) => {
  items -> Map.get(race) -> Option.getOr(Dict.make())
}

let getList = (race: Race.t) => {
  race -> getByRace -> Dict.valuesToArray
}

let getByName = (race: Race.t, name: string) => {
  race -> getByRace -> Dict.get(name)
}

let getMain = (race: Race.t) => {
  let name = switch race {
    | Race.Protoss => "nexus"
    | Race.Terran => "command center"
    | Race.Zerg => "hatchery"
  }

  race -> getByRace -> Dict.get(name)
}

let getSupply = (race: Race.t) => {
  let name = switch race {
    | Race.Protoss => Some("pylon")
    | Race.Terran => Some("supply depot")
    | _ => None
  }

  name -> Option.isSome
    ? race -> getList -> Array.find((v) => v.name === name -> Option.getUnsafe)
    : None
}
