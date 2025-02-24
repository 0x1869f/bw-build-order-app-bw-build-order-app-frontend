type t = | @as("protoss") Protoss | @as("terran") Terran | @as("zerg") Zerg

external toString: t => string = "%identity"

let firstLetter = (race: t) => {
  (race :> string)
    -> String.slice(~start=0, ~end=1)
    -> String.toUpperCase
}
