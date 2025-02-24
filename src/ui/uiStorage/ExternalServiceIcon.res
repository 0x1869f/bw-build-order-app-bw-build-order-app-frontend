let icons: Map.t<ExternalService.t, string> = Map.make()

let getIcon = (service: ExternalService.t) => {
  icons
    -> Map.get(service)
    -> Option.getUnsafe
}

let init = async () => {
  switch await ExternalServiceRepository.get() {
    | Ok(list) =>  list
      -> Array.forEach((v) => icons -> Map.set(v.name, v.icon))
    | Error(_) => ()
  }
}

