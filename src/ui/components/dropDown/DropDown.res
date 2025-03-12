%%raw("import './index.css'")

@send external focus: Dom.element => unit = "focus"
external toNode: Dom.eventTarget_like<'a> => Dom.node_like<'a> = "%identity"

@react.component
let make = (
  ~selected: DropDownItem.t<'a>,
  ~items: array<DropDownItem.t<'a>>,
  ~label: string,
  ~onChange: DropDownItem.t<'a> => unit,
) => {
  Signal.track()

  let componentRef: React.ref<Nullable.t<Dom.element>> = React.useRef(Nullable.null)
  let isMenuShown = Signal.useSignal(false)

  let inputClass = Signal.useComputed(() => `drop-down__input mt-8 text-body-small ${isMenuShown -> Signal.get ? "drop-down__input_open" : ""} d-flex align-center justify-space-between px-12`)
  let labelClass = Signal.useComputed(() => `drop-down__label pl-4 text-caption no-select ${isMenuShown -> Signal.get ? "text-color-primary" : "text-color-secondary"}`)
  let iconStyle = Signal.useComputed(() => `drop-down__icon cursor-pointer ${isMenuShown -> Signal.get ? "text-color-primary" : "text-color-secondary"}`)

  let switchMenu = () => {
    isMenuShown
      -> Signal.get
      -> Bool.invert
      -> Signal.set(isMenuShown, _)
  }

  let onClick = (value) => {
    onChange(value)
    switchMenu()
  }


  let menu = Signal.useComputed(() => {
    isMenuShown -> Signal.get 
      ? <div className="drop-down__menu-container radius border-input-active w-full"><div className="drop-down__menu">{
        items -> Array.map((item) => 
          <DropDownMenuItem
            key={item.key}
            onClick={onClick}
            selected={item.key == selected.key}
            item={item}
          />)
          -> React.array
      } </div></div>
      : <div />
  })

  React.useEffect0(() => {
    let listener = (e) => {
      switch componentRef.current -> Nullable.toOption {
        | Some(v) => {
          let child = e -> Webapi.Dom.Event.target -> toNode

          if !(v -> Webapi.Dom.Element.contains(~child=child)) {
            isMenuShown -> Signal.set(false)
          }
        }
        | None => ()
      }
    }

    Webapi.Dom.document -> Webapi.Dom.Document.addEventListener("click", listener)

    Some(() => {
      Webapi.Dom.document -> Webapi.Dom.Document.removeEventListener("click", listener)
    })
  })

  <div
    onClick={(_) => switchMenu()}
    ref={ReactDOM.Ref.domRef(componentRef)}
    className="cursor-pointer position-relative"
  >
    <div className={labelClass -> Signal.get}>
      {label -> React.string}
    </div>

    <div className={inputClass -> Signal.get}>
      {selected.text -> React.string}

      <button
        onClick={e => {
          e -> ReactEvent.Mouse.stopPropagation
          switchMenu()
        }}
        className={iconStyle -> Signal.get}
      >
        {isMenuShown -> Signal.get
          ? <Lucide.ChevronUp size={20} />
          : <Lucide.ChevronDown size={20} />
        }
      </button>
    </div>

    {menu -> Signal.get}
  </div>
}
