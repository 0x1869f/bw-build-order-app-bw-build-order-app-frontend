type new = {
  name: string,
  race: Race.t,
}

type t = {
  ...new,
  id: Id.t,
}

let cmp = (a: t, b: t) => a.id === b.id ? 1 : 0
