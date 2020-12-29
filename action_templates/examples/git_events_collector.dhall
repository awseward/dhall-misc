let import = ../NimBuildApp.dhall

let mkAction = import.mkAction

let NimBuildApp = import.NimBuildApp

in  [ mkAction
        NimBuildApp::{
        , platforms = [ "macos-latest" ]
        , bin = "git_events_collector"
        }
    ]
