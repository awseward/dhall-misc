let GHA = ../gha/jobs.dhall

let Build = ../NimBuild.dhall

let uses = GHA.Step.uses

in  { name = "CI"
    , on = [ "push" ]
    , jobs =
      [ Build.mkJob
          Build.Opts::{
          , platforms = [ "macos-latest" ]
          , bin = "git_events_collector"
          }
      , { mapKey = "check-shell"
        , mapValue =
          { runs-on = [ "ubuntu-latest" ]
          , steps =
            [ (../gha/steps.dhall).checkout
            , uses GHA.Uses::{ uses = "awseward/gh-actions-shell@0.1.0" }
            ]
          }
        }
      ]
    }
