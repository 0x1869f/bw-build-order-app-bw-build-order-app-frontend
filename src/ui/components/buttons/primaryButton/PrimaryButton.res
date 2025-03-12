%%raw("import './index.css'")

@react.component
let make = (
  ~children: React.element,
  ~disabled: bool = false,
  ~onClick
) => {
  <div className="primary-button text-button">
    <button disabled={disabled} onClick={onClick} className="primary-button__button">
      children
    </button>
  </div>
}
