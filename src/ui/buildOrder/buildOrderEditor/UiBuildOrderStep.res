type t = {
  element: BuildOrder.Step.item,
  isRemovable: bool,
  isCanceled: bool,
  supplyLimitUpBy: int,
  comment: string,
  id: Uuid.t,
  showComment: bool,
}

let fromStep = (step: BuildOrder.Step.t) => {
  id: Uuid.make(),
  element: step.element,
  isRemovable: step.isRemovable,
  isCanceled: step.isCanceled,
  supplyLimitUpBy: step.supplyLimitUpBy,
  comment: switch step.comment {
    | Some(v) => v
    | None => ""
  },
  showComment: step.comment -> Option.isSome,
}

let toStep = (step: t): BuildOrder.Step.t => {
  element: step.element,
  isRemovable: step.isRemovable,
  isCanceled: step.isCanceled,
  supplyLimitUpBy: step.supplyLimitUpBy,
  comment: step.comment -> String.length > 0
    ? Some(step.comment)
    : None,
}

let make = (element: BuildOrder.Step.item): t => {
  {
    id: Uuid.make(),
    comment: "",
    element,
    isRemovable: true,
    isCanceled: false,
    supplyLimitUpBy: 0,
    showComment: false,
  }
}

let makeDefault = (element: BuildOrder.Step.item): t => {
  let supplyLimitUpBy = switch element {
    | Building(v) => v.supply
    | Unit(v) => v.supply
    | Upgrade(_) => 0
  }

  {
    id: Uuid.make(),
    comment: "",
    element,
    isRemovable: false,
    isCanceled: false,
    supplyLimitUpBy,
    showComment: false,
  }
}
