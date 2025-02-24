type new = {
  name: string,
}

type t = {
  ...new,
  id: Id.t,
  image: option<string>,
}
