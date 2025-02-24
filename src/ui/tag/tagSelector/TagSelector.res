%%raw("import './index.css'")

@react.component
let make = (
  ~tags: array<Tag.t>,
  ~selected: dict<Tag.t>,
  ~onUpdate: (dict<Tag.t>) => unit
) => {
  let add = (tag: Tag.t) => {
    let copy = selected -> Dict.copy
    copy -> Dict.set(tag.id, tag)
    copy -> onUpdate
  }

  let delete = (tag: Tag.t) => {
    let copy = selected -> Dict.copy
    copy -> Dict.delete(tag.id)
    copy -> onUpdate
  }

  let tagList = tags -> Array.map((tag) => {
    let (colorClass, action) = switch selected -> Dict.get(tag.id) {
      | Some(_) => (`tag-selector__chip__${(tag.race :> string) -> String.toLowerCase}_selected`, delete)
      | None => {
        let colorClass = `tag-selector__chip__${(tag.race :> string) -> String.toLowerCase}`
        (colorClass, add)
      }
    }

    <Mui.Chip
      className={colorClass}
      key={tag.id}
      variant={Filled}
      label={tag.name -> React.string}
      onClick={(_) => action(tag)}
    />
  })

  <div className="tag-selector">{tagList -> React.array}</div>
}
