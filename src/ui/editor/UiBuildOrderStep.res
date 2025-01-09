type t = {
  ...BuildOrder.Step.t,
  id: Uuid.t,
}

let toStep = (step: t): BuildOrder.Step.t => {
  element: step.element,
  isRemovable: step.isRemovable,
  isCanceled: step.isCanceled,
  supplyLimitUpBy: step.supplyLimitUpBy,
  comment: step.comment,
}

