type role = | @as(0) Root | @as(1) Admin | @as(2) User

type t = {
  id: Id.t,
  nickname: string,
  role: role,
}

