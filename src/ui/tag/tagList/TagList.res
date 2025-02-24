%%raw("import './index.css'")

@react.component
let make = (
  ~tags: array<Tag.t>,
) => {
  let tagList = tags -> Array.map((tag) => {
    let colorClass = `tag-list__chip_${(tag.race :> string) -> String.toLowerCase}`

    <Mui.Chip
      className={colorClass}
      key={tag.id}
      variant={Filled}
      label={tag.name -> React.string}
    />
  })

  <div className="tag-list">{tagList -> React.array}</div>
}
