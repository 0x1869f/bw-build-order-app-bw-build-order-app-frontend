module New = {
  type t = {
    race: Race.t,
    nickname: string,
    bio: option<string>,
    twitch: option<string>,
    soop: option<string>,
    liquipedia: option<string>,
  }
}

type t = {
  id: Id.t,
  creator: Id.t,
  ...New.t,
}
