%%raw("import './index.css'")

@react.component
let make = (
  ~item: DropDownItem.t<'a>,
  ~selected: bool,
  ~onClick: DropDownItem.t<'a> => unit,
) => {
  let style = `drop-down-menu-item text-body-small ${selected ? "bg-primary text-color-primary" : "bg-global text-color-secondary"} h-36 d-flex pl-12 align-center`

  <div
    className={style}
    onClick={e => {
      e -> ReactEvent.Mouse.stopPropagation
      onClick(item)
    }}
  >
    {item.text -> React.string}
  </div>
}
