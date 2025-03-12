%%raw("import './index.css'")

@react.component
let make = (
  ~children: React.element,
  ~onClick: unit => unit,
  ~disabled: bool=false,
) => {
  <button
    disabled={disabled}
    className="icon-button"
    onClick={(e) => {
      e -> ReactEvent.Mouse.stopPropagation
      onClick()
    }}
  >
    <div className="w-16 h-16 pa-8">
      {children}
    </div>
  </button>
}
