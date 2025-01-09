module X = {
  @module("lucide-react")
  @react.component
  external make: (~className: option<string>=?) => React.element = "X"
}

module Ban = {
  @module("lucide-react")
  @react.component
  external make: (~className: option<string>=?) => React.element = "Ban"
}
