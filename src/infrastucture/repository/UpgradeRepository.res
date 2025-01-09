let get = async () => {
  let result: result<array<Upgrade.t>, AppError.t> = await Url.fromString("upgrades")
    -> Api.request({method: Get})

  result
}
