let GHA = ./gha/jobs.dhall

let uses = GHA.Step.uses

let Opts =
      { Type =
          { nimVersion : Text, setupAction : Text, setupActionVersion : Text }
      , default =
        { nimVersion = "1.4.2"
        , setupAction = "jiro4989/setup-nim-action"
        , setupActionVersion = "v1.2.3"
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
              , `with` = toMap
                  { path = "~/.choosenim", key = "\${{ runner.os }}-choosenim" }
              }
          , uses
              GHA.Uses::{
              , name = Some "Cache nimble"
              , uses = "actions/cache@v1"
              , id = Some "cache-nimble"
              , `with` = toMap
                  { path = "~/.nimble", key = "\${{ runner.os }}-nimble" }
              }
          , uses
              GHA.Uses::{
              , uses = "${opts.setupAction}@${opts.setupActionVersion}"
              , `with` = toMap { nim-version = "${opts.nimVersion}" }
              }
          ]
        : List GHA.Step

in  { mkSteps, Opts }
