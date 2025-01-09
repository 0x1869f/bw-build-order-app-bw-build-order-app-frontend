type key = | @as("token") Token

let get = (key: key) => Dom.Storage2.localStorage -> Dom.Storage2.getItem(key :> string)
let set = (key: key, value: string) => Dom.Storage2.localStorage -> Dom.Storage2.setItem(key :> string, value)
let delete = (key: key) => Dom.Storage2.localStorage -> Dom.Storage2.removeItem(key :> string)
