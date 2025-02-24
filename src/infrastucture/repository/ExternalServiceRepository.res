type payload = {
  name: ExternalService.t,
  icon: string,
}

let get = async () => {
  let url = Url.fromString("external-service")

  let result: result<array<payload>, AppError.t> = await url
    -> Api.request({method: Get})

  result
}
