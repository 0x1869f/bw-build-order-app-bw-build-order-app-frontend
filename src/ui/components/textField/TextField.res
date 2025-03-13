%%raw("import './index.css'")

@send external focus: Dom.element => unit = "focus"

@react.component
let make = (
  ~value: string,
  ~label: string,
  ~onChange: string => unit,
  ~placeholder: string="",
  ~icon: React.element=?,
  ~type_: string = "text",
) => {
  let inputRef = React.useRef(Nullable.null)
  let inputClass = `text-field__input ${icon -> Option.isSome ? "pl-8" : "pl-12"} text-body-small radius`

  let setFocus = () => {
    switch inputRef.current -> Nullable.toOption {
      | Some(v) => v -> focus
      | None => ()
    }
  }

  let id = Uuid.make()

  <div className="text-field d-flex gap-8 flex-col">
    <label htmlFor={id} className="text-field__label pl-4 text-caption text-color-secondary no-select cursor-pointer">
      {label -> React.string}
    </label>

    <div className="text-field__container bg-global d-flex radius border-box border">
      {switch icon {
        | Some(v) => <div onClick={(_) => setFocus()} className="pl-12 text-field__icon text-color-secondary cursor-text d-flex align-center">
            {v}
          </div>
        | None => <div />
      }}

      <input
        ref={ReactDOM.Ref.domRef(inputRef)}
        className={inputClass}
        id={id}
        onChange={f => (f -> Form.stringValue).value -> onChange}
        placeholder={placeholder}
        value={value}
        type_={type_}
      />
    </div>
  </div>
}
