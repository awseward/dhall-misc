let Assets = ../NimAssets.dhall

let Build = ../NimBuild.dhall

let Docs = ../NimDocs.dhall

in  { name = "CI"
    , on.pull_request.branches = [ "master" ]
    , jobs =
      [ Assets.mkJob Assets.Opts::{ platforms = [ "macos-latest" ] }
      , Build.mkJob
          Build.Opts::{
          , platforms = [ "ubuntu-latest" ]
          , bin = "web"
          , nimbleFlags = "--define:release --define:useStdLib"
          }
      , Build.mkJob
          Build.Opts::{
          , platforms = [ "macos-latest" ]
          , bin = "call_status_checker"
          , nimbleFlags = "--define:release --define:ssl"
          }
      , Docs.mkJob Docs.Opts::{ platforms = [ "ubuntu-latest" ] }
      ]
    }
