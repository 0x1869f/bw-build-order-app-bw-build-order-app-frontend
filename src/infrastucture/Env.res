@scope(("import", "meta"))
@val external devEnv: dict<string> = "env"

@scope("window")
@val
external windowApiBaseUrl: Nullable.t<string> = "APP_API_BASE_URL"


let baseUrl = switch windowApiBaseUrl -> Nullable.toOption {
  | Some(value) => value
  | None => devEnv
    -> Dict.get("VITE_API_BASE_URL")
    -> Option.getUnsafe
}
