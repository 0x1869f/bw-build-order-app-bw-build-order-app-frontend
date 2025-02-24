%%raw("import './index.css'")

@react.component
let make = (~player: Player.t) => {
  let avatar = switch player.avatar {
    | Some(v) => v
    | None => player.race -> RaceIconStorage.getByRace 
  }

  let buildLink = (href: string, image: string) => {
    <Mui.Link key={image} href={href} target="_blank">
      <Mui.Avatar variant={Rounded} src={image} />
    </Mui.Link>
  }

  let getLinks = () => {
    let links = []

    switch player.soop {
      | Some(value) => {
        let link = buildLink(value, ExternalServiceIcon.getIcon(Soop))
        links -> Array.push(link)
      }
      | None => ()
    }

    switch player.youtube {
      | Some(value) => {
        let link = buildLink(value, ExternalServiceIcon.getIcon(Youtube))
        links -> Array.push(link)
      }
      | None => ()
    }

    switch player.twitch {
      | Some(value) => {
        let link = buildLink(value, ExternalServiceIcon.getIcon(Twitch))
        links -> Array.push(link)
      }
      | None => ()
    }

    switch player.liquipedia {
      | Some(value) => {
        let link = buildLink(value, ExternalServiceIcon.getIcon(Liquipedia))
        links -> Array.push(link)
      }
      | None => ()
    }

    links
  }

  <Mui.Card
    className="player-card"
    elevation={4}
    key={player.id}
  >
    <Mui.CardActionArea>
    <Mui.CardContent
      className="player-card__content"
    >
      <Mui.Avatar
        sx={Mui.Sx.obj({height: Mui.System.Value.Number(68.0), width: Mui.System.Value.Number(68.0)})}
        src={avatar}
      />
      <div>{player.nickname -> React.string}</div>
    </Mui.CardContent>
    </Mui.CardActionArea>

    <Mui.CardActions>
      {getLinks() -> React.array}
    </Mui.CardActions>
  </Mui.Card>
}
