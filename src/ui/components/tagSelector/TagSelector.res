@react.component
let make = (
  ~tags: array<Tag.t>,
  ~selected: dict<Tag.t>,
  ~onUpdate: (dict<Tag.t>) => unit,
  ~smallGap: bool=true,
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
    let (selected, action) = switch selected -> Dict.get(tag.id) {
      | Some(_) => (true, delete)
      | None => (false, add)
    }

    <RaceChip
      race={tag.race}
      selected={selected}
      key={tag.id}
      onClick={() => action(tag)}
    >
      {tag.name ->React.string}
    </RaceChip>
  })

  <div className={`d-flex ${smallGap ? "gap-4" : "gap-8"} flex-wrap`}>
    {tagList -> React.array}
  </div>
}
