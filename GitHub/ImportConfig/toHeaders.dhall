let ImportConfig = ./Type.dhall

let ApiVersion/show = ../ApiVersion/show.dhall

in    λ(conf : ImportConfig.Type)
    → [ { header = "Authorization", value = "token ${conf.token}" }
      , { header = "Accept"
        , value = "application/vnd.github.${ApiVersion/show conf.version}.raw"
        }
      , { header = "User-Agent", value = conf.user-agent }
      ]
