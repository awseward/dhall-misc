let NA = ../NimAssets.dhall

let NBA = ../NimBuildApp.dhall

let ND = ../NimDocs.dhall

let NimAssets = NA.NimAssets

let NimBuildApp = NBA.NimBuildApp

let NimDocs = ND.NimDocs

in  { name = "CI"
    , on.pull_request.branches = [ "master" ]
    , jobs =
      [ NA.mkJob NimAssets::{ platforms = [ "macos-latest" ] }
      , NBA.mkJob
          NimBuildApp::{
          , platforms = [ "ubuntu-latest" ]
          , bin = "web"
          , nimbleFlags = "--define:release --define:useStdLib"
          }
      , NBA.mkJob
          NimBuildApp::{
          , platforms = [ "macos-latest" ]
          , bin = "call_status_checker"
          , nimbleFlags = "--define:release --define:ssl"
          }
      , ND.mkJob NimDocs::{ platforms = [ "ubuntu-latest" ] }
      ]
    }
