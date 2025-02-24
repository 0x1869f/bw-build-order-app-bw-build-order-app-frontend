type form<'t> = {
  value: 't
}

@get external stringValue: ReactEvent.Form.t => form<string> = "target"
