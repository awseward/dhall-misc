let GHA = ./gha/jobs.dhall

let uses = GHA.Step.uses

let Opts =
      { Type =
          { nimVersion : Text, setupAction : Text, setupActionVersion : Text }
      , default =
        { nimVersion = "1.4.2"
        , setupAction = "jiro4989/setup-nim-action"
        , setupActionVersion = "1.2.3"
        }
      }

let mkSteps =
      λ(opts : Opts.Type) →
          [ (./gha/steps.dhall).checkout
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
              , uses = "${opts.setupAction}@${opts.setupActionVersion}"
              , `with` = Some GHA.With::{
                , nim-version = Some "${opts.nimVersion}"
                }
              }
          ]
        : List GHA.Step

in  { mkSteps, Opts }
