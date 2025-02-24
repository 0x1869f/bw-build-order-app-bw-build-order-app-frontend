%%raw("import './index.css'")

@send external clickInput: Dom.element => unit = "click"

@react.component
let make = (
  ~accept: string,
  ~onFileChange: FileForm.form => unit,
  ~text: option<string>=?,
) => {
  Signal.track()

  let inputRef = React.useRef(Nullable.null)
  let isSelected = Signal.useSignal(false)

  let onInputClick = () => {
    switch inputRef.current -> Nullable.toOption {
      | Some(element) => element -> clickInput
      | None => ()
    }
  }

  let updateFile = (e) => {
    e
      -> FileForm.get
      -> onFileChange
    isSelected -> Signal.set(true)
  }

  let content = Signal.computed(() => {
    switch text {
      | Some(value) => <div className="file-input__button-content">
        {value -> React.string}
        <Lucide.FileUp />
      </div>
      | None => <div className="file-input__button-content">
        <Lucide.FileUp />
      </div>
    }
  })

  <div className="file-input">
    <Mui.Button
      variant={Outlined}
      onClick={(_) => onInputClick()}
    >
      <div className="file-input__button-content">
        {content -> Signal.get}
      </div>

      <input
        onChange={updateFile}
        ref={ReactDOM.Ref.domRef(inputRef)}
        type_="file"
        accept={accept}
        hidden={true}
      />
    </Mui.Button>

    {
      isSelected -> Signal.get
        ? <Lucide.Check color="green" />
        : <div />
    }
  </div>
}
