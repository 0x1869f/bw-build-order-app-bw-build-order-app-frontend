@react.component
let make = () => {
  <div className="footer py-24 px-16 text-color-secondary text-caption border-top d-flex flex-col gap-8 bg-global">
    <p>{"Copyright © 2025 — All right reserved." -> React.string}</p>
    <p>
      {"This site is not affiliated with, endorsed, sponsored, or specifically approved by Blizzard Entertainment,
      Inc., and Blizzard Entertainment, Inc. is not responsible for it. 
      Images from StarCraft are © Blizzard Entertainment, Inc. StarCraft,
      Brood War and Blizzard Entertainment are trademarks or registered trademarks of Blizzard Entertainment,
      Inc. in the U.S. and/or other countries." -> React.string}
    </p>
  </div>
}
