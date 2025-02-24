type t = Webapi.FormData.t

@send external appendFile: (t, string, Webapi.File.t) => unit = "append"
