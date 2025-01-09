type requestMethod =
  | @as("GET") Get
  | @as("HEAD") Head
  | @as("POST") Post
  | @as("PUT") Put
  | @as("DELETE") Delete
  | @as("CONNECT") Connect
  | @as("OPTIONS") Options
  | @as("TRACE") Trace
  | @as("PATCH") Patch
  | Other(string)

type referrerPolicy =
  | None
  | NoReferrer
  | NoReferrerWhenDowngrade
  | SameOrigin
  | Origin
  | StrictOrigin
  | OriginWhenCrossOrigin
  | StrictOriginWhenCrossOrigin
  | UnsafeUrl

type requestDestination =
  | None /* default? unknown? just empty string in spec */
  | Document
  | Embed
  | Font
  | Image
  | Manifest
  | Media
  | Object
  | Report
  | Script
  | ServiceWorker
  | SharedWorker
  | Style
  | Worker
  | Xslt

type requestMode =
  | Navigate
  | SameOrigin
  | NoCORS
  | CORS

type requestCredentials =
  | Omit
  | SameOrigin
  | Include

type requestCache =
  | Default
  | NoStore
  | Reload
  | NoCache
  | ForceCache
  | OnlyIfCached

type requestRedirect =
  | Follow
  | Error
  | Manual

module Body = {
  type t

  external make: string => t = "%identity"
  external makeWithBlob: Webapi.Blob.t => t = "%identity"
  // external makeWithBufferSource: bufferSource => t = "%identity"
  external makeWithFormData: Webapi.FormData.t => t = "%identity"
  // external makeWithUrlSearchParams: urlSearchParams => t = "%identity"
}

module Headers = {
  type t

  @new external make: t = "Headers"
  @new external makeWithConfig: dict<string> => t = "Headers"

  @send external append: (t, string, string) => unit = "append"
  @send external delete: (t, string) => unit = "delete"
  /* entries */ /* very experimental */
  @send @return(null_to_opt)
  external get: (t, string) => option<string> = "get"
  @send external has: (t, string) => bool = "has"
  /* keys */ /* very experimental */
  @send external set: (t, string, string) => unit = "set"
  /* values */
  /* very experimental */
}


module Response = {
  type t

  @new external make: string => t = "Response"
  @new external makeWithResponse: t => t = "Response"

  @val external error: unit => t = "error"
  @val external redirect: string => t = "redirect"
  @val external redirectWithStatus: (string, int /* enum-ish */) => t = "redirect"
  @get external headers: t => Headers.t = "headers"
  @get external ok: t => bool = "ok"
  @get external redirected: t => bool = "redirected"
  @get external status: t => int = "status"
  @get external statusText: t => string = "statusText"
  @get external type_: t => string = "type"
  @get external url: t => string = "url"

  @send external clone: t => t = "clone"

  /* Body.Impl */
  // @get external body: t => readableStream = "body"
  @get external bodyUsed: t => bool = "bodyUsed"

  @send external arrayBuffer: t => Js.Promise.t<NodeJs.Buffer.t> = "arrayBuffer"
  @send external blob: t => Js.Promise.t<Webapi.Blob.t> = "blob"
  @send external formData: t => Js.Promise.t<Webapi.FormData.t> = "formData"
  @send external json: t => Js.Promise.t<'a> = "json"
  @send external text: t => Js.Promise.t<string> = "text"
}

module Request = {
  type t

  type config = {
    method?: requestMethod,
    headers?: Headers.t,
    body?: Body.t,
    referrer?: string,
    referrerPolicy?: referrerPolicy,
    mode?: requestMode,
    credentials?: requestCredentials,
    cache?: requestCache,
    redirect?: requestRedirect,
    integrity?: string,
    keepalive?: bool,
    signal?: Webapi.Fetch.AbortController.signal,

  }

  @new external make: Url.t => t = "Request"
  @new external fromConfig: (Url.t, config) => t = "Request"
}

@val external fetch: Url.t => Js.Promise.t<Response.t> = "fetch"
@val external fetchWithRequest: Request.t => Js.Promise.t<Response.t> = "fetch"
