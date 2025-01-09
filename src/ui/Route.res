type t =
  | @as("/build-order-list") BuildOrderList
  | @as("/new-build-order") NewBuildOrder

external url: t => string = "%identity"
