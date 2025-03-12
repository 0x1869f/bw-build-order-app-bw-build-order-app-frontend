%%raw("import './index.css'")

@react.component
let make = (
  ~children: React.element,
  ~onClick: unit => unit,
) => {
  <div
    onClick={(_) => onClick()}
    className="action-card radius bg-primary d-flex justify-space-between cursor-pointer pl-16 py-16"
  >
    <div>
      {children}
    </div>

    <div className="action-card__icon d-flex align-center justify-center text-color-secondary w-48">
      <Lucide.ChevronRight className="w-16 h-16" />
    </div>
  </div>
}
