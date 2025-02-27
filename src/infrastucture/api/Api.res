open Http

let request = async (url: Url.t, config: Request.config): result<'b, AppError.t> => {
  let r = await fetchWithRequest(Request.fromConfig(url, config))

  switch r -> Response.status {
    | 200 => Ok(await r -> Response.json)
    | 201 => Ok(await r -> Response.json)
    | 204 => Ok(await r -> Response.json)
    | 301 => Error(DocumentRelocated)
    | 302 => Error(DocumentRelocated)
    | 400 => Error(InvalidData(r -> Response.statusText))
    | 401 => Error(Unauthorized)
    | 404 => Error(DocumentDoesNotExist)
    | 409 => Error(Conflict)
    | _ => Error(ServiceError)
  }
}

let jsonRequest = async (url: Url.t, config: Request.config) => {
  let newConfig = {
    ...config,
    headers: switch config.headers {
      | Some(headers) => {
        headers -> Headers.append("Content-Type", "application/json")
        headers
      }
      | None => [("Content-Type", "application/json")]
        -> Dict.fromArray
        -> Headers.makeWithConfig
    }
  }

  await request(url, newConfig)
}

let requestWithAuth = async (url: Url.t, config: Request.config) => {
  switch LocalStorage.get(Token) {
    | Some(token) => {
      let newConfig = {
        ...config,
        headers: switch config.headers {
          | Some(headers) => {
            headers -> Headers.append("authorization", `Bearer ${token}`)
            headers
          }
          | None => Headers.makeWithConfig(Dict.fromArray([("authorization", `Bearer ${token}`)]))
        }
      }

      await request(url, newConfig)
    }
    | None => Error(AppError.Unauthorized)
  }
}

let jsonRequestWithAuth = async (url: Url.t, config: Request.config) => {
  switch LocalStorage.get(Token) {
    | Some(token) => {
      let newConfig = {
        ...config,
        headers: switch config.headers {
          | Some(headers) => {
            headers -> Headers.append("authorization", `Bearer ${token}`)
            headers
          }
          | None => [("authorization", `Bearer ${token}`)]
            -> Dict.fromArray
            -> Headers.makeWithConfig
        }
      }

      await jsonRequest(url, newConfig)
    }
    | None => Error(AppError.Unauthorized)
  }
}
