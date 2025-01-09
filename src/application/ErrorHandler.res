let lastError = Signal.useMake(AppError.DocumentDoesNotExist)

let inform = (err: AppError.t) => {
  lastError -> Signal.set(err)
}
