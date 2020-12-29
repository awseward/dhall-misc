let concat = (./imports.dhall).concat

let GHA = ./gha/jobs.dhall

let NimSetup = ./NimSetup.dhall

let run = GHA.Step.run

let NimBuildApp =
      { Type =
          { platforms : List Text
          , bin : Text
          , nimSetup : NimSetup.Opts.Type
          , nimbleFlags : Text
          }
      , default = { nimSetup = NimSetup.Opts::{=}, nimbleFlags = "" }
      }

let mkJob =
      λ(opts : NimBuildApp.Type) →
        { mapKey = "build-${opts.bin}"
        , mapValue =
          { runs-on = opts.platforms
          , steps =
              concat
                GHA.Step
                [ NimSetup.mkSteps opts.nimSetup
                , [ run
                      GHA.Run::{
                      , run =
                          "nimble --stacktrace:on --linetrace:on ${opts.nimbleFlags} build --accept ${opts.bin}"
                      }
                  ]
                ]
          }
        }

in  { mkJob, NimBuildApp }
