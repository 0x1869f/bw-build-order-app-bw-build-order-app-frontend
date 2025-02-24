type form = {
  files: array<Webapi.File.t>
}

@get external get: ReactEvent.Form.t => form = "target"
