%%raw("import './index.css'")

@react.component
let make = (
  ~children: React.element,
  ~selected: bool,
  ~onClick
) => {
  let buttonStyle = `${selected ? "tab-button_selected" : "tab-button"} text-body`

  <button
    onClick={onClick}
    className={buttonStyle}
  >
    {children}
  </button>
}
