let NBA = ../NimBuildApp.dhall

let mkJob = NBA.mkJob

let NimBuildApp = NBA.NimBuildApp

in  { name = "CI"
    , on = [ "push" ]
    , jobs =
      [ mkJob
          NimBuildApp::{
          , platforms = [ "macos-latest" ]
          , bin = "git_events_collector"
          }
      ]
    }
