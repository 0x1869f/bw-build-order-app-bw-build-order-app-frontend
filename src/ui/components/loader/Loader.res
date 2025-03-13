%%raw("import './index.css'")

@react.component
let make = () => {
  let num = (Math.random() *. 3.0)
    -> Math.floor
    -> Float.toInt

  let race = [Race.Protoss, Race.Zerg, Race.Terran]
    -> Array.getUnsafe(num)

  <div className="loader">
    <div className={`loader__container loader__container_${race :> string}`}>
    </div>
  </div>
}

