let GHA = ./gha/jobs.dhall

let uses = GHA.Step.uses

let Opts =
      { Type =
          { nimVersion : Text
          , setupNimAction : Text
          , setupNimActionVersion : Text
          }
      , default =
        { nimVersion = "1.4.2"
        , setupNimAction = "jiro4989/setup-nim-action"
        , setupNimActionVersion = "1.2.3"
        }
      }

let mkSteps =
      λ(opts : Opts.Type) →
          [ uses GHA.Uses::{ uses = "actions/checkout@v2" }
          , uses
              GHA.Uses::{
              , name = Some "Cache choosenim"
              , uses = "actions/cache@v1"
              , id = Some "cache-choosenim"
              , `with` = Some GHA.With::{
                , path = Some "~/.choosenim"
                , key = Some "\${{ runner.os }}-choosenim"
                }
              }
          , uses
              GHA.Uses::{
              , name = Some "Cache nimble"
              , uses = "actions/cache@v1"
              , id = Some "cache-nimble"
              , `with` = Some GHA.With::{
                , path = Some "~/.nimble"
                , key = Some "\${{ runner.os }}-nimble"
                }
              }
          , uses
              GHA.Uses::{
              , uses = "${opts.setupNimAction}@${opts.setupNimActionVersion}"
              , `with` = Some GHA.With::{
                , nim-version = Some "${opts.nimVersion}"
                }
              }
          ]
        : List GHA.Step

in  { mkSteps, Opts }
