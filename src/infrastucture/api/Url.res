type t

external convertToUrl: string => t = "%identity"

let make = (
  path: array<string>,
  ~params: option<dict<string>>=?,
  ~query: option<dict<string>>=?
): t => {
  let pathString = ref(Env.baseUrl)

  switch params {
    | Some(value) => path -> Array.forEach((p) => {
      switch value -> Dict.get(p) {
        | Some(param) => pathString := `${pathString.contents}/${p}/${param}`
        | None => pathString := `${pathString.contents}/${p}`
      }
    })
    | None => pathString := `${pathString.contents}/${path -> Array.join("/")}`
  }

  switch query {
    | Some(value) => value -> Dict.forEachWithKey((v, k) => {
      pathString := `${pathString.contents}?${v}=${k}/`
    })
    | None => ()
  }

  pathString.contents -> convertToUrl
}

let fromString = (path: string): t => {
  `${Env.baseUrl}/${path}` -> convertToUrl
}
