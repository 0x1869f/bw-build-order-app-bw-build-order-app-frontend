@scope(("import", "meta"))
@val external env: dict<string> = "env"

// let baseUrl = NodeJs.Process.process
//   -> NodeJs.Process.env
//   -> Dict.get("BASE_URL")
//   -> Option.getUnsafe

let baseUrl = env
  -> Dict.get("VITE_API_BASE_URL")
  -> Option.getUnsafe
