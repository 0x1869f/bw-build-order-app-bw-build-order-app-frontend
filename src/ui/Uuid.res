type t = string

@scope("crypto")
external make: unit => t = "randomUUID"
