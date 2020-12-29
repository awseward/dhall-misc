let import = ../NimBuildApp.dhall

let mkAction = import.mkAction

let NimBuildApp = import.NimBuildApp

in  [ mkAction
        NimBuildApp::{
        , platforms = [ "ubuntu-latest" ]
        , bin = "web"
        , nimbleBuildFlags = "--define:release --define:useStdLib"
        }
    , mkAction
        NimBuildApp::{
        , platforms = [ "macos-latest" ]
        , bin = "call_status_checker"
        , nimbleBuildFlags = "--define:release --define:ssl"
        }
    ]
