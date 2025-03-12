%%raw("import './index.css'")

@react.component
let make = (
  ~onClick: unit => unit,
  ~children: React.element,
  ~icon: option<React.element>=?,
) => {
  <button
    onClick={(e) => {
      e -> ReactEvent.Mouse.stopPropagation
      onClick()
    }}
    className="secondary-button text-button"
  >
    <div className="secondary-button__container h-40 d-flex border-box w-max-content">
      {switch icon {
        | Some(v) => <div className="pr-8">{v}</div>
        | None => <div />
      }}
      <div className="secondary-button__text">{children}</div>
    </div>
  </button>
}
