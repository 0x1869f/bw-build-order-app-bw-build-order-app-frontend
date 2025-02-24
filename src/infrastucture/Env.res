@scope(("import", "meta"))
@val external env: dict<string> = "env"

let baseUrl = env
  -> Dict.get("VITE_API_BASE_URL")
  -> Option.getUnsafe
