let concat = (./imports.dhall).concat

let GHA = ./gha/jobs.dhall

let NimSetup = ./NimSetup.dhall

let run = GHA.Step.run

let Opts =
      { Type =
          { platforms : List Text
          , nimSetup : NimSetup.Opts.Type
          , nimbleFlags : Text
          }
      , default = { nimSetup = NimSetup.Opts::{=}, nimbleFlags = "" }
      }

let mkJob =
      λ(opts : Opts.Type) →
        { mapKey = "docs"
        , mapValue =
          { runs-on = opts.platforms
          , steps =
              concat
                GHA.Step
                [ NimSetup.mkSteps opts.nimSetup
                , [ run
                      GHA.Run::{
                      , run = "nimble ${opts.nimbleFlags} install --accept"
                      }
                  , run GHA.Run::{ run = "nimble docs" }
                  ]
                ]
          }
        }

in  { mkJob, Opts }
