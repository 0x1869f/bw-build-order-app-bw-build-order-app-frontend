let items: Map.t<Race.t, dict<Unit.t>> = Map.make()

let init = async () => {
  switch await UnitRepository.get() {
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

let getWorker = (race: Race.t) => {
  race
    -> getByRace
    -> Dict.valuesToArray
    -> Array.find((v) => v.type_ === Unit.Worker)
}

let getSupplyUnit = (race: Race.t) => {
  switch race {
    | Race.Zerg => Race.Zerg -> getByName("overlord")
    | _ => None
  }
}
