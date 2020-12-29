let concat = (./imports.dhall).concat

let GHA = ./gha/jobs.dhall

let NimSetup = ./NimSetup.dhall

let run = GHA.Step.run

let NimAssets =
      { Type =
          { platforms : List Text
          , nimSetup : NimSetup.Opts.Type
          , nimbleFlags : Text
          }
      , default = { nimSetup = NimSetup.Opts::{=}, nimbleFlags = "" }
      }

let mkJob =
      λ(opts : NimAssets.Type) →
        { mapKey = "check-assets"
        , mapValue =
          { runs-on = opts.platforms
          , steps =
              concat
                GHA.Step
                [ NimSetup.mkSteps opts.nimSetup
                , [ run GHA.Run::{ run = "nimble install --accept nimassets" }
                  , run GHA.Run::{ run = "nimble ${opts.nimbleFlags} assets" }
                  , run GHA.Run::{ run = "git diff --exit-code --color" }
                  ]
                ]
          }
        }

in  { mkJob, NimAssets }
